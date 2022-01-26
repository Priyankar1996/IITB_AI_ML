mkdir -p bin
mkdir -p obj
gcc -o obj/convolution.o -c -g utils/convolution.c -I include/
gcc -o bin/convolution obj/convolution.o
