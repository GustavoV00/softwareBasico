.section .data
	inicioHeap: 	.quad 0		# .quad indica o long int(8 bytes)
	topoHeap:		.quad 0	
	percorreHeap: 	.quad 0		# Um ponteiro que percorre a heap, entre o inicioHeap e topoHeap
	alocado: 		.quad 1 	# flag que indica que o espaço está ocupado (alocado)
	desalocado: 	.quad 0 	# flag que indica que a váriavel o espaço está descoupado (Desalocado)
	tamHeader: 		.quad 8		# Váriavel que indica o tamanho de cada campo do header
	str1: 			.string "A heap está vazia!\n"
	str2:			.string "Estou aqui!\n"
	str3:			.string "#"
	str4:			.string "+"
	str5:			.string "-"

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
	movq $12, %rax		# Indica qual vai ser a syscall que vai ser chamada
	syscall 			# O endereço de retorno do sbrk(0) fica no %rax

	movq %rax, inicioHeap # Faz o inicioHeap e topoHeap receber o end. inicial da heap
	movq %rax, topoHeap

	movq topoHeap, %rdi # Inicia o alocador na heap
	movq $12, %rax   	 # Com com esoaço igual a zero			
	syscall

	popq %rbp 			# Desaloca o %rbp
	ret					# faz o retorno para o end. Anterior


# Foi implementado para apenas um caso por enquanto
alocaMem:
 	pushq %rbp
 	movq %rsp, %rbp
 
#	movq inicioHeap, %rax
#	movq %rax, topoHeap
# 	# Quando entrar no while o percorreHeap começa com o inicioHeap 
# 	# Sem entrar now hile o percorreHeap começa no topóHeap

	movq topoHeap, %rax
# 	movq %rax, percorreHeap
#	movq tamHeader, %rbx
#
# 	addq %rbx, topoHeap 		# Os dois addq aumenta o espaço do cabecalho
# 	addq %rbx, topoHeap			
# 	movq 16(%rbp), %rdx			# %rdx = numBytes	
#	addq %rdx, topoHeap			# Aqui aumenta o espaço da área de dados
# 
# 	movq $0, %rdi				# brk(topoHeap)
# 	movq $12, %rax
# 	syscall
#
#	movq alocado, %rax			# faz o alocado *alocado ir para o %rax
#	movq %rax, (percorreHeap) 	# *percorreHeap = alocado/desalocado
#
#	movq tamHeader, %rbx		# %rax = $tamHeader (8)
#	addq tamHeader, %rbx		# %rax += 8
#	addq %rbx, percorreHeap		# percorreHeap += 8 (No endereço)
#	movq %rdx, (percorreHeap)

 	popq %rbp
 	ret
 
imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rax
	movq topoHeap, %rbx

	cmpq %rax, %rbx				# Verifica se existe algo alocado
	je if						# Caso não tenha nada alocado, finaliza o código com o if
	jmp endif 					# Caso tenha algo alocado imprime os resultados

	if:
		movq $str1, %rdi
		call printf

		popq %rbp
		ret

	endif:
		subq $16, %rsp
		movq $str2, %rdi
		call printf

	#	movq inicioHeap, %rax
	#	movq %rax, percorreHeap

	#	movq %rax, -8(%rbp) 
	#	addq tamHeader, %rax
	#	movq %rax, -16(%rbp)

	#	movq -8(%rbp), %rdi
	#	call printf

	#	movq -16(%rbp), %rdi
	#	call printf

		addq $16, %rsp
		popq %rbp
		ret