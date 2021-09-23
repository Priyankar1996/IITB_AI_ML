#!/bin/bash
gcc -o obj/mempool.o -c -g -I ../mempool/include ../mempool/src/mempool.c 
gcc -o obj/tensor.o -c -g -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/testCreateTensor.o -g -c util/testCreateTensor.c -I ../mempool/include/ -I ../primitives/include/ -I include/
gcc -o bin/testCreateTensor obj/mempool.o obj/tensor.o obj/createTensor.o obj/testCreateTensor.o 
# Use the ar comand to put all the .o files (other than the test benches into your archive.
