#!/bin/sh

IMAGE=$1

if [ "$IMAGE" != "base" ] && [ "$IMAGE" != "runner" ] && [ "$IMAGE" != "geo" ]; then
  echo "ERROR: Please provide a valid image type - example: ./build-docker.sh base | ./build-docker.sh runner | ./build-docker.sh geo"
  exit 1
fi

if [ "$IMAGE" = "base" ] || [ "$IMAGE" = "runner" ] || [ "$IMAGE" = "geo" ]; then
  echo "Building n8n base image"
  docker buildx build --load --platform linux/amd64 . \
    --file ./docker/images/n8n-base/Dockerfile \
    --tag paschendale/n8n-base:20-bookworm \
    --progress plain
  docker push paschendale/n8n-base:20-bookworm
  docker push paschendale/n8n-base:20-bookworm
fi

# Get the current version from package.json
VERSION=$(grep '"version"' package.json | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[:space:]')

echo "\n#################################################################################################################################\n"

if [ "$IMAGE" = "runner" ] || [ "$IMAGE" = "geo" ]; then
  echo "Building n8n runner image for version $VERSION"  
  docker buildx build --load --platform linux/amd64 ./docker/images/n8n \
    --tag paschendale/n8n:$VERSION-bookworm \
    --tag paschendale/n8n:latest-bookworm \
    --tag paschendale/n8n-geo:latest \
    --build-arg N8N_VERSION=$VERSION \
    --progress plain
  docker push paschendale/n8n:$VERSION-bookworm
  docker push paschendale/n8n:latest-bookworm  
fi
