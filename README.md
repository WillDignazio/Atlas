Atlas Kernel Platform 
---------------------

Originally part of the Sandbox Operating System project, it 
became apparent that the bootloader was essentially it's own program. That
bootloader, now named Atlas, could be very useful for booting virtually any
compiled code, given the right dependencies. Currently the most compatible 
with the IA32 architecture, the Atlas bootloader works hand in hand with the
processor, with no crazy hacks behind the scenes. 

Read BINDING to get a more detailed explanation of how to bind Atlas
to an object file. The BINDING guides how to bind with or without targeting 
a specific file for linking.  

1. Build Options
================
There are two primary build options available, one is to build Atlas 
without binding it immediately to the desired code. The other is to build 
Atlas, and immediately bind it to a compiled object file, allowing it to 
boot immediately. There is no advantage to the other, it just a matter of 
use, and the need at hand. Both options produce the same output of Atlas.o, 
however the second option creates an entire image ready to be written to a 
disk. 
	
	The commands are: 

		1. make 
			- Creates elf-i386 object file
			- Use one of the linker scripts to link to code object
			- File output by default is Atlas.o in the source directory
	
		2. make target TARGET=X
			- X = elf object file to bind to 
			- Uses the ./script/complete.ld script 
			- Creates both Atlas.o, and Atlas.img file
			- Atlas.img should be fully bootable. 
			- Atlas.o is a linkable verion. 
		
		3. make no-libs 
			- Some applications may not want the libraries
			- i.e. the Foundation kernel uses the same video library
			- This excludes all the base libraries from the obj file
	

