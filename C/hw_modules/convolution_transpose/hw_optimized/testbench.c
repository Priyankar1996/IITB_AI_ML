#define __I16 1

#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "convolution_transpose_improved.h"

#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#define __UpdateOutputDescriptorConvTransTensors__(src,kernel,stride0,stride1,padding,output) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    desc_output.data_type = src.data_type;\
    desc_output.number_of_dimensions = src.number_of_dimensions;\
	int ji;\
    desc_output.row_major_form = src.row_major_form;\
    desc_output.dimensions[0] = (src.dimensions[0])*stride0 + desc_kernel.dimensions[1] - 1 - (2*padding);\
    desc_output.dimensions[1] = (src.dimensions[1])*stride1 + desc_kernel.dimensions[2] - 1 - (2*padding);\
	desc_output.dimensions[desc_output.number_of_dimensions-1] = src.dimensions[src.number_of_dimensions-1];\
})

#define __dt__ int16_t

#ifdef SW
DEFINE_THREAD(convTranspose);
DEFINE_THREAD(convTransposeA);
DEFINE_THREAD(convTransposeB);
DEFINE_THREAD(convTransposeC);
DEFINE_THREAD(convTransposeD);
#endif

SizedTensor_16K input,output;
SizedTensor_1024 kernel;
TensorDescriptor desc_input,desc_kernel,desc_output;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
    srand(time(0));

    FILE *input_file,*param_file, *kernel_file, *out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

    if ((kernel_file = fopen(argv[2],"r")) ==  NULL){
        fprintf(stderr,"Input kernel file error\n");
        exit(-1);
    }

    if ((param_file = fopen(argv[3],"r")) == NULL){
        fprintf(stderr,"Parameters File Error\n");
        exit(-1);
    }
    
    if ((out_file = fopen("CoutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
    
    fprintf(stderr,"Defined and opened files\n");

    #ifdef SW
        init_pipe_handler();
        register_pipe ("ConvTranspose_input_pipe",2,16,PIPE_FIFO_MODE);
        register_pipe ("ConvTranspose_output_pipe",2,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_done",1,16,PIPE_FIFO_MODE);
        PTHREAD_DECL(convTranspose);
        PTHREAD_DECL(convTransposeA);
        PTHREAD_DECL(convTransposeB);
        PTHREAD_DECL(convTransposeC);
        PTHREAD_DECL(convTransposeD);	
        PTHREAD_CREATE(convTranspose);
		PTHREAD_CREATE(convTransposeA);
		PTHREAD_CREATE(convTransposeB);
		PTHREAD_CREATE(convTransposeC);
		PTHREAD_CREATE(convTransposeD);
    #endif

    fprintf(stderr,"Reading files\n");
    uint16_t rand_input_data, rand_kernel_data;
	fscanf(input_file,"%hhd",&rand_input_data);
	fscanf(kernel_file,"%hhd",&rand_kernel_data);
    
    //Take datatype as input
    #ifdef __U8
		desc_input.data_type = u8;
        desc_kernel.data_type = u8;
	#endif
	#ifdef __U16
		desc_input.data_type = u16;
        desc_kernel.data_type = u16;
	#endif
	#ifdef __U32
		desc_input.data_type = u32;
        desc_kernel.data_type = u32;
	#endif
	#ifdef __U64
		desc_input.data_type = u64;
        desc_kernel.data_type = u64;
	#endif
	#ifdef __I8
		desc_input.data_type = i8;
        desc_kernel.data_type = i8;
	#endif
	#ifdef __I16
		desc_input.data_type = i16;
		desc_kernel.data_type = i16;
	#endif
	#ifdef __I32
		desc_input.data_type = i32;
        desc_kernel.data_type = i32;
	#endif
	#ifdef __I64
		desc_input.data_type = i64;
        desc_kernel.data_type = i64;
	#endif
	#ifdef __F8
		desc_input.data_type = float8;
        desc_kernel.data_type = float8;
	#endif
	#ifdef __F16
        desc_input.data_type = float16;
        desc_kernel.data_type = float16;
	#endif
	#ifdef __F32
		desc_input.data_type = float32;
        desc_kernel.data_type = float32;
	#endif
	#ifdef __F64
		desc_input.data_type = float64;
        desc_kernel.data_type = float64;
	#endif

    fscanf(input_file,"%hhd",&desc_input.row_major_form);
	write_uint16("ConvTranspose_input_pipe",desc_input.row_major_form);
    fscanf(input_file,"%d",&desc_input.number_of_dimensions);
	write_uint16("ConvTranspose_input_pipe",desc_input.number_of_dimensions);
	int ii;
	for (ii = 0;ii < desc_input.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&desc_input.dimensions[ii]);
        write_uint16("ConvTranspose_input_pipe",desc_input.dimensions[ii]);
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",desc_input.dimensions[0],desc_input.dimensions[1],desc_input.dimensions[2]);

	fscanf(kernel_file,"%hhd",&desc_kernel.row_major_form);
	write_uint16("ConvTranspose_input_pipe",desc_kernel.row_major_form);
	fscanf(kernel_file,"%d",&desc_kernel.number_of_dimensions);
	write_uint16("ConvTranspose_input_pipe",desc_kernel.number_of_dimensions);

	for (ii = 0;ii < desc_kernel.number_of_dimensions;ii++){
		fscanf(kernel_file,"%d",&desc_kernel.dimensions[ii]);
        write_uint16("ConvTranspose_input_pipe",desc_kernel.dimensions[ii]);
	}
	fprintf(stderr,"Read kernel descriptor %d,%d,%d,%d.\n",desc_kernel.dimensions[0],desc_kernel.dimensions[1],desc_kernel.dimensions[2],desc_kernel.dimensions[3]);

    uint16_t stride[3];

    for(ii = 0;ii < 3;ii++){
		fscanf(param_file,"%d",&stride[ii]);
        write_uint16("ConvTranspose_input_pipe",stride[ii]);
	}
	fprintf(stderr,"Read stride values: %d,%d.\n",stride[0],stride[1]);
	fprintf(stderr,"Read pad value:%d\n",stride[2]);
	__UpdateOutputDescriptorConvTransTensors__(desc_input,desc_kernel,stride[0],stride[1],stride[2],desc_output);
    
	for(ii = 0;ii < 3;ii++){
		write_uint16("ConvTranspose_input_pipe",desc_output.dimensions[ii]);
	}

	uint64_t input_size = desc_input.dimensions[0]*desc_input.dimensions[1]*desc_input.dimensions[2];
    uint64_t kernel_size = desc_kernel.dimensions[0]*desc_kernel.dimensions[1]*desc_kernel.dimensions[2]*desc_kernel.dimensions[3];

    if (desc_input.data_type == i16){
		__dt__ temp[4];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;	
			write_uint16("ConvTranspose_input_pipe",temp[ii&3]);
			//fprintf(stderr,"%d\n",temp[ii&3]);				//Sequential data
			if ((ii&3)==3) input.data_array[ii/4] = *(uint64_t*)temp;
		}
		input.data_array[ii/4] = *(uint64_t*)temp;
		
		for (ii = 0; ii < kernel_size; ii++)
		{
			if (rand_kernel_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;					//Sequential data
			write_uint16("ConvTranspose_input_pipe",temp[ii&3]);
			if ((ii&3)==3) kernel.data_array[ii/4] = *(uint64_t*)temp;
		}
		kernel.data_array[ii/4] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.\n");
	}
	fprintf(stderr,"Wrote all input values\n");
	
    fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	int size = desc_output.dimensions[0]*desc_output.dimensions[1]*desc_output.dimensions[2];
	fprintf(stderr,"Size of output is %d,%d,%d\n",desc_output.dimensions[0],desc_output.dimensions[1],desc_output.dimensions[2]);

	if (desc_output.data_type == i16){
		__dt__ val;
		for (ii = 0; ii < (size); ii++)
		{
			val = read_uint16 ("ConvTranspose_output_pipe");
			fprintf(stderr,"%lu\n",val);		
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch.\n");
	}
    fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(param_file);
    fclose(kernel_file);
	fclose(out_file);

	#ifndef SW
		uint64_t time_taken = read_uint64("elapsed_time_pipe");
		fprintf(stderr,"Time taken is %lu\n",time_taken);
	#endif

    #ifdef SW
	    PTHREAD_CANCEL(convTranspose);
	    PTHREAD_CANCEL(convTransposeA);
	    PTHREAD_CANCEL(convTransposeB);
	    PTHREAD_CANCEL(convTransposeC);
	    PTHREAD_CANCEL(convTransposeD);
	    close_pipe_handler();
    #endif
return 0;
}
