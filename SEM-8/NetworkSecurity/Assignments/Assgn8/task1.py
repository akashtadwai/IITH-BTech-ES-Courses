import json
import os
import socket
import sys
import threading
import matplotlib.pyplot as plt
from utils.firewall import *
from utils.utilitites import *

L = []
counter: Counter = Counter()


def stats():
    global L
    """
    Print the statistics
    """
    while True:
        time.sleep(2)
        L.append(counter.numPackets)


def main():
    global counter  # type: Counter
    if len(sys.argv) != 4:
        print(
            "execution format : python3 firewall_task1.py <NIC1> <NIC2> <firewall rules file>"
        )
        sys.exit(1)

    # reading input arguments
    # sys.argv[1:]
    interface2, interface1, rules_file = 'eth12', 'eth2', "task1_rules.json"

    s1 = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.ntohs(3))
    s1.bind((interface1, 0))  # for vm2
    s2 = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.ntohs(3))
    s2.bind((interface2, 0))  # for vm1

    command_str = "ifconfig " + interface1 + " promisc"
    os.system(command_str)
    command_str = "ifconfig " + interface2 + " promisc"
    os.system(command_str)

    # reading firewall rules
    with open(rules_file) as json_file:
        rules = json.load(json_file)
        t1 = threading.Thread(
            target=filter_packets, args=(s1, s2, 1, counter, rules)
        )  # receieves from vm1 and sends to vm2
        t2 = threading.Thread(
            target=filter_packets, args=(s2, s1, 0, counter, rules)
        )  # receieves from vm2 and sends to vm1
        t3 = threading.Thread(target=stats)
        threads: List[threading.Thread] = [t1, t2, t3]
        try:
            for t in threads:
                t.daemon = True
                t.start()
            for t in threads:
                t.join()
        finally:
            print("\nRaised keyboard interrupt, execution ended normally")
            temp_str = "ifconfig " + interface1 + " -promisc"
            os.system(temp_str)
            temp_str = "ifconfig " + interface2 + " -promisc"
            os.system(temp_str)

            print("\t    Displaying Packet Statistics")
            print("\t  Packets sent from Client    Packets blocked by Server")
            print(
                "ARP cnt : ",
                counter.getCount(True, "arp_cnt_sent"),
                "\t\t",
                counter.getCount(True, "arp_cnt_blocked"),
            )
            print(
                "TCP cnt : ",
                counter.getCount(True, "tcp_cnt_sent"),
                "\t\t",
                counter.getCount(True, "tcp_cnt_blocked"),
            )
            print(
                "UDP cnt : ",
                counter.getCount(True, "udp_cnt_sent"),
                "\t\t",
                counter.getCount(True, "udp_cnt_blocked"),
            )
            print(
                "ICMP cnt: ",
                counter.getCount(True, "icmp_cnt_sent"),
                "\t\t",
                counter.getCount(True, "icmp_cnt_blocked"),
            )
            print(
                "packets per second =",
                "{:.2f}".format(counter.numPackets / counter.timeTaken),
                "PPS("
                + str(
                    "{:.2f}".format(
                        (counter.numPackets / counter.timeTaken)
                        * (BUFFSIZE * 8 / 1000000)
                    )
                )
                + "Megabits/sec)",
            )

            plt.plot([(i + 1) * 2 for i in range(len(L))], L)
            plt.xlabel("time in sec")
            plt.ylabel("Cumlative no. of packets processed")
            plt.savefig("plot.png")

            s1.close()
            s2.close()
            sys.exit()
