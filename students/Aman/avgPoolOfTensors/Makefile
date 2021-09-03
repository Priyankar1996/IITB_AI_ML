CC=gcc
CFLAGS = -Wall -g
BIN=bin
SRC=src
INCLUDE=include
MEMPOOL=../../../C/mempool
TENSOR=../../../C/primitives
CREATETENSOR=../../priyankar

all: compile run

compile: mempool.o tensor.o createtensor.o avgPoolOfTensors.o Test_avgpool.o
	cd $(BIN); $(CC) $(CFLAGS) -o Testbench avgPoolOfTensors.o Test_avgpool.o mempool.o tensor.o createTensor.o

mempool.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(MEMPOOL)/src/mempool.c -I ../$(MEMPOOL)/include
	
tensor.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(TENSOR)/src/tensor.c -I ../$(TENSOR)/include
	
createtensor.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(CREATETENSOR)/src/createTensor.c -lm -I ../$(CREATETENSOR)/include -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include

avgPoolOfTensors.o: $(SRC)/avgPoolOfTensors.c $(INCLUDE)/avgPoolOfTensors.h
	cd $(BIN);	$(CC) $(CFLAGS) -c ../$(SRC)/avgPoolOfTensors.c -lm -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include -I $(CREATETENSOR)/include

Test_avgpool.o: util/Test_avgpool.c $(INCLUDE)/avgPoolOfTensors.h
	cd $(BIN);	$(CC) $(CFLAGS) -c ../util/Test_avgpool.c -I ../include -lm -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include -I $(CREATETENSOR)/include

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	read FILENAME; \
	cd $(BIN); ./Testbench ../util/Test_inputs/$$FILENAME

clean:
	rm bin/*
