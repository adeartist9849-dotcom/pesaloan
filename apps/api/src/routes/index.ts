import { FastifyInstance } from 'fastify';
import { registerAuthGuards } from '../common/guards/auth.js';
import { authRoutes } from '../modules/auth/routes.js';
import { kycRoutes } from '../modules/kyc/routes.js';
import { loansRoutes } from '../modules/loans/routes.js';
import { mobileMoneyRoutes } from '../modules/mobile-money/routes.js';
import { adminRoutes } from '../modules/admin/routes.js';

export async function registerRoutes(app: FastifyInstance) {
  // Health check
  app.get('/health', async () => ({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
  }));

  // Register auth guards
  registerAuthGuards(app);

  // API v1 routes
  await app.register(async (fastify) => {
    // Public auth routes
    await fastify.register(authRoutes);
    
    // Protected routes (require authentication)
    await fastify.register(async (protectedRoutes) => {
      protectedRoutes.addHook('onRequest', (fastify as any).authenticate);
      
      await protectedRoutes.register(kycRoutes);
      await protectedRoutes.register(loansRoutes);
      await protectedRoutes.register(mobileMoneyRoutes);
    });
    
    // Admin routes (require admin role)
    await fastify.register(adminRoutes);
  }, { prefix: '/api/v1' });
}
