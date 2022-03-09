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

#define __UnaryOperate__(input,row_low,col_low,row_high,col_high,td_in,td_out,output) ({\
    int64_t in_data,out_data,out_word_one, out_word_two, out_word_three, out_word_four;\
    __dt__ count,num_elems,input_dim0=row_low,input_dim1=col_low,in_word_one, in_word_two, in_word_three, in_word_four,add_src;\
    num_elems = (tensor_dim_0(td_in) * tensor_dim_1(td_in) * tensor_dim_2(td_in))>>2;\
    add_src = tensor_dim_2(td_in)*(col_low + tensor_dim_1(td_in)*row_low);\
    count = add_src + num_elems;\
    while(1) {\
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
        add_src += 4;\
        fprintf(stderr,"%d\t%d\n",add_src,count);\
        if(add_src == count)\
            break;\
    }\
})
#endif