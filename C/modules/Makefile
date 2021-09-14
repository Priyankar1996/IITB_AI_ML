# Necessary variables and definitions. Do not change
CC=gcc
AR=ar
CFLAGS = -Wall -std=c99
ARFLAGS = -cq	# add v if need verbose output
BIN=bin
LIB=lib
SRC=src
INCLUDE=include
MEMPOOL=../mempool
TENSOR=../primitives
PRIMITIVES = $(BIN)/mempool.o $(BIN)/tensor.o
PRIMFILES = $(patsubst $(BIN)/%.o,%.o,$(PRIMITIVES))
OBJ = $(patsubst $(SRC)/%.c,_%,$(wildcard $(SRC)/*.c))

# User defined function - Change according to the file to run.
TESTFILE=util/Test.c



all: compile

compile: createDir $(PRIMITIVES) $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN)/Testfile.o -c $(TESTFILE) -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(INCLUDE)
	cd $(BIN); $(CC) $(CFLAGS) -o Test Testfile.o $(OBJ) $(PRIMFILES)

createDir:
	mkdir -p $(BIN);
	mkdir -p $(LIB);

$(BIN)/mempool.o: $(MEMPOOL)/src/mempool.c $(MEMPOOL)/include/mempool.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(MEMPOOL)/include
	
$(BIN)/tensor.o: $(TENSOR)/src/tensor.c $(TENSOR)/include/tensor.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(TENSOR)/include
	
_%: $(SRC)/%.c $(PRIMITIVES)
	$(CC) $(CFLAGS) -o $(BIN)/$@ -c $< -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(INCLUDE)
	$(AR) $(ARFLAGS) $(LIB)/lib$*.a $(BIN)/$@ $(PRIMITIVES)

.PHONY : clean
clean:
	rm $(BIN) -r
	rm $(LIB) -r
