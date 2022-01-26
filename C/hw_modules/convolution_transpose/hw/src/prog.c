#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution_transpose_improved.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
#endif

SizedTensor_16K input,output;
SizedTensor_1024 kernel;
uint16_t stride[2],padding;

#define __get4xi16__(element) ({\
	element = read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = output.data_array[addr];\
	uint16_t out_data[4];\
	out_data[3] = element & 0xFFFF;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data[1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	write_uint16 ("ConvTranspose_output_pipe",out_data[3]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[2]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[1]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[0]);\
})

uint64_t getRemainingElements(uint16_t ne){
	uint64_t element = 0;uint16_t n;
	for (n = 0 ; n < ne; n++){
		element += read_uint16 ("ConvTranspose_input_pipe");
		element <<= 16;
	}
	element <<= 16*(3-ne);
	return element;
}

void sendRemainingElements(int addr, uint16_t ne){
	uint64_t element = output.data_array[addr];\
	uint16_t out_data[3],n;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data[1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	for (n = 0; n < ne; n++)
		write_uint16 ("ConvTranspose_output_pipe",out_data[n]);
}

void testConfigure()
{
    input.descriptor.descriptor.data_type = u16;
    input.descriptor.descriptor.row_major_form = read_uint16 ("ConvTranspose_input_pipe");;
    input.descriptor.descriptor.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    int i;
    for(i = 0;i < input.descriptor.descriptor.number_of_dimensions;i++){
        input.descriptor.descriptor.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    kernel.descriptor.descriptor.data_type = u16;
    kernel.descriptor.descriptor.row_major_form = read_uint16 ("ConvTranspose_input_pipe");
    kernel.descriptor.descriptor.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    for(i = 0;i < kernel.descriptor.descriptor.number_of_dimensions;i++){
        kernel.descriptor.descriptor.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    for(i=0; i<2; i++)
        stride[i] = read_uint16 ("ConvTranspose_input_pipe");

    padding = read_uint16 ("ConvTranspose_input_pipe");
    
	output.descriptor.descriptor.dimensions[0] = read_uint16("ConvTranspose_input_pipe");
    output.descriptor.descriptor.dimensions[1] = read_uint16("ConvTranspose_input_pipe");
    output.descriptor.descriptor.dimensions[2] = read_uint16("ConvTranspose_input_pipe");
    
	uint64_t input_size = __NumberOfElementsInSizedTensor__(input);
    uint64_t kernel_size = __NumberOfElementsInSizedTensor__(kernel);
    for(i = 0; i < (input_size >> 2); i ++)
    {
        uint64_t element;
        // __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
        __get4xi16__(element);

        input.data_array[i] = element;
    }
    if (input_size&3) input.data_array[i] = getRemainingElements(input_size&3);
    for(i = 0; i < (kernel_size >> 2); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        kernel.data_array[i] = element;
    }
    if (kernel_size&3) kernel.data_array[i] = getRemainingElements(kernel_size&3);

}

void sendB()
{
    uint64_t size = __NumberOfElementsInSizedTensor__(output);
    int i;
    for (i = 0; i < size; i++){
        __set4xi16__(i);
    }
    if (size&3) sendRemainingElements(i,size&3);
}

void convTranspose()
{
    testConfigure();
    #ifndef SW
	    uint64_t start_time = timer();
    #endif
    __ConvTranspose__(input,kernel,stride,padding,output);
    #ifndef SW
	    uint64_t stop_time = timer();
	    uint64_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif
    sendB();
}
