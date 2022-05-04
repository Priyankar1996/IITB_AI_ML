
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
DEFINE_THREAD(convCore5);
#endif

#define __set8xi8__(addr) ({\
	uint64_t element = 0x0005000500050005;\
	uint8_t out_data[8];\
	out_data[7] = element & 0xFF;\
	element>>=8;\
	out_data[6] = element & 0xFF;\
	element>>=8;\
	out_data[5]= element & 0xFF;\
	element>>=8;\
    	out_data[4] = element & 0xFF;\
	element>>=8;\
	out_data[3] = element & 0xFF;\
	element>>=8;\
	out_data[2] = element & 0xFF;\
	element>>=8;\
    	out_data[1] = element & 0xFF;\
	element>>=8;\
	out_data[0] = element & 0xFF;\
	write_uint8 ("conv_output_pipe",out_data[0]);\
	write_uint8 ("conv_output_pipe",out_data[1]);\
	write_uint8 ("conv_output_pipe",out_data[2]);\
	write_uint8 ("conv_output_pipe",out_data[3]);\
    	write_uint8 ("conv_output_pipe",out_data[4]);\
	write_uint8 ("conv_output_pipe",out_data[5]);\
	write_uint8 ("conv_output_pipe",out_data[6]);\
	write_uint8 ("conv_output_pipe",out_data[7]);\
})



