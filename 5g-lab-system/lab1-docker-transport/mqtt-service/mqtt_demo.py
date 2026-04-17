"""Publish and subscribe demo against Mosquitto (Lab 1)."""
import json
import os
import threading
import time

import paho.mqtt.client as mqtt

BROKER = os.environ.get("MQTT_BROKER", "mosquitto")
PORT = int(os.environ.get("MQTT_PORT", "1883"))
TOPIC = os.environ.get("MQTT_TOPIC", "lab1/telemetry")
PAYLOAD = {
    "cell_id": "gnb-001",
    "rssi_dbm": -78,
    "latency_ms": 12.4,
    "timestamp": time.time(),
}


def on_connect(client, _userdata, _flags, rc, _properties=None):
    if rc == 0:
        print(f"[mqtt-demo] connected to {BROKER}:{PORT}")
        client.subscribe(TOPIC)
    else:
        print(f"[mqtt-demo] connect failed rc={rc}")


def on_message(client, _userdata, msg):
    try:
        data = json.loads(msg.payload.decode())
    except json.JSONDecodeError:
        data = msg.payload.decode()
    print(f"[mqtt-demo] received topic={msg.topic} payload={data}")


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "lab1-demo")
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(BROKER, PORT, keepalive=30)

    def loop():
        client.loop_forever()

    threading.Thread(target=loop, daemon=True).start()
    time.sleep(2)
    client.publish(TOPIC, json.dumps(PAYLOAD), qos=0, retain=False)
    print(f"[mqtt-demo] published to {TOPIC}")
    time.sleep(2)
    print("[mqtt-demo] done")
    client.disconnect()


if __name__ == "__main__":
    main()
