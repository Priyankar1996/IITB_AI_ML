#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"


#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
void concat_core(uint16_t,uint16_t,uint32_t,uint8_t,uint8_t,uint8_t);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

void concat(uint16_t input1_dim0,uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0,uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2)
{
    uint32_t output_size = out_dim0 * out_dim1 * out_dim2;
    uint16_t count1 = (input1_dim2)>>3;
    uint16_t count2 = (input2_dim2)>>3; 
    concat_core(count1,count2,output_size,index0,index1,index2);
 
}
