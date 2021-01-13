import socket
import argparse
import os
import threading


def invoke(s):
    s.listen(5)
    while(True):
        c, addr = s.accept()
        print('Connected to :', addr[0], ':', addr[1])
        while(True):
            req = c.recv(1024).decode() # Recieving user message 
            if(req == "close"):         # If user input is "close", then we close the socket
                c.send('Closing...'.encode())
                print('Socket Closed')
                break
            else:
                print (req)             # We are printing the message from client
            c.sendall("Recieved: {}".format(req).encode())  # Sending back recieved message from client to client

parser = argparse.ArgumentParser()
parser.add_argument('--port', type=int,
                    help='listening port')
args = parser.parse_args()

socket_ipv4 = socket.socket(socket.AF_INET,socket.SOCK_STREAM)                     
socket_ipv4.bind(('', args.port))


socket_ipv6 = socket.socket(socket.AF_INET6,socket.SOCK_STREAM)                      
socket_ipv6.bind(('::1', args.port))

print("Socket successfully created")

thread1=threading.Thread(target=invoke,args=(socket_ipv4,))
thread2=threading.Thread(target=invoke,args=(socket_ipv6,))

thread1.start()
thread2.start()