#!/bin/bash
UARTINCL="./include"
UARTLIB="./lib"
DEFINES="-D FPGA -D NUSE_DOUBLE -D NFREADWRITE -D NREADBACK -D NDEBUGPRINT "
INCLUDES="-I $AHIR_RELEASE/include -I include -I ./ -I $UARTINCL"
LIBPATH="-L $AHIR_RELEASE/lib -L $UARTLIB"
LIBS="  -lBitVectors -lPipeHandler -l SockPipes -lm -luart_interface -lpthread "
CFLAGS=" -g "
rm -rf objfinal
mkdir objfinal
#./driver:
gcc $CFLAGS -I include -c src/configure_and_send.c $DEFINES $INCLUDES -o objfinal/configure_and_send.o
gcc $CFLAGS -I include -c src/tb_utils.c $DEFINES $INCLUDES -o objfinal/tb_utils.o
# link
if [ ! -d ./bin ] 
then
  mkdir bin
fi
gcc $CFLAGS -o bin/configure_and_send objfinal/*.o $LIBPATH $LIBS
