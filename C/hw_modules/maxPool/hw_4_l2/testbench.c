#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
#include "maxPoolOfTensors.h"
 
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
TensorDescriptor desc_T,desc_B;

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
	register_pipe ("maxpool_input_pipe", 2, 8, PIPE_FIFO_MODE);
	register_pipe ("maxpool_output_pipe", 2, 8, PIPE_FIFO_MODE);

	PTHREAD_DECL(maxPool3D);

	PTHREAD_CREATE(maxPool3D);

#endif

	fprintf(stderr,"Reading files\n");

	uint8_t rand_data;
	fscanf(file,"%hhd",&rand_data);

	#ifdef __U8
		desc_T.data_type = u8;
		fprintf(octaveInFile,"0\n");
	#endif
	#ifdef __U16
		desc_T.data_type = u16;
		fprintf(octaveInFile,"1\n");
	#endif
	#ifdef __U32
		desc_T.data_type = u32;
		fprintf(octaveInFile,"2\n");
	#endif
	#ifdef __U64
		desc_T.data_type = u64;
		fprintf(octaveInFile,"3\n");
	#endif
	#ifdef __I8
		desc_T.data_type = i8;
		fprintf(octaveInFile,"4\n");
	#endif
	#ifdef __I16
		desc_T.data_type = i16;
		fprintf(octaveInFile,"5\n");
	#endif
	#ifdef __I32
		desc_T.data_type = i32;
		fprintf(octaveInFile,"6\n");
	#endif
	#ifdef __I64
		desc_T.data_type = i64;
		fprintf(octaveInFile,"7\n");
	#endif
	#ifdef __F8
		desc_T.data_type = float8;
		fprintf(octaveInFile,"8\n");
	#endif
	#ifdef __F16
		desc_T.data_type = float16;
		fprintf(octaveInFile,"9\n");
	#endif
	#ifdef __F32
		desc_T.data_type = float32;
		fprintf(octaveInFile,"10\n");
	#endif
	#ifdef __F64
		desc_T.data_type = float64;
		fprintf(octaveInFile,"11\n");
	#endif

	fprintf(stderr,"Entering data to tensor\n");
	uint16_t length,stride;
	fscanf(file,"%hu%hu",&length,&stride);
	fprintf(octaveInFile,"%hu\n%hu\n",length,stride);

	desc_T.number_of_dimensions = 3;
	desc_B.number_of_dimensions = desc_T.number_of_dimensions;
	int i;
	for (i = 0;i < desc_T.number_of_dimensions;i++){
		fscanf(file,"%d",&desc_T.dimensions[i]);
		fprintf(octaveInFile,"%d\n",desc_T.dimensions[i]);
		write_uint8("maxpool_input_pipe",desc_T.dimensions[i]>>8);
		write_uint8("maxpool_input_pipe",desc_T.dimensions[i]);
	
		if (i==2) desc_B.dimensions[i] = desc_T.dimensions[i];
		else desc_B.dimensions[i] = 1 + (desc_T.dimensions[i]-length)/stride;
		write_uint8("maxpool_input_pipe",desc_B.dimensions[i]>>8);
		write_uint8("maxpool_input_pipe",desc_B.dimensions[i]);
	}
	

	uint64_t size = __NumberOfElementsInSizedTensor__(desc_T);

	int16_t temp[4];
	for (i = 0; i < size; i++)
	{
		if (rand_data)	temp[i&3] = rand();	//Random data
		else temp[i&3] = i+1;					//Sequential data
		fprintf(octaveInFile,"%hd\n",temp[i&3]);
		write_uint8("maxpool_input_pipe",temp[i&3]>>8);
		write_uint8("maxpool_input_pipe",temp[i&3]);
		fprintf(stderr,"Sent element %d\n",i);
		if ((i&3)==3) T.data_array[i/4] = *(uint64_t*)temp;
	}
	T.data_array[i/4] = *(uint64_t*)temp;
	fclose(octaveInFile);

	fprintf(stderr,"Checkpoint\n");
	
	fprintf(outFile,"Size of output is ");
	for (i =0; i<desc_B.number_of_dimensions;i++)
	{
		fprintf(outFile,"%hu ",desc_B.dimensions[i]);
	}
	fprintf(outFile,"\n");
	size = __NumberOfElementsInSizedTensor__(desc_B);
	fprintf(stderr,"Size of output is %d\n",size );
	fprintf(stderr,"Reading back the values from hardware\n");
	
	int16_t val;
	for (i = 0; i < size; i++)
	{
		val = read_uint8("maxpool_output_pipe");
		val = (val << 8) + read_uint8("maxpool_output_pipe");
		fprintf(outFile,"%d %hd\n",i+1, val);
		fprintf(stderr,"%d %hd\n",i+1, val);
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
#ifndef SW
	uint64_t time_taken = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Time taken is %lu\n",time_taken);
#endif
	system("cmp COutFile.txt OctaveOutFile.txt");

#ifdef SW
	PTHREAD_CANCEL(maxPool3D);
	close_pipe_handler();
#endif
return 0;

}
