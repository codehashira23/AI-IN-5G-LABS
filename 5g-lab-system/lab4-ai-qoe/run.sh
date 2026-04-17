#!/usr/bin/env bash
# Lab 4 — LangGraph QoE + Ollama (logs under <repo>/logs/)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${ROOT}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/lab4_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "${LOG_FILE}") 2>&1

echo ""
echo "================================================================"
echo "  LAB 4 — AI QoE (LangGraph + LangChain + Ollama)"
echo "  Log file: ${LOG_FILE}"
echo "================================================================"
echo ""
echo "Workflow: LangGraph StateGraph — (1) KPI validation agent -> (2) QoE classification agent -> (3) advice agent."
echo "Input: RSSI, latency, packet loss. Output: JSON fields kpi_ok, qoe_label, advice."
echo ""

if ! command -v ollama &>/dev/null; then
  echo "[FAIL] ollama CLI not found. Install: sudo bash setup/install_all.sh"
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "[Lab4] STEP 1/4 — Python venv + pip dependencies"
if [[ ! -d .venv ]]; then
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate
pip install -q -U pip
pip install -q -r requirements.txt

MODEL="${OLLAMA_MODEL:-llama3.1:8b}"
echo "[Lab4] STEP 2/4 — Ensure Ollama model: ${MODEL}"
ollama pull "${MODEL}"

echo "[Lab4] STEP 3/4 — Run QoE workflow (sample KPIs)"
OUT_JSON="/tmp/lab4_qoe_output.json"
python qoe_workflow.py -82 35 1.2 | tee "${OUT_JSON}"

echo "[Lab4] STEP 4/4 — Validate output fields"
python3 - "${OUT_JSON}" <<'PY'
import json, sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)
for key in ("qoe_label", "advice", "kpi_ok"):
    assert key in data, f"missing field: {key}"
print("[OK] Output contains qoe_label, advice, kpi_ok")
PY

echo ""
echo "================================================================"
echo "  LAB 4 SUCCESS"
echo "  Log: ${LOG_FILE}"
echo "  Stress sample: python qoe_workflow.py -112 180 6.0"
echo "================================================================"
echo ""
