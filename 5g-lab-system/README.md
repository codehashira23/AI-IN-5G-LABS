# 5G Lab System

End-to-end **Ubuntu 22.04** project for final lab and viva: **transports**, **documented APIs**, **two open 5G cores**, **RAN/UE simulation**, and **AI QoE** on top. The repository is organized as **one layered engineering system** (not unrelated assignments).

## Prerequisites

- **Ubuntu 22.04 LTS** (jammy), **~16 GB RAM**, **~60 GB** free disk for full stacks  
- **`sudo`** for host install and for Lab 3  
- Details: **`setup/README.md`**

## Directory map

```text
5g-lab-system/
├── run_demo.sh              ← SINGLE master demo entry point
├── run_all.sh               ← Forwards to run_demo.sh
├── README.md
├── setup/
│   ├── README.md
│   ├── install_all.sh
│   └── verify_env.sh
├── logs/                     ← Timestamped proof (*.log gitignored except README)
├── demo/
│   ├── README.md
│   ├── demo_flow.md         ← Spoken script + fallbacks
│   ├── checkpoints.md      ← Examiner checklist
│   ├── architecture.md      ← Layered system + diagrams
│   └── viva_notes.md
├── lab1-docker-transport/
├── lab2-spring-swagger/
├── lab3-5g-core/
├── lab4-ai-qoe/
└── lab5-ellacore-ueransim/
```

## Exact run order (first time on a VM)

```bash
cd 5g-lab-system
find . -name "*.sh" -type f -exec chmod +x {} \;

sudo bash setup/install_all.sh
bash setup/verify_env.sh
```

## Single command usage (after install)

```bash
chmod +x run_demo.sh
./run_demo.sh
```

Equivalent: `bash run_demo.sh` (does not require the executable bit).

- **`./run_demo.sh`** runs **Lab 1 → 2 → 3 → 4 → 5**, **stops on first failure**, and writes **`logs/demo_master_YYYYMMDD_HHMMSS.log`**.
- **Skip Free5GC** (time/disk): `LAB_DEMO_SKIP_FREE5GC=1 ./run_demo.sh`
- **Skip native UERANSIM compile** on install: `SKIP_UERANSIM_NATIVE=1 sudo bash setup/install_all.sh`

## What to show in viva

1. **Tree:** `setup/`, `lab*/`, `demo/`, `logs/`.  
2. **Master entry:** open **`run_demo.sh`** — show **order** and **fail-fast**.  
3. **Checklist:** open **`demo/checkpoints.md`**.  
4. **Script:** open **`demo/demo_flow.md`** — your **spoken lines**.  
5. **Story:** **`demo/architecture.md`** — **30-second** layered explanation.  
6. **Run or replay:** `./run_demo.sh` **or** `ls -lt logs` and **tail** `demo_master_*.log`.  
7. **Lab 5 live:** browser **`https://127.0.0.1:5002/`** + two terminals (**`nr-gnb`**, **`nr-ue`**) as printed by **`lab5-ellacore-ueransim/run.sh`**.

## Ports (default)

| Port | Lab | Service |
| ---: | --- | --- |
| 8080 | 1 | REST |
| 1883 | 1 | MQTT |
| 50051 | 1 | gRPC |
| 8081 | 2 | Spring + Swagger |
| 5002 | 5 | Ella Core UI |
| 11434 | 4 | Ollama |

## Known notes

- **`verify_env.sh` exits 1** if tools are missing — run **`install_all.sh`** first.  
- **Ella Core:** **one-time web initialization** (vendor design). Subscriber values: **`lab5-ellacore-ueransim/docs/SUBSCRIBER.md`**.  
- **Free5GC:** large **image pull**; use **`LAB_DEMO_SKIP_FREE5GC=1`** if needed.  
- **Open5GS vs Free5GC:** defaults limit port clashes; custom SCTP/IP needs care.  
- **Lab 2:** Java stays on **:8081** until **`kill <PID>`** (PID printed at end of `lab2/run.sh`).  
- **Lab 1:** run **`docker compose down`** in `lab1-docker-transport/` when finished.  
- **Docker group:** after install, **log out and back in** if `docker ps` fails without sudo.

## Documentation index

| Path | Purpose |
| --- | --- |
| `setup/README.md` | VM sizing, install/verify |
| `demo/README.md` | Order to read viva files |
| `demo/demo_flow.md` | Speaking script |
| `demo/checkpoints.md` | Proof table |
| `demo/architecture.md` | Layers + diagrams |
| `demo/viva_notes.md` | Short Q&A |
| `logs/README.md` | Log filename patterns |

## License

Educational bundle; upstream projects retain their own licenses (Open5GS, Free5GC, Ella Core, UERANSIM, Spring, LangChain, etc.).
