#!/bin/bash
mkdir -p bin 
gcc -o obj/mempool.o -c -g -I ../mempool/include ../mempool/src/mempool.c 
gcc -o obj/tensor.o -c -g -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/unary_inplace_fn.o -c -g src/unary_inplace_fn.c -I include/ -I ..//mempool/include/ -I ../primitives/include/
gcc -o obj/Test_unary_inplace.o -c -g util/Test_unary_inplace.c -I include/ -I ..//mempool/include/ -I ../primitives/include/
gcc -o bin/Test_unary_inplace obj/Test_unary_inplace.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/unary_inplace_fn.o  
# Use the ar comand to put all the .o files (other than the test benches into your archive.