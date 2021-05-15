#include <stdlib.h> 
#include <stdio.h>
#include <stdint.h>
#include "mempool.h"
#include "tensor.h"
#include <math.h>

Tensor Basic_tensor;
Tensor Scaled_tensor;
Tensor Padded_tensor;
MemPool mp_src;
MemPool mp_res;
MemPool mp_pad;
MemPoolRequest req1;
MemPoolResponse resp1;

void createTensor (uint32_t ndim, uint32_t* dims, TensorDataType dt, uint16_t mempool, Tensor* result)
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
    uint32_t constant_size = 512;
    uint32_t b=0,k;
    npages = ceil(s/512);
    printf("Number of pages required : %d\n",npages);
    rem = (uint32_t) s % constant_size;
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

int main() {
    // Have to define the scale factor and number of dimensions as well as the dimensions
	uint32_t scale_factor = 2;
    uint32_t ndim = 3;
    uint32_t dims[3] = {2,2,3};

    uint32_t scaled_dims[ndim];
    for (int i = 0; i < ndim; i++)
    {
        scaled_dims[i] = dims[i] + 2*scale_factor;
    }
    
    createTensor(ndim, dims, u16 , mp_src.mem_pool_index, &Basic_tensor);
    createTensor(ndim, scaled_dims, u16 , mp_res.mem_pool_index, &Scaled_tensor);
    createTensor(ndim, scaled_dims, u16 , mp_pad.mem_pool_index, &Padded_tensor);
	zeropadtensor(&Basic_tensor,scale_factor,0,&Padded_tensor);
	return 0;
}
