#include "convolveTensors.h"
#include <stdio.h>
#include <stdint.h>
#include "tensor.h"
#include "sized_tensor.h"
#include <inttypes.h>

SizedTensor_1024 T,K,R;

#define __I16 5

void initTensor(SizedTensor_1024 T)
{
    for (int i = 0; i < T.descriptor.tensor_size; i++)
    {
        *((int16_t*)T.data_array + i) = 5;
        printf("%"PRIu16"\t",*(((int16_t*)T.data_array) + i));
        printf("%d\n",i);
    }
}

int main()
{
    T.descriptor.descriptor.data_type = i16;
    T.descriptor.descriptor.number_of_dimensions = 3;
    T.descriptor.descriptor.dimensions[0] = 3;
    T.descriptor.descriptor.dimensions[1] = 3;
    T.descriptor.descriptor.dimensions[2] = 3;
    T.descriptor.descriptor.row_major_form = 1;
    T.descriptor.tensor_size = 27;

    K.descriptor.descriptor.data_type = i16;
    K.descriptor.descriptor.number_of_dimensions = 4;
    K.descriptor.descriptor.dimensions[0] = 1;
    K.descriptor.descriptor.dimensions[1] = 1;
    K.descriptor.descriptor.dimensions[2] = 1;
    K.descriptor.descriptor.dimensions[3] = 3;
    K.descriptor.descriptor.row_major_form = 1;
    K.descriptor.tensor_size = 3;

    initTensor(T);
    initTensor(K);
    int stride = 1;
    __convolveTensors__(T,K,R,stride);
    for(int i = 0; i < R.descriptor.tensor_size; i++)
    {
        printf("%"PRIu16"\n",*((int16_t*)R.data_array + i));
    }
    return 0;
}
