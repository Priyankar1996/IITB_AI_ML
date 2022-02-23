//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"

void conv2D();

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})
#define __dim3__(T) ({T.descriptor.descriptor.dimensions[3];})

#define __convolveTensors__(inp,ker,out,stride) ({\
    	out.descriptor.descriptor.data_type = i16;\
    	out.descriptor.descriptor.number_of_dimensions = 3;\
    	out.descriptor.descriptor.row_major_form = 1;\
    	out.descriptor.descriptor.dimensions[0] = 1 + __udiv16__(__dim0__(inp) - __dim1__(ker),stride);\
	out.descriptor.descriptor.dimensions[1] = 1 + __udiv16__(__dim1__(inp) - __dim2__(ker),stride);\
	out.descriptor.descriptor.dimensions[2] = __dim0__(ker);\
	out.descriptor.tensor_size = __dim0__(out) * __dim1__(out) * __dim2__(out);\
	int out_idx = -1;\
	int16_t result_temp;\
	int p,q,r,i,j,k;\
	for (p = 0; p < __dim0__(out); p++)\
	{\
		for(q = 0; q < __dim1__(out); q++)\
		{\
			for(r = 0; r < __dim2__(out); r++)\
			{\
				out_idx++;\
				result_temp = 0;\
				for(i = 0; i < __dim1__(ker); i++)\
				{\
					for(j = 0; j < __dim2__(ker); j++)\
					{\
						int img_index0[3] = {p*stride+i,q*stride+j,0};\
						int ker_index0[4] = {r,i,j,0};\
						int img_index1[3] = {p*stride+i,q*stride+j,1};\
						int ker_index1[4] = {r,i,j,1};\
						int img_index2[3] = {p*stride+i,q*stride+j,2};\
						int ker_index2[4] = {r,i,j,2};\
						int img_data_array_idx0 = __GetTensorEntryIndexOffset__(inp,img_index0);\
						int ker_data_array_idx0 = __GetTensorEntryIndexOffset__(ker,ker_index0);\
						int img_data_array_idx1 = __GetTensorEntryIndexOffset__(inp,img_index1);\
						int ker_data_array_idx1 = __GetTensorEntryIndexOffset__(ker,ker_index1);\
						int img_data_array_idx2 = __GetTensorEntryIndexOffset__(inp,img_index2);\
						int ker_data_array_idx2 = __GetTensorEntryIndexOffset__(ker,ker_index2);\
						uint64_t img_data0 = inp.data_array[img_data_array_idx0 >> 2];\
						uint64_t ker_data0 = ker.data_array[ker_data_array_idx0 >> 2];\
						uint64_t img_data1 = inp.data_array[img_data_array_idx1 >> 2];\
						uint64_t ker_data1 = ker.data_array[ker_data_array_idx1 >> 2];\
						uint64_t img_data2 = inp.data_array[img_data_array_idx2 >> 2];\
						uint64_t ker_data2 = ker.data_array[ker_data_array_idx2 >> 2];\
						uint8_t temp_img_rem0 = img_data_array_idx0 - 4*(img_data_array_idx0 >> 2);\
						uint8_t temp_ker_rem0 = ker_data_array_idx0 - 4*(ker_data_array_idx0 >> 2);\
						uint8_t temp_img_rem1 = img_data_array_idx1 - 4*(img_data_array_idx1 >> 2);\
						uint8_t temp_ker_rem1 = ker_data_array_idx1 - 4*(ker_data_array_idx1 >> 2);\
						uint8_t temp_img_rem2 = img_data_array_idx2 - 4*(img_data_array_idx2 >> 2);\
						uint8_t temp_ker_rem2 = ker_data_array_idx2 - 4*(ker_data_array_idx2 >> 2);\
						int16_t img_one_block0 = __getOneBlock__(img_data0,temp_img_rem0);\
						int16_t ker_one_block0 = __getOneBlock__(ker_data0,temp_ker_rem0);\
						int16_t img_one_block1 = __getOneBlock__(img_data1,temp_img_rem1);\
						int16_t ker_one_block1 = __getOneBlock__(ker_data1,temp_ker_rem1);\
						int16_t img_one_block2 = __getOneBlock__(img_data2,temp_img_rem2);\
						int16_t ker_one_block2 = __getOneBlock__(ker_data2,temp_ker_rem2);\
						result_temp += img_one_block0 * ker_one_block0 + img_one_block1 * ker_one_block1 + img_one_block2 * ker_one_block2;\
					}\
				}\
				int out_index[3] = {p,q,r};\
				int out_data_array_idx = __GetTensorEntryIndexOffset__(out,out_index);\
				uint8_t temp_out_rem = out_data_array_idx - 4*(out_data_array_idx >> 2);\
				out.data_array[out_data_array_idx >> 2] = __putOneBlock__(out.data_array[out_data_array_idx >> 2],temp_out_rem,result_temp);\
			}\
		}\
	}\
})

#define __udiv16__(dividend,divisor)({\
	uint16_t quotient = 0;\
	if(divisor != 0)\
	{\
   		uint16_t reduced_dividend = dividend;\
		__DIV_LOOP(reduced_dividend,divisor,quotient,uint16_t);\
	}\
	quotient;\
})

#define __DIV_LOOP(reduced_dividend,divisor,quotient,TNAME) while(reduced_dividend >= divisor)\
	({\
		TNAME curr_quotient = 1;\
        	TNAME shifted_divisor = divisor;\
        	TNAME reduced_dividend_by_2 = (reduced_dividend >> 1);\
		while(1)\
		{\
			if(shifted_divisor < reduced_dividend_by_2)\
			{\
				shifted_divisor = (shifted_divisor << 1);\
				curr_quotient = (curr_quotient << 1);\
			}\
			else	\
		  	break;\
		}\
		quotient += curr_quotient;\
		reduced_dividend -= shifted_divisor;\
   	})

#define __getOneBlock__(array64bit,position)({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})

#define __putOneBlock__(array64bit,position,result)({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
	array64bit;\
})
