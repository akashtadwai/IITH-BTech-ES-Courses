#!/usr/bin/env python3

import socket
import argparse
import sys
import ssl
from utils import *


class Client:
    """
    Represents client class and all its functionalities.
    """

    def __init__(self, server_name: str) -> None:
        self.server_name = server_name

    def create_connection(self) -> None:
        """
        Create a TCP/IP socket and accept connections from clients
        """
        clientSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            host_ip = socket.gethostbyname(self.server_name)
        except socket.gaierror:
            print("Hostname could not be resolved. Exiting")
            sys.exit(1)

        clientSock.connect((host_ip, SERVERPORT))
        print("Connected to: ", host_ip)
        return clientSock

    def tls_client(self, clientSock: socket.socket) -> None:
        """
        Function to perform TLS handshake with server
        @param: clientSock: socket to be used for TLS handshake
        """
        # chat_hello
        clientSock.sendall("chat_hello".encode())
        recvd_data = clientSock.recv(BUFFSIZE)
        print("Recieved: ", recvd_data.decode())

        # chat_STARTTLS
        clientSock.sendall("chat_STARTTLS".encode(FORMAT))
        recvd_data = clientSock.recv(BUFFSIZE)
        print("Recieved ", recvd_data.decode(FORMAT))

        if recvd_data.decode(FORMAT) == "chat_STARTTLS_ACK":
            # Loading Keys and Certificates
            context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
            context.load_verify_locations(ROOTSTORE)
            context.load_cert_chain(CLIENTCERT, CLIENTPRIVATEKEY)
            context.verify_mode = ssl.CERT_REQUIRED
            clientSock = context.wrap_socket(
                clientSock,
                server_hostname=self.server_name,
                do_handshake_on_connect=True,
            )
            print("SSL Certificates Verified Succesfully")

        # No TLS so proceding in no secure connection
        elif recvd_data.decode() == "chat_STARTTLS_NOT_SUPPORTED":
            print("Continuing in TCP connection")
        while True:
            data = input("Enter msg to send: ")
            clientSock.sendall(data.encode(FORMAT))
            if data == "chat_close":
                break
            print("Waiting for message from server. . .")
            recvd_data = clientSock.recv(BUFFSIZE)
            print("recieved: ", recvd_data.decode(FORMAT))
            if recvd_data.decode(FORMAT) == "chat_close":
                break

        clientSock.close()


class Server:
    """
    Represents Server class and all its methods.
    """

    def __init__(self) -> None:
        pass

    def create_and_accept_connections(self):
        """
        Create a TCP/IP socket and accept connections from clients.
        """
        serverSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serverSock.bind(("", SERVERPORT))
        serverSock.listen(1)
        print("Waiting for clients to join")

        # accept for connections
        clientsock, clientAddr = serverSock.accept()
        print("Client connected from: ", clientAddr)

        self.tls_server(serverSock, clientsock)

    def tls_server(self, serverSock: socket.socket, clientSock: socket.socket) -> None:
        """
        Function to perform TLS handshake with client
        @param: serverSock: socket to be used for TLS handshake
        @param: clientSock: socket to be used for TLS handshake
        """
        isHello: bool = False  # checking if hello has been sent for the first time
        isStartTLS: bool = (
            False  # checking if STARTTLS has been sent for the first time
        )

        while True:
            print("Waiting for client message . . .")
            recvd_data = clientSock.recv(BUFFSIZE)
            print(f"received >> {recvd_data.decode(FORMAT)}")
            # chat_hello
            if not isHello and recvd_data.decode() == "chat_hello":
                clientSock.sendall("chat_reply".encode())
                isHello = True
            # chat_STARTTLS
            elif not isStartTLS and recvd_data.decode() == "chat_STARTTLS":
                clientSock.sendall("chat_STARTTLS_ACK".encode())
                # Loading Keys and Certificates
                context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
                context.load_verify_locations(ROOTSTORE)
                context.load_cert_chain(SERVERCERT, SERVERPRIVATEKEY)
                context.verify_mode = ssl.CERT_REQUIRED
                clientSock = context.wrap_socket(
                    clientSock, server_side=True, do_handshake_on_connect=True
                )
                isStartTLS = True
                print("Secure TLS 1.3 pipe Established")

            # chat_close
            elif recvd_data.decode() == "chat_close":
                break

            # sending messages to client
            else:
                send_data = input("Enter message to send: ")
                clientSock.sendall(send_data.encode())
                if send_data == "chat_close":
                    break

        # close sockets
        clientSock.close()
        serverSock.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    if len(sys.argv) not in [2, 3]:
        print("Usage: \n python secure_chat_app.py [-c <server_name> ] [-s]")
        sys.exit(1)

    parser.add_argument("-s", help="Server side", action="store_true")  # Domain name
    parser.add_argument("-c", type=str, help="Server Name")  # Port
    args = parser.parse_args()
    if args.c:
        client = Client(args.c)
        clientSock = client.create_connection()
        client.tls_client(clientSock)

    elif args.s:
        server = Server()
        server.create_and_accept_connections()
