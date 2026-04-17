# === FILE: lab5.md ===

**Environment:** Ubuntu **22.04 LTS**  
**Topic:** **ELLACore** + **UERANSIM** — simulate **5G** attach / session style flow

---

## 1. Objective

Per assignment brief:

1. Install **Ella Core** and **UERANSIM**  
2. **Initialize** Ella Core  
3. Create a **Subscriber**  
4. Connect **5G Radio** simulator  
5. Connect **User Equipment** simulator  
6. **Validate** the connection  
7. **Clean up**  
8. Submit **one PDF** (`YourName_RollNo_Ella_core_Assignment.pdf`) with listed screenshots.

---

## 2. Tools Used

| Tool | Role |
|------|------|
| **ELLACore** | Web-based **5G core** simulation / management (dashboard, subscribers) |
| **UERANSIM** | **Open-source** UE + gNB simulator (5G SA) generating NAS/RAN traffic toward core |
| **Ubuntu 22.04** | Host OS; build UERANSIM per its CMake/gcc deps |

*Exact install URLs and versions follow your **laboratory manual** (course-specific).*

---

## 3. What You Actually Did (Step Flow)

1. **Install ELLACore** using manual (Docker/AppImage/deb — follow doc).  
2. **Open** initialization/setup page → complete wizard → **dashboard** reachable.  
3. **Subscriber:** create profile matching **UERANSIM** config (SUPI, key, OPC, DNN, SST/SD if shown).  
4. **Radio simulator:** start/connect component manual names “5G Radio Simulator” (may be UERANSIM **gNB** side or integrated service).  
5. **UE simulator:** run UERANSIM **UE** with config pointing to **AMF** IP/port from Ella Core (or manual topology).  
6. **Validate:** UE shows **registered** / PDU session **established**; Ella Core subscriber/session **updates**.  
7. **Screenshots:** init page, dashboard, subscriber page, radio connection, UE connection, **updated subscribers**, terminal window.  
8. **Clean up:** stop UE/gNB processes; stop Ella Core stack; remove test subscriber if instructed.

---

## 4. Commands Section

### Ubuntu prep (typical for UERANSIM build)

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `sudo apt update && sudo apt install -y build-essential cmake libsctp-dev lksctp-tools git` | Compiler + SCTP deps | UERANSIM build prerequisites (common) |
| `git clone <ueransim-repo>` | Gets source | Install step |
| `cd UERANSIM && mkdir build && cd build && cmake .. && make -j$(nproc)` | Builds binaries | Produces `nr-gnb`, `nr-ue` (names per version) |
| `./nr-ue -c ../config/ue.yaml` *(example)* | Starts UE with config | Attach test |
| `./nr-gnb -c ../config/gnb.yaml` *(example)* | Starts gNB | Radio side |

**ELLACore:** often **browser + Docker Compose** or installer — use manual’s exact:

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `docker compose up -d` | Starts Ella stack | If manual uses Compose |
| `docker ps` | Shows containers | Verify running |
| `ss -tulpn \| grep LISTEN` | Find web/dashboard port | If URL unclear |

### Debug / logs

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `ping <AMF_IP>` | Basic reachability | UE machine to core |
| `tail -f /path/to/log` | Follow log | NAS/NGAP errors |
| `hostname` / `date` | Identity/time | Good for PDF evidence |

Replace YAML names and paths with **your manual’s** tree.

---

## 5. Output / Expected Result

| Stage | What confirms success |
|-------|------------------------|
| Ella init | Setup completes; you can log in / see **dashboard** |
| Subscriber | Subscriber row exists with **matching** SUPI/security as UE config |
| Radio + UE | Processes running; terminal shows **RRC/NGAP/NAS** progression (exact lines per version) |
| Validation | **Registered** state; **PDU session** active; dashboard shows updated **session/subscriber** |
| Cleanup | After stop, no zombie processes; ports free |

---

## 6. Common Errors + Fixes

| Issue | Fix |
|-------|-----|
| UE **cannot reach AMF** | Wrong **AMF IP** in `amf.yaml` / UE config; firewall; Docker bridge IP |
| **PLMN mismatch** | MCC/MNC in UE **must match** core config |
| **Authentication failure** | Key/OPc mismatch with subscriber record |
| **DNN / APN** wrong | Session fails; align DNN with core slice defaults |
| SCTP errors | Install `libsctp-dev`; load sctp module if manual says |
| Web UI not loading | Wrong port; HTTPS vs HTTP; container not started |

---

## 7. Viva Questions for This Lab

| Question | Short answer | Key points |
|----------|--------------|------------|
| What is UERANSIM? | Open UE+gNB simulator for 5G SA | testing core without hardware |
| Why ELLACore? | Guided UI + core simulation for learning | faster visualization |
| What is a subscriber record? | SUPI + credentials + slice/DNN profile | must match UE |
| What does “attach” mean? | UE registers with **AMF** and becomes known | control plane |
| What is PDU session? | User data session through **SMF/UPF** | user plane |
| How did you validate success? | Logs + UI showing registered/session | evidence-based |
| What did you clean up? | Stopped simulators + removed test data | resource discipline |

---

## 8. Lab Flow Summary (Revision)

1. Install **ELLACore** on Ubuntu 22.04 per manual.  
2. **Initialize** → **dashboard** OK.  
3. **Subscriber** created = same IDs/keys as **UERANSIM** YAML.  
4. Start **gNB** (radio) then **UE** (or order per manual).  
5. Confirm **registration + session** in **terminal + UI**.  
6. Capture **all required screenshots** with short captions.  
7. **Clean up** processes/subscriber.  
8. Export **`YourName_RollNo_Ella_core_Assignment.pdf`**.
