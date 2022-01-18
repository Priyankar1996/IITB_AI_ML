#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

#define __dim0__(dest) ({dest.descriptor.descriptor.dimensions[0];})
#define __dim1__(dest) ({dest.descriptor.descriptor.dimensions[1];})
#define __dim2__(dest) ({dest.descriptor.descriptor.dimensions[2];})
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
    SizedTensor_16K dest2;\
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
	for(int i=0;i<n1;i++)\
	{\
		for(int j=0;j<n2;j++ )\
		{\
			for(int k=0;k<n3;k++)\
			{\
				//dest2.data_array[(n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))]=src.data_array[k+n3*j+n2*n3*i];
                *(((int16_t*)dest2.data_array) + (n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))) = *(((int16_t*)src.data_array) + (k+n3*j+n2*n3*i]));\
			}\
		}\
	}\
	int index=0;\
	int jump_matrix = ((n1+2*pad)*(n2+2*pad));\ 
	int row_jump = (n1+2*pad);\ 
	int column_jump = (n2+2*pad);\
    for(int i=0;i<n1+2*pad;i++)\
	{\
		for(int j=0;j<n2+2*pad;j++)\
		{\
			for(int k=0;k<n3;k++)\
			{\
			    //dest.data_array[index] = dest2.data_array[ k*jump_matrix +  j*(n1+2*pad) + i ];\ 
                *(((int16_t*)dest.data_array) + index) = *(((int16_t*)dest2.data_array) +  k*jump_matrix +  j*(n1+2*pad) + i );\
		        printf("%ld ",*(((int16_t*)dest.data_array) + index));\
			    index = index + 1 ;\
			}\
		}\
	}\
})
