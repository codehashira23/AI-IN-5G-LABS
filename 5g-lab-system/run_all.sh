#!/usr/bin/env bash
# Deprecated alias — use run_demo.sh (master controller, fail-fast).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[INFO] run_all.sh forwards to run_demo.sh — use: bash ${ROOT}/run_demo.sh"
exec bash "${ROOT}/run_demo.sh"
