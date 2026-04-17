"""gRPC Greeter server (Lab 1)."""
from concurrent import futures

import grpc

import helloworld_pb2 as pb2
import helloworld_pb2_grpc as pb2_grpc


class Greeter(pb2_grpc.GreeterServicer):
    def SayHello(self, request, context):
        return pb2.HelloReply(message=f"Hello, {request.name} from gRPC")


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=4))
    pb2_grpc.add_GreeterServicer_to_server(Greeter(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("[grpc] server listening on :50051")
    server.wait_for_termination()


if __name__ == "__main__":
    serve()
