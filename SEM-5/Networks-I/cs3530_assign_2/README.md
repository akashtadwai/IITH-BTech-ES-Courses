# CS 3530 : Computer Networks - I

## Socket Programming Assignment

======================================

**NOTE**: For all the programs run ```$ python3 <program_name>.py --help```  
For help regarding the arguments to be passed.

### Question 1

Integrate getaddrinfo() as part of your client software so that the hostname of the server can be given as the command line option.

- Client : ```$ python3 client_1.py  < hostname >  < port number >```

### Question 2

Add at least two features to Echo Client /Server, and demonstrate them.

- Server : ```$ python3 server_2.py --port < port number>```
- Client : ```$ python3 client_2.py --port < port number> --ipaddr < ip address of server>```

### Question 3

Revise echo client and server to be protocol independent (support both IPv4 and IPv6).

- Server :```$ python server_3.py < port_number>```
- Client :```$ python client_3.py < port_number> < ipv4/ipv6 address>```
