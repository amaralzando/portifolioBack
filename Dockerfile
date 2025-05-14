# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /portifolio/app

# Copia os pacotes e arquivos de configuração do backend
COPY ./backend/package*.json ./backend/tsconfig*.json ./backend/

# Copia os códigos
COPY ./core ./core
COPY ./backend ./backend

# Instala dependências do backend
WORKDIR /portifolio/app/backend
RUN npm install

# Compila o projeto
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine

WORKDIR /app

# Copia os arquivos compilados e necessários do builder
COPY --from=builder /portifolio/app/backend/dist ./dist
COPY --from=builder /portifolio/app/backend/package*.json ./

RUN npm install --only=production

# Executa a aplicação NestJS compilada
CMD ["node", "dist/backend/src/main"]


