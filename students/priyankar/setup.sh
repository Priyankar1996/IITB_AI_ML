#!/bin/bash
gcc -o ../../C/mempool/src/mempool.o -c -g -I ../../C/mempool/include ../../C/mempool/src/mempool.c
gcc -o ../../C/primitives/src/tensor.o -c -g -I ../../C/mempool/include -I ../../C/primitives/include ../../C/primitives/src/tensor.c
gcc -o src/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
gcc -o util/testCreateTensor.o -g -c util/testCreateTensor.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I util/test_createTensor.h
gcc -o bin/testCreateTensor ../../C/mempool/src/mempool.o ../../C/primitives/src/tensor.o src/createTensor.o util/testCreateTensor.o 