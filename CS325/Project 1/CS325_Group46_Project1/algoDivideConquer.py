import math

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

def divideConquerAlgo(array, low, high):

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
