
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>
#include <inttypes.h>

#include "sized_tensor.h"
#include "zero_pad_opt.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

//
//
SizedTensor_16K T,R;
TensorDescriptor desc_T,desc_R;
uint8_t pad;

#ifdef SW
DEFINE_THREAD(zeropad3D);
DEFINE_THREAD(zeropad3D_A);
DEFINE_THREAD(zeropad3D_B);
DEFINE_THREAD(zeropad3D_C);
DEFINE_THREAD(zeropad3D_D);
#endif

void wr_input()
{
	int i;
	for(i = 0; i < desc_T.number_of_dimensions; i++)
	{
		write_uint64("zeropad_input_pipe",desc_T.dimensions[i]);
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_T) >> 2)+1; i++)
	{
		write_uint64("zeropad_input_pipe",T.data_array[i]);
	}
	write_uint64("zeropad_input_pipe",pad);
}


void rd_output()
{
	int i;
        for(i = 0; i < desc_R.number_of_dimensions; i++)
	{
		desc_R.dimensions[i] = read_uint64("zeropad_output_pipe");
	}
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_R) >> 2)+1; i++)
	{
		R.data_array[i] = read_uint64("zeropad_output_pipe");
	}
}


int main(int argc, char* argv[])
{
	fprintf(stderr,"Entering main testbench....\n");

        int i;

        srand(100);

	desc_T.data_type = i16;
	desc_T.row_major_form = 1;
	desc_T.number_of_dimensions = 3;
	desc_R.number_of_dimensions = 3;

	desc_T.dimensions[0] = 6;
	desc_T.dimensions[1] = 6;
	desc_T.dimensions[2] = 3;

        for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_T) >> 2)+1; i++)
	{
		T.data_array[i] = i+1;
		fprintf(stderr,"Value of input %d is %llx\n",i,T.data_array[i]);
	}
	pad = 1;
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("zeropad_input_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("zeropad_output_pipe", 2, 64, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_A_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_B_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_C_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_D_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_A_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_B_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_C_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad3D_D_ack_pipe", 1, 16, PIPE_FIFO_MODE);

	PTHREAD_DECL(zeropad3D);
	PTHREAD_DECL(zeropad3D_A);
	PTHREAD_DECL(zeropad3D_B);
	PTHREAD_DECL(zeropad3D_C);
	PTHREAD_DECL(zeropad3D_D);

	PTHREAD_CREATE(zeropad3D);
	PTHREAD_CREATE(zeropad3D_A);
	PTHREAD_CREATE(zeropad3D_B);
	PTHREAD_CREATE(zeropad3D_C);
	PTHREAD_CREATE(zeropad3D_D);
#endif

	wr_input();
	rd_output();

	fprintf(stdout,"Done.\n");
	for(i = 0; i < (__NumberOfElementsInSizedTensor__(desc_R) >> 2) + 1; i++)
	{
		fprintf(stderr,"Value of %d element is %llx\n",i,R.data_array[i]);
	}

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(zeropad3D);
	PTHREAD_CANCEL(zeropad3D_A);
	PTHREAD_CANCEL(zeropad3D_B);
	PTHREAD_CANCEL(zeropad3D_C);
	PTHREAD_CANCEL(zeropad3D_D);
	close_pipe_handler();
#endif
return 0;
}
