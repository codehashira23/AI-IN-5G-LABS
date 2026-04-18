# AI in 5G Networks - Complete Lab Guide (Lab 1 to Lab 5)

This handbook is a combined learning guide for Labs 1-5.  
It is designed for viva preparation, practical execution, and report writing.

---

## Table of Contents

1. How to Use This Guide  
2. Common Setup for All Labs  
3. Lab 1 - Docker + REST + MQTT + gRPC  
4. Lab 2 - Spring Boot + Swagger  
5. Lab 3 - 5G Core (Open5GS + Free5GC flow)  
6. Lab 4 - AI QoE Workflow (LangGraph + Ollama)  
7. Lab 5 - Ella Core + UERANSIM  
8. Combined Viva Master Set  
9. Report Writing Template  
10. Quick Exam Day Revision

---

## 1) How to Use This Guide

- Read **Common Setup** once.
- For each lab:
  - Understand objective and concept first.
  - Run commands exactly in terminal order.
  - Use provided sample inputs.
  - Compare with expected output signs.
  - Prepare viva Q/A at end of each lab section.
- Keep this file open during practical and viva.

---

## 2) Common Setup for All Labs

### 2.1 Machine and OS

- Ubuntu 22.04 LTS recommended.
- Internet required for pulling Docker images, Maven dependencies, Ollama model.
- Prefer at least:
  - 8 GB RAM minimum (16 GB better for AI + containers)
  - 20+ GB free disk

### 2.2 Common tools checklist

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin curl git python3 python3-venv python3-pip openjdk-17-jdk maven
sudo systemctl enable --now docker
docker --version
docker compose version
python3 --version
java -version
mvn -version
```

### 2.3 Project root used in this guide

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS"
```

### 2.4 Terminal strategy for viva demo

- Keep multiple terminals open and named:
  - `T1` Lab runner
  - `T2` extra service/logs
  - `T3` client command
  - `T4` verification command
- For Lab 5, multiple terminals are mandatory (gNB, UE, ping).

### 2.5 Proof commands for screenshots

Use these before screenshot:

```bash
hostname
date
```

---

## 3) Lab 1 - Docker + REST + MQTT + gRPC

## 3.1 Objective

Build and validate a containerized multi-protocol communication setup:

- REST API calls
- MQTT publish/subscribe
- gRPC client-server request/response

This lab demonstrates transport layer understanding through practical service testing.

## 3.2 Concept in simple words

- Docker isolates services into containers.
- REST uses HTTP and JSON.
- MQTT uses broker-based pub/sub messaging.
- gRPC provides compact and fast RPC over HTTP/2.

In 5G systems, multiple services communicate using APIs and message buses; this lab mimics that idea at mini scale.

