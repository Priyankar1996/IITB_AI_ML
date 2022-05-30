#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include "sized_tensor.h"

#define __UpdateOutputDescriptorConcatTensors__(src1,src2,output) ({\
	fprintf(stderr,"Updating output descriptor and writing inputs.\n");\
    desc_output.dimensions[0] = src1.dimensions[0];\
    desc_output.dimensions[1] = src1.dimensions[1] + src2.dimensions[1];\
	desc_output.dimensions[2] = src1.dimensions[2];\
})

SizedTensor_16K input1,input2,output;
TensorDescriptor desc_input1,desc_input2,desc_output;

int main(int argc,char **argv)
{
    srand(time(0));
    FILE *input_file,*out_file;
    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }
    if ((out_file = fopen("CoutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}
    uint8_t rand_input_data;
	fscanf(input_file,"%hhu",&rand_input_data);
	desc_input1.data_type = u8;
    desc_input2.data_type = u8;
    desc_output.data_type = u8;

    int ii;
	for (ii = 0;ii < 3;ii++){
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
		desc_input1.dimensions[ii] = (var1 << 8) + var2;
	    fprintf(out_file,"%hu\n",(desc_input1.dimensions[ii] >> 8));        
	    fprintf(out_file,"%hu\n",(desc_input1.dimensions[ii]));        
	}
	fprintf(stderr,"Read input-1's descriptor %d,%d,%d.\n",desc_input1.dimensions[0],desc_input1.dimensions[1],desc_input1.dimensions[2]);
    for (ii = 0;ii < 3;ii++){
		uint8_t var1,var2;
		fscanf(input_file,"%u",&var1);
		fscanf(input_file,"%u",&var2);
		desc_input2.dimensions[ii] = (var1 << 8) + var2;
		fprintf(out_file,"%hu\n",(desc_input2.dimensions[ii] >> 8));
		fprintf(out_file,"%hu\n",desc_input2.dimensions[ii]);
	}
	fprintf(stderr,"Read input-2's descriptor %d,%d,%d.\n",desc_input2.dimensions[0],desc_input2.dimensions[1],desc_input2.dimensions[2]);
	uint32_t input1_size = desc_input1.dimensions[0]*desc_input1.dimensions[1]*desc_input1.dimensions[2];
	uint32_t input2_size = desc_input2.dimensions[0]*desc_input2.dimensions[1]*desc_input2.dimensions[2];
    __UpdateOutputDescriptorConcatTensors__(desc_input1,desc_input2,desc_output);
    for(ii = 0;ii < 3;ii++){
		fprintf(out_file,"%u\n",(desc_output.dimensions[ii]>>8));
		fprintf(out_file,"%u\n",desc_output.dimensions[ii]);
	}
    uint8_t temp[8];
    for (ii = 0; ii < input1_size; ii++)
	{
		if (rand_input_data)	temp[ii&3] = rand();	//Random data
		else temp[ii&7] = (ii+1)%128;	
		fprintf(out_file,"%u\n",temp[ii&7]);							//Sequential dat
	}
    for (ii = 0; ii < input2_size; ii++)
	{
		if (rand_input_data)	temp[ii&3] = rand();	//Random data
		else temp[ii&7] = (ii+1)%128;	
		fprintf(out_file,"%u\n",temp[ii&7]);							//Sequential dat
	}
	fprintf(stderr,"Wrote all input values\n");
    fclose(input_file);
	fclose(out_file);
    return 0;
}