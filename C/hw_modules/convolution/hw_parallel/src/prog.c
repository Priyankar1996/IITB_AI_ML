#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolveTensors.h"

//#ifndef SW
//void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
//#endif

SizedTensor_16K T,K,R;
//SizedTensor_1024 K;
uint8_t stride;

void getInput()
{
	int i;
	T.descriptor.descriptor.data_type = i16;
	K.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	K.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	K.descriptor.descriptor.number_of_dimensions = 4;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		T.descriptor.descriptor.dimensions[i] = read_uint64("conv_input_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		T.data_array[i] = read_uint64("conv_input_pipe");
	}
	for(i = 0; i < K.descriptor.descriptor.number_of_dimensions; i++)
	{
		K.descriptor.descriptor.dimensions[i] = read_uint64("conv_input_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(K) >> 2)+1; i++)
	{
		K.data_array[i] = read_uint64("conv_input_pipe");
	}
	stride = read_uint64("conv_input_pipe");
}

void sendOutput()
{
	int i;
	R.descriptor.descriptor.data_type = i16;
	R.descriptor.descriptor.row_major_form = 1;
	R.descriptor.descriptor.number_of_dimensions = 3;
	for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint64("conv_output_pipe",R.descriptor.descriptor.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(R) >> 2)+1; i++)
	{
		write_uint64("conv_output_pipe",R.data_array[i]);
	}
}

void convA()
{
	__convolveTensors__(T,K,R,stride,0,0,0);
}

void convB()
{
	__convolveTensors__(T,K,R,stride,0,1,0);
}

void convC()
{
	__convolveTensors__(T,K,R,stride,1,0,0);
}

void convD()
{
	__convolveTensors__(T,K,R,stride,1,1,0);
}

void conv2D()
{
    getInput();
    #ifndef SW
	    uint64_t start_time = timer();
    #endif
    //__convolveTensors__(T,K,R,stride);
    #ifndef SW
	    uint64_t stop_time = timer();
	    uint64_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif
    sendOutput();
}
