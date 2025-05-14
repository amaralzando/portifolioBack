# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /portifolio

# Copia pacotes e tsconfig do backend
COPY app/package*.json app/tsconfig*.json ./app/

# Copia o código-fonte
COPY core ./core
COPY app ./app

# Instala dependências do backend
WORKDIR /portifolio/app
RUN npm install

# Gera os arquivos do Prisma Client
RUN npx prisma generate

# Compila o projeto NestJS
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine

WORKDIR /portifolio/app

# Copia os arquivos compilados e necessários
COPY --from=builder /portifolio/app/dist ./dist
COPY --from=builder /portifolio/app/package*.json ./
COPY --from=builder /portifolio/app/node_modules ./node_modules
COPY --from=builder /portifolio/app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /portifolio/app/prisma ./prisma

# (Opcional) Copiar o .env se necessário
# COPY app/.env .env

RUN npm install --only=production

ENV PORT=4001

CMD ["node", "dist/backend/src/main"]
