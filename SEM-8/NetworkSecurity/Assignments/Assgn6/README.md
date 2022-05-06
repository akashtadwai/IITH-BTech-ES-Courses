# NETWORK SECURITY Assignment 6: Secure chat using openssl and common attacks (version 2)


## Files submitted
<pre>
.
├── Assgn-6-Group-1-Report.pdf
├── certificates
│   ├── alice
│   │   ├── alice.crt
│   │   ├── aliceCSR.csr
│   │   ├── alicePrivate.pem
│   │   ├── alicePublic.pem
│   │   ├── root.crt
│   │   ├── sha256alice.sign
│   │   └── verify.txt
│   ├── bob
│   │   ├── bob.crt
│   │   ├── bobCSR.csr
│   │   ├── bobPrivate.pem
│   │   ├── bobPublic.pem
│   │   ├── root.crt
│   │   ├── sha256bob.sign
│   │   └── verify.txt
│   ├── rootCA
│   │   ├── root.crt
│   │   ├── rootPrivate.pem
│   │   ├── root.srl
│   │   └── verify.txt
│   └── trudy
│       ├── alice
│       ├── bob
│       ├── root.crt
│       └── verify.txt
├── Makefile
├── pcaps
│   ├── task2.pcap
│   ├── task3.pcap
│   └── task4.pcap
├── README.md
├── secure_chat_app.py
├── secure_chat_interceptor.py
└── utils.py
</pre>

## Instructions to run 
#### passphrase of all private keys is: `ns01`  
<br>

### Organising Data into Containers
- Navigate to the working directory containing all the files
- Run `$ make copyFiles` with appropriate permssions for running vm (`ns@192.168.51.111`)
- Run `$ make distributeFiles` in VM to distribute all the required files into the appropriate places in containers.
- Run `$ make addToRootStore` in VM to add the `root.crt`  in to the `rootstore` of all the containers.
- To cleanup run, `$ make clean`
### Running Task2 - SECURE CHAT
* Make sure DNS is not poisoned, if poisoned, then run the script in `ns@ns` :  
```bash
    $ bash ~/unpoison-dns-alice1-bob1.sh
```
* In bob1 container, open a terminal in the folder containing the `secure_chat_app.py` and run
```bash 
    $ python3 secure_chat_app.py -s 
```
* In alice1 container, open a terminal in the folder containing the `secure_chat_app.py` and run :
```bash 
    $ python3 secure_chat_app.py -c bob1
```
* After receiving the message handshake successful, alice and bob can chat indefinitely and can end the chat when one of them sends `"chat_close"` message.
<br>

### Running Task3 - DOWNGRADE ATTACK
1. Make sure the DNS is poisoned,if not, poison the DNS by the running the script in ns@ns:
```bash
    $ bash ~/poison-dns-alice1-bob1.sh
```
2. In trudy1 container, open a terminal in the folder containing the `secure_chat_interceptor.py`, run : 
```bash
    $ python3 secure_chat_interceptor.py -d alice1 bob1
  ```
3. In bob1 container, open a terminal in the folder containing the `secure_chat_app.py` and run :
```bash
    $ python3 secure_chat_app.py -s
  ```
4. In alice1 container, open a terminal in the folder containing the `secure_chat_app.py` and run :
```bash
    $ python3 secure_chat_app.py -c bob1
  ```
5. Alice and Bob can chat indefinitely and can end the chat when one of them sends `"chat_close"`.

### Running Task4 - MITM ATTACK
- All the instructions are same as [Task-3](#running-task3---downgrade-attack) except that, in instruction-2, we should replace `-d` flag with `-m` flag. 
```bash
    $ python3 secure_chat_interceptor.py -m alice1 bob1
```

## Contributors
    Akash Tadwai      - ES18BTECH11019
    Sai Varshittha P  - CS18BTECH11035
    Amit Kumar        - CS21MTECH11007