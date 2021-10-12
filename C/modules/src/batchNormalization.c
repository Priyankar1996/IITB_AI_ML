#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "mempool.h"
#include "tensor.h"

void fillArrayFromTensor(Tensor *T,  int size, void *array)
{
	assert(size > 0);
	MemPoolRequest req;
	MemPoolResponse resp;
	TensorDescriptor desc = T->descriptor;
	uint8_t dsize = sizeofTensorDataInBytes(desc.data_type);
	req.request_type = READ;
	req.arguments[2] = 1;
	int32_t temp_var = size;
	while (temp_var > 0)
	{
		req.arguments[0] = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS : 1 - (-temp_var*dsize/8));
		req.arguments[1] = T->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (size - temp_var)*dsize/8;
		memPoolAccess((MemPool*)T->mem_pool_identifier,&req,&resp);
		if (resp.status == NOT_OK)
		{
			fprintf(stderr,"Mempool read error. Called from read()");
			exit(-1);
		}
		uint32_t num_iterations = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS*8/dsize : temp_var);
		for (int i = 0; i < num_iterations; i++)
		{
			copyTensorEntry(&desc,array,i+size-temp_var,resp.read_data,i);
		}
		temp_var -= num_iterations;
	}
}

void fillTensorFromArray(Tensor *T, int size, void *array)
{
	assert(size > 0);
	MemPoolRequest req;
	MemPoolResponse resp;
	TensorDescriptor desc = T->descriptor;
	uint8_t dsize = sizeofTensorDataInBytes(desc.data_type);
	req.request_type = WRITE;
	req.arguments[2] = 1;
	int32_t temp_var = size;
	req.arguments[1] = T->mem_pool_buffer_pointer;
	while (temp_var > 0)
	{
		req.arguments[0] = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS : 1 - (-temp_var*dsize/8));
		req.arguments[1] = T->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (size - temp_var)*dsize/8;
		uint32_t num_iterations = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS*8/dsize : temp_var);

		for (int i = 0; i < num_iterations; i++)
		{
			copyTensorEntry(&desc,req.write_data,i,array,i+size-temp_var);
		}
		memPoolAccess((MemPool*)T->mem_pool_identifier,&req,&resp);
		if (resp.status == NOT_OK)
		{
			fprintf(stderr,"Mempool write error. Called from write()");
			exit(-1);
		}
		temp_var -= num_iterations;
	}
}

void batchNormalization(Tensor *input, Tensor *beta, Tensor *gamma, 
						Tensor *moving_mean, Tensor *moving_variance, double epsilon)
{
	// Write beta, gamma, moving_mean and moving_variance values in array.
    TensorDescriptor td = beta->descriptor;
    uint32_t num_elems = numberOfElementsInTensor(beta);
    uint32_t num_elems_input = numberOfElementsInTensor(input);
	uint32_t x = input->descriptor.dimensions[input->descriptor.number_of_dimensions-1];
	assert(num_elems==x);
    switch(td.data_type)
    {
        case u8:
        case u16:
        case u32:
        case u64:
        case i8:
        case i16:
        case i32:
        case i64:
        case float8:{break;}
        case float16:{break;}
        case float32:{
			float beta_arr[x], gamma_arr[x], mm_arr[x], mv_arr[x], input_arr[num_elems_input], resultant[num_elems_input];
			fillArrayFromTensor(beta, num_elems, beta_arr);
			fillArrayFromTensor(gamma, num_elems, gamma_arr);
			fillArrayFromTensor(moving_mean, num_elems, mm_arr);
			fillArrayFromTensor(moving_variance,num_elems,mv_arr);
			fillArrayFromTensor(input,num_elems_input,input_arr);
			for(int i=0;i<num_elems_input;i++)
			{
				int count = i%x;
				resultant[i] = gamma_arr[count]*(input_arr[i]-mm_arr[count])/(mv_arr[count] + epsilon) + beta_arr[count];
			}
			fillTensorFromArray(input,num_elems_input,resultant);
			break;}
        case float64:{break;}
    }

}

