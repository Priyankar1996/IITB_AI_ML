CC=gcc
CFLAGS = -Wall

all: compile run

compile: maxPoolOfTensors.o Test_maxpool.o
	cd bin; $(CC) $(CFLAGS) -o Testbench maxPoolOfTensors.o Test_maxpool.o

maxPoolOfTensors.o: src/maxPoolOfTensors.c include/maxPoolOfTensors.h
	cd bin;	$(CC) $(CFLAGS) -c ../src/maxPoolOfTensors.c

Test_maxpool.o: util/Test_maxpool.c include/maxPoolOfTensors.h
	cd bin;	$(CC) $(CFLAGS) -c ../util/Test_maxpool.c

run:
	@echo "Enter input filename (file must be present in util/Test_inputs/)"; \
	read FILENAME; \
	cd bin; ./Testbench ../util/Test_inputs/$$FILENAME

clean:
	rm bin/*