#!/bin/bash 
mkdir -p bin
gcc -o obj/mempool.o -c -g -I ../mempool/include ../mempool/src/mempool.c -lm
gcc -o obj/tensor.o -c -g -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c -lm
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/scalarOperator.o -c -g -std=c99 src/scalarOperator.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_scalarOperator.o -c -g -std=c99 util/Test_scalarOperator.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_scalarOperator_inplace.o -c -g -std=c99 util/Test_scalarOperator_inplace.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o bin/Test_scalarOperator obj/Test_scalarOperator.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/scalarOperator.o -lm
gcc -o bin/Test_scalarOperator_inplace obj/Test_scalarOperator_inplace.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/scalarOperator.o -lm
# Use the ar comand to put all the .o files (other than the test benches into your archive.
