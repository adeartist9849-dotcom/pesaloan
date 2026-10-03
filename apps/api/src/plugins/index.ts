import { FastifyInstance } from 'fastify';
import fastifyCors from '@fastify/cors';
import fastifyHelmet from '@fastify/helmet';
import fastifyRateLimit from '@fastify/rate-limit';
import fastifyJwt from '@fastify/jwt';
import fastifySwagger from '@fastify/swagger';
import fastifySwaggerUi from '@fastify/swagger-ui';
import { config } from '../config/index.js';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { errorHandler } from '../common/filters/error-handler.js';

export async function registerPlugins(app: FastifyInstance) {
  // CORS
  await app.register(fastifyCors, {
    origin: config.nodeEnv === 'development' ? true : (config as any).allowedOrigins?.split(',') || false,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  });
  
  // Helmet
  await app.register(fastifyHelmet, {
    contentSecurityPolicy: config.nodeEnv === 'development' ? false : undefined,
  });
  
  // Rate limiting
  await app.register(fastifyRateLimit, {
    max: 100,
    timeWindow: '1 minute',
    allowList: ['127.0.0.1', '::1'],
  });
  
  // JWT
  await app.register(fastifyJwt, {
    secret: config.jwtSecret,
    sign: { expiresIn: config.jwtExpiry },
    verify: { maxAge: config.jwtExpiry },
  });
  
  // Zod type provider
  app.withTypeProvider<ZodTypeProvider>();
  
  // Error handler
  app.setErrorHandler(errorHandler);
  
  // Swagger
  if (config.nodeEnv !== 'production') {
    await app.register(fastifySwagger, {
      openapi: {
        info: {
          title: 'PesaLoan API',
          description: 'Digital lending platform API',
          version: config.appVersion,
        },
        servers: [{ url: `http://${config.host}:${config.port}`, description: 'Development server' }],
        components: {
          securitySchemes: {
            bearerAuth: {
              type: 'http',
              scheme: 'bearer',
              bearerFormat: 'JWT',
            },
          },
        },
      },
    });
    
    await app.register(fastifySwaggerUi, {
      routePrefix: '/docs',
      uiConfig: { docExpansion: 'list', deepLinking: true },
    });
  }
  
  // Request logging
  app.addHook('onRequest', async (request) => {
    request.log.info({ method: request.method, url: request.url }, 'Incoming request');
  });
  
  // Response logging
  app.addHook('onResponse', async (request, reply) => {
    request.log.info(
      { statusCode: reply.statusCode, responseTime: reply.elapsedTime },
      'Request completed'
    );
  });
}
