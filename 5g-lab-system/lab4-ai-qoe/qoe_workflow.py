"""
Lab 4 — AI QoE orchestration with LangGraph + LangChain + Ollama (llama3.1:8b).

Input KPIs: RSSI (dBm), latency (ms), packet loss (%).
Output: QoE label + operator advice.
"""
from __future__ import annotations

import json
import os
import re
import sys
from typing import TypedDict

from langchain_community.chat_models import ChatOllama
from langchain_core.messages import HumanMessage, SystemMessage
from langgraph.graph import END, StateGraph


class QoEState(TypedDict):
    rssi_dbm: float
    latency_ms: float
    packet_loss_percent: float
    kpi_ok: bool
    kpi_report: str
    qoe_label: str
    qoe_details: str
    advice: str


def _llm() -> ChatOllama:
    model = os.environ.get("OLLAMA_MODEL", "llama3.1:8b")
    base = os.environ.get("OLLAMA_BASE_URL", "http://127.0.0.1:11434")
    return ChatOllama(model=model, base_url=base, temperature=0.2)


def node_kpi_validation(state: QoEState) -> QoEState:
    """Rule-based KPI gate + concise LLM explanation."""
    rssi = float(state["rssi_dbm"])
    lat = float(state["latency_ms"])
    loss = float(state["packet_loss_percent"])

    reasons = []
    ok = True
    if rssi < -105:
        ok = False
        reasons.append("RSSI is very weak for reliable mobility.")
    if lat > 120:
        ok = False
        reasons.append("Latency exceeds interactive target.")
    if loss > 3.0:
        ok = False
        reasons.append("Packet loss is high for real-time services.")

    summary = (
        f"RSSI={rssi:.1f} dBm, latency={lat:.1f} ms, loss={loss:.2f}%. "
        + ("All KPIs within lab thresholds. " if ok else "Threshold violations: ")
        + ("; ".join(reasons) if reasons else "")
    )

    llm = _llm()
    msgs = [
        SystemMessage(
            content="You are a 5G radio engineer. Summarize KPI health in 2 sentences. "
            "Do not invent numbers beyond what you are given."
        ),
        HumanMessage(content=summary),
    ]
    report = llm.invoke(msgs).content.strip()
    return {**state, "kpi_ok": ok, "kpi_report": report}


def node_qoe_classification(state: QoEState) -> QoEState:
    llm = _llm()
    payload = {
        "rssi_dbm": state["rssi_dbm"],
        "latency_ms": state["latency_ms"],
        "packet_loss_percent": state["packet_loss_percent"],
        "kpi_ok": state["kpi_ok"],
        "kpi_report": state["kpi_report"],
    }
    msgs = [
        SystemMessage(
            content=(
                "Classify end-user QoE for a 5G NR data session. "
                "Reply with STRICT JSON only: {\"label\": one of "
                "[Excellent, Good, Fair, Poor], \"details\": string }"
            )
        ),
        HumanMessage(content=json.dumps(payload)),
    ]
    raw = llm.invoke(msgs).content.strip()
    m = re.search(r"\{.*\}", raw, re.S)
    label, details = "Fair", raw
    if m:
        try:
            obj = json.loads(m.group(0))
            label = str(obj.get("label", label))
            details = str(obj.get("details", details))
        except json.JSONDecodeError:
            pass
    return {**state, "qoe_label": label, "qoe_details": details}


def node_advice(state: QoEState) -> QoEState:
    llm = _llm()
    msgs = [
        SystemMessage(
            content=(
                "You are a NOC advisor. Given KPIs and QoE, give 3-5 actionable bullets "
                "(RF, transport, core checks). Be concrete, no fluff."
            )
        ),
        HumanMessage(
            content=json.dumps(
                {
                    "kpis": {
                        "rssi_dbm": state["rssi_dbm"],
                        "latency_ms": state["latency_ms"],
                        "packet_loss_percent": state["packet_loss_percent"],
                    },
                    "kpi_ok": state["kpi_ok"],
                    "qoe_label": state["qoe_label"],
                    "qoe_details": state["qoe_details"],
                }
            )
        ),
    ]
    advice = llm.invoke(msgs).content.strip()
    return {**state, "advice": advice}


def build_graph():
    g = StateGraph(QoEState)
    g.add_node("kpi_validation", node_kpi_validation)
    g.add_node("qoe_classification", node_qoe_classification)
    # Node id must not collide with a state key name.
    g.add_node("advice_node", node_advice)
    g.set_entry_point("kpi_validation")
    g.add_edge("kpi_validation", "qoe_classification")
    g.add_edge("qoe_classification", "advice_node")
    g.add_edge("advice_node", END)
    return g.compile()


def main(argv: list[str]) -> int:
    if len(argv) != 4:
        print(
            "Usage: python qoe_workflow.py <rssi_dbm> <latency_ms> <packet_loss_percent>",
            file=sys.stderr,
        )
        return 2
    rssi, lat, loss = map(float, argv[1:4])
    app = build_graph()
    out = app.invoke(
        {
            "rssi_dbm": rssi,
            "latency_ms": lat,
            "packet_loss_percent": loss,
            "kpi_ok": False,
            "kpi_report": "",
            "qoe_label": "",
            "qoe_details": "",
            "advice": "",
        }
    )
    print(json.dumps(out, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
