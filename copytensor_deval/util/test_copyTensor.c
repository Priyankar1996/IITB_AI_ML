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
    result->descriptor.number_of_dimensions = ndim;
    printf("Number of dim : %d\n",result->descriptor.number_of_dimensions);
    for(r=0;r<ndim;r++)
    {
        result->descriptor.dimensions[r] = *dims;
        printf("Dim %d is %d\n",r,result->descriptor.dimensions[r]);
        s = s * (*dims);
        dims = dims + 1;
    }
    result->descriptor.data_type = dt;
    result->mem_pool_identifier = mempool;
    printf("size of created tensor src %f\n",s);

    uint32_t p = 0;
    uint32_t npages,rem;
    uint32_t consta = 512.0;
    uint32_t b=0,k;
    npages = ceil(s/512);
    printf("Number of pages required : %d\n",npages);
    rem = (uint32_t) s % consta;
    for(p=0;p<npages;p++)
    {
        if(p != npages - 1)
        {
            req1.request_type = ALLOCATE;
            req1.request_tag = p;
            req1.arguments[0] = 1;

            memPoolAccess(&mp_src, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not allocate memory.\n");
            }

            for(k=0; k < MEMPOOL_PAGE_SIZE; k++)
            {
                req1.write_data[k] = b+1;
                b++;
            }

            req1.request_type = WRITE;
            req1.request_tag  = p + npages;
            req1.arguments[0] = MEMPOOL_PAGE_SIZE;
            req1.arguments[1] = resp1.allocated_base_address;

            memPoolAccess(&mp_src, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not write into memory.\n");
            }

            fprintf(stderr,"\nInfo: wrote into page %d.\n", p);
        }
        if(p == npages - 1)
        {
            req1.request_type = ALLOCATE;
            req1.request_tag = p;
            req1.arguments[0] = 1;

            memPoolAccess(&mp_src, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not allocate memory.\n");
            }

            for(k=0; k < rem; k++)
            {
                req1.write_data[k] = b+1;
                b++;
            }

            req1.request_type = WRITE;
            req1.request_tag  = p + npages;
            req1.arguments[0] = MEMPOOL_PAGE_SIZE;
            req1.arguments[1] = resp1.allocated_base_address;

            memPoolAccess(&mp_src, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not write into memory.\n");
            }

            fprintf(stderr,"\nInfo: wrote into page %d.\n", p);
        }
    }
    result->mem_pool_buffer_pointer = mp_src.mem_pool_buffer;
}

int main()
{
    int l = 0;
    uint32_t ndim = 7;
    uint32_t dims[7] = {1,2,3,4,5,6,2};
    initMemPool(&mp_src, 10, 10);
    createTensor(ndim, dims, u16, mp_src.mem_pool_index, &T1);
    printf("----------SOURCE TENSOR CREATED----------\n");

    //Init pool with index 5 and number of pages 10.
    initMemPool(&mp_dest, 5, 10);

    //pointer to the chain of buffers in mp1 which contains copy of src.
    T2.mem_pool_buffer_pointer = mp_dest.mem_pool_buffer;

    copyTensor(&T1, &T2, &mp_dest);

    printf("Destination tensor buffer pointer:%d\t",T2.mem_pool_buffer_pointer);
    printf("Source tensor buffer pointer:%d\n",T1.mem_pool_buffer_pointer);

    printf("Destination tensor mem pool index:%d\t",T2.mem_pool_identifier);
    printf("Source tensor mem pool index:%d\n",T1.mem_pool_identifier);

    uint64_t *ptr1 = T1.mem_pool_buffer_pointer;
    uint64_t *ptr2 = T2.mem_pool_buffer_pointer;

    for(l=0;l<1440;l++)
    {
        printf("Source tensor:%d \t",*ptr1);
        printf("Destination tensor:%d",*ptr2);
        printf("\n");
        ptr1 = ptr1 + 1;
        ptr2 = ptr2 + 1;
    }
    return(1);
}
