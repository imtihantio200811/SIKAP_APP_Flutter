import { z } from 'zod';

export const registerSchema = z.object({
  nama: z.string().trim().min(2).max(120),
  email: z.string().trim().email().max(320),
  password: z
    .string()
    .min(10)
    .max(72)
    .refine(
      (password) => Buffer.byteLength(password, 'utf8') <= 72,
      'Kata sandi tidak boleh melebihi 72 byte.',
    ),
});

const loginPasswordSchema = z
  .string()
  .min(1)
  .max(72)
  .refine(
    (password) => Buffer.byteLength(password, 'utf8') <= 72,
    'Kata sandi tidak boleh melebihi 72 byte.',
  );

export const loginSchema = z.object({
  email: z.string().trim().email().max(320),
  password: loginPasswordSchema,
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
