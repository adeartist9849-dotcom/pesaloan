# API Dockerfile
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat openssl
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./
COPY apps/api/package.json apps/api/package-lock.json* ./apps/api/
COPY packages/shared/package.json packages/shared/package-lock.json* ./packages/shared/

# Install dependencies
RUN npm ci --workspace=apps/api --workspace=packages/shared

# Generate Prisma client
COPY apps/api/prisma ./apps/api/prisma
RUN cd apps/api && npx prisma generate

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build shared package first
RUN cd packages/shared && npm run build

# Build API
RUN cd apps/api && npm run build

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs

COPY --from=builder /app/apps/api/dist ./dist
COPY --from=builder /app/apps/api/node_modules ./node_modules
COPY --from=builder /app/apps/api/package.json ./package.json
COPY --from=builder /app/apps/api/prisma ./prisma
COPY --from=builder /app/packages/shared/dist ./packages/shared/dist

USER nestjs

EXPOSE 3000

CMD ["node", "dist/main.js"]