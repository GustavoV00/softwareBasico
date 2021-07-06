.section .data
    A: .quad 0
    B: .quad 0
.section .text
.globl _start
troca:
    pushq %rbp            # empilha %rbp
    movq %rsp, %rbp       # faz %rbp apontar para novo R.A
    subq $8, %rsp         # long int z (em -8(%rbp))
    movq 16(%rbp), %rax   # %rax = x
    movq (%rax), %rbx     # %rbx = end. aponta por %rax (*x)
    movq %rbx, -8(%rbp)   # z = *x
    movq 24(%rbp), %rax  # 
    movq (%rax), %rbx
    movq 16(%rbp), %rax
    movq % rbx, (%rax)
    movq -8(%rbp), %rbx
    movq 24(%rbp) , %rax
    movq %rbx, (%rax)
    addq $8 , %rsp
    popq %rbp
    ret
_start:
    movq $1, A
    movq $2, B
    pushq $B              # Empilha endereco de B
    pushq $A              # Empilha endereco de A
    call troca
    addq $16, %rsp        # Libera espaco dos parametros
    movq $0, %rdi
    movq $60, %rax
    syscall
