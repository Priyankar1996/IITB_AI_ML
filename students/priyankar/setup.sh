#!/bin/bash
gcc -o ../../C/mempool/src/mempool.o -c -g -I ../../C/mempool/include ../../C/mempool/src/mempool.c
gcc -o src/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
gcc -o util/test_createTensor.o -g -c util/test_createTensor.c -I ../../C/mempool/include/ -I ../../C/primitives/include -I include/
gcc -o bin/test_createTensor ../../C/mempool/src/mempool.o src/createTensor.o util/test_createTensor.o 