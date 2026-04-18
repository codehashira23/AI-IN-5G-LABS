# === FILE: lab2.md ===

**Environment:** Ubuntu **22.04 LTS**  
**Topic:** **Open5GS**, **free5GC**, **Spring Boot** + **Swagger UI**

---

## 1. Objective

- **Part A:** Start **Open5GS** and show core services running + logs.  
- **Part B:** Build/run **free5GC**, open **WebConsole**, show subscriber / status.  
- **Part C:** Run **Spring Boot** app, open **Swagger UI**, execute APIs.  
- Submit **one PDF** with required screenshots (each with 2–4 line explanation).  
- At least one terminal screenshot must show **`hostname`** and **`date`** with a running service.

---

## 2. Tools Used

| Tool | Role |
|------|------|
| **Open5GS** | Open 5G Core — systemd or binary processes (AMF, SMF, UPF, …) |
| **free5GC** | Alternative 5GC + **WebConsole** |
| **Java + Maven/Gradle** | Build/run Spring Boot |
| **Spring Boot** | Hosts REST APIs |
| **Swagger UI** | Browser UI to try APIs |

---

## 3. What You Actually Did (Step Flow)

**Part A — Open5GS**

1. Install dependencies + Open5GS (per your manual: package or source).  
2. Configure minimal files if manual says (e.g. subscriber, DNN).  
3. Start services (`systemctl` or provided script).  
4. Capture: services **running**, **startup logs**, **verification** (`systemctl status` or log grep).

**Part B — free5GC**

1. Clone/build free5GC per manual.  
2. Run `./run.sh` (or documented command).  
3. Open **WebConsole** in browser (HTTPS port from doc).  
4. Create/verify **subscriber**; screenshot UI + NF registration logs.

**Part C — Spring Boot + Swagger**

1. Import/run Spring Boot project (`./mvnw spring-boot:run` or `java -jar`).  
2. Open **Swagger UI** URL (often `http://localhost:8080/swagger-ui.html` or `/swagger-ui/index.html`).  
3. Execute **GET/POST** from Swagger; screenshot **response**.

---

## 4. Commands Section

### System / proof (screenshots)

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `hostname` | Shows machine name | Lab submission requirement |
| `date` | Shows timestamp | Lab submission requirement |

### Open5GS (typical patterns — follow your manual first)

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `sudo systemctl start open5gs-amfd` *(example)* | Starts AMF daemon | Bring up NF (exact names depend on install) |
| `sudo systemctl status 'open5gs-*'` or specific unit | Shows active/failed state | Verification screenshot |
| `sudo journalctl -u open5gs-amfd -f` *(example)* | Live logs for one NF | Startup / error analysis |
| `ss -tulpn \| grep LISTEN` | Lists listeners + process | Find AMF/SMF web if needed |

*Note:* Unit names differ between **apt** install vs **from source**. Your manual lists the exact services.

### free5GC

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `./run.sh` | Starts free5GC NFs as configured | Core “running” screenshot |
| `./webconsole` or manual’s console start | Starts Web UI backend | Access subscriber UI |
| `tail -f logfile` | Follow log | NF registration lines |

### Spring Boot

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `./mvnw spring-boot:run` | Runs app with Maven wrapper | Dev run |
| `java -jar target/*.jar` | Runs packaged jar | Prod-style run |
| `curl http://localhost:8080/v3/api-docs` | Prints OpenAPI JSON | Verify Swagger backend |

---

## 5. Output / Expected Result

| Part | What should happen |
|------|---------------------|
| Open5GS | Key NFs **active**; logs without fatal bind/auth errors (exact “OK” depends on manual). |
| free5GC | `./run.sh` shows NFs **register**; WebConsole **loads**; subscriber **visible/created**. |
| Spring Boot | Terminal shows **Started …Application**; Swagger shows **operations**; **Try it out** returns **200** + body. |

---

## 6. Common Errors + Fixes

| Issue | Fix |
|-------|-----|
| Service **failed** (address already in use) | Another NF using port; `ss -tulpn` find culprit; stop duplicate |
| **MongoDB/DB not running** | Many cores need DB; start `mongod` per manual |
| **TUN** / routing errors for UPF | Often needs `ip tuntap` / sysctl; follow Open5GS networking doc |
| WebConsole **TLS** warning | Use exact `https://host:port` from doc; trust self-signed if instructed |
| Swagger **404** | Wrong path; Springdoc vs springfox; check Boot version in manual |
| `hostname`/`date` missing in screenshot | Re-run in same terminal before capture |

---

## 7. Viva Questions for This Lab

| Question | Short answer | Key points |
|----------|--------------|------------|
| What did Open5GS demonstrate? | Running 5GC NFs locally | AMF/SMF/UPF “exist” as processes |
| free5GC WebConsole purpose? | Manage subscribers / view core | ops-like UI |
| Why two cores in one lab? | Compare implementations | both 3GPP-oriented |
| Swagger’s role? | Interactive API test | documents + tries REST |
| Difference AMF vs SMF? | AMF mobility/reg; SMF sessions | control plane split |
| Why `hostname`/`date` in screenshot? | Proves **your** machine/time | academic integrity |

---

## 8. Lab Flow Summary (Revision)

1. Ubuntu 22.04 ready; DB/services deps from manual.  
2. **Open5GS** up → status + logs → screenshots.  
3. **free5GC** `./run.sh` → logs → **WebConsole** → subscriber.  
4. **Spring Boot** run → **Swagger** → GET/POST success.  
5. Every screenshot: **command + output + concept**.  
6. Include **hostname** + **date** with a running service once.  
7. Name PDF: **`RollNo_Name_Lab2.pdf`**.  
8. Single consolidated **PDF** only.
