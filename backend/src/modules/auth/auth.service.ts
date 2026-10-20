import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import type { User } from '../../generated/prisma/client.js';
import { env } from '../../config/env.js';
import { prisma } from '../../db/prisma.js';
import { ApiError } from '../../lib/api-error.js';
import type { LoginInput, RegisterInput } from './auth.schemas.js';

const passwordRounds = 12;

export async function register(input: RegisterInput) {
  const email = input.email.toLowerCase();
  const existingUser = await prisma.user.findUnique({ where: { email } });
  if (existingUser) {
    throw new ApiError(409, 'Email sudah terdaftar.', 'EMAIL_ALREADY_EXISTS');
  }

  const password = await bcrypt.hash(input.password, passwordRounds);
  const user = await prisma.user.create({
    data: { nama: input.nama, email, password },
    select: { id: true, nama: true, email: true, createdAt: true },
  });
  return user;
}

export async function login(input: LoginInput) {
  const user = await prisma.user.findUnique({
    where: { email: input.email.toLowerCase() },
  });
  const passwordMatches = user
    ? await bcrypt.compare(input.password, user.password)
    : false;

  if (!user || !passwordMatches) {
    throw new ApiError(401, 'Email atau kata sandi salah.', 'INVALID_CREDENTIALS');
  }

  return {
    token: createAccessToken(user),
    user: publicUser(user),
  };
}

export async function getCurrentUser(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { id: true, nama: true, email: true, createdAt: true },
  });
  if (!user) {
    throw new ApiError(401, 'Sesi pengguna tidak lagi berlaku.', 'USER_NOT_FOUND');
  }
  return user;
}

function createAccessToken(user: Pick<User, 'id' | 'email'>) {
  return jwt.sign({ email: user.email }, env.JWT_SECRET, {
    subject: user.id,
    expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'],
    issuer: 'sikap-api',
    audience: 'sikap-client',
  });
}

function publicUser(user: User) {
  return {
    id: user.id,
    nama: user.nama,
    email: user.email,
    createdAt: user.createdAt,
  };
}
