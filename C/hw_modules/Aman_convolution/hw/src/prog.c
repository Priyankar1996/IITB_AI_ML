#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution.h"

SizedTensor_16K T,B,K;

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

#define __get4xi16__(element) ({\
	element = read_uint16 ("maxpool_input_pipe");\
	element = (element << 16) + read_uint16 ("maxpool_input_pipe");\
	element = (element << 16) + read_uint16 ("maxpool_input_pipe");\
	element = (element << 16) + read_uint16 ("maxpool_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = B.data_array[addr];\
	uint16_t out_data[4];\
	out_data[3] = element & 0xFFFF;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data [1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	write_uint16 ("maxpool_output_pipe",out_data[0]);\
	write_uint16 ("maxpool_output_pipe",out_data[1]);\
	write_uint16 ("maxpool_output_pipe",out_data[2]);\
	write_uint16 ("maxpool_output_pipe",out_data[3]);\
})

// // this sends B...
// void sendB()
// {
// 	uint64_t size = __NumberOfElementsInSizedTensor__(desc_B);
// 	int i;
// 	for(i=0; i < (size>>2); i++)
// 	{
// 		__set4xi16__(i);
// 	}
// }

uint64_t getRemainingElements(uint16_t ne){
	uint64_t element = 0;
	for (uint16_t n = 0 ; n < ne; n++){
		element += read_uint16 ("maxpool_input_pipe");
		element <<= 16;
	}
	element <<= 16*(3-ne);
	return element;
}

void convolution3D()
{
	int i;
	uint16_t rt = read_uint16 ("maxpool_input_pipe");
	uint16_t ct = read_uint16 ("maxpool_input_pipe");
	uint16_t chl_in = read_uint16 ("maxpool_input_pipe");
	uint16_t rb = read_uint16 ("maxpool_input_pipe");
	uint16_t cb = read_uint16 ("maxpool_input_pipe");
	uint16_t chl_out = read_uint16 ("maxpool_input_pipe");
	uint16_t rk = read_uint16 ("maxpool_input_pipe");
	uint16_t ck = read_uint16 ("maxpool_input_pipe");

	// size = number of 16-bit values in data array..
	uint64_t size = rt*ct*chl_in;
	uint64_t element;
	for (i = 0; i < (size >> 2); i++)
	{
		__get4xi16__(element);
		T.data_array[i] = element;
	}
	if (size&3) T.data_array[i] = getRemainingElements(size&3);
	
	size =  chl_in*ck*rk*chl_out;
	for (i = 0; i < (size >> 2); i++)
	{
		__get4xi16__(element);
		K.data_array[i] = element;
	}
	if (size&3) K.data_array[i] = getRemainingElements(size&3);
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	__aa_barrier__();
	__convolution3D_div__( cb, rb, chl_out, chl_in, ct, rk, ck);
	__aa_barrier__();
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	__aa_barrier__();
	// sendB ();
}
