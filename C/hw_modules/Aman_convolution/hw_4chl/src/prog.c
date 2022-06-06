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

SizedTensor_16K T,B,K;

#define my_read_write_fn(s1,s2) ({\
	uint8_t x = read_uint8(s1);\
	write_uint8(s2,x);\
	x;\
})

#ifndef SW
void fill_T(uint64_t i);
#else
#define fill_T(i) ({\
	uint64_t element;\
	__get4xi16__(element);\
	T.data_array[4*i] = element;\
	__get4xi16__(element);\
	T.data_array[4*i+1] = element;\
	__get4xi16__(element);\
	T.data_array[4*i+2] = element;\
	__get4xi16__(element);\
	T.data_array[4*i+3] = element;\
})
#endif

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
	uint64_t element = B.data_array[addr];\
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
uint64_t getRemainingElements(uint8_t ne){
	uint64_t element = 0;
	for (uint8_t n = 0 ; n < ne; n++){
		element += read_uint8("maxpool_input_pipe");
		element <<= 8;
	}
	element <<= 8*(7-ne);
	return element;
}

void sendRemainingElements(uint32_t addr, uint8_t ne){
	uint64_t element = B.data_array[addr];
	uint8_t out_data[7];
	element>>=8;
	out_data[6] = element & 0xFF;
	element>>=8;
	out_data[5] = element & 0xFF;
	element>>=8;
	out_data[4] = element & 0xFF;
	element>>=8;
	out_data[3] = element & 0xFF;
	element>>=8;
	out_data[2] = element & 0xFF;
	element>>=8;
	out_data[1] = element & 0xFF;
	element>>=8;
	out_data[0] = element & 0xFF;
	for (int n = 0; n < ne; n++)
	{
		write_uint8 ("maxpool_output_pipe",out_data[n]);
	}
}

// this sends B...
void sendB(uint32_t size)
{
	uint32_t i;
	for(i=0; i < (size>>3); i++)
	{
		__set8xi8__(i);
	}
	if (size & 7) sendRemainingElements(i,size&7);
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
		T.data_array[i] = element;
	}
	
	size =  chl_in*ck*rk*chl_out;
	for (i = 0; i < (size >> 3); i++)
	{
		__get8xi8__(element);
		K.data_array[i] = element;
	}
	chl_in >>= 3;
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	write_uint16("output_pipe",rb);
	write_uint16("output_pipe",cb);
	write_uint16("output_pipe",chl_out);
	write_uint16("num_out_pipe",rb);
	write_uint16("num_out_pipe",cb);
	write_uint16("kernel_module_pipe",chl_in);
	write_uint16("kernel_module_pipe",chl_out);
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
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	sendB (cb*rb*chl_out);
	__aa_barrier__();
	uint8_t time_data[8];
	time_data[7] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[6] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[5]= elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[4] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[3] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[2] = elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[1] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[0] = elapsed_time & 0xFF;
	write_uint8 ("maxpool_output_pipe",time_data[0]);
	write_uint8 ("maxpool_output_pipe",time_data[1]);
	write_uint8 ("maxpool_output_pipe",time_data[2]);
	write_uint8 ("maxpool_output_pipe",time_data[3]);
    write_uint8 ("maxpool_output_pipe",time_data[4]);
	write_uint8 ("maxpool_output_pipe",time_data[5]);
	write_uint8 ("maxpool_output_pipe",time_data[6]);
	write_uint8 ("maxpool_output_pipe",time_data[7]);
#endif
}
