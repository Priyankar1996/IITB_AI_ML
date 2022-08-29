#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "sized_tensor.h"
 
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#ifndef SW
#include "vhdlCStubs.h"
#endif

TensorDescriptor desc_T,desc_B,desc_K;

void hear_timer()
{
    fprintf(stderr,"hear_timer is running.\n");
    while(1)
    {
    uint32_t t;
    uint64_t time_taken = read_uint64("time_pipe");
    t = time_taken>>32;
    fprintf(stderr,"Time taken at call %u is %u \n",t,time_taken);
    }
}

DEFINE_THREAD(hear_timer);

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

	PTHREAD_DECL(hear_timer);
	PTHREAD_CREATE(hear_timer);

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
	uint16_t length,stride,pad;
	// fscanf(file,"%hu%hu",&length,&stride);
	stride = 1;
	pad = 1;
	// fprintf(octaveInFile,"%hu\n%hu\n",length,stride);
	

	desc_T.number_of_dimensions = 3;
	desc_B.number_of_dimensions = 3;
	int i;
	for (i = 0;i < desc_T.number_of_dimensions;i++){
		fscanf(file,"%d",&desc_T.dimensions[i]);
		fprintf(octaveInFile,"%d\n",desc_T.dimensions[i]);
		write_uint8("maxpool_input_pipe",desc_T.dimensions[i]>>8);
		write_uint8("maxpool_input_pipe",desc_T.dimensions[i]&0xFF);
	
		fscanf(file,"%d",&desc_K.dimensions[(i+1)%3]);
		fprintf(octaveInFile,"%d\n",desc_K.dimensions[(i+1)%3]);
	}
	desc_K.number_of_dimensions = 4;
	desc_K.dimensions[3] = desc_T.dimensions[2];
	desc_B.dimensions[0] = 1 + (desc_T.dimensions[0]+2*pad-desc_K.dimensions[1])/stride;
	desc_B.dimensions[1] = 1 + (desc_T.dimensions[1]+2*pad-desc_K.dimensions[2])/stride;
	desc_B.dimensions[2] = desc_K.dimensions[0];
	write_uint8("maxpool_input_pipe",desc_B.dimensions[0]>>8);
	write_uint8("maxpool_input_pipe",desc_B.dimensions[0]&0xFF);
	write_uint8("maxpool_input_pipe",desc_B.dimensions[1]>>8);
	write_uint8("maxpool_input_pipe",desc_B.dimensions[1]&0xFF);
	write_uint8("maxpool_input_pipe",desc_B.dimensions[2]>>8);
	write_uint8("maxpool_input_pipe",desc_B.dimensions[2]&0xFF);
	write_uint8("maxpool_input_pipe",desc_K.dimensions[1]>>8);
	write_uint8("maxpool_input_pipe",desc_K.dimensions[1]&0xFF);
	write_uint8("maxpool_input_pipe",desc_K.dimensions[2]>>8);
	write_uint8("maxpool_input_pipe",desc_K.dimensions[2]&0xFF);
	uint16_t shft_val;
	fscanf(file,"%hu",&shft_val);
	write_uint8("maxpool_input_pipe",shft_val>>8);
	write_uint8("maxpool_input_pipe",shft_val&0xFF);
	fprintf(octaveInFile,"%d\n",shft_val);
	

	uint64_t size = __NumberOfElementsInSizedTensor__(desc_T);

	int8_t temp[4];
	for (i = 0; i < size; i++)
	{
		if (rand_data)	temp[i&3] = rand();	//Random data
		else temp[i&3] = i+1;					//Sequential data
		fprintf(octaveInFile,"%hhd\n",temp[i&3]);
		write_uint8("maxpool_input_pipe",temp[i&3]);
		fprintf(stderr,"Sent element %d\n",i);
	}

	size = __NumberOfElementsInSizedTensor__(desc_K);

	for (i = 0; i < size; i++)
	{
		if (rand_data)	temp[i&3] = rand();	//Random data
		else temp[i&3] = i+1;					//Sequential data
		fprintf(octaveInFile,"%hhd\n",temp[i&3]);
		write_uint8("maxpool_input_pipe",temp[i&3]);
		fprintf(stderr,"Sent kernel element %d\n",i);
	}
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
	
	
	
	int8_t val;
	// val = read_uint8("maxpool_output_pipe");
	// val = (val << 8) + read_uint8("maxpool_output_pipe");
	for (i = 0; i < size; i++)
	{
		val = read_uint8("maxpool_output_pipe");
		fprintf(outFile,"%d %hhd\n",i+1, val);
		fprintf(stderr,"%d %hhd\n",i+1, val);
	}
	
	fprintf(stderr,"Read back the values from hardware\n");

	fclose(file);
	fclose(outFile);
	int system(const char *command);
	fprintf(stderr,"Calling reference implementation\n");

	char arr[100] = "octave octaveFile <";
	strcat(arr,oct);
	strcat(arr," >OctaveOutFile.txt\n");
	system(arr);

	printf("If no message is printed after this one, there is no error!!\n");

	system("cmp COutFile.txt OctaveOutFile.txt");

return 0;

}
