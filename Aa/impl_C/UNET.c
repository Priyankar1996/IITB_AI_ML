// UNET model for image segmentation
// AUTHORS : Aman Dhammani , Priyankar Sarkar
// Department of Electrical Engineering, IITB

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"
#include "maxPoolOfTensors.h"
#include "createTensor.h"
#include "conv.h"
#include "convolutionTranspose.h"
#include "unary_fn.h"
#include "readWriteTensorsFromStandardIO.h"
// #include "batchNormalization.h"
#include "concat.h"


//         
// INPUTS...
//    num_iters = 3
//   "Updated_weights/T0.csv"
//		contains the source image...
//   "Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv"
//           for %d=0,1,2,3,4,5     (these are specified kernels) in the encoder stage
//           for %d=6,7             (these are specified kernels) in the middle stage
//           for %d=8,9,10,11,12,13 (these are specified kernels) in the decoder stage
//           for %d=14              for obtaining the final output.
//   "Updated_weights/Parameters/BN/%dbatch_normalization_%dgamma.csv"
//   "Updated_weights/Parameters/BN/%dbatch_normalization_%dbeta.csv"
//   "Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_mean.csv"
//   "Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_variance.csv"
//           for %d=0,1,2,3,4,5     (these are specified kernels) in the encoder stage
//           for %d=6,7             (these are specified kernels) in the middle stage
//           for %d=8,9,10,11,12,13 (these are specified kernels) in the decoder stage
//   "Updated_weights/Parameters/ConvT/%dconv2d_transpose_%dkernel.csv"
//           for %d=0,1,2           (these are specified kernels) in the decoder stage
//
//
// INTERMEDIATES (for debugging)...
//   "intermediateTensors/EncoderIn%d.txt"
//	     for %d = 0,1,2  (intermediate outputs after each iteration).
//   "intermediateTensors/Conv%d.txt"
//           for %d =0,1,2,3,4,5     (intermediate result of convolution in the encoder stage)
//           for %d =6,7             (intermediate result of convolution in the middle stage)
//           for %d =8,9,10,11,12,13 (intermediate result of convolution in the decoder stage)
//   "intermediateTensors/BN%d.txt"
//           for %d=0,1,2,3,4,5      (intermediate result of batch_norm in the encoder stage)
//           for %d=6,7              (intermediate result of batch_norm in the middle stage)
//           for %d=8,9,10,11,12,13  (intermediate result of batch_norm in the decoder stage)
//   "intermediateTensors/Relu%d.txt"
//           for %d=0,1,2,3,4,5      (intermediate result of unaryOperateOnTensors in the encoder stage)
//           for %d=6,7              (intermediate result of unaryOperateOnTensors in the middle stage)
//           for %d=8,9,10,11,12,13  (intermediate result of unaryOperateOnTensors in the decoder stage)
//   "intermediateTensors/MP%d.txt"
//           for %d=0,1,2            (intermediate result of maxPoolOnTensors)
//   "intermediateTensors/Concat%d.txt"
//           for %d=0,1,2            (intermediate result of concatTensors)
//   "intermediateTensors/Dilate%d.txt"
//           for %d=0,1,2            (intermediate result of dilateTensors)
//   "intermediateTensors/Depad%d.txt"
//           for %d=0,1,2            (intermediate result of depadTensors)
//   "intermediateTensors/ConvT%d.txt"
//           for %d=0,1,2            (intermediate result of convolutionTranpose post dilate and depad)
//
//
// OUTPUTS
//    "GeneratedImage.csv", the final image...
//

// // We have three memory pools
// #define INPUT_POOL	1
// #define KERNEL_POOL	2
// #define OUTPUT_POOL	3

int num_iters = 3;
int pad[4] = {1,1,1,1};
int str = 1;
int stride[2] = {str,str};
int dim_to_pool[2] = {0,1};
int pad_deconv = 1;
int new_pad[4] = {0,0,0,0};
uint32_t str_dec[2] = {2,2};

SizedTensor_8M    T;
SizedTensor_1024  K;
SizedTensor_8M    S;
SizedTensor_8M    R0, R1, R2;
SizedTensor_1024  beta, gamma, moving_mean, moving_variance;

#define EncodingIteration(K,S,T,stride,pad,R,dim_to_pool) {\
		__readSizedTensorFromInputDataPipe__(K);\
		?? ZERO PAD ??\
		__convTensors__(T,K,S,stride,pad);\
		__unaryOperateOnTensor__(S,RELU_OP);\
		__readSizedTensorFromInputDataPipe__(K);\
		?? ZERO PAD ??\
		__convTensors__(S,K,R,stride,pad);\
		__unaryOperateOnTensor__(R, RELU_OP);\
		__maxPoolOfTensors__(R, T, 2, 2, 2, dim_to_pool, 0);}

