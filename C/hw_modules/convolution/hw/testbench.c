
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>
#include <inttypes.h>
#include "prog.h"

#include "sized_tensor.h"
#include "convolveTensors.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#include "prog.h"
#else
#include "vhdlCStubs.h"
#endif

//
//
SizedTensor_16K T,K,R;
//SizedTensor_1024 K;
uint8_t stride;

#ifdef SW
DEFINE_THREAD(conv2D);
#endif

void wr_input()
{
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint64("conv_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		write_uint64("conv_input_pipe",T.data_array[i]);
	}
	for(i = 0; i < K.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint64("conv_input_pipe",K.descriptor.descriptor.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(K) >> 2)+1; i++)
	{
		write_uint64("conv_input_pipe",K.data_array[i]);
	}
	write_uint64("conv_input_pipe",stride);
}


void rd_output()
{
	int i;
        for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint64("conv_output_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(R) >> 2)+1; i++)
	{
		R.data_array[i] = read_uint64("conv_output_pipe");
	}
}


int main(int argc, char* argv[])
{
	fprintf(stderr,"Entering main testbench....\n");

        int i;

        srand(100);

	T.descriptor.descriptor.data_type = i16;
	K.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	K.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	K.descriptor.descriptor.number_of_dimensions = 4;

	R.descriptor.descriptor.number_of_dimensions = 3;

	T.descriptor.descriptor.dimensions[0] = 25;
	T.descriptor.descriptor.dimensions[1] = 25;
	T.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[0] = 1;
	K.descriptor.descriptor.dimensions[1] = 3;
	K.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[3] = 3;

        for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		T.data_array[i] = 5;
	}
        for(i = 0; i < (__NumberOfElementsInSizedTensor__(K) >> 2)+1; i++)
	{
		K.data_array[i] = 1;
	}
	stride = 1;
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("conv_input_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("conv_output_pipe", 2, 64, PIPE_FIFO_MODE);

	PTHREAD_DECL(conv2D);

	PTHREAD_CREATE(conv2D);
#endif

	wr_input();
	rd_output();

	fprintf(stdout,"Done.\n");

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(conv2D);
	close_pipe_handler();
#endif
return 0;
}
