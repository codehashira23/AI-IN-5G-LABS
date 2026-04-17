# === FILE: lab4.md ===

**Environment:** Ubuntu **22.04 LTS**  
**Topic:** **Multi-Agent AI-Based QoE Analysis** (same course brief as Lab 3)

> The instruction file in your folder for **Lab 4** matches **Lab 3** (same QoE / Ollama / LangGraph brief). Treat **Lab 4** as a **second deliverable milestone** or **advanced iteration**: same codebase path, stronger emphasis on **experiments**, **LangSmith**, and **viva depth**.

---

## 1. Objective

- Same core system as Lab 3: **QoE-oriented multi-agent** workflow with **Ollama (`llama3.1:8b`)** and **LangGraph**.  
- Lab 4 focus (recommended): **document changes**, **measurable improvements**, and **monitoring**.

---

## 2. Tools Used

Same as Lab 3: **Python**, **Ollama**, **LangGraph**, optional **LangSmith**, dependencies from manual.

---

## 3. What You Actually Did (Step Flow)

1. Start from **working Lab 3 baseline** (do not rebuild from zero unless course says so).  
2. **Few-shot edits:** change examples; re-run same scenario; **compare** outputs in PDF table (before/after).  
3. **Enhance Network Advice agent:** add rules, RAG snippet, or stricter prompt; show **code** + new recommendation text.  
4. **Real human review:** run flow where human input is taken from terminal/UI; screenshot prompt + result.  
5. **New agent (e.g. Trend Analysis):** reads time-series of KPIs; output “improving/degrading”; wire into graph **before** final report.  
6. **LangSmith:** enable tracing; capture **run URL** or trace screenshot; note **tokens** and slow steps.  
7. PDF: highlight **what changed since Lab 3** in a short upfront section.

---

## 4. Commands Section

All commands from **lab3.md** still apply. Add these for iteration/debug:

| COMMAND | WHAT IT DOES | WHY USED |
|---------|----------------|----------|
| `git diff` | Shows code changes | Evidence for “what changed” |
| `pytest` *(if repo has tests)* | Runs unit tests | Safer refactors |
| `python -m py_compile file.py` | Syntax check | Quick error catch |
| `ollama run llama3.1:8b "ping"` | Quick model sanity | Is LLM responsive |
| `env \| grep LANG` | Shows LangSmith-related env | Verify tracing config |

---

## 5. Output / Expected Result

| Deliverable | Expected |
|-------------|----------|
| Few-shot change | Clear **before/after** example + different agent behavior |
| Advice agent | **Stronger** or more **constrained** recommendations |
| Human review | Proof of **actual human** input affecting output |
| New agent | Extra section in final report; graph includes new node |
| LangSmith | Trace + **1–2 sentences** on tokens/performance |

---

## 6. Common Errors + Fixes

| Issue | Fix |
|-------|-----|
| “Lab 4 same as Lab 3” in viva | Explain **delta**: experiments + monitoring + new agent | graders want **progress** |
| Graph breaks after new agent | Check state merges; ensure new node returns correct keys |
| Human step blocks forever | Add timeout or default path in code (if manual allows) |
| LangSmith empty | Confirm API key, project name, and outbound HTTPS |

---

## 7. Viva Questions for This Lab

| Question | Short answer | Key points |
|----------|--------------|------------|
| What did you change in few-shot? | Updated examples to reduce X bias | show concrete example |
| How did you enhance advice? | Added constraints / context source | safety + usefulness |
| Why human-in-the-loop? | Catch LLM mistakes; compliance | governance |
| What does Trend agent add? | Temporal KPI reasoning | beyond single snapshot |
| LangSmith value? | Debug graph, latency, cost | observability |
| Failure mode of pure LLM QoE? | Hallucinated KPI interpretation | why sanity agent matters |

---

## 8. Lab Flow Summary (Revision)

1. Baseline from **Lab 3** running on Ubuntu 22.04.  
2. **Iterate**: few-shot + advice agent with **evidence** (diff + outputs).  
3. **Human review** path demonstrated once.  
4. **New agent** integrated into **LangGraph**.  
5. **LangSmith** trace (or explain honestly if disabled).  
6. PDF structured + “**Changes since Lab 3**” section.  
7. Viva: speak to **metrics** (tokens/time) and **5G KPI meaning**.  
8. Keep screenshots **readable** (zoom, crop).
