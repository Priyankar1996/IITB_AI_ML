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
#define tensor_dim_0(td) (td.dimensions[0])
#define tensor_dim_1(td) (td.dimensions[1])
#define tensor_dim_2(td) (td.dimensions[2])

#define __CheckEndOfWhile__(dim0,dim1,dim2,dim1_low,dim0_high,dim1_high,dim2_high) ({\
    __dt__ end_flag = 0;\
    if((dim2 + 4) < dim2_high)\
	        dim2+=4;\
	else {\
	    dim2=0;\
        dim1++;\
	    if(dim1 == dim1_high) {\
	        dim0++;\
            dim1=dim1_low;\
        }\
        if(dim0 == dim0_high)\
            end_flag = 1;\
	}\
    end_flag;\
})

#define __UnaryOperate__(input,row_low,col_low,row_high,col_high,td_in,td_out,output) ({\
    int64_t in_data,out_data,out_word_one, out_word_two, out_word_three, out_word_four;\
    __dt__ flag = 0,input_dim0=row_low,input_dim1=col_low,input_dim2=0,in_word_one, in_word_two, in_word_three, in_word_four,add_src;\
    while(1) {\
        add_src = input_dim2 + tensor_dim_2(td_in)*(input_dim1 + tensor_dim_1(td_in)*input_dim0);\
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
        output.data_array[add_src >> 2] = out_data;\
        flag = __CheckEndOfWhile__(input_dim0,input_dim1,input_dim2,col_low,row_high,col_high,tensor_dim_2(td_in));\
        if(flag == 1)\
            break;\
    }\
})
#endif