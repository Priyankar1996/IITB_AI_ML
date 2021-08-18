#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "conv.h"
#include "convolutionTranspose.h"
#include "readWriteTensorsFromStandardIO.h"

MemPool pool1;
Tensor input,kernel,intermediate,output;

#define MAX_PAGES 10

int main()
{
    int _err_ = 0;
    initMemPool(&pool1,1,MAX_PAGES);
    uint32_t stride[2]={2,2}, padding[4] = {0,0,0,0};
    uint8_t val = 1,val1 = 0;

    input.descriptor.data_type = 0;
    input.descriptor.row_major_form = 1;
    input.descriptor.number_of_dimensions = 3;
    input.descriptor.dimensions[0] = 3;
    input.descriptor.dimensions[1] = 3;
    input.descriptor.dimensions[2] = 1;

    kernel.descriptor.data_type = 0;
    kernel.descriptor.row_major_form = 1;
    kernel.descriptor.number_of_dimensions = 3;
    kernel.descriptor.dimensions[0] = 2;
    kernel.descriptor.dimensions[1] = 2;
    kernel.descriptor.dimensions[2] = 1;

	intermediate.descriptor.data_type = 0;
    intermediate.descriptor.row_major_form = 1;
    intermediate.descriptor.number_of_dimensions = 3;
    intermediate.descriptor.dimensions[0] = 7;
    intermediate.descriptor.dimensions[1] = 7;
    intermediate.descriptor.dimensions[2] = 1;

    output.descriptor.data_type = 0;
    output.descriptor.row_major_form = 1;
    output.descriptor.number_of_dimensions = 3;
    output.descriptor.dimensions[0] = 6;
    output.descriptor.dimensions[1] = 6;
    output.descriptor.dimensions[2] = 1;

    _err_ = createTensor(&input,&pool1)  ||
            createTensor(&kernel,&pool1) ||
			createTensor(&intermediate,&pool1) ||
            createTensor(&output,&pool1)  ||
            initializeTensor(&input,&val) ||
            initializeTensor(&kernel,&val) || _err_;

    _err_ = convTranspose(&input,&kernel,&intermediate,stride,padding,0,&output) || 
			writeTensorToFile("util/sample_csv/transConv.csv", &intermediate) ||
            _err_;
}