#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

SizedTensor_16K B;

#ifndef SW
void fill_T(uint64_t i);
#else
SizedTensor_16K T;
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
	element = read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
	element = (element << 8) + read_uint8 ("maxpool_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = B.data_array[addr];\
	uint16_t out_data[8];\
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

// void testConfigure()
// {

// 	// configure the tensor T
// 	desc_T.data_type = u16;
// 	desc_T.row_major_form = 1;
// 	desc_T.number_of_dimensions = 3;
// 	desc_B.number_of_dimensions = 3;
// 	int i;
// 	for (i = 0;i < desc_T.number_of_dimensions;i++){
// 		desc_T.dimensions[i] = read_uint8 ("maxpool_input_pipe");
// 		desc_B.dimensions[i] = read_uint8 ("maxpool_input_pipe");
// 	}

// 	// size = number of 16-bit values in data array..
// 	uint64_t size = __NumberOfElementsInSizedTensor__(desc_T);
// 	for (i = 0; i < (size >> 4); i++)
// 	{
// 		fill_T(i);
// 	}
// }

// this sends B...
void sendB(uint32_t size)
{
	int i;
	for(i=0; i < (size>>3); i++)
	{
		__set4xi16__(i);
	}
}

void maxPool3D()
{
	// testConfigure();

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
	__aa_barrier__();
	uint32_t size = rt*ct*chl_in;
	uint32_t i;
	for (i = 0; i < (size >> 3); i++)
	{
		fill_T(i);
	}
	__aa_barrier__();
	uint16_t ce = cb;
	uint16_t re = rb;
	uint16_t dim1d = ct;
	uint16_t offset1 = chl_out>>3, offset2 = dim1d*offset1;
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	__aa_barrier__();
	__maxPoolOfTensors3D_div__(B, 0, 0, re,ce,dim1d,ce,offset1,offset2);
	__aa_barrier__();
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	__aa_barrier__();
	sendB (cb*rb*chl_out);
}
