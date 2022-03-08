#define __I16 1

#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "unaryfn.h"

#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#define __UpdateOutputDescriptor__(src,output) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    output.data_type = src.data_type;\
    output.number_of_dimensions = src.number_of_dimensions;\
	int ji;\
    output.row_major_form = src.row_major_form;\
    output.dimensions[0] = src.dimensions[0];\
    output.dimensions[1] = src.dimensions[1];\
	output.dimensions[2] = src.dimensions[2];\
})

#define __dt__ int16_t

#ifdef SW
DEFINE_THREAD(unaryOperate);
DEFINE_THREAD(unaryOperateA);
DEFINE_THREAD(unaryOperateB);
DEFINE_THREAD(unaryOperateC);
DEFINE_THREAD(unaryOperateD);
#endif

SizedTensor_16K input,output;
TensorDescriptor desc_input,desc_output;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
    srand(time(0));

    FILE *input_file, *in_data, *out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }
    
	if ((in_data = fopen("Indata.txt","w")) == NULL){
		fprintf(stderr,"Input data File error\n");
		exit(-1);
	}

    if ((out_file = fopen("Outdata.txt","w")) == NULL){
		fprintf(stderr,"Output data File error\n");
		exit(-1);
	}
    
    fprintf(stderr,"Defined and opened files\n");

    #ifdef SW
        init_pipe_handler();
        register_pipe ("UnaryOperate_input_pipe",2,16,PIPE_FIFO_MODE);
        register_pipe ("UnaryOperate_output_pipe",2,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_start",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_done",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_done",1,16,PIPE_FIFO_MODE);
        PTHREAD_DECL(unaryOperate);
        PTHREAD_DECL(unaryOperateA);
        PTHREAD_DECL(unaryOperateB);
        PTHREAD_DECL(unaryOperateC);
        PTHREAD_DECL(unaryOperateD);	
        PTHREAD_CREATE(unaryOperate);
		PTHREAD_CREATE(unaryOperateA);
		PTHREAD_CREATE(unaryOperateB);
		PTHREAD_CREATE(unaryOperateC);
		PTHREAD_CREATE(unaryOperateD);
    #endif

    fprintf(stderr,"Reading files\n");
    uint16_t rand_input_data;
	fscanf(input_file,"%hhd",&rand_input_data);
    
    //Take datatype as input
    #ifdef __U8
		desc_input.data_type = u8;
	#endif
	#ifdef __U16
		desc_input.data_type = u16;
	#endif
	#ifdef __U32
		desc_input.data_type = u32;
	#endif
	#ifdef __U64
		desc_input.data_type = u64;
	#endif
	#ifdef __I8
		desc_input.data_type = i8;
	#endif
	#ifdef __I16
		desc_input.data_type = i16;
	#endif
	#ifdef __I32
		desc_input.data_type = i32;
	#endif
	#ifdef __I64
		desc_input.data_type = i64;
	#endif
	#ifdef __F8
		desc_input.data_type = float8;
	#endif
	#ifdef __F16
        desc_input.data_type = float16;
	#endif
	#ifdef __F32
		desc_input.data_type = float32;
	#endif
	#ifdef __F64
		desc_input.data_type = float64;
	#endif

    fscanf(input_file,"%hhd",&desc_input.row_major_form);
	write_uint16("UnaryOperate_input_pipe",desc_input.row_major_form);
    fscanf(input_file,"%d",&desc_input.number_of_dimensions);
	write_uint16("UnaryOperate_input_pipe",desc_input.number_of_dimensions);
	int ii;
	for (ii = 0;ii < desc_input.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&desc_input.dimensions[ii]);
        write_uint16("UnaryOperate_input_pipe",desc_input.dimensions[ii]);
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",desc_input.dimensions[0],desc_input.dimensions[1],desc_input.dimensions[2]);
	
    __UpdateOutputDescriptor__(desc_input,desc_output);

	for(ii = 0;ii < 3;ii++){
		write_uint16("UnaryOperate_input_pipe",desc_output.dimensions[ii]);
	}

	uint64_t input_size = desc_input.dimensions[0]*desc_input.dimensions[1]*desc_input.dimensions[2];

    if (desc_input.data_type == i16){
		__dt__ temp[4];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;	
			write_uint16("UnaryOperate_input_pipe",temp[ii&3]);
			fprintf(in_data,"%hd\n",temp[ii&3]);				//Sequential data
			if ((ii&3)==3) input.data_array[ii/4] = *(uint64_t*)temp;
		}
		input.data_array[ii/4] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.\n");
	}
	fprintf(stderr,"Wrote all input values\n");
	
    fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	int size = desc_output.dimensions[0]*desc_output.dimensions[1]*desc_output.dimensions[2];

	fprintf(stderr,"Size of output is %d,%d,%d\n",desc_output.dimensions[0],desc_output.dimensions[1],desc_output.dimensions[2]);

	if (desc_output.data_type == i16)
    {
		__dt__ val;
		for (ii = 0; ii < (size); ii++)
		{
			val = read_uint16 ("UnaryOperate_output_pipe");
			fprintf(out_file,"%hd\n",val);		
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch.\n");
	}
    fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(in_data);
	fclose(out_file);

	#ifndef SW
		uint64_t time_taken = read_uint64("elapsed_time_pipe");
		fprintf(stderr,"Time taken is %lu\n",time_taken);
	#endif

	if ((in_data = fopen("Indata.txt","r")) == NULL){
		fprintf(stderr,"Input data File error\n");
		exit(-1);
	}

    if ((out_file = fopen("Outdata.txt","r")) == NULL){
		fprintf(stderr,"Output data File error\n");
		exit(-1);
	}

	fprintf(stderr,"Any data mismatch message will be printed next line onwards.\n");
	__dt__ in_value,out_value;
	for(ii = 0; ii < size; ii++)
	{
		fscanf(in_data,"%hd\n",&in_value);
		fscanf(out_file,"%hd\n",&out_value);
		if(in_value < 0)
		{
			if(out_value!=0)
				fprintf(stderr,"Output mismatch at input:%d\n",ii);
		}
		else
		{
			if(out_value != in_value)
				fprintf(stderr,"Output mismatch at input:%d\n",ii);
		}
	}

    #ifdef SW
	    PTHREAD_CANCEL(unaryOperate);
	    PTHREAD_CANCEL(unaryOperateA);
	    PTHREAD_CANCEL(unaryOperateB);
	    PTHREAD_CANCEL(unaryOperateC);
	    PTHREAD_CANCEL(unaryOperateD);
	    close_pipe_handler();
    #endif
return 0;
}
