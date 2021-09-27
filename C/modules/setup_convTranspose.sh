mkdir -p bin
gcc -o obj/readWriteTensors.o -c -g src/readWriteTensorsFromStandardIO.c -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/conv.o -c -g -std=c99 src/conv.c -lm -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/convTranspose.o -c -g -std=c99 src/convolutionTranspose.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/ 
gcc -o obj/testconvTranspose.o -c -g -std=c99 util/testconvTranspose.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/
gcc -o bin/convTranspose obj/conv.o obj/convTranspose.o obj/createTensor.o obj/mempool.o obj/tensor.o obj/testconvTranspose.o obj/readWriteTensors.o