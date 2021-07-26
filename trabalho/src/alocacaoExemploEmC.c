#include <stdio.h>
#include <unistd.h>
#include "./../includes/alocacao.h"


long int* inicioHeap;
long int* topoHeap;
long int* topoBrk;
long int* percorreHeap;
long int alocado = 1;
long int desalocado = 0;
long int tamHeader = sizeof(long int);
long int quatroK = 4096;
long int total = 0;

int main(int argc, char ** argv){
	void *a, *b, *c, *d, *e, *f;
	iniciaAlocador();

	a = alocaMem(400);
	imprimeMapa();
	printf("\n");

	b = alocaMem(300);
	imprimeMapa();
	printf("\n");

	c = alocaMem(100);
	imprimeMapa();
	printf("\n");

	d = alocaMem(200);
	imprimeMapa();
	printf("\n");

	liberaMem(a);
	imprimeMapa();
	printf("\n");

	e = alocaMem(500);
	imprimeMapa();
	printf("\n");

	liberaMem(d);
	imprimeMapa();
	printf("\n");

	liberaMem(e);
	imprimeMapa();
	printf("\n");

	e = alocaMem(20000);
	imprimeMapa();
	printf("\n");

	b = alocaMem(20);
	printf("\n");

	imprimeMapa();
	liberaMem(c);
	printf("\n");

	imprimeMapa();
	liberaMem(e); 
	printf("\n");
	imprimeMapa();

	finalizaAlocador();
	return (0);
}
void iniciaAlocador(){
	inicioHeap = (long int *) sbrk(0); // sbrk(0) retorna o endereço do topo da heap
    topoBrk = inicioHeap;
    topoHeap = inicioHeap;

    topoBrk += quatroK;
	brk((void *) topoBrk);

	return;
}

void* alocaMem(long int numBytes) {
	percorreHeap = inicioHeap;
	int flag = 0;
	long int* auxEndr = 0;
	while(quatroK < total){
        printf("Entgrei aqui \n");
        quatroK += 4096;
        topoBrk += quatroK;
        brk((void *) topoBrk);

    }
	// Loop verifica se existe algum espaço livre na heap
	// Caso não exista, aloca no topo da heap
	while(percorreHeap < topoHeap) {
		long int tamDataHeader  = *(percorreHeap+tamHeader);
		if(*percorreHeap == desalocado && *(percorreHeap+tamHeader) >= numBytes && auxEndr != 0) {
			if(*(auxEndr+tamHeader) >= *(percorreHeap+tamHeader) && *(auxEndr+tamHeader) >= numBytes)
				auxEndr = percorreHeap;
				
		} else if(*percorreHeap == desalocado && *(percorreHeap+tamHeader) >= numBytes && auxEndr == 0) {
			auxEndr = percorreHeap;
			flag = 1;
		}
		percorreHeap += (tamHeader * 2) + tamDataHeader;
	}

	if(auxEndr != 0) {
		percorreHeap = auxEndr;
		*percorreHeap = alocado;
		return (void *) percorreHeap;
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

void imprimeMapa() {
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

		for(long int i = 0; i < tamHeader * 2; i++) printf("#");

		if(alocadoOuDesalocado == 1) 
			for(long int i = 0; i < tamDataHeader; i++) printf("+");
		else
			for(long int i = 0; i < tamDataHeader; i++) printf("-");
		printf("\n");

		percorreHeap += tamDataHeader;
		printf("Verifica se chegou no topo: %p e %p\n", percorreHeap, topoHeap);
	}
}
