OUTPUT_FORMAT(binary) 
ENTRY(start) 
SECTIONS
{ 
	. = 0x7C00; 
	.boot : AT(0x0) { *(.boot) } 
	. = 0x500; 
	.init : AT(0x200) { *(.init) } 
	. = 0x50000; 
	.text : AT(0x600) { *(.text) }
	.data : { *(.data) }
	.rodata : { *(.rodata) } 
	.bss : { *(.bss) }
}
