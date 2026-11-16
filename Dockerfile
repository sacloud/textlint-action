FROM node:26.13.0-alpine3.24@sha256:8996bb5821d62a8fd9bb27c1cb07462f3fdce6e47d640c6a881ead0b064ce216
MAINTAINER Usacloud Members<sacloud.users@gmail.com>

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

ENV PATH="/app/node_modules/.bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
