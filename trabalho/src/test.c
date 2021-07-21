#include "./../includes/alocacao.h"


int main() {
    void *a, *b, *c, *d;

    iniciaAlocador();
    a = alocaMem(25);
    b = alocaMem(30);
    c = alocaMem(35);
    c = alocaMem(40);

    imprimeMapa();
    return 0;
}