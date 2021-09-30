mkdir -p bin
gcc -o obj/mempool.o -c -g -std=c99 -I ../mempool/include ../mempool/src/mempool.c 
gcc -o obj/tensor.o -c -g -std=c99 -I ../mempool/include -I ../primitives/include ../primitives/src/tensor.c
gcc -o obj/createTensor.o -c -g -std=c99 -I src/ -I include/ src/createTensor.c -lm -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/readWriteTensors.o -c -g -std=c99 src/readWriteTensorsFromStandardIO.c -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/conv.o -c -g -std=c99 src/conv.c -lm -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/convTranspose.o -c -g -std=c99 src/convolutionTranspose.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/ 
gcc -o obj/testconvTranspose.o -c -g -std=c99 util/testconvTranspose.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/
gcc -o bin/convTranspose obj/conv.o obj/convTranspose.o obj/createTensor.o obj/mempool.o obj/tensor.o obj/testconvTranspose.o obj/readWriteTensors.o