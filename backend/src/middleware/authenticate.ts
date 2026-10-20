import type { RequestHandler } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';
import { ApiError } from '../lib/api-error.js';

interface AccessTokenClaims extends jwt.JwtPayload {
  email: string;
}

export const authenticate: RequestHandler = (request, _response, next) => {
  const authorization = request.header('authorization');
  const [scheme, token] = authorization?.split(' ') ?? [];

  if (scheme !== 'Bearer' || !token) {
    return next(new ApiError(401, 'Bearer token diperlukan.', 'UNAUTHORIZED'));
  }

  try {
    const claims = jwt.verify(token, env.JWT_SECRET, {
      issuer: 'sikap-api',
      audience: 'sikap-client',
    });
    if (
      typeof claims === 'string' ||
      typeof claims.sub !== 'string' ||
      typeof (claims as AccessTokenClaims).email !== 'string'
    ) {
      return next(new ApiError(401, 'Token tidak valid.', 'INVALID_TOKEN'));
    }
    request.auth = {
      userId: claims.sub,
      email: (claims as AccessTokenClaims).email,
    };
    next();
  } catch {
    next(new ApiError(401, 'Token tidak valid atau kedaluwarsa.', 'INVALID_TOKEN'));
  }
};
