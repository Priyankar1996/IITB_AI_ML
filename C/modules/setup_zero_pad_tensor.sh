#!/bin/bash
mkdir -p bin
echo 'started'
gcc -o obj/mempool.o -c -g -I ../mempool/include ../mempool/src/mempool.c
echo 'done 1st'
gcc -o obj/tensor.o -c -g -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c
echo 'done 2nd'
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/
echo 'done 3rd'
gcc -o obj/zero_pad_tensor.o -g -c src/zero_pad_tensor.c -I ../mempool/include/ -I ../primitives/include/ -I ../include/ -I include/
echo 'done 4th'
gcc -o obj/zero_pad_tensor_test.o -g -c util/zero_pad_tensor_test.c -I ../mempool/include/ -I ../primitives/include/  -I include/
echo 'done 5th'
gcc -o bin/zero_pad_tensor_test obj/mempool.o obj/tensor.o obj/createTensor.o obj/zero_pad_tensor.o obj/zero_pad_tensor_test.o 
echo 'done 6th'
