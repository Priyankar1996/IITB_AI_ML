#!/bin/bash
gcc -o obj/mempool.o -c -g -I ../../../C/mempool/include ../../../C/mempool/src/mempool.c
gcc -o obj/tensor.o -c -g -I ../../../C/mempool/include -I ../../../C/primitives/include ../../../C/primitives/src/tensor.c

gcc -o obj/createTensor.o -c -g ../../priyankar/src/createTensor.c -lm -I ../../priyankar/include/ -I ../../../C/mempool/include/ -I ../../../C/primitives/include/
gcc -o obj/readWriteTensors.o -c -g ../../priyankar/src/readWriteTensorsFromStandardIO.c -I ../../priyankar/include/ -I ../../../C/mempool/include/ -I ../../../C/primitives/include/

gcc -o obj/new_conv.o -g -c -std=c99 src/new_conv.c -lm -I include/ -lm -I ../../../C/mempool/include/ -I ../../../C/primitives/include/
gcc -o obj/testConv.o -c -g -std=c99 utils/conv_tb.c -I include/ -I ../../priyankar/include/ -I ../../../C/mempool/include/ -I ../../../C/primitives/include/ 

gcc -o bin/testConvExec obj/mempool.o obj/tensor.o obj/createTensor.o obj/readWriteTensors.o obj/new_conv.o obj/testConv.o
# Use the ar comand to put all the .o files (other than the test benches into your archive.
$SHELL