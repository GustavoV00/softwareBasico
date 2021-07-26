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
build: alocacao.o
	$(GCC) $(CFLAGS) $(SRC)/test.c $(SRC)/alocacao.o -o test 

alocacao.o:
	$(AS) $(SRC)/alocacao.s -o $(SRC)/alocacao.o -g

## Limpa os diretórios
clean:
	rm $(SRC)/*.o && rm ./test