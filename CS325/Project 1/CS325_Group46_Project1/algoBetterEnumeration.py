
def betterEnumerationAlgo(a):
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