## 3.3 Folder and runner

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab1-docker-transport"
chmod +x run.sh
./run.sh
```

## 3.4 What `run.sh` verifies

- Starts Docker compose stack
- Checks REST health endpoint
- Executes REST GET/POST examples
- Reads MQTT logs for publish/receive evidence
- Runs gRPC client call from container
- Prints success banner and log location

## 3.5 Manual verification commands

```bash
docker compose ps
curl -s http://127.0.0.1:8080/health
curl -s http://127.0.0.1:8080/api/items/42
curl -s -X POST http://127.0.0.1:8080/api/items -H "Content-Type: application/json" -d '{"name":"ue-telemetry"}'
docker compose logs --tail 50 mqtt-demo
docker compose exec -T grpc python client.py grpc:50051
```

## 3.6 Inputs used in this lab

- REST POST JSON:
  - `{"name":"ue-telemetry"}`
- gRPC endpoint:
  - `grpc:50051`
- MQTT topic/message are handled by included demo scripts.

## 3.7 Expected output signs

- `docker compose ps` shows services in `Up` state.
- REST `/health` returns success JSON or healthy response.
- POST returns created item/object.
- MQTT logs contain keywords like `published`, `received`, or `connected`.
- gRPC client prints successful response (not UNAVAILABLE error).

## 3.8 Common issues and fix

- Docker daemon not running:
  - `sudo systemctl start docker`
- Permission denied on Docker socket:
  - `sudo usermod -aG docker $USER` and re-login
- Port conflict:
  - stop old containers or modify mapping
- REST connection refused:
  - container not ready yet; wait and retry

## 3.9 Viva questions (Lab 1)

1. **What is Docker and why used in this lab?**  
   Docker runs services in isolated containers for reproducible setup.

2. **Image vs container?**  
   Image is template; container is running instance.

3. **REST vs gRPC?**  
   REST is HTTP+JSON and easy; gRPC is binary, fast, and good for internal services.

4. **What is MQTT?**  
   Lightweight pub/sub protocol using broker and topics.

5. **Why pub/sub model is useful?**  
   Decouples sender and receiver for scalable event-driven systems.

6. **How did you prove Lab 1 success?**  
   REST responses, MQTT logs, and gRPC successful call.

## 3.10 5-line viva summary for Lab 1

We created a Docker-based multi-service environment for transport protocols.  
Then we validated REST using health and CRUD-style HTTP requests.  
MQTT communication was checked through publish/subscribe logs.  
gRPC client-server communication was executed and verified.  
This demonstrated protocol-level interoperability in a practical setup.

---

## 4) Lab 2 - Spring Boot + Swagger

## 4.1 Objective

Build and run a Spring Boot application, expose APIs, and verify them through Swagger UI and OpenAPI docs.

## 4.2 Concept in simple words

- Spring Boot makes Java API development quick.
- Swagger UI gives a browser interface to test API endpoints.
- OpenAPI JSON is machine-readable API contract.

This lab demonstrates API-first development and API documentation/testing workflow.

## 4.3 Folder and runner

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab2-spring-swagger"
chmod +x run.sh
./run.sh
```

## 4.4 What `run.sh` verifies

- Maven build (`package`)
- Launches jar app on port `8081`
- Waits until Swagger UI loads
- Performs POST and GET API checks
- Validates OpenAPI JSON presence

## 4.5 Manual verification commands

```bash
curl -I http://127.0.0.1:8081/swagger-ui/index.html
curl http://127.0.0.1:8081/v3/api-docs
curl -X POST http://127.0.0.1:8081/api/slices -H "Content-Type: application/json" -d '{"name":"eMBB-Lab","sst":"1","sd":"010203"}'
```

## 4.6 Inputs used in this lab

- Slice creation payload:
  - `{"name":"eMBB-Lab","sst":"1","sd":"010203"}`
- Target API URL:
  - `http://127.0.0.1:8081`

## 4.7 Expected output signs

- Maven build success with jar generated under `target/`.
- Swagger UI opens in browser.
- POST returns object with generated ID.
- GET for that ID returns same object.
- `/v3/api-docs` returns valid JSON with `openapi` or `swagger` key.

## 4.8 Common issues and fix

- `mvn` not found:
  - install Maven
- Java version unsupported:
  - use OpenJDK 17 or newer
- Port 8081 already used:
  - stop conflict process
- Swagger 404:
  - confirm correct path `/swagger-ui/index.html`

## 4.9 Viva questions (Lab 2)

1. **What is Spring Boot?**  
   Framework for quickly building Java backend services.

2. **Why Swagger in backend projects?**  
   Interactive API docs and testing without writing custom client.

3. **What is OpenAPI?**  
   Standard schema describing API endpoints, models, and operations.

4. **POST vs GET in this lab?**  
   POST creates slice resource; GET fetches created slice.

5. **How did you validate API correctness?**  
   Used Swagger endpoint checks and OpenAPI JSON validation.

6. **Why API-first helps teams?**  
   Shared contract improves frontend-backend coordination and testing.

## 4.10 5-line viva summary for Lab 2

We built and started a Spring Boot API service using Maven.  
Then we accessed Swagger UI to inspect and test endpoints.  
We created a sample network slice via POST and fetched it via GET.  
OpenAPI JSON was validated to confirm API contract generation.  
This lab proved API implementation plus documentation workflow.

---

## 5) Lab 3 - 5G Core (Open5GS + Free5GC flow)

## 5.1 Objective

Run and verify 5G core workflows using Open5GS and Free5GC style scripts and checks.

## 5.2 Concept in simple words

5G core is divided into network functions:

- AMF: registration and mobility signaling
- SMF: session management
- UPF: user data forwarding

Lab 3 demonstrates that core services can be started and validated as a reproducible stack.

