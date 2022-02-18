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
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__ {;}
#endif

SizedTensor_16K input,output;
SizedTensor_1024 kernel;
uint16_t stride[2],padding;

#define __dt__ int16_t

#define __get4xi16__(element) ({\
	element = read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
	element = (element << 16) + read_uint16 ("ConvTranspose_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = output.data_array[addr];\
	__dt__ out_data[4];\
	out_data[3] = element & 0xFFFF;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data[1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	write_uint16 ("ConvTranspose_output_pipe",out_data[0]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[1]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[2]);\
	write_uint16 ("ConvTranspose_output_pipe",out_data[3]);\
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
	__dt__ out_data[3],n;\
	element>>=16;\
	out_data[2] = element & 0xFFFF;\
	element>>=16;\
	out_data[1]= element & 0xFFFF;\
	element>>=16;\
	out_data[0] = element & 0xFFFF;\
	for (n = 0; n < ne; n++)
		write_uint16 ("ConvTranspose_output_pipe",out_data[n]);
}

uint16_t testConfigure()
{
    input.descriptor.descriptor.data_type = i16;
    input.descriptor.descriptor.row_major_form = read_uint16 ("ConvTranspose_input_pipe");;
    input.descriptor.descriptor.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    int i;
    for(i = 0;i < input.descriptor.descriptor.number_of_dimensions;i++){
        input.descriptor.descriptor.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    kernel.descriptor.descriptor.data_type = i16;
    kernel.descriptor.descriptor.row_major_form = read_uint16 ("ConvTranspose_input_pipe");
    kernel.descriptor.descriptor.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    for(i = 0;i < kernel.descriptor.descriptor.number_of_dimensions;i++){
        kernel.descriptor.descriptor.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    for(i=0; i<2; i++)
        stride[i] = read_uint16 ("ConvTranspose_input_pipe");

    padding = read_uint16 ("ConvTranspose_input_pipe");
    
	output.descriptor.descriptor.dimensions[0] = read_uint16 ("ConvTranspose_input_pipe");
    output.descriptor.descriptor.dimensions[1] = read_uint16 ("ConvTranspose_input_pipe");
    output.descriptor.descriptor.dimensions[2] = read_uint16 ("ConvTranspose_input_pipe");
    
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
    /*uint64_t output_size = output.descriptor.descriptor.dimensions[0] * output.descriptor.descriptor.dimensions[1] * output.descriptor.descriptor.dimensions[2];
    for(i = 0; i < output_size>>2; i++)
        output.data_array[i] = 0;*/

    return(input_size);
}

void sendOutput()
{
    uint64_t size = output.descriptor.descriptor.dimensions[0] * output.descriptor.descriptor.dimensions[1] * output.descriptor.descriptor.dimensions[2];
    int i;
    for (i = 0; i < (size >> 2); i++){
        __set4xi16__(i);
    }
    if (size&3) sendRemainingElements(i,size&3);
}

void convTransposeA()
{
    uint16_t s0 = read_uint16("Block0_start");
    #ifdef SW
        fprintf(stderr,"Block-0 started.\n");
    #endif
    __ConvTransposeOptimized__(0,(input.descriptor.descriptor.dimensions[0]),
                               0,(input.descriptor.descriptor.dimensions[1]/2),
                               input,kernel,stride,padding,output);
    #ifdef SW
	    fprintf(stderr,"Block-0 done.\n");
    #endif
	write_uint16 ("Block0_done", s0);
}

void convTransposeB()
{
    uint16_t s1 = read_uint16("Block1_start");
    #ifdef SW
        fprintf(stderr,"Block-1 started.\n");
    #endif
    __ConvTransposeOptimized__(0,(input.descriptor.descriptor.dimensions[0]),
                            (input.descriptor.descriptor.dimensions[1]/2),
                            input.descriptor.descriptor.dimensions[1],
                            input,kernel,stride,padding,output);
    #ifdef SW
        fprintf(stderr,"Block-1 done.\n");
    #endif
    write_uint16 ("Block1_done", s1);
}

/*void convTransposeC()
{
    uint16_t s2 = read_uint16("Block2_start");
    #ifdef SW
        fprintf(stderr,"Block-2 started.\n");
    #endif
    __ConvTransposeOptimized__((input.descriptor.descriptor.dimensions[0]/2),
                               input.descriptor.descriptor.dimensions[0],0,
                               (input.descriptor.descriptor.dimensions[1]/2),
                               input,kernel,stride,padding,output);
    #ifdef SW
        fprintf(stderr,"Block-2 done.\n");
    #endif
    write_uint16 ("Block2_done", s2);
}

void convTransposeD()
{
    uint16_t s3 = read_uint16("Block3_start");
    #ifdef SW
        fprintf(stderr,"Block-3 started.\n");
    #endif
    __ConvTransposeOptimized__((input.descriptor.descriptor.dimensions[0]/2),
                               input.descriptor.descriptor.dimensions[0],
                               (input.descriptor.descriptor.dimensions[1]/2),
                               input.descriptor.descriptor.dimensions[1],
                               input,kernel,stride,padding,output);    
    #ifdef SW
        fprintf(stderr,"Block-3 done.\n");
    #endif
    write_uint16 ("Block3_done", s3);
}*/

void convTranspose()
{
    uint16_t rv = testConfigure();
    #ifndef SW
	    uint64_t start_time = timer();
    #endif

	__aa_barrier__();

    write_uint16("Block0_start", rv);
    write_uint16("Block1_start", rv);
    //write_uint16("Block2_start", 1);
    //write_uint16("Block3_start", 1);

	__aa_barrier__();

    uint16_t s0 = read_uint16("Block0_done");
    uint16_t s1 = read_uint16("Block1_done");
    //uint16_t s2 = read_uint16("Block2_done");
    //uint16_t s3 = read_uint16("Block3_done");   
    #ifndef SW
	    uint64_t stop_time = timer();
	    uint64_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif

	__aa_barrier__();

    sendOutput();
}
