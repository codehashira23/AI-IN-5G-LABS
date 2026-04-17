# Lab 2 — Spring Boot + Swagger (OpenAPI)

## Run

```bash
./run.sh
```

Swagger UI: `http://127.0.0.1:8081/swagger-ui/index.html`

OpenAPI JSON: `http://127.0.0.1:8081/v3/api-docs`

## API

- `GET /api/slices/{id}`
- `POST /api/slices` with JSON body `{ "name", "sst", "sd" }`

Stop the background Java process using the PID printed at the end of `run.sh`.
