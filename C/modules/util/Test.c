#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"


int main(){
    int num_dim = 3;
    int num_iters = 1;
    MemPool pool;
    Tensor T[2*num_iters];
    Tensor K;
    Tensor S[3*num_iters]; // This number will change because concat tensors hasn't been incorporated yet.

    int pad[num_dim];
    int stride[num_dim];
    int stride_deconv[2] = {2,2};
    int pad_deconv = 0;
    int _err_ = 0;
    float kernel_init = 1.0;

    initMemPool(&pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);
    for (int i = 0; i < 2*num_iters; i++)
    {
        T[i].descriptor.data_type = float32;
        T[i].descriptor.number_of_dimensions = num_dim;
        T[i].descriptor.row_major_form = 0;
    }

    for (int i=0; i < 3*num_iters; i++)
    {
        S[i].descriptor.data_type = float32;
        S[i].descriptor.number_of_dimensions = num_dim;
        S[i].descriptor.row_major_form = 0;
    }

    K.descriptor.data_type = float32;
    K.descriptor.number_of_dimensions = num_dim;
    K.descriptor.row_major_form = 0;
    K.descriptor.dimensions[0] = 3;
    K.descriptor.dimensions[1] = 3;
    K.descriptor.dimensions[2] = 1;

    _err_ = createTensorAtHead(&K,&pool) || 
            initializeTensor(&K,&kernel_init) || _err_;


    for (int i = 0; i < num_iters; i++){
        // There should be another loop for tensor->dimension[2] as all the operations are on 2D.
        _err_ = convTensors(&T[i], &K, &S[i] ,stride,pad ) || _err_;
        unaryOperateOnTensor_inplace(&S[i], 2);
        maxPoolOfTensors(&S[i], &T[i+1],2, 2,  2, stride, 0); 
    }
    for (int i = num_iters; i < 2*num_iters; i++){
         // There should be another loop for tensor->dimension[2] as all the operations are on 2D.
        _err_ = dilateTensor(&T[i], &K, stride,  &S[i]) ||
                dePadTensor(&S[i],pad_deconv,&S[num_iters + i]) ||
                convTensors(&S[num_iters + i],&K,&T[i+1],stride_deconv,pad_deconv ) || _err_;
        unaryOperateOnTensor_inplace(S[i], 5);
    }
    if (_err_)
        fprintf(stderr,"Something's wrong. Please check.");
    return 0;
}