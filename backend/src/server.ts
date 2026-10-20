import { app } from './app.js';
import { env } from './config/env.js';
import { logger } from './config/logger.js';
import { pool, prisma } from './db/prisma.js';

let server: ReturnType<typeof app.listen> | undefined;

async function shutdown(signal: string) {
  logger.info({ signal }, 'Shutting down SIKAP API');
  if (server) {
    await new Promise<void>((resolve, reject) => {
      server!.close((error) => (error ? reject(error) : resolve()));
    });
  }
  await prisma.$disconnect();
  await pool.end();
}

async function start() {
  await prisma.$connect();
  server = app.listen(env.PORT, () => {
    logger.info({ port: env.PORT }, 'SIKAP API listening');
  });
}

void start().catch((error: unknown) => {
  logger.fatal({ err: error }, 'Failed to start SIKAP API');
  process.exitCode = 1;
});

for (const signal of ['SIGINT', 'SIGTERM'] as const) {
  process.once(signal, () => {
    void shutdown(signal).catch((error: unknown) => {
      logger.error({ err: error, signal }, 'Graceful shutdown failed');
      process.exitCode = 1;
    });
  });
}
