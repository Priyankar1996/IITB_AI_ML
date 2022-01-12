#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"
SizedTensor_16K T,B;
int16_t length, stride;

void testConfigure()
{
	// configure the tensor T
	T.descriptor.descriptor.data_type = i16;
	T.descriptor.descriptor.row_major_form = 1;
	T.descriptor.descriptor.number_of_dimensions = 3;

	for (i = 0;i < T.descriptor.descriptor.number_of_dimensions;i++){
		T.descriptor.descriptor.dimensions[i] = read_int16 ("maxpool_input_pipe");
	}

	length = read_int16 ("maxpool_input_pipe");
	stride = read_int16 ("maxpool_input_pipe");

	// size = number of 16-bit values in data array..
	uint64_t size = __NumberOfElementsInSizedTensor__(T);
	int i;
	for (i = 0; i < (size >> 2); i++)
	{
		uint64_t element;
		// __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
 		__get4xi16__(element);

		T.data_array[i] = element;
	}
}


// this sends B...
void sendB()
{
}


int main()
{
	testConfigure();	
	__maxPoolOfTensors3D__(T,B,length,stride);
	sendB ();
}


