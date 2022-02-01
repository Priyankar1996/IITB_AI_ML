#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
#include "convolveTensors.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#ifdef SW
DEFINE_THREAD(conv2D);
#endif

SizedTensor_16K T,K,R;
uint16_t stride = 1;

void write_input()
{
	for(int i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("conv_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
        for(int i = 0; i < __NumberOfElementsInSizedTensor__(T); i++) 
	{
		write_uint16("conv_input_pipe",T.data_array[i]);
	}
	fprintf(stderr,"Sent T.\n");
}

void write_kernel()
{
	for(int i = 0; i < K.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("conv_input_pipe",K.descriptor.descriptor.dimensions[i]);
	}
        for(int i = 0; i < __NumberOfElementsInSizedTensor__(K); i++) 
	{
		write_uint16("conv_input_pipe",K.data_array[i]);
	}
	fprintf(stderr,"Sent K.\n");
}

void write_stride()
{
	write_uint16("conv_input_pipe",stride);
}


void read_result()
{
	for(int i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint16("conv_output_pipe");
	}
        for(int i = 0; i < __NumberOfElementsInSizedTensor__(R); i++) 
	{
		R.data_array[i] = read_uint16("conv_output_pipe");
	}
	fprintf(stderr,"Read R.\n");
}


int main(int argc, char* argv[])
{
        int i;

        srand(100);

	T.descriptor.descriptor.dimensions[0] = 10;
	T.descriptor.descriptor.dimensions[1] = 10;
	T.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[0] = 1;
	K.descriptor.descriptor.dimensions[1] = 3;
	K.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[3] = 3;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
	{
		T.data_array[i] = rand();
	}

        for(i = 0; i < __NumberOfElementsInSizedTensor__(K); i++)
	{
		K.data_array[i] = rand();
	}
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("conv_input_pipe", 2, 32, PIPE_FIFO_MODE);
	register_pipe ("conv_output_pipe", 2, 32, PIPE_FIFO_MODE);

	PTHREAD_DECL(conv2D);

	PTHREAD_CREATE(conv2D);
#endif
	write_input();
	write_kernel();
	write_stride();
	read_result();

	fprintf(stdout,"results: \n ");
	for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++)
	{
		fprintf(stdout,"R.data_array[%d] = %d\n", i, R.data_array[i]);
	}
	fprintf(stdout,"done\n");

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(conv2D);
	close_pipe_handler();
	return 0;
#endif
}
