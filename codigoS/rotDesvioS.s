

.section .text
.globl _start
_start:
    movq $0, %rax   # %rax = 0 -> Inicio Loop
    movq $10, %rbx   # %rbx = 10 -> Fim Loop
loop:
    cmpq %rbx, %rax # Se rbx e rax forem iguais, faz o jump para o fim_loop
    jg fim_loop     # Jump to label
    add $1, %rax    # Addiciona 1 to rax; %rax += 1;
    jmp loop        # Jump to loop novamente, e repete o código
fim_loop:
    movq $60, %rax  # %rax = 60;
    movq %rax, %rdi # %rdi = %rax;
    syscall         # Syscall
