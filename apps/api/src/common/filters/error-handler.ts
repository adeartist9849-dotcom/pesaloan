import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';

export async function errorHandler(
  error: FastifyError,
  request: FastifyRequest,
  reply: FastifyReply
) {
  request.log.error({ err: error }, 'Request error');
  
  // Zod validation errors
  if (error instanceof ZodError) {
    return reply.status(400).send({
      code: 'VALIDATION_ERROR',
      message: 'Validation failed',
      details: error.errors.map(e => ({
        field: e.path.join('.'),
        message: e.message,
      })),
    });
  }
  
  // Prisma errors
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    if (error.code === 'P2002') {
      const target = (error.meta?.target as string[])?.join(', ') || 'field';
      return reply.status(409).send({
        code: 'CONFLICT',
        message: `${target} already exists`,
      });
    }
    if (error.code === 'P2025') {
      return reply.status(404).send({
        code: 'NOT_FOUND',
        message: 'Record not found',
      });
    }
  }
  
  // Fastify validation errors
  if (error.validation) {
    return reply.status(400).send({
      code: 'VALIDATION_ERROR',
      message: 'Validation failed',
      details: error.validation.map(v => ({
        field: v.instancePath.replace('/', '') || v.schemaPath,
        message: v.message,
      })),
    });
  }
  
  // JWT errors
  if (error.code === 'FST_JWT_BAD_REQUEST' || error.code === 'FST_JWT_AUTHORIZATION_TOKEN_EXPIRED') {
    return reply.status(401).send({
      code: 'TOKEN_EXPIRED',
      message: 'Token expired or invalid',
    });
  }
  
  if (error.code === 'FST_JWT_NO_AUTHORIZATION_IN_HEADER') {
    return reply.status(401).send({
      code: 'AUTHENTICATION_ERROR',
      message: 'Authentication required',
    });
  }
  
  // Rate limit
  if (error.statusCode === 429) {
    return reply.status(429).send({
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests',
    });
  }
  
  // Default error
  const statusCode = error.statusCode || 500;
  const message = statusCode === 500 ? 'Internal server error' : error.message;
  
  return reply.status(statusCode).send({
    code: error.code || 'INTERNAL_ERROR',
    message,
  });
}