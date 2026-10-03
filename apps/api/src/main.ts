import Fastify from 'fastify';
import { config } from './config/index.js';
import { registerPlugins } from './plugins/index.js';
import { registerRoutes } from './routes/index.js';

const app = Fastify({
  logger: {
    level: config.logLevel,
    transport: config.nodeEnv === 'development' ? {
      target: 'pino-pretty',
      options: { colorize: true },
    } : undefined,
  },
});

async function start() {
  try {
    await registerPlugins(app);
    await registerRoutes(app);
    
    await app.listen({ port: config.port, host: config.host });
    console.log(`🚀 Server running at http://${config.host}:${config.port}`);
    console.log(`📚 API docs at http://${config.host}:${config.port}/docs`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

start();