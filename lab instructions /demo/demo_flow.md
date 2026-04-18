# Viva / demo — speaking script (use under pressure)

Open **`demo/checkpoints.md`** on a second window. Keep this file as **speaker notes**.

---

## 0) Opening the repository (30 seconds)

**Say:** “This is **one 5G lab system** for Ubuntu 22.04, not five random tasks. There is a **single master entry point**, **`run_demo.sh`**, and every lab writes **timestamped logs** under **`logs/`** for proof.”

**Show on screen:**

1. Repo root listing: `setup/` , `lab1-docker-transport/` … `lab5-ellacore-ueransim/` , `demo/` , `logs/`
2. Open **`run_demo.sh`** (first 25 lines) — point at **order** and **fail-fast** comment.
3. Open **`demo/checkpoints.md`** — “here is the **examiner checklist**.”

---

## 1) What you run (Phase A — automated)

**Say:** “I pre-flight the VM, then run the **full pipeline** once.”

```bash
cd 5g-lab-system
find . -name "*.sh" -type f -exec chmod +x {} \;
bash setup/verify_env.sh
./run_demo.sh
```

**If `sudo` prompts at Lab 3:** “Lab 3 needs **root** for **Open5GS systemd** and **Free5GC Docker** — that is expected.”

**If Free5GC is too heavy (time or disk):**

**Say:** “For this slot I skip Free5GC and still prove **Open5GS**.”

```bash
LAB_DEMO_SKIP_FREE5GC=1 ./run_demo.sh
```

**If a step fails:**

**Say:** “The script is **fail-fast** so we do not hide errors. Here is the **log path** printed in red.” Show **`logs/demo_master_*.log`** tail, then run the **single lab** `lab*/run.sh` and show that lab’s **`logs/lab*_*.log`**.

---

## 2) What to say **per lab** (while logs scroll)

### Lab 1 — Transport

**Say:** “**Docker** wraps **Flask REST**, **Mosquitto MQTT**, and **Python gRPC**. That is how northbound systems actually mix **pull**, **push**, and **RPC**.”

**Show:** `curl` health line in log; mention **`docker compose ps`**.

### Lab 2 — API

**Say:** “**Spring Boot** exposes **GET/POST**; **Swagger** is the human face of **OpenAPI**.”

**Show:** browser **`http://127.0.0.1:8081/swagger-ui/index.html`** — one **Try it out**.

### Lab 3 — Core

**Say:** “**Open5GS** on **systemd** is the ‘NF on the host’ story; **Free5GC** in **compose** is the ‘many containers’ story. Both expose an **AMF** and **NRF-style discovery**.”

**Show:** `systemctl is-active open5gs-amfd` → **`active`**; **`docker compose ps`** under `free5gc-compose`.

### Lab 4 — Intelligence

**Say:** “**LangGraph** runs three **agents**: validate KPIs, classify **QoE**, emit **advice**. **Ollama** runs **locally** — no cloud keys.”

**Show:** JSON line with **`qoe_label`** in the log.

### Lab 5 — RAN / UE

**Say:** “**UERANSIM** drives **gNB** then **UE**. We see **registration** and **PDU session** — the same **3GPP** procedures that connect a UE to the **AMF** from **Lab 3** when we integrate natively; here the **pinned Docker bundle** uses **Ella Core** as AMF for a vendor-stable class demo.”

**Show:** **`https://127.0.0.1:5002/`** once (accept cert warning). **Do not invent subscriber fields** — read **`lab5-ellacore-ueransim/docs/SUBSCRIBER.md`**.

**Terminal A:** `docker compose exec -ti ueransim bin/nr-gnb --config /gnb.yaml`  
**Say:** “**SCTP** and **NG setup**.”

**Terminal B:** `docker compose exec -ti ueransim bin/nr-ue --config /ue.yaml`  
**Say:** “**Registration accept**, **PDU session**, **TUN** IP.”

**If Ella UI is awkward live:** “The product has a **first-time web initialization** — that is **vendor design**, not a gap in our repo. Subscriber values are **fixed** in **`docs/SUBSCRIBER.md`** for repeatability.”

---

## 3) Closing (20 seconds)

**Say:** “**Structure** in folders, **automation** in **`run_demo.sh`**, **proof** in **`logs/`** and **`demo/checkpoints.md`**, and **one story**: transports → APIs → **core** → **RAN/UE** → **AI QoE**.”

**Show:** `ls -lt logs | head -n 6`

---

## Quick index

| Artifact | Use |
| --- | --- |
| `./run_demo.sh` | Full ordered run + master log |
| `demo/checkpoints.md` | Pass/fail table |
| `demo/architecture.md` | Layered explanation + diagrams |
| `logs/demo_master_*.log` | Full transcript |
