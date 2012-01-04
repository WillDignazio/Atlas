;;GDT inc file
;;	- GDT setup routines
;; 	- The platform for setting up protected mode 
%ifndef __GDT_INC_UNIQUEID1_INCLUDED__
%define __GDT_INC_UNIQUEID1_INCLUDED__
[BITS 16]

;; GDT Install
;;	-Installs the GDT
gdt_install:
  cli 			; Clear interrupts
  pusha 		; Save registers
  lgdt [toc]	; Load GDT into GDTR
  sti			; re-enable interrupts
  popa			; restore registers
  ret			; done. 

;; GLOBAL DESCRIPTOR TABLE (GDT)
gdt_data:
  dd 0			; null descriptor
  dd 0 			
;; CODE DESCRIPTOR
  dw 0FFFFh		; limit low
  dw 0			; base low
  db 0			; base middle 
  db 10011010b	; access
  db 11001111b	; granularity
  db 0			; base high
;; DATA DESCRIPTOR
  dw 0FFFFh		; limit low
  dw 0			; base low
  db 0			; base middle
  db 10010010b	; access
  db 11001111b	; granularity
  db 0			; base high 
end_of_gdt:
toc:
  dw end_of_gdt - gdt_data - 1 ; size of gdt
  dd gdt_data					; base of gdt

%endif 
