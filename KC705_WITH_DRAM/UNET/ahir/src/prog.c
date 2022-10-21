#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
//#include "concat.h"
#include "convolution.h"
//#include "convTranspose.h"

void __aa_barrier__();

uint64_t readModule1 (uint32_t);
void writeModule1 (uint8_t, uint32_t, uint64_t);

void concat(uint16_t input1_dim0, uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0, uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index0,uint8_t index1,uint8_t index2);

void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);

void convolutionAll (uint16_t rb, uint16_t cb, uint16_t rt, uint16_t ct, uint16_t chl_out, uint16_t chl_in, uint16_t rk, uint16_t ck, uint8_t index_in1, uint8_t index_in2, uint8_t index_k, uint8_t index_out, uint16_t shift_val,uint16_t pad, uint8_t pool, uint8_t activation);

#define __get8xi8__(element) ({\
	element = read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
	element = (element << 8) + read_uint8("system_input_pipe");\
})

#define __set8xi8__(addr) ({\
	uint64_t element = readModule1(addr);\
	uint8_t out_data[8];\
	out_data[7] = element & 0xFF;\
	element>>=8;\
	out_data[6] = element & 0xFF;\
	element>>=8;\
	out_data[5] = element & 0xFF;\
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
	write_uint8 ("system_output_pipe",out_data[0]);\
	write_uint8 ("system_output_pipe",out_data[1]);\
	write_uint8 ("system_output_pipe",out_data[2]);\
	write_uint8 ("system_output_pipe",out_data[3]);\
	write_uint8 ("system_output_pipe",out_data[4]);\
	write_uint8 ("system_output_pipe",out_data[5]);\
	write_uint8 ("system_output_pipe",out_data[6]);\
	write_uint8 ("system_output_pipe",out_data[7]);\
})

void readFromSystemPipe(uint8_t index)
{
	uint32_t word_count = read_uint8("system_input_pipe"), i;
	word_count = (word_count << 8) + read_uint8("system_input_pipe");
	word_count = (word_count << 8) + read_uint8("system_input_pipe");
	uint64_t element;
	for (i = 0; i < word_count; i++)
	{
		__get8xi8__(element);
		writeModule1 (index,i,element);
	}
}

void fill_input()
{
	// kernels followed by input tensor
	uint8_t i;
	for (i = 0; i < 2; i++) readFromSystemPipe(i);
}

void sendOutput()
{
	uint32_t i;
	for(i=0; i < 18816; i++)
	{
		__set8xi8__(i);
	}
}

