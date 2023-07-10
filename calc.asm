extern printf
extern scanf
extern fopen
extern fclose
; nasm -f elf64 calc.asm ; gcc -m64 -no-pie calc.o -o calc.x

section .data
    ola: db "Equação :", 10, 0
    erro: db "funcionalidade não disponível", 10
    vart: db "%f %c %f", 0
    modo: db "a", 0
    nomearq: db "respostas.txt", 0

section .bss
    arq: resd 1 
    op1: resd 1
    op2: resd 1
    op: resb 2  

section .text
    global main

soma:
    movss xmm0, dword[op1]   ; Carregar op1 em xmm0
    movss xmm1, dword[op2]   ; Carregar op2 em xmm1
    addss xmm0, xmm1  
    ret

menos:
    movss xmm0, dword[op1]   
    movss xmm1, dword[op2]   
    subss xmm0, xmm1 
    ret

mult:
    movss xmm0, dword[op1]   
    movss xmm1, dword[op2]   
    mulss xmm0, xmm1 
k:
    ret

divide:
    movss xmm0, dword[op1]   
    movss xmm1, dword[op2]  
    divss xmm0, xmm1 
y:
    ret

arquivo:
    ;abre o arquivo
    lea rsi, [modo]
    lea rdi, [nomearq]
    call fopen

    mov [arq], eax 

    ;fecha
    lea rdi, [nomearq]
    call fclose
    jmp fim

errou:
    xor rax, rax
    mov rdi, erro
    mov esi, 1
    call printf
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
    call menos 
    jmp fim 


    cmp r8b, 'a'
    call soma
    jmp fim 

    cmp r8b, 'm'
    call mult 
    jmp fim 


    cmp r8b, 'd'
    call divide 
    jmp fim 


    ;cmp r8b, 'e'
    ;call exp 
    ;jmp arquivo 


fim:
    mov rax, 60  
    xor edi, edi
    syscall
