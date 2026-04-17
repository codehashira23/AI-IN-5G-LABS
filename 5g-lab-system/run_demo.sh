#!/usr/bin/env bash
#
# 5G Lab System — SINGLE MASTER DEMO ENTRY POINT (Ubuntu 22.04)
#
# Run from repository root (after chmod):
#   chmod +x run_demo.sh setup/*.sh lab*/run.sh 2>/dev/null || true
#   find . -name "*.sh" -type f -exec chmod +x {} \;
#   bash setup/verify_env.sh    # recommended pre-flight
#   ./run_demo.sh
#
# Logs everything to:  logs/demo_master_YYYYMMDD_HHMMSS.log
# Stops on first failure with a clear [DEMO FAILED] message.
#
# Optional — skip Free5GC (disk/time); Lab 3 runs Open5GS only:
#   LAB_DEMO_SKIP_FREE5GC=1 ./run_demo.sh
#
set -euo pipefail
set -o pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LAB_SYSTEM_ROOT="${ROOT}"
cd "${ROOT}"

TS="$(date +%Y%m%d_%H%M%S)"
DEMO_LOG="${ROOT}/logs/demo_master_${TS}.log"
mkdir -p "${ROOT}/logs"

banner() {
  printf '\n'
  printf '=%.0s' {1..72}
  printf '\n  %s\n' "$1"
  printf '=%.0s' {1..72}
  printf '\n'
}

die() {
  echo "" | tee -a "${DEMO_LOG}"
  echo "[DEMO FAILED] $*" | tee -a "${DEMO_LOG}" >&2
  echo "Full transcript: ${DEMO_LOG}" | tee -a "${DEMO_LOG}" >&2
  exit 1
}

run_step() {
  local title="$1"
  shift
  banner "${title}"
  set +e
  "$@" 2>&1 | tee -a "${DEMO_LOG}"
  local st="${PIPESTATUS[0]}"
  set -e
  if [[ "${st}" -ne 0 ]]; then
    die "${title} — exit code ${st}"
  fi
}

[[ -f "${ROOT}/lab1-docker-transport/run.sh" ]] || die "Run from 5g-lab-system root (missing lab1-docker-transport/run.sh)."

{
  echo "5g-lab-system — MASTER DEMO"
  echo "Started: $(date -Iseconds)"
  echo "Host: $(hostname)"
  echo "CWD: ${ROOT}"
  echo "LAB_DEMO_SKIP_FREE5GC=${LAB_DEMO_SKIP_FREE5GC:-0}"
} | tee "${DEMO_LOG}"

run_step "STEP 1/5 — Lab 1 (Transport: Docker + REST + MQTT + gRPC)" \
  bash "${ROOT}/lab1-docker-transport/run.sh"

run_step "STEP 2/5 — Lab 2 (API: Spring Boot + Swagger / OpenAPI)" \
  bash "${ROOT}/lab2-spring-swagger/run.sh"

LAB3_MODE="all"
if [[ "${LAB_DEMO_SKIP_FREE5GC:-0}" == "1" ]]; then
  LAB3_MODE="open5gs"
  echo "[INFO] LAB_DEMO_SKIP_FREE5GC=1 — Lab 3 runs Open5GS only (Free5GC skipped)." | tee -a "${DEMO_LOG}"
fi

if [[ "${EUID}" -eq 0 ]]; then
  run_step "STEP 3/5 — Lab 3 (Core: Open5GS + Free5GC as selected)" \
    bash "${ROOT}/lab3-5g-core/run.sh" "${LAB3_MODE}"
else
  if ! sudo -n true 2>/dev/null; then
    echo "[INFO] sudo may prompt once for Lab 3 (systemd + Docker)." | tee -a "${DEMO_LOG}"
  fi
  run_step "STEP 3/5 — Lab 3 (Core: Open5GS + Free5GC as selected)" \
    sudo env "PATH=${PATH}" "HOME=${HOME}" \
    bash "${ROOT}/lab3-5g-core/run.sh" "${LAB3_MODE}"
fi

run_step "STEP 4/5 — Lab 4 (Intelligence: LangGraph QoE + Ollama)" \
  bash "${ROOT}/lab4-ai-qoe/run.sh"

run_step "STEP 5/5 — Lab 5 (RAN/UE: Ella Core + UERANSIM containers)" \
  bash "${ROOT}/lab5-ellacore-ueransim/run.sh"

banner "DEMO PIPELINE COMPLETE"
{
  echo "All automated steps finished successfully."
  echo "Finished: $(date -Iseconds)"
  echo "Master transcript: ${DEMO_LOG}"
  echo ""
  echo "Human proof (browser + 2 terminals): demo/checkpoints.md , demo/demo_flow.md"
} | tee -a "${DEMO_LOG}"

exit 0
