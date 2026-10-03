import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { prisma } from '../../database/client.js';
import { createAuditLog } from '../../common/utils/audit.js';

const submitKycSchema = z.object({
  nationalId: z.string().regex(/^\d{8}$/),
  idFrontImage: z.string().optional(),
  idBackImage: z.string().optional(),
  selfieImage: z.string().optional(),
});

export const kycRoutes: FastifyPluginAsyncZod = async (app) => {
  // Submit KYC (requires auth)
  app.post('/submit', {
    schema: { body: submitKycSchema, tags: ['KYC'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;
    const { nationalId, idFrontImage, idBackImage, selfieImage } = request.body;

    // Check if user already has KYC
    const existingKyc = await prisma.kycRecord.findUnique({ where: { userId } });
    
    if (existingKyc && existingKyc.status !== 'REJECTED' && existingKyc.status !== 'EXPIRED') {
      return reply.status(409).send({ code: 'KYC_ALREADY_SUBMITTED', message: 'KYC already submitted' });
    }

    // In production: Call KYC provider API
    // For now: mock verification
    const mockVerification = await mockKycVerification(nationalId, idFrontImage, idBackImage, selfieImage);

    const kycRecord = await prisma.kycRecord.upsert({
      where: { userId },
      create: {
        userId,
        status: mockVerification.success ? 'VERIFIED' : 'REJECTED',
        provider: 'mock',
        providerReference: `KYC-${Date.now()}`,
        verificationData: {
          nationalId,
          idFrontImage: !!idFrontImage,
          idBackImage: !!idBackImage,
          selfieImage: !!selfieImage,
          ...mockVerification.data,
        },
        verifiedAt: mockVerification.success ? new Date() : null,
        rejectedAt: !mockVerification.success ? new Date() : null,
        rejectionReason: mockVerification.success ? null : mockVerification.reason,
      },
      update: {
        status: mockVerification.success ? 'VERIFIED' : 'REJECTED',
        provider: 'mock',
        providerReference: `KYC-${Date.now()}`,
        verificationData: {
          nationalId,
          idFrontImage: !!idFrontImage,
          idBackImage: !!idBackImage,
          selfieImage: !!selfieImage,
          ...mockVerification.data,
        },
        verifiedAt: mockVerification.success ? new Date() : null,
        rejectedAt: !mockVerification.success ? new Date() : null,
        rejectionReason: mockVerification.success ? null : mockVerification.reason,
      },
    });

    // Update user KYC status
    await prisma.user.update({
      where: { id: userId },
      data: { kycStatus: mockVerification.success ? 'VERIFIED' : 'REJECTED' },
    });

    // Audit log
    await createAuditLog({
      userId,
      action: mockVerification.success ? 'KYC_VERIFIED' : 'KYC_REJECTED',
      entityType: 'KycRecord',
      entityId: kycRecord.id,
      newValues: { status: kycRecord.status, providerReference: kycRecord.providerReference },
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { 
      status: kycRecord.status,
      message: mockVerification.success ? 'KYC verified successfully' : 'KYC rejected',
      rejectionReason: kycRecord.rejectionReason,
    };
  });

  // Get KYC status
  app.get('/status', {
    schema: { tags: ['KYC'], security: [{ bearerAuth: [] }] },
    onRequest: [(app as any).authenticate],
  }, async (request, reply) => {
    const userId = (request as any).user.sub;

    const kyc = await prisma.kycRecord.findUnique({ where: { userId } });
    const user = await prisma.user.findUnique({ where: { id: userId }, select: { kycStatus: true } });

    if (!kyc) {
      return { status: user?.kycStatus || 'NOT_STARTED', record: null };
    }

    return { 
      status: kyc.status,
      record: {
        id: kyc.id,
        provider: kyc.provider,
        providerReference: kyc.providerReference,
        verifiedAt: kyc.verifiedAt,
        rejectedAt: kyc.rejectedAt,
        rejectionReason: kyc.rejectionReason,
        expiresAt: kyc.expiresAt,
      },
    };
  });
};

// Mock KYC verification - replace with real provider integration
async function mockKycVerification(
  nationalId: string,
  idFrontImage?: string,
  idBackImage?: string,
  selfieImage?: string
): Promise<{ success: boolean; data: Record<string, unknown>; reason?: string }> {
  // Simulate API call delay
  await new Promise(resolve => setTimeout(resolve, 1000));

  // Basic validation
  if (!nationalId || nationalId.length !== 8) {
    return { success: false, data: {}, reason: 'Invalid national ID format' };
  }

  if (!idFrontImage || !idBackImage || !selfieImage) {
    return { success: false, data: {}, reason: 'All document images required' };
  }

  // Mock: 90% success rate
  const success = Math.random() > 0.1;

  return {
    success,
    data: {
      faceMatchScore: success ? 0.95 + Math.random() * 0.05 : 0.3,
      documentValidity: success ? 'valid' : 'expired',
      livenessCheck: success ? 'passed' : 'failed',
    },
    reason: success ? undefined : 'Document verification failed',
  };
}