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

void convolution3D(uint16_t rb, uint16_t cb, uint16_t chl_out, uint16_t chl_in, uint8_t index_in, uint8_t index_k, uint8_t index_out, uint16_t ct, uint8_t activation);

void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);

void maxPool3D(uint16_t cb, uint16_t rb, uint16_t ct, uint16_t chl_out, uint8_t index_in, uint8_t index_out);

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
    for (i = 0; i < 19; i++) readFromSystemPipe(i);
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
    fill_input();
	zeropad(224,224,3,226,226,30,0,0);
    convolution3D(224,224,64,3,0,0,0,226,relu);
    zeropad(224,224,64,226,226,64,1,1);
    convolution3D(224,224,64,64,1,1,1,226,relu);
    maxPool3D(112,112,224,64,0,0);
    zeropad(112,112,64,114,114,64,2,2);
    convolution3D(112,112,128,64,2,2,2,114,relu);
    zeropad(112,112,128,114,114,128,3,3);
    convolution3D(112,112,128,128,3,3,3,114,relu);
    maxPool3D(56,56,112,128,1,1);
    zeropad(56,56,112,58,58,112,4,4);
    convolution3D(56,56,256,128,4,4,4,58,relu);
    zeropad(56,56,256,58,58,256,5,5);
    convolution3D(56,56,256,256,5,5,5,58,relu);
    maxPool3D(28,28,56,256,2,2);

    zeropad(28,28,512,30,30,512,6,6);
    convolution3D(28,28,512,256,6,6,6,30,relu);
    zeropad(28,28,512,30,30,512,7,7);
    convolution3D(28,28,512,512,7,7,7,30,relu);

    convTranspose(28,28,512,2,2,2,0,57,57,512,2,2);
    convolution3D(56,56,256,512,8,8,8,58,relu);
    concat(56,56,256,56,56,256,56,56,512,4,5,2);
    zeropad(56,56,512,58,58,512,9,9);
    convolution3D(56,56,256,512,9,9,9,58,relu);
    zeropad(56,56,256,58,58,256,10,10);
    convolution3D(56,56,256,256,10,10,10,58,relu);

    convTranspose(56,56,256,2,2,2,0,113,113,256,1,1);
    convolution3D(112,112,128,256,11,11,11,114,relu);
    concat(112,112,128,112,112,128,112,112,256,2,3,1);
    zeropad(112,112,256,114,114,256,12,12);
    convolution3D(112,112,128,256,12,12,12,114,relu);
    zeropad(112,112,128,114,114,128,13,13);
    convolution3D(112,112,128,128,13,13,13,114,relu);

    convTranspose(112,112,256,2,2,2,0,225,225,256,0,0);
    convolution3D(224,224,64,128,14,14,14,226,relu);
    concat(224,224,64,224,224,64,224,224,128,0,1,0);
    zeropad(224,224,128,226,226,128,15,15);
    convolution3D(224,224,64,128,15,15,15,226,relu);
    zeropad(224,224,64,226,226,64,16,16);
    convolution3D(224,224,64,64,16,16,16,226,relu);

    zeropad(224,224,64,226,226,64,17,17);
    convolution3D(224,224,3,64,17,17,17,226,sigmoid);
    //Final stage is a sigmoid activation       
    
    sendOutput();
}
