-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "Badge" AS ENUM ('MERAH', 'KUNING', 'HIJAU');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "nama" VARCHAR(120) NOT NULL,
    "email" VARCHAR(320) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "analysis_history" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "input_text" TEXT,
    "input_url" VARCHAR(2048),
    "badge" "Badge" NOT NULL,
    "summary" TEXT NOT NULL,
    "ai_analysis" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "analysis_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bookmarks" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "analysis_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bookmarks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "analysis_history_user_id_created_at_idx" ON "analysis_history"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "bookmarks_user_id_created_at_idx" ON "bookmarks"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "bookmarks_user_id_analysis_id_key" ON "bookmarks"("user_id", "analysis_id");

-- AddForeignKey
ALTER TABLE "analysis_history" ADD CONSTRAINT "analysis_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookmarks" ADD CONSTRAINT "bookmarks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookmarks" ADD CONSTRAINT "bookmarks_analysis_id_fkey" FOREIGN KEY ("analysis_id") REFERENCES "analysis_history"("id") ON DELETE CASCADE ON UPDATE CASCADE;
