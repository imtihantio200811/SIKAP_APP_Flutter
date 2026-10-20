import { Router } from 'express';
import { rateLimit } from 'express-rate-limit';
import { z } from 'zod';
import { authenticate } from '../../middleware/authenticate.js';
import { asyncHandler } from '../../lib/async-handler.js';
import { analyzeRequestSchema } from './analysis.schemas.js';
import {
  analyzeContent,
  analyzeGuestContent,
  getAnalysis,
  getHistory,
  getPerspectives,
} from './analysis.service.js';

export const analyzeRouter = Router();
export const guestAnalyzeRouter = Router();
export const historyRouter = Router();
export const analysisRouter = Router();

const analysisRateLimit = rateLimit({
  windowMs: 60 * 1000,
  limit: 10,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: {
    error: { code: 'RATE_LIMITED', message: 'Batas analisis tercapai. Coba lagi nanti.' },
  },
});

const guestAnalysisRateLimit = rateLimit({
  windowMs: 60 * 1000,
  limit: 5,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: {
    error: {
      code: 'RATE_LIMITED',
      message: 'Batas analisis lokal tercapai. Coba lagi dalam satu menit.',
    },
  },
});

const idSchema = z.string().uuid();

guestAnalyzeRouter.post(
  '/',
  guestAnalysisRateLimit,
  asyncHandler(async (request, response) => {
    const input = analyzeRequestSchema.parse(request.body);
    const result = await analyzeGuestContent(input);
    response.json(result);
  }),
);

analyzeRouter.use(authenticate);
historyRouter.use(authenticate);
analysisRouter.use(authenticate);

analyzeRouter.post(
  '/',
  analysisRateLimit,
  asyncHandler(async (request, response) => {
    const input = analyzeRequestSchema.parse(request.body);
    const result = await analyzeContent(request.auth!.userId, input);
    if (result.status === 'IGNORED_NON_POLITICAL') {
      response.status(200).json(result);
      return;
    }
    response.status(201).json({ data: result.data });
  }),
);

historyRouter.get(
  '/',
  asyncHandler(async (request, response) => {
    response.json({ data: await getHistory(request.auth!.userId) });
  }),
);

analysisRouter.get(
  '/:id/perspectives',
  asyncHandler(async (request, response) => {
    const id = idSchema.parse(request.params.id);
    response.json({
      data: await getPerspectives(request.auth!.userId, id),
    });
  }),
);

analysisRouter.get(
  '/:id',
  asyncHandler(async (request, response) => {
    const id = idSchema.parse(request.params.id);
    response.json({ data: await getAnalysis(request.auth!.userId, id) });
  }),
);
