# === FILE: concepts_and_viva.md ===

Beginner notes: all lab-style commands below assume **Ubuntu 22.04 LTS** (Jammy). Replace usernames/paths with yours.

---

## 1. Big Picture (START HERE)

### What is **5G** (simple)

**5G** is the fifth generation of mobile networks. It connects your **phone / IoT device (UE)** to the internet through **radio towers (gNB)** and a **5G core** (computers + software that handle identity, sessions, and data routing).

### Why it exists

- **More capacity**: many users and devices at once  
- **Lower delay** (**latency**): better for gaming, AR/VR, industrial control  
- **Flexible services**: same network can support different needs (**network slicing**)

### Real-world analogy

Think of **5G** like a **smart airport**:

- **UE** = passenger  
- **gNB** = boarding gate + security checkpoint (first contact)  
- **5G Core** = immigration, baggage system, airlines’ IT (who you are, where you’re allowed to go, how traffic flows)  
- **Internet / server** = your destination city  

### End-to-end flow (one line)

**UE → gNB (RAN) → 5G Core → Internet / application server**

---

## 2. Core Concepts (Explain Simply)

| Term | What it is | Why needed | Where used |
|------|------------|------------|------------|
| **UE** (User Equipment) | Your device: phone, dongle, IoT module, or **simulator** (e.g. **UERANSIM**) | Something must connect over the air | Labs: simulated UE attaches to core |
| **gNB** (5G base station) | Radio + **RAN** control for 5G New Radio | Converts radio ↔ packets, manages radio resources | Real towers; labs: **UERANSIM** can act like gNB + UE depending on setup |
| **RAN** (Radio Access Network) | Everything “radio side” up to the core edge | Moves bits wirelessly | Field: towers; lab: simulators |
| **AMF** (Access and Mobility Management Function) | **Control plane**: registration, mobility, connection management | Core must know **who** is attached and **where** | Open5GS / free5GC / Ella Core stacks |
| **SMF** (Session Management Function) | **Control plane** for **PDU sessions** (data sessions) | Creates/updates/releases sessions, IP policy | Same stacks |
| **UPF** (User Plane Function) | **User plane**: actually forwards **user data packets** | Fast path for internet traffic | Same stacks |
| **5G Core** | Set of **Network Functions (NFs)** working together | Central brain + data path for 5G | Open5GS, free5GC, Ella Core, etc. |
| **Control plane vs User plane** | **Control** = signaling (register, authenticate, “open a session”). **User** = your actual browsing/video bytes | Separation keeps signaling reliable and allows scaling data separately | AMF/SMF = control; UPF = user |
| **SBA** (Service Based Architecture) | NFs talk via **HTTP/2 + REST-style APIs** (service discovery, etc.) | Easier to deploy in cloud, upgrade per function | Modern cores (3GPP 5GC) |
| **NFV** (Network Functions Virtualization) | Run NFs as **software on generic servers** instead of custom boxes | Cheaper, faster updates | Almost all lab cores |
| **SDN** (Software Defined Networking) | Control of forwarding can be **centralized/programmed** | Flexible routing, slicing support | Often paired with NFV in teaching |
| **Network slicing** | Logical “private networks” on same physical infra | One slice for broadband, one for low-latency factory, etc. | Advanced topic; mentioned in viva |

---

## 3. Simulation Tools Overview

### **Open5GS**

| | |
|--|--|
| **Purpose** | Open-source **5G Core** implementation for learning and testing |
| **Key parts** | AMF, SMF, UPF, AUSF, UDM, PCF, NRF, … (as separate processes/services) |
| **Why in labs** | Start a real-style core on **Ubuntu**, watch logs, verify registration |

### **free5GC**

| | |
|--|--|
| **Purpose** | Another open **5G Core** (research / education friendly) |
| **Key parts** | Similar NFs + **WebConsole** for subscribers |
| **Why in labs** | Compare with Open5GS; practice **subscriber** creation in UI |

### **FlexRIC**

| | |
|--|--|
| **Purpose** | **O-RAN** style **RIC** (RAN Intelligent Controller) research platform — “smart” radio control / xApps |
| **Key parts** | Near-RT RIC concepts, E2 interface (in advanced courses) |
| **Why in labs** | When course covers **AI/optimization in RAN** (not always in every lab set) |

### **ELLACore** (Ella Core)

| | |
|--|--|
| **Purpose** | Packaged environment to **simulate / visualize** 5G core workflows (subscriber, attach, dashboards) |
| **Key parts** | Web UI, subscriber management, hooks for **radio** and **UE** simulators |
| **Why in labs** | Your **Lab 5**: connect **UERANSIM**-style UE/RAN simulation and **validate** end-to-end |

### How they fit together (mental map)

- **Open5GS / free5GC** = “I’m running a **core** like an operator.”  
- **UERANSIM** = “I’m faking **UE** and/or **gNB** traffic toward that core.”  
- **ELLACore** = “I’m using a **guided** simulation + UI for the same big picture.”  

---

