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

memStructTemp memory;

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
    memory.input.data_array[5] = 1;
    fill_input(1);
}
