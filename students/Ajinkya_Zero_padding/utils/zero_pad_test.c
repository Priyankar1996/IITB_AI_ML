#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "../include/readWriteTensorsFromStandardIO.h"
#include "../include/createTensor.h"
#include "../include/zero_pad.h"
#include "../include/mempool.h"
#include "../include/tensor.h"

#define NPAGES 1024

MemPool pool;

Tensor a;
Tensor b;

int _err1_ = 0;

int main(){
	//Initialize memory pool
    	initMemPool(&pool,1,NPAGES);
	
	//create tensors
	printf("Initialization started\n");
	_err1_ = readTensorFromFile("./utils/a.csv",&a);
	printf("Initialization of a completed\n");
    	_err1_ = createTensorAtHead(&a,&pool) + _err1_;

	if(_err1_!=0)
		fprintf(stderr,"create Tensor FAILURE.\n");

    
	//fill output tensor descriptor
	uint32_t scale_factor = 1;


    // Creating the destination tensor or the final Zero-padded tensor 
    // by using the details of the source tensor and the scale factor
    b.descriptor.data_type = a.descriptor.data_type;
    b.descriptor.row_major_form = a.descriptor.row_major_form;
    b.descriptor.number_of_dimensions = a.descriptor.number_of_dimensions;
    for (int i=0;i<a.descriptor.number_of_dimensions;i++)
    {
        b.descriptor.dimensions[i] = a.descriptor.dimensions[i] + 2*scale_factor;
    }
	

	//Exit function if there is any error
    _err1_ = createTensorAtHead(&b,&pool) + _err1_;
	if(_err1_ != 0){
		fprintf(stderr, "ERROR : Create tensor failed\n");
		exit(1);
	}

    _err1_ = initializeTensor(&b,&pool) + _err1_;
    if(_err1_ != 0){
        fprintf(stderr, "ERROR : Initialize tensor failed\n");
        exit(1);
    }

    
    printf("\n Completed!!");  
    // Zero-padding the the source tensor in order to generate the
    // padded tensor
    zero_pad(&a,scale_factor,&b);
    printf("\n ZeroPad Completed!!");

	//Write back the result tensor to output file
	_err1_ += writeTensorToFile("./utils/b.csv", &b);
    if(_err1_ != 0){
        fprintf(stderr, "ERROR : Write tensor failed\n");
        exit(1);
    }
	return 0;
}
