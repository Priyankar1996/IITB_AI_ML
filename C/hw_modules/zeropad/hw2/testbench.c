#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
#include "zero_pad.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#ifdef SW
DEFINE_THREAD(zeropad3D);
#endif

SizedTensor_16K T,R;
uint16_t pad = 1;

void write_input()
{
	for(int i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("zeropad_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
        for(int i = 0; i < __NumberOfElementsInSizedTensor__(T); i++) 
	{
		write_uint16("zeropad_input_pipe",T.data_array[i]);
	}
	fprintf(stderr,"Sent T.\n");
}

void write_pad()
{
	write_uint16("zeropad_input_pipe",pad);
}


void read_result()
{
	for(int i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint16("zeropad_output_pipe");
	}
        for(int i = 0; i < __NumberOfElementsInSizedTensor__(R); i++) 
	{
		R.data_array[i] = read_uint16("zeropad_output_pipe");
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

    for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
	{
		T.data_array[i] = rand();
	}
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("zeropad_input_pipe", 2, 32, PIPE_FIFO_MODE);
	register_pipe ("zeropad_output_pipe", 2, 32, PIPE_FIFO_MODE);

	PTHREAD_DECL(zeropad3D);

	PTHREAD_CREATE(zeropad3D);
#endif
	write_input();
	write_pad();
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
	PTHREAD_CANCEL(zeropad3D);
	close_pipe_handler();
	return 0;
#endif
}
