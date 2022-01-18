mkdir -p bin
gcc -o obj/convolution.o -c -g -std=c99 utils/convolution.c -I include/
gcc -o bin/convolution obj/convolution.o
$SHELL