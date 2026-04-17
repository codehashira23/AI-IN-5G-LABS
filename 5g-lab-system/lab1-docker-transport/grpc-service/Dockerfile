FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY helloworld.proto server.py .
RUN python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. helloworld.proto
EXPOSE 50051
CMD ["python", "server.py"]
