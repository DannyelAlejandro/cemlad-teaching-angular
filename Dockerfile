# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM node:24-alpine AS builder

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# ── Stage 2: Runner ──────────────────────────────────────────────────────────
FROM node:24-alpine AS runner

WORKDIR /app

# La build de Angular (esbuild) produce un bundle autocontenido.
# Solo necesitamos el output de dist/.
COPY --from=builder /app/dist ./dist

EXPOSE 4000

ENV PORT=4000

CMD ["node", "dist/learning-angular/server/server.mjs"]
