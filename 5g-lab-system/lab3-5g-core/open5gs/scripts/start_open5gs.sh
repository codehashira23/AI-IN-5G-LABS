#!/usr/bin/env bash
set -euo pipefail
echo "[open5gs] Starting core network services (systemd)..."

start_if_present() {
  local u="$1"
  if systemctl list-unit-files | grep -q "^${u}.service"; then
    echo "[open5gs] starting ${u}..."
    sudo systemctl start "${u}"
  else
    echo "[open5gs] skip ${u} (unit not installed)"
  fi
}

# NRF before AMF is a common ordering expectation for discovery-heavy stacks.
start_if_present open5gs-nrfd
start_if_present open5gs-scpd
start_if_present open5gs-amfd
start_if_present open5gs-smfd
start_if_present open5gs-upfd
start_if_present open5gs-ausfd
start_if_present open5gs-udmd
start_if_present open5gs-pcfd
start_if_present open5gs-nssfd
start_if_present open5gs-bsfd
start_if_present open5gs-udrd

echo "[open5gs] Done. AMF status:"
sudo systemctl --no-pager --lines=0 status open5gs-amfd || true
