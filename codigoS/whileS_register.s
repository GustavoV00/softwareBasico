.section .text
.globl _start
_start:
    movq $0, %rax
    movq $0, %rax
while:
    cmpq $10, %rax
    jge fim_while
    addq %rax, %rdi
    addq $1, %rax
    jpm while
fim_while:
    movq $60, %rax
    syscall
