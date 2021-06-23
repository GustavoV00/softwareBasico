.section .data
    I: .quad 0
    A: .quad 0
.section .text
.globl _start
_start:
    movq $0, I
    movq $0, A
    movq I, %rax
while:
    cmpq $10, %rax      # %rax == 10
    jge fim_while
    movq A, %rdi
    addq %rax, %rdi
    movq %rdi, A
    addq $1, %rax
    movq %rax, I
    jmp while
fim_while:
    mvoq $60, %rax
    syscall
