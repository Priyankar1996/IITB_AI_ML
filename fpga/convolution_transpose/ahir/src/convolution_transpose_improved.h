//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __convolution_transpose_improved_h__
#define __convolution_transpose_improved_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void convTranspose();
void convTransposeA();
void convTransposeB();
void convTransposeC();
void convTransposeD();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

/*#define __ConvTransposeOptimized__(row_low,row_high,col_low,col_high,input,kernel,stride,padding,output) ({\
    __dt__ row,col,channel,add_src,add_dest_dim0,add_dest_dim1,add_out;\
    uint64_t out_data;\
    for (row = row_low; row < row_high; row++) {\
        add_dest_dim0 = row*stride + tensor_dim_1(kernel) - padding - 1;\
        for(col = col_low; col < col_high; col++) {\
            add_dest_dim1 = col*stride + tensor_dim_2(kernel) - padding - 1;\
            add_src = tensor_dim_2(input)*(col + tensor_dim_1(input)*row);\
            add_out = tensor_dim_2(output)*(add_dest_dim1 + tensor_dim_1(output)*add_dest_dim0);\
            for(channel = 0; channel < tensor_dim_2(input); channel+=4) {\
                uint64_t data = input.data_array[add_src>>2];\
                output.data_array[add_out >> 2] = data;\
                add_src+=4;\
                add_out+=4;\
            }\
        }\
    }\
})*/

#define __CheckEndOfWhile__(dim0,dim1,dim2,dim0_high,dim1_high,dim2_high) ({\
    __dt__ end_flag = 0;\
    if((dim2 + 4) < dim2_high)\
	        dim2+=4;\
	else {\
	    dim2=0;\
        dim1++;\
	    if(dim1 == dim1_high) {\
	        dim0++;\
            dim1=0;\
        }\
        if(dim0 == dim0_high)\
            end_flag = 1;\
	}\
    end_flag;\
})

#define __ConvTransposeOptimized__(row_low,row_high,col_low,col_high,i,k,o,offset,input,kernel,stride,padding,output) ({\
    uint16_t input_dim0=row_low,input_dim1=col_low,input_dim2=0,add_dest_dim0,\
            add_dest_dim1,add_dest_dim2,flag;\
    uint32_t add_src_0 = offset, add_out_0 = 0;\
    while(1) {\
        add_dest_dim0 = input_dim0*stride + k[1] - padding - 1;\
        add_dest_dim1 = input_dim1*stride + k[2] - padding - 1;\
        add_out_0 = input_dim2 + o[2]*(add_dest_dim1 + o[1]*add_dest_dim0);\
        output.data_array[add_out_0 >> 2] = input.data_array[add_src_0 >> 2];\
        flag = __CheckEndOfWhile__(input_dim0,input_dim1,input_dim2,row_high,col_high,i[2]);\
        if(flag == 1)\
            break;\
        add_src_0 += 4;\
    }\
})

#endif
