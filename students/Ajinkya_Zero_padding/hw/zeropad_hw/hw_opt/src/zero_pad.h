//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"

void zeropad3D();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})

#define __convolveTensors__(inp,out,pad) ({\
    out.descriptor.descriptor.data_type = i16;\
    out.descriptor.descriptor.number_of_dimensions = 3;\
    out.descriptor.descriptor.row_major_form = 1;\
    out.descriptor.descriptor.dimensions[0] = __dim0__(T) + (pad << 1);\
	out.descriptor.descriptor.dimensions[1] = __dim1__(T) + (pad << 1);\
	out.descriptor.descriptor.dimensions[2] = __dim2__(T);\
	out.descriptor.tensor_size = __dim0__(out) * __dim1__(out) * __dim2__(out);\
	int16_t result_temp,temp;\
	int i,j,k;\
	int count = 0;\
	uint64_t img_data;\
	uint64_t ker_data;\
	result_temp = 0;\
	while(i < __dim0__(T))\
	{\
		int img_data_array_idx = __GetTensorEntryIndexOffset__(inp,i,j,k);\
		uint64_t img_data = inp.data_array[img_data_array_idx >> 2];\
		if((count - 4*(count >> 2)) == 0)\
		{\
			__getOneTensorBlock__(inp,img_data,img_data_array_idx);\
		}\
		uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
		int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
		k++;\
		if(k == __dim2__(T))\
		{\
			k = 0;\
			j++;\
			if(j == __dim1__(T))\
			{\
				j = 0;\
				i++;\
			}\
		}\
		count++;\
		int out_data_array_idx = __GetTensorEntryIndexOffset__(out,i + pad,j + pad,k + pad);\
		uint8_t temp_out_rem = out_data_array_idx - 4*(out_data_array_idx >> 2);\
		__putOneBlock__(out.data_array[out_data_array_idx >> 2],temp_out_rem,img_one_block);\
	}\
})
#define __getOneTensorBlock__(tnsr,data,index)({\
	data = tnsr.data_array[index >> 2];\
})
#define __getOneBlock__(array64bit,position)({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})
#define __putOneBlock__(array64bit,position,result)({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
})
