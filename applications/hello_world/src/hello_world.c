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
    
    readTensorFromFile("inpT0.csv",&T[0],&pool);
    readTensorFromFile("inpK0.csv",&K,&pool);

    _err_ = writeTensorToFile("T0.csv",&T[0]) || _err_;

    for (int i = 0; i < num_iters; i++){
        updateOutputDescriptorConvTensors(&T[i], &K, stride, pad, &S[i] );
        createTensor(&S[i],&pool,1,1);
        new_convTensors(&T[i], &K, &S[i] ,stride,pad );
        
        destroyTensor(&T[i]);

        char ch[10];
        sprintf(ch,"S%d.csv",i);
        writeTensorToFile(ch,&S[i]);

        updateOutputDescriptorMaxPoolOfTensors(&S[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],&pool,1);
        maxPoolOfTensors(&S[i], &T[i+1], str, str, 2,dim_to_pool, 0); 

        unaryOperateOnTensor_inplace(&T[i+1], 2);  

        destroyTensor(&S[i]); 
        
        sprintf(ch,"T%d.csv",i+1);
        writeTensorToFile(ch,&T[i+1]);
    }

    for (int i = num_iters; i < 2*num_iters; i++){
        updateOutputSDescriptorDilateTensors(&T[i], &K, stride, &S[i]);
        createTensor(&S[i],&pool,1);
        dilateTensor(&T[i], &K, stride,  &S[i]);

        char ch[10];
        sprintf(ch,"S%d.csv",i);
        writeTensorToFile(ch,&S[i]);

        updateOutputSDescriptorDepadTensors(&S[i], pad_deconv, &S[num_iters+i]);
        createTensor(&S[num_iters+i],&pool,1);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);

        sprintf(ch,"S%d.csv",i+num_iters);
        writeTensorToFile(ch,&S[num_iters +i]);
        updateOutputDescriptorConvTensors(&S[num_iters+i],&K, stride, pad, &T[i+1] );
        createTensor(&T[i+1],&pool,1);
        new_convTensors(&S[num_iters+i],&K,&T[i+1],stride,pad );
        
        unaryOperateOnTensor_inplace(&T[i+1], 5);
        
        sprintf(ch,"T%d.csv",i+1);
        writeTensorToFile(ch,&T[i+1]);
    }


    
    return 0;
}
