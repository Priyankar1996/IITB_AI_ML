#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <inttypes.h>
#include "../../../C/primitives/include/tensor.h" 
#include "../../../docs/original_idea/students_implementations/createTensor/src/createTensor.c" 
#include "../include/utils/tb_utils.h"
#include "../include/concat.h"
#include "../src/concat.c"
#define NPAGES 30

MemPool 	pool;

Tensor a;
Tensor b;
Tensor r;

int _err_ = 0;

int main(){
    initMemPool(&pool,1,NPAGES);
	//define tensor
	const TensorDataType dataType = i16;
	const int8_t row_major_form = 0;
	const uint32_t ndim  = 4;
	const uint32_t dx = 3,dim_dx = 1;
	uint32_t dims[ndim];
	dims[0] = 2;
	dims[1] = 2;
	dims[2] = 4;
	dims[3] = 3;
	a.descriptor.data_type = dataType;
	a.descriptor.row_major_form = row_major_form;
	a.descriptor.number_of_dimensions = ndim;

	b.descriptor.data_type = dataType;
	b.descriptor.row_major_form = row_major_form;
	b.descriptor.number_of_dimensions = ndim;

    r.descriptor.data_type = dataType;
	r.descriptor.row_major_form = row_major_form;
	r.descriptor.number_of_dimensions = ndim;
    
	uint32_t num_elems_a = 1, num_elems_b =1; // product of dims (# of elements in tensor)  
	
	for (int i = 0; i < ndim; i++)
	{
		a.descriptor.dimensions[i] = dims[i];
		num_elems_a *= dims[i];
        if (i!=dx){
		    b.descriptor.dimensions[i] = dims[i];
		    r.descriptor.dimensions[i] = dims[i];
            num_elems_b *= dims[i];
        }else{
		    b.descriptor.dimensions[i] = dim_dx;   
            r.descriptor.dimensions[i] = dims[i]+dim_dx;
            num_elems_b *= dim_dx;     
        }
	}

	//create tensor
    _err_ = createTensor(&a,&pool,&req,&resp) + _err_;
    _err_ = createTensor(&b,&pool,&req,&resp) + _err_;
    _err_ = createTensor(&r,&pool,&req,&resp) + _err_;

    if(_err_!=0)
		fprintf(stderr,"create Tensor FAILURE.\n");


	uint32_t element_size = sizeofTensorDataInBytes(a.descriptor.data_type); 

	//fill tensor A values
	double offset = 1;
	fillTensorValues(&a, num_elems_a, offset,&req,&resp);
    offset = 1;
	fillTensorValues(&b, num_elems_b, offset,&req,&resp);
    offset = 1;
	fillTensorValues(&r, num_elems_b+num_elems_a, -1,&req,&resp);
    
    concatTensors(&a,&b,&r);

	// printf("\nTensor A\n");
	// print2dTensor(&a,&req,&resp);
	// printf("\nTensor B\n");
	// print2dTensor(&b,&req,&resp);
	printf("\nTensor Result\n");
	print2dTensor(&r,&req,&resp);

	// printf("%" PRIx64 "",b.mem_pool_identifier->mem_pool_buffer[b.mem_pool_buffer_pointer+1]);
}