## 5.3 Folder and runner

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab3-5g-core"
chmod +x run.sh
./run.sh
```

You can also run specific mode:

```bash
./run.sh open5gs
./run.sh free5gc
./run.sh all
```

## 5.4 What `run.sh` verifies

- Open5GS start and verification scripts
- Free5GC clone/up and verification scripts
- Writes logs under `5g-lab-system/logs`
- Prints proof commands for AMF status and compose status

## 5.5 Manual verification commands

```bash
systemctl is-active open5gs-amfd
systemctl status open5gs-amfd --no-pager | head -15
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab3-5g-core/free5gc/free5gc-compose"
docker compose ps
```

## 5.6 Inputs used in this lab

- Mode argument:
  - `open5gs`, `free5gc`, `all`
- Subscriber/core configs are taken from provided scripts and docs.

## 5.7 Expected output signs

- Open5GS verification script exits successfully.
- `open5gs-amfd` service shows active status.
- Free5GC compose shows running containers.
- No fatal errors in generated log files.

## 5.8 Common issues and fix

- systemd service missing:
  - install/configure Open5GS properly
- Docker not found in free5GC mode:
  - install Docker and compose plugin
- Port conflicts:
  - stop stale containers/processes
- Dependency script failures:
  - rerun setup scripts and check logs

## 5.9 Viva questions (Lab 3)

1. **What does AMF do?**  
   Handles UE registration, mobility, and control signaling anchor.

2. **What does SMF do?**  
   Creates and manages PDU sessions and policy.

3. **What does UPF do?**  
   Handles user-plane packet forwarding to data networks.

4. **Open5GS vs Free5GC?**  
   Both are open-source 5G cores with different implementations.

5. **What is control plane vs user plane?**  
   Signaling logic vs actual user data flow.

6. **How did you validate Lab 3?**  
   Service status checks, compose status, and verification logs.

## 5.10 5-line viva summary for Lab 3

We executed automated scripts to start and verify 5G core components.  
Both Open5GS and Free5GC workflows were tested in the same lab setup.  
AMF status and core readiness were verified through service checks/logs.  
Container state and script verification outputs confirmed stable execution.  
This lab demonstrated practical 5G core orchestration and validation.

---

## 6) Lab 4 - AI QoE Workflow (LangGraph + Ollama)

## 6.1 Objective

Run a multi-step AI pipeline that maps KPI inputs to QoE classification and network advice.

## 6.2 Concept in simple words

Lab 4 uses AI orchestration:

1. Validate KPI sanity
2. Classify QoE quality
3. Generate optimization advice

The workflow runs with local LLM through Ollama and returns structured JSON-like output.

## 6.3 Folder and runner

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab4-ai-qoe"
chmod +x run.sh
./run.sh
```

## 6.4 What `run.sh` verifies

- Creates/activates Python venv
- Installs dependencies
- Pulls Ollama model (`llama3.1:8b`)
- Runs QoE workflow with KPI sample
- Validates output keys: `qoe_label`, `advice`, `kpi_ok`

## 6.5 Manual verification commands

Terminal A (Ollama service):

```bash
ollama serve
```

