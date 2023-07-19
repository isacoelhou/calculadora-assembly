extern printf
extern scanf
extern fopen
extern fclose
; nasm -f elf64 calc.asm ; gcc -m64 -no-pie calc.o -o calc.x

; multiplicalção e divisão por negativo fdiv, fmul?
; verificar call de função e retorno
; escrita em arquivo

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
    cmp xmm1, 0
    je erro

    divss xmm0, xmm1 
    ret

exp: 
    movss xmm0, dword[op1]   
    movss xmm1, dword[op2] 
    movss xmm2, dword[op1]

    cmp xmm1, 0
    jb erro
        
    ; if op2 == 0 return 1 
    ; se op2 = 0 ret 1 
    cmp xmm1, 0
        ret 1
    
    cmp xmm1, 1
        ret xmm0


    conta:
        mov r12, 2 
        mulss xmm0, xmm2
        cmp xmm1, r12
        jb conta
        
    e:
        ret


arquivo:
    ;abre o arquivo
    lea rsi, [modo]
    lea rdi, [nomearq]
    call fopen

  
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
    je menos 
    jmp arquivo

    cmp r8b, 'a'
    je soma
    jmp arquivo

    cmp r8b, 'm'
    je mult 
    jmp arquivo

    cmp r8b, 'd'
    je divide 
    jmp arquivo

    cmp r8b, 'e'
    je exp 
    jmp arquivo 


fim:
    mov rax, 60  
    xor edi, edi
    syscall
