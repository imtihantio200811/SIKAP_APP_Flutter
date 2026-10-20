process.env.NODE_ENV ??= 'test';
process.env.PORT ??= '3000';
process.env.DATABASE_URL ??=
  'postgresql://sikap:sikap@localhost:5432/sikap?schema=public';
process.env.JWT_SECRET ??=
  'test-secret-that-is-long-enough-for-jwt-signatures';
process.env.GEMINI_API_KEY ??= 'test-gemini-key';
process.env.GEMINI_MODEL ??= 'gemini-2.5-flash';
process.env.ANALYSIS_MIN_TEXT_LENGTH ??= '40';
