#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution_transpose_improved.h"

SizedTensor_16K input,output;
SizedTensor_1024 kernel;
TensorDescriptor desc_input,desc_output,desc_kernel;
uint16_t stride[2],padding;

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

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
    desc_input.data_type = i16;
    desc_input.row_major_form = read_uint16 ("ConvTranspose_input_pipe");;
    desc_input.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    int i;
    for(i = 0;i < desc_input.number_of_dimensions;i++){
        desc_input.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    desc_kernel.data_type = i16;
    desc_kernel.row_major_form = read_uint16 ("ConvTranspose_input_pipe");
    desc_kernel.number_of_dimensions = read_uint16 ("ConvTranspose_input_pipe");
    for(i = 0;i < desc_kernel.number_of_dimensions;i++){
        desc_kernel.dimensions[i] = read_uint16 ("ConvTranspose_input_pipe");
    }

    for(i=0; i<2; i++)
        stride[i] = read_uint16 ("ConvTranspose_input_pipe");

    padding = read_uint16 ("ConvTranspose_input_pipe");
    
	desc_output.dimensions[0] = read_uint16 ("ConvTranspose_input_pipe");
    desc_output.dimensions[1] = read_uint16 ("ConvTranspose_input_pipe");
    desc_output.dimensions[2] = read_uint16 ("ConvTranspose_input_pipe");
    
	uint64_t input_size = desc_input.dimensions[0]*desc_input.dimensions[1]*desc_input.dimensions[2];
    uint64_t kernel_size = desc_kernel.dimensions[0]*desc_kernel.dimensions[1]*desc_kernel.dimensions[2]*desc_kernel.dimensions[3];
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
    uint64_t size = desc_output.dimensions[0] * desc_output.dimensions[1] * desc_output.dimensions[2];
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
    __aa_barrier__();
    __ConvTransposeOptimized__(0,tensor_dim_0(desc_input)/2, 
                               0,tensor_dim_1(desc_input)/2, 
                               desc_input,desc_kernel,desc_output,
                               input,kernel,stride,padding,output);
    __aa_barrier__();
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
    __aa_barrier__();
    __ConvTransposeOptimized__(0,tensor_dim_0(desc_input)/2,
                               tensor_dim_1(desc_input)/2,tensor_dim_1(desc_input),
                               desc_input,desc_kernel,desc_output,
                               input,kernel,stride,padding,output);
    __aa_barrier__();
    #ifdef SW
        fprintf(stderr,"Block-1 done.\n");
    #endif
    write_uint16 ("Block1_done", s1);
}

void convTransposeC()
{
    uint16_t s2 = read_uint16("Block2_start");
    #ifdef SW
        fprintf(stderr,"Block-2 started.\n");
    #endif
    __aa_barrier__();
    __ConvTransposeOptimized__(tensor_dim_0(desc_input)/2,tensor_dim_0(desc_input),
                               0,tensor_dim_1(desc_input)/2,
                               desc_input,desc_kernel,desc_output,
                               input,kernel,stride,padding,output);
    __aa_barrier__();
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
    __aa_barrier__();
    __ConvTransposeOptimized__(tensor_dim_0(desc_input)/2,tensor_dim_0(desc_input),
                               tensor_dim_1(desc_input)/2,tensor_dim_1(desc_input),
                               desc_input,desc_kernel,desc_output,
                               input,kernel,stride,padding,output);
    __aa_barrier__();    
    #ifdef SW
        fprintf(stderr,"Block-3 done.\n");
    #endif
    write_uint16 ("Block3_done", s3);
}

void convTranspose()
{
    uint16_t rv = testConfigure();
    __aa_barrier__();

    write_uint16("Block0_start", rv);
    write_uint16("Block1_start", rv);
    write_uint16("Block2_start", rv);
    write_uint16("Block3_start", rv);
    uint16_t s0 = read_uint16("Block0_done");
    uint16_t s1 = read_uint16("Block1_done");
    uint16_t s2 = read_uint16("Block2_done");
    uint16_t s3 = read_uint16("Block3_done");   
    __aa_barrier__();
    
    sendOutput();
}
