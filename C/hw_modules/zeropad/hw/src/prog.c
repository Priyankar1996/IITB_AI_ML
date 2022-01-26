#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
#endif

SizedTensor_16K input,output;
uint16_t pad;

#define __get4xi16__(element) ({\
	element = read_uint16 ("ZeroPad_input_pipe");\
	element = (element << 16) + read_uint16 ("ZeroPad_input_pipe");\
	element = (element << 16) + read_uint16 ("ZeroPad_input_pipe");\
	element = (element << 16) + read_uint16 ("ZeroPad_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = output.data_array[addr];\
	uint16_t out_data[4];\
	out_data[3] = element & 0xFFFF;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data [1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	write_uint16 ("ZeroPad_output_pipe",out_data[0]);\
	write_uint16 ("ZeroPad_output_pipe",out_data[1]);\
	write_uint16 ("ZeroPad_output_pipe",out_data[2]);\
	write_uint16 ("ZeroPad_output_pipe",out_data[3]);\
})

void ReadInputInfo()
{
    fprintf(stderr,"Starting test configure\n");

    input.descriptor.descriptor.data_type = i16;
    input.descriptor.descriptor.row_major_form = 1;
    input.descriptor.descriptor.number_of_dimensions = 3;
    int i1;
    for(i1 = 0;i1 < input.descriptor.descriptor.number_of_dimensions;i1++){
        input.descriptor.descriptor.dimensions[i1] = read_uint16 ("ZeroPad_input_pipe");
    }

    pad = read_uint16 ("ZeroPad_input_pipe");
    
    uint64_t input_size = __NumberOfElementsInSizedTensor__(input);

    for(i1 = 0; i1 < (input_size >> 2); i1++)
    {
        uint64_t element;
        // __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
        __get4xi16__(element);

        input.data_array[i1] = element;
    }
    fprintf(stderr,"Ending test_configure\n");
}

void sendOutput()
{
    fprintf(stderr,"Starting test send\n");
    write_uint16("ZeroPad_output_pipe",output.descriptor.descriptor.dimensions[0]);
    write_uint16("ZeroPad_output_pipe",output.descriptor.descriptor.dimensions[1]);
    write_uint16("ZeroPad_output_pipe",output.descriptor.descriptor.dimensions[2]);
    uint64_t size = __NumberOfElementsInSizedTensor__(output);
    int i2;
    for (i2 = 0; i2 < size; i2++){
        __set4xi16__(i2);
    }
    fprintf(stderr,"Ending test_send\n");
}

void zeropad_thread()
{
    ReadInputInfo();
    __zero_pad__(input,pad,output);
    sendOutput();
}