FROM node:26.11.1-alpine3.24@sha256:143494b1da2945f061539253adc65e4f1569ddf07da2d384c022c791a9d90a4a
MAINTAINER Usacloud Members<sacloud.users@gmail.com>

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

ENV PATH="/app/node_modules/.bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
