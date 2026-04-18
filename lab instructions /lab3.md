# === FILE: lab3.md ===

**Environment:** Ubuntu **22.04 LTS**  
**Topic:** **Multi-Agent AI-Based QoE Analysis** for 5G (LangGraph + **Ollama**)

> Your provided `lab3` and `lab4` instruction text files are **identical**. This file is the **main walkthrough**; see `lab4.md` for extension/revision emphasis.

---

## 1. Objective

- Build a **multi-agent** workflow that analyses **QoE** (Quality of Experience) style scenarios for **5G** (KPIs, user perception, advice).  
- Use **Ollama** with model **`llama3.1:8b`**.  
- Implement agents: **KPI Sanity Check**, **QoE Classification**, **Human Review**, **Network Advice**, **Memory**.  
- **LangGraph** workflow + optional **LangSmith** traces.  
- Submit **one PDF** with screenshots and explanations.

---

## 2. Tools Used

| Tool | Role |
|------|------|
| **Python** + venv | Runs agents and workflow |
| **Ollama** | Local LLM server; runs **llama3.1:8b** |
| **LangGraph** | Orchestrates agents as a graph/state machine |
| **LangSmith** (optional) | Trace runs, tokens, latency |
| Lab repo / manual | Exact file names and graph diagram |

---

## 3. What You Actually Did (Step Flow)

1. **Dependencies:** create venv; `pip install -r requirements.txt` (per manual).  
2. **Ollama:** install from official Linux instructions; `ollama serve` running.  
3. **Model:** `ollama pull llama3.1:8b` → wait for success.  
4. **Agents:** implement or fill each agent module per manual.  
5. **LangGraph:** connect nodes/edges; compile graph; run sample **scenarios**.  
6. **Outputs:** save **final report** text/JSON; screenshot console + any UI diagram.  
7. **Experiments (required by brief):** tweak few-shot; improve advice agent; real human review; add new agent (e.g. **Trend Analysis**).  
8. **LangSmith (if used):** API keys in env; screenshot trace.  
9. Assemble **PDF** with headings: Model Setup → System → Experiments → Monitoring.

---

## 4. Commands Section

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `python3 -m venv .venv && source .venv/bin/activate` | Creates + activates venv | Clean Python deps |
| `pip install -U pip && pip install -r requirements.txt` | Installs libraries | LangChain/LangGraph stack |
| `curl -fsSL https://ollama.com/install.sh \| sh` | Installs Ollama (official) | LLM runtime on Ubuntu |
| `ollama serve` | Starts Ollama API server | Background terminal |
| `ollama pull llama3.1:8b` | Downloads model weights | Required model |
| `ollama list` | Lists local models | Screenshot “model present” |
| `python main.py` *(or manual’s entry)* | Runs workflow | Task outputs |
| `export LANGCHAIN_TRACING_V2=true` etc. | Enables LangSmith tracing | Optional monitoring |
| `hostname` / `date` | Machine/time proof | Good habit for reports |

---

## 5. Output / Expected Result

| Item | Success indicator |
|------|-------------------|
| Model pull | `ollama list` shows **llama3.1:8b** |
| Workflow | Graph runs end-to-end **without** Python tracebacks |
| Agents | Each stage produces **meaningful** text (sanity → classify → …) |
| Final report | Consolidated summary for a scenario | screenshot |
| Experiments | You can **point to code diff** + new output | PDF section |
| LangSmith | Trace shows steps/tokens (if configured) | screenshot |

---

## 6. Common Errors + Fixes

| Issue | Fix |
|-------|-----|
| `Connection refused` to Ollama | Start `ollama serve`; check `11434` listening |
| Out of RAM / slow | Use **8b** only; close apps; smaller batch in manual |
| LangGraph errors | Node name mismatch; return dict keys must match state schema |
| LangSmith no traces | Env vars unset; wrong project; network blocked |
| `pip` conflicts | Always in **venv**; pin versions from manual |

---

## 7. Viva Questions for This Lab

| Question | Short answer | Examiner expects |
|----------|--------------|------------------|
| What is QoE? | User-perceived quality (not just bitrate) | KPIs vs experience |
| Why multi-agent? | Split tasks; easier to debug/extend | modularity |
| KPI Sanity agent? | Detect impossible/inconsistent KPIs | guardrail |
| QoE Classification agent? | Label experience (good/fair/poor) | mapping KPIs→QoE |
| Human Review agent? | Human-in-the-loop approval/edits | trust/safety |
| Network Advice agent? | Actionable recommendations | ops flavor |
| Memory agent? | Stores past context/decisions | multi-turn coherence |
| Why Ollama? | Local LLM without cloud API | privacy/cost |
| LangGraph purpose? | Structured multi-step flow | vs loose script |

---

## 8. Lab Flow Summary (Revision)

1. Ubuntu **venv** + `requirements.txt`.  
2. Install/run **Ollama**; **`ollama pull llama3.1:8b`**.  
3. Implement **five agents** + **LangGraph** workflow.  
4. Run **scenarios**; capture **diagram**, pulls, outputs, **final report**.  
5. Do **experimental** tasks + optional **LangSmith**.  
6. One **PDF**, clear headings, every screenshot explained.  
7. Be ready to explain **each agent** in one sentence.  
8. Relate to 5G: **KPIs** (throughput, latency, loss) → **QoE** reasoning.
