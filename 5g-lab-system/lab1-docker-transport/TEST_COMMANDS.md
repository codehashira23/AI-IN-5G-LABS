# Lab 1 — manual test commands (Ubuntu 22.04)

```bash
cd lab1-docker-transport
./run.sh
```

REST:

```bash
curl -s http://127.0.0.1:8080/health | jq .
curl -s http://127.0.0.1:8080/api/items/7 | jq .
curl -s -X POST http://127.0.0.1:8080/api/items -H "Content-Type: application/json" -d '{"name":"test"}' | jq .
```

MQTT (host has broker on 1883):

```bash
sudo apt-get update && sudo apt-get install -y mosquitto-clients
mosquitto_sub -h 127.0.0.1 -p 1883 -t 'lab1/#' -C 1 &
sleep 1
mosquitto_pub -h 127.0.0.1 -p 1883 -t lab1/telemetry -m '{"ping":true}'
```

gRPC:

```bash
docker compose exec grpc python client.py grpc:50051
```

Teardown:

```bash
docker compose down
```
