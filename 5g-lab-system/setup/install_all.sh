#!/usr/bin/env bash
#
# 5G Lab System — host installer (Ubuntu 22.04 jammy)
#
# Usage:
#   sudo bash setup/install_all.sh
#
# Optional environment:
#   SKIP_UERANSIM_NATIVE=1   — do not compile native UERANSIM (Docker Lab 5 still works)
#
# Idempotent: safe to re-run on the same VM (may upgrade packages).
#
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "[install_all] ERROR: run as root: sudo bash $0"
  exit 1
fi

if [[ "$(lsb_release -cs 2>/dev/null || echo unknown)" != "jammy" ]]; then
  echo "[install_all] WARN: this bundle is tested on Ubuntu 22.04 (jammy). Detected: $(lsb_release -ds 2>/dev/null || echo unknown)"
fi

export DEBIAN_FRONTEND=noninteractive

echo ""
echo "================================================================"
echo "  5G Lab System — install_all.sh"
echo "================================================================"
echo ""

echo "[1/7] APT — base toolchain and Lab dependencies"
apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates curl gnupg lsb-release software-properties-common \
  apt-transport-https \
  git build-essential cmake make pkg-config \
  python3 python3-venv python3-pip python3-dev \
  openjdk-17-jdk maven \
  libsctp-dev lksctp-tools libssl-dev \
  jq unzip \
  mosquitto-clients \
  iproute2 iputils-ping net-tools

echo "[2/7] Docker Engine"
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
else
  echo "       Docker already present — skipping get.docker.com"
fi

if [[ -n "${SUDO_USER:-}" ]] && getent group docker &>/dev/null; then
  usermod -aG docker "${SUDO_USER}" 2>/dev/null || true
  echo "       [INFO] User '${SUDO_USER}' is in group 'docker' (re-login if docker ps fails without sudo)."
fi

echo "[3/7] Docker Compose plugin"
docker compose version

echo "[4/7] Open5GS (official packaging)"
if ! apt-cache policy open5gs 2>/dev/null | grep -q open5gs.org; then
  add-apt-repository -y ppa:open5gs/latest
  apt-get update
fi
apt-get install -y --no-install-recommends open5gs

echo "[5/7] Ollama"
if ! command -v ollama &>/dev/null; then
  curl -fsSL https://ollama.com/install.sh | sh
fi
systemctl enable --now ollama 2>/dev/null || true

echo "[6/7] Ollama model for Lab 4 (large download)"
if [[ -n "${SUDO_USER:-}" ]]; then
  sudo -u "${SUDO_USER}" -H bash -lc 'ollama pull llama3.1:8b'
else
  ollama pull llama3.1:8b
fi

LAB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UER="${LAB_ROOT}/lab5-ellacore-ueransim/ueransim-native"

echo "[7/7] Optional native UERANSIM"
if [[ "${SKIP_UERANSIM_NATIVE:-0}" == "1" ]]; then
  echo "       SKIP_UERANSIM_NATIVE=1 — skipping clone/build."
elif [[ -f "${UER}/build_ueransim.sh" && -n "${SUDO_USER:-}" ]]; then
  echo "       Building as user ${SUDO_USER} (deps already installed)..."
  sudo -u "${SUDO_USER}" -H env SKIP_APT=1 UERANSIM_PREFIX="${UER}/install" bash "${UER}/build_ueransim.sh" || {
    echo "       [WARN] Native UERANSIM build failed — Lab 5 Docker path is unaffected."
  }
elif [[ -f "${UER}/build_ueransim.sh" ]]; then
  echo "       [INFO] No SUDO_USER — skip auto-build. Run later: bash ${UER}/build_ueransim.sh"
else
  echo "       [INFO] build_ueransim.sh not found — skipped."
fi

echo ""
echo "================================================================"
echo "  install_all.sh COMPLETE"
echo "================================================================"
echo "  Next (as your user):  bash setup/verify_env.sh"
echo "  Then:                 bash run_demo.sh"
echo "  Docs:                 README.md , setup/README.md , demo/"
echo ""
