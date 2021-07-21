#include "./../includes/alocacao.h"


int main() {
    void *a, *b, *c, *d;

    iniciaAlocador();
    imprimeMapa();
    a=alocaMem(240);
    imprimeMapa();
    b=alocaMem(50);
    imprimeMapa();
    liberaMem(a);
    imprimeMapa();
    a=alocaMem(50);
    imprimeMapa();
    
    finalizaAlocador();
    return 0;
}