import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { prisma } from '../../database/client.js';
import { createAuditLog } from '../../common/utils/audit.js';

export const adminRoutes = async (app: any) => {
  // Admin authentication middleware
  const requireAdmin: any = async (request: any, reply: any) => {
    await app.authenticate(request, reply);
    if (reply.sent) return;
    
    // Check if user is admin (you'd need admin user table or role field)
    // For now, check if user has admin role in metadata
    // In production, use separate AdminUser table
    const user = await prisma.user.findUnique({ where: { id: (request as any).user.sub } });
    if (!user || user.phoneNumber !== '254700000000') { // Replace with proper admin check
      return reply.status(403).send({ code: 'AUTHORIZATION_ERROR', message: 'Admin access required' });
    }
  };

  // ============================================
  // Customers
  // ============================================
  app.get('/customers', {
    schema: {
      querystring: z.object({
        page: z.coerce.number().default(1),
        limit: z.coerce.number().default(20),
        search: z.string().optional(),
        kycStatus: z.string().optional(),
        accountStatus: z.string().optional(),
      }),
      tags: ['Admin - Customers'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { page = 1, limit = 20, search, kycStatus, accountStatus } = request.query || {};
    const where: any = {};

    if (search) {
      where.OR = [
        { fullName: { contains: search, mode: 'insensitive' } },
        { phoneNumber: { contains: search } },
        { email: { contains: search, mode: 'insensitive' } },
        { nationalId: { contains: search } },
      ];
    }
    if (kycStatus) where.kycStatus = kycStatus;
    if (accountStatus) where.status = accountStatus;

    const [customers, total] = await Promise.all([
      prisma.user.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
        select: {
          id: true,
          phoneNumber: true,
          fullName: true,
          email: true,
          kycStatus: true,
          status: true,
          loanLimit: true,
          createdAt: true,
          lastLoginAt: true,
          loans: {
            where: { status: { in: ['ACTIVE', 'OVERDUE'] } },
            take: 1,
            orderBy: { createdAt: 'desc' },
            select: { status: true },
          },
        },
      }),
      prisma.user.count({ where }),
    ]);

    return {
      data: customers.map(c => ({
        id: c.id,
        phoneNumber: c.phoneNumber,
        fullName: c.fullName,
        email: c.email,
        kycStatus: c.kycStatus,
        accountStatus: c.status,
        loanLimit: c.loanLimit,
        currentLoanStatus: c.loans[0]?.status || null,
        createdAt: c.createdAt,
        lastActiveAt: c.lastLoginAt,
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  });

  app.get('/customers/:id', {
    schema: { params: z.object({ id: z.string().cuid() }), tags: ['Admin - Customers'], security: [{ bearerAuth: [] }] },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { id } = request.params;
    const customer = await prisma.user.findUnique({
      where: { id },
      include: {
        kycRecord: true,
        loans: { orderBy: { createdAt: 'desc' } },
        _count: { select: { loans: true, repayments: true, transactions: true } },
      },
    });

    if (!customer) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Customer not found' });
    }

    return customer;
  });

  app.patch('/customers/:id/status', {
    schema: {
      params: z.object({ id: z.string().cuid() }),
      body: z.object({ status: z.enum(['ACTIVE', 'SUSPENDED', 'CLOSED', 'BLOCKED']) }),
      tags: ['Admin - Customers'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { id } = request.params;
    const { status } = request.body;

    const customer = await prisma.user.update({
      where: { id },
      data: { status },
    });

    await createAuditLog({
      adminId: (request as any).user.sub,
      action: status === 'SUSPENDED' ? 'CUSTOMER_SUSPENDED' : 'CUSTOMER_REACTIVATED',
      entityType: 'User',
      entityId: id,
      newValues: { status },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { message: `Customer ${status.toLowerCase()}`, customer };
  });

  // ============================================
  // Loans
  // ============================================
  app.get('/loans', {
    schema: {
      querystring: z.object({
        page: z.coerce.number().default(1),
        limit: z.coerce.number().default(20),
        status: z.string().optional(),
        search: z.string().optional(),
      }),
      tags: ['Admin - Loans'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { page = 1, limit = 20, status, search } = request.query || {};
    const where: any = {};

    if (status) where.status = status;
    if (search) {
      where.OR = [
        { id: { contains: search } },
        { user: { fullName: { contains: search, mode: 'insensitive' } } },
        { user: { phoneNumber: { contains: search } } },
      ];
    }

    const [loans, total] = await Promise.all([
      prisma.loan.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
        include: { user: { select: { id: true, fullName: true, phoneNumber: true } } },
      }),
      prisma.loan.count({ where }),
    ]);

    return {
      data: loans.map(l => ({
        id: l.id,
        customerId: l.userId,
        customerName: l.user.fullName,
        customerPhone: l.user.phoneNumber,
        principal: l.principal,
        outstandingBalance: l.outstandingBalance,
        status: l.status,
        dueDate: l.dueDate,
        createdAt: l.createdAt,
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  });

  app.post('/loans/:id/approve', {
    schema: {
      params: z.object({ id: z.string().cuid() }),
      tags: ['Admin - Loans'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { id } = request.params;

    const loan = await prisma.loan.findUnique({ where: { id } });
    if (!loan) return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });

    await prisma.loan.update({ where: { id }, data: { status: 'APPROVED' } });
    await prisma.loanApplication.update({ where: { id: loan.applicationId }, data: { status: 'APPROVED' } });

    await createAuditLog({
      adminId: (request as any).user.sub,
      action: 'LOAN_MANUALLY_APPROVED',
      entityType: 'Loan',
      entityId: id,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { message: 'Loan approved' };
  });

  app.post('/loans/:id/decline', {
    schema: {
      params: z.object({ id: z.string().cuid() }),
      body: z.object({ reason: z.string().min(1) }),
      tags: ['Admin - Loans'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { id } = request.params;
    const { reason } = request.body;

    const loan = await prisma.loan.findUnique({ where: { id } });
    if (!loan) return reply.status(404).send({ code: 'NOT_FOUND', message: 'Loan not found' });

    await prisma.loan.update({ where: { id }, data: { status: 'RESOLVED' as any } });
    await prisma.loanApplication.update({ where: { id: loan.applicationId }, data: { status: 'DECLINED', decisionReason: reason } });

    await createAuditLog({
      adminId: (request as any).user.sub,
      action: 'LOAN_MANUALLY_DECLINED',
      entityType: 'Loan',
      entityId: id,
      newValues: { reason },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { message: 'Loan declined' };
  });

  // ============================================
  // Payments
  // ============================================
  app.get('/payments', {
    schema: {
      querystring: z.object({
        page: z.coerce.number().default(1),
        limit: z.coerce.number().default(20),
        type: z.string().optional(),
        status: z.string().optional(),
        provider: z.string().optional(),
        search: z.string().optional(),
      }),
      tags: ['Admin - Payments'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { page = 1, limit = 20, type, status, provider, search } = request.query || {};
    const where: any = {};

    if (type) where.type = type;
    if (status) where.status = status;
    if (provider) where.provider = provider;
    if (search) {
      where.OR = [
        { id: { contains: search } },
        { reference: { contains: search } },
        { user: { fullName: { contains: search, mode: 'insensitive' } } },
        { loan: { id: { contains: search } } },
      ];
    }

    const [payments, total] = await Promise.all([
      prisma.transaction.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
        include: {
          user: { select: { id: true, fullName: true, phoneNumber: true } },
          loan: { select: { id: true } },
        },
      }),
      prisma.transaction.count({ where }),
    ]);

    return {
      data: payments.map(p => ({
        id: p.id,
        loanId: p.loanId,
        customerName: p.user.fullName,
        customerPhone: p.user.phoneNumber,
        type: p.type,
        amount: p.amount,
        status: p.status,
        reference: p.reference,
        provider: p.provider,
        providerReference: p.providerReference,
        createdAt: p.createdAt,
        processedAt: p.processedAt,
      })),
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  });

  // ============================================
  // Credit Rules
  // ============================================
  app.get('/credit/rules', {
    schema: { tags: ['Admin - Credit'], security: [{ bearerAuth: [] }] },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const rules = await prisma.creditRules.findFirst();
    if (!rules) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Credit rules not found' });
    }
    return rules;
  });

  app.put('/credit/rules', {
    schema: {
      body: z.object({
        minLoanAmount: z.number().int().positive(),
        maxLoanAmount: z.number().int().positive(),
        minTermDays: z.number().int().positive(),
        maxTermDays: z.number().int().positive(),
        interestRate: z.number().min(0).max(100),
        processingFeeRate: z.number().min(0).max(100),
        lateFeeRate: z.number().min(0).max(100),
        maxLoanToLimitRatio: z.number().min(0).max(1),
        minCreditScore: z.number().int().min(0).max(1000),
        maxActiveLoans: z.number().int().positive(),
      }),
      tags: ['Admin - Credit'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const data = request.body as any;

    const rules = await prisma.creditRules.upsert({
      where: { id: 'default' },
      create: { id: 'default', ...data },
      update: data,
    });

    await createAuditLog({
      adminId: (request as any).user.sub,
      action: 'CREDIT_RULES_UPDATED',
      entityType: 'CreditRules',
      entityId: 'default',
      newValues: data,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return rules;
  });

  // ============================================
  // Registration Fee Management
  // ============================================
  app.get('/registration-fee', {
    schema: { tags: ['Admin - Registration Fee'], security: [{ bearerAuth: [] }] },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const fee = await prisma.registrationFee.findFirst({ where: { isActive: true }, orderBy: { createdAt: 'desc' } });
    if (!fee) {
      return reply.status(404).send({ code: 'NOT_FOUND', message: 'Registration fee not configured' });
    }
    return fee;
  });

  app.put('/registration-fee', {
    schema: {
      body: z.object({
        amount: z.number().int().positive('Amount must be positive'),
        currency: z.string().default('KES'),
        isActive: z.boolean().default(true),
        description: z.string().optional(),
        destinationType: z.enum(['MPESA_TILL', 'MPESA_PAYBILL', 'BANK_ACCOUNT', 'MOBILE_MONEY']).default('MPESA_TILL'),
        destinationAccount: z.string().min(1, 'Destination account is required'),
        destinationName: z.string().optional(),
        destinationBranch: z.string().optional(),
        destinationReference: z.string().optional(),
      }),
      tags: ['Admin - Registration Fee'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const data = request.body as any;

    // Deactivate all existing fees
    await prisma.registrationFee.updateMany({
      where: { isActive: true },
      data: { isActive: false },
    });

    // Create new fee
    const fee = await prisma.registrationFee.create({
      data: {
        amount: data.amount,
        currency: data.currency,
        isActive: data.isActive,
        description: data.description,
        destinationType: data.destinationType,
        destinationAccount: data.destinationAccount,
        destinationName: data.destinationName,
        destinationBranch: data.destinationBranch,
        destinationReference: data.destinationReference,
      },
    });

    await createAuditLog({
      adminId: (request as any).user.sub,
      action: 'CREDIT_RULES_UPDATED',
      entityType: 'RegistrationFee',
      entityId: fee.id,
      newValues: data,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return fee;
  });

  // ============================================
  // Audit Logs
  // ============================================
  app.get('/audit-logs', {
    schema: {
      querystring: z.object({
        page: z.coerce.number().default(1),
        limit: z.coerce.number().default(50),
        action: z.string().optional(),
        entityType: z.string().optional(),
        userId: z.string().optional(),
        adminId: z.string().optional(),
        fromDate: z.string().optional(),
        toDate: z.string().optional(),
      }),
      tags: ['Admin - Audit'],
      security: [{ bearerAuth: [] }],
    },
    onRequest: [requireAdmin],
  }, async (request: any, reply: any) => {
    const { page = 1, limit = 50, action, entityType, userId, adminId, fromDate, toDate } = (request as any).query || {};
    const where: any = {};

    if (action) where.action = action;
    if (entityType) where.entityType = entityType;
    if (userId) where.userId = userId;
    if (adminId) where.adminId = adminId;
    if (fromDate || toDate) {
      where.createdAt = {};
      if (fromDate) where.createdAt.gte = new Date(fromDate);
      if (toDate) where.createdAt.lte = new Date(toDate);
    }

    const [logs, total] = await Promise.all([
      prisma.auditLog.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      prisma.auditLog.count({ where }),
    ]);

    return reply.send({ data: logs, total, page, limit, totalPages: Math.ceil(total / limit) });
  });

  // ============================================
  // Dashboard Stats
  // ============================================
  app.get('/dashboard/stats', {
    schema: { tags: ['Admin - Dashboard'], security: [{ bearerAuth: [] }] },
    onRequest: [requireAdmin],
  }, async (_request: any, reply: any) => {
    const [
      totalCustomers,
      activeLoans,
      totalDisbursed,
      totalRepaid,
      pendingApplications,
      overdueLoans,
      kycVerified,
      kycPending,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.loan.count({ where: { status: 'ACTIVE' } }),
      prisma.transaction.aggregate({ where: { type: 'DISBURSEMENT', status: 'COMPLETED' }, _sum: { amount: true } }),
      prisma.transaction.aggregate({ where: { type: 'REPAYMENT', status: 'COMPLETED' }, _sum: { amount: true } }),
      prisma.loanApplication.count({ where: { status: 'SUBMITTED' } }),
      prisma.loan.count({ where: { status: 'OVERDUE' } }),
      prisma.user.count({ where: { kycStatus: 'VERIFIED' } }),
      prisma.user.count({ where: { kycStatus: 'PENDING_REVIEW' } }),
    ]);

    const disbursedAmount = totalDisbursed._sum.amount || 0;
    const repaidAmount = totalRepaid._sum.amount || 0;

    return reply.send({
      totalCustomers,
      activeLoans,
      totalDisbursed: disbursedAmount,
      totalRepaid: repaidAmount,
      pendingApplications,
      overdueLoans,
      kycVerified,
      kycPending,
      repaymentRate: disbursedAmount > 0 ? Number(((repaidAmount / disbursedAmount) * 100).toFixed(1)) : 0,
    });
  });
};