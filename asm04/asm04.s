section .data
    prompt db "Entrez un nombre : ", 0
    newline db 10

section .text
    global _start

_start:
    ; Afficher le prompt
    mov rsi, prompt
    call printString

    ; Lire l'entrée de l'utilisateur
    call readInt

    ; Tester si le nombre est impair
    test rax, 1
    jnz .exitFailure

    ; Sortie avec code de succès
    xor edi, edi
    jmp .exit

.exitFailure:
    ; Sortie avec code d'échec
    mov edi, 1

.exit:
    ; Appel système pour terminer le programme
    mov eax, 60
    syscall

printString:
    ; Afficher une chaîne de caractères pointée par RSI
    mov eax, 1
    mov edi, 1
    mov edx, 0xffffffff
    syscall
    ret

readInt:
    ; Lire un entier de l'entrée standard et le stocker dans RAX
    xor rax, rax
    xor rdi, rdi
    lea rsi, [rsp - 8] ; Pointeur vers l'emplacement de stockage temporaire
    mov rdx, 20 ; Longueur maximale de l'entrée
    syscall
    mov rax, [rsp - 8] ; Convertir la chaîne en entier
    ret

