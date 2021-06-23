.section .data
    B: .quad 0
    A: .quad 0
.section .text
.globl _start
_start:
    movq $4, A
    movq $5, B
    movq A, %rax   # rax = a;
    movq B, %rbx   # rbx = b;
if:
    cmpq %rbx, %rax     # faz %rax - %rbx ou A - B
    jl else
    addq %rbx, %rax
    jmp fim
else:
    subq %rbx, %rax
    jmp fim
fim:
    movq $60, %rax
	movq %rax, %rdi
    syscall
