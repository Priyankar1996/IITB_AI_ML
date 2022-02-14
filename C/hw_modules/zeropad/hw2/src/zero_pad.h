//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"
#include <inttypes.h>
#include <assert.h>

void zeropad3D();

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})

#define __zero_pad__(T, pad, R)  ({\
    int n1 = T.descriptor.descriptor.dimensions[0];\
    int n2 = T.descriptor.descriptor.dimensions[1];\
    int n3 = T.descriptor.descriptor.dimensions[2];\
    SizedTensor_16K dest2;\
    dest2.descriptor.descriptor.data_type = i16;\
    dest2.descriptor.descriptor.number_of_dimensions = 3;\
    dest2.descriptor.descriptor.dimensions[0] = R.descriptor.descriptor.dimensions[0];\
    dest2.descriptor.descriptor.dimensions[1] = R.descriptor.descriptor.dimensions[1];\
    dest2.descriptor.descriptor.dimensions[2] = R.descriptor.descriptor.dimensions[2];\
    dest2.descriptor.descriptor.row_major_form = 1;\
    dest2.descriptor.tensor_size = (R.descriptor.descriptor.dimensions[0])*(R.descriptor.descriptor.dimensions[1])*(R.descriptor.descriptor.dimensions[2]);\
	int out_idx = -1;\
	int16_t result_temp;\
	int size=(n1*n2*n3);\
    int idx   = 0;\
	int width = 0;\
	int i, j, k;\
	int dest2_ind, src_ind;\
	for(i=0;i<n1;i++)\
	{\
		out_idx++;\
		result_temp = 0;\
		for(j=0;j<n2;j++ )\
		{\
			for(k=0;k<n3;k++)\
			{\
				src_ind = (k+n3*j+n2*n3*i);\
				uint64_t img_data = T.data_array[src_ind >> 2];\
				uint8_t temp_img_rem = src_ind - 4*(src_ind >> 2);\
				int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
				dest2_ind = (n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad));\
				uint8_t temp_out_rem = dest2_ind - 4*(dest2_ind >> 2);\
				dest2.data_array[dest2_ind >> 2] = __putOneBlock__(dest2.data_array[dest2_ind >> 2],temp_out_rem,img_one_block);\
			}\
		}\
	}\
    int index=0;\
    int jump_matrix = ((n1+2*pad)*(n2+2*pad));\
    int row_jump = (n1+2*pad);\
    int column_jump = (n2+2*pad);\
	out_idx = -1;\
    for(i=0;i<n1+2*pad;i++)\
	{\
		out_idx++;\
		result_temp = 0;\
		for(j=0;j<n2+2*pad;j++)\
		{\
			for(k=0;k<n3;k++)\
			{\
				dest2_ind = k*jump_matrix +  j*(n1+2*pad) + i ;\
                uint64_t img_data = dest2.data_array[dest2_ind >> 2];\
				uint8_t temp_img_rem = dest2_ind - 4*(dest2_ind >> 2);\
				int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
				uint8_t temp_out_rem = index - 4*(index >> 2);\
				R.data_array[index >> 2] = __putOneBlock__(R.data_array[index >> 2],temp_out_rem,img_one_block);\
				index = index + 1 ;\
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