#!/bin/bash
echo 'started'
mkdir -p bin
echo 'done 1st'
gcc -o obj/zero_pad_test.o -g -c util/zero_pad_test.c -I ../../C/primitives/include/ -I include/
echo 'done 2th'
gcc -o bin/zero_pad_test obj/zero_pad_test.o 
echo 'done 3th'
