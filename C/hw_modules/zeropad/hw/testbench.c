#define __I16 1
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "zero_pad.h"

#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#define __UpdateOutputDescriptorConvTransTensors__(src,pad,output) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    output.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
    output.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
	int ji;\
    output.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
    output.descriptor.descriptor.dimensions[0] = (src.descriptor.descriptor.dimensions[0]) + (2*pad);\
    output.descriptor.descriptor.dimensions[1] = (src.descriptor.descriptor.dimensions[1]) + (2*pad);\
	output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
	output.descriptor.tensor_size = output.descriptor.descriptor.dimensions[0] * output.descriptor.descriptor.dimensions[1] * output.descriptor.descriptor.dimensions[2];\
})

#define __dt__ int16_t

#ifdef SW
DEFINE_THREAD(zeropad_thread);
#endif

SizedTensor_16K input,output;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
    srand(time(0));

    FILE *input_file,*param_file,*out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

	if ((param_file = fopen(argv[2],"r")) == NULL){
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
        register_pipe ("ZeroPad_input_pipe",2,16,PIPE_FIFO_MODE);
        register_pipe ("ZeroPad_output_pipe",2,16,PIPE_FIFO_MODE);

        PTHREAD_DECL(zeropad_thread);
        PTHREAD_CREATE(zeropad_thread);
    #endif

    fprintf(stderr,"Reading files\n");
	uint16_t rand_input_data;
	fscanf(input_file,"%hhd",&rand_input_data);

    //Take datatype as input
    #ifdef __U8
		input.descriptor.descriptor.data_type = u8;
	#endif
	#ifdef __U16
		input.descriptor.descriptor.data_type = u16;
	#endif
	#ifdef __U32
		input.descriptor.descriptor.data_type = u32;
	#endif
	#ifdef __U64
		input.descriptor.descriptor.data_type = u64;
	#endif
	#ifdef __I8
		input.descriptor.descriptor.data_type = i8;
	#endif
	#ifdef __I16
		input.descriptor.descriptor.data_type = i16;
	#endif
	#ifdef __I32
		input.descriptor.descriptor.data_type = i32;
	#endif
	#ifdef __I64
		input.descriptor.descriptor.data_type = i64;
	#endif
	#ifdef __F8
		input.descriptor.descriptor.data_type = float8;
	#endif
	#ifdef __F16
        input.descriptor.descriptor.data_type = float16;
	#endif
	#ifdef __F32
		input.descriptor.descriptor.data_type = float32;
	#endif
	#ifdef __F64
		input.descriptor.descriptor.data_type = float64;
	#endif

    fscanf(input_file,"%hhd",&input.descriptor.descriptor.row_major_form);
    write_uint16("ZeroPad_input_pipe",input.descriptor.descriptor.row_major_form);
	fscanf(input_file,"%d",&input.descriptor.descriptor.number_of_dimensions);
	write_uint16("ZeroPad_input_pipe",input.descriptor.descriptor.number_of_dimensions);
	int ii;
	for (ii = 0;ii < input.descriptor.descriptor.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&input.descriptor.descriptor.dimensions[ii]);
        write_uint16("ZeroPad_input_pipe",input.descriptor.descriptor.dimensions[ii]);

	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",input.descriptor.descriptor.dimensions[0],input.descriptor.descriptor.dimensions[1],input.descriptor.descriptor.dimensions[2]);
	input.descriptor.tensor_size = __NumberOfElementsInSizedTensor__(input);
	
	// Entering the padding size that needs to be done
	uint16_t pad;
	fscanf(param_file,"%d",&pad);
	write_uint16("ZeroPad_input_pipe",pad);
	
	

	fprintf(stderr,"Read pad value:%d\n",pad);
	__UpdateOutputDescriptorConvTransTensors__(input,pad,output);
    
	for(ii = 0;ii < 3;ii++){
		write_uint16("ZeroPad_input_pipe",output.descriptor.descriptor.dimensions[ii]);
	}

    uint64_t input_size = __NumberOfElementsInSizedTensor__(input);

	if (input.descriptor.descriptor.data_type == i16){
		__dt__ temp[4];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;	
			write_uint16("ZeroPad_input_pipe",temp[ii&3]);
			//fprintf(stderr,"%d\n",temp[ii&3]);				//Sequential data
			if ((ii&3)==3) input.data_array[ii/4] = *(uint64_t*)temp;
		}
		input.data_array[ii/4] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.\n");
	}


    fprintf(stderr,"Reading the output values from hardware\n");
    fprintf(out_file,"\n");
	int size = __NumberOfElementsInSizedTensor__(output);
	fprintf(stderr,"Size of output is %d,%d,%d\n",output.descriptor.descriptor.dimensions[0],output.descriptor.descriptor.dimensions[1],output.descriptor.descriptor.dimensions[2]);
	
	if (output.descriptor.descriptor.data_type == i16){
		uint16_t val;
		for (ii = 0; ii < size; ii++)
		{
			val = read_uint16("ZeroPad_output_pipe");
			fprintf(stderr,"%lu\n",val);
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch. \n");
	}
    fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(param_file);
	fclose(out_file);

	#ifndef SW
		uint64_t time_taken = read_uint64("elapsed_time_pipe");
		fprintf(stderr,"Time taken is %lu\n",time_taken);
	#endif

    #ifdef SW
	    PTHREAD_CANCEL(zeropad_thread);
	    close_pipe_handler();
    #endif
return 0;
}
