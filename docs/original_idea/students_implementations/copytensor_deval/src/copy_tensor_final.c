#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "mempool.h"
#include "tensor.h"
#include <math.h>

float sizeofsrc(Tensor *src)
{
    uint64_t i = 0;
    float size_src = 1.0;
    uint32_t ndim_src = src->descriptor.number_of_dimensions;
    uint32_t *dims_src;
    dims_src = src->descriptor.dimensions;
    for(i=0;i<ndim_src;i++)
    {
        printf("%d\n",*dims_src);
        size_src = size_src * (*dims_src);
        dims_src = dims_src + 1;
    }
    printf("%f\n",size_src);
    return size_src;
}

//copy src tensor to dest in mempool mp
void copyTensor(Tensor *src, Tensor *dest, MemPool *mp)
{
    MemPoolRequest req;         //req resp pair
    MemPoolResponse resp;

    //tensor descriptors
    dest->mem_pool_identifier = mp->mem_pool_index;
    dest->descriptor.data_type = src->descriptor.data_type;
    dest->descriptor.number_of_dimensions = src->descriptor.number_of_dimensions;
    dest->descriptor.row_major_form = src->descriptor.row_major_form;

    float size_of_src;
    size_of_src = sizeofsrc(src);

    //allocate pages and fill.
    uint32_t npages,rem;
    uint32_t consta = 512.0;
    npages = ceil(size_of_src/512);
    printf("\nNumber of pages required : %d",npages);
    rem = (uint32_t) size_of_src % consta;
    int p = 0;
    uint64_t *src_base;
    src_base = src->mem_pool_buffer_pointer;
    for(p=0;p<npages;p++)
    {
        if(p != npages - 1)
        {
            req.request_type = ALLOCATE;
            req.request_tag = p;
            req.arguments[0] = 1;

            memPoolAccess(mp, &req, &resp);
            if(resp.status !=  OK)
            {
                fprintf(stderr,"Error: could not allocate memory.\n");
            }

            uint32_t k;
            for(k=0; k < MEMPOOL_PAGE_SIZE; k++)
            {
                req.write_data[k] = *src_base;
                src_base = src_base + 1;
            }

            req.request_type = WRITE;
            req.request_tag  = p + npages;
            req.arguments[0] = MEMPOOL_PAGE_SIZE;
            req.arguments[1] = resp.allocated_base_address;

            memPoolAccess(mp, &req, &resp);
            if(resp.status !=  OK)
            {
                fprintf(stderr,"Error: could not write into memory.\n");
            }

            fprintf(stderr,"\nInfo: wrote into page %d.\n", p);
        }
        if(p == npages - 1)
        {
            req.request_type = ALLOCATE;
            req.request_tag = p;
            req.arguments[0] = 1;

            memPoolAccess(mp, &req, &resp);
            if(resp.status !=  OK)
            {
                fprintf(stderr,"Error: could not allocate memory.\n");
            }

            uint32_t k;
            for(k=0; k < rem; k++)
            {
                req.write_data[k] = *src_base;
                src_base = src_base + 1;
            }

            req.request_type = WRITE;
            req.request_tag  = p + npages;
            req.arguments[0] = MEMPOOL_PAGE_SIZE;
            req.arguments[1] = resp.allocated_base_address;

            memPoolAccess(mp, &req, &resp);
            if(resp.status !=  OK)
            {
                fprintf(stderr,"Error: could not write into memory.\n");
            }

            fprintf(stderr,"\nInfo: wrote into page %d.\n", p);
        }
    }

}
