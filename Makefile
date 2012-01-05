CC=nasm
out_dir=./bin/
INC=./inc/
SCRIPT=./script/
CFLAGS=-f elf32 -I $(INC) 
LDFLAGS=-melf_i386 -T $(SCRIPT)
OBJ=*.o
TARGET="NONE"

# Start point of making Atlas 
# By default if there is no extra options set, 
# the bootloader will produce a linkable object file. 
# that requires the linker script to compile with. 
atlas: boot.o 
	ld -r $(LDFLAGS)elf.ld $(out_dir)$(OBJ) -o ./Atlas.o 

target: boot.o 
	ld $(LDFLAGS)complete.ld $(out_dir)$(OBJ) $(TARGET) -o ./Atlas_Complete.bin

boot.o:
	mkdir -p ./bin/
	$(CC) $(CFLAGS) ./boot/boot.asm -o $(out_dir)boot.o
	$(CC) $(CFLAGS) ./boot/init.asm -o $(out_dir)init.o


clean: 
	rm -rf $(out_dir)
