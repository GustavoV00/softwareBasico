
long int a,b;
int main( long int arc, char **argv ){
    a = 4;
    b = 5;

    if(a > b){
        a = a + b;
    } else {
        a = a - b;
    }
   
    return a;
}