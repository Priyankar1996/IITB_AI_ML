//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

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
	int out_idx = 0;\
	int p,q,r,i,j,k;\
	for (p = 0; p < __dim0__(out); p++)\
	{\
		for(q = 0; q < __dim1__(out); q++)\
		{\
			for(r = 0; r < __dim2__(out); r++)\
			{\
				for(i = 0; i < __dim1__(ker); i++)\
				{\
					for(j = 0; j < __dim2__(ker); j++)\
					{\
						for(k = 0; k < __dim3__(ker); k++)\
						{\
							int img_index[3] = {p*stride+i,q*stride+j,k};\
							int ker_index[4] = {r,i,j,k};\
							int img_data_array_idx = __GetTensorEntryIndexOffset__(inp,img_index);\
							int ker_data_array_idx = __GetTensorEntryIndexOffset__(ker,ker_index);\
							*(((int16_t*)out.data_array) + out_idx) += *(((int16_t*)inp.data_array) + img_data_array_idx) * *(((int16_t*)ker.data_array) + ker_data_array_idx);\
						}\
					}\
				}\
				out_idx++;\
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
