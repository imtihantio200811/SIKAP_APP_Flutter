import type { ErrorRequestHandler } from 'express';
import { Prisma } from '../generated/prisma/client.js';
import { ZodError } from 'zod';
import { logger } from '../config/logger.js';
import { ApiError } from '../lib/api-error.js';

export const errorHandler: ErrorRequestHandler = (
  error: unknown,
  request,
  response,
  _next,
) => {
  if (error instanceof ApiError) {
    response.status(error.statusCode).json({
      error: { code: error.code, message: error.message },
    });
    return;
  }

  if (error instanceof ZodError) {
    response.status(400).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Data request tidak valid.',
        details: error.issues.map((issue) => ({
          field: issue.path.join('.'),
          message: issue.message,
        })),
      },
    });
    return;
  }

  if (
    typeof error === 'object' &&
    error !== null &&
    'type' in error &&
    error.type === 'entity.parse.failed'
  ) {
    response.status(400).json({
      error: { code: 'INVALID_JSON', message: 'Body request bukan JSON valid.' },
    });
    return;
  }
  if (
    typeof error === 'object' &&
    error !== null &&
    'type' in error &&
    error.type === 'entity.too.large'
  ) {
    response.status(413).json({
      error: { code: 'PAYLOAD_TOO_LARGE', message: 'Body request terlalu besar.' },
    });
    return;
  }

  if (
    error instanceof Prisma.PrismaClientKnownRequestError &&
    error.code === 'P2002'
  ) {
    response.status(409).json({
      error: { code: 'CONFLICT', message: 'Data sudah terdaftar.' },
    });
    return;
  }

  logger.error(
    { err: error, method: request.method, path: request.path },
    'Unhandled request error',
  );
  response.status(500).json({
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'Terjadi kesalahan internal.',
    },
  });
};
