FROM node:26.10.0-alpine3.24@sha256:0b36e8c136b94cd4fcf02188228e76c31ad5872eef3fec8cbd2eee500cfd9e80
MAINTAINER Usacloud Members<sacloud.users@gmail.com>

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

ENV PATH="/app/node_modules/.bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
