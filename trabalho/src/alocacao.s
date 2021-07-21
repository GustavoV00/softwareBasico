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
	ponteiro:		.string "%p \n"
	inteiro:		.string "%ld \n"
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
	movq tamHeader, %rbx
 
	movq inicioHeap, %rax
	movq %rax, percorreHeap

	inicioEncontrarEspacoHeap:
		movq percorreHeap, %rax
		movq topoHeap, %rcx
		cmpq %rcx, %rax
		jl fimDesalocado
		jmp fimEncontrarEspacoHeap

		inicioDesalocado:
			cmpq %r13, %r12
			jle cabeNoEspaco
			jmp fimDesalocado
			cabeNoEspaco:
				movq $str2, %rdi
				call printf

				movq percorreHeap, %rax
				movq alocado, %rbx
				movq %rbx, (%rax)
				movq percorreHeap, %rax

				popq %rbp
				ret
		fimDesalocado:
		movq (%rax), %rbx

		addq tamHeader, %rax
		movq (%rax), %r13

		cmpq %rbx, desalocado
		je inicioDesalocado

		movq percorreHeap, %rax
		addq tamHeader, %rax
		movq (%rax), %r15
		addq tamHeader, %rax
		addq %r15, %rax
		movq %rax, percorreHeap
		jmp inicioEncontrarEspacoHeap

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
	
	#	movq $inteiro, %rdi
	#	movq (%rax), %rsi
	#	call printf

		movq percorreHeap, %rax

		popq %rbp
		ret
 

liberaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %r12				# Bloco que vai ser desalocado. r12 = bloco

	movq $ponteiro, %rdi
	movq %r12, %rsi
	call printf

	movq %r12, percorreHeap
	movq percorreHeap, %rax
	movq $0, %rcx
	movq %rcx, (%rax)

	movq inicioHeap, %rax
	movq %rax, percorreHeap

	popq %rbp
	ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rdi
	movq $12, %rax
	syscall

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
			movq percorreHeap, %rax
			movq topoHeap, %rcx
			cmpq %rax, %rcx
			jle fimImprimeMapa

			movq percorreHeap, %r13		# alocadoOuDesalocado = *percorreHeap

			movq $inteiro, %rdi
			movq (%r13), %rsi
			call printf
	
			addq %rbx, percorreHeap
			movq percorreHeap, %r14		# tamDataHeader = *(percorreHeap + tamDataHeader)

			movq $inteiro, %rdi
			movq (%r14), %rsi
			call printf

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
				jmp inicioImprimeDesalocado
	
			fimImprimes:
			movq $quebraLinha, %rdi
			call printf
	
			movq (%r14), %rax
			addq %rax, percorreHeap
	
#			movq $ponteiro, %rdi
#			movq inicioHeap, %rsi
#			call printf
#	
#			movq $ponteiro, %rdi
#			movq percorreHeap, %rsi
#			call printf
#	
#			movq $ponteiro, %rdi
#			movq topoHeap, %rsi
#			call printf

			jmp inicioMapaHeap
		
		fimImprimeMapa:
		popq %rbp
		ret