#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "mempool.h"
#include "tensor.h"
#include <math.h>

Tensor T1;
Tensor T2;
MemPool mp_src;
MemPool mp_dest;
MemPoolRequest req1;
MemPoolResponse resp1;

//This will be replaced by create tensor function.
void createTensor (uint32_t ndim, uint32_t *dims, TensorDataType dt, uint32_t mempool, Tensor *result)
{
    int r;
    float s=1;

    //fill the dimensions
    result->descriptor.number_of_dimensions = ndim;
    printf("Number of dim : %d\n",result->descriptor.number_of_dimensions);
    for(r=0;r<ndim;r++)
    {
        result->descriptor.dimensions[r] = *dims;
        printf("Dim %d is %d\t",r,result->descriptor.dimensions[r]);
        s = s * (*dims);
        dims = dims + 1;
    }
    result->descriptor.data_type = dt;
    result->mem_pool_identifier = mempool;
    printf("size of created tensor src %f\n",s);

    //allocate and fill pages
    uint32_t npages,rem;
    uint32_t consta = 512.0;
    uint32_t b=0,k;
    npages = ceil(s/512);
    printf("Number of pages required : %d\n",npages);
    rem = (uint32_t) s % consta;

    req1.request_type = ALLOCATE;
    req1.request_tag = 1;
    req1.arguments[0] = npages;

    memPoolAccess(&mp_src, &req1, &resp1);
    if(resp1.status !=  OK)
    {
        fprintf(stderr,"Error: could not allocate memory.\n");
    }

    result->mem_pool_buffer_pointer = resp1.allocated_base_address;

    for(k=0; k < (npages-1)*MEMPOOL_PAGE_SIZE + rem; k++)
    {
        req1.write_data[k] = b+1;
        //printf("write data i is %d\n",req1.write_data[k]);
        b++;
    }

    req1.request_type = WRITE;
    req1.request_tag  = 2;
    req1.arguments[0] = (npages - 1)*MEMPOOL_PAGE_SIZE + rem;
    req1.arguments[1] = resp1.allocated_base_address;

    memPoolAccess(&mp_src, &req1, &resp1);
    if(resp1.status !=  OK)
    {
        fprintf(stderr,"Error: could not write into memory.\n");
    }

    fprintf(stderr,"\nInfo: wrote into pages.\n");
}

int main()
{
    //Helper variable
    int l = 0;
    int mp_src_idx = 10;
    int mp_dest_idx = 5;

    //Number of dim
    uint32_t ndim = 6;

    //Shape across dimensions
    uint32_t dims[6] = {1,2,3,4,5,6};

    //Init mem pool with index 10 and number of pages 10.
    initMemPool(&mp_src, 10, 10);
    //Init mem pool with index 5 and number of pages 10.
    initMemPool(&mp_dest, 5, 10);
    T2.mem_pool_identifier = 5;
    //T2.mem_pool_buffer_pointer = 10;

    //Helper function to init tensor in a mempool
    //initTensor();

    //This function will be replaced by createTensor by Priyankar.
    createTensorInMemory(ndim, dims, u16, mp_src.mem_pool_index, &T1);
    printf("----------SOURCE TENSOR CREATED----------\n");

    //copy
    copyTensor(&T1, &T2, &mp_src, &mp_dest);

    //equality check
    printf("Destination tensor buffer pointer:%d\t",T2.mem_pool_buffer_pointer);
    printf("Source tensor buffer pointer:%d\n",T1.mem_pool_buffer_pointer);

    printf("Destination tensor mem pool index:%d\t",T2.mem_pool_identifier);
    printf("Source tensor mem pool index:%d\n",T1.mem_pool_identifier);
}
