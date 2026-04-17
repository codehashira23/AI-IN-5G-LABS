# Lab 4 — AI QoE (LangChain + LangGraph + Ollama)

## Graph

Three nodes on a shared `QoEState`:

1. **kpi_validation** — threshold checks + LLM summary.
2. **qoe_classification** — LLM emits JSON `{label, details}`.
3. **advice** — LLM emits remediation bullets.

## Prerequisites

- `ollama` service running (`setup/install_all.sh`).
- Model `llama3.1:8b` pulled once.

## Run

```bash
./run.sh
# or directly:
source .venv/bin/activate
pip install -r requirements.txt
python qoe_workflow.py -90 25 0.5
```

## Environment

- `OLLAMA_MODEL` (default `llama3.1:8b`)
- `OLLAMA_BASE_URL` (default `http://127.0.0.1:11434`)
