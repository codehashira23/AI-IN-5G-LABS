# === FILE: lab1.md ===

**Environment:** Ubuntu **22.04 LTS**  
**Topic:** Docker + **REST**, **gRPC**, **MQTT**

---

## 1. Objective

- Use **Docker** to run isolated services.  
- Show **REST** (HTTP/JSON-style) communication.  
- Show **gRPC** (RPC between client/server).  
- Show **MQTT** publish/subscribe.  
- Capture **screenshots** with short explanations for your PDF report.

---

## 2. Tools Used

| Tool | Role |
|------|------|
| **Docker** | Packages each demo app + dependencies in a **container** |
| **curl** | Tests **REST** APIs from terminal |
| **gRPC** stack | Language-specific (often Python/Java/Go) — client + server binaries in containers |
| **MQTT broker** (e.g. **Mosquitto**) | Message hub; apps **publish** / **subscribe** |

---

## 3. What You Actually Did (Step Flow)

Follow your **official lab manual** first; this is a typical flow:

1. **Install Docker** on Ubuntu → verify with `docker run hello-world`.  
2. **Build images** from `Dockerfile` (REST service, gRPC server, MQTT broker/client).  
3. **Run containers** (`docker run` or `docker compose up`).  
4. **REST:** call API with `curl`, see JSON/status codes.  
5. **gRPC:** run client → it talks to server → see RPC response in terminal.  
6. **MQTT:** start broker → terminal A **subscribe** → terminal B **publish** → message appears.  
7. **Screenshots:** Docker proof, build, run, each protocol output + 2–4 lines explanation.

---

## 4. Commands Section

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `sudo apt update && sudo apt install -y docker.io docker-compose-plugin` | Installs Docker engine + compose (Ubuntu repo path) | Lab machine ready |
| `sudo systemctl enable --now docker` | Starts Docker on boot / now | Avoid “daemon not running” |
| `sudo usermod -aG docker $USER` + **re-login** | Lets you run `docker` without `sudo` every time | Convenience + permission fix |
| `docker --version` | Shows Docker version | Proof in report |
| `docker run --rm hello-world` | Pulls tiny test image, prints success | Verify install |
| `docker build -t myrest:1 .` | Builds image from `Dockerfile` in current folder | REST lab image |
| `docker compose up -d` | Starts services in background per `docker-compose.yml` | Multi-container REST/MQTT stack |
| `docker ps` | Lists running containers | Show “running” screenshot |
| `docker logs <container>` | Prints app logs | Debug REST/gRPC/MQTT |
| `curl -i http://localhost:8080/health` | HTTP GET with headers | REST test |
| `curl -X POST http://localhost:8080/api/... -H "Content-Type: application/json" -d '{"k":"v"}'` | Sends JSON POST | REST create/update demo |
| `docker exec -it <container> bash` | Shell inside container | Debug inside box |
| `mosquitto_sub -h localhost -t demo/topic -v` | MQTT subscribe (if broker on host) | See messages live |
| `mosquitto_pub -h localhost -t demo/topic -m "hello"` | MQTT publish | Generate traffic |
| `hostname` | Prints machine name | Often required next to running service |
| `date` | Prints current date/time | Screenshot requirement |

**gRPC:** manual usually gives `./client` or `python client.py` — treat as **run client after server**; same table style in your report: *command → connects to server → prints RPC result*.

---

## 5. Output / Expected Result

| Step | Success looks like |
|------|---------------------|
| Docker install | `hello-world` prints “Hello from Docker!” |
| Image build | Final line “Successfully tagged …” |
| Container run | `docker ps` shows **STATUS = Up** |
| REST | `curl` returns **200** + expected JSON/body |
| gRPC | Client prints server response **without** connection errors |
| MQTT | Subscriber terminal **shows message** when publisher sends |

---

## 6. Common Errors + Fixes

| Error / symptom | Quick fix |
|-----------------|-----------|
| `permission denied` on Docker socket | `sudo usermod -aG docker $USER` then **log out and in** (or reboot) |
| `Cannot connect to Docker daemon` | `sudo systemctl start docker` |
| Port already in use | Change host port in `docker-compose.yml` (`8080:80` → `8081:80`) or stop old container |
| `curl: connection refused` | Container not up / wrong port / firewall; check `docker ps` and `ss -tulpn` |
| gRPC “UNAVAILABLE” | Server container not running or wrong **host:port** in client |
| MQTT no messages | Wrong **topic** spelling; broker not on assumed host; subscribe started **before** publish |

---

## 7. Viva Questions for This Lab

| Question | Short answer | Examiner expects |
|----------|--------------|------------------|
| What is a container? | Isolated process/filesystem bundle sharing host kernel | vs full VM |
| Image vs container? | Image = recipe; container = running instance | lifecycle |
| Why Docker for this lab? | Reproducible env, one command deploy | devops angle |
| What is REST? | HTTP verbs + resources, often JSON | statelessness, simple |
| What is gRPC? | RPC, protobuf, HTTP/2 | efficient internal APIs |
| What is MQTT? | Pub/sub, lightweight | IoT, broker model |
| What is a topic? | Named channel subscribers listen to | decoupling publishers |

---

## 8. Lab Flow Summary (Revision)

1. Install/enable **Docker** on Ubuntu 22.04.  
2. **Build** images from lab repo.  
3. **Run** containers (compose or `docker run`).  
4. Prove **REST** with **curl** (GET/POST).  
5. Prove **gRPC** with client/server logs.  
6. Prove **MQTT** with **pub/sub** terminals.  
7. Screenshot each major step + **hostname/date** where required.  
8. One **PDF** submission with explanations under each figure.
