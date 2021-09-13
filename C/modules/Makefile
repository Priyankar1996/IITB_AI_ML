CC=gcc
AR=ar
CFLAGS = -Wall -std=c99
ARFLAGS = -cvq
BIN=bin
LIB=lib
SRC=src
INCLUDE=include
MEMPOOL=../mempool
TENSOR=../primitives
PRIMITIVES = $(BIN)/mempool.o $(BIN)/tensor.o $(BIN)/createTensor.o
OBJ =  _maxPoolOfTensors _convolutionTranspose _readWriteTensorsFromStandardIO

all: compile

compile: createDir $(PRIMITIVES) $(OBJ)
	# cd $(BIN); $(CC) $(CFLAGS) -o Testbench $(OBJ)
	# ar -cvq $(LIB)/libMaxPool.a $(BIN)/*.o

createDir:
	mkdir -p $(BIN);
	mkdir -p $(LIB);

$(BIN)/mempool.o: $(MEMPOOL)/src/mempool.c $(MEMPOOL)/include/mempool.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(MEMPOOL)/include
	
$(BIN)/tensor.o: $(TENSOR)/src/tensor.c $(TENSOR)/include/tensor.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(TENSOR)/include
	
$(BIN)/createTensor.o: $(SRC)/createTensor.c
	$(CC) $(CFLAGS) -o $@ -c $< -I $(INCLUDE) -I $(MEMPOOL)/include -I $(TENSOR)/include

_%: $(SRC)/%.c $(PRIMITIVES)
	$(CC) $(CFLAGS) -o $(BIN)/$@ -c $< -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(INCLUDE)
	$(AR) $(ARFLAGS) $(LIB)/lib$*.a $(BIN)/$@ $(PRIMITIVES)

clean:
	rm $(BIN) -r
	rm $(LIB) -r