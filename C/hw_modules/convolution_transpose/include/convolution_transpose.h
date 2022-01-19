//Author: Priyankar Sarkar
//Dept. of Electrical Engineering, IIT-Bombay.

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
    for(int i=0;i<output.descriptor.descriptor.number_of_dimensions-1;i++)\
        output.descriptor.descriptor.dimensions[i] = (src.descriptor.descriptor.dimensions[i])*stride[i] + kernel.descriptor.descriptor.dimensions[i+1] - 1;\
    output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
})

#define __UpdateOutputDescriptorDepadTensors__(src, padding, output) ({\
    output.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
    output.descriptor.number_of_dimensions = src.descriptor.number_of_dimensions;\
    output.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
    for(int i=0;i<td_output->number_of_dimensions-1;i++)\
        output.descriptor.descriptor.dimensions[i] = src.descriptor.descriptor.dimensions[i] - (2*padding);\
    output.descriptor.descriptor.dimensions[output.descriptor.descriptor.number_of_dimensions-1] = src.descriptor.descriptor.dimensions[src.descriptor.descriptor.number_of_dimensions-1];\
})

#define __ComputeDilatedTensorOffset__(offset,src,output,kernel,stride) ({\
    int i,p; uint32_t indices[3], output_indices[3], output_offset;\
    for(p=td_in->number_of_dimensions-1;p>=0;p--) {\
        indices[p] = ((offset % src.descriptor.descriptor.dimensions[p])? (offset % src.descriptor.descriptor.dimensions[p]):src.descriptor.descriptor.dimensions[p])-1;\
        offset = CEILING(offset,src.descriptor.descriptor.dimensions[p]);\
    }\
    for(i = 0;i < output.descriptor.descriptor.number_of_dimensions-1;i++)\
        output_indices[i] = indices[i] * stride[i] + kernel.descriptor.descriptor.dimensions[i+1] -1;\
    output_indices[output.descriptor.descriptor.number_of_dimensions-1] = indices[output.descriptor.descriptor.number_of_dimensions-1];\
    output_offset = __GetTensorEntryIndexOffset__(output,output_indices);\
    output_offset;\
})

#define __CheckPadding__(offset,src,output,padding) ({\
    int i,p; int indices[3],output_indices[3],output_offset, flag;\
    for(p=src.descriptor.descriptor.number_of_dimensions-1;p>=0;p--) {\
        indices[p] = ((offset % src.descriptor.descriptor.dimensions[p])? (offset % src.descriptor.descriptor.dimensions[p]):src.descriptor.descriptor.dimensions[p])-1;\
        offset = CEILING(offset,src.descriptor.descriptor.dimensions[p]);\
    }\
    for(i = 0;i < output.descriptor.descriptor.number_of_dimensions-1;i++)\
        output_indices[i] = indices[i] - padding;\
    output_indices[output.descriptor.descriptor.number_of_dimensions-1] = indices[output.descriptor.descriptor.number_of_dimensions-1];\
    for(i=0;i<output.descriptor.descriptor.number_of_dimensions-1;i++) {\
        if(output_indices[i] < 0 || output_indices[i] >= output.descriptor.descriptor.dimensions[i])\
            flag = 1;\
    }\
    output_offset = flag ? -1 : 1;\
    output_offset;\
})

#define __DilateTensors__(input,kernel,stride,output) ({\
    __UpdateOutputDescriptorDilateTensors__(input,kernel,stride,output);\
    uint32_t datasize = __SizeofTensorDataInBytes__(input.descriptor.descriptor.data_type),\
             num_elems_input = __NumberOfElementsInTensor__(input),\
             num_elems_output = __NumberOfElementsInTensor__(output),count=0,output_offset;\
    for(int i=0;i<num_elems_output*8/datasize;i++)\
        output.data_array[i] = 0;\
    for(int i=0;i<num_elems_input;i++){\
        uint64_t read_data = input.data_array[i];\
        uint16_t bytes[4];\
        bytes[0] = read_data & 0xFFFF;\
        bytes[1] = (read_data >> 16) & 0xFFFF;\
        bytes[2] = (read_data >> 32) & 0xFFFF;\
        bytes[3] = (read_data >> 48) & 0xFFFF;\
        for(int k=0;k<__dt_size__;k++) {\
            count++;\
            output_offset = __ComputeDilatedTensorOffset__(count,input,output,kernel,stride);\
            *((__dt__*)output.data_array + output_offset) = (*bytes)[k];\
        }\
    }\
})

#define __DepadTensors__(input,padding,output) ({\
    __UpdateOutputDescriptorDepadTensors__(input, padding, output);\
    uint32_t datasize = __SizeofTensorDataInBytes__(input.descriptor.descriptor.data_type),\
             num_elems_input = __NumberOfElementsInTensor__(input),\
             num_elems_output = __NumberOfElementsInTensor__(output);\
    int count=0,check_depad=0,output_offset=0;\
    for(int i=0;i<num_elems_output*8/datasize;i++)\
        output.data_array[i] = 0;\
    for(int i=0;i<num_elems_input;i++){\
        uint64_t read_data = input.data_array[i];\
        uint16_t bytes[4];\
        bytes[0] = read_data & 0xFFFF;\
        bytes[1] = (read_data >> 16) & 0xFFFF;\
        bytes[2] = (read_data >> 32) & 0xFFFF;\
        bytes[3] = (read_data >> 48) & 0xFFFF;\
        for(int k=0;k<__dt_size__;k++) {\
            count++;\
            check_depad = __CheckPadding__(count,input,output,padding);\
            if(check_depad>0)\
                *((__dt__*)output.data_array + output_offset++) = (*bytes)[k];\
        }\
    }\          
})