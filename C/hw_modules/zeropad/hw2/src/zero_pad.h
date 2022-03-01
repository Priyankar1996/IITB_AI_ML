//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"
#include <inttypes.h>
#include <assert.h>

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

#define __zero_pad__(T, pad, R)  ({\
	int k = 0;\
	int j = 0;\
	int i = 0;\
	while (i < __dim0__(T))\
	{\
		int img_index[3] = {i,j,k};\
		int dest_index[3] = {i+pad,j+pad,k};\
		int img_data_array_idx = __GetTensorEntryIndexOffset__(T,img_index);\
		int dest_data_array_idx = __GetTensorEntryIndexOffset__(R,dest_index);\
		uint64_t img_data = T.data_array[img_data_array_idx >> 2];\
		uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
		int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
		uint8_t temp_out_rem = dest_data_array_idx - 4*(dest_data_array_idx >> 2);\
		R.data_array[dest_data_array_idx >> 2] = __putOneBlock__(R.data_array[dest_data_array_idx >> 2],temp_out_rem,img_one_block);\
		k++;\
		if (k == __dim2__(T))\
		{\
			k = 0;\
			j++;\
			if (j == __dim1__(T))\
			{\
				j = 0;\
				i++;\
			}\
		}\
	}\
})
#define __getOneBlock__(array64bit,position)   ({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})
#define __putOneBlock__(array64bit,position,result)  ({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
	array64bit;\
})