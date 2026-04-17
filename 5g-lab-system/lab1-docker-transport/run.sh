#!/usr/bin/env bash
# Lab 1 — Docker + REST + MQTT + gRPC (logs under <repo>/logs/)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${ROOT}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/lab1_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "${LOG_FILE}") 2>&1

echo ""
echo "================================================================"
echo "  LAB 1 — Docker + Transport (REST, MQTT, gRPC)"
echo "  Log file: ${LOG_FILE}"
echo "================================================================"
echo ""

if ! command -v docker &>/dev/null; then
  echo "[FAIL] docker not found. Install: sudo bash setup/install_all.sh"
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "[Lab1] STEP 1/6 — docker compose build + up"
docker compose up -d --build

echo "[Lab1] STEP 2/6 — Proof: compose service status"
docker compose ps --no-color

echo "[Lab1] STEP 3/6 — Wait for REST /health (port 8080)"
ok=0
for i in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:8080/health >/dev/null 2>&1; then
    ok=1
    break
  fi
  sleep 1
done
if [[ "${ok}" -ne 1 ]]; then
  echo "[FAIL] REST /health did not become ready."
  docker compose ps
  exit 1
fi
echo "[OK] REST health endpoint responds."

echo "[Lab1] STEP 4/6 — REST proof (GET + POST)"
curl -fsS http://127.0.0.1:8080/api/items/42
echo ""
curl -fsS -X POST http://127.0.0.1:8080/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"ue-telemetry"}'
echo ""
echo "[OK] REST GET/POST returned JSON."

echo "[Lab1] STEP 5/6 — MQTT proof (mosquitto + mqtt-demo logs)"
docker compose logs --no-color --tail 40 mqtt-demo || {
  echo "[FAIL] could not read mqtt-demo logs"
  exit 1
}
if ! docker compose logs --no-color mqtt-demo 2>&1 | grep -qiE 'published|received|connected'; then
  echo "[FAIL] MQTT demo log missing expected publish/receive/connect lines."
  exit 1
fi
echo "[OK] MQTT demo log contains publish/receive evidence."

echo "[Lab1] STEP 6/6 — gRPC proof (in-container client → grpc:50051)"
docker compose exec -T grpc python client.py grpc:50051
echo "[OK] gRPC round-trip succeeded."

echo ""
echo "================================================================"
echo "  LAB 1 SUCCESS"
echo "  Log: ${LOG_FILE}"
echo "================================================================"
echo ""
echo "[PROOF — optional manual]"
echo "  docker compose ps"
echo "  curl -s http://127.0.0.1:8080/health"
echo "  docker compose exec grpc python client.py grpc:50051"
echo "  docker compose down   # teardown"
echo ""