void systemTOP()
{
	// 0
	uint8_t start = read_uint8("debug_input_pipe");
	write_uint8("debug_output_pipe",9);
	fill_input();
	write_uint8("debug_output_pipe",10);
	__aa_barrier__();
	uint64_t start_time = timer();
	write_uint8("debug_output_pipe",11);
	// 0 -> 1
	convolutionAll(224,224,224,224,64,3,3,3,0,0,0,1,0,1,0,relu);
	write_uint8("debug_output_pipe",11);
	__aa_barrier__();
	// 1 -> 2
	convolutionAll(224,224,224,224,64,64,3,3,1,0,1,2,0,1,1,relu);
	write_uint8("debug_output_pipe",12);
	__aa_barrier__();
	// 2 -> 1
	convolutionAll(112,112,112,112,128,64,3,3,2,0,2,1,0,1,0,relu);
	write_uint8("debug_output_pipe",13);
	__aa_barrier__();
	// 1 -> 3
	convolutionAll(112,112,112,112,128,128,3,3,1,0,3,3,0,1,1,relu);
	write_uint8("debug_output_pipe",14);
	__aa_barrier__();
	// 3 -> 1
	convolutionAll(56,56,56,56,256,128,3,3,0,0,4,1,0,1,0,relu);
	write_uint8("debug_output_pipe",15);
	__aa_barrier__();
	// 1 -> 4
	convolutionAll(56,56,56,56,256,256,3,3,1,0,5,4,0,1,1,relu);
	write_uint8("debug_output_pipe",16);
	__aa_barrier__();
	
	// 4 -> 1
	convolutionAll(28,28,28,28,512,256,3,3,4,0,6,1,0,1,0,relu);
	write_uint8("debug_output_pipe",17);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(28,28,28,28,512,512,3,3,1,0,7,0,0,1,0,relu);
	write_uint8("debug_output_pipe",18);
	__aa_barrier__();


	//convTranspose(28,28,512,2,2,2,0,57,57,512,0,1);
	write_uint8("debug_output_pipe",19);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(56,56,28,28,256,512,2,2,0,0,8,1,0,0,0,relu);
	write_uint8("debug_output_pipe",20);
	__aa_barrier__();
	//concat(56,56,256,56,56,256,56,56,512,4,0,1);
	write_uint8("debug_output_pipe",21);
	__aa_barrier__();
	// 4,1 -> 0
	convolutionAll(56,56,56,56,256,512,3,3,4,129,9,0,0,1,0,relu);
	write_uint8("debug_output_pipe",22);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(56,56,56,56,256,256,3,3,0,0,10,1,0,1,0,relu);
	write_uint8("debug_output_pipe",23);
	__aa_barrier__();
	
	//convTranspose(56,56,256,2,2,2,0,113,113,256,1,0);
	write_uint8("debug_output_pipe",24);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(112,112,56,56,128,256,2,2,1,0,11,0,0,0,0,relu);
	write_uint8("debug_output_pipe",25);
	__aa_barrier__();
	//concat(112,112,128,112,112,128,112,112,256,3,1,0);
	write_uint8("debug_output_pipe",26);
	__aa_barrier__();
	// 3,0 -> 1
	convolutionAll(112,112,112,112,128,256,3,3,3,128,12,1,0,1,0,relu);
	write_uint8("debug_output_pipe",27);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(112,112,112,112,128,128,3,3,1,0,13,0,0,1,0,relu);
	write_uint8("debug_output_pipe",28);
	__aa_barrier__();

	//convTranspose(112,112,256,2,2,2,0,225,225,256,0,1);
	write_uint8("debug_output_pipe",29);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(224,224,112,112,64,128,2,2,0,0,14,1,0,0,0,relu);
	write_uint8("debug_output_pipe",30);
	__aa_barrier__();
	//concat(224,224,64,224,224,64,224,224,128,2,0,1);
	write_uint8("debug_output_pipe",31);
	__aa_barrier__();
	// 2,1 -> 0
	convolutionAll(224,224,224,224,64,128,3,3,2,129,15,0,0,1,0,relu);
	write_uint8("debug_output_pipe",32);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(224,224,224,224,64,64,3,3,0,0,16,1,0,1,0,relu);
	write_uint8("debug_output_pipe",33);
	__aa_barrier__();

	// 1 -> 0
	//Final stage is a sigmoid activation	  
	convolutionAll(224,224,224,224,3,64,3,3,1,0,17,0,0,1,0,sigmoid);
	write_uint8("debug_output_pipe",34);
	__aa_barrier__();
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time-start_time;
	uint8_t out_data[8];\
	out_data[7] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[6] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[5] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[4] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[3] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[2] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[1] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[0] = elapsed_time & 0xFF;\
	__aa_barrier__();
	write_uint8 ("debug_output_pipe",out_data[0]);\
	write_uint8 ("debug_output_pipe",out_data[1]);\
	write_uint8 ("debug_output_pipe",out_data[2]);\
	write_uint8 ("debug_output_pipe",out_data[3]);\
	write_uint8 ("debug_output_pipe",out_data[4]);\
	write_uint8 ("debug_output_pipe",out_data[5]);\
	write_uint8 ("debug_output_pipe",out_data[6]);\
	write_uint8 ("debug_output_pipe",out_data[7]);\
	
	write_uint8("debug_output_pipe",35);
	__aa_barrier__();
	sendOutput();
	write_uint8("debug_output_pipe",36);
}
