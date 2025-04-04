# 1. Use a builder step to download various dependencies
FROM qgis/qgis:3.40.5-bookworm AS builder

# Install fonts
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fontconfig \
        git \
        openssh-client \
        graphicsmagick \
        tini \
        tzdata \
        ca-certificates \
        jq \
        curl \
        libc6 && \
    fc-cache -f && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Update npm and install full-uci
COPY .npmrc /usr/local/etc/npmrc
RUN npm install -g corepack@0.31 full-icu@1.5.0

# Activate corepack, and install pnpm
WORKDIR /tmp
COPY package.json ./
RUN corepack enable && corepack prepare --activate

# Cleanup
RUN rm -rf /tmp/* /root/.npm /root/.cache/node /opt/yarn*

# 2. Start with a new clean image and copy over the added files into a single layer
FROM qgis/qgis:3.40.5-bookworm
COPY --from=builder / /

# Delete this folder to make the base image backward compatible to be able to build older version images
RUN rm -rf /tmp/v8-compile-cache*

WORKDIR /home/node
ENV NODE_ICU_DATA=/usr/local/lib/node_modules/full-icu
EXPOSE 5678/tcp
