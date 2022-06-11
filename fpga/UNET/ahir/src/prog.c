#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"

SizedTensor_64K input, output;

SizedTensor_512 KE1_1, KL;
SizedTensor_8K KE1_2, KD1_2;
SizedTensor_16K KT1, KE2_1, KD1_1;
SizedTensor_32K KE2_2, KD2_2;
SizedTensor_64K KE3_1, KT2, KD2_1;
SizedTensor_128K KE3_2, KD3_2;
SizedTensor_256K KM1, KT3, KD3_1;
SizedTensor_512K KM2;

SizedTensor_32K M3;
SizedTensor_64K M2, CM1, CM2;
SizedTensor_128K M1, CE3_1, CE3_2, T3, CD3_1, CD3_2;
SizedTensor_256K CE2_1, CE2_2, CO3, T2, CD2_1, CD2_2;
SizedTensor_512K CE1_1, CE1_2, CO2, T1, CD1_1, CD1_2;
SizedTensor_1M CO1;

void systemTOP()
{
    fill_input();
    convTensorsE1_1();
    convTensorsE1_2();
    maxPool1();
    convTensorsE2_1();
    convTensorsE2_2();
    maxPool2();
    convTensorsE3_1();
    convTensorsE3_2();
    maxPool3();

    convTensorsM_1();
    convTensorsM_2();

    convTranspose3();
    concat3();
    convTensorsD3_1();
    convTensorsD3_2();

    convTranspose2();
    concat2();
    convTensorsD2_1();
    convTensorsD2_2();

    convTranspose1();
    concat1();
    convTensorsD1_1();
    convTensorsD1_2();

    convTensorsL();
       
}
