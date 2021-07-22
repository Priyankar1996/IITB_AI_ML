#include "../include/sharedFunctions.h"


uint32_t getSizeOfTensor(Tensor *T)
{
	uint32_t size = 1;
	for (int i = 0; i < T->descriptor.number_of_dimensions; i++){
		size *= T->descriptor.dimensions[i];
	}
	return size;
}

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
		memPoolAccess(T->mem_pool_identifier,req,resp);
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
		memPoolAccess(T->mem_pool_identifier,req,resp);
		if (resp.status == NOT_OK)
		{
			fprintf(stderr,"Mempool write error. Called from write()");
			exit(-1);
		}
		temp_var -= num_iterations;
	}
}

uint64_t getBitMask(uint8_t dsize , uint8_t position)
{
	assert(position < 8/dsize);
	switch (dsize)
	{
	case 8:
		// 64b, position independent
		return (uint64_t)(0xFFFFFFFFFFFFFFFF);
		break;
	case 4:
		// 32b, can occupy first 32 bits (position = 1) or last 32 bits (position = 0) in a 64b word 
		return ((uint64_t)(0xFFFFFFFF) << 32*(position));
		break;
	case 2:
		// 16b, positions (3 2 1 0) in a 64b word
		return ((uint64_t)(0xFFFF) << 16*(position));
		break;
	case 1:
		// 8b, positions (7 6 5 4 3 2 1 0) in a 64b word
		return ((uint64_t)(0xFF) << 8*(position));
		break;
	default:
		break;
	}
	return 0;
}
