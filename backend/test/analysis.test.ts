import jwt from 'jsonwebtoken';
import { HarmBlockThreshold, HarmCategory } from '@google/generative-ai';
import request from 'supertest';
import { afterEach, describe, expect, it, vi } from 'vitest';

const { analyzeWithGeminiMock } = vi.hoisted(() => ({
  analyzeWithGeminiMock: vi.fn(),
}));

vi.mock('../src/modules/analysis/gemini.service.js', async (importOriginal) => {
  const actual =
    await importOriginal<
      typeof import('../src/modules/analysis/gemini.service.js')
    >();
  return { ...actual, analyzeWithGemini: analyzeWithGeminiMock };
});

import { app } from '../src/app.js';
import { env } from '../src/config/env.js';
import { prisma } from '../src/db/prisma.js';
import {
  geminiAnalysisConfiguration,
  parseGeminiAnalysisResponse,
} from '../src/modules/analysis/gemini.service.js';

const validAnalysis = {
  badge: 'KUNING',
  confidence_score: 0.58,
  title_analysis: 'Klaim membutuhkan pemeriksaan lebih lanjut',
  summary: 'Konteks bukti belum cukup untuk memastikan klaim.',
  key_arguments: ['Dokumen primer yang mendukung klaim belum tersedia.'],
  key_findings: ['Dokumen primer yang mendukung klaim belum tersedia.'],
  is_political: true,
  perspectives: {
    pro: 'Klaim dapat dipertimbangkan jika dokumen primer mendukungnya.',
    contra: 'Belum ada bukti independen yang mengonfirmasi klaim tersebut.',
  },
  fact_check_references: [],
  user_guidance: 'Cari dokumen primer sebelum menyebarkan klaim.',
};

afterEach(() => {
  vi.clearAllMocks();
});

describe('Gemini analysis service', () => {
  it('uses structured JSON output, political-safe settings, and the configured model', () => {
    expect(geminiAnalysisConfiguration.modelName).toBe('gemini-2.5-flash');
    expect(geminiAnalysisConfiguration.generationConfig.responseMimeType).toBe(
      'application/json',
    );
    expect(geminiAnalysisConfiguration.safetySettings).toHaveLength(5);
    expect(
      geminiAnalysisConfiguration.safetySettings.find(
        (setting) =>
          setting.category === HarmCategory.HARM_CATEGORY_CIVIC_INTEGRITY,
      )?.threshold,
    ).toBe(HarmBlockThreshold.BLOCK_NONE);
    expect(geminiAnalysisConfiguration.systemInstruction).toContain(
      'Anda adalah SIKAP AI',
    );
    expect(geminiAnalysisConfiguration.systemInstruction).toContain(
      'Jika teks merupakan percakapan biasa',
    );
  });

  it('parses structured model output and accepts a JSON markdown fence', () => {
    const result = parseGeminiAnalysisResponse(
      `\`\`\`json\n${JSON.stringify(validAnalysis)}\n\`\`\``,
    );

    expect(result.badge).toBe('KUNING');
    expect(result.confidence_score).toBe(0.58);
    expect(result.perspectives.pro).toContain('dokumen primer');
  });

  it('requires the non-political response to have no badge or arguments', () => {
    const result = parseGeminiAnalysisResponse(
      JSON.stringify({
        ...validAnalysis,
        is_political: false,
        badge: null,
        summary: 'Tidak ada konten politik yang terdeteksi.',
        key_arguments: [],
        key_findings: [],
      }),
    );

    expect(result.badge).toBeNull();
    expect(result.is_political).toBe(false);
    expect(result.summary).toBe('Tidak ada konten politik yang terdeteksi.');
    expect(result.key_arguments).toEqual([]);
  });

  it('rejects malformed JSON and unsupported badge responses', () => {
    expect(() => parseGeminiAnalysisResponse('bukan json')).toThrow(
      expect.objectContaining({ code: 'AI_INVALID_JSON', statusCode: 502 }),
    );
    expect(() =>
      parseGeminiAnalysisResponse(
        JSON.stringify({ ...validAnalysis, badge: 'UNGU' }),
      ),
    ).toThrow(
      expect.objectContaining({ code: 'AI_INVALID_RESULT', statusCode: 502 }),
    );
  });
});

