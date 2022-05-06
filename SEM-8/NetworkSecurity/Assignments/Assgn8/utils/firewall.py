import ipaddress
import json
import socket
import time
from typing import IO, Dict, List

from utils.headers import *
from utils.utilitites import Counter

BUFFSIZE = 2048


class Ipv4Props:
    def __init__(
        self, ip4_header_version, header_length, proto, src, dest, ttl, data
    ) -> None:
        self.ip4_header_version = ip4_header_version
        self.header_length = header_length
        self.proto = proto
        self.src = src
        self.dest = dest
        self.ttl = ttl
        self.data = data


class Ipv6Props:
    def __init__(self, proto, hop_limit, src, dest, payload_length, data) -> None:
        self.proto = proto
        self.hop_limit = hop_limit
        self.src = src
        self.dest = dest
        self.payload_length = payload_length
        self.data = data


class Params:
    """
    Class to implement the parameters
    """

    def __init__(
        self, srcip, destip, srcport, destport, proto, srcmac, destmac, flag
    ) -> None:
        """
        Initialize the parameters
        """
        self.srcip = srcip
        self.destip = destip
        self.srcport = srcport
        self.destport = destport
        self.proto = proto
        self.srcmac = srcmac
        self.destmac = destmac
        self.flag = flag


def isBlocked(ipAddress: str, subnet: list, isIpv4: bool) -> bool:
    """
    Checks if the ip address is blocked
    @param ipAddress: str: the ip address to check
    @param subnet: list: the subnet to check
    @param isIpv4: bool: True if ipv4, False if ipv6
    """
    addressFamily = socket.AF_INET if isIpv4 else socket.AF_INET6
    numBits = 32 if isIpv4 else 128
    binIP_rule = socket.inet_pton(addressFamily, subnet[0])
    binIP_pkt = socket.inet_pton(addressFamily, ipAddress)
    binIP_rule = int.from_bytes(binIP_rule, "big")  # convert to bigendian
    binIP_pkt = int.from_bytes(binIP_pkt, "big")
    return binIP_rule >> (numBits - int(subnet[1])) != binIP_pkt >> (
        numBits - int(subnet[1])
    )


def validate_rule(props: Params, rules_file: IO) -> bool:
    """
    Validates the rule and returns the verdict
    @param props: Params: the properties of the packet
    @param rules_file: IO: the rules file
    @return: bool: True if the packet is allowed, False if blocked
    """

    pkt_info: List[str] = [
        props.srcip,
        " ",
        props.destip,
        " ",
        props.srcport,
        props.destport,
        props.proto,
        props.srcmac,
        props.destmac,
        props.flag,
    ]

    with open(rules_file) as json_file:
        rules: Dict[str, str] = json.load(json_file)
        cols = list(rules.keys())

    for i in range(len(rules[cols[0]])):
        check = 1  # = 1 means matching with rule, which means need to block this row
        for j in range(len(cols)):
            if rules[cols[j]][i] == "any":
                continue
            if j in [1, 3]:  # prefix ip check
                if pkt_info[j - 1] == " ":  # if srcip or destip is empty => no match
                    check = 0
                    break
                subnet: list[str] = rules[cols[j]][i].split("/")
                if (
                    subnet[0].count(".") == 0 and pkt_info[j - 1].count(".") == 0
                ):  # ipv6
                    if isBlocked(pkt_info[j - 1], subnet, False):
                        check = 0
                        break
                elif (
                    subnet[0].count(":") == 0 and pkt_info[j - 1].count(":") == 0
                ):  # ipv4
                    if isBlocked(pkt_info[j - 1], subnet, True):
                        check = 0
                        break
                else:
                    check = 0
                    break
            elif j in [4, 5]:  # port range check
                if pkt_info[j] == " ":
                    check = 0
                    break
                portRange = rules[cols[j]][i].split("-")
                if int(pkt_info[j]) > int(portRange[1]) or int(pkt_info[j]) < int(
                    portRange[0]
                ):
                    check = 0
                    break
            else:
                if pkt_info[j] != rules[cols[j]][i]:
                    check = 0
                    break

        if check == 1:
            return False

    return True


def udp(
    packet: bytes,
    start: time.time,
    firewall_props: Params,
    counter: Counter,
    s: socket.socket,
    flag: bool,
    rules_file: IO,
) -> None:
    if validate_rule(firewall_props, rules_file):
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("UDP packet sent")
        s.sendall(packet)
        if flag == 1:
            counter.increment(1, "udp_cnt_sent")
            counter.timeTaken += temp_time
    else:
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("UDP packet blocked")
        if flag:
            counter.increment(0, "udp_cnt_blocked")
            counter.timeTaken += temp_time


def tcp(
    packet: bytes,
    start: time.time,
    firewall_props: Params,
    counter: Counter,
    s: socket.socket,
    flag: bool,
    rules_file: IO,
) -> None:
    if validate_rule(firewall_props, rules_file):
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("TCP packet sent")
        s.sendall(packet)
        if flag == 1:
            counter.increment(1, "tcp_cnt_sent")
            counter.timeTaken += temp_time
    else:
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("TCP packet blocked")
        if flag:
            counter.increment(0, "tcp_cnt_blocked")
            counter.timeTaken += temp_time


