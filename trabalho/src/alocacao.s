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
	ponteiro:		.string "%p"
	inteiro:		.string "%ld"
	quebraLinha:	.string "\n"

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
	movq %rdi, %r12	
 
	movq inicioHeap, %rax
	movq %rax, topoHeap

	inicioEncontrarEspacoHeap:

# 	# Quando entrar no while o percorreHeap começa com o inicioHeap 
# 	# Sem entrar now hile o percorreHeap começa no topóHeap

	fimEncontrarEspacoHeap:
		movq topoHeap, %rax			# percorreHeap = topoHeap
		movq %rax, percorreHeap
	
		movq tamHeader, %rbx
	
		addq %rbx, topoHeap 		# Os dois addq aumenta o espaço do cabecalho
		addq %rbx, topoHeap			
		addq %r12, topoHeap			# Aqui aumenta o espaço da área de dados. topoHeap += numBytes
	
		movq topoHeap, %rdi				# brk(topoHeap)
		movq $12, %rax
		syscall
	
		movq percorreHeap, %rax			# faz o alocado *alocado ir para o %rax
		movq alocado, %rcx
		movq %rcx, (%rax) 			# *percorreHeap = alocado/desalocado
	
		movq %rax, percorreHeap
		addq %rbx, %rax
		movq %r12, (%rax)
	
		popq %rbp
		ret
 
imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rax
	movq topoHeap, %rcx

	cmpq %rax, %rcx				# Verifica se existe algo alocado
	je if						# Caso não tenha nada alocado, finaliza o código com o if
	jmp endif 					# Caso tenha algo alocado imprime os resultados

	if:
		movq $str1, %rdi
		call printf

		popq %rbp
		ret

	endif:
		movq inicioHeap, %rax
		movq tamHeader, %rbx
		movq %rax, percorreHeap		# percorreHeap = inicioHeap;

#		# Pular o while por enquanto, e fazer para apenas um caso
		inicioMapaHeap:
			cmpq %rax, %rcx
			jl fimImprimeMapa

			movq percorreHeap, %r13		# alocadoOuDesalocado = *percorreHeap
	
			addq %rbx, percorreHeap
			movq percorreHeap, %r14		# tamDataHeader = *(percorreHeap + tamDataHeader)
			addq %rbx, percorreHeap
	
			movq $0, %r12				# i = 0;
			inicioForCabecalho:
				cmpq $16, %r12
				jge fimForCabecalho
	
				movq $str3, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioForCabecalho
	
			fimForCabecalho:
			movq $quebraLinha, %rdi
			call printf
	
			movq $0, %r12
			cmpq $1, (%r13)
			je inicioImprimeAlocado
			jmp inicioImprimeDesalocado
	
			inicioImprimeAlocado:
				cmpq (%r14), %r12
				jge fimImprimes
	
				movq $str4, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioImprimeAlocado
	
			inicioImprimeDesalocado:
				cmpq (%r14), %r12
				jge fimImprimes
	
				movq $str5, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioImprimeAlocado
	
			fimImprimes:
			movq $quebraLinha, %rdi
			call printf
	
			movq (%r14), %rax
			addq %rax, percorreHeap
	
			movq $ponteiro, %rdi
			movq inicioHeap, %rsi
			call printf
	
			movq $quebraLinha, %rdi
			call printf
		
			movq $ponteiro, %rdi
			movq percorreHeap, %rsi
			call printf
	
			movq $quebraLinha, %rdi
			call printf
	
			movq $ponteiro, %rdi
			movq topoHeap, %rsi
			call printf
	
			movq $quebraLinha, %rdi
			call printf

			popq %rbp
			ret
			jmp inicioMapaHeap
		
		fimImprimeMapa:
		popq %rbp
		ret