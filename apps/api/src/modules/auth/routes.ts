import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { config } from '../../config/index.js';
import { prisma } from '../../database/client.js';
import { hashPin, verifyPin, generateToken, generateRefreshToken, hashToken } from '../../common/utils/crypto.js';
import { createAuditLog } from '../../common/utils/audit.js';
import { sendOtp } from '../../modules/notifications/providers/notification.service.js';
import { mpesaService } from '../mobile-money/providers/mpesa.service.js';

const registerSchema = z.object({
  phoneNumber: z.string().regex(/^254[17]\d{8}$/),
  fullName: z.string().min(2).max(100),
  dateOfBirth: z.string().datetime(),
  nationalId: z.string().regex(/^\d{8}$/),
  email: z.string().email().optional().nullable(),
  pin: z.string().regex(/^\d{4,6}$/),
  consentGiven: z.literal(true),
  consentVersion: z.string().min(1),
});

const stkPushSchema = z.object({
  phoneNumber: z.string().regex(/^254[17]\d{8}$/),
});

const loginSchema = z.object({
  phoneNumber: z.string().regex(/^254[17]\d{8}$/),
  pin: z.string().regex(/^\d{4,6}$/),
});

const otpRequestSchema = z.object({
  phoneNumber: z.string().regex(/^254[17]\d{8}$/),
});

const otpVerifySchema = z.object({
  phoneNumber: z.string().regex(/^254[17]\d{8}$/),
  code: z.string().regex(/^\d{6}$/),
});

const createPinSchema = z.object({
  pin: z.string().regex(/^\d{4,6}$/),
});

