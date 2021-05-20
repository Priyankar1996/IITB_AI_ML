#include <stdio.h>
#include "maxpoolTensors.c"
#include "../../Mempool/mempool.c"
#include "../../Mempool/tensor.c"

MemPool pool;

int main(){

	Tensor T,B;

	//Take input tensor dimensions: num_diminsions followed by size of each dimension
	scanf("%d",&T.descriptor.number_of_dimensions);
	for (int i = 0;i < T.descriptor.number_of_dimensions;i++){
		scanf("%d",&T.descriptor.dimensions[i]);		
	}
	int size = getSizeOfTensor(&T);
	initMemPool(&pool,1,2 + 2*size/MEMPOOL_PAGE_SIZE);

	int length,stride,num_dims,mode;
	scanf("%d%d%d%d",&length,&stride,&mode,&num_dims);
	// mode = 0 for floor, 1 for ceil

	int dims_to_pool[num_dims];
	for (int i = 0;i < num_dims;i++){
		scanf("%d",&dims_to_pool[i]);		
	}

	T.mem_pool_identifier = &pool;
	T.mem_pool_buffer_pointer = 0;
	T.descriptor.row_major_form = 1;
	T.descriptor.data_type = u64;
	uint64_t temp[size];
	for (int i = 0; i < size; i++)
	{
		temp[i] = i+1;
	}
	MemPoolRequest req;
	MemPoolResponse resp;
	write(&T,&req,&resp,size,&temp);
	
	B.mem_pool_identifier = &pool;
	B.mem_pool_buffer_pointer = 1 + size/MEMPOOL_PAGE_SIZE;
	
	maxPoolOfTensors(&T,&B,length,stride,num_dims,dims_to_pool,mode);
	// Arguments : input , output , pool_size , stride , num_dims , mode  
	
	printf("Size of B is ");
	for (int i =0; i<B.descriptor.number_of_dimensions;i++) printf("%d ",B.descriptor.dimensions[i]);
	printf("\n");
	size = getSizeOfTensor(&B);
	uint64_t array[size];
	read(&B,&req,&resp,size,array);
	for (int i = 0; i < size; i++)
	{
		printf("%d %ld\n",i, array[i]);
	}
	
	return 0;
}