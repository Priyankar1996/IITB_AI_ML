#!/bin/bash
UARTINCL="./include"
UARTLIB="./lib"
DEFINES=" -D FPGA -D NUSE_DOUBLE -D FREADWRITE  -D NDEBUGPRINT "
INCLUDES="-I $AHIR_RELEASE/include -I include -I ./ -I $UARTINCL"
LIBPATH="-L $AHIR_RELEASE/lib -L $UARTLIB"
LIBS="  -lBitVectors -lPipeHandler -l SockPipes -lm -luart_interface -lpthread "
CFLAGS=" -g "
rm -rf objsw
mkdir objsw
#./driver:
gcc $CFLAGS -I include/ -c src/tb_utils.c $DEFINES $INCLUDES -o objsw/tb_utils.o
gcc $CFLAGS -I include/ -c src/receive_fits.c $DEFINES $INCLUDES -o objsw/receive_fits.o
# link
if [ ! -d ./bin ] 
then
  mkdir bin
fi
gcc $CFLAGS -o bin/receive_fits objsw/*.o $LIBPATH $LIBS
