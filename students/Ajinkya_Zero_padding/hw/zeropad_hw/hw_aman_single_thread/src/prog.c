#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad_opt.h"


SizedTensor_16K T,R;

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
	element = read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = R.data_array[addr];\
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
	write_uint8 ("zeropad_output_pipe",out_data[0]);\
	write_uint8 ("zeropad_output_pipe",out_data[1]);\
	write_uint8 ("zeropad_output_pipe",out_data[2]);\
	write_uint8 ("zeropad_output_pipe",out_data[3]);\
	write_uint8 ("zeropad_output_pipe",out_data[4]);\
	write_uint8 ("zeropad_output_pipe",out_data[5]);\
	write_uint8 ("zeropad_output_pipe",out_data[6]);\
	write_uint8 ("zeropad_output_pipe",out_data[7]);\
})


void sendOutput(size)
{
    int i;
    for (i = 0; i < (size >> 2); i++){
        __set4xi16__(i);
    }
}



void zeropad3D()
{
    uint16_t t0 = read_uint8("zeropad_input_pipe");
    t0 = (t0 << 8) + read_uint8("zeropad_input_pipe");
    uint16_t t1 = read_uint8("zeropad_input_pipe");
    t1 = (t1 << 8) + read_uint8("zeropad_input_pipe");
    uint16_t t2 = read_uint8("zeropad_input_pipe");
    t2 = (t2 << 8) + read_uint8("zeropad_input_pipe");
    uint16_t pad = read_uint8("zeropad_input_pipe");
    pad = (pad << 8) + read_uint8("zeropad_input_pipe");
    uint16_t r0 = read_uint8("zeropad_input_pipe");
    r0 = (r0 << 8) + read_uint8("zeropad_input_pipe");
    uint16_t r1 = read_uint8("zeropad_input_pipe");
    r1 = (r1 << 8) + read_uint8("zeropad_input_pipe");
    uint16_t r2 = read_uint8("zeropad_input_pipe");
    r2 = (r2 << 8) + read_uint8("zeropad_input_pipe");

    __aa_barrier__();
    uint32_t size = t0 * t1 * t2;
	uint32_t i;
	for(i = 0; i < (size >> 3); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        T.data_array[i] = element;
    }


    #ifndef SW
	    uint64_t start_time = timer();
    #endif
    __zero_pad_opt__(0,t0,0,t1,0,t2,t0,t1,t2,r0,r1,r2,T,pad,R);
    
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
	write_uint8 ("zeropad_output_pipe",time_data[0]);
	write_uint8 ("zeropad_output_pipe",time_data[1]);
	write_uint8 ("zeropad_output_pipe",time_data[2]);
	write_uint8 ("zeropad_output_pipe",time_data[3]);
    write_uint8 ("zeropad_output_pipe",time_data[4]);
	write_uint8 ("zeropad_output_pipe",time_data[5]);
	write_uint8 ("zeropad_output_pipe",time_data[6]);
	write_uint8 ("zeropad_output_pipe",time_data[7]);
    #endif
    __aa_barrier__();

    sendOutput(r0*r1*r2);
}
