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

#define MAX_PAGES 50

int main()
{
    int _err_ = 0;
    initMemPool(&pool1,1,MAX_PAGES);
    uint32_t stride[2]={2,2}, padding[4] = {0,0,0,0}, depad = 1;
    uint8_t val = 33;float val1 = 11.0;
    float val2= 21.3;

    input.descriptor.data_type = float32;
    input.descriptor.row_major_form = 1;
    input.descriptor.number_of_dimensions = 3;
    input.descriptor.dimensions[0] = 30;
    input.descriptor.dimensions[1] = 30;
    input.descriptor.dimensions[2] = 3;

    kernel.descriptor.data_type = float32;
    kernel.descriptor.row_major_form = 1;
    kernel.descriptor.number_of_dimensions = 4;
    kernel.descriptor.dimensions[0] = 1;
    kernel.descriptor.dimensions[1] = 2;
    kernel.descriptor.dimensions[2] = 2;
    kernel.descriptor.dimensions[3] = 3;

	//intermediate_dilate.descriptor.data_type = float32;
    //intermediate_dilate.descriptor.row_major_form = 1;
    //intermediate_dilate.descriptor.number_of_dimensions = 3;
    //intermediate_dilate.descriptor.dimensions[0] = 3;
    //intermediate_dilate.descriptor.dimensions[1] = 3;
    //intermediate_dilate.descriptor.dimensions[2] = 3;

    //intermediate_depad.descriptor.data_type = float32;
    //intermediate_depad.descriptor.row_major_form = 1;
    //intermediate_depad.descriptor.number_of_dimensions = 3;
    //intermediate_depad.descriptor.dimensions[0] = 3;
    //intermediate_depad.descriptor.dimensions[1] = 3;
    //intermediate_depad.descriptor.dimensions[2] = 3;

    _err_ = createTensorAtHead(&input,&pool1)  ||
            createTensorAtHead(&kernel,&pool1);
            
            updateOutputSDescriptorDilateTensors(&input, &kernel, stride, &intermediate_dilate);    
            updateOutputSDescriptorDepadTensors(&intermediate_dilate, depad, &intermediate_depad);                                    
	
    _err_ =	createTensorAtHead(&intermediate_dilate,&pool1) ||
            createTensorAtHead(&intermediate_depad,&pool1)  ||
            initializeTensor(&input,&val1) ||
            initializeTensor(&kernel,&val1) || _err_;

    _err_ = dilateTensor(&input,&kernel,stride,&intermediate_dilate) || 
            dePadTensor(&intermediate_dilate,depad,&intermediate_depad) ||
            writeTensorToFile("util/sample_csv/transConvinput.csv", &input) ||
			writeTensorToFile("util/sample_csv/transConvdilate.csv", &intermediate_dilate) ||
            writeTensorToFile("util/sample_csv/transConvdepad.csv", &intermediate_depad) ||
            _err_;
}