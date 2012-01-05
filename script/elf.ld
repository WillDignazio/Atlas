OUTPUT_FORMAT(elf32-i386)
ENTRY(boot_load)
SECTIONS
{ 
	. = 0x7C00; 
	.boot : AT(0x0) { *(.boot) }
	. = 0x500; 
	.init : AT(0x200) { *(.init) }
}
