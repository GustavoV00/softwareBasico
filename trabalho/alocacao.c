#include <stdio.h>
#include <unistd.h>

int topoInicialHeap;

void iniciaAlocador();
void finalizaAlocador();
void* alocaMem(int numBytes);
int liberaMem(void* bloco);
void imprimir();

int main(int argc, char ** argv){
    printf("%d\n", topoInicialHeap);
	return (0);
}

void iniciaAlocador(){
    topoInicialHeap = brk(0);
}


void imprimeHeap(){
    if(topoInicialHeap == 0){
        printf("Loop para imprimir a heap\n");
    
    } else {
        printf("Deu ruim ao iniciar a heap\n");
    }
}


