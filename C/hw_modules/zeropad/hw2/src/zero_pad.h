//Assumptions : 3D tensor, row_major, int16 data type

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"
#include <inttypes.h>
#include <assert.h>


#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})

#define __zero_pad__(T, pad, R)  ({\
    int n1 = T.descriptor.descriptor.dimensions[0];\
    int n2 = T.descriptor.descriptor.dimensions[1];\
    int n3 = T.descriptor.descriptor.dimensions[2];\
    SizedTensor_1M dest2;\
    dest2.descriptor.descriptor.data_type = i16;\
    dest2.descriptor.descriptor.number_of_dimensions = 3;\
    dest2.descriptor.descriptor.dimensions[0] = R.descriptor.descriptor.dimensions[0];\
    dest2.descriptor.descriptor.dimensions[1] = R.descriptor.descriptor.dimensions[1];\
    dest2.descriptor.descriptor.dimensions[2] = R.descriptor.descriptor.dimensions[2];\
    dest2.descriptor.descriptor.row_major_form = 1;\
    dest2.descriptor.tensor_size = (R.descriptor.descriptor.dimensions[0])*(R.descriptor.descriptor.dimensions[1])*(R.descriptor.descriptor.dimensions[2]);\
    int size=(n1*n2*n3);\
    int idx   = 0;\
	int width = 0;\
	int i, j, k;\
	for(i=0;i<n1;i++)\
	{\
		for(j=0;j<n2;j++ )\
		{\
			for(k=0;k<n3;k++)\
			{\
				*(((int16_t*)dest2.data_array) + (n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))) = *(((int16_t*)T.data_array) + (k+n3*j+n2*n3*i));\
			}\
		}\
	}\
    int index=0;\
    int jump_matrix = ((n1+2*pad)*(n2+2*pad));\
    int row_jump = (n1+2*pad);\
    int column_jump = (n2+2*pad);\
    for(i=0;i<n1+2*pad;i++)\
	{\
		for(j=0;j<n2+2*pad;j++)\
		{\
			for(k=0;k<n3;k++)\
			{\
                *(((int16_t*)R.data_array) + index) = *(((int16_t*)dest2.data_array) +  k*jump_matrix +  j*(n1+2*pad) + i );\
		        fprintf("%d ",*(((int16_t*)R.data_array) + index));\
			    index = index + 1 ;\
			}\
		}\
	}\
})