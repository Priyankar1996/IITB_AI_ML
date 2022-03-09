#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad.h"

SizedTensor_16K T,R;
uint8_t pad;

void getInput()
{
	int i;
	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		T.descriptor.descriptor.dimensions[i] = read_uint64("zeropad_input_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		T.data_array[i] = read_uint64("zeropad_input_pipe");
	}
	pad = read_uint64("zeropad_input_pipe");
}

void sendOutput()
{
	int i;
	R.descriptor.descriptor.data_type = i16;
	R.descriptor.descriptor.row_major_form = 1;
	R.descriptor.descriptor.number_of_dimensions = 3;
	for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint64("zeropad_output_pipe",R.descriptor.descriptor.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(R) >> 2)+1; i++)
	{
		write_uint64("zeropad_output_pipe",R.data_array[i]);
	}
}

void zeropad3D()
{
    getInput();
    #ifndef SW
	    uint64_t start_time = timer();
    #endif
    __convolveTensors__(T,R,pad);
    #ifndef SW
	    uint64_t stop_time = timer();
	    uint64_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif
    sendOutput();
}
