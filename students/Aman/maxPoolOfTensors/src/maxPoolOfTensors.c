#include "../include/maxPoolOfTensors.h"

void sort(int *array,int *num)
// Sort the array in ascending order
{
	assert(*num > 0);
	for (uint8_t i = 0; i < *num; i++)
	{
		for (uint8_t j = i+1; j < *num; j++)
		{
			if (array[j] == array[i])
			// if equal, then remove one entry
			{
				for (uint8_t k = j; k < *num-1; k++)
				{
					array[k] = array[k+1];
				}
				*num = *num - 1;
				continue;
			}
			if (array[j] < array[i])
			// if smaller number appears later, swap
			{
				array[j] += array[i];
				array[i] = array[j] - array[i];
				array[j] = array[j] - array[i];
			}
		}	
	}	
}

uint32_t getSizeOfTensor(Tensor *T)
// Compute size of tensor
{
	uint32_t size = 1;
	for (int i = 0; i < T->descriptor.number_of_dimensions; i++){
		size *= T->descriptor.dimensions[i];
	}
	return size;
}

void readTensor(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array)
// Read data of tensor T into array
{
	assert(size > 0);
	TensorDescriptor desc = T->descriptor;
	uint8_t dsize = sizeofTensorDataInBytes(desc.data_type);
	req->request_type = READ;
	req->arguments[2] = 1;
	int32_t temp_var = size;
	while (temp_var > 0)
	{
		req->arguments[0] = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS : 1 - (-temp_var*dsize/8));
		req->arguments[1] = T->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (size - temp_var)*dsize/8;
		memPoolAccess(T->mem_pool_identifier,req,resp);
		if (resp->status == NOT_OK)
		{
			fprintf(stderr,"Mempool read error. Called from read()");
			exit(-1);
		}
		uint32_t num_iterations = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS*8/dsize : temp_var);
		for (int i = 0; i < num_iterations; i++)
		{
			copyTensorEntry(&desc,array,i+size-temp_var,resp->read_data,i);
		}
		temp_var -= num_iterations;
	}
}

void writeTensor(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array)
// Write array data as the data of tensor T 
{
	assert(size > 0);
	TensorDescriptor desc = T->descriptor;
	uint8_t dsize = sizeofTensorDataInBytes(desc.data_type);
	req->request_type = WRITE;
	req->arguments[2] = 1;
	int32_t temp_var = size;
	req->arguments[1] = T->mem_pool_buffer_pointer;
	while (temp_var > 0)
	{
		req->arguments[0] = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS : 1 - (-temp_var*dsize/8));
		req->arguments[1] = T->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (size - temp_var)*dsize/8;
		uint32_t num_iterations = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS*8/dsize : temp_var);

		for (int i = 0; i < num_iterations; i++)
		{
			copyTensorEntry(&desc,req->write_data,i,array,i+size-temp_var);
		}
		memPoolAccess(T->mem_pool_identifier,req,resp);
		if (resp->status == NOT_OK)
		{
			fprintf(stderr,"Mempool write error. Called from write()");
			exit(-1);
		}
		temp_var -= num_iterations;
	}
}

uint64_t getBitMask(uint8_t dsize , uint8_t position)
// Compute bitmask givne the datatype and its position in the word
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

