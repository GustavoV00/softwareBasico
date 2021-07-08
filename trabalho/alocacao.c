#include <stdio.h>
#include <unistd.h>


void* inicioHeap;
void* topoHeap;
void* percorreHeap;
long int* alocaCabecalho;
long int alocado = 1;
long int desalocado = 0;
long int tamHeader = sizeof(long int);

void iniciaAlocador();
void finalizaAlocador();
void* alocaMem(long int numBytes);
int liberaMem(void* bloco);
void imprimeValoresDaHeap();

int main(int argc, char ** argv){
	iniciaAlocador();
	topoHeap = alocaMem(10);
	topoHeap = alocaMem(30);
	topoHeap = alocaMem(50);

	imprimeValoresDaHeap();


	return (0);
}

void iniciaAlocador(){
	inicioHeap = sbrk(0); // sbrk(0) retorna o endereço do topo da heap
	topoHeap = inicioHeap;
	brk(topoHeap);

	return;
}

void finalizaAlocador() {
	brk(inicioHeap);
	return;
}

void* alocaMem(long int numBytes) {
	alocaCabecalho = topoHeap;
	topoHeap += tamHeader*2;
	brk(topoHeap);

	*alocaCabecalho = alocado;
	alocaCabecalho += tamHeader;
	*alocaCabecalho = numBytes;

	topoHeap += numBytes;
	brk(topoHeap);

	return topoHeap;
}

void  imprimeValoresDaHeap() {
	if(topoHeap == inicioHeap) {
		printf("Não existe nada alocado\n");
		return;
	}

	percorreHeap = inicioHeap;
	alocaCabecalho = inicioHeap;
	while(percorreHeap != topoHeap) {
		long int alocadoOuDesalocado = *alocaCabecalho;
		long int tamDataHeader  = *(alocaCabecalho+tamHeader);
		printf("%ld e %ld\n", tamDataHeader, alocadoOuDesalocado);

		printf("0-%p e %p\n", percorreHeap, alocaCabecalho);
		percorreHeap += tamHeader * 2;
		alocaCabecalho += tamHeader * 2;
		printf("1-%p e %p\n", percorreHeap, alocaCabecalho);

		if(alocadoOuDesalocado == 1) 
			for(long int i = 0; i < tamDataHeader; i++) printf("*");
		else
			for(long int i = 0; i < tamDataHeader; i++) printf("-");

		printf("\n");

		percorreHeap += tamDataHeader;
		printf("%p e %p\n", percorreHeap, topoHeap);
		alocaCabecalho = percorreHeap;
	}
	printf("cheguei aqui porra\n");
}



















