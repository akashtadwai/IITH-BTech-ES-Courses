# Computer Networks 
## Lab Assignment - 2


<br />

**Compiling server, client files** :

- Server : ```$ gcc -o server server_fin.c -pthread```

- Client : ```$ gcc -o client client_fin.c -pthread```

**Executing files** :

- Server : ```$ ./server <port>```

- Client : ```$ ./client <filename> <ip address> <port>```


If port number is not provided by user, default port **4444** will be considered.

**NOTE** : 

- Recived file in server will be saved with the name ```recvdFile```.