export const authRoutes: FastifyPluginAsyncZod = async (app) => {
  // Register
  app.post('/register', {
    schema: { body: registerSchema, tags: ['Auth'] },
  }, async (request, reply) => {
    const { phoneNumber, fullName, dateOfBirth, nationalId, email, pin, consentGiven, consentVersion } = request.body;
    
    // Check if user exists
    const existingUser = await prisma.user.findFirst({
      where: { OR: [{ phoneNumber }, { nationalId }] },
    });
    
    if (existingUser) {
      return reply.status(409).send({ code: 'CONFLICT', message: 'User with this phone number or ID already exists' });
    }
    
    // Hash PIN
    const pinHash = await hashPin(pin);
    
    // Calculate age
    const dob = new Date(dateOfBirth);
    const age = Math.floor((Date.now() - dob.getTime()) / (365.25 * 24 * 60 * 60 * 1000));
    
    if (age < 18) {
      return reply.status(400).send({ code: 'VALIDATION_ERROR', message: 'Must be at least 18 years old' });
    }
    
    // Create user
    const user = await prisma.user.create({
      data: {
        phoneNumber,
        fullName,
        dateOfBirth: dob,
        nationalId,
        email,
        pinHash,
        status: 'PENDING',
        kycStatus: 'NOT_STARTED',
        loanLimit: 0,
      },
    });
    
    // Generate OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    await prisma.oTP.create({
      data: {
        phoneNumber,
        code: otpCode,
        purpose: 'registration',
        expiresAt: new Date(Date.now() + 5 * 60 * 1000),
      },
    });
    
    // Send OTP
    await sendOtp(phoneNumber, otpCode, 'registration');
    
    // Audit log
    await createAuditLog({
      userId: user.id,
      action: 'USER_REGISTERED',
      entityType: 'User',
      entityId: user.id,
      newValues: { phoneNumber, fullName, nationalId: nationalId.slice(-4) },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });
    
    return reply.status(201).send({ message: 'Registration successful. OTP sent to your phone.' });
  });

  // Get registration fee info (public endpoint)
  app.get('/registration-fee', {
    schema: { tags: ['Auth'] },
  }, async (request, reply) => {
    const fee = await prisma.registrationFee.findFirst({ 
      where: { isActive: true }, 
      orderBy: { createdAt: 'desc' } 
    });
    if (!fee) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Registration fee not configured' });
    }
    return { 
      amount: fee.amount, 
      currency: fee.currency, 
      description: fee.description,
      destinationType: fee.destinationType,
      destinationAccount: fee.destinationAccount,
      destinationName: fee.destinationName,
      destinationBranch: fee.destinationBranch,
      destinationReference: fee.destinationReference,
    };
  });

  // Initiate registration fee payment (STK Push)
  app.post('/registration-fee/pay', {
    schema: { body: stkPushSchema, tags: ['Auth'] },
  }, async (request, reply) => {
    const { phoneNumber } = request.body;
    
    const user = await prisma.user.findUnique({ where: { phoneNumber } });
    
    if (!user) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'User not found' });
    }
    
    if (user.registrationFeePaid) {
      return reply.status(400).send({ code: 'ALREADY_PAID', message: 'Registration fee already paid' });
    }
    
    const fee = await prisma.registrationFee.findFirst({ 
      where: { isActive: true }, 
      orderBy: { createdAt: 'desc' } 
    });
    
    if (!fee) {
      return reply.status(500).send({ code: 'FEE_NOT_CONFIGURED', message: 'Registration fee not configured' });
    }
    
    // Check for existing pending payment
    const existingPayment = await prisma.registrationFeePayment.findFirst({
      where: { userId: user.id, status: 'PENDING' },
      orderBy: { createdAt: 'desc' },
    });
    
    if (existingPayment) {
      // Return existing payment info
      return { 
        checkoutRequestId: (existingPayment.metadata as any)?.checkoutRequestId,
        message: 'Payment already initiated. Please check your phone.',
      };
    }
    
    // Generate reference
    const reference = `REG-${Date.now()}-${Math.random().toString(36).substring(2, 8).toUpperCase()}`;
    
    try {
      // Initiate STK Push
      // Use the configured destination account (till/paybill number) for the payment
      const response = await mpesaService.stkPush({
        phoneNumber,
        amount: fee.amount,
        accountReference: reference,
        transactionDesc: fee.description || 'Registration Fee',
        callbackUrl: `${config.mpesa.callbackUrl}/registration-fee`,
        businessShortCode: fee.destinationAccount, // Use configured till/paybill number
      });
      
      // Create payment record
      await prisma.registrationFeePayment.create({
        data: {
          userId: user.id,
          amount: fee.amount,
          currency: fee.currency,
          status: 'PENDING',
          provider: 'MPESA',
          reference,
          description: fee.description || 'Registration Fee',
          metadata: { checkoutRequestId: response.CheckoutRequestID, destinationAccount: fee.destinationAccount },
        },
      });
      
      return { 
        checkoutRequestId: response.CheckoutRequestID,
        message: 'STK Push sent. Please enter your M-Pesa PIN to complete payment.',
      };
    } catch (error: any) {
      return reply.status(500).send({ code: 'PAYMENT_INIT_FAILED', message: error.message });
    }
  });

  // Check registration fee payment status
  app.get('/registration-fee/status/:phoneNumber', {
    schema: { 
      params: z.object({ phoneNumber: z.string().regex(/^254[17]\d{8}$/) }),
      tags: ['Auth'] 
    },
  }, async (request, reply) => {
    const { phoneNumber } = request.params;
    
    const user = await prisma.user.findUnique({ where: { phoneNumber } });
    
    if (!user) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'User not found' });
    }
    
    const payment = await prisma.registrationFeePayment.findFirst({
      where: { userId: user.id },
      orderBy: { createdAt: 'desc' },
    });
    
    if (!payment) {
      return { paid: false, status: 'NOT_INITIATED' };
    }
    
    return { 
      paid: user.registrationFeePaid, 
      status: payment.status,
      amount: payment.amount,
      currency: payment.currency,
      processedAt: payment.processedAt,
    };
  });
  
  // Login
  app.post('/login', {
    schema: { body: loginSchema, tags: ['Auth'] },
  }, async (request, reply) => {
    const { phoneNumber, pin } = request.body;
    
    const user = await prisma.user.findUnique({ where: { phoneNumber } });
    
    if (!user) {
      return reply.status(401).send({ code: 'INVALID_CREDENTIALS', message: 'Invalid phone number or PIN' });
    }
    
    // Check if registration fee is paid (unless user is admin)
    if (!user.registrationFeePaid) {
      return reply.status(403).send({ 
        code: 'REGISTRATION_FEE_REQUIRED', 
        message: 'Registration fee payment required before login',
        registrationFeeRequired: true,
      });
    }
    
    if (user.status === 'BLOCKED' || user.status === 'SUSPENDED') {
      return reply.status(403).send({ code: 'ACCOUNT_SUSPENDED', message: 'Account is suspended' });
    }
    
    if (user.lockedUntil && user.lockedUntil > new Date()) {
      return reply.status(403).send({ code: 'ACCOUNT_LOCKED', message: 'Account temporarily locked' });
    }
    
    const isValid = await verifyPin(pin, user.pinHash);
    
    if (!isValid) {
      const attempts = user.failedLoginAttempts + 1;
      const updateData: any = { failedLoginAttempts: attempts };
      
      if (attempts >= 5) {
        updateData.lockedUntil = new Date(Date.now() + 15 * 60 * 1000);
      }
      
      await prisma.user.update({ where: { id: user.id }, data: updateData });
      
      return reply.status(401).send({ code: 'INVALID_CREDENTIALS', message: 'Invalid phone number or PIN' });
    }
    
    // Reset failed attempts
    await prisma.user.update({
      where: { id: user.id },
      data: { failedLoginAttempts: 0, lockedUntil: null, lastLoginAt: new Date() },
    });
    
    // Generate tokens
    const accessToken = generateToken({ sub: user.id, phone: user.phoneNumber, role: 'user' });
    const refreshToken = generateRefreshToken();
    const refreshTokenHash = await hashToken(refreshToken);
    
    await prisma.refreshToken.create({
      data: {
        userId: user.id,
        tokenHash: refreshTokenHash,
        expiresAt: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      },
    });
    
    // Audit log
    await createAuditLog({
      userId: user.id,
      action: 'USER_LOGIN',
      entityType: 'User',
      entityId: user.id,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });
    
    return { accessToken, refreshToken, expiresIn: 900 };
  });
  
  // Refresh token
  app.post('/refresh', {
    schema: { body: z.object({ refreshToken: z.string() }), tags: ['Auth'] },
  }, async (request, reply) => {
    const { refreshToken } = request.body;
    const refreshTokenHash = await hashToken(refreshToken);
    
    const stored = await prisma.refreshToken.findUnique({ where: { tokenHash: refreshTokenHash } });
    
    if (!stored || stored.expiresAt < new Date()) {
      return reply.status(401).send({ code: 'TOKEN_EXPIRED', message: 'Refresh token expired' });
    }
    
    const user = await prisma.user.findUnique({ where: { id: stored.userId } });
    
    if (!user || user.status !== 'ACTIVE') {
      return reply.status(401).send({ code: 'AUTHENTICATION_ERROR', message: 'User not found or inactive' });
    }
    
    // Rotate refresh token
    await prisma.refreshToken.delete({ where: { id: stored.id } });
    
    const newAccessToken = generateToken({ sub: user.id, phone: user.phoneNumber, role: 'user' });
    const newRefreshToken = generateRefreshToken();
    const newRefreshTokenHash = await hashToken(newRefreshToken);
    
    await prisma.refreshToken.create({
      data: {
        userId: user.id,
        tokenHash: newRefreshTokenHash,
        expiresAt: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      },
    });
    
    return { accessToken: newAccessToken, refreshToken: newRefreshToken, expiresIn: 900 };
  });
  
  // Logout
  app.post('/logout', {
    schema: { body: z.object({ refreshToken: z.string().optional() }), tags: ['Auth'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const { refreshToken } = request.body;
    
    if (refreshToken) {
      const refreshTokenHash = await hashToken(refreshToken);
      await prisma.refreshToken.deleteMany({ where: { tokenHash: refreshTokenHash } });
    }
    
    await createAuditLog({
      userId: (request as any).user.sub,
      action: 'USER_LOGOUT',
      entityType: 'User',
      entityId: (request as any).user.sub,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });
    
    return { message: 'Logged out successfully' };
  });
  
  // Request OTP
  app.post('/otp/request', {
    schema: { body: otpRequestSchema, tags: ['Auth'] },
  }, async (request, reply) => {
    const { phoneNumber } = request.body;
    
    const user = await prisma.user.findUnique({ where: { phoneNumber } });
    
    if (!user) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'User not found' });
    }
    
    // Check rate limit
    const recentOtp = await prisma.oTP.findFirst({
      where: { phoneNumber, purpose: 'login', createdAt: { gte: new Date(Date.now() - 60 * 1000) } },
    });
    
    if (recentOtp) {
      return reply.status(429).send({ code: 'RATE_LIMIT_EXCEEDED', message: 'Please wait before requesting another OTP' });
    }
    
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    await prisma.oTP.create({
      data: {
        phoneNumber,
        code: otpCode,
        purpose: 'login',
        expiresAt: new Date(Date.now() + 5 * 60 * 1000),
      },
    });
    
    await sendOtp(phoneNumber, otpCode, 'login');
    
    return { message: 'OTP sent' };
  });
  
  // Verify OTP
  app.post('/otp/verify', {
    schema: { body: otpVerifySchema, tags: ['Auth'] },
  }, async (request, reply) => {
    const { phoneNumber, code } = request.body;
    
    const otp = await prisma.oTP.findFirst({
      where: { phoneNumber, code, purpose: 'registration', used: false },
      orderBy: { createdAt: 'desc' },
    });
    
    if (!otp || otp.expiresAt < new Date()) {
      return reply.status(400).send({ code: 'OTP_EXPIRED', message: 'OTP expired or invalid' });
    }
    
    if (otp.attempts >= 3) {
      return reply.status(400).send({ code: 'OTP_MAX_ATTEMPTS', message: 'Too many attempts' });
    }
    
    await prisma.oTP.update({ where: { id: otp.id }, data: { used: true, attempts: { increment: 1 } } });
    
    // Activate user
    await prisma.user.update({ where: { phoneNumber }, data: { status: 'ACTIVE' } });
    
    return { message: 'Phone number verified' };
  });
  
  // Create PIN (after OTP verification)
  app.post('/pin', {
    schema: { body: createPinSchema, tags: ['Auth'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const { pin } = request.body;
    const userId = (request as any).user.sub;
    
    const pinHash = await hashPin(pin);
    
    await prisma.user.update({
      where: { id: userId },
      data: { pinHash },
    });
    
    await createAuditLog({
      userId,
      action: 'PIN_CHANGED',
      entityType: 'User',
      entityId: userId,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });
    
    return { message: 'PIN created successfully' };
  });
};