void maxWithSpacing(int num_max, int start, void* matrix,  TensorDataType dt, void * temp)
// Core operation of maxPool
// Computes the max of num_max quantities in matrix starting at indice start based on the datatype
// Returns the data in at location temp
{	
	assert(num_max > 0);

	switch (dt)
	// Select comparator based on datatype
		{
		case i8:
		*((int8_t*)temp ) = *((int8_t*)(matrix) +(start)*8);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((int8_t*)(matrix) +(start+i)*8)> *((int8_t*)temp )) *((int8_t*)temp ) = *((int8_t*)(matrix) +(start+i)*8);
		}
		break;
		case float8:
		case u8:
		*((uint8_t*)temp ) = *((uint8_t*)(matrix) +(start)*8);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((uint8_t*)(matrix) +(start+i)*8)> *((uint8_t*)temp )) *((uint8_t*)temp ) = *((uint8_t*)(matrix) +(start+i)*8);
		}
		break;
		case i16:
		*((int16_t*)temp ) = *((int16_t*)(matrix) +(start)*4);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((int16_t*)(matrix) +(start+i)*4)> *((int16_t*)temp )) *((int16_t*)temp ) = *((int16_t*)(matrix) +(start+i)*4);
		}
		break;
		case float16:
		case u16:
		*((uint16_t*)temp ) = *((uint16_t*)(matrix) +(start)*4);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((uint16_t*)(matrix) +(start+i)*4)> *((uint16_t*)temp )) *((uint16_t*)temp ) = *((uint16_t*)(matrix) +(start+i)*4);
		}
		break;
		case i32:
		*((int32_t*)temp ) = *((int32_t*)(matrix) +(start)*2);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((int32_t*)(matrix) +(start+i)*2)> *((int32_t*)temp )) *((int32_t*)temp ) = *((int32_t*)(matrix) +(start+i)*2);
		}
		break;
		case float32:
		*((float*)temp ) = *((float*)(matrix) +(start)*2);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((float*)(matrix) +(start+i)*2)> *((float*)temp )) *((float*)temp ) = *((float*)(matrix) +(start+i)*2);
		}
		break;
		case u32:
		*((uint32_t*)temp ) = *((uint32_t*)(matrix) +(start)*2);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((uint32_t*)(matrix) +(start+i)*2)> *((uint32_t*)temp )) *((uint32_t*)temp ) = *((uint32_t*)(matrix) +(start+i)*2);
		}
		break;
		case i64:
		*((int64_t*)temp) = *((int64_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((int64_t*)(matrix) +(start+i)*1)> *((int64_t*)temp)) *((int64_t*)temp) = *((int64_t*)(matrix) +(start+i)*1);
		}
		break;
		case float64:
		*((double*)temp) = *((double*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((double*)(matrix) +(start+i)*1)> *((double*)temp)) *((double*)temp) = *((double*)(matrix) +(start+i)*1);
		}
		break;
		case u64:
		*((uint64_t*)temp) = *((uint64_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			// Update if larger
			if (*((uint64_t*)(matrix) +(start+i)*1)> *((uint64_t*)temp)) *((uint64_t*)temp) = *((uint64_t*)(matrix) +(start+i)*1);
		}
		break;
		default:
			break;
		}
	return;
}

