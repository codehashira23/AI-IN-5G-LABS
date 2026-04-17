#!/usr/bin/env bash
# Lab 5 — Ella Core + UERANSIM (Docker). Logs under <repo>/logs/
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${ROOT}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/lab5_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "${LOG_FILE}") 2>&1

echo ""
echo "================================================================"
echo "  LAB 5 — Ella Core + UERANSIM (Docker)"
echo "  Log file: ${LOG_FILE}"
echo "================================================================"
echo ""

if ! command -v docker &>/dev/null; then
  echo "[FAIL] docker not found."
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "[Lab5] STEP 1/3 — docker compose up (Ella Core + UERANSIM image)"
docker compose up -d

echo "[Lab5] STEP 2/3 — Proof: docker compose ps (expect Up / running)"
docker compose ps --no-color

PS_OUT="$(docker compose ps --no-color 2>&1)"
if ! echo "${PS_OUT}" | grep -qiE '[[:space:]]up[[:space:]]|[[:space:]]running[[:space:]]'; then
  echo "[FAIL] Compose did not report services in Up state."
  exit 1
fi
echo "[OK] Core + UERANSIM containers are Up."

echo "[Lab5] STEP 3/3 — Human checkpoints (first-time product UI)"
echo ""
echo "  Ella Core uses a one-time web initialization (vendor design)."
echo "  Subscriber values (fixed, reproducible): docs/SUBSCRIBER.md"
echo ""
echo "  Terminal A (gNB):"
echo "    docker compose exec -ti ueransim bin/nr-gnb --config /gnb.yaml"
echo "  Terminal B (UE):"
echo "    docker compose exec -ti ueransim bin/nr-ue --config /ue.yaml"
echo "  Data plane check:"
echo "    docker compose exec -ti ueransim ping -I uesimtun0 8.8.8.8 -c4"
echo ""
echo "  Browser: https://127.0.0.1:5002/  (accept self-signed certificate warning)"
echo ""
echo "  Native UERANSIM build (optional): bash ueransim-native/build_ueransim.sh"
echo ""

echo "================================================================"
echo "  LAB 5 AUTOMATION SUCCESS (containers running)"
echo "  Complete signaling live in front of examiner (see demo/checkpoints.md)"
echo "  Log: ${LOG_FILE}"
echo "  Teardown: docker compose down"
echo "================================================================"
echo ""
