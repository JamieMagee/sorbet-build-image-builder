#!/usr/bin/env bash
#
# usage: ./build.sh
# usage: PUBLISH=true ./build.sh
#
# Builds (and optionally publishes) the sorbet-build-image in the current architecture

set -eou pipefail

function current_architecture() {
  case "$(uname -m)" in
    x86_64)
      echo "amd64"
      ;;
    aarch64|arm64)
      echo "arm64"
      ;;
    *)
      echo "unknown architecture: $(uname -m)"
      exit 1
      ;;
  esac
}

# Get image repo source code
SOURCE_REPO=sorbet/sorbet-build-image

rm -rf sorbet-build-image
if [ ! -d sorbet-build-image ]; then
  git clone "git@github.com:${SOURCE_REPO}.git" sorbet-build-image
fi

# Build image
IMAGE=ghcr.io/sorbet-multiarch/sorbet-build-image
TAG="latest-$(current_architecture)"

docker build -t "${IMAGE}:${TAG}" sorbet-build-image/

# Publish image
if [[ "${PUBLISH:-false}" == "true" ]]; then
  docker push "${IMAGE}:${TAG}"
fi
