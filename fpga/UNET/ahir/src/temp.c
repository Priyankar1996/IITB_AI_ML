#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution.h"

uint8_t writeModule1 (uint8_t,uint32_t,uint64_t);

typedef struct __memStructTemp {
SizedTensor_64K input, output;
SizedTensor_512 kernel;
} memStructTemp;

SizedTensor_64K input, output;

SizedTensor_512 KE1_1, KL;
SizedTensor_8K KE1_2, KD1_2;
SizedTensor_16K KT1, KE2_1, KD1_1;
SizedTensor_32K KE2_2, KD2_2;
SizedTensor_64K KE3_1, KT2, KD2_1;
SizedTensor_128K KE3_2, KD3_2;
SizedTensor_256K KM1, KT3, KD3_1;
SizedTensor_512K KM2;

SizedTensor_32K M3;
SizedTensor_64K M2, CM1, CM2;
SizedTensor_128K M1, CE3_1, CE3_2, T3, CD3_1, CD3_2;
SizedTensor_256K CE2_1, CE2_2, CO3, T2, CD2_1, CD2_2;
SizedTensor_512K CE1_1, CE1_2, CO2, T1, CD1_1, CD1_2;
SizedTensor_1M CO1;

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

void fill_input(index){
    uint16_t row = read_uint8("system_input_pipe");
    row = (row << 8) + read_uint8("system_input_pipe");
    uint16_t col = read_uint8("system_input_pipe");
    col = (col << 8) + read_uint8("system_input_pipe");
    uint16_t chl = read_uint8("system_input_pipe");
    chl = (chl << 8) + read_uint8("system_input_pipe");
    uint32_t size = row*col*chl, i;
	uint64_t element;
	for (i = 0; i < (size >> 3); i++)
	{
		__get8xi8__(element);
		uint8_t x = writeModule1 (index,i,element);
	}
}

void systemTOP()
{
    input.data_array[5] = 1;
    kernel.data_array[5] = 1;
    output.data_array[5] = 1;
    fill_input(1);
}
