#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "createTensor.h"
#include "conv.h"
#include "convolutionTranspose.h"
#include "readWriteTensorsFromStandardIO.h"

MemPool pool1;
Tensor input,kernel,intermediate_dilate,intermediate_depad,output;

#define MAX_PAGES 10

int main()
{
    int _err_ = 0;
    initMemPool(&pool1,1,MAX_PAGES);
    uint32_t stride[2]={2,2}, padding[4] = {0,0,0,0};
    uint8_t val = 3,val1 = 0;

    input.descriptor.data_type = 0;
    input.descriptor.row_major_form = 1;
    input.descriptor.number_of_dimensions = 3;
    input.descriptor.dimensions[0] = 3;
    input.descriptor.dimensions[1] = 3;
    input.descriptor.dimensions[2] = 1;

    kernel.descriptor.data_type = 0;
    kernel.descriptor.row_major_form = 1;
    kernel.descriptor.number_of_dimensions = 2;
    kernel.descriptor.dimensions[0] = 2;
    kernel.descriptor.dimensions[1] = 2;
    kernel.descriptor.dimensions[2] = 1;

	intermediate_dilate.descriptor.data_type = 0;
    intermediate_dilate.descriptor.row_major_form = 1;
    intermediate_dilate.descriptor.number_of_dimensions = 3;
    intermediate_dilate.descriptor.dimensions[0] = 7;
    intermediate_dilate.descriptor.dimensions[1] = 7;
    intermediate_dilate.descriptor.dimensions[2] = 1;

    intermediate_depad.descriptor.data_type = 0;
    intermediate_depad.descriptor.row_major_form = 1;
    intermediate_depad.descriptor.number_of_dimensions = 3;
    intermediate_depad.descriptor.dimensions[0] = 5;
    intermediate_depad.descriptor.dimensions[1] = 5;
    intermediate_depad.descriptor.dimensions[2] = 1;

    _err_ = createTensor(&input,&pool1)  ||
            createTensor(&kernel,&pool1) ||
			createTensor(&intermediate_dilate,&pool1) ||
            createTensor(&intermediate_depad,&pool1)  ||
            initializeTensor(&input,&val) ||
            initializeTensor(&kernel,&val) || _err_;

    _err_ = dilateTensor(&input,&kernel,stride,&intermediate_dilate) || 
            dePadTensor(&intermediate_dilate,1,&intermediate_depad) ||
			writeTensorToFile("util/sample_csv/transConv.csv", &intermediate_dilate) ||
            _err_;
}