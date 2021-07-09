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
int liberaMem(void* bloco);
void imprimeValoresDaHeap();

int main(int argc, char ** argv){
	iniciaAlocador();
	topoHeap = alocaMem(10);
	topoHeap = alocaMem(30);
	topoHeap = alocaMem(50);
	topoHeap = alocaMem(60);
	topoHeap = alocaMem(1000);

	imprimeValoresDaHeap();


	return (0);
}

void iniciaAlocador(){
	inicioHeap = (long int *) sbrk(0); // sbrk(0) retorna o endereço do topo da heap
	topoHeap = inicioHeap;
	brk((void *) topoHeap);

	return;
}

void finalizaAlocador() {
	brk(inicioHeap);
	return;
}

void* alocaMem(long int numBytes) {
	percorreHeap = topoHeap;
	topoHeap += tamHeader*2;
	brk((void *) topoHeap);

	*percorreHeap = alocado;
	percorreHeap += tamHeader;
	*percorreHeap = numBytes;

	topoHeap += numBytes;
	brk((void *) topoHeap);

	return (void *) topoHeap;
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
	printf("cheguei aqui porra\n");
}



















