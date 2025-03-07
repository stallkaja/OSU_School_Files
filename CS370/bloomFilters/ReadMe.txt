No make file is needed as this is written in python.
You do need to install python modules bitarray and pymmh3

pymmh3 is the algorithm that I used, I did so because it is a very common pythong module and was easy to use.
The usage for this script is from a command prompt "python bloomFilters.py dictionary.txt rockyou.ISO-8859.txt output.txt" 
where rockyou.ISO-8859.txt is the input file of passwords and output.txt will contain the results for given passwords.

For the size of the bit array I used the formula m = -(n * math.log(p))/(math.log(2)**2)
For the number of hashes I used the formula k = (m/n) * math.log(2)
Both of these formulas I got from this website :https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/

For this exercise my script found the array size to be 8945341 and the hashcount was 4. Using the given input text my script usually ran in around 50 seconds.

In regards to positive and negative results. First bloom filters never produce false negatives, IE telling you a word doesnt exist when it actually does, which is exactly why we use 
it for things like name look up and similar. The rate of false positives IE it tells you it does exit and it doesnt is given by p=(1-(1-1/m)^kn)^kn

I constructed my bit array size and number of hashes to create a .05 percent change of false positives. I did so using the other formulas given on the before mentioned site.
