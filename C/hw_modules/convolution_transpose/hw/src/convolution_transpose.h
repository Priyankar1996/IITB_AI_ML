//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.
#ifndef __convolution_transpose_h__
#define __convolution_transpose_h__

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

#define __UpdateOutputDescriptorDilateTensors__(src,kernel,stride,output) ({\
    output.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
    output.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
    output.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
    for(int mi=0;mi<output.descriptor.descriptor.number_of_dimensions-1;mi++)\
        output.descriptor.descriptor.dimensions[mi] = (src.descriptor.descriptor.dimensions[mi])*stride[mi] + kernel.descriptor.descriptor.dimensions[mi+1] - 1;\
    output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
})

#define __UpdateOutputDescriptorDepadTensors__(src, padding, output) ({\
    output.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
    output.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
    output.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
    for(int ei=0;ei<output.descriptor.descriptor.number_of_dimensions-1;ei++)\
        output.descriptor.descriptor.dimensions[ei] = src.descriptor.descriptor.dimensions[ei] - (2*padding);\
    output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
})

#define __ComputeDilatedTensorOffset__(offset,src,output,kernel,stride) ({\
    int m,p; uint32_t indices[3], output_indices[3], output_offset=0;\
    if(offset == 1){\
        for(int x=0;x<3;x++)\
            indices[x] = 0;\
    }\
    else{\
        for(p=src.descriptor.descriptor.number_of_dimensions-1;p>=0;p--) {\
            indices[p] = ((offset % src.descriptor.descriptor.dimensions[p])? (offset % src.descriptor.descriptor.dimensions[p]):src.descriptor.descriptor.dimensions[p]) - 1;\
            offset = CEILING(offset,src.descriptor.descriptor.dimensions[p]);\
        }\
    }\
    for(m = 0;m < output.descriptor.descriptor.number_of_dimensions-1;m++){\
        output_indices[m] = indices[m] * stride[m] + kernel.descriptor.descriptor.dimensions[m+1] - 1;\
    }\
    output_indices[output.descriptor.descriptor.number_of_dimensions-1] = indices[output.descriptor.descriptor.number_of_dimensions-1];\
    output_offset = __GetTensorEntryIndexOffset__(output,output_indices);\
    output_offset;\
})

#define __CheckPadding__(depad_offset,src,output,padding) ({\
    int ij,pp; int indices_depad[3],output_indices_depad[3],depad_output_offset,flag;\
    for(pp=src.descriptor.descriptor.number_of_dimensions-1;pp>=0;pp--) {\
        indices_depad[pp] = ((depad_offset % src.descriptor.descriptor.dimensions[pp])? (depad_offset % src.descriptor.descriptor.dimensions[pp]):src.descriptor.descriptor.dimensions[pp])-1;\
        depad_offset = CEILING(depad_offset,src.descriptor.descriptor.dimensions[pp]);\
    }\
    for(ij = 0;ij < output.descriptor.descriptor.number_of_dimensions-1;ij++)\
        output_indices_depad[ij] = indices_depad[ij] - padding;\
    output_indices_depad[output.descriptor.descriptor.number_of_dimensions-1] = indices_depad[output.descriptor.descriptor.number_of_dimensions-1];\
    for(ij=0;ij<output.descriptor.descriptor.number_of_dimensions-1;ij++) {\
        if(output_indices_depad[ij] < 0 || output_indices_depad[ij] >= output.descriptor.descriptor.dimensions[ij])\
            flag = flag || 1;\
        else\
            flag = flag || 0;\
    }\
    depad_output_offset = flag ? -1 : 1;\
    flag = 0;\
    depad_output_offset;\
})

#define __DilateTensors__(input,kernel,stride,output) ({\
    __UpdateOutputDescriptorDilateTensors__(input,kernel,stride,output);\
    uint32_t datasize = __SizeOfTensorDataInBytes__(input.descriptor.descriptor.data_type),\
             num_elems_input = __NumberOfElementsInSizedTensor__(input),\
             count=0,offset,output_offset=0;\
    for(int i=0;i<CEILING(num_elems_input*datasize,8);i++){\
        uint64_t read_data = input.data_array[i];\
        __dt__ (*bytes)[__dt_size__] = ((void*)&read_data);\
        for(int k=0;k<__dt_size__;k++) {\
            count++;\
            offset = count;\
            output_offset = __ComputeDilatedTensorOffset__(offset,input,output,kernel,stride);\
            *((__dt__*)output.data_array + output_offset) = (*bytes)[k];\
        }\
    }\
})

#define __DepadTensors__(input,padding,output) ({\
    __UpdateOutputDescriptorDepadTensors__(input, padding, output);\
    uint32_t datasize = __SizeOfTensorDataInBytes__(input.descriptor.descriptor.data_type),\
             num_elems_dinput = __NumberOfElementsInSizedTensor__(input);\
    int d_count=0,d_offset,check_depad=0,d_output_offset=0;\
    for(int XX=0;XX<CEILING(num_elems_dinput*datasize,8);XX++){\
        uint64_t read_data = input.data_array[XX];\
        __dt__ (*bytes)[__dt_size__] = ((void*)&read_data);\
        for(int kk=0;kk<__dt_size__;kk++) {\
            d_count++;\
            d_offset = d_count;\
            check_depad = __CheckPadding__(d_offset,input,output,padding);\
            if(check_depad>0){\
                *((__dt__*)output.data_array + d_output_offset++) = (*bytes)[kk];\
            }\
        }\
    }})


#endif