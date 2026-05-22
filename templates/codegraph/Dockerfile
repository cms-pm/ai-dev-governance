# syntax=docker/dockerfile:1.7

ARG NODE_IMAGE=node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293

FROM ${NODE_IMAGE} AS deps
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

FROM deps AS build
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM ${NODE_IMAGE} AS runtime-deps
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts \
  && npm cache clean --force

FROM ${NODE_IMAGE} AS runtime
WORKDIR /app
ENV NODE_ENV=production \
    NODE_OPTIONS=--disable-proto=delete

RUN addgroup -S -g 10001 codegraph \
  && adduser -S -D -H -u 10001 -G codegraph codegraph

COPY --from=runtime-deps --chown=10001:10001 /app/package.json ./package.json
COPY --from=runtime-deps --chown=10001:10001 /app/package-lock.json ./package-lock.json
COPY --from=runtime-deps --chown=10001:10001 /app/node_modules ./node_modules
COPY --from=build --chown=10001:10001 /src/dist ./dist

USER 10001:10001
ENTRYPOINT ["node", "/app/dist/bin/codegraph.js"]
