//Assumptions : 3D tensor, row_major, int16 data type
#ifndef __zero_pad_opt_h__
#define __zero_pad_opt_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"
#include <inttypes.h>
#include <assert.h>

void zeropad3D();
void zeropad3D_A();
void zeropad3D_B();
void zeropad3D_C();
void zeropad3D_D();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})

#define __zero_pad_opt__(row_low,row_high,col_low,col_high,T,pad,R) ({\
	int k = 0;\
	int j1 = col_low,j;\
	int i = row_low;\
	int dim2T = __dim2__(T);\
	int dim1T = __dim1__(T);\
	int dim0T = __dim0__(T);\
	int dim2R = __dim2__(R);\
	int dim1R = __dim1__(R);\
	int dim0R = __dim0__(R);\
	int dim21T = dim2T*dim1T;\
	int dim21R = dim2R*dim1R;\
	j = j1;\
	while (i < row_high)\
	{\
		int img_data_array_idx = k + dim2T*j + dim21T*i;\
		int dest_data_array_idx = k + dim2R*(j+pad) + dim21R*(i+pad);\
		uint64_t img_data = T.data_array[img_data_array_idx >> 2];\
		uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
		int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
		uint8_t temp_out_rem = dest_data_array_idx - 4*(dest_data_array_idx >> 2);\
		__putOneBlock__(R.data_array[dest_data_array_idx >> 2],temp_out_rem,img_one_block);\
		k++;\
		if (k == dim2T)\
		{\
			k = 0;\
			j++;\
			if (j == col_high)\
			{\
				j = j1;\
				i++;\
			}\
		}\
	}\
})
#define __getOneBlock__(array64bit,position)({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})
#define __putOneBlock__(array64bit,position,result)({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
})
#endif