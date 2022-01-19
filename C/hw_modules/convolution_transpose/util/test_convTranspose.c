#define __U16 1

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"
#include "convolution_transpose_improved.h"

SizedTensor_256K input, output;
SizedTensor_4096 kernel;
int stride[2],padding;
//Fill input and kernel tensors with random values.
    

int main(int argc,char **argv)
{

    FILE *input_file,*param_file, *kernel_file, *out_file;

    if ((input_file = fopen(argv[1],"r")) == NULL){
        fprintf(stderr,"Input File Error\n");
        exit(-1);
    }

    if ((kernel_file = fopen(argv[2],"r")) ==  NULL){
        fprintf(stderr,"Input kernel file error\n");
        exit(-1);
    }
    
	if ((param_file = fopen(argv[3],"r")) ==  NULL){
        fprintf(stderr,"Input parameters file error\n");
        exit(-1);
    }

    if ((out_file = fopen("CoutFile.txt","w")) == NULL){
		fprintf(stderr,"Output File error\n");
		exit(-1);
	}

    uint8_t rand_input_data, rand_kernel_data;
	fscanf(input_file,"%hhd",&rand_input_data);
	fscanf(kernel_file,"%hhd",&rand_kernel_data);

    //Take datatype as input
    #ifdef __U8
		input.descriptor.descriptor.data_type = u8;
        kernel.descriptor.descriptor.data_type = u8;
	#endif
	#ifdef __U16
		input.descriptor.descriptor.data_type = u16;
        kernel.descriptor.descriptor.data_type = u16;
	#endif
	#ifdef __U32
		input.descriptor.descriptor.data_type = u32;
        kernel.descriptor.descriptor.data_type = u32;
	#endif
	#ifdef __U64
		input.descriptor.descriptor.data_type = u64;
        kernel.descriptor.descriptor.data_type = u64;
	#endif
	#ifdef __I8
		input.descriptor.descriptor.data_type = i8;
        kernel.descriptor.descriptor.data_type = i8;
	#endif
	#ifdef __I16
		input.descriptor.descriptor.data_type = i16;
		kernel.descriptor.descriptor.data_type = i16;
	#endif
	#ifdef __I32
		input.descriptor.descriptor.data_type = i32;
        kernel.descriptor.descriptor.data_type = i32;
	#endif
	#ifdef __I64
		input.descriptor.descriptor.data_type = i64;
        kernel.descriptor.descriptor.data_type = i64;
	#endif
	#ifdef __F8
		input.descriptor.descriptor.data_type = float8;
        kernel.descriptor.descriptor.data_type = float8;
	#endif
	#ifdef __F16
        input.descriptor.descriptor.data_type = float16;
        kernel.descriptor.descriptor.data_type = float16;
	#endif
	#ifdef __F32
		input.descriptor.descriptor.data_type = float32;
        kernel.descriptor.descriptor.data_type = float32;
	#endif
	#ifdef __F64
		input.descriptor.descriptor.data_type = float64;
        kernel.descriptor.descriptor.data_type = float64;
	#endif

    fscanf(input_file,"%hhd",&input.descriptor.descriptor.row_major_form);
    fscanf(input_file,"%d",&input.descriptor.descriptor.number_of_dimensions);
	int ii;
	for (ii = 0;ii < input.descriptor.descriptor.number_of_dimensions;ii++){
		fscanf(input_file,"%d",&input.descriptor.descriptor.dimensions[ii]);
	}

	fscanf(kernel_file,"%hhd",&kernel.descriptor.descriptor.row_major_form);
    fscanf(kernel_file,"%d",&kernel.descriptor.descriptor.number_of_dimensions);
	
	for (ii = 0;ii < kernel.descriptor.descriptor.number_of_dimensions;ii++){
		fscanf(kernel_file,"%d",&kernel.descriptor.descriptor.dimensions[ii]);
	}

	for (ii = 0;ii < 2;ii++){
		fscanf(param_file,"%d",&stride[ii]);
	}
	fscanf(param_file,"%d",&padding);
    //View output
    uint64_t input_size = __NumberOfElementsInSizedTensor__(input);
	uint64_t kernel_size = __NumberOfElementsInSizedTensor__(kernel);

    if (input.descriptor.descriptor.data_type == u16){
		uint16_t temp[4];
		for (ii = 0; ii < input_size; ii++)
		{
			if (rand_input_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;					//Sequential data
			if ((ii&3)==3) input.data_array[ii/4] = *(uint64_t*)temp;
		}
		input.data_array[ii/4] = *(uint64_t*)temp;
		for (ii = 0; ii < kernel_size; ii++)
		{
			if (rand_kernel_data)	temp[ii&3] = rand();	//Random data
			else temp[ii&3] = ii+1;					//Sequential data
			if ((ii&3)==3) kernel.data_array[ii/4] = *(uint64_t*)temp;
		}
		kernel.data_array[ii/4] = *(uint64_t*)temp;
	}	
	else{
		fprintf(stderr,"Error. Datatypes mismatch.");	
    }
    
    __ConvTranspose__(input,kernel,stride,padding,output);

    for (ii =0; ii<output.descriptor.descriptor.number_of_dimensions;ii++) 
        fprintf(out_file,"%d ",output.descriptor.descriptor.dimensions[ii]);
	fprintf(out_file,"\n");
	int size = __NumberOfElementsInSizedTensor__(output);

	if (input.descriptor.descriptor.data_type == u16){
		uint16_t temp[4];
		for (ii = 0; ii < size; ii++)
		{
			if ((ii&3)==0) *((uint64_t*)temp) = output.data_array[ii/4];
			fprintf(out_file,"%d %hd\n",ii+1, temp[ii&3]);
		}
	}
    else{
		fprintf(stderr,"Error. Datypes mismatch.");
	}
    fclose(input_file);
    fclose(kernel_file);
    fclose(out_file);
    return 0;
}