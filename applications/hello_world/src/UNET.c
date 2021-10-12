// UNET model for image segmentation
// AUTHORS : Aman Dhammani , Priyankar Sarkar
// Department of Electrical Engineering, IITB

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"
#include "maxPoolOfTensors.h"
#include "createTensor.h"
#include "conv.h"
#include "convolutionTranspose.h"
#include "unary_fn.h"
#include "readWriteTensorsFromStandardIO.h"
// #include "batchNormalization.h"
#include "concat.h"

void batch(int x,MemPool*kernel_pool,Tensor*gamma,Tensor*beta,Tensor*moving_mean,Tensor*moving_variance,Tensor*T){
        char next_file[100];
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dgamma.csv",x,x);
        readTensorFromFile(next_file,gamma, kernel_pool);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dbeta.csv",x,x);
        readTensorFromFile(next_file,beta, kernel_pool);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_mean.csv",x,x);
        readTensorFromFile(next_file,moving_mean, kernel_pool);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_variance.csv",x,x);
        readTensorFromFile(next_file, moving_variance, kernel_pool);

        batchNormalization(T, beta, gamma, moving_mean, moving_variance, 0.001);

        destroyTensor(gamma);
        destroyTensor(beta);
        destroyTensor(moving_mean);
        destroyTensor(moving_variance);
}

int main()
{
    //Create and initialize mempools.
    MemPool pool;
    initMemPool(&pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);

    MemPool kernel_pool;
    initMemPool(&kernel_pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);

    int num_iters = 3;
    
    Tensor T[2*num_iters+3];
    Tensor K;
    Tensor S[4*num_iters];
    Tensor R[4*num_iters];
    Tensor beta, gamma, moving_mean, moving_variance;

    int pad[4] = {0,0,0,0};
    int str = 2;
    int stride[2] = {str,str};
    int dim_to_pool[2] = {0,1};
    int pad_deconv = 0;

    readTensorFromFile("Updated_weights/T0.csv",&T[0],&pool);

    char next_file[100];
    //encoding loop
    for(int i=0;i<num_iters;i++)
    {
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i,2*i);
        readTensorFromFile(next_file,&K, &kernel_pool);

        updateOutputDescriptorConvTensors(&T[i], &K, &S[i], stride, pad);
        createTensor(&S[i],&pool,1,1);
        new_convTensors(&T[i], &K, &S[i] ,stride,pad );

        destroyTensor(&K);
        destroyTensor(&T[i]);

        batch(2*i,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[i]);

        unaryOperateOnTensor_inplace(&S[i], 2);

        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i+1,2*i+1);
        readTensorFromFile(next_file,&K, &kernel_pool);

        updateOutputDescriptorConvTensors(&S[i], &K, &R[i], stride, pad);
        createTensor(&R[i],&pool,1,1);
        new_convTensors(&S[i], &K, &R[i] ,stride,pad );

        destroyTensor(&K);
        destroyTensor(&S[i]);

        batch(2*i+1,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[i]);

        unaryOperateOnTensor_inplace(&R[i], 2);

        updateOutputDescriptorMaxPoolOfTensors(&R[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1,1);
        maxPoolOfTensors(&R[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        printf("Loop 1 destroyed");
    } 

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*num_iters,2*num_iters);
    readTensorFromFile(next_file,&K, &kernel_pool);

    updateOutputDescriptorConvTensors(&T[num_iters], &K, &S[num_iters], stride, pad);
    createTensor(&S[num_iters],&pool,1,1);
    new_convTensors(&T[num_iters], &K, &S[num_iters], stride, pad);

    destroyTensor(&T[num_iters]);
    destroyTensor(&K);

    batch(2*num_iters,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[num_iters]);

    unaryOperateOnTensor_inplace(&S[num_iters],2);

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*num_iters+1,2*num_iters+1);
    readTensorFromFile(next_file,&K, &kernel_pool);

    updateOutputDescriptorConvTensors(&S[num_iters], &K, &R[num_iters], stride, pad);
    createTensor(&R[num_iters],&pool,1,1);
    new_convTensors(&S[num_iters], &K, &R[num_iters] ,stride,pad );

    destroyTensor(&K);
    destroyTensor(&S[num_iters]);

    batch(2*num_iters+1,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&R[num_iters]);

    unaryOperateOnTensor(&R[num_iters],&T[num_iters+1] ,2);


    //decoding loop
    for(int i = num_iters+1; i <= 2*num_iters; i++)
    {
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_transpose_%dkernel.csv",i-num_iters-1,i-num_iters-1);
        readTensorFromFile(next_file,&K, &kernel_pool);

        updateOutputSDescriptorDilateTensors(&T[i], &K, stride, &S[i]);
        createTensor(&S[i],&pool,1,1);
        dilateTensor(&T[i],&K, stride, &S[i]);

        destroyTensor(&K);
        destroyTensor(&T[i]);

        updateOutputSDescriptorDepadTensors(&S[i], pad_deconv, &S[num_iters+i]);
        createTensor(&S[num_iters+i],&pool,1,1);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);

        createTensor(&R[num_iters+1],&pool,1,1);
        concatTensors(&S[num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i]);

        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i,2*i);
        readTensorFromFile(next_file,&K, &kernel_pool);

        updateOutputDescriptorConvTensors(&R[num_iters+i], &K, &S[2*num_iters+i], stride, pad);
        createTensor(&S[2*num_iters+i],&pool,1,1);
        new_convTensors(&R[num_iters+i], &K, &S[2*num_iters+i] ,stride,pad );

        destroyTensor(&K);
        destroyTensor(&R[num_iters+i]);

        batch(2*i,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[num_iters]);

        unaryOperateOnTensor_inplace(&S[2*num_iters+i], 2);
        
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i+1,2*i+1);
        readTensorFromFile(next_file,&K, &kernel_pool);

        updateOutputDescriptorConvTensors(&S[2*num_iters+i], &K, &R[2*num_iters+i], stride, pad);
        createTensor(&R[2*num_iters+i],&pool,1,1);
        new_convTensors(&S[2*num_iters+i], &K, &R[2*num_iters+i] ,stride,pad );

        destroyTensor(&K);
        destroyTensor(&S[2*num_iters+i]);

        batch(2*i+1,&kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[num_iters]);

        unaryOperateOnTensor_inplace(&R[2*num_iters+i], 2);

        updateOutputDescriptorMaxPoolOfTensors(&R[2*num_iters+i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1,1);
        maxPoolOfTensors(&R[2*num_iters+i], &T[i+1], str, str, 2,dim_to_pool, 0);
    }

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",4*num_iters+2,4*num_iters+2);
    readTensorFromFile(next_file,&K, &kernel_pool);

    updateOutputDescriptorConvTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, pad);
    new_convTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, pad);

    destroyTensor(&K);
    writeTensorToFile("GeneratedImage.csv",&T[2*num_iters+2]);
}