#!/usr/bin/env bash
set -euo pipefail

DEST="${FREE5GC_COMPOSE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/free5gc-compose}"
if [[ ! -f "${DEST}/docker-compose.yaml" && ! -f "${DEST}/docker-compose.yml" ]]; then
  echo "[ERROR] free5gc-compose not found at ${DEST}. Run clone_and_up.sh first."
  exit 1
fi

cd "${DEST}"
FILE="docker-compose.yaml"
[[ -f "${FILE}" ]] || FILE="docker-compose.yml"

echo "=== Free5GC docker compose ps ==="
PS_OUT="$(docker compose -f "${FILE}" ps --no-color 2>&1)"
echo "${PS_OUT}"

echo ""
if ! echo "${PS_OUT}" | grep -qiE '[[:space:]]up[[:space:]]|[[:space:]]running[[:space:]]'; then
  echo "[ERROR] No 'Up' / running services in compose ps. Check: docker compose -f ${FILE} logs"
  exit 1
fi

echo "[OK] Free5GC: compose reports at least one service Up."

echo ""
echo "=== AMF / NRF log excerpts (best-effort container names) ==="
containers="$(docker ps --format '{{.Names}}' | grep -Ei 'amf|nrf' || true)"
if [[ -z "${containers}" ]]; then
  echo "[WARN] No container names matched amf|nrf; showing first 6 running containers:"
  docker ps --format '{{.Names}}' | head -6
else
  while IFS= read -r c; do
    [[ -z "${c}" ]] && continue
    echo "--- ${c} ---"
    docker logs --tail 60 "${c}" 2>&1 || true
    echo ""
  done <<< "${containers}"
  AMF="$(echo "${containers}" | grep -i amf | head -1 || true)"
  if [[ -n "${AMF}" ]]; then
    echo "[PROOF] AMF container log keyword sample (NF attach / config; varies by image):"
    docker logs --tail 120 "${AMF}" 2>&1 | grep -iE 'amf|register|profile|ngap|nas|heartbeat|start' | tail -n 8 || echo "  (no keyword hits in tail — show full docker logs in viva)"
  fi
fi
