#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "concat.h"

#ifdef SW
    #include <pipeHandler.h>
    #include <Pipes.h>
    #include <pthreadUtils.h>
#else
    #include "vhdlCStubs.h"
#endif

#define __UpdateOutputDescriptorConcatTensors__(src1,src2,output) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    desc_output.dimensions[0] = src1.dimensions[0];\
    desc_output.dimensions[1] = src1.dimensions[1] + src2.dimensions[1];\
	desc_output.dimensions[2] = src1.dimensions[2];\
})

#ifdef SW
DEFINE_THREAD(concat);
#endif

SizedTensor_16K input1,input2,output;
TensorDescriptor desc_input1,desc_input2,desc_output;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
    srand(time(0));
    FILE *input_file,*out_file;
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
        register_pipe ("Concat_input_pipe",2,8,PIPE_FIFO_MODE);
        register_pipe ("Concat_output_pipe",2,8,PIPE_FIFO_MODE);
        PTHREAD_DECL(concat);
        PTHREAD_CREATE(concat);
    #endif
    
    fprintf(stderr,"Reading files\n");
    uint8_t rand_input_data;
	fscanf(input_file,"%hhu",&rand_input_data);
	desc_input1.data_type = u8;
    desc_input2.data_type = u8;
    desc_output.data_type = u8;
    
    int ii;
	for (ii = 0;ii < 3;ii++) {
        uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
        desc_input1.dimensions[ii] = (var1<<8) + var2;
        write_uint8("Concat_input_pipe",var1);
	    write_uint8("Concat_input_pipe",var2);
	}
	fprintf(stderr,"Read input-1's descriptor %d,%d,%d.\n",desc_input1.dimensions[0],desc_input1.dimensions[1],desc_input1.dimensions[2]);
    
    for (ii = 0;ii < 3;ii++) {
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
        desc_input2.dimensions[ii] = (var1<<8) + var2;
        write_uint8("Concat_input_pipe",var1);
	    write_uint8("Concat_input_pipe",var2);	
    }
	fprintf(stderr,"Read input-2's descriptor %d,%d,%d.\n",desc_input2.dimensions[0],desc_input2.dimensions[1],desc_input2.dimensions[2]);
	__UpdateOutputDescriptorConcatTensors__(desc_input1,desc_input2,desc_output);
    for(ii = 0;ii < 3;ii++){
		write_uint8("Concat_input_pipe",desc_output.dimensions[ii]>>8);
		write_uint8("Concat_input_pipe",desc_output.dimensions[ii]);
	}
	uint32_t input1_size = desc_input1.dimensions[0]*desc_input1.dimensions[1]*desc_input1.dimensions[2];
	uint32_t input2_size = desc_input2.dimensions[0]*desc_input2.dimensions[1]*desc_input2.dimensions[2];

    uint8_t temp[8];
    for (ii = 0; ii < input1_size; ii++)
	{
		if (rand_input_data)	temp[ii&3] = rand();	//Random data
		else temp[ii&7] = (ii+1)%256;	
		write_uint8("Concat_input_pipe",temp[ii&7]);//Sequential data
		if ((ii&7)==7) input1.data_array[ii/8] = *(uint64_t*)temp;
	}
	input1.data_array[ii/8] = *(uint64_t*)temp;

    for (ii = 0; ii < input2_size; ii++)
	{
		if (rand_input_data)	temp[ii&3] = rand();	//Random data
		else temp[ii&7] = (ii+1)%256;	
		write_uint8("Concat_input_pipe",temp[ii&7]);//Sequential data
		if ((ii&7)==7) input2.data_array[ii/8] = *(uint64_t*)temp;
	}
	input2.data_array[ii/8] = *(uint64_t*)temp;
	fprintf(stderr,"Wrote all input values\n");
    fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	
    uint32_t out_size = desc_output.dimensions[0]*desc_output.dimensions[1]*desc_output.dimensions[2];
	fprintf(stderr,"Size of output is %d,%d,%d\n",desc_output.dimensions[0],desc_output.dimensions[1],desc_output.dimensions[2]);

#ifndef SW
	uint64_t time_taken;
	time_taken = read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	time_taken = (time_taken << 8) + read_uint8 ("Concat_output_pipe");
	fprintf(stderr,"Time taken is %lu\n",time_taken);
#endif

    uint8_t val;
    for(ii = 0; ii < out_size; ii++)
    {
        val = read_uint8 ("Concat_output_pipe");
        fprintf(stderr,"%lu\n",val);
    }
    fprintf(stderr,"Read back the values from hardware\n");
	fclose(input_file);
	fclose(out_file);

    #ifdef SW
	    PTHREAD_CANCEL(concat);
        close_pipe_handler();
    #endif
    return 0;
}





