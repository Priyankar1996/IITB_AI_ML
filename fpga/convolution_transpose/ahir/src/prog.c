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

void convTransposeA()
{
    uint16_t i[3],k[4],o[3],s,p;
    uint32_t offset;
    i[0]   = read_uint16("Block0_start");
    i[1]   = read_uint16("Block0_start");
    i[2]   = read_uint16("Block0_start");
    k[0]   = read_uint16("Block0_start");
    k[1]   = read_uint16("Block0_start");
    k[2]   = read_uint16("Block0_start");
    k[3]   = read_uint16("Block0_start");
    s      = read_uint16("Block0_start");
    p      = read_uint16("Block0_start");
    offset = read_uint16("Block0_start");
    offset = (offset << 16) + read_uint16("Block0_start");
    o[0]   = read_uint16("Block0_start");
    o[1]   = read_uint16("Block0_start");
    o[2]   = read_uint16("Block0_start");
    __aa_barrier__();

    __ConvTransposeOptimized__(0,(i[0]>>2),0,i[1], 
                               i,k,o,offset,input,kernel,s,p,output);
    __aa_barrier__();
    write_uint16 ("Block0_done", 1);
}

void convTransposeB()
{
    uint16_t i[3],k[4],o[3],s,p;
    uint32_t offset;
    i[0] = read_uint16("Block1_start");
    i[1] = read_uint16("Block1_start");
    i[2] = read_uint16("Block1_start");
    k[0] = read_uint16("Block1_start");
    k[1] = read_uint16("Block1_start");
    k[2] = read_uint16("Block1_start");
    k[3] = read_uint16("Block1_start");
    s    = read_uint16("Block1_start");
    p    = read_uint16("Block1_start");
    offset = read_uint16("Block1_start");
    offset = (offset << 16) + read_uint16("Block1_start");
    o[0] = read_uint16("Block1_start");
    o[1] = read_uint16("Block1_start");
    o[2] = read_uint16("Block1_start");
    __aa_barrier__();

    __ConvTransposeOptimized__((i[0]>>2),(i[0]>>1),0,i[1],
                               i,k,o,offset,input,kernel,s,p,output);
    __aa_barrier__();
    write_uint16 ("Block1_done", 1);
}

void convTransposeC()
{
    uint16_t i[3],k[4],o[3],s,p;uint32_t offset;
    i[0] = read_uint16("Block2_start");
    i[1] = read_uint16("Block2_start");
    i[2] = read_uint16("Block2_start");
    k[0] = read_uint16("Block2_start");
    k[1] = read_uint16("Block2_start");
    k[2] = read_uint16("Block2_start");
    k[3] = read_uint16("Block2_start");
    s    = read_uint16("Block2_start");
    p    = read_uint16("Block2_start");
    offset = read_uint16("Block2_start");
    offset = (offset << 16) + read_uint16("Block2_start");
    o[0] = read_uint16("Block2_start");
    o[1] = read_uint16("Block2_start");
    o[2] = read_uint16("Block2_start");
    __aa_barrier__();
    __ConvTransposeOptimized__((i[0]>>1),((i[0]>>2) + (i[0]>>1)),0,i[1],
                               i,k,o,offset,input,kernel,s,p,output);
    __aa_barrier__();
    write_uint16 ("Block2_done", 1);
}

void convTransposeD()
{
    uint16_t i[3],k[4],o[3],s,p;uint32_t offset;
    i[0] = read_uint16("Block3_start");
    i[1] = read_uint16("Block3_start");
    i[2] = read_uint16("Block3_start");
    k[0] = read_uint16("Block3_start");
    k[1] = read_uint16("Block3_start");
    k[2] = read_uint16("Block3_start");
    k[3] = read_uint16("Block3_start");
    s    = read_uint16("Block3_start");
    p    = read_uint16("Block3_start");
    offset = read_uint16("Block3_start");
    offset = (offset << 16) + read_uint16("Block3_start");
    o[0] = read_uint16("Block3_start");
    o[1] = read_uint16("Block3_start");
    o[2] = read_uint16("Block3_start");
    __aa_barrier__();
    __ConvTransposeOptimized__(((i[0]>>2) + (i[0]>>1)),i[0],0,i[1],
                               i,k,o,offset,input,kernel,s,p,output);
    __aa_barrier__();    
    write_uint16 ("Block3_done", 1);
}

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
    uint32_t offset0 = 0, offset1 = (input_size >> 2), offset2 = offset1 + (input_size >> 2),offset3 = offset2 + (input_size >> 2);
    
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
    for(i = 0; i < (input_size >> 2); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        input.data_array[i] = element;
    }

    for(i = 0; i < (kernel_size >> 2); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        kernel.data_array[i] = element;
    }

    uint32_t output_size = out_dim0 * out_dim1 * out_dim2;
    for(i = 0; i < (output_size >> 2); i++)
        output.data_array[i] = 0;
    __aa_barrier__();
