#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
#endif

SizedTensor_16K T,B;
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

void testConfigure()
{
	// configure the tensor T
	fprintf(stderr,"Starting test_configure\n");

	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;
	int i;
	for (i = 0;i < T.descriptor.descriptor.number_of_dimensions;i++){
		T.descriptor.descriptor.dimensions[i] = read_uint16 ("maxpool_input_pipe");
	}

	length = read_uint16 ("maxpool_input_pipe");
	stride = read_uint16 ("maxpool_input_pipe");

	// size = number of 16-bit values in data array..
	uint64_t size = __NumberOfElementsInSizedTensor__(T);
	for (i = 0; i < (size >> 2); i++)
	{
		uint64_t element;
		// __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
 		__get4xi16__(element);

		T.data_array[i] = element;
	}
	fprintf(stderr,"Ending test_configure\n");

}

// this sends B...
void sendB()
{
	fprintf(stderr,"Starting test_send\n");
	write_uint16("maxpool_output_pipe",__dim0__(B));
	write_uint16("maxpool_output_pipe",__dim1__(B));
	write_uint16("maxpool_output_pipe",__dim2__(B));
	uint64_t size = __NumberOfElementsInSizedTensor__(B);
	int i;
	for(i=0; i < (size>>2); i++)
	{
		__set4xi16__(i);
	}
	fprintf(stderr,"Ending test_send\n");
}


void maxPool3D()
{
	testConfigure();	
	__maxPoolOfTensors3D__(T,B,length,stride);
	sendB ();
}