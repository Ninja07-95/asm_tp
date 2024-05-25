section .data
    successMessage db '1337', 0xA ; Message à afficher avec un saut de ligne à la fin
    messageLength equ $-successMessage ; Calcule la longueur du message
    expectedArg db '42', 0 ; L'argument attendu est "42" suivi d'un caractère nul

section .bss

section .text
    global _start

_start:
    mov rax, [rsp] ; argc (nombre d'arguments, incluant le nom du programme)
    cmp rax, 2 ; Vérifier si nous avons au moins 1 argument + le nom du programme
    jl .exitFailure ; Sauter à la fin avec un code de sortie 1 si moins de 2 arguments

    mov rsi, [rsp+16] ; argv[1]
    mov rdi, expectedArg ; L'argument attendu ("42\0")
    call compareStrings ; Comparer l'argument fourni avec "42"

    test al, al ; Vérifier le résultat de la comparaison
    jz .printSuccess ; Si zéro (succès), afficher le message

.exitFailure:
    mov eax, 60 ; syscall: exit
    mov edi, 1 ; Code de sortie: 1
    syscall

.printSuccess:
    mov eax, 1 ; syscall: write
    mov edi, 1 ; fd: stdout
    mov rsi, successMessage ; Le message à afficher
    mov edx, messageLength ; Longueur du message
    syscall

    ; Sortie avec code 0
    mov eax, 60 ; syscall: exit
    xor edi, edi ; Code de sortie: 0
    syscall

compareStrings:
    .nextChar:
        mov al, [rdi] ; Charger le caractère courant de la chaîne attendue
        mov bl, [rsi] ; Charger le caractère courant de l'entrée de l'utilisateur
        cmp al, bl ; Comparer les deux caractères
        jne .notequal ; Sauter si les caractères ne sont pas égaux
        or al, al ; Vérifier si on a atteint la fin de la chaîne attendue
        jz .equal ; Si al est 0, les deux chaînes sont égales jusqu'au caractère nul
        inc rdi ; Passer au caractère suivant dans la chaîne attendue
        inc rsi ; Passer au caractère suivant dans l'entrée de l'utilisateur
        jmp .nextChar ; Continuer la comparaison
    .equal:
        xor al, al ; Mettre 0 dans AL pour indiquer l'égalité
        ret
    .notequal:
        mov al, 1 ; Mettre 1 dans AL pour indiquer une différence
        ret

