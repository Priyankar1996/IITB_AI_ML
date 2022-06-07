#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution_transpose_improved.h"

SizedTensor_64K input;
SizedTensor_512 K1;
SizedTensor_8K K2;
SizedTensor_512K C1, C2;
SizedTensor_128K M1;


void systemTOP()
{
    fill_input();
    convTensors1();
    convTensors2();
    maxPool1();
    convTensors3();
}
