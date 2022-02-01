#ifndef __zerp_pad_h__
#define __zerp_pad_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include <inttypes.h>
#include <assert.h>
#include "sized_tensor.h"

void zeropad_thread();

#define __I16 1
#define __dim0__(dest) ({dest.descriptor.descriptor.dimensions[0];})
#define __dim1__(dest) ({dest.descriptor.descriptor.dimensions[1];})
#define __dim2__(dest) ({dest.descriptor.descriptor.dimensions[2];})

#define __dt__ int16_t
#define __dt_min_val__ 0x8000

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif
// The function "zeropadtensor" creates a new tensor for zero padding 
// It creates it from the src tensor by reading and then writing the 
// destination tensor according to scale factor provded. 

// ASSUMPTIONS:
//      1. source (src) tensor is already declared with its description
//      2. destination (dest) tensor is already declared taking into scale factor into account
//         , with its description.
// SUMMARY:
//      Zero padding of the tensor : Adds outer layer of constant (mostly 0) to the pre-existing 
//      src tensor to create the dest tensor, in all dimensions 
// SIDE-EFFECTS:
//      The data stored in the destination tensor is changes according to the src and the 
//      constant as well as the scale factor bby which we want to pad the src tensor
// ARGUEMENTS:
//      scr :- pointer to the source tensor
//      scale_factor :- The factor of layer which is added to each dimension for zero padding
//      dest :- pointer to the destination tensor
// RETURN VALUES:
//      NA
#define __zero_pad__(src, scale_factor,dest)  ({\
    int n1 = src.descriptor.descriptor.dimensions[0];\
    int n2 = src.descriptor.descriptor.dimensions[1];\
    int n3 = src.descriptor.descriptor.dimensions[2];\
    SizedTensor_1M dest2;\
    dest2.descriptor.descriptor.data_type = i16;\
    dest2.descriptor.descriptor.number_of_dimensions = 3;\
    dest2.descriptor.descriptor.dimensions[0] = dest.descriptor.descriptor.dimensions[0];\
    dest2.descriptor.descriptor.dimensions[1] = dest.descriptor.descriptor.dimensions[1];\
    dest2.descriptor.descriptor.dimensions[2] = dest.descriptor.descriptor.dimensions[2];\
    dest2.descriptor.descriptor.row_major_form = 1;\
    dest2.descriptor.tensor_size = (dest.descriptor.descriptor.dimensions[0])*(dest.descriptor.descriptor.dimensions[1])*(dest.descriptor.descriptor.dimensions[2]);\
    int size=(n1*n2*n3);\
    int pad=scale_factor;\
    int idx   = 0;\
	int width = 0;\
	int i, j, k;\
	for(i=0;i<n1;i++)\
	{\
		for(j=0;j<n2;j++ )\
		{\
			for(k=0;k<n3;k++)\
			{\
				*(((int16_t*)dest2.data_array) + (n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))) = *(((int16_t*)src.data_array) + (k+n3*j+n2*n3*i));\
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
                *(((int16_t*)dest.data_array) + index) = *(((int16_t*)dest2.data_array) +  k*jump_matrix +  j*(n1+2*pad) + i );\
		        fprintf("%d ",*(((int16_t*)dest.data_array) + index));\
			    index = index + 1 ;\
			}\
		}\
	}\
})
#endif