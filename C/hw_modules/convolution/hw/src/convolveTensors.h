#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"

void conv2D();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

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
	int16_t result_temp;\
	int p=0,q=0,r=0,i=0,j=0,k=0;\
	int count = 0;\
	int dim0_inp = __dim0__(inp);\
	int dim1_inp = __dim1__(inp);\
	int dim2_inp = __dim2__(inp);\
	int dim0_ker = __dim0__(ker);\
	int dim1_ker = __dim1__(ker);\
	int dim2_ker = __dim2__(ker);\
	int dim3_ker = __dim3__(ker);\
	int dim0_out = __dim0__(out);\
	int dim1_out = __dim1__(out);\
	int dim2_out = __dim2__(out);\
	uint64_t img_data;\
	uint64_t ker_data;\
	for(p = 0; p < dim0_out; p++)\
	{\
		int pxstride = p*stride;\
		for(q = 0; q < dim0_out; q++)\
		{\
			int qxstride = q*stride;\
			for(r = 0; r < dim2_out; r++)\
			{\
				result_temp = 0;\
				while(i < dim1_ker)\
				{\
					int x_idx_img = pxstride+i;\
					int y_idx_img = qxstride+j;\
					int img_data_array_idx;\
					__GetImgEntryIndexOffset__(img_data_array_idx,x_idx_img,y_idx_img,k);\
					int ker_data_array_idx;\
					__GetKerEntryIndexOffset__(ker_data_array_idx,r,i,j,k);\
					if((count - 4*(count >> 2)) == 0)\
					{\
						__getOneTensorBlock__(inp,img_data,img_data_array_idx);\
						__getOneTensorBlock__(ker,ker_data,ker_data_array_idx);\
					}\
					uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
					uint8_t temp_ker_rem = ker_data_array_idx - 4*(ker_data_array_idx >> 2);\
					int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
					int16_t ker_one_block = __getOneBlock__(ker_data,temp_ker_rem);\
					result_temp += (img_one_block * ker_one_block);\
					__checkIncrementCondition1__(i,j,k);\
					count++;\
				}\
				i = 0;j = 0;k = 0;\
				int out_data_array_idx;\
				__GetOutEntryIndexOffset__(out_data_array_idx,p,q,r);\
				uint8_t temp_out_rem = out_data_array_idx - 4*(out_data_array_idx >> 2);\
				__putOneBlock__(out.data_array[out_data_array_idx >> 2],temp_out_rem,result_temp);\
			}\
		}\
	}\
})

#define __checkIncrementCondition1__(i,j,k)({\
	k++;\
	if(k == dim3_ker)\
	{\
		k = 0;\
		j++;\
		if(j == dim2_ker)\
		{\
			j = 0;\
			i++;\
		}\
	}\
})

#define __GetImgEntryIndexOffset__(ret_val,x,y,z)({\
	ret_val = z + dim2_inp*y + dim2_inp*dim1_inp*x;\
})

#define __GetKerEntryIndexOffset__(ret_val,w,x,y,z)({\
	ret_val = z + dim3_ker*y + dim3_ker*dim2_ker*x + dim3_ker*dim2_ker*dim1_ker*w;\
})

#define __GetOutEntryIndexOffset__(ret_val,x,y,z)({\
	ret_val = z + dim2_out*y + dim2_out*dim1_out*x;\
})

#define __getOneTensorBlock__(tnsr,data,index)({\
	data = tnsr.data_array[index >> 2];\
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
})
