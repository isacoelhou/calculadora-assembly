extern printf
extern scanf
extern fopen
extern fclose

section .data
    ola: db "Equação :", 10, 0
    erro: db "funcionalidade não disponível", 10
    vart: db "%f %c %f", 0
    modo: "a", 0
    nomearq: db "respostas.txt", 0

section .bss
    arq: resd 1 
    op1: resd 1
    op2: resd 1
    op: resb 2  

section .text
    global main

soma:

    jmp arquivo

menos:

    jmp arquivo

mult:

    jmp arquivo

divide:

    jmp arquivo

exp:

    jmp arquivo


arquivo:
    ;abre o arquivo
    lea rsi, [modo]
    lea rdi, [nome]
    call fopen

    mov [arq], eax 

    ;fecha
    lea rdi, [nome]
    call fclose

    jmp fim

main:
    push rbp
    mov rbp, rsp

    ; Equação :
    xor rax, rax
    mov rdi, ola
    mov esi, 1
    call printf

    ; Le a entrada
    xor rax, rax
    mov rdi, vart
    lea rsi, [op1]
    lea rdx, [op]
    lea rcx, [op2]
    call scanf

    ;move o char para r8b (por causa da compatibilidade do tamanho)
    mov r8b, [op]

    ;compara com as opções
    cmp r8b, 's'
    je menos

    cmp r8b, 'a'
    je soma

    cmp r8b, 'm'
    je mult

    cmp r8b, 'd'
    je divide

    cmp r8b, 'e'
    je exp

fim:
    mov rax, 60  
    xor edi, edi
    syscall
