# Found this useful for implementing bloomFilter https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/
import sys
import os
import time
from bitarray import bitarray
import pymmh3 #using most standard pyhon hashing function
import math


class BloomFilter(object):
	#initializing the variables
	def __init__(self, dictSize, hashCount):
		super(BloomFilter, self).__init__()
		self.dictSize = dictSize
		self.bitarray = bitarray(self.dictSize)
		self.bitarray.setall(0)
		self.hashCount = hashCount


	def add(self, entry):
		digests = []
		for i in range(self.hashCount):
			digests = mmh3.hash(entry, i) % self.dictSize
			self.bitarray[digests] = True
			
	def check(self, entry):
		for i in range(self.hashCount):
			digests = mmh3.hash(entry, i) % self.dictSize
			if self.bitarray[digests] == False:
				return "maybe"
			return "no"

    
def createBloom(hashCount, passwords,outputFile):
    space = 2**32 #the dictionary size is 623518 lines so 2^32 should be enough for password space
    bloom = BloomFilter(space,hashCount)
    dictionary = open(sys.argv[1]).read().splitlines()
    for word in dictonary:
        bloom.add(word)
    output = open(outPutFile, 'w+')
    for word in passwords:
        output.write(bloom.search(word) + '\n')

def main():
    passwords = open(sys.argv[2]).read().splitlines()
    passwords.pop(0) #remove the count
    timer = time.clock()
    createBloom(3,passwords,sys.argv[3])
    print ("Ran passwords in this many seconds", timer)
if __name__ == "__main__": main()
