
def enumerationAlgo(a):
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
