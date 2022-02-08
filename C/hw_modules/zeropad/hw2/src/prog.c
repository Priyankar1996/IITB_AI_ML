#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad.h"

SizedTensor_16K T,R;
uint16_t pad;

// void sendOutput(){
// 	int i;
// 	for(i = 0; i < R.descriptor.descriptor.number_of_dimensions; i++){
// 		write_uint16("zeropad_output_pipe",R.descriptor.descriptor.dimensions[i]);		
// 	}
// 	for(i = 0; __NumberOfElementsInSizedTensor__(R); i++)
// 	{
// 		write_uint16("zeropad_output_pipe",R.data_array[i]);
// 	}
// }

// void getInput(){
// 	T.descriptor.descriptor.data_type = i16;
// 	T.descriptor.descriptor.row_major_form = 1;
// 	T.descriptor.descriptor.number_of_dimensions = 3;
// 	int i;
// 	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++){
// 		T.descriptor.descriptor.dimensions[i] = read_uint16("zeropad_input_pipe");		
// 	}
// 	for(i = 0; i < __NumberOfElementsInSizedTensor__(T); i++)
// 	{
// 		T.data_array[i] = read_uint16("zeropad_input_pipe");
// 	}
// 	pad = read_uint16("zeropad_input_pipe");
// }

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

void getInputDim(){
	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	int i;
	for(i = 0; i < T.descriptor.descriptor.number_of_dimensions; i++){
		T.descriptor.descriptor.dimensions[i] = read_uint16("zeropad_input_pipe");	
	}
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


void zeropad3D()
{
	// getInput();
	getInputDim();
	getInputData();
	getpad();
#ifndef SW
	uint64_t start_time = timer();
#endif
	__zero_pad__(T,pad,R);
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	// sendOutput();
	sendOutputDim();
	sendOutputData();
}
