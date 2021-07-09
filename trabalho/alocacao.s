.section .data
	inicioHeap: 	.quad 0		# .quad indica o long int(8 bytes)
	topoHeap:		.quad 0	
	percorreHeap: 	.quad 0		# Um ponteiro que percorre a heap, entre o inicioHeap e topoHeap
	alocado: 		.quad 1 	# flag que indica que o espaço está ocupado (alocado)
	desalocado: 	.quad 0 	# flag que indica que a váriavel o espaço está descoupado (Desalocado)
	tamHeader: 		.quad 8		# Váriavel que indica o tamanho de cada campo do header

.section .text
.globl _start

iniciaAlocador:
	pushq %rbp			# Abre espaço na pilha
	movq %rsp, %rbp 	# Faz o rsp apontar para o rbp

	movq $0, %rdi 		# Indica o valor que vai ser passado como parametro na syscall
	movq 12, %rax		# Indica qual vai ser a syscall que vai ser chamada
	syscall 			# sbrk(0) ?

	popq %rbp 			# Desaloca o %rbp
	ret					# faz o retorno para o end. Anterior
_start:
	call iniciaAlocador
	movq $13, %rdi
	movq $60, %rax
	syscall