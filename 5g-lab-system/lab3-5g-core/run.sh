#!/usr/bin/env bash
# Lab 3 — 5G Core: Open5GS + Free5GC. Logs: logs/lab3_<TIMESTAMP>_<stack>.log
set -euo pipefail
set -o pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${ROOT}/logs"
mkdir -p "${LOG_DIR}"
TS="$(date +%Y%m%d_%H%M%S)"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 {open5gs|free5gc|all}"
  exit 1
}

MODE="${1:-all}"
[[ "${MODE}" =~ ^(open5gs|free5gc|all)$ ]] || usage

banner() {
  echo ""
  echo "================================================================"
  echo "  LAB 3 — 5G Core (Open5GS / Free5GC)  |  mode=${MODE}"
  echo "================================================================"
  echo ""
}

log_ok() { echo "[OK] $*"; }
log_step() { echo "[Lab3] STEP $*"; }

banner

run_open5gs() {
  local log="${LOG_DIR}/lab3_${TS}_open5gs.log"
  log_step "3A — Open5GS start + verify → ${log}"
  set +e
  {
    echo "=== Lab 3 — Open5GS ==="
    bash "${HERE}/open5gs/scripts/start_open5gs.sh"
    bash "${HERE}/open5gs/scripts/verify_open5gs.sh"
  } 2>&1 | tee "${log}"
  local st="${PIPESTATUS[0]}"
  set -e
  if [[ "${st}" -ne 0 ]]; then
    echo "[FAIL] Open5GS pipeline exited ${st}. See: ${log}"
    exit "${st}"
  fi
  log_ok "Open5GS evidence written."
}

run_free5gc() {
  local log="${LOG_DIR}/lab3_${TS}_free5gc.log"
  log_step "3B — Free5GC clone/up + verify → ${log}"
  if ! command -v docker &>/dev/null; then
    echo "[FAIL] docker not found (required for Free5GC path)."
    exit 1
  fi
  set +e
  {
    echo "=== Lab 3 — Free5GC ==="
    bash "${HERE}/free5gc/scripts/clone_and_up.sh"
    bash "${HERE}/free5gc/scripts/verify_free5gc.sh"
  } 2>&1 | tee "${log}"
  local st="${PIPESTATUS[0]}"
  set -e
  if [[ "${st}" -ne 0 ]]; then
    echo "[FAIL] Free5GC pipeline exited ${st}. See: ${log}"
    exit "${st}"
  fi
  log_ok "Free5GC evidence written."
}

cd "${HERE}"

case "${MODE}" in
  open5gs) run_open5gs ;;
  free5gc) run_free5gc ;;
  all)
    run_open5gs
    run_free5gc
    ;;
esac

echo ""
echo "================================================================"
echo "  LAB 3 SUCCESS  |  mode=${MODE}"
echo "  Logs: ${LOG_DIR}/lab3_${TS}_open5gs.log (and/or _free5gc.log)"
echo "================================================================"
echo ""
echo "[PROOF — copy/paste]"
echo "  Open5GS AMF:  systemctl status open5gs-amfd --no-pager | head -15"
echo "  Open5GS:      systemctl is-active open5gs-amfd"
if command -v systemctl &>/dev/null; then
  echo "  [snapshot]    open5gs-amfd -> $(systemctl is-active open5gs-amfd 2>/dev/null || echo n/a)"
fi
echo "  Free5GC:      cd ${HERE}/free5gc/free5gc-compose && docker compose ps"
echo ""
