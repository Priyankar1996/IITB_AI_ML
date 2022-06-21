#define __U8 1

#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"

#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#define __dt__ int16_t

#ifdef SW
DEFINE_THREAD(convTranspose);
DEFINE_THREAD(convTransposeA);
// DEFINE_THREAD(convTransposeB);
// DEFINE_THREAD(convTransposeC);
// DEFINE_THREAD(convTransposeD);
#endif

SizedTensor_16K input,output;
TensorDescriptor desc_input,desc_output;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
    srand(time(0));

    FILE *input_file, *out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }
    
    if ((out_file = fopen("CoutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
    
    fprintf(stderr,"Defined and opened files\n");

    #ifdef SW
        init_pipe_handler();
        register_pipe ("ConvTranspose_input_pipe",2,8,PIPE_FIFO_MODE);
        register_pipe ("ConvTranspose_output_pipe",2,8,PIPE_FIFO_MODE);
		register_pipe ("Block0_start",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block1_start",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block2_start",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block3_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_done",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block1_done",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block2_done",1,16,PIPE_FIFO_MODE);
		// register_pipe ("Block3_done",1,16,PIPE_FIFO_MODE);
        PTHREAD_DECL(convTranspose);
        PTHREAD_DECL(convTransposeA);
        // PTHREAD_DECL(convTransposeB);
        // PTHREAD_DECL(convTransposeC);
        // PTHREAD_DECL(convTransposeD);	
        PTHREAD_CREATE(convTranspose);
		PTHREAD_CREATE(convTransposeA);
		// PTHREAD_CREATE(convTransposeB);
		// PTHREAD_CREATE(convTransposeC);
		// PTHREAD_CREATE(convTransposeD);
    #endif

    fprintf(stderr,"Reading files\n");
    uint16_t rand_input_data, rand_kernel_data;
	fscanf(input_file,"%hhd",&rand_input_data);
    
    //Take datatype as input
    #ifdef __U8
		desc_input.data_type = u8;
		desc_output.data_type = u8;
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
		desc_output.data_type = i16;
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

	int ii;
	for (ii = 0;ii < 3;ii++){
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
        write_uint8("ConvTranspose_input_pipe",var1);
		write_uint8("ConvTranspose_input_pipe",var2);
		desc_input.dimensions[ii] = (var1 << 8) + var2;
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",desc_input.dimensions[0],desc_input.dimensions[1],desc_input.dimensions[2]);
    
	for (ii = 0;ii < 3;ii++){
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
        write_uint8("ConvTranspose_input_pipe",var1);
		write_uint8("ConvTranspose_input_pipe",var2);
		desc_output.dimensions[ii] = (var1 << 8) + var2;
	}
	
	uint64_t input_size = desc_input.dimensions[0]*desc_input.dimensions[1]*desc_input.dimensions[2];
    
    if (desc_input.data_type == u8){
		uint8_t temp[8];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&7] = rand();	//Random data
			else temp[ii&7] = (ii+1)%128;	
			write_uint8("ConvTranspose_input_pipe",temp[ii&7]);							//Sequential data
			if ((ii&7)==7) input.data_array[ii/8] = *(uint64_t*)temp;
		}
		input.data_array[ii/8] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.\n");
	}
	fprintf(stderr,"Wrote all input values\n");
	
    fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	int size = desc_output.dimensions[0]*desc_output.dimensions[1]*desc_output.dimensions[2];
	fprintf(stderr,"Size of output is %d,%d,%d\n",desc_output.dimensions[0],desc_output.dimensions[1],desc_output.dimensions[2]);

#ifndef SW
		uint64_t time_taken;
		time_taken = read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		time_taken = (time_taken << 8) + read_uint8 ("ConvTranspose_output_pipe");
		fprintf(stderr,"Time taken is %lu\n",time_taken);
#endif

	if (desc_output.data_type == u8){
		uint8_t val;
		for (ii = 0; ii < (size); ii++)
		{
			val = read_uint8 ("ConvTranspose_output_pipe"); 			
			fprintf(stderr,"%lu,%lu\n",(ii+1),val);		
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch.\n");
	}
    fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(out_file);

    #ifdef SW
	    PTHREAD_CANCEL(convTranspose);
	    PTHREAD_CANCEL(convTransposeA);
	    // PTHREAD_CANCEL(convTransposeB);
	    // PTHREAD_CANCEL(convTransposeC);
	    // PTHREAD_CANCEL(convTransposeD);
	    close_pipe_handler();
    #endif
return 0;
}
