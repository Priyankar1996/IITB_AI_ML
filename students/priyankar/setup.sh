#!/bin/bash
gcc -o obj/mempool.o -c -g -I ../../C/mempool/include ../../C/mempool/src/mempool.c
gcc -o obj/tensor.o -c -g -I ../../C/mempool/include -I ../../C/primitives/include ../../C/primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
gcc -o obj/testCreateTensor.o -g -c util/testCreateTensor.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I include/
gcc -o bin/testCreateTensor obj/mempool.o obj/tensor.o obj/createTensor.o obj/testCreateTensor.o 