#define DecodingIteration(K,S,T,decode_stride, stride,pad,R) {\
		__readSizedTensorFromInputDataPipe__(K);\
		__dilateTensor__(T,K,S, decode_stride);\
		__depadTensor(S,T, deconv_pad);\
		?? ZERO PAD ??\
		__convTensors__(T,K,S, stride, pad);\
		__concatTensorsAlongDim(S,R, T, 2);\
		__readSizedTensorFromInputDataPipe__(K);\
		?? ZERO PAD ??\
		__convTensors__(T,K,S, stride, pad);\
		__unaryOperateOnTensor__(S, RELU_OP);\
		__readSizedTensorFromInputDataPipe__(K);\
		?? ZERO PAD ??\
		__convTensors__(S,K,T, stride, pad);\
		__unaryOperateOnTensor__(T, RELU_OP);}

int main_revised()
{
	__readSizedTensorFromInputDataPipe__(T);
	EncodingIteration (K,S,T,stride,pad,R0);
	EncodingIteration (K,S,T,stride,pad,R1);
	EncodingIteration (K,S,T,stride,pad,R2);

	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(T,K,S,stride,pad);
	__unaryOperateOnTensor__(S, RELU_OP);
	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(S,K,T,stride,pad);
	__unaryOperateOnTensor__(T, RELU_OP);

	DecodingIteration(K,S,T,decode_stride,stride,pad,R2);
	DecodingIteration(K,S,T,decode_stride,stride,pad,R1);
	DecodingIteration(K,S,T,decode_stride,stride,pad,R0);

	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(T,K,S, stride, pad);
	__writeTensorToOutputDataPipe__(S);
}

int main()
{
	__readSizedTensorFromInputDataPipe__(T);
	//encoding loop
	for(int i=0;i<num_iters;i++)
	{
		//Read kernel_tensor from file and create.
		__readSizedTensorFromInputDataPipe__(K);

		// Write a macro
		__convTensors__(T,K,S,stride,pad);

		// implicit Tensor arguments gamma, beta, moving_mean, moving_variance, S
		__batch__(S, gamma, beta, moving_mean, moving_variance, 2*i)

		__unaryOperateOnTensor__(S,RELU_OP);

		// read tensor into K
		__readSizedTensorFromInputDataPipe__(K);


		//Compute output size, create the tensor and convolve.
		__convTensors__(S,K,(R[i]),stride,pad);
		__batch__((R[i]), gamma, beta, moving_mean, moving_variance, ((2*i)+1))

	
		__unaryOperateOnTensor__((R[i]), RELU_OP);

		//Maxpool the output tensor of previous stage for dimensionality reduction.
		__maxPoolOfTensors__((R[i]), T, 2, 2, 2, dim_to_pool, 0);
	} 

	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(T,K,S,stride,pad);

	__batch__(S, gamma, beta, moving_mean, moving_variance, (2*num_iters));
	__unaryOperateOnTensor__(S, RELU_OP);


	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(S,K,T,stride,pad);


	__batch__(T, gamma, beta, moving_mean, moving_variance, ((2*num_iters)+1));
	__unaryOperateOnTensor__(T, RELU_OP);

	//decoding loop
	for(int i = 1; i <= num_iters; i++)
	{
		__readSizedTensorFromInputDataPipe__(K);
		__dilateTensor__(T,K,S, decode_stride);

		__depadTensor(S,T, deconv_pad);
		__convTensors__(T,K,S, stride, pad);


		//Concat output tensor of convTranspose with that of the convolved tensor from input state.
		__concatTensorsAlongDim(S,(R[num_iters-i]), T, 2);

		__readSizedTensorFromInputDataPipe__(K);
		__convTensors__(T,K,S, stride, pad);

		__batch__(S, gamma, beta, moving_mean, moving_variance, ((2*(num_iters+i))));
		__unaryOperateOnTensor__(S, RELU_OP);


		__readSizedTensorFromInputDataPipe__(K);
		__convTensors__(S,K,T, stride, pad);

		__batch__(T, gamma, beta, moving_mean, moving_variance, ((2*(num_iters+i))+1));
		__unaryOperateOnTensor__(T, RELU_OP);

	}

	__readSizedTensorFromInputDataPipe__(K);
	__convTensors__(T,K,S, stride, pad);
	__writeTensorToOutputDataPipe__(S);
}
