import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { prisma } from '../../database/client.js';
import { creditEngine } from './services/credit-engine.js';
import { createAuditLog } from '../../common/utils/audit.js';
import { mpesaService } from '../mobile-money/providers/mpesa.service.js';
import { sendLoanNotification } from '../notifications/providers/notification.service.js';

const applyLoanSchema = z.object({
  amount: z.number().int().positive().max(50000),
  termDays: z.number().int().positive().max(90),
});

const acceptLoanSchema = z.object({
  loanId: z.string().cuid(),
  agreementVersion: z.string().min(1),
});

const repayLoanSchema = z.object({
  loanId: z.string().cuid(),
  amount: z.number().int().positive(),
});

export const loansRoutes: FastifyPluginAsyncZod = async (app) => {
  // Apply for loan
  app.post('/apply', {
    schema: { body: applyLoanSchema, tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { amount, termDays } = request.body;

    // Get user with loan limit
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, loanLimit: true, kycStatus: true, status: true },
    });

    if (!user || user.status !== 'ACTIVE') {
      return reply.status(403).send({ code: 'ACCOUNT_SUSPENDED', message: 'Account not active' });
    }

    // Check for existing active loan
    const activeLoan = await prisma.loan.findFirst({
      where: { userId, status: { in: ['ACTIVE', 'DISBURSEMENT_PENDING', 'OVERDUE'] } },
    });

    if (activeLoan) {
      return reply.status(409).send({ code: 'LOAN_ACTIVE_EXISTS', message: 'Active loan exists' });
    }

    // Evaluate credit
    const previousLoans = await prisma.loan.findMany({ where: { userId } });
    const repaidOnTime = previousLoans.filter(l => l.status === 'PAID').length;
    const defaulted = previousLoans.filter(l => l.status === 'DEFAULTED').length;
    const lastLoan = previousLoans[0];
    const daysSinceLastLoan = lastLoan ? Math.floor((Date.now() - lastLoan.createdAt.getTime()) / (1000 * 60 * 60 * 24)) : 999;

    const creditInput = {
      userId,
      requestedAmount: amount,
      requestedTermDays: termDays,
      kycStatus: user.kycStatus,
      hasActiveLoan: false,
      previousLoansCount: previousLoans.length,
      repaidOnTimeCount: repaidOnTime,
      defaultedCount: defaulted,
      daysSinceLastLoan,
    };

    const decision = await creditEngine.evaluate(creditInput);

    if (!decision.approved) {
      const application = await prisma.loanApplication.create({
        data: {
          userId,
          requestedAmount: amount,
          requestedTermDays: termDays,
          status: 'DECLINED',
          score: decision.score,
          decisionReason: decision.reason,
          expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
        },
      });

      await createAuditLog({
        userId,
        action: 'LOAN_APPLICATION_DECLINED',
        entityType: 'LoanApplication',
        entityId: application.id,
        newValues: { requestedAmount: amount, requestedTermDays: termDays, score: decision.score, reason: decision.reason },
        ipAddress: request.ip,
        userAgent: request.headers['user-agent'],
      });

      return reply.status(400).send({
        code: 'LOAN_NOT_ELIGIBLE',
        message: decision.reason || 'Not eligible for loan',
        score: decision.score,
        maxAmount: decision.maxAmount,
      });
    }

    // Create approved application
    const application = await prisma.loanApplication.create({
      data: {
        userId,
        requestedAmount: amount,
        requestedTermDays: termDays,
        status: 'APPROVED',
        score: decision.score,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
      },
    });

    // Calculate pricing
    const pricing = await creditEngine.calculateLoanPricing(amount, termDays);

    // Create loan record (pending acceptance)
    const loan = await prisma.loan.create({
      data: {
        userId,
        applicationId: application.id,
        principal: amount,
        interest: pricing.interest,
        fees: pricing.fees,
        totalPayable: pricing.totalPayable,
        termDays,
        outstandingBalance: pricing.totalPayable,
        status: 'APPROVED',
        dueDate: new Date(Date.now() + termDays * 24 * 60 * 60 * 1000),
        agreementVersion: '1.0',
      },
    });

    await createAuditLog({
      userId,
      action: 'LOAN_APPLICATION_APPROVED',
      entityType: 'LoanApplication',
      entityId: application.id,
      newValues: { loanId: loan.id, amount, termDays, score: decision.score, totalPayable: pricing.totalPayable },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    // Send notification
    await sendLoanNotification(userId, 'APPLICATION_APPROVED', { amount, loanId: loan.id });

    return {
      loanId: loan.id,
      amount: loan.principal,
      termDays: loan.termDays,
      interest: loan.interest,
      fees: loan.fees,
      totalPayable: loan.totalPayable,
      dueDate: loan.dueDate.toISOString(),
      agreementVersion: loan.agreementVersion,
      agreementUrl: `${process.env.APP_URL}/loan-agreement/${loan.agreementVersion}`,
      expiresAt: application.expiresAt.toISOString(),
    };
  });

  // Get loan offer
  app.get('/offer/:id', {
    schema: { params: z.object({ id: z.string().cuid() }), tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { id } = request.params;

    const loan = await prisma.loan.findFirst({
      where: { id, userId },
      include: { application: true },
    });

    if (!loan || loan.status !== 'APPROVED') {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan offer not found or expired' });
    }

    if (loan.application.expiresAt < new Date()) {
      await prisma.loanApplication.update({ where: { id: loan.applicationId }, data: { status: 'EXPIRED' } });
      await prisma.loan.update({ where: { id }, data: { status: 'APPLICATION' } });
      return reply.status(410).send({ code: 'LOAN_OFFER_EXPIRED', message: 'Loan offer has expired' });
    }

    return {
      loanId: loan.id,
      amount: loan.principal,
      termDays: loan.termDays,
      interest: loan.interest,
      fees: loan.fees,
      totalPayable: loan.totalPayable,
      dueDate: loan.dueDate.toISOString(),
      agreementVersion: loan.agreementVersion,
      agreementUrl: `${process.env.APP_URL}/loan-agreement/${loan.agreementVersion}`,
      expiresAt: loan.application.expiresAt.toISOString(),
    };
  });

  // Accept loan offer
  app.post('/accept', {
    schema: { body: acceptLoanSchema, tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { loanId, agreementVersion } = request.body;

    const loan = await prisma.loan.findFirst({
      where: { id: loanId, userId },
      include: { application: true },
    });

    if (!loan) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });
    }

    if (loan.status !== 'APPROVED' && loan.status !== 'ACCEPTED') {
      return reply.status(400).send({ code: 'LOAN_ALREADY_ACCEPTED', message: 'Loan cannot be accepted' });
    }

    if (loan.application.expiresAt < new Date()) {
      return reply.status(410).send({ code: 'LOAN_OFFER_EXPIRED', message: 'Loan offer has expired' });
    }

    if (agreementVersion !== loan.agreementVersion) {
      return reply.status(400).send({ code: 'VALIDATION_ERROR', message: 'Invalid agreement version' });
    }

    // Update loan status
    const updatedLoan = await prisma.loan.update({
      where: { id: loanId },
      data: {
        status: 'ACCEPTED',
        agreementAcceptedAt: new Date(),
      },
    });

    // Initiate disbursement
    await prisma.loan.update({ where: { id: loanId }, data: { status: 'DISBURSEMENT_PENDING' } });

    try {
      // Call M-Pesa B2C for disbursement
      const disbursement = await mpesaService.b2cPayment({
        phoneNumber: (await prisma.user.findUnique({ where: { id: userId } }))?.phoneNumber || '',
        amount: loan.principal,
        remarks: `Loan disbursement ${loanId}`,
        occasion: 'Loan disbursement',
      });

      await prisma.transaction.create({
        data: {
          loanId,
          userId,
          type: 'DISBURSEMENT',
          amount: loan.principal,
          status: 'PROCESSING',
          reference: `DISB-${Date.now()}`,
          provider: 'MPESA',
          providerReference: disbursement.ConversationID,
          description: 'Loan disbursement via M-Pesa B2C',
          metadata: { conversationId: disbursement.ConversationID },
        },
      });

      await createAuditLog({
        userId,
        action: 'LOAN_OFFER_ACCEPTED',
        entityType: 'Loan',
        entityId: loanId,
        newValues: { status: 'DISBURSEMENT_PENDING', disbursementRef: disbursement.ConversationID },
        ipAddress: request.ip,
        userAgent: request.headers['user-agent'],
      });

    } catch (error) {
      console.error('Disbursement failed:', error);
      // Don't fail the acceptance - disbursement will be retried
    }

    return { message: 'Loan accepted. Disbursement initiated.', loanId };
  });

  // Get dashboard data
  app.get('/dashboard', {
    schema: { tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;

    const [user, activeLoan, recentLoans, availableLimit] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId }, select: { id: true, fullName: true, loanLimit: true, kycStatus: true } }),
      prisma.loan.findFirst({
        where: { userId, status: { in: ['ACTIVE', 'DISBURSEMENT_PENDING', 'OVERDUE'] } },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.loan.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
        take: 5,
      }),
      prisma.user.findUnique({ where: { id: userId }, select: { loanLimit: true } }),
    ]);

    const activeLoanData = activeLoan ? {
      id: activeLoan.id,
      outstandingBalance: activeLoan.outstandingBalance,
      dueDate: activeLoan.dueDate.toISOString(),
      status: activeLoan.status,
    } : null;

    const recentLoansData = recentLoans.map(l => ({
      id: l.id,
      amount: l.principal,
      status: l.status,
      dueDate: l.dueDate.toISOString(),
    }));

    return {
      user: {
        id: user?.id,
        fullName: user?.fullName,
        loanLimit: user?.loanLimit,
        kycStatus: user?.kycStatus,
      },
      availableLimit: user?.loanLimit || 0,
      currentLoan: activeLoanData,
      recentLoans: recentLoansData,
    };
  });

  // Get loan history
  app.get('/history', {
    schema: { 
      querystring: z.object({ page: z.coerce.number().default(1), limit: z.coerce.number().default(20) }),
      tags: ['Loans'], 
      security: [{ bearerAuth: [] }] 
    },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { page = 1, limit = 20 } = request.query;

    const [loans, total] = await Promise.all([
      prisma.loan.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      prisma.loan.count({ where: { userId } }),
    ]);

    return {
      data: loans.map(l => ({
        id: l.id,
        amount: l.principal,
        status: l.status,
        dueDate: l.dueDate.toISOString(),
        disbursedAt: l.disbursedAt?.toISOString(),
        paidAt: l.paidAt?.toISOString(),
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  });

  // Get loan detail
  app.get('/:id', {
    schema: { params: z.object({ id: z.string().cuid() }), tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { id } = request.params;

    const loan = await prisma.loan.findFirst({
      where: { id, userId },
      include: {
        application: true,
        repayments: { orderBy: { createdAt: 'desc' } },
        transactions: { orderBy: { createdAt: 'desc' } },
      },
    });

    if (!loan) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });
    }

    return {
      ...loan,
      application: loan.application,
      repayments: loan.repayments,
      transactions: loan.transactions,
    };
  });

  // Get repayment detail
  app.get('/repay/:id', {
    schema: { params: z.object({ id: z.string().cuid() }), tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { id } = request.params;

    const loan = await prisma.loan.findFirst({
      where: { id, userId },
      select: { id: true, outstandingBalance: true, dueDate: true, status: true, principal: true, interest: true, fees: true, totalPayable: true },
    });

    if (!loan) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });
    }

    return {
      loanId: loan.id,
      outstandingBalance: loan.outstandingBalance,
      dueDate: loan.dueDate.toISOString(),
      status: loan.status,
      principal: loan.principal,
      interest: loan.interest,
      fees: loan.fees,
      totalPayable: loan.totalPayable,
    };
  });

  // Initiate repayment
  app.post('/repay', {
    schema: { body: repayLoanSchema, tags: ['Loans'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { loanId, amount } = request.body;

    const loan = await prisma.loan.findFirst({
      where: { id: loanId, userId },
    });

    if (!loan) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });
    }

    if (loan.status !== 'ACTIVE' && loan.status !== 'OVERDUE') {
      return reply.status(400).send({ code: 'LOAN_NOT_ACTIVE', message: 'Loan is not active' });
    }

    if (amount > loan.outstandingBalance) {
      return reply.status(400).send({ code: 'REPAYMENT_AMOUNT_INVALID', message: 'Amount exceeds outstanding balance' });
    }

    // Create repayment record
    const repayment = await prisma.repayment.create({
      data: {
        loanId,
        userId,
        amount,
        transactionReference: `REPAY-${Date.now()}`,
        provider: 'MPESA',
        status: 'PROCESSING',
        metadata: {},
      },
    });

    // Create transaction record
    await prisma.transaction.create({
      data: {
        loanId,
        userId,
        type: 'REPAYMENT',
        amount,
        status: 'PROCESSING',
        reference: repayment.transactionReference,
        provider: 'MPESA',
        description: 'Loan repayment via M-Pesa STK Push',
        metadata: { repaymentId: repayment.id },
      },
    });

    // Initiate M-Pesa STK Push
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (user) {
      try {
        const stkPush = await mpesaService.stkPush({
          phoneNumber: user.phoneNumber,
          amount,
          accountReference: loanId,
          transactionDesc: `Loan repayment ${loanId}`,
          callbackUrl: `${process.env.MPESA_CALLBACK_URL}`,
        });

        await prisma.repayment.update({
          where: { id: repayment.id },
          data: { providerTransactionId: stkPush.CheckoutRequestID },
        });

        await prisma.transaction.update({
          where: { reference: repayment.transactionReference },
          data: { providerReference: stkPush.CheckoutRequestID },
        });

      } catch (error) {
        console.error('STK Push failed:', error);
        await prisma.repayment.update({ where: { id: repayment.id }, data: { status: 'FAILED', failedReason: 'STK Push failed' } });
        return reply.status(500).send({ code: 'REPAYMENT_FAILED', message: 'Failed to initiate payment' });
      }
    }

    await createAuditLog({
      userId,
      action: 'LOAN_REPAYMENT_INITIATED',
      entityType: 'Repayment',
      entityId: repayment.id,
      newValues: { loanId, amount, status: 'PROCESSING' },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { transactionId: repayment.id, status: 'PROCESSING', message: 'Repayment initiated. Complete on your phone.' };
  });
};