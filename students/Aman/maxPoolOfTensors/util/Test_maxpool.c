#include <stdio.h>
#include <string.h>
#include "../src/maxPoolOfTensors.c"
#include "../../../Mempool/mempool.c"
#include "../../../Mempool/tensor.c"

MemPool pool;

int main(int argc, char**argv){

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

	//Take input tensor dimensions: num_diminsions followed by size of each dimension
	fscanf(file,"%d",&T.descriptor.number_of_dimensions);
	fprintf(octaveInFile,"%d\n",T.descriptor.number_of_dimensions);
	for (int i = 0;i < T.descriptor.number_of_dimensions;i++){
		fscanf(file,"%d",&T.descriptor.dimensions[i]);
		fprintf(octaveInFile,"%d\n",T.descriptor.dimensions[i]);
	}
	int length,stride,num_dims,mode;
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
	
	T.mem_pool_identifier = &pool;
	T.mem_pool_buffer_pointer = 0;
	T.descriptor.row_major_form = 0;
	
	T.descriptor.data_type = u8;
	uint8_t temp[size];
	uint8_t array[size];
	for (int i = 0; i < size; i++)
	{
		//temp[i] = i+1;					//Sequential data
		temp[i] = random();					//Random data
		fprintf(octaveInFile,"%d\n",temp[i]);
	}

	writeTensor(&T,&req,&resp,size,&temp);
	
	B.mem_pool_identifier = &pool;
	B.mem_pool_buffer_pointer = 1 + size*dsize/(MEMPOOL_PAGE_SIZE*8);
	
	maxPoolOfTensors(&T,&B,length,stride,num_dims,dims_to_pool,mode);
	// Arguments : input , output , pool_size , stride , num_dims , dims_to_pool , mode  
	
	fprintf(outFile,"Size of output is ");
	for (int i =0; i<B.descriptor.number_of_dimensions;i++) fprintf(outFile,"%d ",B.descriptor.dimensions[i]);
	fprintf(outFile,"\n");
	size = getSizeOfTensor(&B);
	
	readTensor(&B,&req,&resp,size,array);
	for (int i = 0; i < size; i++)
	{
		fprintf(outFile,"%d %d\n",i+1, array[i]);
	}
	int system(const char *command);
	fclose(octaveInFile);
	char arr[100] = "octave octaveFile <";
	strcat(arr,oct);
	strcat(arr," >OctaveOutFile.txt\n");
	system(arr);
	fclose(file);
	fclose(outFile);
	printf("If no message is printed after this one, there is no error!!\n");
	system("cmp COutFile.txt OctaveOutFile.txt");
	return 0;
}
