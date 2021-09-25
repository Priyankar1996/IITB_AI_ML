#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
// #include <math.h>
#include "../src/readWriteTensorsFromStandardIO.c"
#include "../src/createTensor.c"
#include "../src/my_conv.c"
#include "../src/mempool.c"
#include "../src/tensor.c"
#include "../src/genRandomTensor.c"

#define NPAGES 3

MemPool 	pool;

Tensor a;
Tensor b;
Tensor r;

int _err_ = 0;

int main(){
    initMemPool(&pool,1,NPAGES);
	//define tensor
	const TensorDataType dataType = float64;
	const int8_t row_major_form = 1;
	const uint32_t ndim  = 3;
	// const uint32_t dx = 3,dim_dx = 1;

	a.descriptor.data_type = dataType;
	a.descriptor.row_major_form = row_major_form;
	a.descriptor.number_of_dimensions = ndim;
	a.descriptor.dimensions[0] = 4;  // Also simply tried 4
	a.descriptor.dimensions[1] = 4;  // Also simply tried 4
	a.descriptor.dimensions[2] = 1;  // Also simply tried 1

	b.descriptor.data_type = dataType;
	b.descriptor.row_major_form = row_major_form;
	b.descriptor.number_of_dimensions = ndim;
	b.descriptor.dimensions[0] = 3; 
	b.descriptor.dimensions[1] = 3;
	b.descriptor.dimensions[2] = 1; // Also simply tried 1

	/*
    r.descriptor.data_type = dataType;
	r.descriptor.row_major_form = row_major_form;
	r.descriptor.number_of_dimensions = ndim;
    r.descriptor.dimensions[0] = 2;
	r.descriptor.dimensions[1] = 2;
	r.descriptor.dimensions[2] = 1;
	*/
	
	//create tensor
    _err_ = createTensorAtHead(&a,&pool) + _err_;
    _err_ = createTensorAtHead(&b,&pool) + _err_;
    //_err_ = createTensorAtHead(&r,&pool) + _err_;

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
	double init_val = 1;
	_err_ += initializeTensor(&a, &init_val);
	init_val = 3;
	//_err_ += initializeTensor(&b, &init_val);
	if(_err_ != 0){
		fprintf(stderr, "Initialise failed");
	}
	RngType re = mersenne_Twister;
	genRandomTensor(17, re, &b);
    int strides[3] = {1, 1, 1}; //non zero also simply tried {1, 1, 1}
    int padding[6] = {0, 0, 0, 0, 0, 0}; // Also simply tried all 0

    convTensors(&a, &b, &r, &pool, strides, padding);

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
	return 0;
	// printf("%" PRIx64 "",b.mem_pool_identifier->mem_pool_buffer[b.mem_pool_buffer_pointer+1]);
}

