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

#define __dt__ int16_t
#define __dt_min_val__ 0
#define __dt_size__ 4
#define tensor_dim_0(tensor) (tensor.descriptor.descriptor.dimensions[0])
#define tensor_dim_1(tensor) (tensor.descriptor.descriptor.dimensions[1])
#define tensor_dim_2(tensor) (tensor.descriptor.descriptor.dimensions[2])

#define __ConvTranspose__(input,kernel,stride,padding,output) ({\
    __dt__ row,col,channel,add_src,add_dest_dim0,add_dest_dim1,add_out;\
    uint64_t out_data,element;\
    for (row = 0; row < tensor_dim_0(input); row++) {\
        add_dest_dim0 = row*stride[0] + tensor_dim_1(kernel) -padding - 1;\
        if(add_dest_dim0 >= 0 && add_dest_dim0 < tensor_dim_0(output)) {\
            for(col = 0; col < tensor_dim_1(input); col++) {\
                add_dest_dim1 = col*stride[1] + tensor_dim_2(kernel) - padding - 1;\
                if(add_dest_dim1 >= 0 && add_dest_dim1 < tensor_dim_1(output)) {\
                    for(channel = 0; channel < tensor_dim_2(input); channel++) {\
                        add_src = channel + tensor_dim_2(input)*(col + tensor_dim_1(input)*row);\
                        uint64_t data = input.data_array[add_src>>2];\
                        __dt__ value = (data >> (16*(3 - (add_src & 3))));\
                        out_data = value;\
                        add_out = channel + tensor_dim_2(output)*(add_dest_dim1 + tensor_dim_1(output)*add_dest_dim0);\
                        output.data_array[add_out >> 2] += (out_data << 16*(3 - (add_out & 3)));\
                    }\
                }\
            }\
        }\
    }\
})
#endif