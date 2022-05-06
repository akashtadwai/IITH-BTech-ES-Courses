"""
This module contains all the functions related to extracting header information from the packet.
"""
import struct


def get_ipv4(addr: bytes) -> str:
    """
    Converts to IPv4 address from binary
    @param addr:
    @return: str: ipv4 address in dotted notation
    """
    return ".".join(map(str, addr))


def get_mac(mac_string: bytes) -> str:
    """
    Converts to MAC address in hexadecimal format
    @param: mac_string: bytes
    @return: str: mac address in hexadecimal format
    """
    return ":".join("%02x" % b for b in mac_string)


def ethernet_header(packet: bytes) -> tuple:
    """
    Separates the ethernet header from the packet
    @param packet: bytes
    @return: tuple: (destination_mac, source_mac, ethernet_type,data)
    """
    dest, src, proto = struct.unpack("! 6s 6s H", packet[:14])
    ether_type = proto
    src_mac = get_mac(src)
    dest_mac = get_mac(dest)
    data = packet[14:]
    return dest_mac, src_mac, ether_type, data


def ip4_header(ipPacket: bytes) -> tuple:
    """
    Separates the ipv4 header from the packet
    @param ipPacket: bytes
    @return: tuple: (header_version,header_len,protocol,source_ip,dest_ip,ttl,data)
    """
    ip_version = ipPacket[0]
    header_length = (ip_version % 16) * 4
    ip4_header_version = ip_version // 16
    ttl, proto, src, dest = struct.unpack("! 8x B B 2x 4s 4s", ipPacket[0:20])
    data = ipPacket[header_length:]
    return ip4_header_version, header_length, proto, src, dest, ttl, data


def ip6_header(ipPacket: bytes) -> tuple:
    """
    Separates the ipv6 header from the packet
    @param ipPacket: bytes
    @return: tuple: (next_header,hop_limit,source_ip,dest_ip,length,data)
    """
    next_header, hop_limit, src, dest = struct.unpack("! B B 16s 16s", ipPacket[6:40])
    length = ipPacket[4:6]
    data = ipPacket[40:]
    return next_header, hop_limit, src, dest, length, data


def udp_header(udpHeader: bytes) -> tuple:
    """
    Separates the udp header from the packet
    @param udpHeader: bytes
    @return: tuple: (source_port,dest_port,length,check_sum,data)
    """
    src_port, dest_port, length, check_sum = struct.unpack("! H H H H", udpHeader[:8])
    data = udpHeader[8:]
    return src_port, dest_port, length, check_sum, data


def tcp_header(tcpheader: bytes) -> tuple:
    """
    Separates the tcp header from the packet
    @param tcpheader: bytes
    @return: tuple: (source_port,dest_port,header_length,data)
    """
    (src_port, dest_port, _, _, temp) = struct.unpack("! H H L L H", tcpheader[:14])
    header_length = (temp >> 12) * 4
    data = tcpheader[header_length:]
    return src_port, dest_port, header_length, data


__all__ = [
    "get_ipv4",
    "get_mac",
    "ethernet_header",
    "ip4_header",
    "ip6_header",
    "udp_header",
    "tcp_header",
]
