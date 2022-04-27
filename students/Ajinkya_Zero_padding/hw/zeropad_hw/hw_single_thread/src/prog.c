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
TensorDescriptor des_inp,des_out;
uint8_t pad;

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

// uint64_t getRemainingElements(uint16_t ne){
// 	uint64_t element = 0;uint16_t n;
// 	for (n = 0 ; n < ne; n++){
// 		element += read_uint16 ("zeropad_input_pipe");
// 		element <<= 16;
// 	}
// 	element <<= 16*(3-ne);
// 	return element;
// }

// void sendRemainingElements(int addr, uint16_t ne){
// 	uint64_t element = R.data_array[addr];\
// 	__dt__ out_data[3],n;\
// 	element>>=16;\
// 	out_data[2] = element & 0xFFFF;\
// 	element>>=16;\
// 	out_data[1]= element & 0xFFFF;\
// 	element>>=16;\
// 	out_data[0] = element & 0xFFFF;\
// 	for (n = 0; n < ne; n++)
// 		write_uint16 ("zeropad_output_pipe",out_data[n]);
// }

uint16_t testConfigure()
{
	des_inp.data_type = i16;
    des_inp.row_major_form = read_uint8 ("zeropad_input_pipe");;
    des_inp.number_of_dimensions = read_uint8 ("zeropad_input_pipe");
    int i;
    for(i = 0;i < des_inp.number_of_dimensions;i++){
        des_inp.dimensions[i] = read_uint8 ("zeropad_input_pipe");
    }

    pad = read_uint8 ("zeropad_input_pipe");
    
	des_out.dimensions[0] = read_uint8 ("zeropad_input_pipe");
    des_out.dimensions[1] = read_uint8 ("zeropad_input_pipe");
    des_out.dimensions[2] = read_uint8 ("zeropad_input_pipe");
    
	// uint64_t input_size = __NumberOfElementsInSizedTensor__(T);
    uint64_t input_size = des_inp.dimensions[0]*des_inp.dimensions[1]*des_inp.dimensions[2];
	fprintf(stderr,"Hello World!\n");    
    
    for(i = 0; i < (input_size >> 2); i ++)
    {
        uint64_t element;
        // __get4xi16__ reads 4 16-bit numbers from
		// maxpool_input_pipe, and packs them into 
		// a 64 bit number
        __get4xi16__(element);

        T.data_array[i] = element;
    }
    #ifdef SW
        fprintf(stderr,"Test configure complete.\n");
    #endif
    // if (input_size&3) T.data_array[i] = getRemainingElements(input_size&3);
    return(input_size);
}

void sendOutput()
{
    uint64_t size = des_out.dimensions[0] * des_out.dimensions[1] * des_out.dimensions[2];
    int i;
    for (i = 0; i < (size >> 2); i++){
        __set4xi16__(i);
    }
    // if (size&3) sendRemainingElements(i,size&3);
}

void zeropad3D_A()
{
    uint8_t s0 = read_uint8("Block0_starting");
    #ifdef SW
        fprintf(stderr,"Block-0 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__(0,des_inp.dimensions[0],
                               0,des_inp.dimensions[1],des_inp,des_out,
                               T,pad,R);
    __aa_barrier__();
    #ifdef SW
	    fprintf(stderr,"Block-0 done.\n");
    #endif
	write_uint8 ("Block0_complete", s0);
}


void zeropad3D()
{
    uint16_t rv = testConfigure();
    __aa_barrier__();

    #ifndef SW
	    uint64_t start_time = timer();
    #endif
    write_uint8("Block0_starting", rv);
    uint8_t s0 = read_uint8("Block0_complete");
    __aa_barrier__();
    
    #ifndef SW
	    uint64_t stop_time = timer();
	    uint64_t elapsed_time = stop_time - start_time;
	    write_uint64("elapsed_time_pipe", elapsed_time);
    #endif
    __aa_barrier__();

    sendOutput();
}
