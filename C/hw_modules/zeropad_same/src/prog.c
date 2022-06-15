#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"


SizedTensor_16K T[2];

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
void zeropad_same(uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint8_t,uint8_t);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

#define __get8xi8__(element) ({\
	element = read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
    element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("Zeropad_input_pipe");\
})

#define __set8xi8__(addr) ({\
	uint64_t element = T[1].data_array[addr];\
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
	write_uint8 ("Zeropad_output_pipe",out_data[0]);\
	write_uint8 ("Zeropad_output_pipe",out_data[1]);\
	write_uint8 ("Zeropad_output_pipe",out_data[2]);\
	write_uint8 ("Zeropad_output_pipe",out_data[3]);\
    write_uint8 ("Zeropad_output_pipe",out_data[4]);\
	write_uint8 ("Zeropad_output_pipe",out_data[5]);\
	write_uint8 ("Zeropad_output_pipe",out_data[6]);\
	write_uint8 ("Zeropad_output_pipe",out_data[7]);\
})

void zeropad()
{
    uint16_t input_dim0,input_dim1,input_dim2,out_dim0,out_dim1,out_dim2;
    input_dim0 = read_uint8 ("Zeropad_input_pipe");
    input_dim0 = (input_dim0 << 8) + read_uint8 ("Zeropad_input_pipe");
    input_dim1 = read_uint8 ("Zeropad_input_pipe");
    input_dim1 = (input_dim1 << 8) + read_uint8 ("Zeropad_input_pipe");
    input_dim2 = read_uint8 ("Zeropad_input_pipe");
    input_dim2 = (input_dim2 << 8) + read_uint8 ("Zeropad_input_pipe");

    out_dim0 = read_uint8 ("Zeropad_input_pipe");
    out_dim0 = (out_dim0 << 8) + read_uint8 ("Zeropad_input_pipe");
    out_dim1 = read_uint8 ("Zeropad_input_pipe");
    out_dim1 = (out_dim1 << 8) + read_uint8 ("Zeropad_input_pipe");
    out_dim2 = read_uint8 ("Zeropad_input_pipe");
    out_dim2 = (out_dim2 << 8) + read_uint8 ("Zeropad_input_pipe");

    int i;
    uint32_t input1_size = input_dim0 * input_dim1 * input_dim2;
    uint32_t output_size = out_dim0 * out_dim1 *out_dim2;
    
    for(i = 0; i < (input1_size >> 3); i ++)
    {
        uint64_t element;
        __get8xi8__(element);
        T[0].data_array[i] = element;
    }

    for(i = 0; i < (output_size >> 3); i ++)
    {
        T[1].data_array[i] = 0;
    }
    __aa_barrier__();
#ifndef SW
    uint64_t start_time = timer();
    __aa_barrier__();
#endif
    zeropad_same(input_dim0,input_dim1,input_dim2,out_dim0,out_dim1,out_dim2,0,1);
    __aa_barrier__();
#ifndef SW
    uint64_t stop_time = timer();
    uint64_t elapsed_time = stop_time - start_time;
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
	write_uint8 ("Zeropad_output_pipe",time_data[0]);
	write_uint8 ("Zeropad_output_pipe",time_data[1]);
	write_uint8 ("Zeropad_output_pipe",time_data[2]);
	write_uint8 ("Zeropad_output_pipe",time_data[3]);
    write_uint8 ("Zeropad_output_pipe",time_data[4]);
	write_uint8 ("Zeropad_output_pipe",time_data[5]);
	write_uint8 ("Zeropad_output_pipe",time_data[6]);
	write_uint8 ("Zeropad_output_pipe",time_data[7]);
#endif    
    __aa_barrier__();
    for (i = 0; i < (output_size >> 3); i++){
        __set8xi8__(i);
    }
}