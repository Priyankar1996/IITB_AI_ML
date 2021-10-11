#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"

int main()
{
    //Create and initialize mempools.
    MemPool pool;
    initMemPool(&pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);

    MemPool kernel_pool;
    initMemPool(&kernel_pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);

    int num_iters = 1;
    int num_dim =3;
    
    Tensor T[2*num_iters+1];
    Tensor K;
    Tensor S[4*num_iters];
    Tensor R[4*num_iters];

    int pad[4] = {0,0,0,0};
    int str = 1, str_deconv;
    int stride[2] = {str,str};
    int stride_deconv[3] = {str_deconv,str_deconv};
    int dim_to_pool[2] = {1,2};
    int pad_deconv = 0;
    int _err_ = 0;

    //encoding loop
    for(int i=0;i<num_iters;i++)
    {
        updateOutputDescriptorConvTensors(&T[i], &K, stride, pad, &S[i]);
        createTensor(&S[i],&pool,1,1);
        new_convTensors(&T[i], &K, &S[i] ,stride,pad );
        unaryOperateOnTensor_inplace(&S[i], 2);
        destroyTensor(&T[i]);

        updateOutputDescriptorConvTensors(&S[i], &K, stride, pad, &R[i]);
        createTensor(&R[i],&pool,1,1);
        new_convTensors(&S[i], &K, &R[i] ,stride,pad );
        unaryOperateOnTensor_inplace(&R[i], 2);
        destroyTensor(&S[i]);

        updateOutputDescriptorMaxPoolOfTensors(&R[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1);
        maxPoolOfTensors(&R[i], &T[i+1], str, str, 2,dim_to_pool, 0);
    } 

    updateOutputDescriptorConvTensors(&T[num_iters], &K, stride, pad, &S[num_iters]);
    createTensor(&S[num_iters],&pool,1,1);
    new_convTensors(&T[num_iters], &K, &S[num_iters], stride, pad);
    unaryOperateOnTensor_inplace(&S[num_iters],2);
    destroyTensor(&T[num_iters]);

    updateOutputDescriptorConvTensors(&S[num_iters], &K, stride, pad, &R[num_iters]);
    createTensor(&R[num_iters],&pool,1,1);
    new_convTensors(&S[num_iters], &K, &R[num_iters] ,stride,pad );
    unaryOperateOnTensor(&R[num_iters],&T[num_iters+1] ,2);
    destroyTensor(&S[num_iters]);


    //decoding loop
    for(int i = num_iters+1; i <= 2*num_iters; i++)
    {
        updateOutputSDescriptorDilateTensors(&T[i], &K, stride, &S[i]);
        createTensor(&S[i],&pool,1);
        dilateTensor(&T[i],&K, stride, &S[i]);

        destroyTensor(&T[i]);

        updateOutputSDescriptorDepadTensors(&S[i], pad_deconv, &S[num_iters+i]);
        createTensor(&S[num_iters+i],&pool,1);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);

        createTensor(&R[num_iters+1],&pool,1,1);
        concatTensor(&S[num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i]);

        updateOutputDescriptorConvTensors(&R[num_iters+i], &K, stride, pad, &S[2*num_iters+i]);
        createTensor(&S[2*num_iters+i],&pool,1,1);
        new_convTensors(&R[num_iters+i], &K, &S[2*num_iters+i] ,stride,pad );
        unaryOperateOnTensor_inplace(&S[2*num_iters+i], 2);
        destroyTensor(&R[num_iters+i]);

        updateOutputDescriptorConvTensors(&S[2*num_iters+i], &K, stride, pad, &R[2*num_iters+i]);
        createTensor(&R[2*num_iters+i],&pool,1,1);
        new_convTensors(&S[2*num_iters+i], &K, &R[2*num_iters+i] ,stride,pad );
        unaryOperateOnTensor_inplace(&R[2*num_iters+i], 2);
        destroyTensor(&S[2*num_iters+i]);

        updateOutputDescriptorMaxPoolOfTensors(&R[2*num_iters+i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1);
        maxPoolOfTensors(&R[2*num_iters+i], &T[i+1], str, str, 2,dim_to_pool, 0);
    }

    updateOutputDescriptorConvTensors(&T[2*num_iters+1],&K ,stride, pad, &T[2*num_iters+2]);
    new_convTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, pad);
}