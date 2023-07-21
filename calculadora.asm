; nasm -f elf64 calculadora.asm ; gcc -m64 -no-pie calculadora.o -o calculadora.x

section .data
    solok : db "%lf %c %lf = %lf", 10, 0
    solnotok : db "%lf %c %lf = funcionalidade não disponível", 10, 0
    prinleitura : db "equação: ", 0
    scanctl : db "%f %c %f", 0
    file : db "saida.txt", 0
    openmode : db "a+"
    one : dd 1.0

section .bss
    op : resb 1
    op1 : resd 1
    op2 : resd 1
    assfile : resd 1

section .text
    extern printf
    extern scanf
    extern fprintf
    extern fopen
    extern fclose
    global main


main:
    push rbp
    mov rbp, rsp

    mov rdi, file
    mov rsi, openmode
    call fopen

    mov [assfile], rax

    mov rdi, prinleitura
    call printf

    ;chama a função scanf
    xor rax, rax
    mov rdi, scanctl
    lea rsi, [op1]
    lea rdx, [op]
    lea rcx, [op2]
    call scanf

    ;passa os operandos para os registradores de parametros
    movss xmm0, dword [op1]
    movss xmm1, dword [op2]
    movss xmm3, dword [op1]
    movss xmm4, dword [op2]

    ;comparador para escolher qual instrução usar
    ;move o char para r8b (por causa da compatibilidade do tamanho)
    mov r8b, [op]
    
    cmp r8b, 'a'
    je callsoma
    
    cmp r8b, 's' 
    je callmenos 

    cmp r8b, 'm'
    je callmult 

    cmp r8b, 'd'
    je calldivide 

    cmp r8b, 'e'
    je callexp

end:
    mov rdi, qword[assfile]
    call fclose

    mov rsp, rbp   
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall


callsoma:
    mov r8b, "+"
    call adicao
    jmp solucaook

callmenos:
    mov r8b, "-"
    call subtracao
    jmp solucaook

callmult:
    mov r8b, "*"
    call multiplicacao
    jmp solucaook

calldivide:
    mov r8b, "/"
    call divisao
    jmp solucaook

callexp:
    mov r8b, "^"
    call exponenciacao
    jmp solucaook

adicao:
    push rbp
    mov rbp, rsp

    addss xmm0, xmm1  

    mov rsp, rbp
    pop rbp

    ret

subtracao:
    push rbp
    mov rbp, rsp

    subss xmm0, xmm1  

    mov rsp, rbp
    pop rbp

    ret

multiplicacao:
    push rbp
    mov rbp, rsp

    mulss xmm0, xmm1  

    mov rsp, rbp
    pop rbp

    ret

divisao:
    push rbp
    mov rbp, rsp

    divss xmm0, xmm1

    mov rsp, rbp
    pop rbp

    ret

exponenciacao:
    push rbp
    mov rbp, rsp

    movss xmm2, xmm0
    cvtss2si r9, xmm1

    mov r10, 1
    cmp r10, r9
    je igual
    jg zero

    for:
        mulss xmm0, xmm2
        inc r10
        cmp r10, r9
        jl for

        mov rsp, rbp
        pop rbp
        ret

    igual:
        mov rsp, rbp
        pop rbp
        ret

    zero:
        movss xmm0, dword[one]

        mov rsp, rbp
        pop rbp
        ret
l1:
    


solucaook:
    call escrevesolucaook
    jmp end

solucaonotok:

escrevesolucaook:
    push rbp
    mov rbp, rsp

    mov rax, 3
    mov rdi, qword[assfile]
    mov rsi, solok
    cvtss2sd xmm2, xmm0
    cvtss2sd xmm1, [op2]
    mov rdx, r8
    cvtss2sd xmm0, [op1]
    call fprintf

    mov rsp, rbp
    pop rbp
    ret

