mkdir -p bin
gcc -o obj/readWriteTensors.o -c -g src/readWriteTensorsFromStandardIO.c -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/conv.o -c -g src/conv.c -lm -I include/ -I ../mempool/include/ -I ../primitives/include/
gcc -o obj/testconv.o -c -g util/conv_tb.c -I include/ -I ../mempool/include/ -I ../primitives/include/ -I include/ 
gcc -o bin/conv obj/conv.o obj/createTensor.o obj/mempool.o obj/tensor.o obj/readWriteTensors.o obj/testconv.o