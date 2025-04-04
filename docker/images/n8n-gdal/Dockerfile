FROM paschendale/n8n:latest-bookworm AS builder

USER root

# Install gdal
RUN echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends \
        gdal-bin 

RUN ogrinfo --version

# Instal mb-util
RUN apt-get -y update && \
    apt-get install -y --fix-missing python3-pip python3-venv vim proj-bin && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install rasterio rio-rgbify rio-mbtiles mbutil numpy==1.26.4

ENV PATH="/opt/venv/bin:$PATH"
