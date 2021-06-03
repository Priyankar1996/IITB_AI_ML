#include "../maxpoolTensors.h"

void sort(int *array,int num)
{
	for (int i = 0; i < num; i++)
	{
		for (int j = i+1; j < num; j++)
		{
			if (array[j] < array[i])
			{
				array[j] += array[i];
				array[i] = array[j] - array[i];
				array[j] = array[j] - array[i];
			}
		}	
	}	
}

uint32_t getSizeOfTensor(Tensor *T)
{
	uint32_t size = 1;
	for (int i = 0; i < T->descriptor.number_of_dimensions;i++){
		size *= T->descriptor.dimensions[i];
	}
	return size;
}

void readTensor(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array)
{
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
		uint32_t num_iterations = ((temp_var*dsize/8 >= MAX_SIZE_OF_REQUEST_IN_WORDS) ? MAX_SIZE_OF_REQUEST_IN_WORDS*8/dsize : temp_var);
		for (int i = 0; i < num_iterations; i++)
		{
			copyTensorEntry(&desc,array,i+size-temp_var,resp->read_data,i);
		}
		temp_var -= num_iterations;
	}
}

void writeTensor(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array)
{
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
		temp_var -= num_iterations;
	}
}

void maxWithSpacing(int num_max, void* matrix, int start,int spacing, TensorDataType dt, void * temp)
{	
	switch (dt)
		{
		case i8:
		*(int8_t*)temp = *((int8_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((int8_t*)(matrix) + start+i*spacing)> *(int8_t*)temp) *(int8_t*)temp = *((int8_t*)(matrix) + start+i*spacing);
		}
		break;
		case float8:
		case u8:
		*(uint8_t*)temp = *((uint8_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((uint8_t*)(matrix) + start+i*spacing)> *(uint8_t*)temp) *(uint8_t*)temp = *((uint8_t*)(matrix) + start+i*spacing);
		}
		break;
		case i16:
		*(int16_t*)temp = *((int16_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((int16_t*)(matrix) + start+i*spacing)> *(int16_t*)temp) *(int16_t*)temp = *((int16_t*)(matrix) + start+i*spacing);
		}
		break;
		case float16:
		case u16:
		*(uint16_t*)temp = *((uint16_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((uint16_t*)(matrix) + start+i*spacing)> *(uint16_t*)temp) *(uint16_t*)temp = *((uint16_t*)(matrix) + start+i*spacing);
		}
		break;
		case i32:
		*(int32_t*)temp = *((int32_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((int32_t*)(matrix) + start+i*spacing)> *(int32_t*)temp) *(int32_t*)temp = *((int32_t*)(matrix) + start+i*spacing);
		}
		break;
		case float32:
		*(float*)temp = *((float*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((float*)(matrix) + start+i*spacing)> *(float*)temp) *(float*)temp = *((float*)(matrix) + start+i*spacing);
		}
		break;
		case u32:
		*(uint32_t*)temp = *((uint32_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((uint32_t*)(matrix) + start+i*spacing)> *(uint32_t*)temp) *(uint32_t*)temp = *((uint32_t*)(matrix) + start+i*spacing);
		}
		break;
		case i64:
		*(int64_t*)temp = *((int64_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((int64_t*)(matrix) + start+i*spacing)> *(int64_t*)temp) *(int64_t*)temp = *((int64_t*)(matrix) + start+i*spacing);
		}
		break;
		case float64:
		*(double*)temp = *((double*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((double*)(matrix) + start+i*spacing)> *(double*)temp) *(double*)temp = *((double*)(matrix) + start+i*spacing);
		}
		break;
		case u64:
		*(uint64_t*)temp = *((uint64_t*)(matrix) + start);
		for (int i = 1;i< num_max;i++)
		{
			if (*((uint64_t*)(matrix) + start+i*spacing)> *(uint64_t*)temp) *(uint64_t*)temp = *((uint64_t*)(matrix) + start+i*spacing);
		}
		// printf("maxSpace: %ld\n",*(uint64_t*)temp);
		break;
		default:
			break;
		}
	return;
}

