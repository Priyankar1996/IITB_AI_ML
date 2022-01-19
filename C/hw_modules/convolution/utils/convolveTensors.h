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
    	__dim0__(out) = (__dim0__(inp) - __dim1__(ker))/stride + 1;\
	__dim1__(out) = (__dim1__(inp) - __dim2__(ker))/stride + 1;\
	__dim2__(out) = (__dim0__(ker));\
	out.descriptor.tensor_size = __dim0__(out) * __dim1__(out) * __dim2__(out);\
	int out_idx = 0;\
	for (int p = 0; p < __dim0__(out); p++)\
	{\
		for(int q = 0; q < __dim1__(out); q++)\
		{\
			for(int r = 0; r < __dim2__(out); r++)\
			{\
				for(int i = 0; i < __dim1__(ker); i++)\
				{\
					for(int j = 0; j < __dim2__(ker); j++)\
					{\
						for(int k = 0; k < __dim3__(ker); k++)\
						{\
							int img_index[3] = {p*stride+i,q*stride+j,k};\
							int ker_index[4] = {r,i,j,k};\
							int img_data_array_idx = __getTensorEntryIndexOffset__(inp,img_index);\
							int ker_data_array_idx = __getTensorEntryIndexOffset__(ker,ker_index);\
							*(((int16_t*)out.data_array) + out_idx) += *(((int16_t*)inp.data_array) + img_data_array_idx) * *(((int16_t*)ker.data_array) + ker_data_array_idx);\
						}\
					}\
				}\
				out_idx++;\
			}\
		}\
	}\
})
