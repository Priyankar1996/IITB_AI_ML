#define __I16 1

#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "zero_pad_opt.h"

#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#define __UpdateOutputDescriptorZeropadTensors__(T,pad,R) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    des_out.data_type = T.data_type;\
    des_out.number_of_dimensions = T.number_of_dimensions;\
	int ji;\
    des_out.row_major_form = T.row_major_form;\
    des_out.dimensions[0] = T.dimensions[0] + 2*pad;\
    des_out.dimensions[1] = T.dimensions[1] + 2*pad;\
	des_out.dimensions[des_out.number_of_dimensions-1] = T.dimensions[T.number_of_dimensions-1];\
})

#define __dt__ int16_t

#ifdef SW
DEFINE_THREAD(zeropad3D);
DEFINE_THREAD(zeropad3D_A);
DEFINE_THREAD(zeropad3D_B);
DEFINE_THREAD(zeropad3D_C);
DEFINE_THREAD(zeropad3D_D);
DEFINE_THREAD(zeropad3D_E);
DEFINE_THREAD(zeropad3D_F);
DEFINE_THREAD(zeropad3D_G);
DEFINE_THREAD(zeropad3D_H);
#endif

SizedTensor_16K T,R;
uint8_t pad;
TensorDescriptor des_inp,des_out;

int main(int argc,char **argv)
{
    fprintf(stderr,"Entering testbench main program\n");
	srand(time(0));

    FILE *input_file,*param_file, *out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

    if ((param_file = fopen(argv[2],"r")) ==  NULL){
        fprintf(stderr,"Input parameter file error\n");
        exit(-1);
    }
    
    if ((out_file = fopen("CoutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
    
    fprintf(stderr,"Defined and opened files\n");

    #ifdef SW
        init_pipe_handler();
        register_pipe ("zeropad_input_pipe",2,8,PIPE_FIFO_MODE);
        register_pipe ("zeropad_output_pipe",2,8,PIPE_FIFO_MODE);
		register_pipe ("Block0_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block0_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block1_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block2_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block3_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block4_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block4_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block5_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block5_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block6_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block6_complete",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block7_starting",1,16,PIPE_FIFO_MODE);
		register_pipe ("Block7_complete",1,16,PIPE_FIFO_MODE);

        
		PTHREAD_DECL(zeropad3D);
		PTHREAD_DECL(zeropad3D_A);
		PTHREAD_DECL(zeropad3D_B);
		PTHREAD_DECL(zeropad3D_C);
		PTHREAD_DECL(zeropad3D_D);
		PTHREAD_DECL(zeropad3D_E);
		PTHREAD_DECL(zeropad3D_F);
		PTHREAD_DECL(zeropad3D_G);
		PTHREAD_DECL(zeropad3D_H);

		
		PTHREAD_CREATE(zeropad3D);
		PTHREAD_CREATE(zeropad3D_A);
		PTHREAD_CREATE(zeropad3D_B);
		PTHREAD_CREATE(zeropad3D_C);
		PTHREAD_CREATE(zeropad3D_D);
		PTHREAD_CREATE(zeropad3D_E);
		PTHREAD_CREATE(zeropad3D_F);
		PTHREAD_CREATE(zeropad3D_G);
		PTHREAD_CREATE(zeropad3D_H);

    #endif

    fprintf(stderr,"Reading files\n");
    uint16_t rand_input_data;
	fscanf(input_file,"%hhd",&rand_input_data);
    
    //Take datatype as input
    
	#ifdef __I16
		des_inp.data_type = i16;
	#endif
	

    fscanf(input_file,"%hhd",&des_inp.row_major_form);
	write_uint8("zeropad_input_pipe",des_inp.row_major_form);
    fscanf(input_file,"%d",&des_inp.number_of_dimensions);
	write_uint8("zeropad_input_pipe",des_inp.number_of_dimensions);
	int ii;
	for (ii = 0;ii < des_inp.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&des_inp.dimensions[ii]);
        write_uint8("zeropad_input_pipe",des_inp.dimensions[ii]);
	}
	fprintf(stderr,"Read input descriptor %d,%d,%d.\n",des_inp.dimensions[0],des_inp.dimensions[1],des_inp.dimensions[2]);

	fscanf(param_file,"%d",&pad);
	write_uint8("zeropad_input_pipe",pad);
	
	fprintf(stderr,"Read pad value:%d\n",pad);
	__UpdateOutputDescriptorZeropadTensors__(des_inp,pad,des_out);
    fprintf(stderr,"Read output descriptor %d,%d,%d.\n",des_out.dimensions[0],des_out.dimensions[1],des_out.dimensions[2]);
	for(ii = 0;ii < 3;ii++){
		write_uint8("zeropad_input_pipe",des_out.dimensions[ii]);
	}

	// uint64_t input_size = __NumberOfElementsInSizedTensor__(T);
	uint64_t input_size = des_inp.dimensions[0]*des_inp.dimensions[1]*des_inp.dimensions[2];

    if (des_inp.data_type == i16){
		__dt__ temp[4];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;	
			write_uint8("zeropad_input_pipe",temp[ii&3]>>8);
			write_uint8("zeropad_input_pipe",temp[ii&3]);
			//fprintf(stderr,"%d\n",temp[ii&3]);				//Sequential data
			if ((ii&3)==3) T.data_array[ii/4] = *(uint64_t*)temp;
		}
		T.data_array[ii/4] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.\n");
	}
	fprintf(stderr,"Wrote all input values\n");
	
    fprintf(stderr,"Reading the output values from hardware\n");
	fprintf(out_file,"\n");
	int size = des_out.dimensions[0]*des_out.dimensions[1]*des_out.dimensions[2];
	fprintf(stderr,"Size of output is %d,%d,%d\n",des_out.dimensions[0],des_out.dimensions[1],des_out.dimensions[2]);

	if (des_out.data_type == i16){
		__dt__ val;
		for (ii = 0; ii < (size); ii++)
		{
			val = read_uint8 ("zeropad_output_pipe");
			val = (val <<8) + read_uint8("zeropad_output_pipe");
			fprintf(stderr,"%lu\n",val);		
		}
	}		
	else{
		fprintf(stderr,"Error. Datypes mismatch.\n");
	}
    fprintf(stderr,"Read back the values from hardware\n");

	fclose(input_file);
	fclose(param_file);
	fclose(out_file);

	// #ifndef SW
	// 	uint64_t time_taken = read_uint64("elapsed_time_pipe");
	// 	fprintf(stderr,"Time taken is %lu\n",time_taken);
	// #endif

    #ifdef SW
	    PTHREAD_CANCEL(zeropad3D);
		PTHREAD_CANCEL(zeropad3D_A);
		PTHREAD_CANCEL(zeropad3D_B);
		PTHREAD_CANCEL(zeropad3D_C);
		PTHREAD_CANCEL(zeropad3D_D);
		PTHREAD_CANCEL(zeropad3D_E);
		PTHREAD_CANCEL(zeropad3D_F);
		PTHREAD_CANCEL(zeropad3D_G);
		PTHREAD_CANCEL(zeropad3D_H);

	    close_pipe_handler();
    #endif
return 0;
}
