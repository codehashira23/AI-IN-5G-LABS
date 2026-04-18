#!/usr/bin/env bash
set -euo pipefail

DEST="${FREE5GC_COMPOSE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/free5gc-compose}"

if [[ ! -d "${DEST}/.git" ]]; then
  echo "[free5gc] Cloning free5gc-compose into ${DEST} ..."
  mkdir -p "$(dirname "${DEST}")"
  git clone --depth 1 -b master https://github.com/free5gc/free5gc-compose.git "${DEST}"
else
  echo "[free5gc] Using existing repo ${DEST}"
fi

cd "${DEST}"
echo "[free5gc] Pulling images and starting (this can take a while)..."
docker compose pull
docker compose up -d

echo "[free5gc] Containers:"
docker compose ps
