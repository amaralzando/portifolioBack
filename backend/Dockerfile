# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copia os pacotes do backend e core
COPY ./backend/package*.json ./backend/tsconfig*.json ./
COPY ./core ./core
COPY ./backend ./backend

# Instala as dependências (inclusive para monorepo ou refs locais)
RUN npm install

# Compila o projeto
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine

WORKDIR /app

# Copia apenas os arquivos compilados e necessários
COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/backend/package*.json ./

RUN npm install --only=production

CMD ["node", "dist/backend/src/main"]
