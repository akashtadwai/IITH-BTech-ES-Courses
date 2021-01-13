import socket
import argparse
import os
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--port', type=int, help='port to listen on') # Port argument from user
parser.add_argument('--ipaddr', type=str, help='ip address') # IP address argument from uuser
args = parser.parse_args()


socket_family = socket.getaddrinfo(args.ipaddr,args.port)[0][0]
if socket_family == socket.AF_INET6:
	print("Im inside IPV6")
	s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM) # Creating a socket
	s.connect((args.ipaddr, args.port)) # Connecting to the server
elif socket_family == socket.AF_INET:
	print("Im inside IPV4")
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Creating a socket
	s.connect((args.ipaddr, args.port)) # Connecting to the server

while(True):
	print("Type your message: ")    # Prompt user to type the message
	inp = input()           
	s.sendall(inp.encode())         # Sending user message from client to server
	res = s.recv(1024).decode()     # Recieving message from the server
	print(res)  
	if(inp == "close"):             # Closing the socket
		s.close()
		sys.exit()
