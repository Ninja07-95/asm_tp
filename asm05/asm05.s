section .data
    userMessage db 'Result: ', 0xA
    userMessageLen equ $ - userMessage
    resultBuffer times 20 db 0

section .text
    global _start

_start:
    mov rdi, [rsp + 16]
    mov rsi, [rsp + 24]


    call convertToInt
    mov r12, rax
    mov rdi, rsi

    call convertToInt
    add rax, r12

    mov rdi, rax
    mov rsi, resultBuffer
    call intToString

    mov rdi, 1
    mov rax, 1
    mov rsi, userMessage
    mov rdx, userMessageLen
    syscall

    mov rdi, 1
    mov rax, 1
    mov rsi, resultBuffer
    mov rdx, 20
    syscall

    mov eax, 60
    xor edi, edi
    syscall

convertToInt:
    xor rbx, rbx
    xor rcx, rcx

.nextChar:
    movzx rax, byte [rdi + rcx]
    test  rax, rax
    jz    .done
    sub   rax, '0'
    imul  rbx, rbx, 10
    add   rbx, rax
    inc   rcx
    jmp   .nextChar

.done:
    mov rax, rbx
    ret

intToString:
    mov     rcx, 10
    mov     rdi, rsi
    add     rdi, 20
    mov     byte [rdi], 0

.nextDigit:
    dec     rdi
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    mov     [rdi], dl
    test    rax, rax
    jnz     .nextDigit
    ret
