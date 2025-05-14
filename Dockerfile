# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /portifolio/app

# Copia pacotes e tsconfig
COPY backend/package*.json backend/tsconfig*.json ./backend/

# Copia o código
COPY core ./core
COPY backend ./backend

# Instala dependências do backend
WORKDIR /portifolio/app/backend
RUN npm install

# Gera os arquivos do Prisma Client
RUN npx prisma generate

# Compila o projeto NestJS
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine

WORKDIR /app

# Copia os arquivos compilados e necessários
COPY --from=builder /portifolio/app/backend/dist ./dist
COPY --from=builder /portifolio/app/backend/package*.json ./
COPY --from=builder /portifolio/app/backend/node_modules ./node_modules
COPY --from=builder /portifolio/app/backend/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /portifolio/app/backend/prisma ./prisma

# ⬇️ Copia o arquivo .env do backend
# COPY backend/.env .env

RUN npm install --only=production

# ⬅️ Porta corrigida para garantir o funcionamento com Coolify ou Docker local
ENV PORT=4001

# Executa a aplicação NestJS
CMD ["node", "dist/backend/src/main"]
