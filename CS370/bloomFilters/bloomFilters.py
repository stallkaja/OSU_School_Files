#lab 3
# Found this useful for implementing bloomFilter https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/
import sys
import os
import time
from time import process_time
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
			digests = pymmh3.hash(entry, i) % self.dictSize
			self.bitarray[digests] = True
			
	def check(self, entry):
		for i in range(self.hashCount):
			digests = pymmh3.hash(entry, i) % self.dictSize
			if self.bitarray[digests] == False:
				return "maybe"
			return "no"

    
def createBloom(hashCount, passwords,outPutFile):
    fp_prob = 0.05
    n = len(passwords)
    dictSize = int(-(n * math.log(fp_prob))/(math.log(2)**2))
    bloom = BloomFilter(dictSize,hashCount)
    dictionary = open(sys.argv[1]).read().splitlines()
    for word in dictionary:
        bloom.add(word)
    output = open(outPutFile, 'w+')
    for word in passwords:
        output.write(bloom.check(word) + '\n')

def main():
    passwords = open(sys.argv[2],encoding="latin-1").read().splitlines()
    fp_prob = 0.05
    n = len(passwords)
    dictSize = int(-(n * math.log(fp_prob))/(math.log(2)**2))
    hashCount = int((dictSize/n) * math.log(2))
    print("dictSize is: ")
    print(dictSize)
    print("hashCount is: ")
    print(hashCount)
    startTime = process_time();
    createBloom(hashCount,passwords,sys.argv[3])
    endTime = process_time();
    print ("Ran passwords in this many seconds", endTime-startTime)
if __name__ == "__main__": main()
