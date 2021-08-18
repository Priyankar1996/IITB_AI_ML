#!/bin/bash
gcc -o obj/mempool.o -c -g -I ../../../C/mempool/include ../../../C/mempool/src/mempool.c
gcc -o obj/tensor.o -c -g -I ../../../C/mempool/include -I ../../../C/primitives/include ../../../C/primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -I ../../priyankar/src/ -I ../../priyankar/include/ ../../priyankar/src/createTensor.c -lm -I ../../../C/mempool/include/ -I ../../../C/primitives/include/
gcc -o obj/copyTensorInMemory.o -c -g -I src/ -I include/ src/copyTensorInMemory.c -lm -I ../../../C/mempool/include/ -I ../../../C/primitives/include/
gcc -o obj/test_copyTensorInMemory.o -g -c utils/test_copyTensorInMemory.c -I ../../../C/mempool/include/ -I ../../../C/primitives/include/ -I include/
gcc -o bin/test_copyTensorInMemory obj/mempool.o obj/tensor.o obj/copyTensorInMemory.o obj/createTensor.o obj/test_copyTensorInMemory.o