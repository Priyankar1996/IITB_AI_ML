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

#define __dt__ int16_t
#define __dt_size__ 4
#define tensor_dim_0(tensor) (tensor.descriptor.descriptor.dimensions[0])
#define tensor_dim_1(tensor) (tensor.descriptor.descriptor.dimensions[1])
#define tensor_dim_2(tensor) (tensor.descriptor.descriptor.dimensions[2])

#define __ConvTransposeOptimized__(row_low,row_high,col_low,col_high,input,kernel,stride,padding,output) ({\
    __dt__ row,col,channel,add_src,add_dest_dim0,add_dest_dim1,add_out;\
    uint64_t out_data;\
    for (row = row_low; row < row_high; row++) {\
        add_dest_dim0 = row*stride[0] + tensor_dim_1(kernel) - padding - 1;\
        for(col = col_low; col < col_high; col++) {\
            add_dest_dim1 = col*stride[1] + tensor_dim_2(kernel) - padding - 1;\
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
})
#endif