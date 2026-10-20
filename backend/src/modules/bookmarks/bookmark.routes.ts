import { Router } from 'express';
import { z } from 'zod';
import { prisma } from '../../db/prisma.js';
import { authenticate } from '../../middleware/authenticate.js';
import { asyncHandler } from '../../lib/async-handler.js';
import { ApiError } from '../../lib/api-error.js';

export const bookmarkRouter = Router();
const bookmarkInputSchema = z.object({ analysis_id: z.string().uuid() });

bookmarkRouter.use(authenticate);

bookmarkRouter.get(
  '/',
  asyncHandler(async (request, response) => {
    const bookmarks = await prisma.bookmark.findMany({
      where: { userId: request.auth!.userId },
      orderBy: { createdAt: 'desc' },
      include: {
        analysis: {
          select: {
            id: true,
            badge: true,
            summary: true,
            inputText: true,
            inputUrl: true,
            createdAt: true,
          },
        },
      },
    });
    response.json({ data: bookmarks });
  }),
);

bookmarkRouter.post(
  '/',
  asyncHandler(async (request, response) => {
    const { analysis_id: analysisId } = bookmarkInputSchema.parse(request.body);
    const userId = request.auth!.userId;
    const analysis = await prisma.analysisHistory.findFirst({
      where: { id: analysisId, userId },
      select: { id: true },
    });
    if (!analysis) {
      throw new ApiError(404, 'Hasil analisis tidak ditemukan.', 'ANALYSIS_NOT_FOUND');
    }

    const bookmark = await prisma.bookmark.upsert({
      where: { userId_analysisId: { userId, analysisId } },
      create: { userId, analysisId },
      update: {},
    });
    response.status(201).json({ data: bookmark });
  }),
);

bookmarkRouter.delete(
  '/:analysisId',
  asyncHandler(async (request, response) => {
    const analysisId = z.string().uuid().parse(request.params.analysisId);
    await prisma.bookmark.deleteMany({
      where: { userId: request.auth!.userId, analysisId },
    });
    response.status(204).send();
  }),
);
