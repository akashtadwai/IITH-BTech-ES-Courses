import socket
import argparse
import os
import sys
FORMAT = 'utf-8'
parser = argparse.ArgumentParser()
parser.add_argument('domain_name', type=str, help='domain_name') # Domain name
parser.add_argument('port', type=int, help='port to listen on')  # Port
args = parser.parse_args()
addrInfo = socket.getaddrinfo(args.domain_name, args.port, family=socket.AF_INET, proto=socket.IPPROTO_TCP) # Resolving dns
IP = addrInfo[0][4][0]
print(f'IP address of {args.domain_name} is {IP}')

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Creating a socket
s.connect((IP,args.port))
s.sendall("GET / HTTP/1.1\r\nHost: {}\r\n\r\n".format(args.domain_name).encode(FORMAT))   # sending a GET request to the corresponding IP address
data = s.recv(2048)
print(data.decode(FORMAT))

sys.exit()	 # Exiting
