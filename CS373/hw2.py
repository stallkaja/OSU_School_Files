import sys
import os
import psutil
from psutil._common import bytes2human
from psutil._compat import get_terminal_size
import subprocess



def main():
    arg=sys.argv[1]
    print(len(sys.argv))
    if(len(sys.argv)>2):
        pid = int(sys.argv[2])
    elif((len(sys.argv)>2) and(arg == "-t" or arg == "-l" or arg == "-e" or arg == "-m")):
        print("missing pid")
        exit

    if arg == "-p":
        print("in P")
        for proc in psutil.process_iter():
        	pinfo = proc.as_dict(attrs=['pid', 'name', 'status', 'username'])
        	if pinfo['status'] == psutil.STATUS_RUNNING:
        		print(pinfo)
                    
    elif arg == "-t":
        print("in t")
        proc = psutil.Process(pid)
        threads = proc.threads()
        numThreads = proc.num_threads()
        for thread in threads:
            print(thread)
            
    elif arg == "-l":
        print("in l")
        p = psutil.Process(pid)
        for dll in p.memory_maps():
            print(dll.path)
    
    elif arg == "-e":
    	p1 = subprocess.Popen(['pmap', str(pid)], stdout=subprocess.PIPE)
    	p2 = subprocess.Popen(['grep', '\-x\-'], stdin=p1.stdout)
    	p1.stdout.close()
    	p2.communicate()

    elif arg == "-m":
        print("in m")
        p1 = subprocess.Popen(['gcore', '-a', str(pid)], stdout=subprocess.PIPE)
        p2 = subprocess.Popen(['xxd', 'core.{}'.format(pid)], stdin=p1.stdout)
        p1.stdout.close()
        p2.communicate()
    
if __name__ == "__main__":
    main()
