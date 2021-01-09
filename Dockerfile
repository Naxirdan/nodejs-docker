FROM alpine:3.12.3

LABEL authors="Adrian Cejudo Garcia" issues="https://github.com/Naxirdan/nodejs-docker/issues" 

ENV NODE_VERSION="v14.15.4" PYTHON_VERSION="python3"

RUN apk upgrade --no-cache -U && \
  apk add --no-cache curl make gcc g++ ${PYTHON_VERSION} linux-headers binutils-gold gnupg libstdc++

RUN curl -sfSLO https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz && \
  tar -xf node-${NODE_VERSION}.tar.gz && \
  cd node-${NODE_VERSION} && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  make -j$(getconf _NPROCESSORS_ONLN) && \
  make install

RUN apk del curl make gcc g++ ${NODE_BUILD_PYTHON} linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  rm -rf ${RM_DIRS} /node-${NODE_VERSION}* /SHASUMS256.txt /tmp/* \
    /usr/share/man/* /usr/share/doc /root/.npm /root/.node-gyp /root/.config \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/docs \
    /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  { rm -rf /root/.gnupg || true; }

RUN addgroup -S node && adduser -S node -G node

USER node

RUN mkdir /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node ./app/package-lock.json ./app/package.json ./

RUN npm ci

COPY --chown=node:node . .

EXPOSE 9000

CMD ["node", "index.js"]