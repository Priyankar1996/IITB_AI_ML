//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __convolution_transpose_improved_h__
#define __convolution_transpose_improved_h__

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include "sized_tensor.h"

void convTranspose();

#define __dt__ uint16_t
#define __dt_min_val__ 0
#define __dt_size__ 4

#define CEILING(dividend) ({\
	uint16_t quotient;\
    quotient = (dividend+3)>>2;\
	quotient;\
})

#define __ConvTranspose__(input,kernel,stide,padding,output) ({\
    uint16_t datasize = __SizeOfTensorDataInBytes__(input.descriptor.descriptor.data_type),\
            num_elems_input = __NumberOfElementsInSizedTensor__(input),\
            conv_output_indices[3],flag=0,conv_output_flag,i,kl,mm;\
    static uint16_t input_indices[3];\
    uint16_t num_words = CEILING(num_elems_input);\
    for(i=0;i<num_words;i++){\
        uint64_t read_data = input.data_array[i],element;\
        uint16_t bytes[4];\
        bytes[0] = read_data & 0xFFFF;\
        bytes[1] = (read_data >> 16) & 0xFFFF;\
        bytes[2] = (read_data >> 32) & 0xFFFF;\
        bytes[3] = (read_data >> 48) & 0xFFFF;\
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
                    input_indices[0]++;\
                }\
                else\
                    input_indices[1]++;\
            }\
            else\
                input_indices[2]++;\
        }\
    }\
})
#endif
