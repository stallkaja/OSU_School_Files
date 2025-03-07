To use this script you must have the following installed

import sys
import os
import psutil
Enumerate all the running processes. 
	./hw3.py -p
List all the running threads within process boundary.
	./hw3.py -t
Enumerate all the loaded modules within the processes.
	./hw3.py -l
Is able to show all the executable pages within the processes.
	./hw3.py -e
Gives us a capability to read the memory.
	./hw3.py -m