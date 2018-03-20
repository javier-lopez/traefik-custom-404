#!/bin/sh
PS4="> "; set -xe #exit on error && be verbose

upstream_release="${1:-v1.5.4}"
image_tag="${2}"
[ -z "${image_tag}" ] && image_tag="traefik-custom-404:${upstream_release}-201803161152"

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd)"

if [ -d "${CURRENT_DIR}/traefik" ]; then
    (cd "${CURRENT_DIR}/traefik" && git pull)
else
    git clone https://github.com/containous/traefik "${CURRENT_DIR}/traefik"
fi

(cd "${CURRENT_DIR}/traefik" && git checkout tags/"${upstream_release}")

export VERSION="${upstream_release}"
export CODENAME="cancoillotte"

(cd "${CURRENT_DIR}"
if patch -p0 -N --dry-run --silent < 01-custom-error-templates.patch 2>/dev/null; then
   patch -p0 < 01-custom-error-templates.patch
fi)
(cd "${CURRENT_DIR}/traefik" && make binary)
sudo rm -rf "${CURRENT_DIR}/traefik/static/"
docker build -t "${image_tag}" "${CURRENT_DIR}/traefik/"
