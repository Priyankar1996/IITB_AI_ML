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

#ifdef SW
DEFINE_THREAD(conv2D);
#endif

SizedTensor_16K T,K,R;
uint16_t stride;

void write_input_dim(){
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("conv_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
}

void write_kernel_dim(){
	int i;
	for(i = 0; i < K.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("conv_input_pipe",K.descriptor.descriptor.dimensions[i]);
	}
}

void write_input_data(){
	int i;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++) 
	{
		write_uint16("conv_input_pipe",*(((int16_t*)T.data_array) + i));
	}
}

void write_kernel_data(){
	int i;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(K); i++) 
	{
		write_uint16("conv_input_pipe",*(((int16_t*)K.data_array) + i));
	}
}
void write_stride(){
	write_uint16("conv_input_pipe",stride);
}


void read_result_dim(){
	int i;
	for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint16("conv_output_pipe");
	}
}

void read_result_data(){
	int i;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++) 
	{
		*(((int16_t*)R.data_array) + i) = read_uint16("conv_output_pipe");
	}
}


int main(int argc, char* argv[])
{

	int i;
	T.descriptor.descriptor.number_of_dimensions = 3;
	K.descriptor.descriptor.number_of_dimensions = 4;
	T.descriptor.descriptor.dimensions[0] = 10;
	T.descriptor.descriptor.dimensions[1] = 10;
	T.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[0] = 1;
	K.descriptor.descriptor.dimensions[1] = 3;
	K.descriptor.descriptor.dimensions[2] = 3;
	K.descriptor.descriptor.dimensions[3] = 3;
	R.descriptor.descriptor.number_of_dimensions = 3;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
	{
		*(((int16_t*)T.data_array) + i) = 5;
	}

        for(i = 0; i < __NumberOfElementsInSizedTensor__(K); i++)
	{
		*(((int16_t*)K.data_array) + i) = 1;
	}
	stride = 1;

#ifdef SW
	init_pipe_handler();
	register_pipe ("conv_input_pipe", 2, 16, PIPE_FIFO_MODE);
	register_pipe ("conv_output_pipe", 2, 16, PIPE_FIFO_MODE);

	PTHREAD_DECL(conv2D);

	PTHREAD_CREATE(conv2D);
#endif
	
	write_input_dim();
	write_input_data();
	write_kernel_dim();
	write_kernel_data();
	write_stride();	
	read_result_dim();
	read_result_data();
	for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++)
	{
		fprintf(stderr,"Result %d = %"PRId16"\n",i,*(((int16_t*)R.data_array) + i));
	}

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(conv2D);
	close_pipe_handler();
#endif
}
