//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __convolution_transpose_h__
#define __convolution_transpose_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dt__ int16_t
#define __dt_size__ 4
#define tensor_dim_0(tensor) (tensor.descriptor.descriptor.dimensions[0])
#define tensor_dim_1(tensor) (tensor.descriptor.descriptor.dimensions[1])
#define tensor_dim_2(tensor) (tensor.descriptor.descriptor.dimensions[2])

#define __CheckEndOfWhile__(input,address) ({\
    uint32_t num_elems = (__NumberOfElementsInSizedTensor__(input) >> 2);\
    __dt__ flag = 0;\
    if(address == num_elems)\
        flag = 1;\
    else\    
        address+=4;\
    flag;\
})

#define __UnaryOperate__(input,row_low,col_low,output) ({\
    uint64_t in_data,out_data;\
    __dt__ flag = 0,in_word_one, in_word_two, in_word_three, in_word_four,add_src,out_word_one, out_word_two, out_word_three, out_word_four;\
    add_src = tensor_dim_2(input)*(col_low + tensor_dim_1(input)*row_low);\
    while(1) ({\
        in_data = input.data_array[add_src >> 2];\
        in_word_one = in_data;\
        in_word_two = in_data >> 16;\
        in_word_three = in_data >> 32;\
        in_word_four = in_data >> 48;\
        out_word_one = (in_word_one<0)?0:in_word_one;\
        out_word_two = (in_word_two<0)?0:in_word_two;\
        out_word_three = (in_word_three<0)?0:in_word_three;\
        out_word_four = (in_word_four<0)?0:in_word_four;\
        out_data = out_word_four;\
        out_data <<= 16;\
		out_data += out_word_three;\
		out_data <<= 16;\
		out_data += out_word_two;\
		out_data <<= 16;\
		out_data += out_word_one;\
        out_data = output.data_array[add_src >> 2];\
        flag = __CheckEndOfWhile__(input,add_src);\
        if(flag == 1)\
            break;\
    }\
})
#endif