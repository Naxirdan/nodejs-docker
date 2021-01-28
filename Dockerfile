FROM alpine:3.12.3

ARG NVM_VERSION=v0.37.2

ARG NPM_VERSION=14.15.1

ARG HOME_DIR="/home/node"

ARG APP_DIR="/home/node/app"

RUN addgroup -S node && adduser -S node -G node

RUN apk add nodejs -U curl \
bash \
ca-certificates \
openssl \
ncurses \
coreutils \
python2 \
make \
gcc \
g++ \
libgcc \
linux-headers \
grep \
util-linux \
binutils \
findutils 

USER node

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

RUN chown -R node:node ${HOME_DIR}

RUN mkdir ${APP_DIR}

WORKDIR ${HOME_DIR}

COPY --chown=node:node ./app/package-lock.json ./app/package.json ./app/

COPY --chown=node:node .bashrc node_init.sh ${HOME_DIR}/

RUN chmod ugo+x ${HOME_DIR}/.bashrc ${HOME_DIR}/node_init.sh

COPY --chown=node:node . .

ENTRYPOINT ["bash", "node_init.sh"]