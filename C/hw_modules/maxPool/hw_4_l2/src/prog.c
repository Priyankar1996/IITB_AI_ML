#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

TensorDescriptor desc_T,desc_B;
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

void testConfigure()
{

	// configure the tensor T
	desc_T.data_type = u16;
	desc_T.row_major_form = 1;
	desc_T.number_of_dimensions = 3;
	desc_B.number_of_dimensions = 3;
	int i;
	for (i = 0;i < desc_T.number_of_dimensions;i++){
		desc_T.dimensions[i] = read_uint16 ("maxpool_input_pipe");
		desc_B.dimensions[i] = read_uint16 ("maxpool_input_pipe");
	}

	// size = number of 16-bit values in data array..
	uint64_t size = __NumberOfElementsInSizedTensor__(desc_T);
	for (i = 0; i < (size >> 4); i++)
	{
		fill_T(i);
	}
}

// this sends B...
void sendB()
{
	uint64_t size = __NumberOfElementsInSizedTensor__(desc_B);
	int i;
	for(i=0; i < (size>>2); i++)
	{
		__set4xi16__(i);
	}
}

void maxPool3D()
{
	testConfigure();
	__aa_barrier__();
	uint16_t ce = __dim1__(desc_B);
	uint16_t re = __dim0__(desc_B);
	uint16_t dim1d = __dim1__(desc_T);
	uint16_t offset1 = __dim24__(desc_B), offset2 = dim1d*offset1;
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
	sendB ();
}
