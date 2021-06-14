#include <stdio.h>
#include <string.h>
#include <time.h>
#include "../include/maxPoolOfTensors.h"
#include "../../../Mempool/mempool.c"
#include "../../../Mempool/tensor.c"

MemPool pool;

int main(int argc, char**argv){

	srand(time(0));

	FILE *file, *outFile, *octaveInFile;
	if ((file = fopen(argv[1],"r")) == NULL){
		fprintf(stderr,"Input File error\n");
		exit(-1);
	}
	if ((outFile = fopen("COutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
	char *oct = "octaveInput.txt";
	if ((octaveInFile = fopen(oct,"w")) == NULL){
		fprintf(stderr,"Octave Input File error\n");
		exit(-1);
	}
	Tensor T,B;
	MemPoolRequest req;
	MemPoolResponse resp;

	uint8_t rand_data;
	fscanf(file,"%hhd",&rand_data);

	//Take datatype as input
	uint8_t dt_temp;
	fscanf(file,"%hhd",&dt_temp);
	fprintf(octaveInFile,"%hhd\n",dt_temp);
	switch (dt_temp)
	{
	case 0:
		T.descriptor.data_type = u8;
		break;
	case 1:
		T.descriptor.data_type = u16;
		break;
	case 2:
		T.descriptor.data_type = u32;
		break;
	case 3:
		T.descriptor.data_type = u64;
		break;
	case 4:
		T.descriptor.data_type = i8;
		break;
	case 5:
		T.descriptor.data_type = i16;
		break;
	case 6:
		T.descriptor.data_type = i32;
		break;
	case 7:
		T.descriptor.data_type = i64;
		break;
	case 8:
		T.descriptor.data_type = float8;
		break;
	case 9:
		T.descriptor.data_type = float16;
		break;
	case 10:
		T.descriptor.data_type = float32;
		break;
	case 11:
		T.descriptor.data_type = float64;
		break;		
	default:
		fprintf(stderr,"Invalid datatype!!\n");
		exit(-1);
		break;
	}
	

	//Take row-major-form as input
	fscanf(file,"%hhd",&T.descriptor.row_major_form);
	fprintf(octaveInFile,"%hhd\n",T.descriptor.row_major_form);

	//Take input tensor dimensions){ num_diminsions followed by size of each dimension
	fscanf(file,"%d",&T.descriptor.number_of_dimensions);
	fprintf(octaveInFile,"%d\n",T.descriptor.number_of_dimensions);
	for (int i = 0;i < T.descriptor.number_of_dimensions;i++){
		fscanf(file,"%d",&T.descriptor.dimensions[i]);
		fprintf(octaveInFile,"%d\n",T.descriptor.dimensions[i]);
	}
	int length,stride,mode,num_dims;
	fscanf(file,"%d%d%d%d",&length,&stride,&mode,&num_dims);
	fprintf(octaveInFile,"%d\n%d\n%d\n%d\n",length,stride,mode,num_dims);
	// mode = 0 for floor, 1 for ceil
	
	int dims_to_pool[num_dims];
	for (int i = 0;i < num_dims;i++){
		fscanf(file,"%d",&dims_to_pool[i]);
		fprintf(octaveInFile,"%d\n",dims_to_pool[i]);	
	}

	int size = getSizeOfTensor(&T);
	int dsize = sizeofTensorDataInBytes(T.descriptor.data_type);

	initMemPool(&pool,1,3 + 3*size*dsize/(MEMPOOL_PAGE_SIZE*8));
	// printf("Memory Size In Pages = %d\n",3 + 3*size*dsize/(MEMPOOL_PAGE_SIZE*8));
	
	T.mem_pool_identifier = &pool;
	T.mem_pool_buffer_pointer = 0;

	if (T.descriptor.data_type == u8){
		uint8_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhu\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == u16){
		uint16_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hu\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == u32){
		uint32_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%u\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == u64){
		uint64_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lu\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == i8){
		int8_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhd\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == i16){
		int16_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hd\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == i32){
		int32_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == i64){
		int64_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%ld\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}	
	else if (T.descriptor.data_type == float8){
		uint8_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhu\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == float16){
		uint16_t temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hu\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == float32){
		float temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%f\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}
	else if (T.descriptor.data_type == float64){
		double temp[size];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i] = rand();	//Random data
			else temp[i] = i+1;					//Sequential data
			fprintf(octaveInFile,"%f\n",temp[i]);
		}
		writeTensor(&T,&req,&resp,size,&temp);
	}	
	else{
		fprintf(stderr,"Error. Datypes mismatch.");
	}

	// for (int i = 0; i < size; i++)
	// {
	// 	fprintf(outFile,"%d %ld\n",i+1, T.mem_pool_identifier->mem_pool_buffer[T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i]);
	// }
	// readTensor(&T,&req,&resp,size,temp);
	// for (int i = 0; i < size; i++)
	// {
	// 	fprintf(outFile,"%d %ld\n",i+1, temp[i]);
	// }
	
	B.mem_pool_identifier = &pool;
	B.mem_pool_buffer_pointer = 1 + size*dsize/(MEMPOOL_PAGE_SIZE*8);
	
	maxPoolOfTensors(&T,&B,length,stride,num_dims,dims_to_pool,mode);
	// Arguments ){ input , output , pool_size , stride , num_dims , dims_to_pool , mode  

	fprintf(outFile,"Size of output is ");
	for (int i =0; i<B.descriptor.number_of_dimensions;i++) fprintf(outFile,"%d ",B.descriptor.dimensions[i]);
	fprintf(outFile,"\n");
	size = getSizeOfTensor(&B);
	
	if (T.descriptor.data_type == u8){
		uint8_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hhu\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == u16){
		uint16_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hu\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == u32){
		uint32_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %u\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == u64){
		uint64_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %lu\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == i8){
		int8_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hhd\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == i16){
		int16_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hd\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == i32){
		int32_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %d\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == i64){
		int64_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %ld\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == float8){
		uint8_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hhu\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == float16){
		uint16_t temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %hu\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == float32){
		float temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %f\n",i+1, temp[i]);
		}
	}	
	else if (T.descriptor.data_type == float64){
		double temp[size];
		readTensor(&B,&req,&resp,size,temp);
		for (int i = 0; i < size; i++)
		{
			fprintf(outFile,"%d %f\n",i+1, temp[i]);
		}
	}	
	else{
		fprintf(stderr,"Error. Datypes mismatch.");
	}

	int system(const char *command);
	fclose(octaveInFile);
	char arr[100] = "octave ../util/octaveFile <";
	strcat(arr,oct);
	strcat(arr," >OctaveOutFile.txt\n");
	system(arr);
	fclose(file);
	fclose(outFile);
	printf("If no message is printed after this one, there is no error!!\n");
	system("cmp COutFile.txt OctaveOutFile.txt");
	return 0;
}
