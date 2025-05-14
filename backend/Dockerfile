# Stage 1 - Builder
FROM node:20-alpine as builder

ENV NODE_ENV=build

WORKDIR /portifolio/backend/app

# Copy package files first for better caching
COPY --chown=node:node package*.json ./
RUN npm ci

# Copy remaining files
COPY --chown=node:node . .

# Build application
RUN npx prisma generate && npm run build

# Stage 2 - Production
FROM node:20-alpine

ENV NODE_ENV=production
EXPOSE 4001

WORKDIR /home/gasa/portifolio/backend

COPY --from=builder --chown=node:node /home/gasa/portifolio/backend/node_modules ./node_modules
COPY --from=builder --chown=node:node /home/gasa/portifolio/backend/dist ./dist
COPY --from=builder --chown=node:node /home/gasa/portifolio/backend/package*.json ./

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:3000/api/health || exit 1

CMD ["node", "dist/backend/src/main.js"]