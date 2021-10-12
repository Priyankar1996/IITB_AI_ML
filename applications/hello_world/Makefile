# Compile script to run applications
# AUTHOR : Aman Dhammani
# Department of Electrical Engineering, IITB

# Necessary variables and definitions. Do not change
CC=gcc
AR=ar
CFLAGS = -Wall -std=c99 -lm
ARFLAGS = -cq	# add v if need verbose output

# Directory paths for various functions/primitives
BIN=bin
LIB=lib
SRC=../../C/modules/src
INCLUDE=../../C/modules/include
MEMPOOL=../../C/mempool
TENSOR=../../C/primitives

# List of primitives - mempool and tensor
PRIMITIVES = $(BIN)/mempool.o $(BIN)/tensor.o
PRIMFILES = $(patsubst $(BIN)/%.o,%.o,$(PRIMITIVES))

# # Uncomment to include all files present in $(SRC) 
# # Also comment the next definition of OBJ, if uncommenting this
# OBJ = $(patsubst $(SRC)/%.c,_%,$(wildcard $(SRC)/*.c))

# Can list objects required as _<object_src_file_name>
OBJ = 	_maxPoolOfTensors \
		_createTensor \
		_conv \
		_convolutionTranspose \
		_unary_fn \
		_readWriteTensorsFromStandardIO \
		_batchNormalization \
		_concat

# User defined function - Change according to the file to run.
TESTFILE=src/UNET.c


all: compile

compile: createDir $(PRIMITIVES) $(OBJ)
	$(CC) $(CFLAGS) -o $(BIN)/Testfile.o -c $(TESTFILE) -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(INCLUDE) -L$(LIB)
	cd $(BIN); $(CC) -o Test Testfile.o $(OBJ) $(PRIMFILES) $(CFLAGS)

createDir:
	mkdir -p $(BIN);
	mkdir -p $(LIB);

$(BIN)/mempool.o: $(MEMPOOL)/src/mempool.c $(MEMPOOL)/include/mempool.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(MEMPOOL)/include
	
$(BIN)/tensor.o: $(TENSOR)/src/tensor.c $(TENSOR)/include/tensor.h
	$(CC) $(CFLAGS) -o $@ -c $< -I $(TENSOR)/include
	
_%: $(SRC)/%.c $(PRIMITIVES)
	$(CC) $(CFLAGS) -o $(BIN)/$@ -c $< -I $(MEMPOOL)/include -I $(TENSOR)/include -I $(INCLUDE) $(ENDFLAGS)
	$(AR) $(ARFLAGS) $(LIB)/lib$*.a $(BIN)/$@ $(PRIMITIVES)

.PHONY : clean
clean:
	rm $(BIN) -rf
	rm $(LIB) -rf