void maxpool1D(Tensor *src, uint32_t size, uint8_t x, int l, int s, int cs, Tensor *dst, int mode, MemPoolRequest *req, MemPoolResponse *resp)
{
	uint8_t dt = src->descriptor.data_type;
	uint8_t dsize = sizeofTensorDataInBytes(dt);
	int num_units = size/(x*cs);
	int num_1D_steps = ((mode == floor) ? 1 + (x-l)/s : 1 - (l-x)/s);
	if (l>x)
	{
		fprintf(stderr,"Warning: Length exceeds dimension.\n");
		num_1D_steps = mode;
	}
	uint64_t temp, temp_old[num_1D_steps];
	req->arguments[2] = cs;
	void *temp_var;
	temp_var = &temp;
	int i=0,j=0,k=0;
	for (i = 0;i<num_units;i++)
	{	
		for (k = 0;k < cs;k++)
		{
			req->request_type = READ;
			req->arguments[0] = x;
			req->arguments[1] = src->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + (i*x*cs+k);
			memPoolAccess(src->mem_pool_identifier,req,resp);

			for (j = 0; j < num_1D_steps - mode; j++)
			{	
				maxWithSpacing(l, resp->read_data, j*s , 1, dt,temp_var);
				temp_old[j] = *(uint64_t*)temp_var;
			}
			if (mode == ceil)
			{
				maxWithSpacing(x - (num_1D_steps-1)*s, resp->read_data, j*s, 1, dt,temp_var);
				temp_old[j] = *(uint64_t*)temp_var;
			}
			req->request_type = WRITE;
			req->arguments[0] = num_1D_steps;
			req->arguments[1] = dst->mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i*num_1D_steps*cs + k;
			for (int var = 0; var < num_1D_steps; var++)
			{
				req->write_data[var] = temp_old[var];
			}
			// resp->status = OK;
			memPoolAccess(dst->mem_pool_identifier,req,resp);
		}
	}
}

void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool, int * dims_to_pool, int mode)
{
	if (num_dims_to_pool > src->descriptor.number_of_dimensions)
	{
		fprintf(stderr,"Error: Dimensions to pool exceeds vector dimensions.\n");
		return;
	}

	dst->descriptor.data_type = src->descriptor.data_type;
	uint8_t row_major = src->descriptor.row_major_form;
	dst->descriptor.row_major_form = row_major;
	uint32_t size = getSizeOfTensor(src);
	int cs = 1,i = 0;
	uint8_t x;
	uint8_t dsize = sizeofTensorDataInBytes(src->descriptor.data_type);
	dst->descriptor.number_of_dimensions = src->descriptor.number_of_dimensions;
	sort(dims_to_pool,num_dims_to_pool);
	
	MemPoolRequest req;
	MemPoolResponse resp;

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

	// createTensor()
	Tensor temp_Tensor;
	temp_Tensor.descriptor = src->descriptor;
	temp_Tensor.mem_pool_identifier = src->mem_pool_identifier;
	temp_Tensor.mem_pool_buffer_pointer = 2*(1 + size/MEMPOOL_PAGE_SIZE);
	
	for (int j = jStart; j != jEnd;j += jInc)
	{
		x = src->descriptor.dimensions[j];
		if ((j == dims_to_pool[i]) && (i != (iEnd+iInc)))
		{
			
			if ((i == iStart)&&(i == iEnd))
			{
				maxpool1D(src, size, x, l, stride, cs, dst, mode, &req, &resp);
			}
			else if (i == iStart)
			{
				maxpool1D(src, size, x, l, stride, cs, &temp_Tensor, mode, &req, &resp);
			}
			else if	(i == iEnd)
			{
				maxpool1D(&temp_Tensor, size, x, l, stride, cs, dst, mode, &req, &resp);
			}
			else 
			{
				maxpool1D(&temp_Tensor, size, x, l, stride, cs, &temp_Tensor, mode, &req, &resp);
			}

			int factor = (x<l) ? mode : ((mode == floor) ? 1+(x-l)/stride : 1 - (l-x)/stride);
			size = size*factor/x;
			dst->descriptor.dimensions[j] = factor;
			cs *= factor;
			i += iInc;
		}
		else
		{
			dst->descriptor.dimensions[j] = x;
			cs *= x;
		}
	}
}
