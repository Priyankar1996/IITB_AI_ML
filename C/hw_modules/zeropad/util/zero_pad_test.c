#include <stdio.h>
#include <stdint.h>
#include "sized_tensor.h"
#include "zero_pad.h"
#include <inttypes.h>

#define __I16 5

SizedTensor_1024 T,K;

void initTensor(SizedTensor_1024* T)
{
    for (int i = 0; i < T->descriptor.tensor_size; i++)
    {
        *((int16_t*)T->data_array + i) = i+1;
    }
}

int main(){
	T.descriptor.descriptor.data_type = i16;
    T.descriptor.descriptor.number_of_dimensions = 3;
    T.descriptor.descriptor.dimensions[0] = 3;
    T.descriptor.descriptor.dimensions[1] = 3;
    T.descriptor.descriptor.dimensions[2] = 3;
    T.descriptor.descriptor.row_major_form = 1;
    T.descriptor.tensor_size = 27;

    int scale_factor = 1;

    K.descriptor.descriptor.data_type = i16;
    K.descriptor.descriptor.number_of_dimensions = 4;
    K.descriptor.descriptor.dimensions[0] = T.descriptor.descriptor.dimensions[0] + 2*scale_factor;
    K.descriptor.descriptor.dimensions[1] = T.descriptor.descriptor.dimensions[1] + 2*scale_factor;
    K.descriptor.descriptor.dimensions[2] = T.descriptor.descriptor.dimensions[2] + 2*scale_factor;
    K.descriptor.descriptor.row_major_form = 1;
    K.descriptor.tensor_size = K.descriptor.descriptor.dimensions[0] * K.descriptor.descriptor.dimensions[1] * K.descriptor.descriptor.dimensions[2]; 
    // Zero-padding the the source tensor in order to generate the
    // padded tensor
    initTensor(&T);
    __zero_pad__(T,scale_factor,K);
    fprintf("\n ZeroPad Completed!!");
	return 0;
}
