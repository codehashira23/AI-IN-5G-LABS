"""Minimal REST API for Lab 1 (Flask)."""
from flask import Flask, jsonify, request

app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify({"status": "ok", "service": "rest"})


@app.get("/api/items/<int:item_id>")
def get_item(item_id: int):
    return jsonify({"id": item_id, "name": f"item-{item_id}"})


@app.post("/api/items")
def create_item():
    body = request.get_json(silent=True) or {}
    name = body.get("name", "unnamed")
    return jsonify({"created": True, "name": name}), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
