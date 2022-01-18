mkdir -p bin
gcc -o obj/zero_pad.o -c -g -std=c99 util/zero_pad_test.c -I include/
gcc -o bin/zero_pad obj/zero_pad.o
