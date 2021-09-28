#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
// #include <math.h>
#include "readWriteTensorsFromStandardIO.h"
#include "createTensor.h"
#include "conv.h"

#define NPAGES 30

MemPool pool;

Tensor a;
Tensor b;
Tensor r;

int _err_ = 0;

int main(){
    	initMemPool(&pool,1,NPAGES);
	//define tensor
	const TensorDataType dataType = u64;
	const int8_t row_major_form = 1;
	const uint32_t ndim  = 3;
	// const uint32_t dx = 3,dim_dx = 1;

	a.descriptor.data_type = dataType;
	a.descriptor.row_major_form = row_major_form;
	a.descriptor.number_of_dimensions = ndim;
	a.descriptor.dimensions[0] = 5;
	a.descriptor.dimensions[1] = 5;
	a.descriptor.dimensions[2] = 3;

	b.descriptor.data_type = dataType;
	b.descriptor.row_major_form = row_major_form;
	b.descriptor.number_of_dimensions = ndim-1;
	b.descriptor.dimensions[0] = 3;
	b.descriptor.dimensions[1] = 3;
	b.descriptor.dimensions[2] = 3;

    r.descriptor.data_type = dataType;
	r.descriptor.row_major_form = row_major_form;
	r.descriptor.number_of_dimensions = ndim;
    r.descriptor.dimensions[0] = 3;
	r.descriptor.dimensions[1] = 3;
	r.descriptor.dimensions[2] = 1;
	
	//create tensor
    _err_ = createTensorAtHead(&a,&pool) + _err_;
    _err_ = createTensorAtHead(&b,&pool) + _err_;
    _err_ = createTensorAtHead(&r,&pool) + _err_;

    if(_err_!=0)
		fprintf(stderr,"create Tensor FAILURE.\n");

    fprintf(stderr,"1*****\n");

	//fill tensor A values
	/*
		{{1, 2, 3, 4},
		 {5, 6, 7, 8},
		 {...}
		 {13, ..., 16}}
	*/
	uint64_t init_a = 5;
	uint64_t init_b = 1;
	_err_ += initializeTensor(&a, &init_a);
	_err_ += initializeTensor(&b, &init_b);
	if(_err_ != 0){
		fprintf(stderr, "Initialise failed");
	}
    int strides[2] = {1, 1}; //non zero
    int padding[4] = {0, 0, 0, 0};

    new_convTensors(&a, &b, &r, strides, padding);

	// printf("\nTensor A\n");
	// print2dTensor(&a,&req,&resp);
	// printf("\nTensor B\n");
	// print2dTensor(&b,&req,&resp);
	_err_ += writeTensorToFile("./a.csv", &a);
	_err_ += writeTensorToFile("./b.csv", &b);
	_err_ += writeTensorToFile("./r.csv", &r);
	
	if(_err_ != 0){
		fprintf(stderr, "Conv failed");
	}

	// printf("%" PRIx64 "",b.mem_pool_identifier->mem_pool_buffer[b.mem_pool_buffer_pointer+1]);
}
