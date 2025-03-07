from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad

def encVal(key):

    return bytearray(key, encoding = "utf-8"), bytearray.fromhex("00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00")

def encMsg(key, iv, word):

    return AES.new(key, AES.MODE_CBC, iv).encrypt(pad(str.encode(word), AES.block_size)).hex()

def wordPadding(word, buffer):

    for x in range(0, buffer):
        word += ' '

    return word

def findKey(plain, cipher):
    #8d20e5056a8d24d0462ce74e4904c1b513e10d1df4a2ef2ad4540fae1ca0aaf9
    #This is a top secret.
    library = []
    file = open('words.txt', 'r')

    for line in file:
        newLine = line.strip()
        library.append(newLine)

    file.close()
    print(plain)
    print(cipher)
    

    for word in library:
        if(len(word) < 16):

            keySize, iv = encVal(wordPadding(word, 16 - len(word)))
            

            if(plain == encMsg(keySize, iv, cipher)):
                print(word)
        else:
            continue


