#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
#include "zero_pad_opt.h"
 
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#ifdef SW
DEFINE_THREAD(zeropad3D);
DEFINE_THREAD(zeropad3D_A);
DEFINE_THREAD(zeropad3D_B);
DEFINE_THREAD(zeropad3D_C);
DEFINE_THREAD(zeropad3D_D);
#endif

SizedTensor_16K T,R;
uint16_t pad;

void write_input_dim(){
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++)
	{
		write_uint16("zeropad_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
}

void write_input_data(){
	int i;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++) 
	{
		write_uint16("zeropad_input_pipe",*(((int16_t*)T.data_array) + i));
	}
}

void write_pad(){
	write_uint16("zeropad_input_pipe",pad);
}


void read_result_dim(){
	int i;
	for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++)
	{
		R.descriptor.descriptor.dimensions[i] = read_uint16("zeropad_output_pipe");
	}
}

void read_result_data(){
	int i;
        for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++) 
	{
		*(((int16_t*)R.data_array) + i) = read_uint16("zeropad_output_pipe");
	}
}



int main(int argc, char* argv[])
{
	fprintf(stderr,"Entering main testbench....\n");
        int i;

        //srand(100);
	T.descriptor.descriptor.data_type = i16;
    T.descriptor.descriptor.number_of_dimensions = 3;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.dimensions[0] = 4;
	T.descriptor.descriptor.dimensions[1] = 4;
	T.descriptor.descriptor.dimensions[2] = 3;
	T.descriptor.tensor_size = T.descriptor.descriptor.dimensions[0] * T.descriptor.descriptor.dimensions[1] * T.descriptor.descriptor.dimensions[2];

    for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
	{
		//T.data_array[i] = rand();
		*(((int16_t*)T.data_array) + i) = i+1;
	}
	pad = 1;

	R.descriptor.descriptor.data_type = i16;
    R.descriptor.descriptor.number_of_dimensions = 3;
	R.descriptor.descriptor.row_major_form = 1;
    R.descriptor.descriptor.dimensions[0] = T.descriptor.descriptor.dimensions[0] + 2 * pad;
	R.descriptor.descriptor.dimensions[1] = T.descriptor.descriptor.dimensions[1] + 2 * pad;
	R.descriptor.descriptor.dimensions[2] = T.descriptor.descriptor.dimensions[2];
	R.descriptor.tensor_size = R.descriptor.descriptor.dimensions[0] * R.descriptor.descriptor.dimensions[1] * R.descriptor.descriptor.dimensions[2];
	
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("zeropad_input_pipe", 2, 16, PIPE_FIFO_MODE);
	register_pipe ("zeropad_output_pipe", 2, 16, PIPE_FIFO_MODE);
	register_pipe ("Block0_starting",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block1_starting",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block2_starting",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block3_starting",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block0_complete",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block1_complete",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block2_complete",1,16,PIPE_FIFO_MODE);
	register_pipe ("Block3_complete",1,16,PIPE_FIFO_MODE);

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
	// write_input();
	// read_result();

	write_input_dim();
	write_input_data();
	write_pad();	
	read_result_dim();
	read_result_data();

	//fprintf(stdout,"results: \n ");
	//for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++)
	//{
	//	fprintf(stdout,"R.data_array[%d] = %d\n", i, R.data_array[i]);
	//}
	//fprintf(stdout,"done\n");
	for(i = 0; i < __NumberOfElementsInSizedTensor__(R); i++)
	{
		fprintf(stderr,"Result %d = %"PRId16"\n",i,*(((int16_t*)R.data_array) + i));
	}
	fprintf(stdout,"done\n");

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(zeropad3D);
	PTHREAD_CANCEL(zeropad3D_A);
	PTHREAD_CANCEL(zeropad3D_B);
	// PTHREAD_CANCEL(zeropad3D_C);
	// PTHREAD_CANCEL(zeropad3D_D);
	close_pipe_handler();
#endif
return 0;
}
