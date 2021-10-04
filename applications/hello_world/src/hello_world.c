// Pilot model to verify implementation of individual operations
// AUTHORS : Aman Dhammani , Priyankar Sarkar
// Department of Electrical Engineering, IITB

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"


int main(){
    // Create and initialize mempools
    MemPool pool;
    initMemPool(&pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);

    // Number of iterations
    int num_iters = 1;
    int num_dim =3;
    
    Tensor T[2*num_iters+1];
    Tensor K;
    Tensor S[3*num_iters]; // This number will change because concat tensors hasn't been incorporated yet.

    int pad[4] = {0,0,0,0};
    int str = 1;
    int stride[2] = {str,str};
    
    int stride_deconv[3] = {str,str,str};
    int dim_to_pool[2] = {1,2};
    int pad_deconv = 0;
    int _err_ = 0;
    float kernel_init = 0.1;

    for (int i=0; i < 2*num_iters+1; i++)
    {
        T[i].descriptor.data_type = float32;
        T[i].descriptor.number_of_dimensions = num_dim;
        T[i].descriptor.row_major_form = 1;
        T[i].descriptor.dimensions[0] = 3;
        T[i].descriptor.dimensions[1] = 3;
        T[i].descriptor.dimensions[2] = 3;  
    }
    for (int i=0; i < 3*num_iters; i++)
    {
        S[i].descriptor.data_type = float32;
        S[i].descriptor.number_of_dimensions = num_dim;
        S[i].descriptor.row_major_form = 1;
        S[i].descriptor.dimensions[0] = 3;
        S[i].descriptor.dimensions[1] = 3;
        S[i].descriptor.dimensions[2] = 3;  
    }

    for (int i = 0; i < 2*num_iters;i++){
        createTensorAtHead(&T[i],&pool);
        createTensorAtHead(&S[i],&pool);
        if (i>=num_iters)
        createTensorAtHead(&S[num_iters+i],&pool);
    }
    createTensor(&T[2*num_iters],&pool,1);

    readTensorFromFile("inpT0.csv",&T[0],&pool);
    readTensorFromFile("inpK0.csv",&K,&pool);
    // _err_ = initializeTensor(&K,&kernel_init) || _err_;


    for (int i = 0; i < num_iters; i++){
        new_convTensors(&T[i], &K, &S[i] ,stride,pad );
        updateOutputDescriptorMaxPoolOfTensors(&S[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1);
        maxPoolOfTensors(&S[i], &T[i+1], str, str, 2,dim_to_pool, 0); 
        unaryOperateOnTensor_inplace(&T[i+1], 2);   
    }


    for (int i = num_iters; i < 2*num_iters; i++){
        dilateTensor(&T[i], &K, stride,  &S[i]);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);
        new_convTensors(&S[num_iters+i],&K,&T[i+1],stride,pad );
        unaryOperateOnTensor_inplace(&T[i+1], 5);
    }

    _err_ = writeTensorToFile("T0.csv",&T[0]) || _err_;
    _err_ = writeTensorToFile("S0.csv",&S[0]) || _err_;
    _err_ = writeTensorToFile("T1.csv",&T[1]) || _err_;
    _err_ = writeTensorToFile("S1.csv",&S[1]) || _err_;
    _err_ = writeTensorToFile("S2.csv",&S[2]) || _err_;
    _err_ = writeTensorToFile("T2.csv",&T[2]) || _err_;

    
    return 0;
}
