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

#ifdef __U64
	#define __dt__ uint64_t
	#define __dt_min_val__ 0
    #define __dt_size__ 1 
#endif
#ifdef __U32
	#define __dt__ uint32_t
	#define __dt_min_val__ 0
    #define __dt_size__ 2
#endif
#ifdef __U16
	#define __dt__ uint16_t
	#define __dt_min_val__ 0
    #define __dt_size__ 4
#endif
#ifdef __U8
	#define __dt__ uint8_t
	#define __dt_min_val__ 0
    #define __dt_size__ 8
#endif
#ifdef __I64
	#define __dt__ int64_t
	#define __dt_min_val__ 0x8000000000000000
    #define __dt_size__ 1
#endif
#ifdef __I32
	#define __dt__ int32_t
	#define __dt_min_val__ 0x80000000
    #define __dt_size__ 2
#endif
#ifdef __I16
	#define __dt__ int16_t
	#define __dt_min_val__ 0x8000
    #define __dt_size__ 4
#endif
#ifdef __I8
	#define __dt__ int8_t
	#define __dt_min_val__ 0x80
    #define __dt_size__ 8
#endif
#ifdef __F64
	#define __dt__ double
	#define __dt_min_val__ -DBL_MAX
    #define __dt_size__ 1
#endif
#ifdef __F32
	#define __dt__ float
	#define __dt_min_val__ -FLT_MAX
    #define __dt_size__ 2
#endif
#ifdef __F16
	#define __dt__ uint16_t
	#define __dt_min_val__ 0
    #define __dt_size__ 4
#endif
#ifdef __F8
	#define __dt__ uint8_t
	#define __dt_min_val__ 0
    #define __dt_size__ 8
#endif

#define CEILING(x,y) (((x) + (y) - 1) / (y))

#define __UpdateOutputDescriptorConvTransTensors__(src,kernel,stride,padding,output) ({\
    output.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
    output.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
    output.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
    for(int i=0;i<output.descriptor.descriptor.number_of_dimensions-1;i++)\
        output.descriptor.descriptor.dimensions[i] = (src.descriptor.descriptor.dimensions[i])*stride[i] + kernel.descriptor.descriptor.dimensions[i+1] - 1 - (2*padding);\
    output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
})

#define __CheckConvTransposedTensor__(conv_offset,src,output,kernel,stride,padding) ({\
    __UpdateOutputDescriptorConvTransTensors__(input,kernel,stride,padding,output);\
    int mm,ppp; uint32_t conv_indices[3], conv_output_indices[3],flag=0,conv_output_flag=0;\
    for(ppp=src.descriptor.descriptor.number_of_dimensions-1;ppp>=0;ppp--) {\
        conv_indices[ppp] = ((conv_offset % src.descriptor.descriptor.dimensions[ppp])? (conv_offset % src.descriptor.descriptor.dimensions[ppp]):src.descriptor.descriptor.dimensions[ppp])-1;\
        conv_offset = CEILING(conv_offset,src.descriptor.descriptor.dimensions[ppp]);\
    }\
    for(mm = 0;mm < output.descriptor.descriptor.number_of_dimensions-1;mm++){\
        conv_output_indices[mm] = conv_indices[mm] * stride[mm] + kernel.descriptor.descriptor.dimensions[mm+1] - padding - 1;\
    }\
    conv_output_indices[output.descriptor.descriptor.number_of_dimensions-1] = conv_indices[output.descriptor.descriptor.number_of_dimensions-1];\
    for (mm=0;mm<output.descriptor.descriptor.number_of_dimensions-1;mm++) {\
        if(conv_output_indices[mm] < 0 || conv_output_indices[mm] >= output.descriptor.descriptor.dimensions[mm])\
            flag = flag | 1;\
        else\
            flag = flag | 0;\
    }\
    conv_output_flag = flag ? -1 : __GetTensorEntryIndexOffset__(output,conv_output_indices);\
    flag = 0;\
    conv_output_flag;\
})


#define __ConvTranspose__(input,kernel,stride,padding,output) ({\
    __UpdateOutputDescriptorConvTransTensors__(input,kernel,stride,padding,output);\
    uint32_t datasize = __SizeOfTensorDataInBytes__(input.descriptor.descriptor.data_type),\
             num_elems_input = __NumberOfElementsInSizedTensor__(input),\
             count=0,offset;\
    int conv_offset;\
    for(int i=0;i<CEILING(num_elems_input*datasize,8);i++){\
        uint64_t read_data = input.data_array[i];\
        uint16_t bytes[4];\
        bytes[0] = read_data & 0xFFFF;\
        bytes[1] = (read_data >> 16) & 0xFFFF;\
        bytes[2] = (read_data >> 32) & 0xFFFF;\
        bytes[3] = (read_data >> 48) & 0xFFFF;\
        for(int kl=0;kl<__dt_size__;kl++) {\
            count++;\
            offset = count;\
            conv_offset = __CheckConvTransposedTensor__(offset,input,output,kernel,stride,padding);\
            if(conv_offset>=0)\
                *((__dt__*)output.data_array + conv_offset) = bytes[kl];\
        }\
    }\
})

#define __ConvTranspose2__(input,kernel,stide,padding,output) ({\
    __UpdateOutputDescriptorConvTransTensors__(input,kernel,stride,padding,output);\
    uint16_t datasize = __SizeOfTensorDataInBytes__(input.descriptor.descriptor.data_type),\
            num_elems_input = __NumberOfElementsInSizedTensor__(input),\
            conv_output_indices[3],flag=0,conv_output_flag;\
    static uint16_t input_indices[3];\
    for(uint16_t i=0;i<CEILING(num_elems_input*datasize,8);i++){\
        uint64_t read_data = input.data_array[i];\
        uint16_t bytes[4];\
        bytes[0] = read_data & 0xFFFF;\
        bytes[1] = (read_data >> 16) & 0xFFFF;\
        bytes[2] = (read_data >> 32) & 0xFFFF;\
        bytes[3] = (read_data >> 48) & 0xFFFF;\
        for(uint16_t kl=0;kl<__dt_size__;kl++) {\
            for(uint16_t mm = 0;mm < output.descriptor.descriptor.number_of_dimensions-1;mm++)\
                conv_output_indices[mm] = input_indices[mm] * stride[mm] + kernel.descriptor.descriptor.dimensions[mm+1] - padding - 1;\
            conv_output_indices[output.descriptor.descriptor.number_of_dimensions-1] = input_indices[output.descriptor.descriptor.number_of_dimensions-1];\
            for(uint16_t mm=0;mm<output.descriptor.descriptor.number_of_dimensions-1;mm++) {\
                if(conv_output_indices[mm] < 0 || conv_output_indices[mm] >= output.descriptor.descriptor.dimensions[mm])\
                    flag = flag | 1;\
                else\
                    flag = flag | 0;\
            }\
            conv_output_flag = flag ? -1 : __GetTensorEntryIndexOffset__(output,conv_output_indices);\
            flag = 0;\
            if(conv_output_flag>=0) {\
                output.data_array[conv_output_flag >> 2] += (uint64_t)bytes[kl] << 16*(conv_output_flag & 3);\
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