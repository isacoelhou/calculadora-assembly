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
    erro: db "funcionalidade não disponível", 10, 0
    vart: db "%f %c %f", 0
    modo: db "a", 0
    nomearq: db "respostas.txt", 0
    zerof: dd 0.0
    umf: dd 1.0
    doisf: dd 2.0
    strcontrol: db "%lf", 10, 0
    

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
    comiss xmm1, xmm5
    je erro

    divss xmm0, xmm1 
    ret

exp: 
    movss xmm0, dword[op1]   
    movss xmm1, dword[op2] 
    movss xmm2, dword[op1]
    movss xmm5, dword[zerof]
    movss xmm6, dword[umf]
    movss xmm7, dword[doisf]

    comiss xmm1, xmm5
    jb errou
        
    ; if op2 == 0 return 1 
    ; se op2 = 0 ret 1 
    comiss xmm1, xmm5
    je zero


    comiss xmm1, xmm6
    je igual


    conta:
        mulss xmm0, xmm2
        comiss xmm1, xmm7
        jb conta
        
    e:
        ret
    
    igual:
        movss xmm0, xmm1
        ret
    
    zero:
        movss xmm0, xmm5
        ret
    um: 
        movss xmm0, xmm6
        ret
    



;arquivo:
    ;abre o arquivo
 ;   lea rsi, [modo]
  ;  lea rdi, [nomearq]
   ; call fopen

    ;xor rax, rax
    ;mov rdi, ola
    ;mov esi, 1
    ;call fprintf    

    ;fecha
    ;lea rdi, [nomearq]
    ;call fclose
    ;jmp fim


printtela:
    cvtss2sd xmm0, xmm0
    mov rax, 1
    mov rdi, strcontrol
    call printf
    jmp fim

errou:
    xor rax, rax
    mov rdi, erro
    mov rsi, 1
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

l1:
    ;move o char para r8b (por causa da compatibilidade do tamanho)
    mov r8b, [op]
    ;compara com as opções
    cmp r8b, 's' 
    je callmenos 


    cmp r8b, 'a'
    je callsoma


    cmp r8b, 'm'
    je callmult 


    cmp r8b, 'd'
    je calldivide 

    cmp r8b, 'e'
    je callexp 
 


fim:
    mov rsp, rbp    
    pop rbp

    mov rax, 60  
    xor edi, edi
    syscall


calldivide:
    call divide
    jmp printtela

callexp:
    call exp
    jmp printtela

callmenos:
    call menos
    jmp printtela

callmult:
    call mult
    jmp printtela

callsoma:
    call soma
    jmp printtela