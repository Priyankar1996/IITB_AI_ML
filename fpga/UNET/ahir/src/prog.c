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
    convolution3D(224,224,64,3,0,0,0,226,relu);
    zeropadE1_2();
    convolution3D(224,224,64,64,1,1,1,226,relu);
    maxPool3D(112,112,224,64,0,0);
    zeropadE2_1();
    convolution3D(112,112,128,64,2,2,2,114,relu);
    zeropadE2_2();
    convolution3D(112,112,128,128,3,3,3,114,relu);
    maxPool3D(56,56,112,128,1,1);
    zeropadE3_1();
    convolution3D(56,56,256,128,4,4,4,58,relu);
    zeropadE3_2();
    convolution3D(56,56,256,256,5,5,5,58,relu);
    maxPool3D(28,28,56,256,2,2);

    zeropadM_1();
    convolution3D(28,28,512,256,6,6,6,30,relu);
    zeropadM_2();
    convolution3D(28,28,512,512,7,7,7,30,relu);

    convTranspose3();
    zeropadT_3();
    convolution3D(56,56,256,512,8,8,8,58,relu);
    concat3();
    zeropadD3_1();
    convolution3D(56,56,256,512,9,9,9,58,relu);
    zeropadD3_2();
    convolution3D(56,56,256,256,10,10,10,58,relu);

    convTranspose2();
    zeropadT_2();
    convolution3D(112,112,128,256,11,11,11,114,relu);
    concat2();
    zeropadD2_1();
    convolution3D(112,112,128,256,12,12,12,114,relu);
    zeropadD2_2();
    convolution3D(112,112,128,128,13,13,13,114,relu);

    convTranspose1();
    zeropadT_1();
    convolution3D(224,224,64,128,14,14,14,226,relu);
    concat1();
    zeropadD1_1();
    convolution3D(224,224,64,128,15,15,15,226,relu);
    zeropadD1_2();
    convolution3D(224,224,64,64,16,16,16,226,relu);

    zeropadL();
    convolution3D(224,224,3,64,17,17,17,226,sigmoid);
    //Final stage is a sigmoid activation       
}
