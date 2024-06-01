section .bss
    n resd 1        ; Réserve 4 octets pour stocker l'entier n
    sum resd 1      ; Réserve 4 octets pour stocker la somme
    buffer resb 20  ; Réserve 20 octets pour lire l'entrée de l'utilisateur
    result resb 20  ; Réserve 20 octets pour stocker la chaîne de résultat

section .data
    prompt db 'Enter a positive integer: ', 0
    sum_msg db 0AH, 'Sum = ', 0
    newline db 0AH, 0
    ten dq 10

section .text
    global _start

_start:
    ; Initialise sum à 0
    mov dword [sum], 0

read_input:
    ; Affiche le message d'invite
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rsi, prompt           ; adresse de la chaîne
    mov rdx, 25               ; longueur de la chaîne
    syscall

    ; Lit l'entrée de l'utilisateur
    mov rax, 0                ; syscall: read
    mov rdi, 0                ; file descriptor: stdin
    mov rsi, buffer           ; adresse pour stocker l'entrée
    mov rdx, 20               ; nombre d'octets à lire
    syscall

    ; Convertit l'entrée ASCII en entier
    call atoi
    mov [n], eax              ; stocke le résultat dans n

    ; Vérifie si n est positif
    cmp dword [n], 1
    jl read_input             ; si n < 1, relire l'entrée

    ; Initialisation de la boucle
    mov ecx, 1                ; i = 1

sum_loop:
    ; Compare i à n-1
    cmp ecx, [n]
    jge end_loop              ; si i >= n, finir la boucle

    ; Ajoute i à sum
    add dword [sum], ecx

    ; Incrémente i
    inc ecx
    jmp sum_loop              ; répète la boucle

end_loop:
    ; Affiche le message de somme
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rsi, sum_msg          ; adresse de la chaîne
    mov rdx, 7                ; longueur de la chaîne
    syscall

    ; Convertit sum en chaîne et l'affiche
    mov eax, [sum]
    call itoa                 ; Convertit eax en chaîne de caractères dans result

    ; Affiche la somme convertie
    mov rax, 1                ; syscall: write
    mov rdi, 1                ; file descriptor: stdout
    mov rsi, result           ; adresse de la chaîne convertie
    mov rdx, 20               ; longueur maximale de la chaîne
    syscall

    ; Ajoute une nouvelle ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

exit:
    ; Quitte le programme
    mov rax, 60               ; syscall: exit
    xor rdi, rdi              ; code de sortie 0
    syscall

atoi:
    ; Convertit la chaîne en entier (simple)
    xor eax, eax              ; Clear eax (résultat)
    xor ecx, ecx              ; Clear ecx (indice de la chaîne)
atoi_loop:
    movzx edx, byte [buffer + ecx]
    cmp dl, 10                ; Vérifie la fin de la ligne (ASCII 10)
    je atoi_done
    sub dl, '0'               ; Convertit le caractère ASCII en chiffre
    imul eax, eax, 10         ; Multiplie le résultat par 10
    add eax, edx              ; Ajoute le chiffre au résultat
    inc ecx
    jmp atoi_loop
atoi_done:
    ret

itoa:
    ; Convertit l'entier en chaîne (simple)
    mov rdi, result           ; Destination de la chaîne
    add rdi, 19               ; Déplace à la fin du buffer
    mov byte [rdi], 0         ; Ajoute le caractère nul
itoa_loop:
    dec rdi
    xor edx, edx
    div dword [ten]
    add dl, '0'
    mov [rdi], dl
    test eax, eax
    jnz itoa_loop
    mov rsi, rdi
    ret