#ifndef SW
    uint64_t start_time = timer();
#endif
    write_uint16("Block0_start", inp_dim0);
    write_uint16("Block0_start", inp_dim1);
    write_uint16("Block0_start", inp_dim2);
    write_uint16("Block0_start", ker_dim0);
    write_uint16("Block0_start", ker_dim1);
    write_uint16("Block0_start", ker_dim2);
    write_uint16("Block0_start", ker_dim3);
    write_uint16("Block0_start", stride0);
    write_uint16("Block0_start", padding);
    write_uint16("Block0_start", offset0);
    write_uint16("Block0_start", (offset0 >> 16));
    write_uint16("Block0_start", out_dim0);
    write_uint16("Block0_start", out_dim1);
    write_uint16("Block0_start", out_dim2);
    
    write_uint16("Block1_start", inp_dim0);
    write_uint16("Block1_start", inp_dim1);
    write_uint16("Block1_start", inp_dim2);
    write_uint16("Block1_start", ker_dim0);
    write_uint16("Block1_start", ker_dim1);
    write_uint16("Block1_start", ker_dim2);
    write_uint16("Block1_start", ker_dim3);
    write_uint16("Block1_start", stride0);
    write_uint16("Block1_start", padding);
    write_uint16("Block1_start", offset1);
    write_uint16("Block1_start", (offset1 >> 16));
    write_uint16("Block1_start", out_dim0);
    write_uint16("Block1_start", out_dim1);
    write_uint16("Block1_start", out_dim2);
     
    write_uint16("Block2_start", inp_dim0);
    write_uint16("Block2_start", inp_dim1);
    write_uint16("Block2_start", inp_dim2);
    write_uint16("Block2_start", ker_dim0);
    write_uint16("Block2_start", ker_dim1);
    write_uint16("Block2_start", ker_dim2);
    write_uint16("Block2_start", ker_dim3);
    write_uint16("Block2_start", stride0);
    write_uint16("Block2_start", padding);
    write_uint16("Block2_start", offset2); 
    write_uint16("Block2_start", (offset2 >> 16));
    write_uint16("Block2_start", out_dim0);
    write_uint16("Block2_start", out_dim1);
    write_uint16("Block2_start", out_dim2);   
 
    write_uint16("Block3_start", inp_dim0);
    write_uint16("Block3_start", inp_dim1);
    write_uint16("Block3_start", inp_dim2);
    write_uint16("Block3_start", ker_dim0);
    write_uint16("Block3_start", ker_dim1);
    write_uint16("Block3_start", ker_dim2);
    write_uint16("Block3_start", ker_dim3);
    write_uint16("Block3_start", stride0);
    write_uint16("Block3_start", padding);
    write_uint16("Block3_start", offset3);
    write_uint16("Block3_start", (offset3 >> 16));
    write_uint16("Block3_start", out_dim0);
    write_uint16("Block3_start", out_dim1);
    write_uint16("Block3_start", out_dim2);
    

    uint16_t s0 = read_uint16("Block0_done");
    uint16_t s1 = read_uint16("Block1_done");
    uint16_t s2 = read_uint16("Block2_done");
    uint16_t s3 = read_uint16("Block3_done");   
    __aa_barrier__();
#ifndef SW
    uint64_t stop_time = timer();
    uint64_t elapsed_time = stop_time - start_time;
    write_uint64("elapsed_time_pipe", elapsed_time);
#endif    
    __aa_barrier__();

    for (i = 0; i < (output_size >> 2); i++){
        __set4xi16__(i);
    }   
}