describe('protected analysis API', () => {
  it('returns a non-political toast response without creating history', async () => {
    const token = jwt.sign(
      { email: 'tester@example.com' },
      env.JWT_SECRET,
      {
        subject: '61ba6999-4ab8-4525-a463-ef955eb1a330',
        issuer: 'sikap-api',
        audience: 'sikap-client',
        expiresIn: '5m',
      },
    );
    const create = vi.spyOn(prisma.analysisHistory, 'create');
    analyzeWithGeminiMock.mockResolvedValue({
      badge: null,
      confidence_score: 0.95,
      title_analysis: 'Konten bukan politik',
      summary: 'Tidak ada konten politik yang terdeteksi.',
      key_arguments: [],
      key_findings: [],
      is_political: false,
      perspectives: { pro: '', contra: '' },
      fact_check_references: [],
      user_guidance: 'Konten berada di luar cakupan analisis politik SIKAP.',
    });

    const response = await request(app)
      .post('/api/analyze')
      .set('Authorization', `Bearer ${token}`)
      .send({ text: 'Diskon kuliner hari ini tersedia di pusat kota.' });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      status: 'IGNORED_NON_POLITICAL',
      is_political: false,
      trigger_toast: true,
      toast_message: 'Tidak ada konten politik yang terdeteksi pada halaman ini.',
      data: null,
    });
    expect(create).not.toHaveBeenCalled();
  });

  it('rejects requests without a bearer token', async () => {
    const response = await request(app)
      .post('/api/analyze')
      .send({ text: 'Klaim politik yang cukup panjang untuk diperiksa.' });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('UNAUTHORIZED');
  });

  it('protects history and analysis detail routes', async () => {
    const historyResponse = await request(app).get('/api/history');
    const detailResponse = await request(app).get(
      '/api/analysis/61ba6999-4ab8-4525-a463-ef955eb1a330',
    );

    expect(historyResponse.status).toBe(401);
    expect(detailResponse.status).toBe(401);
  });

  it('rejects content shorter than the configured minimum', async () => {
    const token = jwt.sign(
      { email: 'tester@example.com' },
      env.JWT_SECRET,
      {
        subject: '61ba6999-4ab8-4525-a463-ef955eb1a330',
        issuer: 'sikap-api',
        audience: 'sikap-client',
        expiresIn: '5m',
      },
    );

    const response = await request(app)
      .post('/api/analyze')
      .set('Authorization', `Bearer ${token}`)
      .send({ text: 'terlalu pendek' });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('exposes a health endpoint without requiring a database connection', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ok');
  });
});

describe('local-session analysis API', () => {
  it('analyzes content without JWT or saving it to user history', async () => {
    const create = vi.spyOn(prisma.analysisHistory, 'create');
    analyzeWithGeminiMock.mockResolvedValue({
      badge: 'KUNING',
      confidence_score: 0.58,
      title_analysis: 'Klaim membutuhkan pemeriksaan lebih lanjut',
      summary: 'Konteks bukti belum cukup untuk memastikan klaim.',
      key_arguments: ['Dokumen primer belum tersedia.'],
      key_findings: ['Dokumen primer belum tersedia.'],
      is_political: true,
      perspectives: {
        pro: 'Klaim dapat dipertimbangkan dengan bukti.',
        contra: 'Belum ada sumber independen yang mengonfirmasi klaim.',
      },
      fact_check_references: [],
      user_guidance: 'Periksa sumber primer.',
    });

    const response = await request(app)
      .post('/api/analyze/guest')
      .send({ url: 'https://example.com/politics' });

    expect(response.status).toBe(200);
    expect(response.body).toMatchObject({
      status: 'ANALYZED',
      data: {
        inputText: null,
        inputUrl: 'https://example.com/politics',
        aiAnalysis: {
          badge: 'KUNING',
          is_political: true,
        },
      },
    });
    expect(analyzeWithGeminiMock).toHaveBeenCalledWith({
      url: 'https://example.com/politics',
    });
    expect(create).not.toHaveBeenCalled();
  });

  it('requires text or a URL', async () => {
    const response = await request(app).post('/api/analyze/guest').send({});

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });
});
