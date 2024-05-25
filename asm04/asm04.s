section .data
section .text
    global _start

_start:
    mov rax, [rsp+8] ; argc (nombre d'arguments, incluant le nom du programme)
    cmp rax, 2 ; Nous attendons au moins 1 argument + le nom du programme
    jl .exitSuccess ; Sauter à la fin avec un code de sortie 0 si moins de 2 arguments

    mov rsi, [rsp+16] ; argv[1]
    call convertToInt ; Convertir l'argument en entier

    test rax, 1 ; Teste le bit le plus bas de RAX
    jnz .exitSuccess ; Si impair (bit le plus bas est 1), sauter à exitSuccess

.exitSuccess:
    xor edi, edi ; Code de sortie 0
    jmp .exit

.exit:
    mov eax, 60 ; syscall: exit
    syscall

convertToInt:
    xor rax, rax ; Efface RAX pour stocker le résultat
    .loop:
        movzx rcx, byte [rsi] ; Lire le caractère actuel
        test rcx, rcx ; Vérifie si le caractère est NULL
        jz .done ; Fin de la chaîne
        sub rcx, '0' ; Convertir de ASCII à entier
        imul rax, rax, 10 ; RAX = RAX * 10
        add rax, rcx ; RAX = RAX + RCX (ajouter la valeur du chiffre actuel)
        inc rsi ; Passer au prochain caractère
        jmp .loop
    .done:
        ret

