.section .data
.section .text
.globl _start
_start:
    movq $60, %rax      # %rax := 60  movq copia uma constante para dentro de um registrador
    movq $13, %rdi      # %rdi := 13
    syscall