mkdir -p bin
gcc -o obj/readWriteTensors.o -c -g src/readWriteTensorsFromStandardIO.c -I include/ -I ..//mempool/include/ -I ../primitives/include/
gcc -o obj/testReadWriteTensors.o -c -g util/testStdIO.c -I ../mempool/include/ -I ../primitives/include/ -I include/ -I src/
gcc -o bin/testStdIO obj/mempool.o obj/tensor.o obj/createTensor.o obj/readWriteTensors.o obj/testReadWriteTensors.o