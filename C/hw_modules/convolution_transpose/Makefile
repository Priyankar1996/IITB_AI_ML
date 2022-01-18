# Necessary variables and definitions. Do not change
CC=gcc
CFLAGS = -Wall -std=c99 -lm
BIN=bin
LIB=lib
INCLUDE=include
SIZED_TENSOR=../../primitives/include

# User defined function - Change according to the file to run.
TESTFILE=util/test_convTranspose.c

all: compile run

compile: createDir
	$(CC) $(CFLAGS) -o $(BIN)/Testfile.o -c $(TESTFILE) -I $(SIZED_TENSOR) -I $(INCLUDE)
	cd $(BIN); $(CC) -o Test Testfile.o $(CFLAGS)

createDir:
	mkdir -p $(BIN);
	mkdir -p $(LIB);

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	# read FILENAME; \
	cd $(BIN); ./Test ../util/Test_inputs/input_image.txt ../util/Test_inputs/input_kernel.txt

.PHONY : clean
clean:
	rm $(BIN) -rf
	rm $(LIB) -rf