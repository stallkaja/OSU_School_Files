
import hashlib
import random
import string


def createString():

    newString = ''.join(random.choice(string.ascii_letters) for i in range(10))

    return newString

def hashString(givenString):

    hashValue = hashlib.sha256(givenString.encode())

    return hashValue.hexdigest()

def main():

    print("Weak Collision Resistance\n")
    testCount = 0
    netCollisions = 0

    stringOne = createString()

    for i in range(50):
       
        attemptNum = 0
        testCount += 1
       
        while 1:
            stringTwo = createString()
            if stringOne == stringTwo:
                continue
            else:
                hashValueOne = hashString(stringOne)
                hashValueTwo = hashString(stringTwo)
            
                attemptNum += 1

            if(hashValueOne[0:6] == hashValueTwo[0:6]):
                break

        netCollisions += attemptNum
    average = netCollisions / testCount

    print("Number of tests ran: %s" % (testCount))
    print("Average attempts to break: %s" % average)

    print("Collision Free Resistance\n")
    testCount = 0
    netCollisions = 0
    
    for i in range(50):
        attemptNum = 0
        testCount += 1

        while 1:
            stringOne = createString()
            stringTwo = createString()
            if stringOne == stringTwo:
                continue
            else:
                hashValueOne = hashString(stringOne)
                hashValueTwo = hashString(stringTwo)  

                attemptNum += 1

                if(hashValueOne[0:6] == hashValueTwo[0:6]):
                    break

        netCollisions += attemptNum
    average = netCollisions / testCount

    print("Number of tests ran: %s" % (testCount))
    print("Average attempts to break: %s" % average)

main()
