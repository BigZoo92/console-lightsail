FROM node:18 AS builder

WORKDIR /app

COPY pnpm-lock.yaml ./
RUN npm install -g pnpm
COPY package.json ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

FROM nginx:stable

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
