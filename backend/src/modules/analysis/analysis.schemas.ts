import { z } from 'zod';
import { env } from '../../config/env.js';

export const analyzeRequestSchema = z
  .object({
    text: z.string().trim().max(20_000).optional(),
    url: z.string().trim().url().max(2048).optional(),
  })
  .superRefine((input, context) => {
    const text = input.text?.trim();
    const url = input.url?.trim();
    if (!text && !url) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'Isi teks atau URL konten yang akan dianalisis.',
        path: ['text'],
      });
    }
    if (text && text.length < env.ANALYSIS_MIN_TEXT_LENGTH) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: `Teks harus memiliki minimal ${env.ANALYSIS_MIN_TEXT_LENGTH} karakter.`,
        path: ['text'],
      });
    }
    if (url) {
      const parsedUrl = new URL(url);
      if (parsedUrl.protocol !== 'https:') {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'URL harus menggunakan HTTPS.',
          path: ['url'],
        });
      }
      if (parsedUrl.username || parsedUrl.password) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'URL tidak boleh memuat kredensial.',
          path: ['url'],
        });
      }
    }
  });

const perspectiveSchema = z.object({
  pro: z.string().trim().min(1).max(2000),
  contra: z.string().trim().min(1).max(2000),
});

const referenceSchema = z.object({
  source_name: z.string().trim().min(1).max(300),
  url_or_description: z.string().trim().min(1).max(2048),
});

export const aiAnalysisSchema = z.object({
  badge: z.enum(['MERAH', 'KUNING', 'HIJAU']),
  confidence_score: z.number().min(0).max(1),
  title_analysis: z.string().trim().min(1).max(300),
  summary: z.string().trim().min(1).max(3000),
  key_arguments: z.array(z.string().trim().min(1).max(1500)).max(12).optional(),
  key_findings: z.array(z.string().trim().min(1).max(1500)).max(12),
  is_political: z.literal(true),
  perspectives: perspectiveSchema,
  fact_check_references: z.array(referenceSchema).max(15),
  user_guidance: z.string().trim().min(1).max(2000),
}).strict();

const geminiAnalysisFields = {
  confidence_score: z.number().min(0).max(1),
  title_analysis: z.string().trim().min(1).max(300),
  summary: z.string().trim().min(1).max(3000),
  key_arguments: z.array(z.string().trim().min(1).max(1500)).max(12),
  key_findings: z.array(z.string().trim().min(1).max(1500)).max(12),
  perspectives: perspectiveSchema,
  fact_check_references: z.array(referenceSchema).max(15),
  user_guidance: z.string().trim().min(1).max(2000),
} as const;

export const geminiAnalysisSchema = z.discriminatedUnion('is_political', [
  z.object({
    ...geminiAnalysisFields,
    badge: z.enum(['MERAH', 'KUNING', 'HIJAU']),
    is_political: z.literal(true),
  }).strict(),
  z.object({
    ...geminiAnalysisFields,
    badge: z.null(),
    is_political: z.literal(false),
    summary: z.literal('Tidak ada konten politik yang terdeteksi.'),
    key_arguments: z.array(z.never()).length(0),
    key_findings: z.array(z.never()).length(0),
  }).strict(),
]);

export type AnalyzeRequest = z.infer<typeof analyzeRequestSchema>;
export type AiAnalysis = z.infer<typeof aiAnalysisSchema>;
export type GeminiAnalysis = z.infer<typeof geminiAnalysisSchema>;
