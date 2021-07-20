#ifndef __ALOCACAO__
#define __ALOCACAO__


// Inicia a heap alocado sem espaço nenhum. 
// Inicia topoHeap e inicioHeap com os valores zerados
void iniciaAlocador();

// Volta a heap para o estado sem nada alocado
void finalizaAlocador();

// ALoca algum espaço na heap com tamanho de numBytes
void* alocaMem(long int numBytes);

// Desaloca o espaço alocado na heap. E o bloco indica qual é o endereço do bloco
// QUe precisa ser desalocado
void liberaMem(void* bloco);

// Imprime um mapa de como os blocos estão alocados na heap
void imprimeMapa();

#endif