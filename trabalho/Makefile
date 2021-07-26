### COMPILADORES ###
GCC = gcc
AS = as

### DIRETORIOS ###
SRC=./src

### FLAGS ###
CFLAGS=-Wall -g -no-pie -fno-pie

### FILES ###
TEST=./test

all: build
build: meuAlocador.o
	$(GCC) $(CFLAGS) $(SRC)/test.c $(SRC)/meuAlocador.o -o test 

meuAlocador.o:
	$(AS) $(SRC)/meuAlocador.s -o $(SRC)/meuAlocador.o -g

## Limpa os diretórios
clean:
	rm $(SRC)/*.o && rm ./test