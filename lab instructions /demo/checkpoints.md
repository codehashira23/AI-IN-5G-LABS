# Viva checkpoints — open this during the demo

**Columns:** what runs → verify command → expect → URL → one line to say.

**Master transcript (full pipeline):** `logs/demo_master_YYYYMMDD_HHMMSS.log` from `./run_demo.sh`.

---

## Lab 1 — Transport (Docker + REST + MQTT + gRPC)

| What is running | Verify command | Expected output | URL / endpoint | Say in one line |
| --- | --- | --- | --- | --- |
| Compose: `rest`, `mosquitto`, `grpc` up | `cd lab1-docker-transport && docker compose ps` | **Up** / **running** for core services | `http://127.0.0.1:8080/health` | “Transport layer: **REST**, **MQTT**, **gRPC** — how OAM and telemetry actually move data.” |
| REST | `curl -fsS http://127.0.0.1:8080/health` | JSON **`"status":"ok"`** | same | “Pull-style health and CRUD over HTTP.” |
| MQTT demo | `docker compose logs --tail 25 mqtt-demo` | **connect** / **publish** / **receive** style lines | — | “Pub/sub for asynchronous KPIs and alarms.” |
| gRPC | `docker compose exec -T grpc python client.py grpc:50051` | Greeting line with **Hello** | — | “Binary RPC with a strict `.proto` contract.” |

**Log:** `logs/lab1_YYYYMMDD_HHMMSS.log`

---

## Lab 2 — API (Spring Boot + Swagger)

| What is running | Verify command | Expected output | URL / endpoint | Say in one line |
| --- | --- | --- | --- | --- |
| Spring on **8081** | `curl -fsSI http://127.0.0.1:8081/swagger-ui/index.html` (first line) | **`HTTP/1.1 200`** | `http://127.0.0.1:8081/swagger-ui/index.html` | “API layer: **Swagger** is human UI; **OpenAPI** is machine contract.” |
| POST then GET | run `lab2/run.sh` or use Swagger **Try it out** | JSON includes **`id`**, **`name`**, **`sst`** | `http://127.0.0.1:8081/v3/api-docs` | “Same discipline as OSS northbound portals.” |

**Log:** `logs/lab2_YYYYMMDD_HHMMSS.log`

---

## Lab 3 — Core (Open5GS + Free5GC)

| What is running | Verify command | Expected output | URL / endpoint | Say in one line |
| --- | --- | --- | --- | --- |
| Open5GS AMF | `systemctl is-active open5gs-amfd` | **`active`** | no default browser UI | “**Open5GS**: core NFs on **systemd** — closest to ‘NF on a server’ mentally.” |
| AMF status | `systemctl status open5gs-amfd --no-pager` (first screen) | **Active (running)** | — | “**AMF** is where **UE registration** and **session** control meet **N2**.” |
| NRF / discovery (logs) | `sudo journalctl -u open5gs-nrfd -n 200 --no-pager` then search **NF** / **profile** | Text lines (exact strings vary by release) | — | “**NRF** holds **NF profiles** so other NFs can **discover** peers.” |
| Free5GC stack | `cd lab3-5g-core/free5gc/free5gc-compose && docker compose ps` | Multiple rows **Up** | — | “**Free5GC**: same logical roles, **Docker** packaging for CI-style labs.” |

**Logs:** `logs/lab3_YYYYMMDD_HHMMSS_open5gs.log` and `logs/lab3_YYYYMMDD_HHMMSS_free5gc.log` when both run.

---

## Lab 4 — Intelligence (LangGraph + LangChain + Ollama)

| What is running | Verify command | Expected output | URL / endpoint | Say in one line |
| --- | --- | --- | --- | --- |
| Ollama + model | `ollama list` | Row **llama3.1:8b** | `http://127.0.0.1:11434` (API) | “Intelligence layer: **local LLM**, no API keys in class.” |
| **StateGraph** output | `cd lab4-ai-qoe && source .venv/bin/activate && python qoe_workflow.py -82 35 1.2` | One JSON with **`kpi_ok`**, **`qoe_label`**, **`advice`** | — | “Three **agents**: KPI validate → **QoE** classify → **advice**; **LangGraph** wires the order.” |

**Log:** `logs/lab4_YYYYMMDD_HHMMSS.log`

---

## Lab 5 — RAN / UE (Ella Core + UERANSIM)

| What is running | Verify command | Expected output | URL / endpoint | Say in one line |
| --- | --- | --- | --- | --- |
| Ella + ueransim containers | `cd lab5-ellacore-ueransim && docker compose ps` | **Up** for both | `https://127.0.0.1:5002/` | “RAN layer: **gNB** and **UE** simulators toward an **AMF**.” |
| gNB (terminal A) | `docker compose exec -ti ueransim bin/nr-gnb --config /gnb.yaml` | **SCTP** / **NG Setup successful** | — | “**N2** is up; same signaling family as toward **Lab 3’s AMF** when integrated.” |
| UE + session (terminal B) | `docker compose exec -ti ueransim bin/nr-ue --config /ue.yaml` | **Registration** success, **PDU session** success, **uesimtun0** IP | — | “**UE registration** and **PDU session** are the procedures that bind the UE to the **5G core** for user traffic.” |

**Subscriber (fixed):** `lab5-ellacore-ueransim/docs/SUBSCRIBER.md`  
**Log:** `logs/lab5_YYYYMMDD_HHMMSS.log`

---

## One sentence (memorize)

**Labs 1–2** move data and contracts; **Lab 3** runs real **open 5G cores**; **Lab 5** runs **UERANSIM** through **UE registration** and **PDU session** to an **AMF** (the same procedures toward **Open5GS/Free5GC’s AMF** when you integrate native UERANSIM with Lab 3); **Lab 4** maps **KPIs → QoE + advice** — all with **timestamped logs** as proof.