def icmp(
    packet: bytes,
    start: time.time,
    ipData: Ipv4Props,
    counter: Counter,
    s: socket.socket,
    flag: bool,
    eth: list,
    rules_file: IO,
) -> None:
    fire_wall_props = Params(
        str(get_ipv4(ipData.src)),
        str(get_ipv4(ipData.dest)),
        " ",
        " ",
        str(ipData.proto),
        str(eth[1]),
        str(eth[0]),
        str(flag),
    )
    if validate_rule(fire_wall_props, rules_file):
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("ICMP packet sent")
        s.sendall(packet)
        if flag:
            counter.increment(1, "icmp_cnt_sent")
            counter.numPackets += 1
            counter.timeTaken += temp_time
    else:
        temp_time = time.time() - start
        print("packet analysed and checked in " + str(temp_time) + " secs")
        print("ICMP packet blocked")
        if flag:
            counter.increment(0, "icmp_cnt_blocked")
            counter.numPackets += 1
            counter.timeTaken += temp_time


def filter_packets(
    s1: socket.socket, s2: socket.socket, flag: bool, counter: Counter, rules_file: IO
) -> None:
    counter.resetCounter()
    while True:
        pkt, _ = s2.recvfrom(BUFFSIZE)
        st = time.time()
        eth = ethernet_header(pkt)

        # ARP Packet
        print("--" * 10)
        if eth[2] == 2054:  # ARP is decimal 2054
            props = Params(
                " ", " ", " ", " ", " ", str(eth[1]), str(eth[0]), str(flag), rules_file
            )
            if validate_rule(props, rules_file):
                temp_time = time.time() - st
                print("packet analysed and checked in " + str(temp_time) + " secs")
                print("ARP packet sent")
                if flag == 1:
                    counter.increment(True, "arp_cnt_sent")
                    counter.numPackets += 1
                    counter.timeTaken += temp_time
                s1.sendall(pkt)
            else:
                temp_time = time.time()
                print("packet analysed and checked in " + str(temp_time) + " secs")
                print("ARP packet dropped")
                if flag == 1:
                    counter.increment(True, "arp_cnt_blocked")
                    counter.numPackets += 1
                    counter.timeTaken += temp_time

        # IPv4 Packet
        elif eth[2] == 2048:  # IPv4 is decimal 2048
            print("IPV4 packet")
            ipPacket = eth[3]
            ipData: Ipv4Props = Ipv4Props(*ip4_header(ipPacket))

            # UDP Packet
            if ipData.proto == 17:
                udp_pkt = udp_header(ipData.data)
                firewall_props = Params(
                    str(get_ipv4(ipData.src)),
                    str(get_ipv4(ipData.dest)),
                    str(udp_pkt[0]),
                    str(udp_pkt[1]),
                    str(ipData.proto),
                    str(eth[1]),
                    str(eth[0]),
                    str(flag),
                )
                udp(pkt, st, firewall_props, counter, s1, flag, rules_file)
                if flag:
                    counter.numPackets += 1

            elif ipData.proto == 6:
                tcp_pkt = tcp_header(ipData.data)
                firewall_props = Params(
                    str(get_ipv4(ipData.src)),
                    str(get_ipv4(ipData.dest)),
                    str(tcp_pkt[0]),
                    str(tcp_pkt[1]),
                    str(ipData.proto),
                    str(eth[1]),
                    str(eth[0]),
                    str(flag),
                )
                tcp(pkt, st, firewall_props, counter, s1, flag, rules_file)
                if flag:
                    counter.numPackets += 1

            elif ipData.proto == 1:
                icmp(pkt, st, ipData, counter, s1, flag, eth, rules_file)

            print("src_mac :", eth[1])
            print("dest_mac:", eth[0])
            print("Info of the packet that reached the firewall vm")
            print("Version: " + str(ipData.ip4_header_version))
            print("ihl: " + str(ipData.header_length))
            print("Protocol: " + str(ipData.proto))
            print("Source Address: " + get_ipv4(ipData.src))
            print("Destination Address: " + get_ipv4(ipData.dest))
            print("TTL: " + str(ipData.ttl) + "\n")

        # IPv6 Packet
        elif eth[2] == 34525:
            print("IPV6 packet")
            ipPacket = eth[3]
            ipData: Ipv6Props = Ipv6Props(*ip6_header(ipPacket))
            if ipData.proto == 17:
                udp_pkt = udp_header(ipData.data)
                firewall_props = Params(
                    str(ipaddress.ip_address(ipData.src)),
                    str(ipaddress.ip_address(ipData.dest)),
                    str(udp_pkt[0]),
                    str(udp_pkt[1]),
                    str(ipData.proto),
                    str(eth[1]),
                    str(eth[0]),
                    str(flag),
                )
                udp(pkt, st, ipData, firewall_props, counter, s1, flag, eth, rules_file)
                if flag:
                    counter.numPackets += 1
            elif ipData.proto == 6:
                tcp_pkt = tcp_header(ipData.data)
                firewall_props = Params(
                    str(ipaddress.ip_address(ipData.src)),
                    str(ipaddress.ip_address(ipData.dest)),
                    str(tcp_pkt[0]),
                    str(tcp_pkt[1]),
                    str(ipData.proto),
                    str(eth[1]),
                    str(eth[0]),
                    str(flag),
                )
                tcp(pkt, st, firewall_props, counter, s1, flag, eth, rules_file)
                if flag:
                    counter.numPackets += 1

            elif ipData.proto == 1:
                icmp(pkt, st, ipData, counter, s1, flag, eth, rules_file)

            print("Protocol: " + str(ipData.proto))
            print("Source address: ", ipaddress.ip_address(ipData.src))
            print("Destination address: ", ipaddress.ip_address(ipData.dest))
