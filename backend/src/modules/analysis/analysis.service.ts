import { Prisma } from '../../generated/prisma/client.js';
import { prisma } from '../../db/prisma.js';
import { ApiError } from '../../lib/api-error.js';
import { analyzeWithGemini } from './gemini.service.js';
import {
  aiAnalysisSchema,
  type AnalyzeRequest,
} from './analysis.schemas.js';

export async function analyzeContent(userId: string, input: AnalyzeRequest) {
  const aiAnalysis = await analyzeWithGemini(input);
  if (!aiAnalysis.is_political) {
    return {
      status: 'IGNORED_NON_POLITICAL' as const,
      is_political: false as const,
      trigger_toast: true as const,
      toast_message: 'Tidak ada konten politik yang terdeteksi pada halaman ini.',
      data: null,
    };
  }

  const record = await prisma.analysisHistory.create({
    data: {
      userId,
      inputText: input.text ?? null,
      inputUrl: input.url ?? null,
      badge: aiAnalysis.badge,
      summary: aiAnalysis.summary,
      aiAnalysis: aiAnalysis as Prisma.InputJsonValue,
    },
  });
  return { status: 'ANALYZED' as const, data: record };
}

export async function analyzeGuestContent(input: AnalyzeRequest) {
  const aiAnalysis = await analyzeWithGemini(input);
  if (!aiAnalysis.is_political) {
    return {
      status: 'IGNORED_NON_POLITICAL' as const,
      is_political: false as const,
      trigger_toast: true as const,
      toast_message: 'Tidak ada konten politik yang terdeteksi pada halaman ini.',
      data: null,
    };
  }

  return {
    status: 'ANALYZED' as const,
    data: {
      inputText: input.text ?? null,
      inputUrl: input.url ?? null,
      aiAnalysis,
    },
  };
}

export async function getHistory(userId: string) {
  return prisma.analysisHistory.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
    take: 100,
    select: {
      id: true,
      inputText: true,
      inputUrl: true,
      badge: true,
      summary: true,
      createdAt: true,
    },
  });
}

export async function getAnalysis(userId: string, analysisId: string) {
  const analysis = await prisma.analysisHistory.findFirst({
    where: { id: analysisId, userId },
  });
  if (!analysis) {
    throw new ApiError(404, 'Hasil analisis tidak ditemukan.', 'ANALYSIS_NOT_FOUND');
  }
  return analysis;
}

export async function getPerspectives(userId: string, analysisId: string) {
  const analysis = await getAnalysis(userId, analysisId);
  if (analysis.badge !== 'KUNING') {
    throw new ApiError(
      409,
      'Perspektif hanya tersedia untuk hasil berlencana KUNING.',
      'PERSPECTIVES_NOT_AVAILABLE',
    );
  }
  const result = aiAnalysisSchema.parse(analysis.aiAnalysis);
  return {
    analysisId: analysis.id,
    perspectives: result.perspectives,
  };
}
