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

	d = alocaMem(201);
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

	e = alocaMem(5000);
	imprimeMapa();
	printf("\n");

	liberaMem(b);
	imprimeMapa();
	printf("\n");

	b = alocaMem(2000);
	imprimeMapa();
	printf("\n");

	liberaMem(c);
	imprimeMapa();
	printf("\n");

	c = alocaMem(20);
	imprimeMapa();
	printf("\n");

	liberaMem(e); 
	printf("\n");
	imprimeMapa();

	liberaMem(c);
	imprimeMapa();
	printf("\n");

	liberaMem(b);
	imprimeMapa();
	printf("\n");


	finalizaAlocador();

    return 0;
}
