#include <stdio.h>
#include <stdlib.h>

int main(){
	int aux;
	int k=0;
    int n = 10;
	int vetorA[n];

    for(int i=0;i < n;i++)
    {
        aux = rand() % 99;

        for(int j=0;j < n;j++)
        {
            if (vetorA[j] == aux){
				printf("aqui ");
				break;

			} else if(vetorA[j] == '\0'){
                vetorA[k] = aux;
                k = k+1;
				break;
            }
        }
    }

    for(int i=0;i < k;i++)
    {
        printf("%d ", vetorA[i]);
    }
	printf("\n");

    return 0;
}