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
    Tensor T[2*num_iters+1];
    Tensor K;
    Tensor S[3*num_iters]; // This number will change because concat tensors hasn't been incorporated yet.

    int pad[3] = {0,0,0};
    int str = 1;
    int stride[2] = {str,str};
    int stride_deconv[2] = {str,str};
    int dim_to_pool[2] = {1,2};
    int pad_deconv = 0;
    int _err_ = 0;
    float kernel_init = 1.0;

    initMemPool(&pool,1,MAX_MEMPOOL_SIZE_IN_PAGES);
    for (int i = 0; i < 2*num_iters+1; i++)
    {
        T[i].descriptor.data_type = float32;
        T[i].descriptor.number_of_dimensions = num_dim;
        T[i].descriptor.row_major_form = 1;
        T[i].descriptor.dimensions[0] = 1;
        T[i].descriptor.dimensions[1] = 3;
        T[i].descriptor.dimensions[2] = 3;    
    }

    for (int i=0; i < 3*num_iters; i++)
    {
        S[i].descriptor.data_type = float32;
        S[i].descriptor.number_of_dimensions = num_dim;
        S[i].descriptor.row_major_form = 1;
        S[i].descriptor.dimensions[0] = 1;
        S[i].descriptor.dimensions[1] = 3;
        S[i].descriptor.dimensions[2] = 1;  
    }

    for (int i = 0; i < 2*num_iters;i++){
        createTensorAtHead(&T[i],&pool);
        createTensorAtHead(&S[i],&pool);
        if (i>=num_iters)
        createTensorAtHead(&S[num_iters+i],&pool);
    }
    createTensorAtHead(&T[2*num_iters+1],&pool);
    // Write data 1 to 9 in T[0]
    for (int i = 0; i < (getSizeOfTensor(&T[0])+1)/2; i++){
        MemPoolRequest req;
        MemPoolResponse resp;
        req.request_type = WRITE;
        req.arguments[1] = T[0].mem_pool_buffer_pointer + i;
        req.arguments[0] = 1;
        req.arguments[2] = 1;
        req.write_data[0] = ((uint64_t)(2*i+1)<<32) + 2*i;
        memPoolAccess((MemPool*)(T[0].mem_pool_identifier),&req,&resp);
    }

    K.descriptor.data_type = float32;
    K.descriptor.number_of_dimensions = num_dim;
    K.descriptor.row_major_form = 1;
    K.descriptor.dimensions[0] = 1;
    K.descriptor.dimensions[1] = 1;
    K.descriptor.dimensions[2] = 1;

    _err_ = createTensorAtHead(&K,&pool) || 
            initializeTensor(&K,&kernel_init) || _err_;


    for (int i = 0; i < num_iters; i++){
        // There should be another loop for tensor.dimension[2] as all the operations are on 2D.
        convTensors(&T[i], &K, &S[i] ,stride,pad );
        // maxPoolOfTensors(&S[i], &T[i+1], str, str, 1,dim_to_pool, 0); 
        // unaryOperateOnTensor_inplace(&T[i+1], 2);
    }

    for (int i = 0;i<num_iters;i++){
        MemPoolRequest req;
        MemPoolResponse resp;
        req.request_type = READ;
        req.arguments[2] = 1;
        req.arguments[1] = T[i].mem_pool_buffer_pointer;
        req.arguments[0] = getSizeOfTensor(&T[i]);
        memPoolAccess((MemPool*)(T[i].mem_pool_identifier),&req,&resp);
        for (int j = 0; j < req.arguments[0]; j++ ){
            printf("T[%d] element %d = %lu \n",i,j,0xFF&(resp.read_data[j/2]>>(32*(j&1))));
        }
        printf("\n");
        req.arguments[1] = S[i].mem_pool_buffer_pointer;
        req.arguments[0] = getSizeOfTensor(&T[i]);
        memPoolAccess((MemPool*)(S[i].mem_pool_identifier),&req,&resp);
        for (int j = 0; j < req.arguments[0]; j++ ){
            printf("S[%d] element %d = %lu \n",i,j,0xFF&(resp.read_data[j/2]>>(32*(j&1))));
        }
        printf("\n");
    }

    for (int i = num_iters; i < 2*num_iters; i++){
         // There should be another loop for tensor.dimension[2] as all the operations are on 2D.
        dilateTensor(&T[i], &K, stride,  &S[i]);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);
        convTensors(&S[num_iters+i],&K,&T[i+1],stride_deconv,pad_deconv );
        // unaryOperateOnTensor_inplace(S[i], 5);
    }
    if (_err_)
        fprintf(stderr,"Something's wrong. Please check.");
    
    return 0;
}