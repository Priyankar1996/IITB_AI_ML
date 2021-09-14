#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "tensor.h"
#include "mempool.h"
#include "createTensor.h"
#include "maxPoolOfTensors.h"
#include "conv.h"
#include ".h"

int main(){

    int num_iters = 0;
    Tensor T[2*num_iters];
    Tensor K;
    Tensor S[2*num_iters];

    for (int i = 0; i < num_iters; i++){
        convTensors(&T[num_iters], &K, &S[num_iters] ,0 ,0 );
    }
    return 0;
}