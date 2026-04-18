#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PREFIX="${UERANSIM_PREFIX:-${ROOT}/install}"

if [[ "${SKIP_APT:-0}" != "1" ]]; then
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    git build-essential cmake make gcc g++ \
    libsctp-dev lksctp-tools pkg-config libssl-dev
fi

SRC="${ROOT}/UERANSIM"
if [[ ! -d "${SRC}/.git" ]]; then
  git clone --depth 1 https://github.com/aligungr/UERANSIM.git "${SRC}"
fi

cd "${SRC}"
cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -DCMAKE_BUILD_TYPE=Release .
make -j"$(nproc)"
make install

echo "[ueransim-native] Installed to ${INSTALL_PREFIX}"
echo "Binaries: ${INSTALL_PREFIX}/bin/nr-gnb ${INSTALL_PREFIX}/bin/nr-ue"
