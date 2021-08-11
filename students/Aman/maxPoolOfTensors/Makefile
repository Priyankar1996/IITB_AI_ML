CC=gcc
CFLAGS = -Wall
SRC=src
INCLUDE=include

all: compile run

compile: maxPoolOfTensors.o Test_maxpool.o
	cd bin; $(CC) $(CFLAGS) -o Testbench maxPoolOfTensors.o Test_maxpool.o

maxPoolOfTensors.o: $(SRC)/maxPoolOfTensors.c $(INCLUDE)/maxPoolOfTensors.h
	cd bin;	$(CC) $(CFLAGS) -c ../$(SRC)/maxPoolOfTensors.c

Test_maxpool.o: util/Test_maxpool.c $(INCLUDE)/maxPoolOfTensors.h
	cd bin;	$(CC) $(CFLAGS) -c ../util/Test_maxpool.c

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	read FILENAME; \
	cd bin; ./Testbench ../util/Test_inputs/$$FILENAME

clean:
	rm bin/*