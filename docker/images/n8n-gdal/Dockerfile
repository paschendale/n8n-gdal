FROM paschendale/n8n:latest-bookworm AS builder

USER root

RUN echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends \
        gdal-bin

RUN ogrinfo --version