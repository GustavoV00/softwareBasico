
### COMPILADORES ###
GCC = gcc
AS = as

### DIRETORIOS ###
INC=./includes
SRC=./src
BIN=./bin

### FLAGS ###
CFLAGS=-Wall -g -no-pie -fno-pie

### FILES ###
TEST=./test

all: build
build: diretorios alocacao.o
	$(GCC) $(CFLAGS) $(SRC)/test.c $(BIN)/alocacao.o -o test 

alocacao.o:
	$(AS) $(SRC)/alocacao.s -o $(BIN)/alocacao.o -g

### CRIA OS DIRETORIOS ###
diretorios:

	@if [ ! -d "$(BIN)" ]; then \
		mkdir $(BIN); \
	fi


## Limpa os diretórios
clean:

	@if [ -d "$(BIN)" ]; then \
		rm -r $(BIN) && rm $(TEST); \
	fi
