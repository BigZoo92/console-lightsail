FROM node:18-alpine AS builder
WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN npm install -g pnpm && pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build

FROM nginx:stable
WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist .

# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
