#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution.h"

void __aa_barrier__();

uint64_t readModule1 (uint32_t);
void writeModule1 (uint8_t, uint32_t, uint64_t);


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

uint64_t global_time_val[20];

void writeTime(uint8_t ind)
{
	global_time_val[ind] = timer();
}

writeTimeBack()
{
	for (int i = 0; i < 19; i++)
	{
	uint64_t elapsed_time = global_time_val[i];
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
	}
	
}

void systemTOP()
{
	// 0
	uint8_t start = read_uint8("debug_input_pipe");
	uint8_t end = read_uint8("system_input_pipe");
	//write_uint8("debug_output_pipe",9);
	//fill_input();
	//write_uint8("debug_output_pipe",10);
	__aa_barrier__();
	writeTime(0);
	//write_uint8("debug_output_pipe",11);
	// 0 -> 1
	convolutionAll(224,224,224,224,64,3,3,3,0,0,0,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",11);
	__aa_barrier__();
	writeTime(1);
	__aa_barrier__();
	// 1 -> 2
	convolutionAll(224,224,224,224,64,64,3,3,1,0,1,2,0,1,1,relu);
	//write_uint8("debug_output_pipe",12);
	__aa_barrier__();
	writeTime(2);
	__aa_barrier__();
	// 2 -> 1
	convolutionAll(112,112,112,112,128,64,3,3,2,0,2,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",13);
	__aa_barrier__();
	writeTime(3);
	__aa_barrier__();
	// 1 -> 3
	convolutionAll(112,112,112,112,128,128,3,3,1,0,3,3,0,1,1,relu);
	//write_uint8("debug_output_pipe",14);
	__aa_barrier__();
	writeTime(4);
	__aa_barrier__();
	// 3 -> 1
	convolutionAll(56,56,56,56,256,128,3,3,0,0,4,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",15);
	__aa_barrier__();
	writeTime(5);
	__aa_barrier__();
	// 1 -> 4
	convolutionAll(56,56,56,56,256,256,3,3,1,0,5,4,0,1,1,relu);
	//write_uint8("debug_output_pipe",16);
	__aa_barrier__();
	writeTime(6);
	__aa_barrier__();
	
	// 4 -> 1
	convolutionAll(28,28,28,28,512,256,3,3,4,0,6,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",17);
	__aa_barrier__();
	writeTime(7);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(28,28,28,28,512,512,3,3,1,0,7,0,0,1,0,relu);
	//write_uint8("debug_output_pipe",18);
	__aa_barrier__();

	writeTime(8);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(56,56,28,28,256,512,2,2,0,0,8,1,0,0,0,relu);
	//write_uint8("debug_output_pipe",20);
	__aa_barrier__();
	writeTime(9);
	__aa_barrier__();
	// 4,1 -> 0
	convolutionAll(56,56,56,56,256,512,3,3,4,129,9,0,0,1,0,relu);
	//write_uint8("debug_output_pipe",22);
	__aa_barrier__();
	writeTime(10);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(56,56,56,56,256,256,3,3,0,0,10,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",23);
	__aa_barrier__();
	writeTime(11);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(112,112,56,56,128,256,2,2,1,0,11,0,0,0,0,relu);
	//write_uint8("debug_output_pipe",25);
	__aa_barrier__();
	writeTime(12);
	__aa_barrier__();
	// 3,0 -> 1
	convolutionAll(112,112,112,112,128,256,3,3,3,128,12,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",27);
	__aa_barrier__();
	writeTime(13);
	__aa_barrier__();
	// 1 -> 0
	convolutionAll(112,112,112,112,128,128,3,3,1,0,13,0,0,1,0,relu);
	//write_uint8("debug_output_pipe",28);
	__aa_barrier__();
	writeTime(14);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(224,224,112,112,64,128,2,2,0,0,14,1,0,0,0,relu);
	//write_uint8("debug_output_pipe",30);
	__aa_barrier__();
	writeTime(15);
	__aa_barrier__();
	// 2,1 -> 0
	convolutionAll(224,224,224,224,64,128,3,3,2,129,15,0,0,1,0,relu);
	//write_uint8("debug_output_pipe",32);
	__aa_barrier__();
	writeTime(16);
	__aa_barrier__();
	// 0 -> 1
	convolutionAll(224,224,224,224,64,64,3,3,0,0,16,1,0,1,0,relu);
	//write_uint8("debug_output_pipe",33);
	__aa_barrier__();
	writeTime(17);
	__aa_barrier__();

	// 1 -> 0
	//Final stage is a sigmoid activation	  
	convolutionAll(224,224,224,224,3,64,3,3,1,0,17,0,0,1,0,sigmoid);
	//write_uint8("debug_output_pipe",34);
	__aa_barrier__();
	writeTime(18);
	//uint64_t stop_time = timer();
	//uint64_t elapsed_time = stop_time-start_time;
	//uint8_t out_data[8];\
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
	//write_uint8 ("debug_output_pipe",out_data[0]);\
	//write_uint8 ("debug_output_pipe",out_data[1]);\
	//write_uint8 ("debug_output_pipe",out_data[2]);\
	//write_uint8 ("debug_output_pipe",out_data[3]);\
	//write_uint8 ("debug_output_pipe",out_data[4]);\
	//write_uint8 ("debug_output_pipe",out_data[5]);\
	//write_uint8 ("debug_output_pipe",out_data[6]);\
	//write_uint8 ("debug_output_pipe",out_data[7]);\
	
	//write_uint8("debug_output_pipe",35);
	__aa_barrier__();
	writeTimeBack();
	sendOutput();
	//write_uint8("debug_output_pipe",36);
}
