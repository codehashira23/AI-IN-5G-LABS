#!/usr/bin/env bash
#
# 5G Lab System — environment verification (no root required for most checks)
#
# Usage:
#   bash setup/verify_env.sh
#
# Exits with status 1 if any required component is missing (fail-fast for pre-flight).
#
set -uo pipefail

pass() { echo "[OK]   $*"; }
fail() { echo "[MISS] $*"; FAILURES=$((FAILURES + 1)); }

FAILURES=0

LAB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NR_BIN="${LAB_ROOT}/lab5-ellacore-ueransim/ueransim-native/install/bin/nr-gnb"

echo ""
echo "================================================================"
echo "  5G Lab System — verify_env.sh"
echo "================================================================"
echo ""

if command -v docker &>/dev/null; then
  pass "docker $(docker --version 2>/dev/null | awk '{print $3}' | tr -d ',')"
else
  fail "docker (install: sudo bash setup/install_all.sh)"
fi

if docker compose version &>/dev/null; then
  pass "$(docker compose version 2>/dev/null | head -1)"
else
  fail "docker compose plugin"
fi

if command -v java &>/dev/null; then
  pass "$(java -version 2>&1 | head -1)"
else
  fail "java (openjdk-17-jdk)"
fi

if command -v mvn &>/dev/null; then
  pass "$(mvn -version 2>/dev/null | head -1)"
else
  fail "maven (mvn)"
fi

if command -v python3 &>/dev/null; then
  pass "$(python3 --version 2>/dev/null)"
else
  fail "python3"
fi

if command -v systemctl &>/dev/null; then
  if systemctl list-unit-files 2>/dev/null | grep -q '^open5gs-amfd.service'; then
    pass "open5gs-amfd unit installed"
    AMF_STATE="$(systemctl is-active open5gs-amfd 2>/dev/null || echo unknown)"
    if [[ "${AMF_STATE}" == "active" ]]; then
      pass "open5gs-amfd is active"
    else
      echo "[INFO] open5gs-amfd state=${AMF_STATE} (start Lab 3 or: sudo systemctl start open5gs-amfd)"
    fi
  else
    fail "open5gs-amfd unit (run: sudo bash setup/install_all.sh)"
  fi
else
  echo "[INFO] systemctl not found — skipping Open5GS unit checks."
fi

if command -v ollama &>/dev/null; then
  pass "ollama CLI"
  if ollama list 2>/dev/null | grep -q 'llama3.1:8b'; then
    pass "ollama model llama3.1:8b present"
  else
    echo "[INFO] llama3.1:8b not listed yet — run: ollama pull llama3.1:8b (or re-run install_all.sh)"
  fi
else
  fail "ollama CLI"
fi

if [[ -x "${NR_BIN}" ]]; then
  pass "native UERANSIM: ${NR_BIN}"
else
  echo "[INFO] native UERANSIM not built (optional). Lab 5 uses container image ghcr.io/ellanetworks/ueransim."
fi

echo ""
echo "================================================================"
if [[ "${FAILURES}" -eq 0 ]]; then
  echo "  verify_env.sh: all required checks passed"
else
  echo "  verify_env.sh: ${FAILURES} missing component(s) — fix above, then retry"
fi
echo "================================================================"
echo ""

[[ "${FAILURES}" -eq 0 ]] || exit 1
