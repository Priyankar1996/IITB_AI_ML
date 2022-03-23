
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
#include "zero_pad.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#include "prog.h"
#else
#include "vhdlCStubs.h"
#endif


SizedTensor_16K T,R;
uint8_t pad;

#ifdef SW
DEFINE_THREAD(zeropad3D);
#endif

void wr_input()
{
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint64("zeropad_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		write_uint64("zeropad_input_pipe",T.data_array[i]);
	}
	write_uint64("zeropad_input_pipe",pad);
}


void rd_output()
{
	int i;
        for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint64("zeropad_output_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(R) >> 2)+1; i++)
	{
		R.data_array[i] = read_uint64("zeropad_output_pipe");
	}
}


int main(int argc, char* argv[])
{
	fprintf(stderr,"Entering main testbench....\n");

        int i;

        srand(100);

	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	
	R.descriptor.descriptor.number_of_dimensions = 3;

	T.descriptor.descriptor.dimensions[0] = 5;
	T.descriptor.descriptor.dimensions[1] = 5;
	T.descriptor.descriptor.dimensions[2] = 5;

    for(i = 0; i < (__NumberOfElementsInSizedTensor__(T) >> 2)+1; i++)
	{
		T.data_array[i] = i + 1;
	}
	pad = 1;
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("zeropad_input_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("zeropad_output_pipe", 2, 64, PIPE_FIFO_MODE);

	PTHREAD_DECL(zeropad3D);

	PTHREAD_CREATE(zeropad3D);
#endif

	wr_input();
	rd_output();

	fprintf(stdout,"Done.\n");

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(zeropad3D);
	close_pipe_handler();
#endif
return 0;
}
