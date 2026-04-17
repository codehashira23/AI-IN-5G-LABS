# Lab 1 — Docker + transport protocols

## What is implemented

- **REST**: Flask + Gunicorn (`rest-service/`, port **8080**).
- **MQTT**: Eclipse Mosquitto broker + Python publisher/subscriber demo (`mqtt-service/`).
- **gRPC**: Python greeter with `grpcio-tools` codegen at image build (`grpc-service/`, port **50051**).

## Run

```bash
./run.sh
```

## Evidence

- Host: `curl` samples against REST.
- Compose: `docker compose logs mqtt-demo` shows publish + subscribe.
- gRPC: `docker compose exec grpc python client.py grpc:50051`.

Logs mirror stdout under `../logs/lab1_*.log`.
