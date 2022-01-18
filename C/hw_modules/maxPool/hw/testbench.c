#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
#include "maxPoolOfTensors.h"

//
// the next two inclusions are
// to be used in the software version
//  
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#else
#include "vhdlCStubs.h"
#endif

#ifdef SW
DEFINE_THREAD(maxPool3D);
#endif


SizedTensor_16K T,B;
int main(int argc, char**argv){

	fprintf(stderr,"Entering testbench main program\n");

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
	fprintf(stderr,"Defined and opened files\n");

#ifdef SW
	init_pipe_handler();
	register_pipe ("maxpool_input_pipe", 2, 16, PIPE_FIFO_MODE);
	register_pipe ("maxpool_output_pipe", 2, 16, PIPE_FIFO_MODE);

	PTHREAD_DECL(maxPool3D);

	PTHREAD_CREATE(maxPool3D);
#endif

	fprintf(stderr,"Reading files\n");

	uint8_t rand_data;
	fscanf(file,"%hhd",&rand_data);

	//Take datatype as input

	#ifdef __U8
		T.descriptor.descriptor.data_type = u8;
		fprintf(octaveInFile,"0\n");
	#endif
	#ifdef __U16
		T.descriptor.descriptor.data_type = u16;
		fprintf(octaveInFile,"1\n");
	#endif
	#ifdef __U32
		T.descriptor.descriptor.data_type = u32;
		fprintf(octaveInFile,"2\n");
	#endif
	#ifdef __U64
		T.descriptor.descriptor.data_type = u64;
		fprintf(octaveInFile,"3\n");
	#endif
	#ifdef __I8
		T.descriptor.descriptor.data_type = i8;
		fprintf(octaveInFile,"4\n");
	#endif
	#ifdef __I16
		T.descriptor.descriptor.data_type = i16;
		fprintf(octaveInFile,"5\n");
	#endif
	#ifdef __I32
		T.descriptor.descriptor.data_type = i32;
		fprintf(octaveInFile,"6\n");
	#endif
	#ifdef __I64
		T.descriptor.descriptor.data_type = i64;
		fprintf(octaveInFile,"7\n");
	#endif
	#ifdef __F8
		T.descriptor.descriptor.data_type = float8;
		fprintf(octaveInFile,"8\n");
	#endif
	#ifdef __F16
		T.descriptor.descriptor.data_type = float16;
		fprintf(octaveInFile,"9\n");
	#endif
	#ifdef __F32
		T.descriptor.descriptor.data_type = float32;
		fprintf(octaveInFile,"10\n");
	#endif
	#ifdef __F64
		T.descriptor.descriptor.data_type = float64;
		fprintf(octaveInFile,"11\n");
	#endif

	//Take row-major-form as input
	fscanf(file,"%hhd",&T.descriptor.descriptor.row_major_form);
	fprintf(octaveInFile,"%hhd\n",T.descriptor.descriptor.row_major_form);

	//Take input tensor dimensions){ num_diminsions followed by size of each dimension
	fscanf(file,"%d",&T.descriptor.descriptor.number_of_dimensions);
	fprintf(octaveInFile,"%d\n",T.descriptor.descriptor.number_of_dimensions);
	
	int i;
	for (i = 0;i < T.descriptor.descriptor.number_of_dimensions;i++){
		fscanf(file,"%d",&T.descriptor.descriptor.dimensions[i]);
		fprintf(octaveInFile,"%d\n",T.descriptor.descriptor.dimensions[i]);
		write_uint16("maxpool_input_pipe",T.descriptor.descriptor.dimensions[i]);
	}
	uint16_t length,stride,mode,num_dims;
	fscanf(file,"%hu%hu%hu%hu",&length,&stride,&mode,&num_dims);
	fprintf(octaveInFile,"%hu\n%hu\n%hu\n%hu\n",length,stride,mode,num_dims);
	write_uint16("maxpool_input_pipe",length);
	write_uint16("maxpool_input_pipe",stride);
	// mode = 0 for floor, 1 for ceil
	
	int dims_to_pool[num_dims];
	for (i = 0;i < num_dims;i++){
		fscanf(file,"%d",&dims_to_pool[i]);
		fprintf(octaveInFile,"%d\n",dims_to_pool[i]);	
	}

	fprintf(stderr,"Entering data to tensor\n");

	uint64_t size = __NumberOfElementsInSizedTensor__(T);

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
			write_uint16("maxpool_input_pipe",temp[i&3]);
			if ((i&3)==3) T.data_array[i/4] = *(uint64_t*)temp;
		}
		T.data_array[i/4] = *(uint64_t*)temp;
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
		T.data_array[i/2] = *(uint64_t*)temp;
	}
	else if (T.descriptor.descriptor.data_type == u64){
		uint64_t temp[1];
		for (i = 0; i < size; i++)
		{
			if (rand_data)	temp[0] = rand();	//Random data
			else temp[0] = i+1;					//Sequential data
			fprintf(octaveInFile,"%lu\n",temp[0]);
			T.data_array[i] = *(uint64_t*)temp;
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
		T.data_array[i/4] = *(uint64_t*)temp;
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
		T.data_array[i/2] = *(uint64_t*)temp;
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
		T.data_array[i/4] = *(uint64_t*)temp;
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
		T.data_array[i/2] = *(uint64_t*)temp;
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
	fprintf(stderr,"Checkpoint\n");
	fclose(octaveInFile);
	
	fprintf(stderr,"Reading back the values from hardware\n");

	fprintf(outFile,"Size of output is ");
	for (i =0; i<B.descriptor.descriptor.number_of_dimensions;i++)
	{
		uint16_t dim = read_uint16("maxpool_output_pipe");
		fprintf(outFile,"%hu ",dim);
	}
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
		uint16_t val;
		for (i = 0; i < size; i++)
		{
			val = read_uint16("maxpool_output_pipe");
			fprintf(outFile,"%d %hu\n",i+1, val);
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

	fprintf(stderr,"Read back the values from hardware\n");

	fclose(file);
	fclose(outFile);
	int system(const char *command);
	fprintf(stderr,"Calling reference implementation\n");

	char arr[100] = "octave ../util_macro/octaveFile <";
	strcat(arr,oct);
	strcat(arr," >OctaveOutFile.txt\n");
	system(arr);

	printf("If no message is printed after this one, there is no error!!\n");
	system("cmp COutFile.txt OctaveOutFile.txt");

#ifdef SW
	PTHREAD_CANCEL(maxPool3D);
	close_pipe_handler();
#endif
return 0;

}
