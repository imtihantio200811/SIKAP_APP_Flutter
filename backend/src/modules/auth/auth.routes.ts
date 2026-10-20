import { Router } from 'express';
import { rateLimit } from 'express-rate-limit';
import { authenticate } from '../../middleware/authenticate.js';
import { asyncHandler } from '../../lib/async-handler.js';
import { loginSchema, registerSchema } from './auth.schemas.js';
import { getCurrentUser, login, register } from './auth.service.js';

export const authRouter = Router();

const authRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: {
    error: { code: 'RATE_LIMITED', message: 'Terlalu banyak percobaan autentikasi.' },
  },
});

authRouter.post(
  '/register',
  authRateLimit,
  asyncHandler(async (request, response) => {
    const input = registerSchema.parse(request.body);
    const user = await register(input);
    response.status(201).json({ data: user });
  }),
);

authRouter.post(
  '/login',
  authRateLimit,
  asyncHandler(async (request, response) => {
    const input = loginSchema.parse(request.body);
    response.json({ data: await login(input) });
  }),
);

authRouter.get(
  '/me',
  authenticate,
  asyncHandler(async (request, response) => {
    response.json({ data: await getCurrentUser(request.auth!.userId) });
  }),
);
