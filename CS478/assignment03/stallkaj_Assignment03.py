# import pyshark module
import pyshark

# create a list to store the protocols
protocols = []

# create a dictionary to store the protocol counts
protocol_counts = {}

# get the file name from the command line argument
file_name = "win.cap"

# open the file using pyshark.FileCapture
capture = pyshark.FileCapture(file_name)

#data
insecure_protocols = ["FTP", "TELNET", "SSL", "DNS", "HTTP", "POP3", "SMTP", "HTTPS"]
insecure_protocol_counts = {protocol: 0 for protocol in insecure_protocols}
common_ports = {
    22: "SSH",
    80: "HTTP",
    53: "DNS",
    21: "FTP",
    23: "TELNET",
    25: "SMTP",
    110: "POP3",
    143: "IMAP",
    443: "HTTPS",
    3306: "MySQL"
}

#collections
mismatched_ports = []
vulnerable_tls_versions = []
cleartext_credentials = []

def check_tls_version(packet):
    #Check for vulnerable TLS versions in a packet.
    tls_versions = {
        "0x0301": "TLS 1.0",
        "0x0302": "TLS 1.1",
        "0x0303": "TLS 1.2",
        "0x0304": "TLS 1.3",
    }
    if hasattr(packet, 'tls') and hasattr(packet.tls, 'record_version'):
        version = packet.tls.record_version
        if version in ["0x0301", "0x0302"]:
            return tls_versions[version]
    return None
    
#extra feature
def check_cleartext_data(packet):
    #Check for cleartext credentials or sensitive data in a packet.
    try:
        if hasattr(packet, 'ftp'):
            if hasattr(packet.ftp, 'request_command') and packet.ftp.request_command in ["USER", "PASS"]:
                return f"FTP {packet.ftp.request_command}: {packet.ftp.request_arg}"

        if hasattr(packet, 'telnet'):
            return f"TELNET Data: {packet.telnet.data_line}"

        if hasattr(packet, 'http'):
            if hasattr(packet.http, 'authorization'):  # Look for basic auth headers
                return f"HTTP Authorization: {packet.http.authorization}"
    except Exception as e:
        pass
    return None

# loop through each packet in the capture
for packet in capture:
    # get the protocol name from the packet
    protocol = packet.highest_layer

    # if the protocol is not None, add it to the list and update the dictionary
    if protocol:
        protocols.append(protocol)
        protocol_counts[protocol] = protocol_counts.get(protocol, 0) + 1


        if protocol.upper() in insecure_protocols:
            insecure_protocol_counts[protocol.upper()] += 1


        if hasattr(packet, 'tcp'):
            src_port = int(packet.tcp.srcport)
            dst_port = int(packet.tcp.dstport)

            if src_port in common_ports or dst_port in common_ports:
                expected_protocol = common_ports.get(src_port) or common_ports.get(dst_port)
                if protocol.upper() != expected_protocol:
                    mismatched_ports.append((src_port if src_port in common_ports else dst_port, protocol))


        tls_version = check_tls_version(packet)
        if tls_version:
            vulnerable_tls_versions.append((packet.number, tls_version))


        sensitive_data = check_cleartext_data(packet)
        if sensitive_data:
            cleartext_credentials.append((packet.number, sensitive_data))

    # print the packet number and the protocol name
    print(f"Packet {packet.number}: {protocol}")

# close the capture
capture.close()

# print the total number of packets and the unique protocols
print(f"Total packets: {len(protocols)}")
print(f"Unique protocols: {set(protocols)}")

# print the protocol counts for each protocol
for protocol, count in protocol_counts.items():
    print(f"{protocol}: {count}")

#print other info and counts
print("\nInsecure Protocols:")
for protocol, count in insecure_protocol_counts.items():
    print(f"{protocol}: {count}")


print("\nMismatched Ports:")
for port, protocol in mismatched_ports:
    print(f"Port {port} used for {protocol}, expected different protocol.")


print("\nVulnerable TLS Versions:")
for packet_number, tls_version in vulnerable_tls_versions:
    print(f"Packet {packet_number} uses vulnerable TLS version: {tls_version}")

#extra feature
print("\nCleartext Data:")
for packet_number, data in cleartext_credentials:
    print(f"Packet {packet_number} contains sensitive data: {data}")
