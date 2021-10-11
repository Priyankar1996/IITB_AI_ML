mkdir -p bin
clear
gcc -o obj/mempool.o -c -g -std=c99 -I ../mempool/include ../mempool/src/mempool.c 
gcc -o obj/tensor.o -c -g -std=c99 -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -std=c99 -I src/ -I include/ src/createTensor.c  -I ../mempool/include/ -I ../primitives/include/ -lm
gcc -o obj/readWriteTensors.o -c -g -std=c99 src/readWriteTensorsFromStandardIO.c -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/concat.o -c -g -std=c99 src/concat.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -lm

gcc -o obj/test_concat.o -c -g -std=c99 util/concat_tb.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I src/
gcc -o bin/test_concat obj/concat.o obj/test_concat.o obj/createTensor.o obj/mempool.o obj/tensor.o obj/readWriteTensors.o -lm 