section .data
    msg db '1337', 0xa    ; Message à afficher, suivi d'un saut de ligne
    msg_len equ $-msg     ; Longueur du message

section .bss
    input resb 4          ; Réserve 4 octets pour l'entrée (3 caractères + saut de ligne)

section .text
    global _start

_start:
    ; Lire l'entrée de l'utilisateur
    mov eax, 0            ; sys_read
    mov edi, 0            ; file descriptor 0 (stdin)
    mov rsi, input        ; pointeur vers le buffer d'entrée
    mov edx, 4            ; nombre d'octets à lire
    syscall

    ; Comparer l'entrée à "420\n"
    mov al, [input]       ; Charge le premier caractère de l'entrée
    cmp al, '4'           ; Compare avec '4'
    jne check_42          ; Si différent, vérifier "42"

    mov al, [input+1]     ; Charge le deuxième caractère de l'entrée
    cmp al, '2'           ; Compare avec '2'
    jne check_42          ; Si différent, vérifier "42"

    mov al, [input+2]     ; Charge le troisième caractère de l'entrée
    cmp al, '0'           ; Compare avec '0'
    je exit_with_1        ; Si égal, sortir avec le code 1

check_42:
    ; Comparer l'entrée à "42\n"
    mov al, [input]       ; Charge le premier caractère de l'entrée
    cmp al, '4'           ; Compare avec '4'
    jne exit_with_1       ; Si différent, sortir avec le code 1

    mov al, [input+1]     ; Charge le deuxième caractère de l'entrée
    cmp al, '2'           ; Compare avec '2'
    jne exit_with_1       ; Si différent, sortir avec le code 1

    mov al, [input+2]     ; Charge le troisième caractère de l'entrée
    cmp al, 0xa           ; Compare avec le saut de ligne (ASCII 10)
    jne exit_with_1       ; Si différent, sortir avec le code 1

    ; Afficher '1337' si l'entrée est "42\n"
    mov eax, 1            ; sys_write
    mov edi, 1            ; file descriptor 1 (stdout)
    mov rsi, msg          ; pointeur vers le message
    mov edx, msg_len      ; longueur du message
    syscall

    ; Sortir avec le code 0
    mov eax, 60           ; sys_exit
    xor edi, edi          ; code de sortie 0
    syscall

exit_with_1:
    mov eax, 60           ; sys_exit
    mov edi, 1            ; code de sortie 1
    syscall

