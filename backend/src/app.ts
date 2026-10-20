import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import { pinoHttp } from 'pino-http';
import { corsOrigins, env } from './config/env.js';
import { logger } from './config/logger.js';
import { errorHandler } from './middleware/error-handler.js';
import {
  analysisRouter,
  analyzeRouter,
  guestAnalyzeRouter,
  historyRouter,
} from './modules/analysis/analysis.routes.js';
import { authRouter } from './modules/auth/auth.routes.js';
import { bookmarkRouter } from './modules/bookmarks/bookmark.routes.js';

export const app = express();

app.disable('x-powered-by');
app.use(helmet());
app.use(
  cors({
    origin(origin, callback) {
      if (
        !origin ||
        corsOrigins.includes(origin) ||
        (env.NODE_ENV !== 'production' && corsOrigins.length === 0)
      ) {
        callback(null, true);
        return;
      }
      callback(new Error('Origin is not allowed by CORS.'));
    },
  }),
);
app.use(express.json({ limit: '64kb' }));
app.use(pinoHttp({ logger }));

app.get('/health', (_request, response) => {
  response.json({ status: 'ok', environment: env.NODE_ENV });
});
app.use('/api/auth', authRouter);
app.use('/api/analyze/guest', guestAnalyzeRouter);
app.use('/api/analyze', analyzeRouter);
app.use('/api/history', historyRouter);
app.use('/api/analysis', analysisRouter);
app.use('/api/bookmarks', bookmarkRouter);

app.use((_request, response) => {
  response.status(404).json({
    error: { code: 'NOT_FOUND', message: 'Endpoint tidak ditemukan.' },
  });
});
app.use(errorHandler);
