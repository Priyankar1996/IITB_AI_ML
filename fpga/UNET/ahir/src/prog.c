#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "concat.h"
#include "zeropad.h"
#include "convolution.h"
#include "convTranspose.h"
#include "maxPool.h"

void concat(uint16_t input1_dim0, uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0,      uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index0,uint8_t index1,uint8_t index2);
void zeropad(uint16_t input_dim0,uint16_t input_dim1,uint16_t input_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);
void convolution3D(uint16_t rb, uint16_t cb, uint16_t chl_out, uint16_t chl_in, uint8_t index_in, uint8_t index_k, uint8_t index_out, uint16_t ct, uint8_t activation);
void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1, uint8_t index2);
void maxPool3D(uint16_t cb, uint16_t rb, uint16_t ct, uint16_t chl_out, uint8_t index_in, uint8_t index_out);

SizedTensor_64K input, output;
SizedTensor_64K KE3_1, KT2, KD2_1;
SizedTensor_64K M2, CM1, CM2, ZM1, ZM2;

SizedTensor_512 KE1_1, KL;
SizedTensor_8K KE1_2, KD1_2;
SizedTensor_16K KT1, KE2_1, KD1_1;
SizedTensor_32K KE2_2, KD2_2;
SizedTensor_32K M3;
SizedTensor_128K KE3_2, KD3_2;
SizedTensor_128K M1, CE3_1, CE3_2, T3, CD3_1, CD3_2,ZE3_1, ZE3_2, ZD3_1, ZD3_2, ZL;
SizedTensor_256K KM1, KT3, KD3_1;
SizedTensor_256K ZE2_1, ZE2_2, CE2_1, CE2_2, CO3, T2, ZD2_1, ZD2_2, CD2_1, CD2_2;
SizedTensor_512K KM2;
SizedTensor_512K ZE1_1, ZE1_2, CE1_1, CE1_2, CO2, T1, CD1_1, CD1_2, ZD1_1, ZD1_2;
SizedTensor_1M CO1;

void systemTOP()
{
    fill_input();
	zeropad(224,224,3,226,226,30,0,0);
    convolution3D(224,224,64,3,0,0,0,226,relu);
    zeropad(224,224,64,226,226,64,1,1);
    convolution3D(224,224,64,64,1,1,1,226,relu);
    maxPool3D(112,112,224,64,0,0);
    zeropad(112,112,64,114,114,64,2,2);
    convolution3D(112,112,128,64,2,2,2,114,relu);
    zeropad(112,112,128,114,114,128,3,3);
    convolution3D(112,112,128,128,3,3,3,114,relu);
    maxPool3D(56,56,112,128,1,1);
    zeropad(56,56,112,58,58,112,4,4);
    convolution3D(56,56,256,128,4,4,4,58,relu);
    zeropad(56,56,256,58,58,256,5,5);
    convolution3D(56,56,256,256,5,5,5,58,relu);
    maxPool3D(28,28,56,256,2,2);

    zeropad(28,28,512,30,30,512,6,6);
    convolution3D(28,28,512,256,6,6,6,30,relu);
    zeropad(28,28,512,30,30,512,7,7);
    convolution3D(28,28,512,512,7,7,7,30,relu);

    convTranspose(28,28,512,2,2,2,0,57,57,512,3,3);
    convolution3D(56,56,256,512,8,8,8,58,relu);
    concat(56,56,256,56,56,256,56,56,512,3,3,3);
    zeropad(56,56,512,58,58,512,9,9);
    convolution3D(56,56,256,512,9,9,9,58,relu);
    zeropad(56,56,256,58,58,256,10,10);
    convolution3D(56,56,256,256,10,10,10,58,relu);

    convTranspose(56,56,256,2,2,2,0,113,113,256,2,2);
    convolution3D(112,112,128,256,11,11,11,114,relu);
    concat(112,112,128,112,112,128,112,112,256,2,2,2);
    zeropad(112,112,256,114,114,256,12,12);
    convolution3D(112,112,128,256,12,12,12,114,relu);
    zeropad(112,112,128,114,114,128,13,13);
    convolution3D(112,112,128,128,13,13,13,114,relu);

    convTranspose(112,112,256,2,2,2,0,225,225,256,1,1);
    convolution3D(224,224,64,128,14,14,14,226,relu);
    concat(224,224,64,224,224,64,224,224,128,1,1,1);
    zeropad(224,224,128,226,226,128,15,15);
    convolution3D(224,224,64,128,15,15,15,226,relu);
    zeropad(224,224,64,226,226,64,16,16);
    convolution3D(224,224,64,64,16,16,16,226,relu);

    zeropad(224,224,64,226,226,64,17,17);
    convolution3D(224,224,3,64,17,17,17,226,sigmoid);
    //Final stage is a sigmoid activation       
}
