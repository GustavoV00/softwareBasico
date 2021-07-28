.section .data
	inicioHeap: 	.quad 0		# .quad indica o long int(8 bytes)
	topoHeap:		.quad 0	
	topoBrk:  		.quad 0     # Aponta para o topo do 4k
	percorreHeap: 	.quad 0		# Um ponteiro que percorre a heap, entre o inicioHeap e topoHeap
	auxEndr: 		.quad 0 	# Uma váriavel auxiliar, para fazer o best-fit
	alocado: 		.quad 1 	# flag que indica que o espaço está ocupado (alocado)
	desalocado: 	.quad 0 	# flag que indica que a váriavel o espaço está descoupado (Desalocado)
	tamHeader: 		.quad 8		# Váriavel que indica o tamanho de cada campo do header
	quatroK:        .quad 1000  # Flag que indica o 4k
    str0:           .string "Está começando a heap!\n"
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

    movq $str0, %rdi    # Printf da sorte. Sem ele o código n funciona. 
    call printf         # Caso apague, o código entra em loop infinito

	movq $0, %rdi 		# Indica o valor que vai ser passado como parametro na syscall
	movq $12, %rax		# Indica qual vai ser a syscall que vai ser chamada
	syscall 			# O endereço de retorno do sbrk(0) fica no %rax

	movq %rax, inicioHeap # Faz o inicioHeap e topoHeap receber o end. inicial da heap
	movq %rax, topoHeap
    movq %rax, topoBrk

#    addq $1000, topoBrk

	movq topoBrk, %rdi # Inicia o alocador na heap
	movq $12, %rax   	 # Com com esoaço igual a zero			
	syscall

	popq %rbp 			# Desaloca o %rbp
	ret					# faz o retorno para o end. Anterior

