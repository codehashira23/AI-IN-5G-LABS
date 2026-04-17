# Viva — short answers

For **pass/fail proof** during the demo, use `demo/checkpoints.md`. For the **spoken order**, use `demo/demo_flow.md` and run **`./run_demo.sh`** (or `bash run_demo.sh`) once on the VM.

## Why three transports in Lab 1?

REST fits CRUD OAM and human-debuggable calls. MQTT fits high-volume, asynchronous telemetry (RIC / IoT style). gRPC fits internal NF service calls with schema evolution and HTTP/2 efficiency.

## What does Swagger add beyond REST?

A **machine-readable contract** (OpenAPI) for client generation, validation, and governance — critical when multiple teams integrate with the same OSS API.

## Why run both Open5GS and Free5GC?

They differ in **packaging and NF decomposition**. Open5GS is approachable on **systemd** for teaching OS integration; Free5GC demonstrates a **containerized** multi-NF topology closer to some production CI/CD patterns.

## Where is AMF “running” in each?

- **Open5GS**: `open5gs-amfd.service` (verify with `systemctl` + `journalctl`).
- **Free5GC**: AMF container from `free5gc-compose` (verify with `docker ps` + `docker logs`).

## What is NRF registration?

NFs (SMF, AMF, etc.) **register profiles** with the NRF so peers can discover each other. Log lines vary by release but cluster around **NFProfile** / **registration** keywords.

## Why LangGraph instead of one big prompt?

**Separation of concerns**: deterministic KPI gating, structured QoE labeling, and advisory text are distinct responsibilities with different failure modes. Graphs make that explicit and testable.

## Why Ollama locally?

Reproducible demos **without API keys**, lower latency on a lab VM, and offline-friendly evaluation.

## What proves Lab 5 end-to-end?

- gNB log: **SCTP + NG Setup success** to Ella Core AMF.
- UE log: **registration accept** + **PDU session** + **TUN interface** with IP.
- Optional: ping through `uesimtun0` per vendor tutorial.

## What if ports clash?

Stop prior labs or change host port mappings in compose / `application.properties`.
