#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

SizedTensor_16K T,B;
TensorDescriptor desc_T,desc_B;
uint16_t length, stride;

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

uint64_t getRemainingElements(uint16_t ne){
	uint64_t element = 0;
	for (uint16_t n = 0 ; n < ne; n++){
		element += read_uint16 ("maxpool_input_pipe");
		element <<= 16;
	}
	element <<= 16*(3-ne);
	return element;
}

void sendRemainingElements(int addr, uint16_t ne){
	uint64_t element = B.data_array[addr];\
	uint16_t out_data[3];\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data [1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	for (int n = 0; n < ne; n++)
		write_uint16 ("maxpool_output_pipe",out_data[n]);
}

void testConfigure()
{
	length = read_uint16 ("maxpool_input_pipe");
	stride = read_uint16 ("maxpool_input_pipe");

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
	for (i = 0; i < (size >> 2); i++)
	{
		uint64_t element;
		// __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
 		__get4xi16__(element);

		T.data_array[i] = element;
	}
	if (size&3) T.data_array[i] = getRemainingElements(size&3);
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
	if (size&3) sendRemainingElements(i,size&3);
}


void maxPool3D()
{
	testConfigure();	
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	uint32_t offset1 = __dim2__(desc_T);
	uint16_t dim1 = __dim1__(desc_B), dim1d = __dim1__(desc_T);
	uint32_t size = dim1*offset1*__dim0__(desc_B);\
	__maxPoolOfTensors3D__(T,B,length,stride,offset1,dim1,dim1d,size);
#ifndef SW
	__aa_barrier__();
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	sendB ();
}