Terminal B (lab):

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab4-ai-qoe"
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
ollama pull llama3.1:8b
python qoe_workflow.py -82 35 1.2
python qoe_workflow.py -112 180 6.0
```

## 6.6 Inputs used in this lab

Primary sample KPI input:

- RSSI: `-82`
- Latency ms: `35`
- Packet loss %: `1.2`

Stress sample:

- RSSI: `-112`
- Latency ms: `180`
- Packet loss %: `6.0`

## 6.7 Expected output signs

- Script runs without Python errors.
- Output contains:
  - `kpi_ok`
  - `qoe_label`
  - `advice`
- Stress input should usually produce poorer QoE label than normal input.

## 6.8 Common issues and fix

- Ollama connection refused:
  - ensure `ollama serve` is running
- Model missing:
  - run `ollama pull llama3.1:8b`
- venv dependency conflict:
  - recreate `.venv` and reinstall
- slow execution:
  - close heavy apps and ensure enough RAM

## 6.9 Viva questions (Lab 4)

1. **What is QoE?**  
   User perceived service quality.

2. **QoE vs QoS?**  
   QoS is network metrics; QoE is human experience.

3. **Why multi-step AI workflow?**  
   Better modular reasoning: validation, classification, recommendation.

4. **Why Ollama?**  
   Local model inference without cloud dependency.

5. **Why LangGraph-style flow?**  
   Structured state-based orchestration for agent pipelines.

6. **How did you prove output quality?**  
   Compared output fields and behavior across different KPI inputs.

## 6.10 5-line viva summary for Lab 4

We built an AI-driven QoE analysis workflow using Python and Ollama.  
The system accepted KPI values like RSSI, latency, and packet loss.  
It validated KPI sanity and classified QoE condition automatically.  
Finally, it generated actionable network advice in structured output.  
This lab linked AI reasoning with practical 5G performance indicators.

---

## 7) Lab 5 - Ella Core + UERANSIM

## 7.1 Objective

Start Ella Core and UERANSIM environment, run gNB and UE simulators, and validate end-to-end connectivity.

## 7.2 Concept in simple words

Lab 5 simulates real 5G attach/session behavior:

- Core side from Ella Core stack
- Radio and UE side via UERANSIM
- Live signaling and data-plane validation through ping

This is why multiple terminals are required in demonstration.

## 7.3 Folder and runner

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
chmod +x run.sh
./run.sh
```

## 7.4 Multi-terminal demo commands

Terminal A (stack up):

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
./run.sh
```

Terminal B (gNB):

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
docker compose exec -ti ueransim bin/nr-gnb --config /gnb.yaml
```

Terminal C (UE):

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
docker compose exec -ti ueransim bin/nr-ue --config /ue.yaml
```

Terminal D (data plane proof):

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
docker compose exec -ti ueransim ping -I uesimtun0 8.8.8.8 -c4
docker compose ps
```

Browser UI:

- `https://127.0.0.1:5002/`

## 7.5 Inputs used in this lab

- gNB config:
  - `/gnb.yaml`
- UE config:
  - `/ue.yaml`
- Ping interface:
  - `uesimtun0`
- Ping target:
  - `8.8.8.8`

Subscriber values are maintained in:

- `5g-lab-system/lab5-ellacore-ueransim/docs/SUBSCRIBER.md`

## 7.6 Expected output signs

- `docker compose ps` shows core and ueransim containers in `Up` state.
- gNB terminal shows startup without fatal crash.
- UE terminal shows registration/session progression.
- Ping over `uesimtun0` returns replies.
- Ella UI loads and reflects runtime state/subscriber context.

## 7.7 Common issues and fix

- UE fails to register:
  - check subscriber credentials and config matching
- gNB/UE command fails:
  - ensure `ueransim` container is up first
- UI not opening:
  - check HTTPS URL and self-signed cert warning
- ping failure:
  - confirm UE attached and tunnel interface exists

## 7.8 Cleanup commands

```bash
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
docker compose down
```

## 7.9 Viva questions (Lab 5)

1. **What is UERANSIM?**  
   Open-source UE/gNB simulator for 5G SA testing.

2. **Why Ella Core in this lab?**  
   Provides manageable core stack and UI for learning and validation.

3. **Why multiple terminals needed?**  
   Core, gNB, UE, and ping are concurrent runtime processes.

4. **How did you validate successful setup?**  
   Container status, UE registration logs, and ping via UE tunnel.

5. **What causes registration failure most often?**  
   Subscriber and UE security/config mismatch.

6. **What is PDU session in simple words?**  
   Data session that enables UE internet/data connectivity.

## 7.10 5-line viva summary for Lab 5

We started Ella Core and UERANSIM containers as the 5G test environment.  
Then we launched gNB and UE in separate terminals for live signaling.  
UE registration and session behavior were observed through runtime logs.  
Data-plane connectivity was verified using ping on UE tunnel interface.  
This lab demonstrated end-to-end simulated 5G core-to-UE operation.

---

## 8) Combined Viva Master Set (All Labs)

Use this as final exam prep. Keep answers short and clear.

1. **What is the end-to-end 5G path?**  
   UE -> gNB/RAN -> 5G Core -> Internet/Data Network.

2. **AMF in one line?**  
   Control-plane function for registration and mobility.

3. **SMF in one line?**  
   Session manager controlling PDU sessions and policies.

