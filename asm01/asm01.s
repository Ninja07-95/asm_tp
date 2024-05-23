section .data
    message db '1337', 10  ; '1337' suivi d'un saut de ligne

section .text
    global _start

_start:
    ; Appel système 'write'
    mov rax, 1            ; numéro de l'appel système sys_write
    mov rdi, 1            ; file descriptor 1 (stdout)
    mov rsi, message      ; pointeur vers le message à écrire
    mov rdx, 5            ; taille du message à écrire (4 caractères + saut de ligne)
    syscall

    ; Appel système 'exit'
    mov rax, 60           ; numéro de l'appel système sys_exit
    xor rdi, rdi          ; code de sortie 0
    syscall