void maxpool1D(Tensor *src, uint32_t size, uint8_t x, int l, int s, int cs, Tensor *dst, int mode, MemPoolRequest *req, MemPoolResponse *resp)
// Pools one dimension at a time, parameters size , x , l ,s ,cs , mode
// Input tensor src, output dst
// Takes a MemPoolRequest and MemPoolResponse as inputs as well
{
	// Compute essential constants
	uint8_t dt = src->descriptor.data_type;
	uint8_t dsize = sizeofTensorDataInBytes(dt);
	// dim_to_pool refers to the dimension along which we are currently pooling
	// Number of pooling units = size of tensor upto dim_to_pool (dim_to_pool not included)
	int num_units = size/(x*cs);
	// num_1D_steps = floor/ceil (1 + ((x-l)/s)), i.e. the size of output along dim_to_pool 
	int num_1D_steps = ((mode == floor) ? 1 + (x-l)/s : 1 - (l-x)/s);
	if (l>x)
	{
		fprintf(stderr,"Warning: Length exceeds dimension.\n");
		num_1D_steps = mode;
	}

	// Define temporary memory variables
	// Future goal: Improve size by packing data in temp_old
	uint64_t temp_new , temp_old[l], temp_buffer, bitmask;
	void *temp_var1;
	temp_var1 = temp_old;

	// Stride = 1; number of elements to fetch = 1
	req->arguments[0] = 1;
	req->arguments[2] = 1;

	uint32_t i=0,j=0,k=0;
	for (i = 0;i<num_units;i++)
	{	
		for (k = 0;k < cs;k++)
		{
			for (j = 0; j < num_1D_steps - mode; j++)
			{	
				// Read the line from src
				// Optimization opportunity: Use fetched values from previous pool (if overlapping values)
				req->request_type = READ;
				for (uint16_t var = 0; var < l; var++)
				{
					req->arguments[1] = src->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*x*cs+k+(j*s+var)*cs)*dsize/8;
					memPoolAccess(src->mem_pool_identifier,req,resp);
					if (resp->status == NOT_OK)
					{
						fprintf(stderr,"Mempool read error. Called from maxpool1D()");
						exit(-1);
					}
					// printf("%lu %lu \n",src->mem_pool_identifier->mem_pool_buffer[0] & 0xF, src->mem_pool_identifier->mem_pool_buffer[0] / 0xFFFFFFFF);
					temp_old[var] = (resp->read_data[0] >> (8*dsize*(((i*x*cs+k+(j*s+var)*cs)-(8/dsize)*((i*x*cs+k+(j*s+var)*cs)*dsize/8)))));
					bitmask = getBitMask(dsize,0);
					temp_old[var] = temp_old[var]&bitmask;
					// printf("Old %ld\n",temp_old[var]);
				}

				// Perform max operation
				maxWithSpacing(l, 0,temp_var1, dt,&temp_new);
				
				// Read from dst
				req->request_type = READ;
				req->arguments[1] = dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*num_1D_steps*cs + k+j*cs)*dsize/8;
				memPoolAccess(dst->mem_pool_identifier,req,resp);
				if (resp->status == NOT_OK)
				{
					fprintf(stderr,"Mempool read error. Called from maxpool1D()");
					exit(-1);
				}
				
				// Compute write data
				bitmask = ~getBitMask(dsize,i*num_1D_steps*cs + k + j*cs - (8/dsize)*((i*num_1D_steps*cs + k + j*cs)*dsize/8));
				temp_buffer = (resp->read_data[0] & bitmask) + ((temp_new & getBitMask(dsize,0)) << (8*dsize*(((i*num_1D_steps*cs+k+j*cs)-(8/dsize)*((i*num_1D_steps*cs+k+j*cs)*dsize/8)))));
				// printf("From m1D: %ld %ld\n", temp_new , temp_buffer);
				
				// Write back to dst
				req->request_type = WRITE;
				req->arguments[1] = dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*num_1D_steps*cs + k+j*cs)*dsize/8;
				req->write_data[0] = temp_buffer;
				memPoolAccess(dst->mem_pool_identifier,req,resp);
				if (resp->status == NOT_OK)
				{
					fprintf(stderr,"Mempool write error. Called from maxpool1D()");
					exit(-1);
				}
				// printf("%d %ld\n",i*num_1D_steps*cs + k+j*cs,dst->mem_pool_identifier->mem_pool_buffer[dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*num_1D_steps*cs + k+j*cs)]);
			}
			if (mode == ceil)
			{
				// Read the line from src
				// Optimization opportunity: Use fetched values from previous pool (if overlapping values)
				req->request_type = READ;
				for (uint16_t var = 0; var < l; var++)
				{
					req->arguments[1] = src->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*x*cs+k+(j*s+var)*cs)*dsize/8;
					memPoolAccess(src->mem_pool_identifier,req,resp);
					if (resp->status == NOT_OK)
					{
						fprintf(stderr,"Mempool read error. Called from maxpool1D()");
						exit(-1);
					}
					// printf("%lu %lu \n",src->mem_pool_identifier->mem_pool_buffer[0] & 0xF, src->mem_pool_identifier->mem_pool_buffer[0] / 0xFFFFFFFF);
					temp_old[var] = (resp->read_data[0] >> (8*dsize*(((i*x*cs+k+(j*s+var)*cs)-(8/dsize)*((i*x*cs+k+(j*s+var)*cs)*dsize/8)))));
					bitmask = getBitMask(dsize,0);
					temp_old[var] = temp_old[var]&bitmask;
					// printf("Old %ld\n",temp_old[var]);
				}
				// Perform max operation
				maxWithSpacing(x - (num_1D_steps-1)*s, 0, temp_var1, dt,&temp_new);
				
				// Read from dst
				req->request_type = READ;
				req->arguments[1] = dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*num_1D_steps*cs + k+j*cs)*dsize/8;
				memPoolAccess(dst->mem_pool_identifier,req,resp);
				if (resp->status == NOT_OK)
					{
						fprintf(stderr,"Mempool read error. Called from maxpool1D()");
						exit(-1);
					}
				
				// Compute write data
				bitmask = ~getBitMask(dsize,i*num_1D_steps*cs + k + j*cs - (8/dsize)*((i*num_1D_steps*cs + k + j*cs)*dsize/8));
				temp_buffer = (resp->read_data[0] & bitmask) + ((temp_new & getBitMask(dsize,0))<< (8*dsize*(((i*num_1D_steps*cs+k+j*cs)-(8/dsize)*((i*num_1D_steps*cs+k+j*cs)*dsize/8)))));
				
				// Write back to dst
				req->request_type = WRITE;
				req->arguments[1] = dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*num_1D_steps*cs + k+j*cs)*dsize/8;
				req->write_data[0] = temp_buffer;
				memPoolAccess(dst->mem_pool_identifier,req,resp);
				if (resp->status == NOT_OK)
				{
					fprintf(stderr,"Mempool write error. Called from maxpool1D()");
					exit(-1);
				}
			}
		}
	}
}