#define __get8xi8__(element) ({\
	element = read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
    	element = (element << 8) + read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
	element = (element << 8) + read_uint8 ("conv_input_pipe");\
})

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
	srand(time(0));

    FILE *input_file,*kernel_file,*stride_file,*out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

    if ((stride_file = fopen(argv[2],"r")) ==  NULL){
        fprintf(stderr,"Stride file error\n");
        exit(-1);
    }

	if ((kernel_file = fopen(argv[3],"r")) ==  NULL){
        fprintf(stderr,"Kernel file error\n");
        exit(-1);
    }
    
    if ((out_file = fopen("out_file.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
    
    fprintf(stderr,"Defined and opened files\n");

#ifdef SW
	init_pipe_handler();
	register_pipe ("conv_input_pipe", 2, 8, PIPE_FIFO_MODE);
	register_pipe ("conv_output_pipe", 2, 8, PIPE_FIFO_MODE);
	register_pipe ("core1_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core2_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core3_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core4_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core1_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core2_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core3_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core4_ack_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core5_req_pipe", 1, 16, PIPE_FIFO_MODE);
	register_pipe ("core5_ack_pipe", 1, 16, PIPE_FIFO_MODE);

	PTHREAD_DECL(conv2D);
	PTHREAD_DECL(convCore1);
	PTHREAD_DECL(convCore2);
	PTHREAD_DECL(convCore3);
	PTHREAD_DECL(convCore4);
	PTHREAD_DECL(convCore5);

	PTHREAD_CREATE(conv2D);
	PTHREAD_CREATE(convCore1);
	PTHREAD_CREATE(convCore2);
	PTHREAD_CREATE(convCore3);
	PTHREAD_CREATE(convCore4);
	PTHREAD_CREATE(convCore5);
#endif

	desc_T.data_type = i16;
	desc_K.data_type = i16;
	desc_R.data_type = i16;

	fprintf(stderr,"Reading files\n");
    	uint16_t rand_input_data;
	fscanf(input_file,"%hhd",&rand_input_data);
	uint16_t rand_kernel_data;
	fscanf(kernel_file,"%hhd",&rand_kernel_data);

	fscanf(input_file,"%hhd",&desc_T.row_major_form);
	write_uint8("conv_input_pipe",desc_T.row_major_form);
    	fscanf(input_file,"%d",&desc_T.number_of_dimensions);
	write_uint8("conv_input_pipe",desc_T.number_of_dimensions);
	int ii;
	for (ii = 0;ii < desc_T.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&desc_T.dimensions[ii]);
        	write_uint8("conv_input_pipe",desc_T.dimensions[ii]);
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",desc_T.dimensions[0],desc_T.dimensions[1],desc_T.dimensions[2]);

	fscanf(stride_file,"%d",&stride);
	write_uint8("conv_input_pipe",stride);

	fscanf(kernel_file,"%hhd",&desc_K.row_major_form);
	write_uint8("conv_input_pipe",desc_K.row_major_form);
    	fscanf(kernel_file,"%d",&desc_K.number_of_dimensions);
	write_uint8("conv_input_pipe",desc_K.number_of_dimensions);
	for (ii = 0;ii < desc_K.number_of_dimensions;ii++){
		fscanf(kernel_file,"%d",&desc_K.dimensions[ii]);
        	write_uint8("conv_input_pipe",desc_K.dimensions[ii]);
	}
	fprintf(stderr,"Read kernel descriptor %d,%d,%d,%d.\n",desc_K.dimensions[0],desc_K.dimensions[1],desc_K.dimensions[2],desc_K.dimensions[3]);

	uint64_t T_input_size = desc_T.dimensions[0]*desc_T.dimensions[1]*desc_T.dimensions[2];
	uint64_t K_input_size = desc_K.dimensions[0]*desc_K.dimensions[1]*desc_K.dimensions[2]*desc_K.dimensions[3];

	if (desc_T.data_type == i16){
		int64_t temp;
		for (ii = 0; ii < (T_input_size >> 2)+1; ii++)
		{
			if (rand_input_data)	temp = rand();	//Random data
			else temp = 0x0005000500050005;
			write_uint8("conv_input_pipe",(temp>>56));	
			write_uint8("conv_input_pipe",(temp>>48));
			write_uint8("conv_input_pipe",(temp>>40));
			write_uint8("conv_input_pipe",(temp>>32));
			write_uint8("conv_input_pipe",(temp>>24));
			write_uint8("conv_input_pipe",(temp>>16));
			write_uint8("conv_input_pipe",(temp>>8));
			write_uint8("conv_input_pipe",temp);
		}
		
		for (ii = 0; ii < (K_input_size >> 2)+1; ii++)
		{
			if (rand_kernel_data)	temp = rand();	//Random data
			else temp = 0x0001000100010001;					//Sequential data
			write_uint8("conv_input_pipe",(temp>>56));	
			write_uint8("conv_input_pipe",(temp>>48));
			write_uint8("conv_input_pipe",(temp>>40));
			write_uint8("conv_input_pipe",(temp>>32));
			write_uint8("conv_input_pipe",(temp>>24));
			write_uint8("conv_input_pipe",(temp>>16));
			write_uint8("conv_input_pipe",(temp>>8));
			write_uint8("conv_input_pipe",temp);
		}
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch in input.\n");
	}
	fprintf(stderr,"Wrote all input values\n");

	fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	desc_R.dimensions[0] = read_uint8 ("conv_output_pipe");
	desc_R.dimensions[1] = read_uint8 ("conv_output_pipe");
	desc_R.dimensions[2] = read_uint8 ("conv_output_pipe");
	int size = desc_R.dimensions[0]*desc_R.dimensions[1]*desc_R.dimensions[2];
	fprintf(stderr,"Size of output is %d,%d,%d\n",desc_R.dimensions[0],desc_R.dimensions[1],desc_R.dimensions[2]);

	if (desc_R.data_type == i16){
		int64_t val;
		for (ii = 0; ii < (size >> 2)+1; ii++)
		{
			val = ((uint64_t)(read_uint8 ("conv_output_pipe")) << 56) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 48) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 40) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 32) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 24) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 16) + ((uint64_t)(read_uint8 ("conv_output_pipe")) << 8) + ((uint64_t)(read_uint8("conv_output_pipe")));
			fprintf(stderr,"Output = 0x%"PRIx64" \n",val);		
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch in output.\n");
	}
	fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(kernel_file);
	fclose(stride_file);
	fclose(out_file);

	#ifndef SW
		uint64_t time_taken = read_uint64("elapsed_time_pipe");
		fprintf(stderr,"Time taken is %lu\n",time_taken);
	#endif

	#ifdef SW
	PTHREAD_CANCEL(conv2D);
	PTHREAD_CANCEL(convCore1);
	PTHREAD_CANCEL(convCore2);
	PTHREAD_CANCEL(convCore3);
	PTHREAD_CANCEL(convCore4);
	PTHREAD_CANCEL(convCore5);
	close_pipe_handler();
	#endif
	return 0;
}
