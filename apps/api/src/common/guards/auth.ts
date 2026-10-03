import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../database/client.js';

declare module '@fastify/jwt' {
  interface FastifyJWT {
    payload: { sub: string; phone?: string; role?: string };
    user: { sub: string; phone?: string; role?: string };
  }
}

declare module 'fastify' {
  interface FastifyInstance {
    authenticate: (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
    requireRole: (...roles: string[]) => (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
  }
}

export async function authenticate(request: FastifyRequest, reply: FastifyReply) {
  try {
    await request.jwtVerify();
    
    if (!request.user) {
      return reply.status(401).send({ code: 'AUTHENTICATION_ERROR', message: 'Invalid token' });
    }
    
    // Verify user still exists and is active
    const user = await prisma.user.findUnique({ where: { id: request.user.sub } });
    
    if (!user || user.status !== 'ACTIVE') {
      return reply.status(401).send({ code: 'AUTHENTICATION_ERROR', message: 'User not found or inactive' });
    }
  } catch (error) {
    return reply.status(401).send({ code: 'TOKEN_INVALID', message: 'Invalid or expired token' });
  }
}

export function requireRole(...roles: string[]) {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    await authenticate(request, reply);
    
    if (reply.sent) return;
    
    if (!request.user || !roles.includes(request.user.role || '')) {
      return reply.status(403).send({ code: 'AUTHORIZATION_ERROR', message: 'Insufficient permissions' });
    }
  };
}

export function optionalAuth(request: FastifyRequest, reply: FastifyReply, done: () => void) {
  const authHeader = request.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return done();
  }

  try {
    request.jwtVerify();
    done();
  } catch {
    done();
  }
}

export function registerAuthGuards(app: FastifyInstance) {
  app.decorate('authenticate', authenticate);
  app.decorate('requireRole', requireRole);
  app.addHook('onRequest', optionalAuth);
}
