#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

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
	SizedTensor_16K T,B;

	uint8_t rand_data;
	fscanf(file,"%hhd",&rand_data);

	//Take datatype as input
	uint8_t dt_temp;
	fscanf(file,"%hhd",&dt_temp);
	fprintf(octaveInFile,"%hhd\n",dt_temp);
	switch (dt_temp)
	{
	case 0:
		T.descriptor.descriptor.data_type = u8;
		break;
	case 1:
		T.descriptor.descriptor.data_type = u16;
		break;
	case 2:
		T.descriptor.descriptor.data_type = u32;
		break;
	case 3:
		T.descriptor.descriptor.data_type = u64;
		break;
	case 4:
		T.descriptor.descriptor.data_type = i8;
		break;
	case 5:
		T.descriptor.descriptor.data_type = i16;
		break;
	case 6:
		T.descriptor.descriptor.data_type = i32;
		break;
	case 7:
		T.descriptor.descriptor.data_type = i64;
		break;
	case 8:
		T.descriptor.descriptor.data_type = float8;
		break;
	case 9:
		T.descriptor.descriptor.data_type = float16;
		break;
	case 10:
		T.descriptor.descriptor.data_type = float32;
		break;
	case 11:
		T.descriptor.descriptor.data_type = float64;
		break;		
	default:
		fprintf(stderr,"Invalid datatype!!\n");
		exit(-1);
		break;
	}
	

	//Take row-major-form as input
	fscanf(file,"%hhd",&T.descriptor.descriptor.row_major_form);
	
	fprintf(octaveInFile,"%hhd\n",T.descriptor.descriptor.row_major_form);

	//Take input tensor dimensions){ num_diminsions followed by size of each dimension
	fscanf(file,"%d",&T.descriptor.descriptor.number_of_dimensions);
	fprintf(octaveInFile,"%d\n",T.descriptor.descriptor.number_of_dimensions);
	
	for (int i = 0;i < T.descriptor.descriptor.number_of_dimensions;i++){
		fscanf(file,"%d",&T.descriptor.descriptor.dimensions[i]);
		fprintf(octaveInFile,"%d\n",T.descriptor.descriptor.dimensions[i]);
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

	uint64_t size = __NumberOfElementsInSizedTensor__(T);

	int i;
	if (T.descriptor.descriptor.data_type == u8){
		uint8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhu\n",temp[i&7]);
			if ((i&7)==7) T.data_array[i/8] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == u16){
		uint16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hu\n",temp[i&3]);
			if ((i&3)==3) T.data_array[i/4] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == u32){
		uint32_t temp[2];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%u\n",temp[i&1]);
			if ((i&1)==1) T.data_array[i/2] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == u64){
		uint64_t temp[1];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lu\n",temp[0]);
			T.data_array[i/8] = *(uint64_t*)temp;
		}
	}
	else if (T.descriptor.descriptor.data_type == i8){
		int8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hhd\n",temp[i&7]);
			if ((i&7)==7) T.data_array[i/8] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == i16){
		int16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%hd\n",temp[i&3]);
			if ((i&3)==3) T.data_array[i/4] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == i32){
		int32_t temp[2];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&1]);
			if ((i&1)==1) T.data_array[i/2] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == i64){
		int64_t temp[1];

		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%ld\n",temp[0]);
			T.data_array[i] = *(uint64_t*)temp;
		}
	}
	else if (T.descriptor.descriptor.data_type == float8){
		uint8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&7] = rand();	//Random data
			else temp[i&7] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&7]);
			if ((i&7)==7) T.data_array[i/8] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == float16){
		uint16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&3] = rand();	//Random data
			else temp[i&3] = i+1;					//Sequential data
			fprintf(octaveInFile,"%d\n",temp[i&3]);
			if ((i&3)==3) T.data_array[i/4] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == float32){
		float temp[2];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[i&1] = rand();	//Random data
			else temp[i&1] = i+1;					//Sequential data
			fprintf(octaveInFile,"%f\n",temp[i&1]);
			if ((i&1)==1) T.data_array[i/2] = *(uint64_t*)temp;
		}
		T.data_array[i/8] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == float64){
		double temp[1];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lf\n",temp[0]);
			T.data_array[i] = *(uint64_t*)temp;
		}
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.");
	}
	fclose(octaveInFile);
	
	__maxPoolOfTensors__(T,B,length,stride,num_dims,dims_to_pool,mode);

	// Arguments ){ input , output , pool_size , stride , num_dims , dims_to_pool , mode  

	fprintf(outFile,"Size of output is ");
	for (int i =0; i<B.descriptor.descriptor.number_of_dimensions;i++) fprintf(outFile,"%d ",B.descriptor.descriptor.dimensions[i]);
	fprintf(outFile,"\n");
	size = __NumberOfElementsInSizedTensor__(B);

	if (T.descriptor.descriptor.data_type == u8){
		uint8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if ((i&7)==0) *((uint64_t*)temp) = B.data_array[i/8];
			fprintf(outFile,"%d %hhu\n",i+1, temp[i&7]);
		}
		*((uint64_t*)temp) = B.data_array[i/8];
	}	
	else if (T.descriptor.descriptor.data_type == u16){
		uint16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if ((i&3)==0) *((uint64_t*)temp) = B.data_array[i/4];
			fprintf(outFile,"%d %hu\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == u32){
		uint32_t temp[2];
		for (i = 0; i < size; i++)
		{
			if ((i&1)==0) *((uint64_t*)temp) = B.data_array[i/2];
			fprintf(outFile,"%d %u\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == u64){
		uint64_t temp[1];
		for (i = 0; i < size; i++)
		{
			*((uint64_t*)temp) = B.data_array[i];
			fprintf(outFile,"%d %lu\n",i+1, temp[0]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == i8){
		int8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if ((i&7)==0) *((uint64_t*)temp) = B.data_array[i/8];
			fprintf(outFile,"%d %hhd\n",i+1, temp[i&7]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == i16){
		int16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if ((i&3)==0) *((uint64_t*)temp) = B.data_array[i/4];
			fprintf(outFile,"%d %hd\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == i32){
		int32_t temp[2];
		for (i = 0; i < size; i++)
		{
			if ((i&1)==0) *((uint64_t*)temp) = B.data_array[i/2];
			fprintf(outFile,"%d %d\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == i64){
		int64_t temp[1];
		for (i = 0; i < size; i++)
		{
			*((uint64_t*)temp) = B.data_array[i];
			fprintf(outFile,"%d %ld\n",i+1, temp[0]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == float8){
		uint8_t temp[8];
		for (i = 0; i < size; i++)
		{
			if ((i&7)==0) *((uint64_t*)temp) = B.data_array[i/8];
			fprintf(outFile,"%d %hhu\n",i+1, temp[i&7]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == float16){
		uint16_t temp[4];
		for (i = 0; i < size; i++)
		{
			if ((i&3)==0) *((uint64_t*)temp) = B.data_array[i/4];
			fprintf(outFile,"%d %hu\n",i+1, temp[i&3]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == float32){
		float temp[2];
		for (i = 0; i < size; i++)
		{
			if ((i&1)==0) *((uint64_t*)temp) = B.data_array[i/2];
			fprintf(outFile,"%d %f\n",i+1, temp[i&1]);
		}
	}	
	else if (T.descriptor.descriptor.data_type == float64){
		double temp[1];
		for (i = 0; i < size; i++)
		{
			*((uint64_t*)temp) = B.data_array[i];
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
