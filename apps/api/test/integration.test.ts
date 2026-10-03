import { describe, it, expect, beforeAll, afterAll, beforeEach } from '@jest/globals';
import Fastify from 'fastify';
import { registerRoutes } from '../src/routes/index.js';
import { prisma } from '../src/database/client.js';
import { hashPin } from '../src/common/utils/crypto.js';

describe('API Integration Tests', () => {
  let app: any;
  let adminToken: string;
  let userToken: string;
  let testUserId: string;

  beforeAll(async () => {
    app = Fastify({ logger: false });
    await registerRoutes(app);
    await app.ready();

    // Create test admin user
    const adminPasswordHash = await hashPin('admin123');
    await prisma.adminUser.upsert({
      where: { email: 'test@admin.com' },
      update: {},
      create: {
        email: 'test@admin.com',
        passwordHash: adminPasswordHash,
        fullName: 'Test Admin',
        role: 'SUPER_ADMIN',
        permissions: ['*'],
      },
    });

    // Login as admin
    const adminLogin = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/auth/login',
      payload: { email: 'test@admin.com', password: 'admin123' },
    });
    adminToken = JSON.parse(adminLogin.payload).accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(async () => {
    // Clean up test data
    await prisma.user.deleteMany({ where: { phoneNumber: { startsWith: '254799' } } });
  });

  describe('Health Check', () => {
    it('should return ok', async () => {
      const response = await app.inject({ method: 'GET', url: '/health' });
      expect(response.statusCode).toBe(200);
      expect(JSON.parse(response.payload)).toEqual(expect.objectContaining({ status: 'ok' }));
    });
  });

  describe('Auth - User Registration', () => {
    it('should register a new user', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000001',
          fullName: 'Test User',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999999',
          email: 'test@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      expect(response.statusCode).toBe(201);
      expect(JSON.parse(response.payload)).toEqual(expect.objectContaining({ message: expect.any(String) }));
    });

    it('should reject duplicate phone number', async () => {
      await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000002',
          fullName: 'Test User',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999998',
          email: 'test2@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000002',
          fullName: 'Test User 2',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999997',
          email: 'test3@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      expect(response.statusCode).toBe(409);
    });
  });

  describe('Auth - Login Flow', () => {
    beforeEach(async () => {
      // Create user and verify OTP
      await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000003',
          fullName: 'Login Test',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999996',
          email: 'login@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      // Get OTP from database (in test, we'd mock this)
      const otpRecord = await prisma.oTP.findFirst({
        where: { phoneNumber: '254799000003', purpose: 'registration' },
        orderBy: { createdAt: 'desc' },
      });

      if (otpRecord) {
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/otp/verify',
          payload: { phoneNumber: '254799000003', code: otpRecord.code },
        });

        // Create PIN
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/pin',
          payload: { pin: '1234' },
          headers: { authorization: `Bearer ${(await app.inject({
            method: 'POST',
            url: '/api/v1/auth/login',
            payload: { phoneNumber: '254799000003', pin: '1234' },
          })).json().accessToken}` },
        });
      }
    });

    it('should login with correct PIN', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/auth/login',
        payload: { phoneNumber: '254799000003', pin: '1234' },
      });

      expect(response.statusCode).toBe(200);
      const data = JSON.parse(response.payload);
      expect(data).toHaveProperty('accessToken');
      expect(data).toHaveProperty('refreshToken');
      userToken = data.accessToken;
      testUserId = (await app.inject({
        method: 'GET',
        url: '/api/v1/users/profile',
        headers: { authorization: `Bearer ${userToken}` },
      })).json().id;
    });

    it('should reject wrong PIN', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/auth/login',
        payload: { phoneNumber: '254799000003', pin: '4321' },
      });

      expect(response.statusCode).toBe(401);
    });
  });

  describe('KYC', () => {
    it('should submit KYC', async () => {
      // First register and login
      await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000004',
          fullName: 'KYC Test',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999995',
          email: 'kyc@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      const otpRecord = await prisma.oTP.findFirst({
        where: { phoneNumber: '254799000004', purpose: 'registration' },
        orderBy: { createdAt: 'desc' },
      });

      if (otpRecord) {
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/otp/verify',
          payload: { phoneNumber: '254799000004', code: otpRecord.code },
        });

        const login = await app.inject({
          method: 'POST',
          url: '/api/v1/auth/login',
          payload: { phoneNumber: '254799000004', pin: '1234' },
        });
        userToken = login.json().accessToken;

        const response = await app.inject({
          method: 'POST',
          url: '/api/v1/kyc/submit',
          headers: { authorization: `Bearer ${userToken}` },
          payload: {
            nationalId: '99999995',
            idFrontImage: 'base64_image',
            idBackImage: 'base64_image',
            selfieImage: 'base64_image',
          },
        });

        expect(response.statusCode).toBe(200);
        expect(JSON.parse(response.payload)).toHaveProperty('status');
      }
    });

    it('should get KYC status', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/api/v1/kyc/status',
        headers: { authorization: `Bearer ${userToken}` },
      });

      expect(response.statusCode).toBe(200);
    });
  });

  describe('Loans', () => {
    beforeEach(async () => {
      // Setup user with KYC verified
      await app.inject({
        method: 'POST',
        url: '/api/v1/auth/register',
        payload: {
          phoneNumber: '254799000005',
          fullName: 'Loan Test',
          dateOfBirth: '1990-01-01T00:00:00.000Z',
          nationalId: '99999994',
          email: 'loan@example.com',
          pin: '1234',
          consentGiven: true,
          consentVersion: '1.0',
        },
      });

      const otpRecord = await prisma.oTP.findFirst({
        where: { phoneNumber: '254799000005', purpose: 'registration' },
        orderBy: { createdAt: 'desc' },
      });

      if (otpRecord) {
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/otp/verify',
          payload: { phoneNumber: '254799000005', code: otpRecord.code },
        });

        const login = await app.inject({
          method: 'POST',
          url: '/api/v1/auth/login',
          payload: { phoneNumber: '254799000005', pin: '1234' },
        });
        userToken = login.json().accessToken;

        // Manually set KYC verified and loan limit for testing
        const user = await prisma.user.findUnique({ where: { phoneNumber: '254799000005' } });
        if (user) {
          await prisma.user.update({
            where: { id: user.id },
            data: { kycStatus: 'VERIFIED', loanLimit: 50000 },
          });
          await prisma.kycRecord.upsert({
            where: { userId: user.id },
            create: { userId: user.id, status: 'VERIFIED', provider: 'mock', providerReference: 'test', verificationData: {} },
            update: { status: 'VERIFIED' },
          });
        }
      }
    });

    it('should apply for loan', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/loans/apply',
        headers: { authorization: `Bearer ${userToken}` },
        payload: { amount: 10000, termDays: 30 },
      });

      expect(response.statusCode).toBe(200);
      const data = JSON.parse(response.payload);
      expect(data).toHaveProperty('loanId');
      expect(data).toHaveProperty('totalPayable');
    });

    it('should reject loan over limit', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/loans/apply',
        headers: { authorization: `Bearer ${userToken}` },
        payload: { amount: 100000, termDays: 30 },
      });

      expect(response.statusCode).toBe(400);
    });

    it('should get dashboard', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/api/v1/loans/dashboard',
        headers: { authorization: `Bearer ${userToken}` },
      });

      expect(response.statusCode).toBe(200);
      const data = JSON.parse(response.payload);
      expect(data).toHaveProperty('user');
      expect(data).toHaveProperty('availableLimit');
    });
  });

  describe('Admin Routes', () => {
    it('should get dashboard stats', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/api/v1/admin/dashboard/stats',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
      const data = JSON.parse(response.payload);
      expect(data).toHaveProperty('totalCustomers');
      expect(data).toHaveProperty('activeLoans');
    });

    it('should get customers', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/api/v1/admin/customers',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
      const data = JSON.parse(response.payload);
      expect(data).toHaveProperty('data');
      expect(Array.isArray(data.data)).toBe(true);
    });

    it('should get credit rules', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/api/v1/admin/credit/rules',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
    });

    it('should update credit rules', async () => {
      const response = await app.inject({
        method: 'PUT',
        url: '/api/v1/admin/credit/rules',
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          minLoanAmount: 500,
          maxLoanAmount: 50000,
          minTermDays: 7,
          maxTermDays: 90,
          interestRate: 15.0,
          processingFeeRate: 5.0,
          lateFeeRate: 1.0,
          maxLoanToLimitRatio: 1.0,
          minCreditScore: 300,
          maxActiveLoans: 1,
        },
      });

      expect(response.statusCode).toBe(200);
    });
  });
});