4. **UPF in one line?**  
   User-plane packet forwarding function.

5. **Control plane vs user plane?**  
   Signaling and management vs actual data traffic.

6. **Why Docker used in labs?**  
   Reproducible isolated environment and easy deployment.

7. **REST vs gRPC quick difference?**  
   REST is HTTP+JSON resource style; gRPC is compact binary RPC.

8. **MQTT use case?**  
   Lightweight pub/sub for IoT telemetry.

9. **Swagger role in API projects?**  
   Interactive documentation and endpoint testing.

10. **What is OpenAPI?**  
   Standard API contract format.

11. **What is QoE?**  
   User-perceived quality of service experience.

12. **Why AI for QoE analysis?**  
   Converts KPI patterns into classification and actionable advice.

13. **What is UERANSIM?**  
   Software simulator for UE and gNB behavior.

14. **Why Lab 5 needs many terminals?**  
   Concurrent runtime components require separate live sessions.

15. **How to prove practical success in viva?**  
   Show command, output, logs, and one-sentence interpretation.

---

## 9) Report Writing Template (Use for each lab PDF)

Follow this structure to create high-quality submission:

1. Title page (Lab no, name, roll no, date)
2. Objective (3-5 bullet points)
3. Tools and environment
4. Architecture/flow diagram
5. Step-by-step commands (copied exactly)
6. Input values used
7. Output screenshots with explanation
8. Error faced and fix applied
9. Learning outcome (5 bullet points)
10. Viva prep Q/A (8-12 questions)

### Caption format for screenshot

Use this exact line pattern:

- `Command executed: ...`
- `Observed output: ...`
- `Interpretation: ...`

---

## 10) Quick Exam Day Revision

If time is very less, revise these points:

- Lab 1: Docker + REST + MQTT + gRPC proof commands
- Lab 2: Swagger UI + OpenAPI + POST/GET flow
- Lab 3: AMF/SMF/UPF and core status verification
- Lab 4: KPI input -> QoE output -> advice
- Lab 5: stack + gNB + UE + ping with multi-terminal demo

### 60-second all-lab summary

In Lab 1, we validated containerized transport protocols (REST, MQTT, gRPC).  
In Lab 2, we built and tested documented APIs using Spring Boot and Swagger.  
In Lab 3, we executed and verified 5G core workflows through Open5GS/Free5GC checks.  
In Lab 4, we applied AI workflow logic to classify QoE from network KPIs.  
In Lab 5, we simulated live 5G attach/session behavior using Ella Core and UERANSIM.

---

## Appendix A - Commands from your current workflow notes

These are included because they match your practical execution style:

```bash
# Lab 1 and Lab 2 style in your notes
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab2-spring-swagger"
chmod +x run.sh
./run.sh

# Lab 4 cleanup and rerun style from your notes
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system"
cd lab1-docker-transport && docker compose down && cd ..
cd lab5-ellacore-ueransim && docker compose down && cd ..
docker system prune -a --volumes
rm -rf ~/.ollama/models/blobs/*partial
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab4-ai-qoe"
bash run.sh

# Lab 5 multi-terminal sequence from your notes
cd "/home/codehasira23/AI IN %G/AI-IN-5G-LABS/5g-lab-system/lab5-ellacore-ueransim"
bash run.sh
docker compose exec -ti ueransim bin/nr-gnb --config /gnb.yaml
docker compose exec -ti ueransim bin/nr-ue --config /ue.yaml
```

---

## Appendix B - Mini Glossary

- **UE**: user equipment (phone/modem/simulator client)  
- **gNB**: 5G base station (radio side)  
- **AMF**: access and mobility management  
- **SMF**: session management function  
- **UPF**: user plane forwarding  
- **PDU Session**: user data session setup  
- **QoS**: network quality metrics  
- **QoE**: user-perceived quality  
- **SBA**: service-based architecture in 5G core  
- **NF**: network function

---

## Final Learning Outcome

By completing Labs 1-5, you practiced:

- multi-protocol service communication
- API-first backend validation
- 5G core component understanding
- AI-assisted KPI to QoE reasoning
- full end-to-end simulated 5G workflow demonstration

This makes your practical profile strong for viva, project interviews, and higher-level 5G/AI lab work.