# Foi implementado para apenas um caso por enquanto
alocaMem:
 	pushq %rbp                          # Abre espaço na pilha
 	movq %rsp, %rbp                     # Aponta o %rbp e %rsp para a mesma posição
	movq %rdi, %r12	                    # Aloca o numBytes no %r12
	movq $0, auxEndr                    # Uma variavel global. Serve para quando existir algum bloco livre, indica que 

	movq inicioHeap, %rbx
	movq %rbx, percorreHeap # Arruma as posições do inicio e topoHeap
	movq topoHeap, %rdx
	iniciaWhileProcuraEspaco:
		cmpq %rdx, %rbx                 # Faz a comporação inicioHeap < topoHeap e entra no while
		jl procuraOuAlocaEspaco         # Caso não esteja no topo
		jmp verificaSeAlocaNoTopo       # Caso esteja no topo
		procuraOuAlocaEspaco:
			movq %rbx, %rdx
			addq tamHeader, %rdx
			movq (%rdx), %rcx			# %rcx = *(percorreHeap+tamHeader)
	
			cmpq $0, (%rbx)             # Caso exista algum bloco desalocado
			je ifDesalocado             # (%rbx) seria o valor 0 ou 1 de alocado ou desalocado
			jmp fimDesalocados

			ifDesalocado:				
			cmpq %r12, %rcx   		#	Verifica se o bloco que vai ser alocado, cabe em algum 
			jge cabeNoBloco 		# bloco que está desalocado
			jmp fimDesalocados

				cabeNoBloco:
					movq auxEndr, %r14			# %r14 contém o auxEndr
					cmpq $0, %r14 				# Caso caiba, ele altera o auxEndr para o endr do bloco livre
					je primeiroSlotLivre
					jmp comparaDesalocadoAtualComAnterior

					comparaDesalocadoAtualComAnterior:
						movq 8(%rbx), %rcx
						cmpq %rcx, 8(%r14) 							# Caso tenha mais de um bloco livre, o numBytes vai procurar o menor
						jge comparaSeOSlotAtualMaiorQueNumBytes 	# Caso o numBytes caiba
						jmp fimDesalocados

						comparaSeOSlotAtualMaiorQueNumBytes: 		# Caso seja maior que num bytes 
							cmpq %r12, 8(%r14)						# Atualiza o auxEndr com o novo menor possivel para numBytes
							jge atualizaAuxEndr
							jmp fimDesalocados

							atualizaAuxEndr:
								movq %rbx, auxEndr
								jmp fimDesalocados

			primeiroSlotLivre:
				movq %rbx, auxEndr
				movq $1, %r15
				jmp fimDesalocados
	
		fimDesalocados: 			# Caso alguma condição acima não de certo 
		movq percorreHeap, %rbx
		addq tamHeader, %rbx
		movq (%rbx), %rcx
		addq tamHeader, %rbx
		addq %rcx, %rbx
		movq %rbx, percorreHeap
		movq topoHeap, %rdx
		jmp iniciaWhileProcuraEspaco

	verificaSeAlocaNoTopo: 				# Aloca para a primeira alocação
	cmpq $1, %r15
	je retornaAuxEndr
	jmp alocaTopo
	retornaAuxEndr: 					# Caso o auxEndr exista, retorna ele 

		movq auxEndr, %rbx
		movq %rbx, percorreHeap
		movq $1, (%rbx)

		movq percorreHeap, %rax

		popq %rbp
		ret

	alocaTopo: 							# Caso não exista, atualiza o topo

	movq topoHeap, %rax			# percorreHeap = topoHeap
	movq %rax, percorreHeap

	movq tamHeader, %rbx

	addq %rbx, topoHeap 		# Os dois addq aumenta o espaço do cabecalho
	addq %rbx, topoHeap			
	addq %r12, topoHeap			# Aqui aumenta o espaço da área de dados. topoHeap += numBytes

    movq topoHeap, %r15
    movq topoBrk, %r14

	calculaSeValorAlocaoCabe:
    cmpq %r14, %r15
	jg aumentaQuatroK
	jmp alocaMaisMemoria
	
	aumentaQuatroK: 			# Faz um loop que vai somando o 4k até ter memória o sufuciente para pelo menos a próxima alocação
	movq $str2, %rdi
	call printf
    
    addq quatroK, %r14
    movq %r14, topoBrk
    
    jmp calculaSeValorAlocaoCabe
    alocaMaisMemoria:
	movq topoBrk, %rdi
	movq $12, %rax
	syscall

	jmp fimAumentaQuatroK

    fimAumentaQuatroK:
	movq percorreHeap, %rax			# faz o alocado *alocado ir para o %rax
	movq alocado, %rcx
	movq %rcx, (%rax) 			# *percorreHeap = alocado/desalocado

	movq percorreHeap, %rax
	addq %rbx, %rax
	movq %r12, (%rax)

	movq percorreHeap, %rax

	popq %rbp
	ret

liberaMem:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, %r12				# Bloco que vai ser desalocado. r12 = bloco

	movq %r12, percorreHeap
	movq percorreHeap, %rax
	movq $0, %rcx
	movq %rcx, (%rax) 			# Desaloca esse bloco *bloco = desalocado

	movq inicioHeap, %rax
	movq %rax, percorreHeap

	popq %rbp
	ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rdi 		# Aponta o alocador para o inicio da heap e faz syscall brk para desalocar
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
	jmp endif 					# Caso tenha algo alocado vai para o endif imprimir as coisas

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
			movq percorreHeap, %r14		# tamDataHeader = (percorreHeap + tamDataHeader)

            movq $inteiro, %rdi
            movq (%r14), %rsi
            call printf

			addq %rbx, percorreHeap
	
			movq $0, %r12				# i = 0;
			inicioForCabecalho: 		# Imprime os #
				cmpq $16, %r12
				jge fimForCabecalho
	
				movq $str3, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioForCabecalho
	
			fimForCabecalho:
			movq $0, %r12
			cmpq $1, (%r13)
			je inicioImprimeAlocado
			jmp inicioImprimeDesalocado
	
			inicioImprimeAlocado: 		# Imprime os +
				cmpq (%r14), %r12
				jge fimImprimes
	
				movq $str4, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioImprimeAlocado
	
			inicioImprimeDesalocado: 		# imprime os -
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
	
			jmp inicioMapaHeap
		
		fimImprimeMapa:
		popq %rbp
		ret
