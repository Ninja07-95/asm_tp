;section .text
;    global _start

;_start:

global _start
section .text

_start :
	mov rax, 0x3c
	mov rdi, 0
	syscall
