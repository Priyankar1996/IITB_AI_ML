gcc -o obj/mtwist.o -c -g ../mtwist/src/mtwist.c -lm -I ../mtwist/include/
gcc -o obj/genRandomTensor.o -c -g src/genRandomTensor.c -lm -I include/ -I ../mempool/include/ -I ../primitives/include/ -I ../mtwist/include
gcc -o obj/testgenRandom.o -c -g util/test_genRandomTensor.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/ -I ../mtwist/include
gcc -o bin/genRandom obj/genRandomTensor.o obj/createTensor.o obj/mempool.o obj/tensor.o obj/testgenRandom.o obj/mtwist.o