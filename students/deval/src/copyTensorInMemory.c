#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "mempool.h"
#include "tensor.h"
#include <math.h>

//function to calculate the size of tensor required
float sizeofsrc(Tensor *src)
{
    uint64_t i = 0;
    float size_src = 1.0;
    uint32_t ndim_src = src->descriptor.number_of_dimensions;
    uint32_t *dims_src;
    //dims_src = src->descriptor.dimensions;
    for(i=0;i<ndim_src;i++)
    {
        //printf("%d\n",*dims_src);
        size_src = size_src * (src->descriptor.dimensions[i]);
        //dims_src = dims_src + 1;
    }
    printf("Number of data blocks in src : %f\n",size_src);
    return size_src;
}

//copy src tensor to dest in mempool specified in tensor descriptor
void copyTensorInMemory(Tensor *src, Tensor *dest, MemPool *mp1, MemPool *mp2)
{
    MemPoolRequest req;
    req.request_tag = 0;
    MemPoolResponse resp;

    //tensor descriptors
    dest->descriptor.data_type = src->descriptor.data_type;
    dest->descriptor.number_of_dimensions = src->descriptor.number_of_dimensions;
    dest->descriptor.row_major_form = src->descriptor.row_major_form;
    int m;
    for(m=0;m<64;m++)
    {
        dest->descriptor.dimensions[m] = src->descriptor.dimensions[m];
    }

    //number of blocks.
    float size_of_src;
    size_of_src = sizeofsrc(src);

    //allocate pages for dest tensor.
    uint32_t npages,rem;
    uint32_t consta = 512.0;
    npages = ceil(size_of_src/512);
    printf("\nNumber of pages required for destination tensor : %d\n",npages);

    //blocks required for last page.
    rem = (uint32_t) size_of_src % consta;

    //allocate required pages for dest tensor.
    req.request_type = ALLOCATE;
    req.request_tag = req.request_tag + 1;
    req.arguments[0] = npages;

    //generate allocate request.
    memPoolAccess(mp2, &req, &resp);
    if(resp.status !=  OK)
    {
        fprintf(stderr,"Error: could not allocate memory for destination tensor.\n");
    }
    fprintf(stderr,"allocated %d pages for destination tensor.\n", npages);

    //store the base address of dest tensor.
    uint32_t dest_base = 0;
    dest_base = resp.allocated_base_address;
    dest->mem_pool_buffer_pointer = resp.allocated_base_address;
    //fprintf(stderr,"Destination mem pool buffer pointer %d\n",dest->mem_pool_buffer_pointer);

    //generate read req for one word at a time from src.
    //store it into temp_buffer.
    //generate write req for dest tensor.
    uint64_t src_base = src->mem_pool_buffer_pointer;
    uint64_t temp_buffer;
    uint32_t k;
    for(k=0; k < (npages-1)*MEMPOOL_PAGE_SIZE + rem; k++)
    {
        //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
    }
}
