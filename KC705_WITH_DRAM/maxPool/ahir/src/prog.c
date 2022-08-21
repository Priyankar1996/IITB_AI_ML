#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "maxPool.h"

uint64_t readModule1 (uint32_t);
void writeModule1 (uint32_t, uint64_t);

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

void sendOutput(uint32_t size)
{
	uint32_t i;
	for(i=0; i < (size>>3); i++)
	{
		__set8xi8__(i);
	}
}

void systemTOP()
{
    // 0
    uint16_t rt = read_uint8 ("maxpool_input_pipe");
	rt = ( rt<<8 ) + read_uint8 ("maxpool_input_pipe");
	uint16_t rb = read_uint8 ("maxpool_input_pipe");
	rb = ( rb<<8 ) + read_uint8 ("maxpool_input_pipe");
	uint16_t ct = read_uint8 ("maxpool_input_pipe");
	ct = ( ct<<8 ) + read_uint8 ("maxpool_input_pipe");
	uint16_t cb = read_uint8 ("maxpool_input_pipe");
	cb = ( cb<<8 ) + read_uint8 ("maxpool_input_pipe");
	uint16_t chl_in = read_uint8 ("maxpool_input_pipe");
	chl_in = ( chl_in<<8 ) + read_uint8 ("maxpool_input_pipe");
	uint16_t chl_out = read_uint8 ("maxpool_input_pipe");
	chl_out = ( chl_out<<8 ) + read_uint8 ("maxpool_input_pipe");
	write_uint8 ("system_output_pipe",255);\
	__aa_barrier__();
	uint32_t size = rt*ct*chl_in;
	uint32_t i;
    uint64_t element;
    write_uint8 ("system_output_pipe",254);\
	for (i = 0; i < (size>>3); i++)
	{
		__get8xi8__(element);
		writeModule1 (i,element);
	}
	write_uint8 ("system_output_pipe",253);\
	__aa_barrier__();
	write_uint8 ("system_output_pipe",252);\
    uint64_t start_time = timer();
    maxPool3D(cb,rb,ct,chl_out,1,0);
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
    
    sendOutput(size>>2);
}
