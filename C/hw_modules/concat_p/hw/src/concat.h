//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __concat_h__
#define __concat_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void concat();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __ConcatTensors__(input1,input2,output,count1,count2,out_size) ({\
    uint16_t add_out=0,add_inp1=0,add_inp2=0,count_inp1=0,count_inp2=0;\
    while(1) {\
        __loop_pipeline_var__\
        if(count_inp1 < count1) {\
            output.data_array[add_out] = input1.data_array[add_inp1];\
            count_inp1++;\
            add_inp1++;\
            add_out++;\
        }\
        if(count_inp1 == count1 && count_inp2 < count2) {\
            output.data_array[add_out] = input2.data_array[add_inp2];\
            count_inp2++;\
            add_inp2++;\
            add_out++;\
        }\
        if(count_inp1 == count1 && count_inp2 == count2) {\
            count_inp1 = 0;\
            count_inp2 = 0;\
        }\
        if(add_out == out_size)\
            break;\
    }\
})

#endif
