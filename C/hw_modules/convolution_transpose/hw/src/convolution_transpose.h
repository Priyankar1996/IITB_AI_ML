//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __convolution_transpose_h__
#define __convolution_transpose_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void convTranspose();
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

/*#define __ConvTranspose__(input,kernel,stride,padding,output) ({\
    __dt__ row,col,channel,add_src=0,add_dest_dim0,add_dest_dim1,add_out;\
    for (row = 0; row < tensor_dim_0(input); row++) {\
        add_dest_dim0 = row*stride[0] + tensor_dim_1(kernel) -padding - 1;\
        for(col = 0; col < tensor_dim_1(input); col++) {\
            add_dest_dim1 = col*stride[1] + tensor_dim_2(kernel) - padding - 1;\
            add_out = tensor_dim_2(output)*(add_dest_dim1 + tensor_dim_1(output)*add_dest_dim0);\
            for(channel = 0; channel < tensor_dim_2(input); channel+=8) {\
                output.data_array[add_out >> 2] = input.data_array[add_src>>2];\
                add_src+=4;\
                add_out+=4;\
                output.data_array[add_out >> 2] = input.data_array[add_src>>2];\
                add_src+=4;\
                add_out+=4;\
            }\
        }\
    }\
})*/


#define __CheckEndOfWhile__(dim0,dim1,dim2) ({\
    __dt__ end_flag = 0;\
    if(dim2 < tensor_dim_2(input) && (dim2 + 8) < tensor_dim_2(input))\
	        dim2+=8;\
	else {\
	    dim2=0;\
	    if(dim1 < tensor_dim_1(input) && (dim1 + 1) < tensor_dim_1(input))\
	        dim1++;\
	    else {\
	        dim1 = 0;\
	        if(dim0 < tensor_dim_0(input) && (dim0 + 1) < tensor_dim_0(input))\
	            dim0++;\
	        else\
                end_flag = 1;\
	    }\
	}\
    end_flag;\
})

#define __ConvTranspose__(input,kernel,stride,padding,output) ({\
    __dt__ input_dim0=0,input_dim1=0,input_dim2=0,add_dest_dim0,add_src,\
            add_dest_dim1,add_dest_dim2,add_out,flag;\
    while(1) {\
        add_dest_dim0 = input_dim0*stride[0] + tensor_dim_1(kernel) - padding - 1;\
        add_dest_dim1 = input_dim1*stride[1] + tensor_dim_2(kernel) - padding - 1;\
        add_src = input_dim2 + tensor_dim_2(input)*(input_dim1 + tensor_dim_1(input)*input_dim0);\
        add_out = input_dim2 + tensor_dim_2(output)*(add_dest_dim1 + tensor_dim_1(output)*add_dest_dim0);\
        output.data_array[add_out >> 2] = input.data_array[add_src >> 2];\
        add_src+=4;\
        add_out+=4;\
        output.data_array[add_out >> 2] = input.data_array[add_src>>2];\
        flag = __CheckEndOfWhile__(input_dim0,input_dim1,input_dim2);\
        if(flag == 1)\
            break;\
    }\
})
#endif
