FROM node:24.21.0-alpine3.24@sha256:ebfe2f90462722a7a4de65e91990e97fe0d401c70e0e762c5b53302f905ec1c1
MAINTAINER Usacloud Members<sacloud.users@gmail.com>

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

ENV PATH="/app/node_modules/.bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
