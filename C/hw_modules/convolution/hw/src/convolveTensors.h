//Assumptions : 3D tensor, row_major, int16 data type

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
	int16_t result_temp,temp;\
	int p,q,r,i,j,k;\
	int count = 0;\
	uint64_t img_data;\
	uint64_t ker_data;\
	for (p = 0; p < __dim0__(out); p++)\
	{\
		for(q = 0; q < __dim1__(out); q++)\
		{\
			for(r = 0; r < __dim2__(out); r++)\
			{\
				result_temp = 0;\
				while(i < __dim1__(ker))\
				{\
					int img_data_array_idx = __GetTensorEntryIndexOffset__(inp,0,p*stride+i,q*stride+j,k);\
					int ker_data_array_idx = __GetTensorEntryIndexOffset__(ker,r,i,j,k);\
					uint64_t img_data = inp.data_array[img_data_array_idx >> 2];\
					uint64_t ker_data = ker.data_array[ker_data_array_idx >> 2];\
					if((count - 4*(count >> 2)) == 0)\
					{\
						__getOneTensorBlock__(inp,img_data,img_data_array_idx);\
						__getOneTensorBlock__(ker,ker_data,ker_data_array_idx);\
					}\
					uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
					uint8_t temp_ker_rem = ker_data_array_idx - 4*(ker_data_array_idx >> 2);\
					int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
					int16_t ker_one_block = __getOneBlock__(ker_data,temp_ker_rem);\
					temp = result_temp;\
					result_temp = temp + (img_one_block * ker_one_block);\
					k++;\
					if(k == __dim3__(ker))\
					{\
						k = 0;\
						j++;\
						if(j == __dim2__(ker))\
						{\
							j = 0;\
							i++;\
						}\
					}\
					count++;\
				}\
				int out_data_array_idx = __GetTensorEntryIndexOffset__(out,0,p,q,r);\
				uint8_t temp_out_rem = out_data_array_idx - 4*(out_data_array_idx >> 2);\
				__putOneBlock__(out.data_array[out_data_array_idx >> 2],temp_out_rem,result_temp);\
			}\
		}\
	}\
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
