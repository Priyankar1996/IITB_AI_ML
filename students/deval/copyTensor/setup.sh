#!/bin/bash
#!/bin/bash
gcc -o obj/mempool.o -c -g -I ../../../C/mempool/include ../../../C/mempool/src/mempool.c
gcc -o obj/tensor.o -c -g -I ../../../C/mempool/include -I ../../../C/primitives/include ../../../C/primitives/src/tensor.c

gcc -o obj/createTensor.o -c -g ../../priyankar/src/createTensor.c -lm -I ../../priyankar/include/ -I ../../../C/mempool/include/ -I ../../../C/primitives/include/
gcc -o obj/copyTensor.o -c -g -I src/ -I include/ src/copyTensor.c -lm -I ../../../C/mempool/include/ -I ../../../C/primitives/include/

gcc -o obj/test_copyTensor.o -g -c utils/test_copyTensor.c -I ../../priyankar/include/ -I ../../../C/mempool/include/ -I ../../../C/primitives/include/ -I include/
gcc -o bin/test_copyTensor obj/mempool.o obj/tensor.o obj/copyTensor.o obj/createTensor.o obj/test_copyTensor.o
$SHELL