## 4. End-to-End Flow (VERY IMPORTANT)

### A. **UE registration** (simplified)

1. UE finds a cell (simulator config points to core/RAN).  
2. UE sends **registration request** toward **AMF** (via RAN).  
3. AMF talks to other NFs (e.g. **AUSF/UDM**) to **identify** subscriber.  
4. AMF completes registration; UE gets **allowed services** context.

### B. **Authentication** (idea only)

- Proves **SIM / credentials** match operator data.  
- Uses 5G **AKA**-style procedures (details are heavy; for viva: “verify identity with home network”).

### C. **Session establishment** (PDU session)

1. UE requests a **data session** (PDU session).  
2. **SMF** picks policy, assigns or coordinates **IP** / session rules.  
3. **UPF** is selected for the **user plane path**.  
4. Tunnel / GTP-U style forwarding is set up (lab level: “data path ready”).

### D. **Data transfer**

- User traffic flows: **UE ↔ RAN ↔ UPF ↔ Internet**.  
- Control messages can still flow on separate paths to **SMF/AMF**.

### ASCII sketch

```
  [ UE ] ~~~~ air ~~~~ [ gNB / RAN ] === signaling ===> [ AMF / SMF ... ]
                              \
                               === user packets ===> [ UPF ] ===> [ Internet ]
```

---

## 5. VIVA QUESTIONS (HIGH PRIORITY)

Each: **short answer** → **simple explanation**.

1. **What is the difference between UE and gNB?**  
   - **Short:** UE is the device; gNB is the base station.  
   - **Explain:** UE generates user traffic; gNB serves many UEs over the radio.

2. **What does AMF do?**  
   - **Short:** Registration and mobility management.  
   - **Explain:** It is the UE’s first anchor in the core for control; it does not forward bulk user data.

3. **What does SMF do?**  
   - **Short:** Manages PDU sessions.  
   - **Explain:** Session create/modify/release; talks to UPF for forwarding rules.

4. **What does UPF do?**  
   - **Short:** Forwards user data.  
   - **Explain:** It sits on the path to the internet or local DN.

5. **Control plane vs user plane?**  
   - **Short:** Control = signaling; user = payload.  
   - **Explain:** Separates “management” from “bulk traffic” for scale and reliability.

6. **Why use Docker in Lab 1?**  
   - **Short:** Same environment everywhere; easy deploy.  
   - **Explain:** Containers package apps + deps for REST/gRPC/MQTT demos.

7. **What is gRPC vs REST?**  
   - **Short:** gRPC is RPC over HTTP/2 with protobuf; REST is HTTP + JSON common pattern.  
   - **Explain:** gRPC efficient for internal services; REST simple for browsers/tools.

8. **What is MQTT used for?**  
   - **Short:** Lightweight pub/sub messaging.  
   - **Explain:** IoT sensors publish topics; subscribers receive updates.

9. **Open5GS vs free5GC in one line each?**  
   - **Short:** Both are open 5GC implementations; different codebases/UI.  
   - **Explain:** Same teaching goal: run NFs, see registration/session logs.

10. **What is UERANSIM?**  
    - **Short:** Open UE/gNB simulator for 5G SA.  
    - **Explain:** Lets you test core without real radio hardware.

11. **What is network slicing?**  
    - **Short:** Multiple logical networks on one physical network.  
    - **Explain:** Different QoS/isolation per “slice” for different services.

12. **What is SBA?**  
    - **Short:** Core network functions expose services via APIs.  
    - **Explain:** Easier automation, scaling, and vendor mixing than monolith.

---

## 6. Quick Revision Sheet

### Key terms

UE, gNB, RAN, AMF, SMF, UPF, PDU session, control/user plane, SBA, NFV, slicing, Open5GS, free5GC, ELLACore, UERANSIM, Docker, REST, gRPC, MQTT, LangGraph (Lab 3/4), Ollama (Lab 3/4).

### Ubuntu 22.04 — useful commands

| Command | What it does |
|---------|----------------|
| `sudo apt update` | Refreshes package lists |
| `sudo apt install -y docker.io` | Installs Docker from Ubuntu repos (simple path) |
| `sudo systemctl status docker` | Checks Docker daemon |
| `docker ps` | Lists running containers |
| `docker compose up -d` | Starts stack from `docker-compose.yml` |
| `curl -v http://IP:PORT/path` | Tests REST HTTP |
| `hostname` / `date` | Often required in lab screenshots |
| `journalctl -u SERVICE -f` | Follow systemd logs for a service |
| `ss -tulpn` | See listening ports (debug API/UI) |

### Most asked viva angles

- **E2E path** UE → RAN → UPF → internet  
- **AMF / SMF / UPF** one-liners  
- **Why simulators** (cost, repeatability)  
- **Docker** = packaging / isolation  
- **REST vs gRPC** (when/why)  
- **QoE lab**: what each **agent** checks (sanity, classification, advice, memory)

---

*This master file aligns with your course lab briefs (Docker, Open5GS/free5GC, QoE agents, Ella Core + UERANSIM).*
