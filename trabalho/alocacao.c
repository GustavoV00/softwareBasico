#include <stdio.h>
#include <unistd.h>

void* inicioHeap;
void* topoHeap;

void iniciaAlocador();
void finalizaAlocador();
void* alocaMem(int numBytes);
int liberaMem(void* bloco);
void imprimir();

int main(int argc, char ** argv){
	iniciaAlocador();
	printf("%p\n", inicioHeap);
	printf("%p\n", topoHeap);

	return (0);
}

void iniciaAlocador(){
	inicioHeap = sbrk(0); // sbrk(0) retorna o endereço do topo da heap
	topoHeap = inicioHeap;
	brk(topoHeap);

	return;
}