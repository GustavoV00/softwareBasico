#include <stdio.h>
#include <unistd.h>


long int* inicioHeap;
long int* topoHeap;
long int* percorreHeap;
long int alocado = 1;
long int desalocado = 0;
long int tamHeader = sizeof(long int);

void iniciaAlocador();
void finalizaAlocador();
void* alocaMem(long int numBytes);
void liberaMem(void* bloco);
void imprimeValoresDaHeap();

int main(int argc, char ** argv){
	void *a, *b, *c, *d, *e;
	iniciaAlocador();

	a = alocaMem(25);
	b = alocaMem(50);
	c = alocaMem(75);
	d = alocaMem(100);
	e = alocaMem(125);
	
	liberaMem(e);
	liberaMem(b);
	liberaMem(c);

	b = alocaMem(50);
	c = alocaMem(70);

	printf("%p | %p | %p | %p | %p \n", a, b, c, d, e);

	imprimeValoresDaHeap();
	return (0);
}

void iniciaAlocador(){
	inicioHeap = (long int *) sbrk(0); // sbrk(0) retorna o endereço do topo da heap
	topoHeap = inicioHeap;
	brk((void *) topoHeap);

	return;
}

void* alocaMem(long int numBytes) {
	percorreHeap = inicioHeap;
	// Loop verifica se existe algum espaço livre na heap
	// Caso não exista, aloca no topo da heap
	while(percorreHeap != topoHeap) {
		long int tamDataHeader  = *(percorreHeap+tamHeader);
		if(*percorreHeap == desalocado && *(percorreHeap+tamHeader) <= numBytes) {
			*percorreHeap = alocado;
			*(percorreHeap+tamHeader) = numBytes;
			return (void *) topoHeap;
		}
		percorreHeap += (tamHeader * 2) + tamDataHeader;
	}
	percorreHeap = topoHeap;
	topoHeap += (tamHeader*2) + numBytes;
	brk((void *) topoHeap);

	*percorreHeap = alocado;
	*(percorreHeap+tamHeader) = numBytes;

	return (void *) percorreHeap;
}

// Estou considerando o bloco, o endereço que aponta 
// para o inicio do cabecalho
// Nesse caso seria: [ 0/1 | tamHeader | DADOS ]
// Na função eu passo o bloco para desalocado, 1 -> 0
void liberaMem(void* bloco) {
    printf("Desalocando dados: %p\n", bloco);
    percorreHeap = (long int *) bloco;
    *percorreHeap = desalocado;
    percorreHeap = inicioHeap;

	return;
}

void finalizaAlocador() {
	brk((void *) inicioHeap);
    return;
}

void  imprimeValoresDaHeap() {
	if(topoHeap == inicioHeap) {
		printf("Não existe nada alocado\n");
		return;
    }

	percorreHeap = inicioHeap;
	while(percorreHeap != topoHeap) {
		long int alocadoOuDesalocado = *percorreHeap;
		long int tamDataHeader  = *(percorreHeap+tamHeader);
		printf("%ld e %ld\n", tamDataHeader, alocadoOuDesalocado);

		printf("0-%p e %p\n", percorreHeap, percorreHeap);
		percorreHeap += tamHeader * 2;
		printf("1-%p e %p\n", percorreHeap, percorreHeap);

		if(alocadoOuDesalocado == 1) 
			for(long int i = 0; i < tamDataHeader; i++) printf("*");
		else
			for(long int i = 0; i < tamDataHeader; i++) printf("-");

		printf("\n");

		percorreHeap += tamDataHeader;
		printf("Verifica se chegou no topo: %p e %p\n", percorreHeap, topoHeap);
	}
}



















