import socket
import time
import random
import string

TARGET_IP = "127.0.0.1"
TARGET_PORT = 8888
INITIAL_PAYLOAD_SIZE = 64
INCREMENT = 16
MAX_SIZE = 1024


def generate_payload(size):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=size)).encode()


def fuzz():
    size = INITIAL_PAYLOAD_SIZE
    while size <= MAX_SIZE:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((TARGET_IP, TARGET_PORT))
            payload = generate_payload(size)
            s.sendall(payload)
            s.close()
        except ConnectionResetError:
            print("[!] Server crashed!")
            break
        size += INCREMENT
        time.sleep(0.5)

if __name__ == "__main__":
    fuzz()