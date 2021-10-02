# Necessary variables and definitions. Do not change
CC=gcc
AR=ar
CFLAGS = -Wall -std=c99 -lm
ARFLAGS = -cq	# add v if need verbose output
BIN=bin
LIB=lib
SRC=src
INCLUDE=include
MEMPOOL=../../../C/mempool
TENSOR=../../../C/primitives
PRIMITIVES = $(BIN)/mempool.o $(BIN)/tensor.o $(BIN)/createtensor.o
PRIMFILES = $(patsubst $(BIN)/%.o,%.o,$(PRIMITIVES))
OBJ = $(patsubst $(SRC)/%.c,_%,$(wildcard $(SRC)/*.c))

CREATETENSOR=../../priyankar

# User defined function - Change according to the file to run.
TESTFILE=util/Test_maxpool.c

all: compile run

compile: createDir $(PRIMITIVES) $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN)/Testfile.o -c $(TESTFILE) -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(CREATETENSOR)/include -L$(LIB)
	cd $(BIN); $(CC) -o Test Testfile.o $(OBJ) $(PRIMFILES) $(CFLAGS)

createDir:
	mkdir -p $(BIN);
	mkdir -p $(LIB);

$(BIN)/mempool.o: $(MEMPOOL)/src/mempool.c $(MEMPOOL)/include/mempool.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(MEMPOOL)/include
	
$(BIN)/tensor.o: $(TENSOR)/src/tensor.c $(TENSOR)/include/tensor.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(TENSOR)/include
	
$(BIN)/createtensor.o: $(CREATETENSOR)/src/createTensor.c $(CREATETENSOR)/include/createTensor.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(CREATETENSOR)/include

_%: $(SRC)/%.c $(PRIMITIVES)
	$(CC) $(CFLAGS) -o $(BIN)/$@ -c $< -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(CREATETENSOR)/include -I $(INCLUDE) $(ENDFLAGS)
	$(AR) $(ARFLAGS) $(LIB)/lib$*.a $(BIN)/$@ $(PRIMITIVES)

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	read FILENAME; \
	cd $(BIN); ./Test ../util/Test_inputs/$$FILENAME

.PHONY : clean
clean:
	rm $(BIN) -rf
	rm $(LIB) -rf