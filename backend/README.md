# SIKAP Backend

Modular REST API built with Node.js 20+, Express 5, TypeScript, PostgreSQL, Prisma, JWT, and the official `@google/generative-ai` SDK.

## Structure

```text
backend/
  prisma/
    schema.prisma
    migrations/
  src/
    config/       environment and logger
    db/           Prisma client
    lib/          API error and async handler
    middleware/   JWT authentication and error handling
    modules/
      auth/       registration, login, current-user routes
      analysis/   input validation, Gemini, history, result details
      bookmarks/  save, list, remove bookmarks
    app.ts
    server.ts
  test/
```

## Run locally

1. Install Node.js 20.19 or newer.
2. Copy `.env.example` to `.env`, set `DATABASE_URL`, a random `JWT_SECRET` of at least 32 characters, and `GEMINI_API_KEY`. The local-login analysis route needs the Gemini key; it does not connect to PostgreSQL.
3. Install and generate the ORM client, then start the API:

   ```sh
   npm install
   npm run db:generate
   npm run dev
   ```

For account-based history, install/start PostgreSQL and run `npm run db:deploy`
before starting the API.

4. Build/start:

   ```sh
   npm run build
   npm start
   ```

The default API port is `3000`; use `GET /health` for a health check.

## API

All responses are JSON. Protected routes require `Authorization: Bearer <JWT>`.

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/api/auth/register` | No | Create a user with a bcrypt-hashed password |
| POST | `/api/auth/login` | No | Validate credentials and return `{ token, user }` |
| GET | `/api/auth/me` | Yes | Return the authenticated user |
| POST | `/api/analyze` | Yes | Analyze `{ "text": "...", "url": "https://..." }` and persist the result |
| POST | `/api/analyze/guest` | No | Analyze local-session text or URLs without saving results (5 requests/minute per IP) |
| GET | `/api/history` | Yes | Return the latest 100 results for this user |
| GET | `/api/analysis/:id` | Yes | Return one result owned by this user |
| GET | `/api/analysis/:id/perspectives` | Yes | Return perspectives when the result badge is `KUNING` |
| GET | `/api/bookmarks` | Yes | Return the user's bookmarked analyses |
| POST | `/api/bookmarks` | Yes | Idempotently save `{ "analysis_id": "uuid" }` |
| DELETE | `/api/bookmarks/:analysisId` | Yes | Remove a bookmark |

`text` is optional when an HTTPS URL is supplied. If provided, it must have at least `ANALYSIS_MIN_TEXT_LENGTH` characters (40 by default). This service does not download user-provided URLs itself, avoiding an SSRF-capable endpoint. The URL is submitted as untrusted context to Gemini with Google Search grounding enabled; URL-only analyses may be classified `KUNING` when evidence cannot be assessed.

`POST /api/analyze/guest` is intended for the local-login mobile demo. It runs
the same analysis without JWT authentication or database persistence and is
limited to five requests per minute per IP. Add an API gateway or equivalent
abuse protection before exposing this endpoint publicly.

For political content, the analysis response includes `id`, `badge` (`MERAH`, `KUNING`, `HIJAU`), `summary`, `aiAnalysis`, and timestamps. `aiAnalysis` includes `badge`, `confidence_score` (0–1), `title_analysis`, `summary`, `key_arguments`, `key_findings`, `is_political`, `perspectives` (`pro` / `contra`), `fact_check_references`, and `user_guidance`. Gemini Structured Output constrains the generated JSON; the backend parses and validates it again before storing it. For non-political content, the endpoint returns HTTP 200 with `{ "status": "IGNORED_NON_POLITICAL", "is_political": false, "trigger_toast": true, "toast_message": "Tidak ada konten politik yang terdeteksi pada halaman ini.", "data": null }`; it does not create an analysis history record. In that response Gemini must also return `badge: null`, `key_arguments: []`, and the summary `Tidak ada konten politik yang terdeteksi.`.

The Gemini system instruction treats submitted content as untrusted data, requires evidence-based neutral classification, and tells the model not to invent references. Civic-integrity blocking is disabled so political content can be assessed; other safety categories block only high-severity content. The URL is passed to Gemini as analysis context; this API does not download user-provided URLs itself. Treat AI output as advisory and show evidence/uncertainty to users.

## Security notes

- Passwords use bcrypt with 12 rounds; passwords are never returned.
- JWTs are short-lived (one day by default), signed using `JWT_SECRET`, and validated by `authenticate`.
- History and bookmark queries are always scoped to the caller's user ID.
- The analysis endpoint is rate-limited, body sizes are bounded, and response headers use Helmet.
- The Gemini API key is read only from the server environment and is never sent to clients.
- CORS can be restricted with a comma-separated `CORS_ORIGINS` list.

Register does not include OTP; add an email delivery/provider and a verification-token model before enabling email verification in production.
