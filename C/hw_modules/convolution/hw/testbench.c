
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>
#include <inttypes.h>

#include "sized_tensor.h"
#include "convolveTensors.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

//
//
SizedTensor_16K T,K,R;
TensorDescriptor desc_T,desc_K,desc_R;
uint8_t stride;

#ifdef SW
DEFINE_THREAD(conv2D);
DEFINE_THREAD(convCore1);
DEFINE_THREAD(convCore2);
DEFINE_THREAD(convCore3);
DEFINE_THREAD(convCore4);
#endif

void wr_input()
{
	int i;
	for(i = 0; i < desc_T.number_of_dimensions; i++)
	{
		write_uint64("conv_input_pipe",desc_T.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_T) >> 2)+1; i++)
	{
		write_uint64("conv_input_pipe",T.data_array[i]);
	}
	for(i = 0; i < desc_K.number_of_dimensions; i++)
	{
		write_uint64("conv_input_pipe",desc_K.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_K) >> 2)+1; i++)
	{
		write_uint64("conv_input_pipe",K.data_array[i]);
	}
	write_uint64("conv_input_pipe",stride);
}


void rd_output()
{
	int i;
        for(i = 0; i < desc_R.number_of_dimensions; i++)
	{
		desc_R.dimensions[i] = read_uint64("conv_output_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_R) >> 2)+1; i++)
	{
		R.data_array[i] = read_uint64("conv_output_pipe");
	}
}


int main(int argc, char* argv[])
{
	fprintf(stderr,"Entering main testbench....\n");

        int i;

        srand(100);

	desc_T.data_type = i16;
	desc_K.data_type = i16;
	desc_T.row_major_form = 1;
	desc_K.row_major_form = 1;
	desc_T.number_of_dimensions = 3;
	desc_K.number_of_dimensions = 4;

	desc_R.number_of_dimensions = 3;

	desc_T.dimensions[0] = 6;
	desc_T.dimensions[1] = 6;
	desc_T.dimensions[2] = 3;
	desc_K.dimensions[0] = 1;
	desc_K.dimensions[1] = 3;
	desc_K.dimensions[2] = 3;
	desc_K.dimensions[3] = 3;

        for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_T) >> 2)+1; i++)
	{
		T.data_array[i] = 0x0005000500050005;
	}
        for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_K) >> 2)+1; i++)
	{
		K.data_array[i] = 0x0001000100010001;
	}
	stride = 1;
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("conv_input_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("conv_output_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("core1_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core2_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core3_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core4_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core1_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core2_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core3_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core4_ack_pipe", 1, 16, PIPE_FIFO_MODE);

	PTHREAD_DECL(conv2D);
	PTHREAD_DECL(convCore1);
	PTHREAD_DECL(convCore2);
	PTHREAD_DECL(convCore3);
	PTHREAD_DECL(convCore4);

	PTHREAD_CREATE(conv2D);
	PTHREAD_CREATE(convCore1);
	PTHREAD_CREATE(convCore2);
	PTHREAD_CREATE(convCore3);
	PTHREAD_CREATE(convCore4);
#endif

	wr_input();
	rd_output();

	fprintf(stdout,"Done.\n");
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_R) >> 2) + 1; i++)
	{
		fprintf(stderr,"Value is %llx\n",R.data_array[i]);
	}

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(conv2D);
	PTHREAD_CANCEL(convCore1);
	PTHREAD_CANCEL(convCore2);
	PTHREAD_CANCEL(convCore3);
	PTHREAD_CANCEL(convCore4);
	close_pipe_handler();
#endif
return 0;
}
