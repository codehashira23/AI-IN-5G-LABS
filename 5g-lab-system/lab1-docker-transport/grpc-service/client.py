"""Simple gRPC client for local testing."""
import sys

import grpc

import helloworld_pb2 as pb2
import helloworld_pb2_grpc as pb2_grpc


def main():
    target = sys.argv[1] if len(sys.argv) > 1 else "localhost:50051"
    with grpc.insecure_channel(target) as channel:
        stub = pb2_grpc.GreeterStub(channel)
        resp = stub.SayHello(pb2.HelloRequest(name="5G-Lab"))
    print(resp.message)


if __name__ == "__main__":
    main()
