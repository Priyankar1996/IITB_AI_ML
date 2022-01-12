#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"
#include "convolution_transpose.h"

int main()
{
    SizedTensor_256K input, output, dilated;
    SizedTensor_4096 kernel;
    int stride[2] = {0,0}, padding = 0;
    //Fill input and kernel tensors with random values.
    
    //Perform the two operations.
    __DilateTensors__(input,kernel,stride,dilated);
    __DepadTensors__(dilated,padding,output);

    //View output
}