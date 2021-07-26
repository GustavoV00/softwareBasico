### Trabalho de Software Básico
Gustavo Valente Nunes 
GRR: 20182557

Fernando Zanutto Mady Barbosa
GRR: 20182625



### Descrição ###
-> Alocador de memória feito em assembly e utilizando a syscall brk.

### Explicando os Arquivos ###
./src/alocacaoExemploC.c:
    -> Funciona como um pseudoCódigo para escrever o alocador em assembly. Se compilar, está funcionando e os testes estão na main do código. 

./src/alocador.s:
    -> Aqui está o alocador escrito em assembly. 

./src/test.c:
    -> Funcionava como um teste para o código escrito em assembly, após gerar o alocacao.o do alocacao.s foi usado o arquivo test.c para testar se estava funcionando.

./Makefile:
    -> Está a compilação de todo o código. Basta digitar o make ou make all que gera um arquivo test na raiz do diretório.

./includes/alocacao.h:
    -> Está localizado os prototipos das funções que estão sendo utilizadas.


### Estrutura do alocacao.s ###
Váriaveis globais:
    inicioHeap: Está sempre apontando para onde a heap começa.
    topoHeap: Está sempre apontando para o topo da heap.
    percorreHeap: É uma variável que percorre a heap, quando existe uma necessidade.
    auxEndr: Serve como um endereço auxiliar no caso do best-fit.
    alocado: Indica se o bloco está alocado.
    desalocado: Indica que o bloco está desalocado.
    tamHeader: É uma váriavel que indica 8 bytes de tamanho. Basicamente o tamanho de um campo do cabeçalho dos blocos.
    str*: As strings, que são utilizadas para fazer o código.

Diretivas:
    iniciaALocador: Usa a syscall brk para iniciar a heap.
    alocaMem: Faz a alocação de memória. 
    liberaMem: libera algum bloco de memória
    finalizaAlocador: Faz a heap apontar para o inicio novamente. 
    imprimeMapa: Imprime o cabeçalho e os dados da heap.