; SOS Boot Loader
; Author: Will Dignazio
; Date: 06/18/2011
; Rev.: 10/18/2011
; Bootloader for the Sandbox Operating System,loads the "boiler" (setup.asm) and 
; exits to it. The bootloader does nothing but load the necessary code for 
; the kernel.
[BITS 16]
[global boot_load] 
[extern initialize]
[SECTION .boot]
boot_load:

  mov [bootdrv], dl	; set boot drv var
  mov si, bootstr
  call printxt

  cli				; have to stop ints for stack change
  mov ax, 0x9000	
  mov ss, ax		; Set stack segment to 9000
  mov sp, 0			; SS:SP(0)
  sti				; re-enable interrupts
  
  mov [bootdrv], dl	; make sure bootdrive is set 
  call load			; Load the init program  
  mov si, attempt
  call printxt
  call initialize 	; Call the grabber outide of the bootloader

; Load init 
;	- Loads the init program from the boot drive
; 	- Uses all the registers
;	- Returns error codes in ah
load: 
  push ds
 .reset:
  mov ax, 0
  mov dl, [bootdrv]
  int 13h 			; Reset drive
  jc .reset
  pop ds
   
 .read:
  mov ax, 0x50		; Dump location	
  mov es, ax		; Set dump location offset
  mov bx, 0 		
  mov ah, 2			; Read func
  mov al, 1 		; Read 2  sectors (512 bytes x 2)
  mov cx, 2			; Cylinder to 0 (ch), and init sector to 2 (cl)
  mov dh, 0			; Head
  mov dl, [bootdrv]
  int 13h			; call read function bios interrupt
  jc .read			; If we are good, then don't try to read again

  cmp ah, 00
  je .ok			; if ah is 0, then int 13h went alright, otherwise...
  mov si, error
  call printxt
  mov al, ah		; The error code was in ah, now in al
  call print		; we want to print it out after the colon
  mov al, 0Dh		
  call print
  mov al, 0Ah
  call print
  mov si,wReboot	
  call printxt
  mov ah, 0		; Function 0
  int 16h		; Wait for keyboard press
  call warmreboot  
 .ok:
  mov dl, [bootdrv]
  retn

; Warm Reboot 
;	- Reboots the computer without fully turning it off
;	- Resets pretty much everything
warmreboot:
  mov ax, 40h		; bios location
  mov ds, ax		; set data segment here
  mov word[72h], 1234h	; warm reboot val
  jmp 0ffffh:0		; jmp and execute


; Print Character
;	- print a single character to the terminal
; 	- the character printed should be in the al
print: 
  mov ah, 0Eh
  mov bh, 0
  mov bl, 07h
  int 10h
  ret 

; Print Text 
;	- print a series of characters, a string of text, to the terminal 
; 	- move the address of the text to si
; 	- the first character must be the startoftext char (STX), ASII value 2
printxt: 
  mov al, [si]
  cmp al, 02h			; Compare to STX
  jne .error

 .print: 
  inc si				; next character
  mov al, [si]			; grab value at si
  cmp al, 03h			; compare to end of text value 
  je .done
  call print 			; print the character
  jmp .print
 .done: 
  ret 

 .error: 
  mov si, notxt 
  call printxt 
  ret



wReboot db 0x02, 'PRESS ANY KEY TO REBOOT', 0x0A, 0x0D, 0x03
attempt db 0x02, 'Exiting the Bootloader...', 0x0A, 0x0D, 0x03
error db 0x02, 'AN ERROR HAS OCCURRED: ', 0x03
done db 0x02, 'Done.', 0x0A, 0x0D, 0x03
bootstr db 0x02,'Booting...', 0x0A, 0x0D, 0x03
notxt db 0x02, 'Error: Not a String',0x0A, 0x0D, 0x03
bootdrv db 0

times 510-($-$$) db 0		; Fill to end
dw 0xaa55			; Signature
EXIT:
