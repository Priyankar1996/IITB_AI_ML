#!/bin/bash
echo 'started'
gcc -o obj/mempool.o -c -g -I ../../C/mempool/include ../../C/mempool/src/mempool.c
echo 'done 1st'
gcc -o obj/tensor.o -c -g -I ../../C/mempool/include -I ../../C/primitives/include ../../C/primitives/src/tensor.c
echo 'done 2nd'
gcc -o obj/createTensor.o -c -g -I ../priyankar/src/ -I ../priyankar/include/ ../priyankar/src/createTensor.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
echo 'done 3rd'
gcc -o obj/readWriteTensorsFromStandardIO.o -c -g -I ../priyankar/src/ -I ../priyankar/include/ ../priyankar/src/readWriteTensorsFromStandardIO.c -lm -I ../../C/mempool/include/ -I ../../C/primitives/include/
echo 'done 4th'
gcc -o obj/zero_pad.o -g -c src/zero_pad.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I ../priyankar/include/ -I include/
echo 'done 5th'
gcc -o obj/zero_pad_test.o -g -c utils/zero_pad_test.c -I ../../C/mempool/include/ -I ../../C/primitives/include/ -I ../priyankar/include/ -I include/
echo 'done 6th'
gcc -o bin/zero_pad_test obj/mempool.o obj/tensor.o obj/createTensor.o obj/readWriteTensorsFromStandardIO.o obj/zero_pad.o obj/zero_pad_test.o 
echo 'done 7th'
