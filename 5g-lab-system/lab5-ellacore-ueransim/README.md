# Lab 5 — Ella Core + UERANSIM

## Docker path (graded default)

`docker-compose.yaml` follows the official Ella Networks **simulated 5G network** tutorial:

- Core image: `ghcr.io/ellanetworks/ella-core:v1.9.1`
- RAN/UE image: `ghcr.io/ellanetworks/ueransim:3.2.7`
- Internal `n3` subnet: `10.3.0.0/24` (core `10.3.0.2`, UERANSIM `10.3.0.3`)

Reference: [Getting Started: Simulated 5G Network](https://docs.ellanetworks.com/tutorials/getting_started_simulation/)

## Run

```bash
./run.sh
```

Then complete UI steps and start `nr-gnb` / `nr-ue` as printed (two terminals).

Subscriber credentials live in `docs/SUBSCRIBER.md`.

## Native UERANSIM build

```bash
bash ueransim-native/build_ueransim.sh
```

Install prefix defaults to `ueransim-native/install/`. YAML templates under `ueransim-native/config/` are educational; the vendor container configs are authoritative for the Docker demo.
