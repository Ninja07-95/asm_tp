section .bss
    VAL1 resd 1          ; Réserve 4 octets pour stocker un entier de 32 bits
    buffer resb 10       ; Réserve 10 octets pour lire l'entrée de l'utilisateur

section .data
    NL1 db 'ENTER NO: ', 0

section .text
    global _start

_start:
    ; Print "ENTER NO: "
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: stdout
    mov rsi, NL1         ; address of string
    mov rdx, 10          ; length of string
    syscall

    ; Read input
    mov rax, 0           ; syscall: read
    mov rdi, 0           ; file descriptor: stdin
    mov rsi, buffer      ; address to store input
    mov rdx, 10          ; number of bytes to read
    syscall

    ; Convert ASCII to integer
    xor rbx, rbx         ; Clear rbx to use as the result
    xor rcx, rcx         ; Clear rcx to use as the loop index
    mov rdi, buffer      ; rdi points to the start of buffer

convert_loop:
    movzx rax, byte [rdi + rcx]
    cmp rax, 10          ; Check for newline character (ASCII 10)
    je end_convert
    sub rax, '0'         ; Convert ASCII to integer
    imul rbx, rbx, 10    ; Multiply result by 10
    add rbx, rax         ; Add the new digit
    inc rcx
    jmp convert_loop

end_convert:
    mov [VAL1], rbx

    ; Check for primality
    mov rax, [VAL1]
    cmp rax, 2
    jl not_prime
    mov rcx, 2

check_prime:
    cmp rcx, rax
    jge prime            ; if rcx >= rax, number is prime
    mov rdx, 0
    mov rbx, rax         ; Backup rax
    div rcx
    cmp rdx, 0
    mov rax, rbx         ; Restore rax
    je not_prime         ; if remainder is 0, number is not prime
    inc rcx
    jmp check_prime

not_prime:
    mov rax, 60          ; syscall: exit
    mov rdi, 1           ; exit code 1 (not prime)
    syscall

prime:
    mov rax, 60          ; syscall: exit
    xor rdi, rdi         ; exit code 0 (prime)
    syscall


