VERSION=0.01
NAME=ATLAS

AS=nasm
CC=gcc
LD=ld
out_dir=$(CURDIR)/bin/
INC=$(CURDIR)/include/
SCRIPT=$(CURDIR)/script/
AFLAGS=-f elf32 -I $(INC) 
CFLAGS=-m32 -c -I $(INC)
LDFLAGS=-melf_i386 -T $(SCRIPT)
OBJ=*.o
TARGET="NONE"

# Start point of making Atlas 
# By default if there is no extra options set, 
# the bootloader will produce a linkable object file. 
# that requires the linker script to compile with. 
atlas: boot.o 
	@echo "linking..."
	$(LD) -r $(LDFLAGS)elf.ld $(out_dir)*.o -o ./Atlas.o

all: atlas textmode.o
	@echo "linking..." 
	$(LD) -r $(LDFLAGS)elf.ld $(out_dir)*.o -o ./Atlas.o
target: atlas 
	dd if=/dev/zero of=$(out_dir)fluff.bin bs=1M count=10
	$(LD) $(LDFLAGS)complete.ld Atlas.o $(TARGET) -o ./bin/Atlas_Complete.bin
	cat $(out_dir)Atlas_Complete.bin $(out_dir)/fluff.bin > Atlas.img

boot.o:
	mkdir -p ./bin/
	$(AS) $(AFLAGS) ./boot/boot.asm -o $(out_dir)boot.o
	$(AS) $(AFLAGS) ./boot/init.asm -o $(out_dir)init.o

textmode.o: 
	$(CC) $(CFLAGS) ./base/textmode.c -o $(out_dir)textmode.o 

clean: 
	@echo "Cleaning..."
	@rm -rf $(out_dir)
	@rm -f ./Atlas.o 
	@rm -f ./Atlas.img

