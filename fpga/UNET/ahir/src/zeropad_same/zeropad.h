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
void zeropad_same(uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint16_t,uint8_t,uint8_t);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

void zeropad(uint16_t input_dim0,uint16_t input_dim1,uint16_t input_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2)
{
    zeropad_same(input_dim0,input_dim1,input_dim2,out_dim0,out_dim1,out_dim2,index1,index2);
} 
