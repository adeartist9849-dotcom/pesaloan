import { FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { prisma } from '../../database/client.js';
import { hashPin, verifyPin } from '../../common/utils/crypto.js';
import { generateToken, generateRefreshToken, hashToken } from '../../common/utils/crypto.js';
import { createAuditLog } from '../../common/utils/audit.js';

const adminLoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

export const adminAuthRoutes: FastifyPluginAsyncZod = async (app) => {
  // Admin login
  app.post('/login', {
    schema: { body: adminLoginSchema, tags: ['Admin Auth'] },
  }, async (request, reply) => {
    const { email, password } = request.body;

    const admin = await prisma.adminUser.findUnique({ where: { email } });

    if (!admin) {
      return reply.status(401).send({ code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' });
    }

    // For simplicity, using PIN verification - in production use proper password hashing (bcrypt)
    const isValid = await verifyPin(password, admin.passwordHash);

    if (!isValid) {
      return reply.status(401).send({ code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' });
    }

    // Generate tokens
    const accessToken = generateToken({ sub: admin.id, email: admin.email, role: admin.role });
    const refreshToken = generateRefreshToken();
    const refreshTokenHash = await hashToken(refreshToken);

    await prisma.refreshToken.create({
      data: {
        userId: admin.id,
        tokenHash: refreshTokenHash,
        expiresAt: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      },
    });

    await prisma.adminUser.update({
      where: { id: admin.id },
      data: { lastLoginAt: new Date() },
    });

    await createAuditLog({
      adminId: admin.id,
      action: 'ADMIN_LOGIN',
      entityType: 'AdminUser',
      entityId: admin.id,
      ipAddress: request.ip,
      userAgent: request.headers['user-agent'],
    });

    return { accessToken, refreshToken, expiresIn: 900, admin: { id: admin.id, email: admin.email, fullName: admin.fullName, role: admin.role } };
  });
};