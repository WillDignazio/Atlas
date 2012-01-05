;; Atlas Init 
;; Author: Will Dignazio
;; Date: 01/05/2012 
;; Description: 
;; 	Initializer of Atlas boot loader, it sets up the environment for 
;; whatever code is to be run afterword. This environment includes
;; a GDT, with kernel privelage for the entire 4gb of RAM of a IA32 
;; system. It also enables the A20 line, which by most standards is
;; not set at boot. After the A20 address line, and the GDT have been
;; established, protected mode is set to give maximum power to the 
;; code following this initializer. 
[BITS 16]
[extern start]
[global init]
[SECTION .init]
jmp init 

%include "gdt.inc"
%include "print.inc"
%include "a20.inc"
%define	DATA_DESCRIPTOR		0x10
%define CODE_DESCRIPTOR		0x08

init:
  cli
  xor ax, ax				; Set up a flat structure 
  mov ds, ax
  mov es, ax
  mov ax, 0x9000			; Stack at 0x9000
  mov ss, ax
  mov sp, 0xFFFF			; Move the pointer way off.  
  sti
  
  mov [bootdrv], dl			; Save the boot drive

  call setvideo  			; Setting the video mode clears the screen. 
  
  mov si, aengage			; Get Fancy 
  call printxt

  mov si, newline
  call printxt

 .systemcheck:
  
  mov si, readinit
  call printxt			
  
  mov si, isA20
  call printxt
  call check_a20			; Check a20 status
  call printAStatus			; Print The status

  mov si, resetting
  call printxt
  call devres				; Reset Disk Drive
  
  mov si, readingkrn
  call printxt		
  call iLoad				; Read Kernel From Disk
  mov si, done
  call printxt

  mov si, gdtinit 
  call printxt 
  call gdt_install			; Install the gdt descriptors

  mov si, pmodeinit
  call printxt

  cli						; Clear the interrupts 
  mov eax, cr0				; Get the register
  or eax, 1					; Set the pm bit 
  mov cr0, eax				; Move it back, we're now in protected mode.
  jmp CODE_DESCRIPTOR:.End	; Far jump to .End to prove the GDT is alright

.End: 
[BITS 32]					; We're now in 32 bit mode. 
  mov ax, DATA_DESCRIPTOR	; The process is done, we're ready to start 
  mov ds, ax				; the user code. 
  mov ss, ax
  mov es, ax
  mov esp, 0x90000			; But first, we have to set the registers. 
  call start				; Call the start Atlas shrugs to.  

[BITS 16] 					; We're back in 16 bits here for the functions of the loader. 

;; Print A20 Status
;;	- prints the status of the a20 line to the screen 
printAStatus: 
  cmp ax, 0
  jne .yes
  mov si, no
  call printxt
  mov si, enablingA20
  call printxt
  call enable_A20
  ret
 .yes:
  mov si, yes
  call printxt
  ret

;; Set Video Mode
;;	- Sets the video mode
;; 	- The setting will be kept in the ax register. 
setvideo:
  mov ah, 0			; Set video mode 
  mov al, 03h 		; 80*25 text mode 
  int 10h

  mov ch, 32
  mov ah, 1
  int 10h
  ret

;; Init Load 
;;	- Loads the code data to the physical memory
;;	- Drops it in ES:BX
;;	- ES:BX (start point) will be 0x500
;;	- Absolute address 50000
iLoad:
  mov ax, 0x5000 	; Load data to 5000:bx
  mov es, ax		; Set extra segment
  mov bx, 0x0   	; int 13h takes ES:BX
  mov ah, 2			; Read from drive 
  mov al, 127  		; Read 127 sectors (512x10)
  mov cx, 4			; Track and sector start data
  mov dh, 0			; Head
  mov dl, [bootdrv]	; Set Boot Drive 
  int 13h
  ret

;; Drive Reset
;;	- Resets the bootdrv. 
devres:
  push ds			; Save Data Segment location
  mov ax, 0			; Function zero
  mov dl, [bootdrv]	; Set boot drive
  int 13h		
  pop ds			; Recover data segment address
  ret

newline		db 	0x02, 0x0D, 0x0A, 0x03
aengage		db	0x02, '{ ATLAS ENGAGED }', 0x0D, 0x0A, 0x03
yes 		db 	0x02, 'YES', 0x0D, 0x0A, 0x03
no 			db	0x02, 'NO', 0x0D, 0x0A, 0x03
isA20 		db	0x02, '::A20 Enabled: ', 0x03
readingkrn 	db	0x02, '::Reading Kernel From Disk', 0x0D, 0x0A, 0x03
resetting 	db	0x02, '::Resetting Disk Drive', 0x0D, 0x0A, 0x03
status 		db 	0x02, 'Status: ', 0x03
errcode 	db	0x02, 'Error Code: ', 0x03
done		db	0x02, '::Done.', 0x0A, 0x0D, 0x03
notxt		db	0x02, 'ERROR, NOT A STRING', 0x0D, 0x0A, 0x03
readinit 	db	0x02, 'Code Read Initiated:', 0x0D, 0x0A, 0x03
gdtinit		db	0x02, '::Setting Up GDT', 0x0D, 0x0A, 0x03
pmodeinit 	db 	0x02, '::Entering Protected Mode', 0x0D, 0x0A, 0x03
enablingA20 db 	0x02, '::Enabling A20', 0x0D, 0x0A, 0x03
bootdrv		db	0

times 1022-($-$$) db 0  
dw 'WD'			; Signature to know where we are in a dump. 
EXIT:
