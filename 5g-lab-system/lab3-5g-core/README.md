# Lab 3 — Dual 5G core (Open5GS + Free5GC)

## Modes

```bash
sudo ./run.sh open5gs   # systemd Open5GS + journal evidence
sudo ./run.sh free5gc   # clones free5gc-compose + docker compose up + log excerpts
sudo ./run.sh all       # both (long-running; ensure RAM/disk headroom)
```

## What to show in evaluation

- **Open5GS**: `systemctl status open5gs-amfd` and `journalctl` slices saved under `logs/lab3_YYYYMMDD_HHMMSS_open5gs.log`.
- **Free5GC**: `docker compose ps` plus `docker logs` for AMF/NRF containers in `logs/lab3_YYYYMMDD_HHMMSS_free5gc.log`.

## Environment variable

Set `FREE5GC_COMPOSE_DIR` to reuse an existing clone path.
