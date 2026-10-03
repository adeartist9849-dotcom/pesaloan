import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { prisma } from '../../database/client.js';
import { mpesaService } from './providers/mpesa.service.js';
import { sendLoanNotification } from '../notifications/providers/notification.service.js';
import { createAuditLog } from '../../common/utils/audit.js';

const stkCallbackSchema = z.object({
  Body: z.object({
    stkCallback: z.object({
      MerchantRequestID: z.string(),
      CheckoutRequestID: z.string(),
      ResultCode: z.number(),
      ResultDesc: z.string(),
      CallbackMetadata: z.object({
        Item: z.array(z.object({
          Name: z.string(),
          Value: z.union([z.string(), z.number()]),
        })).optional(),
      }).optional(),
    }),
  }),
});

const b2cCallbackSchema = z.object({
  Result: z.object({
    ConversationID: z.string(),
    OriginatorConversationID: z.string(),
    ResultCode: z.number(),
    ResultDesc: z.string(),
    ResultParameters: z.object({
      ResultParameter: z.array(z.object({
        Key: z.string(),
        Value: z.union([z.string(), z.number()]),
      })),
    }).optional(),
  }),
});

export const mobileMoneyRoutes: FastifyPluginAsyncZod = async (app) => {
  // M-Pesa STK Push Callback
  app.post('/mpesa/callback', {
    schema: { body: stkCallbackSchema, tags: ['Mobile Money'] },
  }, async (request, reply) => {
    const callback = request.body.Body.stkCallback;
    
    console.log('M-Pesa STK Callback:', JSON.stringify(callback, null, 2));

    const verification = mpesaService.verifyCallback(request.body as any);
    
    if (!verification.success) {
      console.log('STK Push failed:', callback.ResultDesc);
      
      // Find and update repayment/transaction
      const repayment = await prisma.repayment.findFirst({
        where: { providerTransactionId: callback.CheckoutRequestID },
      });

      if (repayment) {
        await prisma.repayment.update({
          where: { id: repayment.id },
          data: { status: 'FAILED', failedReason: callback.ResultDesc },
        });

        await prisma.transaction.updateMany({
          where: { providerReference: callback.CheckoutRequestID },
          data: { status: 'FAILED' },
        });

        await createAuditLog({
          userId: repayment.userId,
          action: 'LOAN_REPAYMENT_FAILED',
          entityType: 'Repayment',
          entityId: repayment.id,
          newValues: { status: 'FAILED', reason: callback.ResultDesc },
          metadata: { checkoutRequestId: callback.CheckoutRequestID },
        });
      }

      return { ResultCode: 0, ResultDesc: 'Callback processed' };
    }

    // Success - update repayment
    const repayment = await prisma.repayment.findFirst({
      where: { providerTransactionId: callback.CheckoutRequestID },
    });

    if (repayment) {
      await prisma.repayment.update({
        where: { id: repayment.id },
        data: {
          status: 'COMPLETED',
          paidAt: new Date(),
          providerTransactionId: verification.transactionId,
        },
      });

      await prisma.transaction.updateMany({
        where: { providerReference: callback.CheckoutRequestID },
        data: {
          status: 'COMPLETED',
          processedAt: new Date(),
          providerReference: verification.transactionId,
        },
      });

      // Update loan outstanding balance
      const loan = await prisma.loan.findUnique({ where: { id: repayment.loanId } });
      if (loan) {
        const newBalance = loan.outstandingBalance - verification.amount!;
        const newStatus = newBalance <= 0 ? 'PAID' : loan.status;

        await prisma.loan.update({
          where: { id: loan.id },
          data: {
            outstandingBalance: Math.max(0, newBalance),
            status: newStatus,
            paidAt: newBalance <= 0 ? new Date() : null,
          },
        });

        // Update loan limit based on repayment
        // await creditEngine.updateLoanLimit(repayment.userId, true);

        // Send notification
        await sendLoanNotification(repayment.userId, 'PAYMENT_RECEIVED', {
          amount: verification.amount,
          balance: Math.max(0, newBalance),
          reference: verification.transactionId,
        });

        // If fully paid
        if (newBalance <= 0) {
          await sendLoanNotification(repayment.userId, 'LOAN_FULLY_REPAID', {});
          
          await createAuditLog({
            userId: repayment.userId,
            action: 'LOAN_SETTLED',
            entityType: 'Loan',
            entityId: loan.id,
            newValues: { status: 'PAID', paidAt: new Date() },
          });
        } else {
          await createAuditLog({
            userId: repayment.userId,
            action: 'LOAN_REPAYMENT_COMPLETED',
            entityType: 'Repayment',
            entityId: repayment.id,
            newValues: { amount: verification.amount, newBalance, status: 'COMPLETED' },
          });
        }
      }
    }

    return { ResultCode: 0, ResultDesc: 'Callback processed successfully' };
  });

  // M-Pesa B2C Callback (Disbursement)
  app.post('/mpesa/b2c/callback', {
    schema: { body: b2cCallbackSchema, tags: ['Mobile Money'] },
  }, async (request, reply) => {
    const callback = request.body.Result;
    
    console.log('M-Pesa B2C Callback:', JSON.stringify(callback, null, 2));

    const conversationId = callback.ConversationID;
    const isSuccess = callback.ResultCode === 0;

    // Find transaction by conversation ID
    const transaction = await prisma.transaction.findFirst({
      where: { providerReference: conversationId, type: 'DISBURSEMENT' },
    });

    if (!transaction || !transaction.loanId) {
      console.log('Transaction or loanId not found for conversation:', conversationId);
      return { ResultCode: 0, ResultDesc: 'Callback processed' };
    }

    const loan = await prisma.loan.findUnique({ where: { id: transaction.loanId } });
    const userId = transaction.userId;

    if (isSuccess) {
      // Extract transaction ID from result parameters
      let transactionId = '';
      if (callback.ResultParameters?.ResultParameter) {
        const param = callback.ResultParameters.ResultParameter.find(p => p.Key === 'TransactionID');
        if (param) transactionId = param.Value as string;
      }

      await prisma.transaction.update({
        where: { id: transaction.id },
        data: {
          status: 'COMPLETED',
          processedAt: new Date(),
          providerReference: transactionId,
        },
      });

      await prisma.loan.update({
        where: { id: transaction.loanId },
        data: {
          status: 'ACTIVE',
          disbursedAmount: transaction.amount,
          disbursedAt: new Date(),
        },
      });

      await sendLoanNotification(userId, 'LOAN_DISBURSED', {
        amount: transaction.amount,
        reference: transactionId,
      });

      await createAuditLog({
        userId,
        action: 'LOAN_DISBURSED',
        entityType: 'Loan',
        entityId: loan?.id || '',
        newValues: { status: 'ACTIVE', disbursedAmount: transaction.amount, transactionId },
      });

    } else {
      await prisma.transaction.update({
        where: { id: transaction.id },
        data: {
          status: 'FAILED',
          description: `Disbursement failed: ${callback.ResultDesc}`,
        },
      });

      // Revert loan to accepted status for retry
      if (loan) {
        await prisma.loan.update({
          where: { id: loan.id },
          data: { status: 'ACCEPTED' },
        });
      }

      await createAuditLog({
        userId,
        action: 'LOAN_REPAYMENT_FAILED',
        entityType: 'Transaction',
        entityId: transaction.id,
        newValues: { status: 'FAILED', reason: callback.ResultDesc },
      });
    }

    return { ResultCode: 0, ResultDesc: 'Callback processed' };
  });

  // M-Pesa B2C Timeout Callback
  app.post('/mpesa/b2c/timeout', {
    schema: { body: z.any(), tags: ['Mobile Money'] },
  }, async (request, reply) => {
    console.log('M-Pesa B2C Timeout:', JSON.stringify(request.body, null, 2));
    
    // Handle timeout - mark transaction as failed, allow retry
    // Similar to failed callback
    
    return { ResultCode: 0, ResultDesc: 'Timeout processed' };
  });

  // M-Pesa B2C Result Callback (alternative endpoint)
  app.post('/mpesa/b2c/result', {
    schema: { body: z.any(), tags: ['Mobile Money'] },
  }, async (request, reply) => {
    console.log('M-Pesa B2C Result:', JSON.stringify(request.body, null, 2));
    return { ResultCode: 0, ResultDesc: 'Result processed' };
  });

  // Get M-Pesa access token (for testing)
  app.get('/mpesa/token', {
    schema: { tags: ['Mobile Money'] },
  }, async (request, reply) => {
    try {
      const token = await (mpesaService as any).getAccessToken();
      return { access_token: token };
    } catch (error) {
      return reply.status(500).send({ code: 'SERVICE_UNAVAILABLE', message: 'Failed to get M-Pesa token' });
    }
  });

  // Test STK Push
  app.post('/mpesa/stk/test', {
    schema: { 
      body: z.object({ phoneNumber: z.string(), amount: z.number().default(1) }),
      tags: ['Mobile Money'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const { phoneNumber, amount } = request.body;
    
    try {
      const response = await mpesaService.stkPush({
        phoneNumber,
        amount,
        accountReference: 'TEST',
        transactionDesc: 'Test STK Push',
        callbackUrl: `${process.env.MPESA_CALLBACK_URL}`,
      });
      return response;
    } catch (error: any) {
      return reply.status(500).send({ code: 'SERVICE_UNAVAILABLE', message: error.message });
    }
  });

  // Registration Fee Payment Callback
  app.post('/registration-fee/callback', {
    schema: { body: stkCallbackSchema, tags: ['Mobile Money'] },
  }, async (request, reply) => {
    const callback = request.body.Body.stkCallback;
    
    console.log('Registration Fee STK Callback:', JSON.stringify(callback, null, 2));
    
    const checkoutRequestId = callback.CheckoutRequestID;
    
    // Find payment by checkout request ID
    const payment = await prisma.registrationFeePayment.findFirst({
      where: { metadata: { path: ['checkoutRequestId'], equals: checkoutRequestId } },
    });
    
    if (!payment) {
      console.log('Registration fee payment not found for checkoutRequestId:', checkoutRequestId);
      return { ResultCode: 0, ResultDesc: 'Callback processed' };
    }
    
    const user = await prisma.user.findUnique({ where: { id: payment.userId } });
    
    const isSuccess = callback.ResultCode === 0;
    
    if (isSuccess) {
      // Extract transaction ID and amount from callback metadata
      let transactionId = '';
      let amount = payment.amount;
      
      if (callback.CallbackMetadata?.Item) {
        for (const item of callback.CallbackMetadata.Item) {
          if (item.Name === 'MpesaReceiptNumber') {
            transactionId = item.Value as string;
          } else if (item.Name === 'Amount') {
            amount = Number(item.Value);
          }
        }
      }
      
      await prisma.registrationFeePayment.update({
        where: { id: payment.id },
        data: {
          status: 'COMPLETED',
          processedAt: new Date(),
          providerReference: transactionId,
          metadata: {
            ...(payment.metadata as Record<string, any>),
            transactionId,
            callbackAmount: amount,
          },
        },
      });
      
      // Update user
      await prisma.user.update({
        where: { id: user!.id },
        data: {
          registrationFeePaid: true,
          registrationFeePaidAt: new Date(),
          status: 'ACTIVE', // Also activate user after fee payment
        },
      });
      
      // Send notification
      await sendLoanNotification(user!.id, 'GENERAL', {
        title: 'Registration Fee Paid',
        message: `Your registration fee of KES ${(amount / 100).toFixed(2)} has been received. You can now log in.`,
      });
      
      await createAuditLog({
        userId: user!.id,
        action: 'USER_REGISTERED',
        entityType: 'RegistrationFeePayment',
        entityId: payment.id,
        newValues: { status: 'COMPLETED', amount, transactionId },
        metadata: { checkoutRequestId },
      });
      
    } else {
      await prisma.registrationFeePayment.update({
        where: { id: payment.id },
        data: {
          status: 'FAILED',
          metadata: {
            ...(payment.metadata as Record<string, any>),
            failureReason: callback.ResultDesc,
          },
        },
      });
      
      await createAuditLog({
        userId: user!.id,
        action: 'LOAN_REPAYMENT_FAILED',
        entityType: 'RegistrationFeePayment',
        entityId: payment.id,
        newValues: { status: 'FAILED', reason: callback.ResultDesc },
        metadata: { checkoutRequestId },
      });
    }
    
    return { ResultCode: 0, ResultDesc: 'Callback processed' };
  });
};