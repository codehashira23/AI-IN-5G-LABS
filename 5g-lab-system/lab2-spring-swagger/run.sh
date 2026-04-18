#!/usr/bin/env bash
# Lab 2 — Spring Boot + Swagger (logs under <repo>/logs/)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${ROOT}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/lab2_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "${LOG_FILE}") 2>&1

echo ""
echo "================================================================"
echo "  LAB 2 — Spring Boot + Swagger / OpenAPI"
echo "  Log file: ${LOG_FILE}"
echo "================================================================"
echo ""

if ! command -v mvn &>/dev/null; then
  echo "[FAIL] mvn not found. Install: sudo bash setup/install_all.sh"
  exit 1
fi
if ! command -v java &>/dev/null; then
  echo "[FAIL] java not found."
  exit 1
fi

JAVA_VER="$(java -version 2>&1 | head -1 || true)"
echo "[Lab2] Using: ${JAVA_VER}"
if ! java -version 2>&1 | grep -qE 'version "17|version "21'; then
  echo "[WARN] JDK 17+ recommended (Ubuntu: openjdk-17-jdk). Continuing."
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "[Lab2] STEP 1/4 — Maven package"
mvn -q -DskipTests package

JAR="target/lab2-spring-swagger-1.0.0.jar"
if [[ ! -f "${JAR}" ]]; then
  echo "[FAIL] Expected JAR missing: ${JAR}"
  exit 1
fi

echo "[Lab2] STEP 2/4 — Start Spring Boot on :8081 (background)"
java -jar "${JAR}" &
PID=$!
echo "[Lab2] Java PID: ${PID}"

echo "[Lab2] STEP 3/4 — Wait for Swagger UI"
ok=0
for i in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:8081/swagger-ui/index.html >/dev/null 2>&1; then
    ok=1
    break
  fi
  sleep 1
  if ! kill -0 "${PID}" 2>/dev/null; then
    echo "[FAIL] Java process exited before Swagger became ready."
    exit 1
  fi
done
if [[ "${ok}" -ne 1 ]]; then
  echo "[FAIL] Swagger UI not reachable on :8081 within timeout."
  exit 1
fi
echo "[OK] Swagger UI reachable."

echo "[Lab2] STEP 4/4 — API + OpenAPI proof"
curl -fsS -X POST http://127.0.0.1:8081/api/slices \
  -H "Content-Type: application/json" \
  -d '{"name":"eMBB-Lab","sst":"1","sd":"010203"}' | tee /tmp/lab2_post.json
echo ""
ID="$(python3 -c "import json;print(json.load(open('/tmp/lab2_post.json'))['id'])" 2>/dev/null || echo "")"
if [[ -z "${ID}" ]]; then
  echo "[FAIL] could not parse slice id from POST response"
  exit 1
fi
curl -fsS "http://127.0.0.1:8081/api/slices/${ID}"
echo ""
curl -fsS http://127.0.0.1:8081/v3/api-docs >/tmp/lab2_openapi.json
python3 -c "import json; d=json.load(open('/tmp/lab2_openapi.json')); assert 'openapi' in d or 'swagger' in d; print('[OK] OpenAPI document parsed (' + str(len(json.dumps(d))) + ' bytes)')"

echo "[Lab2] PROOF — HTTP response headers (Swagger UI)"
curl -fsSI http://127.0.0.1:8081/swagger-ui/index.html 2>&1 | head -n 8

echo ""
echo "================================================================"
echo "  LAB 2 SUCCESS"
echo "  Swagger: http://127.0.0.1:8081/swagger-ui/index.html"
echo "  OpenAPI: http://127.0.0.1:8081/v3/api-docs"
echo "  Log:     ${LOG_FILE}"
echo "  Stop:    kill ${PID}"
echo "================================================================"
echo ""
