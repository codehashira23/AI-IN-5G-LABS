#!/usr/bin/env bash
# Strict verification: AMF must be active. NRF checked when its unit is installed.
set -euo pipefail

echo "=== Open5GS verification ==="

if ! command -v systemctl &>/dev/null; then
  echo "[ERROR] systemctl not available (not a systemd environment)."
  exit 1
fi

require_unit() {
  local u="$1"
  if ! sudo systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | grep -qx "${u}.service"; then
    echo "[ERROR] systemd unit missing: ${u}.service (install Open5GS packages)."
    exit 1
  fi
}

require_active() {
  local u="$1"
  local state
  state="$(systemctl is-active "${u}" 2>/dev/null || true)"
  echo "[${u}] state=${state}"
  if [[ "${state}" != "active" ]]; then
    echo "[ERROR] ${u} is not active (state=${state}). Check: sudo journalctl -u ${u} -n 80"
    exit 1
  fi
}

require_unit open5gs-amfd
require_active open5gs-amfd

echo ""
echo "--- AMF last log lines ---"
sudo journalctl -u open5gs-amfd -n 40 --no-pager

if sudo systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | grep -qx 'open5gs-nrfd.service'; then
  echo ""
  require_active open5gs-nrfd
  echo ""
  echo "--- NRF last log lines ---"
  sudo journalctl -u open5gs-nrfd -n 40 --no-pager
else
  echo ""
  echo "[WARN] open5gs-nrfd.service not installed — skipping NRF checks (AMF is primary proof)."
fi

echo ""
echo "[PROOF] AMF log keyword sample (NGAP/NAS style strings; varies by traffic):"
sudo journalctl -u open5gs-amfd -n 120 --no-pager | grep -iE 'guti|nas|ngap|register|amf' | tail -n 6 || echo "  (no keyword hits in last 120 lines — show longer journal in viva if needed)"

if sudo systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | grep -qx 'open5gs-nrfd.service' && [[ "$(systemctl is-active open5gs-nrfd 2>/dev/null)" == "active" ]]; then
  echo ""
  echo "[PROOF] NRF log keyword sample (NF discovery / registration style strings):"
  sudo journalctl -u open5gs-nrfd -n 200 --no-pager | grep -iE 'nf|profile|register|subscription|heartbeat|discovery' | tail -n 8 || echo "  (no keyword hits — inspect full NRF journal during viva)"
fi

echo ""
echo "[OK] Open5GS: AMF is active."
