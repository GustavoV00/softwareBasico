.section .data
.section .text
.globl _start
fat :
    pushq % rbp                 # empilha %rbp
    movq % rsp , % rbp          # faz %rbp apontar para novo R.A
    subq $8 , % rsp             # long int r (em -8(rbp))
    movq 24(% rbp ) , % rax     # long int r ( em -8(% rbp ))
    movq $1 , % rbx 
    cmpq % rbx , % rax
    jg else
    movq 16(% rbp ) , % rax
    movq $1 , (% rax )
    jmp fim_if
    else :
    movq 24(% rbp ) , % rax
    subq $1 , % rax
    pushq % rax
    pushq 16(% rbp )
    call fat
    addq $16 , % rsp
    movq 16(% rbp ) , % rax
    movq (% rax ) , % rax
    movq 24(% rbp ) , % rbx
    imul % rbx , % rax
    movq % rax , -8(% rbp )
    movq -8(% rbp ) , % rax
    movq 16(% rbp ) , % rbx
    movq % rax , (% rbx )
    fim_if :
    addq $8 , % rsp
    popq % rbp
    ret
_start :
    pushq % rbp
    movq % rsp , % rbp
    subq $8 , % rsp
    pushq $3
    movq % rbp , % rax
    subq $8 , % rax
    pushq % rax
    call fat
    addq $16 , % rsp
    movq -8(% rbp ) , % rdi
    movq $60 , % rax
    syscall
