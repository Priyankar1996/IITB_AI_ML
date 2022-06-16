#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"

SizedTensor_64K input, output;
SizedTensor_64K KE3_1, KT2, KD2_1;
SizedTensor_64K M2, CM1, CM2;

SizedTensor_512 KE1_1, KL;
SizedTensor_8K KE1_2, KD1_2;
SizedTensor_16K KT1, KE2_1, KD1_1;
SizedTensor_32K KE2_2, KD2_2;
SizedTensor_32K M3;
SizedTensor_128K KE3_2, KD3_2;
SizedTensor_128K M1, CE3_1, CE3_2, T3, CD3_1, CD3_2,ZE3_1, ZE3_2, ZD3_1, ZD3_2;
SizedTensor_256K KM1, KT3, KD3_1;
SizedTensor_256K ZE2_1, ZE2_2, CE2_1, CE2_2, CO3, T2, ZD2_1, ZD2_2, CD2_1, CD2_2;
SizedTensor_512K KM2;
SizedTensor_512K ZE1_1, ZE1_2, CE1_1, CE1_2, CO2, T1, CD1_1, CD1_2, ZD1_1, ZD1_2;
SizedTensor_1M CO1;

void systemTOP()
{
    fill_input();
	zeropadE1_1();
    convTensorsE1_1();
    zeropadE1_2();
    convTensorsE1_2();
    maxPool1();
    zeropadE2_1();
    convTensorsE2_1();
    zeropadE2_2();
    convTensorsE2_2();
    maxPool2();
    zeropadE3_1();
    convTensorsE3_1();
    zeropadE3_2();
    convTensorsE3_2();
    maxPool3();

    zeropadM_1();
    convTensorsM_1();
    zeropadM_2();
    convTensorsM_2();

    convTranspose3();
    zeropadT_3();
    convTensorT_3();
    concat3();
    zeropadD3_1();
    convTensorsD3_1();
    zeropadD3_2();
    convTensorsD3_2();

    convTranspose2();
    zeropadT_2();
    convTensorT_2();
    concat2();
    zeropadD2_1();
    convTensorsD2_1();
    zeropadD2_2();
    convTensorsD2_2();

    convTranspose1();
    zeropadT_1();
    convTensorT_1();
    concat1();
    zeropadD1_1();
    convTensorsD1_1();
    zeropadD1_2();
    convTensorsD1_2();

    zeropadL();
    convTensorsL();
    //Final stage is a sigmoid activation       
}
