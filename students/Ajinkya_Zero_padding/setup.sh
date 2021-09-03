#!/bin/bash
echo 'started'
gcc -o obj/mempool.o -c -g -I ../../C/mempool/include ../../C/mempool/src/mempool.c
echo 'done 1st'
gcc -o obj/tensor.o -c -g -I ../../C/mempool/include -I ../../C/primitives/include ../../C/primitives/src/tensor.c
echo 'done 2nd'
gcc -o obj/createTensor.o -c -g -I ../priyankar/src/ -I ../priyankar/include/ ../priyankar/src/createTensor.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
echo 'done 3rd'
gcc -o obj/zero_pad_tensor.o -g -c src/zero_pad_tensor.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I ../priyankar/include/ -I include/
echo 'done 4th'
gcc -o obj/zero_pad_tensor_test.o -g -c utils/zero_pad_tensor_test.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I ../priyankar/include/ -I include/
echo 'done 5th'
gcc -o bin/zero_pad_tensor_test obj/mempool.o obj/tensor.o obj/createTensor.o obj/zero_pad_tensor.o obj/zero_pad_tensor_test.o 
echo 'done 6th'