void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool, int * dims_to_pool, int mode)
{
	// Sort the dimensions to pool in ascending order
	sort(dims_to_pool,&num_dims_to_pool);

	// Assure that the inputs lie in a meaningful range
	assert(num_dims_to_pool > 0);
	assert(num_dims_to_pool <= src->descriptor.number_of_dimensions);
	assert(dims_to_pool[0]>=0);
	assert(dims_to_pool[num_dims_to_pool-1]<=src->descriptor.number_of_dimensions);
	assert(l>0);
	assert(stride>0);

	// New mempool request and response
	// Will work on improving this
	MemPoolRequest req;
	MemPoolResponse resp;
	
	// Define and initialize variables
	uint8_t row_major = src->descriptor.row_major_form;
	uint64_t size = getSizeOfTensor(src);
	uint8_t x;
	uint8_t dsize = sizeofTensorDataInBytes(src->descriptor.data_type);
	int32_t cs = 1;
	int8_t i = 0;

	//Update destination descriptor	
	dst->descriptor.row_major_form = row_major;
	dst->descriptor.data_type = src->descriptor.data_type;
	dst->descriptor.number_of_dimensions = src->descriptor.number_of_dimensions;
	
	// Decide direction of movement based on row-major/column-major form
	int iStart,iEnd,iInc,jStart,jEnd,jInc;
	if (row_major == 1)
	{
		iStart = num_dims_to_pool - 1;
		iInc = -1;
		iEnd = 0;
		jStart = src->descriptor.number_of_dimensions - 1;
		jEnd = -1;
		jInc = -1;
	}
	else
	{
		iStart = 0;
		iInc = 1;
		iEnd = num_dims_to_pool - 1;
		jEnd = src->descriptor.number_of_dimensions;
		jStart = 0;
		jInc = 1;
	}
	i = iStart;

	// maxPool1D : No need of intermediate tensors for 1D op
	if (num_dims_to_pool == 1)
	{
		for (int j = jStart; j != jEnd;j += jInc)
		// Loop through all dimensions
		{
			x = src->descriptor.dimensions[j];
			if (j == dims_to_pool[0])
			// If dimension equals the dimension to be pooled
			{	
				// Perform maxPool
				maxpool1D(src, size, x, l, stride, cs, dst, mode, &req, &resp);

				// Update parameters
				int factor = (x<l) ? mode : ((mode == floor) ? 1+(x-l)/stride : 1 - (l-x)/stride);
				size = size*factor/x;
				dst->descriptor.dimensions[j] = factor;
				cs *= factor;
			}
			else
			{
				// Update parameters
				dst->descriptor.dimensions[j] = x;
				cs *= x;
			}
		}
		return;
	}

	/* //Future optimization
	//Do the most common case (2D pool with continuous dims and l = stride)
	//efficiently
	if (num_dims_to_pool == 2)
	{
		return;
	}
	*/

	// To be later replaced with
	// Tensor temp_Tensor = createTensor(...);
	Tensor temp_Tensor;
	temp_Tensor.descriptor = src->descriptor;
	temp_Tensor.mem_pool_identifier = src->mem_pool_identifier;
	temp_Tensor.mem_pool_buffer_pointer = 2*(1 + size*dsize/(MEMPOOL_PAGE_SIZE*8));


	// Generalised maxPool (num_dims_to_pool > 1)
	for (int j = jStart; j != jEnd;j += jInc)
	// Loop through all dimensions
	{
		x = src->descriptor.dimensions[j];
		if ((j == dims_to_pool[i]) && (i != (iEnd+iInc)))
		// Found a dimension to pool
		{
			
			// First dimension : From src to temp_Tensor
			if (i == iStart)
			{
				maxpool1D(src, size, x, l, stride, cs, &temp_Tensor, mode, &req, &resp);
			}

			// Last dimension : From temp_Tensor to dst
			else if	(i == iEnd)
			{
				maxpool1D(&temp_Tensor, size, x, l, stride, cs, dst, mode, &req, &resp);
			}

			// Intermediate dimensions : From temp_Tensor to temp_Tensor
			else 
			{
				maxpool1D(&temp_Tensor, size, x, l, stride, cs, &temp_Tensor, mode, &req, &resp);
			}
			
			// Update parameters
			int factor = (x<l) ? mode : ((mode == floor) ? 1+(x-l)/stride : 1 - (l-x)/stride);
			size = size*factor/x;
			dst->descriptor.dimensions[j] = factor;
			cs *= factor;
			i += iInc;
		}
		else
		{
			// Update parameters
			dst->descriptor.dimensions[j] = x;
			cs *= x;
		}
	}
	return;
}
