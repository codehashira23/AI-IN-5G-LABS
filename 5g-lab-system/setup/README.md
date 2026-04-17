# Setup — Ubuntu 22.04 (Jammy)

This folder contains **host preparation** for the 5G Lab System. All scripts are written for **x86_64** (typical classroom VM).

## Prerequisites

| Item | Guidance |
| --- | --- |
| OS | **Ubuntu 22.04 LTS** (`jammy`) |
| RAM | **16 GB** recommended (Free5GC + Docker stacks) |
| Disk | **60 GB+** free if you plan full Free5GC image pulls + logs |
| Access | `sudo` for `install_all.sh` and for Lab 3 systemd/Docker operations |
| Network | First install needs outbound HTTPS (packages, images, models) |

## Scripts

| File | Role |
| --- | --- |
| `install_all.sh` | **Run once** (or when refreshing a VM): APT toolchain, Docker, Open5GS PPA, Ollama + default model, optional native UERANSIM build |
| `verify_env.sh` | **Run anytime** as your normal user: confirms tools on `PATH` and key units; exits non-zero if any check failed |

## Commands

```bash
cd 5g-lab-system
chmod +x setup/*.sh lab*/run.sh run_demo.sh run_all.sh 2>/dev/null || true
find . -name "*.sh" -type f -exec chmod +x {} \;

sudo bash setup/install_all.sh
bash setup/verify_env.sh
```

After Docker install, if `verify_env.sh` reports Docker OK but `docker ps` fails for your user, **log out and back in** (or reboot) so the `docker` group membership applies.

## Idempotency

- `install_all.sh` is safe to re-run: it mostly uses `apt-get install` and “install if missing” patterns.
- Re-running may **upgrade** packages and **re-pull** large images/models depending on upstream state.

## Next

Return to the repository **`README.md`** for the **demo order** (`run_demo.sh`) and viva documentation under `demo/`.
