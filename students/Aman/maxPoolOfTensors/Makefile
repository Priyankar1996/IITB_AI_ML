CC=gcc
CFLAGS = -Wall -g
BIN=bin
SRC=src_2
INCLUDE=include_2
MEMPOOL=../../../C/mempool
TENSOR=../../../C/primitives
CREATETENSOR=../../priyankar

all: compile run

compile: mempool.o tensor.o createtensor.o maxPoolOfTensors.o Test_maxpool.o
	cd $(BIN); $(CC) $(CFLAGS) -o Testbench maxPoolOfTensors.o Test_maxpool.o mempool.o tensor.o createTensor.o

mempool.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(MEMPOOL)/src/mempool.c -I ../$(MEMPOOL)/include
	
tensor.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(TENSOR)/src/tensor.c -I ../$(TENSOR)/include
	
createtensor.o:
	cd $(BIN); $(CC) $(CFLAGS) -c ../$(CREATETENSOR)/src/createTensor.c -lm -I ../$(CREATETENSOR)/include -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include

maxPoolOfTensors.o: $(SRC)/maxPoolOfTensors.c $(INCLUDE)/maxPoolOfTensors.h
	cd $(BIN);	$(CC) $(CFLAGS) -c ../$(SRC)/maxPoolOfTensors.c -lm -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include -I $(CREATETENSOR)/include

Test_maxpool.o: util/Test_maxpool.c $(INCLUDE)/maxPoolOfTensors.h
	cd $(BIN);	$(CC) $(CFLAGS) -c ../util/Test_maxpool.c -I ../include -lm -I ../$(MEMPOOL)/include -I ../$(TENSOR)/include -I $(CREATETENSOR)/include

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	read FILENAME; \
	cd $(BIN); ./Testbench ../util/Test_inputs/$$FILENAME

clean:
	rm bin/*
