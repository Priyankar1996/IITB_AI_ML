#!/bin/bash
rm -rf obj
rm -rf bin
mkdir obj
mkdir bin
gcc -g -c -I ./include src/receive_data.c -o obj/receive_data.o
gcc -g -c -I ./include src/send_data.c -o obj/send_data.o
#
gcc -g -c -I ./include src/tb_utils.c -o obj/tb_utils.o
gcc -g -c -DFREADWRITE -I ./include src/tb_utils.c -o obj/tb_utils.fread.o
#
gcc -g -o bin/send_data obj/send_data.o obj/tb_utils.o  -L ./lib/ -l uart_interface 
gcc -g -o bin/receive_data obj/receive_data.o obj/tb_utils.fread.o -L ./lib/  -l uart_interface 
