#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution_multipipe.h"
#include "inttypes.h"

SizedTensor_16K T[3];

#define my_read_write_fn(s1,s2) ({\
	uint8_t x = read_uint8(s1);\
	write_uint8(s2,x);\
	x;\
})

#define __get8xi8__(element) ({\
	element = read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
	element = (element << 8) + read_uint8("maxpool_input_pipe");\
})

#define __set8xi8__(addr) ({\
	uint64_t element = T[2].data_array[addr];\
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
	write_uint8 ("maxpool_output_pipe",out_data[0]);\
	write_uint8 ("maxpool_output_pipe",out_data[1]);\
	write_uint8 ("maxpool_output_pipe",out_data[2]);\
	write_uint8 ("maxpool_output_pipe",out_data[3]);\
	write_uint8 ("maxpool_output_pipe",out_data[4]);\
	write_uint8 ("maxpool_output_pipe",out_data[5]);\
	write_uint8 ("maxpool_output_pipe",out_data[6]);\
	write_uint8 ("maxpool_output_pipe",out_data[7]);\
})

// printf("val = 0%" PRIx64 "\n",element);

// this sends B...
void sendB(uint32_t size)
{
	uint32_t i;
	for(i=0; i < (size); i++)
	{
		__set8xi8__(i);
	}
}

void convolution3D()
{
	int i;
	uint16_t rt = read_uint8("maxpool_input_pipe");
	rt = ( rt<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t ct = read_uint8("maxpool_input_pipe");
	ct = ( ct<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t chl_in = read_uint8("maxpool_input_pipe");
	chl_in = ( chl_in<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t rb = read_uint8("maxpool_input_pipe");
	rb = ( rb<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t cb = read_uint8("maxpool_input_pipe");
	cb = ( cb<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t chl_out = read_uint8("maxpool_input_pipe");
	chl_out = ( chl_out<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t rk = read_uint8("maxpool_input_pipe");
	rk = ( rk<<8 ) + read_uint8("maxpool_input_pipe");
	uint16_t ck = read_uint8("maxpool_input_pipe");
	ck = ( ck<<8 ) + read_uint8("maxpool_input_pipe");

	// size = number of 16-bit values in data array..
	uint32_t size = rt*ct*chl_in;
	uint64_t element;
	for (i = 0; i < (size >> 3); i++)
	{
		__get8xi8__(element);
		T[0].data_array[i] = element;
	}
	
	size =  chl_in*ck*rk*chl_out;
	for (i = 0; i < (size >> 3); i++)
	{
		__get8xi8__(element);
		T[1].data_array[i] = element;
	}
	chl_in >>= 3;
	chl_out >>= 3;
	__aa_barrier__();
#ifndef SW
    write_uint64("time_pipe",timer(1));
#endif
	write_uint16("output_pipe",rb);
	write_uint16("output_pipe",cb);
	write_uint16("output_pipe",chl_out);
	write_uint16("num_out_pipe",rb);
	write_uint16("num_out_pipe",cb);
	write_uint16("num_out_pipe",chl_in);
	write_uint16("kernel_module_pipe",chl_in);
	write_uint16("kernel_module_pipe",chl_out);
	write_uint16("kernel_module_pipe",1);
	write_uint16("input_module_pipe",rb);
	write_uint16("input_module_pipe",ct);
	write_uint16("input_module_pipe",chl_in);
	write_uint16("input_module_pipe",chl_out);
	__aa_barrier__();
	// __convolution3D_div__( cb, rb, chl_out, chl_in, ct, rk, ck);
	__aa_barrier__();
#ifndef SW
	uint8_t done = read_uint8("input_done_pipe");
	__aa_barrier__();
    write_uint64("time_pipe",timer(2));
	sendB (cb*rb*chl_out);
#endif
}
