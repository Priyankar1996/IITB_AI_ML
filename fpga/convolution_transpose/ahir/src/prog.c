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
	element = read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
    element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
	element = (element << 8) + read_uint8 ("ConvTranspose_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = output.data_array[addr];\
	uint8_t out_data[8];\
	out_data[7] = element & 0xFF;\
	element>>=8;\
	out_data[6] = element & 0xFF;\
	element>>=8;\
	out_data[5]= element & 0xFF;\
	element>>=8;\
    out_data[4] = element & 0xFF;\
	element>>=8;\
	out_data[3] = element & 0xFF;\
	element>>=8;\
	out_data[2] = element & 0xFF;\
	element>>=8;\
    out_data[1] = element & 0xFF;\
	element>>=8;\
	out_data[0] = element & 0xFFFF;\
	write_uint8 ("ConvTranspose_output_pipe",out_data[0]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[1]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[2]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[3]);\
    write_uint8 ("ConvTranspose_output_pipe",out_data[4]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[5]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[6]);\
	write_uint8 ("ConvTranspose_output_pipe",out_data[7]);\
})

uint16_t testConfigure()
{
    desc_input.number_of_dimensions = read_uint8 ("ConvTranspose_input_pipe");
    desc_input.number_of_dimensions = (desc_input.number_of_dimensions << 8) + read_uint8 ("ConvTranspose_input_pipe");

    int i;
    for(i = 0;i < desc_input.number_of_dimensions;i++){
        desc_input.dimensions[i] = read_uint8 ("ConvTranspose_input_pipe");
        desc_input.dimensions[i] = (desc_input.dimensions[i] << 8) + read_uint8 ("ConvTranspose_input_pipe");

    }

    desc_kernel.number_of_dimensions = read_uint8 ("ConvTranspose_input_pipe");
    desc_kernel.number_of_dimensions = (desc_kernel.number_of_dimensions << 8) + read_uint8 ("ConvTranspose_input_pipe");

    for(i = 0;i < desc_kernel.number_of_dimensions;i++){
        desc_kernel.dimensions[i] = read_uint8 ("ConvTranspose_input_pipe");
        desc_kernel.dimensions[i] = (desc_kernel.dimensions[i] << 8) + read_uint8 ("ConvTranspose_input_pipe");
    }

    for(i=0; i<2; i++) {
        stride[i] = read_uint8 ("ConvTranspose_input_pipe");
        stride[i] = (stride[i] << 8) + read_uint8 ("ConvTranspose_input_pipe");
        
    }
    padding = read_uint8 ("ConvTranspose_input_pipe");
    padding = (padding << 8) + read_uint8 ("ConvTranspose_input_pipe");
    
	desc_output.dimensions[0] = read_uint8 ("ConvTranspose_input_pipe");
    desc_output.dimensions[0] = (desc_output.dimensions[0] << 8) + read_uint8 ("ConvTranspose_input_pipe");
    desc_output.dimensions[1] = read_uint8 ("ConvTranspose_input_pipe");
    desc_output.dimensions[1] = (desc_output.dimensions[1] << 8) + read_uint8 ("ConvTranspose_input_pipe");
    desc_output.dimensions[2] = read_uint8 ("ConvTranspose_input_pipe");
    desc_output.dimensions[2] = (desc_output.dimensions[2] << 8) + read_uint8 ("ConvTranspose_input_pipe");
    
	uint32_t input_size = desc_input.dimensions[0]*desc_input.dimensions[1]*desc_input.dimensions[2];
    uint32_t kernel_size = desc_kernel.dimensions[0]*desc_kernel.dimensions[1]*desc_kernel.dimensions[2]*desc_kernel.dimensions[3];
    for(i = 0; i < (input_size >> 2); i ++)
    {
        uint64_t element;
        // __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
        __get4xi16__(element);

        input.data_array[i] = element;
    }

    for(i = 0; i < (kernel_size >> 2); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        kernel.data_array[i] = element;
    }

    uint32_t output_size = desc_output.dimensions[0] * desc_output.dimensions[1] * desc_output.dimensions[2];
    for(i = 0; i < output_size>>2; i++)
        output.data_array[i] = 0;

    return(1);
}

void sendOutput()
{
    uint32_t size = desc_output.dimensions[0] * desc_output.dimensions[1] * desc_output.dimensions[2];
    int i;
    for (i = 0; i < (size >> 2); i++){
        __set4xi16__(i);
    }
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

    #ifndef SW
	    uint32_t start_time = timer();
    #endif

    write_uint16("Block0_start", rv);
    write_uint16("Block1_start", rv);
    write_uint16("Block2_start", rv);
    write_uint16("Block3_start", rv);
    uint16_t s0 = read_uint16("Block0_done");
    uint16_t s1 = read_uint16("Block1_done");
    uint16_t s2 = read_uint16("Block2_done");
    uint16_t s3 = read_uint16("Block3_done");   
    __aa_barrier__();

    #ifndef SW
	    uint32_t stop_time = timer();
	    uint32_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif
    
    sendOutput();
}
