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

#define __dt__ uint16_t
#define __dt_min_val__ 0
#define __dt_size__ 4
#define tensor_dim_0(tensor) (tensor.descriptor.descriptor.dimensions[0])
#define tensor_dim_1(tensor) (tensor.descriptor.descriptor.dimensions[1])
#define tensor_dim_2(tensor) (tensor.descriptor.descriptor.dimensions[2])


/*#define CEILING(dividend) ({\
	uint16_t quotient;\
    quotient = (dividend+3)>>2;\
	quotient;\
})

#define __ConvTranspose__(input,kernel,stride,padding,output) ({\
    __dt__ conv_output_indices[3],flag=0,conv_output_flag,i,kl,mm;\
    __dt__ input_indices[3];\
    __dt__ num_words = CEILING(input.descriptor.tensor_size);\
    input_indices[0] = 0, input_indices[1] = 0, input_indices[2] = 0;\
    for(i=0;i<num_words;i++){\
        uint64_t read_data = input.data_array[i],element;\
        __dt__ bytes[4];\
        bytes[0] = read_data & 0xFFFF, bytes[1] = (read_data >> 16) & 0xFFFF, bytes[2] = (read_data >> 32) & 0xFFFF, bytes[3] = (read_data >> 48) & 0xFFFF;\
        for(kl=0;kl<__dt_size__;kl++) {\
            element = bytes[kl];\
            for(mm = 0;mm < output.descriptor.descriptor.number_of_dimensions-1;mm++){\
                conv_output_indices[mm] = input_indices[mm] * stride[mm] + kernel.descriptor.descriptor.dimensions[mm+1] - padding - 1;\
                if(conv_output_indices[mm] < 0 || conv_output_indices[mm] >= output.descriptor.descriptor.dimensions[mm])\
                    flag = flag | 1;\
                else\
                    flag = flag | 0;\
            }\
            conv_output_indices[output.descriptor.descriptor.number_of_dimensions-1] = input_indices[output.descriptor.descriptor.number_of_dimensions-1];\
            conv_output_flag = flag ? -1 : __GetTensorEntryIndexOffset__(output,conv_output_indices);\
            flag = 0;\
            if(conv_output_flag>=0){\
                output.data_array[conv_output_flag >> 2] += element << 16*(conv_output_flag & 3);\
            }\
            if((input_indices[2] == (input.descriptor.descriptor.dimensions[2] - 1))) {\
                input_indices[2] = 0;\
                if((input_indices[1] == (input.descriptor.descriptor.dimensions[1] - 1))) {\
                    input_indices[1] = 0;\
                    input_indices[0] = input_indices[0] + (uint16_t)1;\
                }\
                else\
                    input_indices[1] = input_indices[1] + (uint16_t)1;\
            }\
            else\
                input_indices[2] = input_indices[2] + (uint16_t)1;\
        }\
    }\
})*/

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
                        uint16_t value = (data >> (16*(3 - (add_src & 3))));\
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