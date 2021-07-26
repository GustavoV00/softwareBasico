#include "./../includes/alocacao.h"
#include <stdio.h>


int main() {
   void *a,*b,*c,*d,*e;

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

	e = alocaMem(20);
	imprimeMapa();
	printf("\n");

	liberaMem(b);
	printf("\n");

	imprimeMapa();
	liberaMem(c);
	printf("\n");

	imprimeMapa();
	liberaMem(e); 
	printf("\n");
	imprimeMapa();

	finalizaAlocador();

    return 0;
}
