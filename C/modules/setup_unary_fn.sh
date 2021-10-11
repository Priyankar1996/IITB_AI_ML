#!/bin/bash 
mkdir -p bin
gcc -o obj/mempool.o -c -g -I ../mempool/include ../mempool/src/mempool.c -lm
gcc -o obj/tensor.o -c -g -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c -lm
gcc -o obj/createTensor.o -c -g -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/copyTensor.o -c -g -I src/ -I include/ src/copyTensor.c -lm -I ../mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/unary_fn.o -c -g -std=c99 src/unary_fn.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_unary_fn.o -c -g -std=c99 util/Test_unary_fn.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_unary_inplace_fn.o -c -g -std=c99 util/Test_unary_inplace_fn.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_unary_fn_Random.o -c -g -std=c99 util/Test_unary_fn_Random.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/Test_unary_fn_inplace_Random.o -c -g -std=c99 util/Test_unary_fn_inplace_Random.c -I include/ -I ..//mempool/include/ -I ../primitives/include/ -lm
gcc -o bin/Test_unary_fn obj/Test_unary_fn.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/unary_fn.o -lm
gcc -o bin/Test_unary_inplace_fn obj/Test_unary_inplace_fn.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/unary_fn.o -lm
gcc -o bin/Test_unary_fn_Random obj/Test_unary_fn_Random.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/unary_fn.o -lm
gcc -o bin/Test_unary_fn_inplace_Random obj/Test_unary_fn_inplace_Random.o obj/mempool.o obj/tensor.o obj/createTensor.o obj/copyTensor.o obj/unary_fn.o -lm
# Use the ar comand to put all the .o files (other than the test benches into your archive.

