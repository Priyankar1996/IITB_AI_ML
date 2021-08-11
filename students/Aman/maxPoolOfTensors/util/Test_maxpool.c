#include <stdio.h>
#include <string.h>
#include <time.h>
#include "../include/maxPoolOfTensors.h"

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

	uint64_t size = getSizeOfTensor(&T);
	int dsize = sizeofTensorDataInBytes(T.descriptor.data_type);

	initMemPool(&pool,1,3 + 3*size*dsize/(MEMPOOL_PAGE_SIZE*8));
	// printf("Memory Size In Pages = %d\n",3 + 3*size*dsize/(MEMPOOL_PAGE_SIZE*8));
	
	createTensor(&T,&pool);

	req.request_type = WRITE;
	req.arguments[2] = 1;
	req.arguments[0] = 1;
	if (T.descriptor.data_type == u8){
		uint8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhu\n",temp[i&7]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == u16){
		uint16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hu\n",temp[i&3]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);		
		}
	}
	else if (T.descriptor.data_type == u32){
		uint32_t temp[2];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%u\n",temp[i&1]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);	
		}
	}
	else if (T.descriptor.data_type == u64){
		uint64_t temp[1];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lu\n",temp[0]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);	
		}
	}
	else if (T.descriptor.data_type == i8){
		int8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhd\n",temp[i&7]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == i16){
		int16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hd\n",temp[i&3]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);		
		}
	}
	else if (T.descriptor.data_type == i32){
		int32_t temp[2];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&1]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);	
		}
	}
	else if (T.descriptor.data_type == i64){
		int64_t temp[1];

		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%ld\n",temp[0]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == float8){
		uint8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&7]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == float16){
		uint16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&3]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == float32){
		float temp[2];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%f\n",temp[i&1]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}
	else if (T.descriptor.data_type == float64){
		double temp[1];
		for (int i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lf\n",temp[0]);
			req.arguments[1] = T.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			req.write_data[0] = *((uint64_t*)temp);
			memPoolAccess((MemPool*)T.mem_pool_identifier,&req,&resp);
		}
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.");
	}
	fclose(octaveInFile);
	
	B.descriptor = T.descriptor;
	createTensor(&B,&pool);

	maxPoolOfTensors(&T,&B,length,stride,num_dims,dims_to_pool,mode);

	// Arguments ){ input , output , pool_size , stride , num_dims , dims_to_pool , mode  

	fprintf(outFile,"Size of output is ");
	for (int i =0; i<B.descriptor.number_of_dimensions;i++) fprintf(outFile,"%d ",B.descriptor.dimensions[i]);
	fprintf(outFile,"\n");
	size = getSizeOfTensor(&B);

	req.request_type = READ;
	req.arguments[2] = 1;
	req.arguments[0] = 1;
	if (T.descriptor.data_type == u8){
		uint8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hhu\n",i+1, temp[i&7]);
		}
	}	
	else if (T.descriptor.data_type == u16){
		uint16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hu\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.data_type == u32){
		uint32_t temp[2];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %u\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.data_type == u64){
		uint64_t temp[1];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %lu\n",i+1, temp[0]);
		}
	}	
	else if (T.descriptor.data_type == i8){
		int8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hhd\n",i+1, temp[i&7]);
		}
	}	
	else if (T.descriptor.data_type == i16){
		int16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hd\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.data_type == i32){
		int32_t temp[2];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %d\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.data_type == i64){
		int64_t temp[1];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %ld\n",i+1, temp[0]);
		}
	}	
	else if (T.descriptor.data_type == float8){
		uint8_t temp[8];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/8;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hhu\n",i+1, temp[i&7]);
		}
	}	
	else if (T.descriptor.data_type == float16){
		uint16_t temp[4];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/4;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %hu\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.data_type == float32){
		float temp[2];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i/2;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %f\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.data_type == float64){
		double temp[1];
		for (int i = 0; i < size; i++)
		{
			req.arguments[1] = B.mem_pool_buffer_pointer*MEMPOOL_PAGE_SIZE + i;
			memPoolAccess((MemPool*)B.mem_pool_identifier,&req,&resp);
			*((uint64_t*)temp) = resp.read_data[0];
			fprintf(outFile,"%d %f\n",i+1, temp[0]);
		}
	}	
	else{
		fprintf(stderr,"Error. Datypes mismatch.");
	}

	fclose(file);
	fclose(outFile);
	int system(const char *command);
	char arr[100] = "octave ../util/octaveFile <";
	strcat(arr,oct);
	strcat(arr," >OctaveOutFile.txt\n");
	system(arr);

	printf("If no message is printed after this one, there is no error!!\n");
	system("cmp COutFile.txt OctaveOutFile.txt");
	return 0;
}
