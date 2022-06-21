#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"


SizedTensor_16K T[3];

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
void ct_core(uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint8_t,uint8_t);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

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
	uint64_t element = T[2].data_array[addr];\
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

void convTranspose()
{
    uint16_t inp_dim0,inp_dim1,inp_dim2,ker_dim0,ker_dim1,ker_dim2,ker_dim3,stride0,padding,out_dim0,out_dim1,out_dim2;
    inp_dim0 = read_uint8 ("ConvTranspose_input_pipe");
    inp_dim0 = (inp_dim0 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    inp_dim1 = read_uint8 ("ConvTranspose_input_pipe");
    inp_dim1 = (inp_dim1 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    inp_dim2 = read_uint8 ("ConvTranspose_input_pipe");
    inp_dim2 = (inp_dim2 << 8) + read_uint8 ("ConvTranspose_input_pipe");

    ker_dim0 = read_uint8 ("ConvTranspose_input_pipe");
    ker_dim0 = (ker_dim0 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    ker_dim1 = read_uint8 ("ConvTranspose_input_pipe");
    ker_dim1 = (ker_dim1 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    ker_dim2 = read_uint8 ("ConvTranspose_input_pipe");
    ker_dim2 = (ker_dim2 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    ker_dim3 = read_uint8 ("ConvTranspose_input_pipe");
    ker_dim3 = (ker_dim3 << 8) + read_uint8 ("ConvTranspose_input_pipe");

    uint32_t input_size = inp_dim0 * inp_dim1 * inp_dim2;    
    uint32_t kernel_size = ker_dim0 * ker_dim1 * ker_dim2 * ker_dim3;
    
    stride0 = read_uint8 ("ConvTranspose_input_pipe");
    stride0 = (stride0 << 8) + read_uint8 ("ConvTranspose_input_pipe");

    padding = read_uint8 ("ConvTranspose_input_pipe");
    padding = (padding << 8) + read_uint8 ("ConvTranspose_input_pipe");

    out_dim0 = read_uint8 ("ConvTranspose_input_pipe");
    out_dim0 = (out_dim0 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    out_dim1 = read_uint8 ("ConvTranspose_input_pipe");
    out_dim1 = (out_dim1 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    out_dim2 = read_uint8 ("ConvTranspose_input_pipe");
    out_dim2 = (out_dim2 << 8) + read_uint8 ("ConvTranspose_input_pipe");
    
    int i;
    for(i = 0; i < (input_size >> 3); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        T[0].data_array[i] = element;
    }

    for(i = 0; i < (kernel_size >> 3); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        T[1].data_array[i] = element;
    }

    uint32_t output_size = out_dim0 * out_dim1 * out_dim2;
    for(i = 0; i < (output_size >> 3); i++)
        T[2].data_array[i] = 0;
#ifndef SW
    __aa_barrier__();
    uint64_t start_time = timer();
    __aa_barrier__();
#endif
    ct_core(inp_dim0,inp_dim1,inp_dim2,ker_dim1,ker_dim2,out_dim0,out_dim1,out_dim2,stride0,padding,0,2);
    __aa_barrier__();
#ifndef SW
    uint64_t stop_time = timer();
    uint64_t elapsed_time = stop_time - start_time;
    __aa_barrier__();
	uint8_t time_data[8];
	time_data[7] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[6] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[5] = elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[4] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[3] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[2] = elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[1] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[0] = elapsed_time & 0xFF;
	write_uint8 ("ConvTranspose_output_pipe",time_data[0]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[1]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[2]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[3]);
    write_uint8 ("ConvTranspose_output_pipe",time_data[4]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[5]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[6]);
	write_uint8 ("ConvTranspose_output_pipe",time_data[7]);
#endif    
    __aa_barrier__();

    for (i = 0; i < (output_size >> 3); i++){
        __set4xi16__(i);
    }   
}
