import math
import os

# Enumeration Algorithm
def max_sub1(a):
	max = 0
	sumSoFar = 0
	start = 0
	end = 0
	for i in range(len(a)):
		for j in range(i, len(a)):
			for k in range(i, (j + 1)):
				sumSoFar = sumSoFar + a[k]
			if sumSoFar > max:
				max = sumSoFar
				start = i
				end = k
			sumSoFar = 0
	return max, start, end

# Better Enumeration Algorithm
def max_sub2(a):
	max = 0
	start = 0
	end = 0
	for i in range(len(a)):
		sumSoFar = 0
		for j in range(i, len(a)):
			sumSoFar = sumSoFar + a[j]
			if sumSoFar > max:
				max = sumSoFar
				start = i
				end = j
		sumSoFar = 0
	return max, start, end

# Divide and Conquer Algorithm
def getMaxCrossingSubarray(array, low, mid, high):

	leftSum = -float("inf")
	sum = 0
	maxLeft = None

	for i in range(mid, low-1, -1):
		sum += array[i]
		if sum > leftSum:
			leftSum = sum
			maxLeft = i

	rightSum = -float("inf")
	sum = 0
	maxRight = None

	for j in range(mid+1, high+1):
		sum += array[j]
		if sum > rightSum:
			rightSum = sum
			maxRight = j

	return leftSum+rightSum, maxLeft, maxRight

def getMaxSubarray(array, low, high):

	if high == low:
		return(array[low], low, high)			# Base Case of 1 element array

	else:
		mid = int(math.floor((low+high)/2))

		leftSum, leftLow, leftHigh = getMaxSubarray(array, low, mid)					# return tuple for left half
		rightSum, rightLow, rightHigh = getMaxSubarray(array, mid+1, high)				# return tuple for right half
		crossSum, crossLow, crossHigh = getMaxCrossingSubarray(array, low, mid, high)	# return tuple for across middle subarray

		if leftSum >= rightSum and leftSum >= crossSum:	# subarray on left has greatest sum
			return leftSum, leftLow, leftHigh
		elif rightSum >= leftSum and rightSum >= crossSum:	# subarray on right has greatest sum
			return rightSum, rightLow, rightHigh
		else:												# subarray on across middle has greatest sum
			return crossSum, crossLow, crossHigh

# Liner Algorithm
def max_sub4(a):
	maxHere = 0
	maxSoFar = 0
	sum = 0
	start = 0
	end = 0
	startFinal = 0
	endFinal = 0
	for x in range(len(a)):
		if a[x] > maxHere + a[x]:
			maxHere = a[x]
			start = x
		else:
			maxHere = maxHere + a[x]
			end = x

		if maxSoFar < maxHere:
			maxSoFar = maxHere
			startFinal = start
			endFinal = end
	return maxSoFar, startFinal, endFinal



