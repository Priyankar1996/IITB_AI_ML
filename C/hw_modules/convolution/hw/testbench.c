
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
uint8_t stride = 1;

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

    FILE *input_file,*kernel_file,*out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

	if ((kernel_file = fopen(argv[2],"r")) ==  NULL){
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
    	uint8_t c1,c2;
    	fscanf(input_file,"%u",&c1);
	fscanf(input_file,"%u",&c2);
	write_uint8("conv_input_pipe",c1);
	write_uint8("conv_input_pipe",c2);
	desc_T.row_major_form = (c1 << 8) + c2;
	fprintf(stderr,"Read the row major form\n");

	fscanf(input_file,"%u",&c1);
	fscanf(input_file,"%u",&c2);
	write_uint8("conv_input_pipe",c1);
	write_uint8("conv_input_pipe",c2);
	desc_T.number_of_dimensions = (c1 << 8) + c2;
	fprintf(stderr,"Read the number of dimensions\n");
	int ii;
	for (ii = 0;ii < desc_T.number_of_dimensions;ii++){
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
        	write_uint8("conv_input_pipe",var1);
		write_uint8("conv_input_pipe",var2);
		desc_T.dimensions[ii] = (var1 << 8) + var2;
		// des_inp.dimensions[ii] = var1;
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",desc_T.dimensions[0],desc_T.dimensions[1],desc_T.dimensions[2]);

	write_uint8("conv_input_pipe",stride);

	fscanf(kernel_file,"%u",&c1);
	fscanf(kernel_file,"%u",&c2);
	write_uint8("conv_input_pipe",c1);
	write_uint8("conv_input_pipe",c2);
	desc_K.row_major_form = (c1 << 8) + c2;
	fprintf(stderr,"Read the row major form %d\n",desc_K.row_major_form);

	fscanf(kernel_file,"%u",&c1);
	fscanf(kernel_file,"%u",&c2);
	write_uint8("conv_input_pipe",c1);
	write_uint8("conv_input_pipe",c2);
	desc_K.number_of_dimensions = (c1 << 8) + c2;
	fprintf(stderr,"Read the number of dimensions %d\n",desc_K.number_of_dimensions);
	for (ii = 0;ii < desc_K.number_of_dimensions;ii++){
		uint8_t var1,var2;
		fscanf(kernel_file,"%u",&var1);
		fscanf(kernel_file,"%u",&var2);
        	write_uint8("conv_input_pipe",var1);
		write_uint8("conv_input_pipe",var2);
		desc_K.dimensions[ii] = (var1 << 8) + var2;
		fprintf(stderr,"%d\n",desc_K.dimensions[ii]);
		// des_inp.dimensions[ii] = var1;
	}
	fprintf(stderr,"Read kernel descriptor %d,%d,%d,%d.\n",desc_K.dimensions[0],desc_K.dimensions[1],desc_K.dimensions[2],desc_K.dimensions[3]);

	uint64_t T_input_size = desc_T.dimensions[0]*desc_T.dimensions[1]*desc_T.dimensions[2];
	uint64_t K_input_size = desc_K.dimensions[0]*desc_K.dimensions[1]*desc_K.dimensions[2]*desc_K.dimensions[3];

	if (desc_T.data_type == i16){
		int64_t temp;
		for (ii = 0; ii < (T_input_size >> 2)+1; ii++)
		{
			temp = 0x0005000500050005;
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
			temp = 0x0001000100010001;					//Sequential data
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
