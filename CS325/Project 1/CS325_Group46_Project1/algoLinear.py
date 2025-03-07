
def linearAlgo(a):
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
