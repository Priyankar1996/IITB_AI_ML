#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "tensor.h"
#include "mempool.h"


int main(){
    int num_dim = 0;
    int num_iters = 0;
    Tensor T[2*num_iters];
    Tensor K;
    Tensor S[2*num_iters];

    int pad[num_dim];
    int stride[num_dim];
    for (int i = 0; i < num_iters; i++){
        convTensors(&T[i], &K, &S[i] ,stride,pad );
        unaryOperateOnTensor_inplace(&S[i], 2);
        maxPoolOfTensors(&S[i], &T[i+1],2, 2,  2, stride, 0);
    }
    for (int i = num_iters; i < 2*num_iters; i++){
        dilateTensor(&T[i], &K, stride,  &S[i]);
        unaryOperateOnTensor_inplace(S[i], 5);
        
    }    
    return 0;
}