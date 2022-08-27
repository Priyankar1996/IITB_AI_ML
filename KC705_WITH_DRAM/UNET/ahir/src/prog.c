#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "concat.h"
#include "zeropad.h"
#include "convolution.h"
#include "convTranspose.h"
#include "maxPool.h"

uint64_t readModule1 (uint32_t);
void writeModule1 (uint8_t, uint32_t, uint64_t);

void concat(uint16_t input1_dim0, uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0,      uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index0,uint8_t index1,uint8_t index2);

void zeropad(uint16_t input_dim0,uint16_t input_dim1,uint16_t input_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);

void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);

void maxPool3D(uint16_t cb, uint16_t rb, uint16_t ct, uint16_t chl_out, uint8_t index_in, uint8_t index_out);

void convolution3D_3 (uint16_t rb, uint16_t cb, uint16_t chl_out, uint16_t chl_in, uint16_t rk, uint16_t ck, uint8_t index_in, uint8_t index_k, uint8_t index_out, uint16_t ct, uint16_t shift_val, uint8_t activation );

void convolutionSmall (uint16_t rb, uint16_t cb, uint16_t chl_out, uint16_t chl_in, uint16_t rk, uint16_t ck, uint8_t index_in, uint8_t index_k, uint8_t index_out, uint16_t ct, uint16_t shift_val, uint8_t activation );

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
    readFromSystemPipe(1);
    readFromSystemPipe(0);
    uint64_t start_time = timer();
	// 0 -> 1
	zeropad(224,224,3,226,226,3,0,1);
    // 1 -> 0
    convolutionSmall(224,224,64,3,3,3,1,0,0,226,0,relu);
    // 0 -> 1
    zeropad(224,224,64,226,226,64,0,1);
    // 1 -> 2
    convolution3D_3(224,224,64,64,3,3,1,1,2,226,0,relu);
    readFromSystemPipe(0);
    // 2 -> 0
    maxPool3D(112,112,224,64,2,0);
    // 0 -> 1
    zeropad(112,112,64,114,114,64,0,1);
    // 1 -> 0
    convolution3D_3(112,112,128,64,3,3,1,2,0,114,0,relu);
    readFromSystemPipe(0);
    // 0 -> 1
    zeropad(112,112,128,114,114,128,0,1);
    // 1 -> 3
    convolution3D_3(112,112,128,128,3,3,1,3,3,114,0,relu);
    readFromSystemPipe(0);
    // 3 -> 0
    maxPool3D(56,56,112,128,3,0);
    // 0 -> 1
    zeropad(56,56,112,58,58,112,0,1);
    // 1 -> 0
    convolution3D_3(56,56,256,128,3,3,1,4,0,58,0,relu);
    readFromSystemPipe(0);
    // 0 -> 1
    zeropad(56,56,256,58,58,256,0,1);
    // 1 -> 4
    convolution3D_3(56,56,256,256,3,3,1,5,4,58,0,relu);
    readFromSystemPipe(0);
    // 4 -> 0
    maxPool3D(28,28,56,256,4,0);

    // 0 -> 1
    zeropad(28,28,512,30,30,512,0,1);
    // 1 -> 0
    convolution3D_3(28,28,512,256,3,3,1,6,0,30,0,relu);
    readFromSystemPipe(0);
    // 0 -> 1
    zeropad(28,28,512,30,30,512,0,1);
    // 1 -> 0
    convolution3D_3(28,28,512,512,3,3,1,7,0,30,0,relu);
	readFromSystemPipe(0);

    // 0 -> 1
    convTranspose(28,28,512,2,2,2,0,57,57,512,0,1);
    // 1 -> 0
    convolution3D_3(56,56,256,512,2,2,1,8,0,57,0,relu);
    readFromSystemPipe(0);
    // 4,0 -> 1
    concat(56,56,256,56,56,256,56,56,512,4,0,1);
    // 1 -> 0
    zeropad(56,56,512,58,58,512,1,0);
    // 0 -> 1
    convolution3D_3(56,56,256,512,3,3,0,9,1,58,0,relu);
    readFromSystemPipe(0);
    // 1 -> 0
    zeropad(56,56,256,58,58,256,1,0);
    // 0 -> 1
    convolution3D_3(56,56,256,256,3,3,0,10,1,58,0,relu);
    readFromSystemPipe(0);
    
    // 1 -> 0
    convTranspose(56,56,256,2,2,2,0,113,113,256,1,0);
    // 0 -> 1
    convolution3D_3(112,112,128,256,2,2,0,11,1,113,0,relu);
    readFromSystemPipe(0);
    // 3,1 -> 0
    concat(112,112,128,112,112,128,112,112,256,3,1,0);
    // 0 -> 1
    zeropad(112,112,256,114,114,256,0,1);
    // 1 -> 0
    convolution3D_3(112,112,128,256,3,3,1,12,0,114,0,relu);
    readFromSystemPipe(0);
    // 0 -> 1
    zeropad(112,112,128,114,114,128,0,1);
    // 1 -> 0
    convolution3D_3(112,112,128,128,3,3,1,13,0,114,0,relu);
    readFromSystemPipe(0);

    // 0 -> 1
    convTranspose(112,112,256,2,2,2,0,225,225,256,0,1);
    // 1 -> 0
    convolution3D_3(224,224,64,128,2,2,1,14,0,225,0,relu);
    readFromSystemPipe(0);
    // 2,0 -> 1
    concat(224,224,64,224,224,64,224,224,128,2,0,1);
    // 1 -> 0
    zeropad(224,224,128,226,226,128,1,0);
    // 0 -> 1
    convolution3D_3(224,224,64,128,3,3,0,15,1,226,0,relu);
    readFromSystemPipe(0);
    // 1 -> 0
    zeropad(224,224,64,226,226,64,1,0);
    // 0 -> 1
    convolution3D_3(224,224,64,64,3,3,0,16,1,226,0,relu);
    readFromSystemPipe(0);

    // 1 -> 0
    zeropad(224,224,64,226,226,64,1,0);
    // 0 -> 1
    convolutionSmall(224,224,3,64,3,3,0,17,1,226,0,sigmoid);
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
	write_uint8 ("system_output_pipe",out_data[0]);\
	write_uint8 ("system_output_pipe",out_data[1]);\
	write_uint8 ("system_output_pipe",out_data[2]);\
	write_uint8 ("system_output_pipe",out_data[3]);\
	write_uint8 ("system_output_pipe",out_data[4]);\
	write_uint8 ("system_output_pipe",out_data[5]);\
	write_uint8 ("system_output_pipe",out_data[6]);\
	write_uint8 ("system_output_pipe",out_data[7]);\
    //Final stage is a sigmoid activation       
    
    sendOutput();
}
