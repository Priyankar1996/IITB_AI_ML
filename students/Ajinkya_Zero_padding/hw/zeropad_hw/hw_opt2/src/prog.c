#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad_opt.h"
#include "prog.h"

SizedTensor_16K T,R;
uint16_t pad;

#ifndef SW
	void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
		#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
	void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif


void sendOutputDim(){
	R.descriptor.descriptor.data_type = i16;
	R.descriptor.descriptor.row_major_form = 1;
	R.descriptor.descriptor.number_of_dimensions = 3;
	for(int i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++){
		write_uint16("zeropad_output_pipe",R.descriptor.descriptor.dimensions[i]);		
	}
}

void sendOutputData(){
	for(int i = 0; __NumberOfElementsInSizedTensor__(R); i++)
	{
		write_uint16("zeropad_output_pipe",*(((int16_t*)R.data_array) + i));
	}
}

uint16_t getInputDim(){
	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++){
		T.descriptor.descriptor.dimensions[i] = read_uint16("zeropad_input_pipe");	
	}
	uint64_t size = __NumberOfElementsInSizedTensor__(T);
	return size;
}


void getInputData(){
	for(int i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
	{
		*(((int16_t*)T.data_array) + i) = read_uint16("zeropad_input_pipe");
	}
}


void getpad(){
	pad = read_uint16("zeropad_input_pipe");
}

void zeropad3D_A()
{
    uint16_t s0 = read_uint16("Block0_starting");
    #ifdef SW
        fprintf(stderr,"Block-0 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__(0,(T.descriptor.descriptor.dimensions[0]/2),
                               0,(T.descriptor.descriptor.dimensions[1]/2),
                               T,pad,R);
    __aa_barrier__();
    #ifdef SW
	    fprintf(stderr,"Block-0 done.\n");
    #endif
	write_uint16 ("Block0_complete", s0);
}

void zeropad3D_B()
{
    uint16_t s1 = read_uint16("Block1_starting");
    #ifdef SW
        fprintf(stderr,"Block-1 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__(0,(T.descriptor.descriptor.dimensions[0]/2),
                            (T.descriptor.descriptor.dimensions[1]/2),
                            T.descriptor.descriptor.dimensions[1],
                            T,pad,R);
    __aa_barrier__();
    #ifdef SW
        fprintf(stderr,"Block-1 done.\n");
    #endif
    write_uint16 ("Block1_complete", s1);
}

void zeropad3D_C()
{
    uint16_t s2 = read_uint16("Block2_starting");
    #ifdef SW
        fprintf(stderr,"Block-2 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__((T.descriptor.descriptor.dimensions[0]/2),
                               T.descriptor.descriptor.dimensions[0],0,
                               (T.descriptor.descriptor.dimensions[1]/2),
                               T,pad,R);
    __aa_barrier__();
    #ifdef SW
        fprintf(stderr,"Block-2 done.\n");
    #endif
    write_uint16 ("Block2_complete", s2);
}

void zeropad3D_D()
{
    uint16_t s3 = read_uint16("Block3_starting");
    #ifdef SW
        fprintf(stderr,"Block-3 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__((T.descriptor.descriptor.dimensions[0]/2),
                               T.descriptor.descriptor.dimensions[0],
                               (T.descriptor.descriptor.dimensions[1]/2),
                               T.descriptor.descriptor.dimensions[1],
                               T,pad,R);
    __aa_barrier__();    
    #ifdef SW
        fprintf(stderr,"Block-3 done.\n");
    #endif
    write_uint16 ("Block3_complete", s3);
}

void zeropad3D()
{
	// getInput();
	uint64_t sz = getInputDim();
	getInputData();
	getpad();
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	// __zero_pad__(T,pad,R);
	write_uint16("Block0_starting",sz);
	write_uint16("Block1_starting",sz);
	write_uint16("Block2_starting",sz);
	write_uint16("Block3_starting",sz);
	uint16_t s0 = read_uint16("Block0_complete");
	uint16_t s1 = read_uint16("Block1_complete");
	uint16_t s2 = read_uint16("Block2_complete");
	uint16_t s3 = read_uint16("Block3_complete");
	__aa_barrier__();
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	__aa_barrier__();
	// sendOutput();
	sendOutputDim();
	sendOutputData();
}
