.section .data
	inicioHeap: 	.quad 0		# .quad indica o long int(8 bytes)
	topoHeap:		.quad 0	
	percorreHeap: 	.quad 0		# Um ponteiro que percorre a heap, entre o inicioHeap e topoHeap
	alocado: 		.quad 1 	# flag que indica que o espaço está ocupado (alocado)
	desalocado: 	.quad 0 	# flag que indica que a váriavel o espaço está descoupado (Desalocado)
	tamHeader: 		.quad 8		# Váriavel que indica o tamanho de cada campo do header

.section .text
.globl iniciaAlocador
.globl finalizaAlocador
.globl alocaMem
.globl liberaMem
.globl imprimeMapa

iniciaAlocador:
	pushq %rbp			# Abre espaço na pilha
	movq %rsp, %rbp 	# Faz o rsp apontar para o rbp

	movq $0, %rdi 		# Indica o valor que vai ser passado como parametro na syscall
	movq 12, %rax		# Indica qual vai ser a syscall que vai ser chamada
	syscall 			# sbrk(0) ?

	popq %rbp 			# Desaloca o %rbp
	ret					# faz o retorno para o end. Anterior


# Foi implementado para apenas um caso por enquanto
alocaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, percorreHeap
	# Quando entrar no while o percoHeap começa com o inicioHeap 
	# Sem entrar now hile o percoHeap começa no topóHeap
	movq topoHeap, percorreHeap
	addq tamHeader, topoHeap
	addq tamHeader, topoHeap
	addq 16(%rbp), topoHeap

	movq $0, %rdi
	movq $12, %rax
	syscall

	popq %rbp
	ret

imprimeMapa:
	# Fazer o if para ver se exite alguma coisa alocado
	pushq %rbp
	movq $rsp, %rbp
	subq $16, %rsp

	movq inicioHeap, percorreHeap
	# Fazer o while para quando tiver de um bloco alocado
	movq (percorreHeap), -8(%rbp)
	addq tamHeader, percorreHeap
	movq (percorreHeap), -16(%rbp)
	addq tamHeader, percorreHeap

	# For para imprimir o cabecalho
	# For para imprimir se algo estiver ocupado
	# For para imprimir se algo estiver descocupado

	addq -16(%rbp), percorreHeap