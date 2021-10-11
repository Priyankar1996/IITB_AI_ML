#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
// #include <math.h>
#include "readWriteTensorsFromStandardIO.h"
#include "createTensor.h"
#include "conv.h"

#define NPAGES 1024

MemPool pool;

Tensor a;
Tensor b;
Tensor r;

int _err_ = 0;

int main(){
	//Initialize memory pool
    	initMemPool(&pool,1,NPAGES);
	
	//create tensors
	//printf("Creation started\n");
	printf("Initialization started\n");
	readTensorFromFile("../../../students/deval/convolution/bin/a.csv",&a,&pool);
	printf("Initialization of a completed\n");
	readTensorFromFile("../../../students/deval/convolution/bin/b.csv",&b,&pool);
	printf("Initialization of b completed\n");
    	_err_ = createTensorAtHead(&r,&pool) + _err_;
	//printf("Creation completed\n");

	if(_err_!=0)
		fprintf(stderr,"create Tensor FAILURE.\n");

    	int strides[2] = {1, 1}; //non zero
    	int padding[4] = {0, 0, 0, 0};

	//fill output tensor descriptor
	updateOutputDescriptorConvTensors(&a, &b, &r, strides, padding);
	//perform convolution
    	_err_ += new_convTensors(&a, &b, &r, strides, padding);

	//Exit function if there is any error
	if(_err_ != 0){
		fprintf(stderr, "ERROR : Convolution failed\n");
		exit(1);
	}

	//Write back the result tensor to output file
	_err_ += writeTensorToFile("../../../students/deval/convolution/bin/r.csv", &r);

	return 0;
}
