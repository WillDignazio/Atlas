; Print Data Include File 
;	- Functions for printing data to terminal 
;	- Contains:
; 		print: print a single character in al
; 		printxt: prints a string starting at si
%ifndef __PRINT_INC_UNIQUEID2_INCLUDED__
%define __PRINT_INC_UNIQUEID2_INCLUDED__

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

%endif 

