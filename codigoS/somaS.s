.section .data
    A: .quad 0
    B: .quad 0
.section .text
.globl _start
_start:
    movq $6, A
    movq $8, B
    movq A, %rax
    movq B, %rbx
    addq %rax, %rbx     # %rbx = %rbx + %rax
    movq $60, %rax
    movq %rbx, %rdi
    syscall
