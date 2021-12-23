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

//fill output tensor descriptor
void copyTensorDescriptor(Tensor *src, Tensor *dst)
{
    dst->descriptor.data_type = src->descriptor.data_type;
    dst->descriptor.row_major_form = src->descriptor.row_major_form;
    dst->descriptor.number_of_dimensions = src->descriptor.number_of_dimensions;

    for (int i = 0; i < src->descriptor.number_of_dimensions; i++)
    {
        dst->descriptor.dimensions[i] = src->descriptor.dimensions[i];
    }
}

//wrapper for batch normalisation. 
void batch(int x,
		MemPool*kernel_pool,
		Tensor*gamma,
		Tensor*beta,
		Tensor*moving_mean,
		Tensor*moving_variance,
		Tensor*T)
{
        char next_file[100];
        //Reads the parameters(gamma,beta,moving_variance,moving_mean) from the necessary files.
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dgamma.csv",x,x);
        readTensorFromFile(next_file,gamma, kernel_pool);
        // writeTensorToFile("gamma.txt",gamma);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dbeta.csv",x,x);
        readTensorFromFile(next_file,beta, kernel_pool);
        // writeTensorToFile("beta.txt",beta);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_mean.csv",x,x);
        readTensorFromFile(next_file,moving_mean, kernel_pool);
        // writeTensorToFile("mm.txt",moving_mean);
        sprintf(next_file,"Updated_weights/Parameters/BN/%dbatch_normalization_%dmoving_variance.csv",x,x);
        readTensorFromFile(next_file, moving_variance, kernel_pool);
        // writeTensorToFile("mv.txt",moving_variance);

        //Performs batch_normalization on input tensors.
        batchNormalization(T, beta, gamma, moving_mean, moving_variance, 0.001);

        destroyTensor(gamma);
        destroyTensor(beta);
        destroyTensor(moving_mean);
        destroyTensor(moving_variance);
}


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

// We have three memory pools
#define INPUT_POOL	1
#define KERNEL_POOL	2
#define OUTPUT_POOL	3

SizedTensor_8M    T;
SizedTensor_1024  K;
SizedTensor_8M    S;
SizedTensor_8M    R;
SizedTensor_1024  beta, gamma, moving_mean, moving_variance;

int main()
{
	//Create and initialize mempools.
	int num_pools = 1;
	int num_pools_k = 1;
	int num_pools_r = 1;

	int num_iters = 3;


	int pad[4] = {1,1,1,1};
	int str = 1;
	int stride[2] = {str,str};
	int dim_to_pool[2] = {0,1};
	int pad_deconv = 1;

	readTensorIntoT();

	//encoding loop
	for(int i=0;i<num_iters;i++)
	{
		//Read kernel_tensor from file and create.
		readTensorIntoK();

		//Calculate the size of the output_tensor and create.
		// Tensor arguments are implicit: T, K, S
		updateOutputDescriptorConvTensors[T,K,S](stride, pad);
		// Tensor argument S
		createTensorInInputPool[T]();
		// Implicit arguments: T, K, S
		new_convTensors[T,K,S](stride,pad );

		// implicit Tensor arguments gamma, beta, moving_mean, moving_variance, S
		batch[S](2*i);

		// unary: implicit argument S
		unaryOperateOnTensor[S](2);

		// TODO: break all allocateAndRead* into two
		//       functions..
		readTensorIntoK();


		//Compute output size, create the tensor and convolve.
		updateOutputDescriptorConvTensors[S,K,R](stride, pad);
		// implicit argument R
		createTensorInOutputPool[R]();
		new_convTensors[S,K,R](stride,pad );

		batch[R](2*i+1);

		unaryOperateOnTensor[R](2);

		//Maxpool the output tensor of previous stage for dimensionality reduction.
		updateOutputDescriptorMaxPoolOfTensors[R,T](str, str, 2,dim_to_pool, 0);
		maxPoolOfTensors[R, T](2, 2, 2,dim_to_pool, 0);
	} 

	// K is read into...
	readTensorIntoKernelPool();
	updateOutputDescriptorConvTensors(&T[num_iters], &K, &S[num_iters], stride, pad);
	createTensorInInputPool(&S[num_iters]);
	new_convTensors(&T[num_iters], &K, &S[num_iters], stride, pad);


	destroyTensorInInputPool(&T[num_iters]);
	destroyTensorInKernelPool(&K);

	batch(2*num_iters,&gamma,&beta,&moving_mean,&moving_variance,&S[num_iters]);
	unaryOperateOnTensorInInputPool(&S[num_iters],2);

	readTensorIntoKernelPool(&K);

	updateOutputDescriptorConvTensors(&S[num_iters], &K, &T[num_iters+1], stride, pad);
	createTensorInInputPool(&T[num_iters+1]);
	new_convTensors(&S[num_iters], &K, &T[num_iters+1] ,stride,pad );

	destroyTensorInKernelPool(&K);
	destroyTensorInInputPool(&S[num_iters]);

	batch(2*num_iters+1,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&T[num_iters+1]);
	unaryOperateOnTensorInInputPool(&T[num_iters+1],2);

	//decoding loop
	for(int i = num_iters+1; i <= 2*num_iters; i++)
	{
		readTensorIntoKernelPool(&K);

		//ConvTranpose for enhancement.
		uint32_t str_dec[2] = {2,2};
		updateOutputSDescriptorDilateTensors(&T[i], &K, str_dec, &S[i]);

		createTensorInInputPool(&S[i],pool,1,1);
		dilateTensor(&T[i],&K,str_dec,&S[i]);

		destroyTensorInInputPool(&T[i]);

		updateOutputSDescriptorDepadTensors(&S[i], pad_deconv, &S[num_iters+i]);
		createTensorInInputPool(&S[num_iters+i]);
		dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);


		destroyTensorInInputPool(&S[i]);

		updateOutputDescriptorConvTensors(&S[num_iters+i], &K, &S[i+3*num_iters], stride, pad);
		createTensorInInputPool(&S[i+3*num_iters]);
		new_convTensors(&S[num_iters+i], &K, &S[i+3*num_iters] ,stride,pad );


		//Concat output tensor of convTranspose with that of the convolved tensor from input state.
		updateOutputDescriptorConcatTensors( &S[3*num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i], 2);
		createTensorInInputPool(&R[num_iters+i]);
		concatTensorsAlongDim(&S[3*num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i],2);

		destroyTensorInInputPool(&S[i+3*num_iters]);

		readTensorIntoKernelPool(&K);

		updateOutputDescriptorConvTensors(&R[num_iters+i], &K, &S[2*num_iters+i], stride, pad);
		createTensorInInputPool(&S[2*num_iters+i]);
		new_convTensors(&R[num_iters+i], &K, &S[2*num_iters+i] ,stride,pad );

		destroyTensorInKernelPool(&K);
		destroyTensorInOutputPool(&R[num_iters+i]);

		batch(2*i,&gamma,&beta,&moving_mean,&moving_variance,&S[2*num_iters+i]);
		unaryOperateOnTensorInInputPool(&S[2*num_iters+i], 2);

		readTensorIntoKernelPool(&K);
		updateOutputDescriptorConvTensors(&S[2*num_iters+i], &K, &T[i+1], stride, pad);
		createTensorInInputPool(&T[i+1]);
		new_convTensors(&S[2*num_iters+i], &K, &T[i+1] ,stride,pad );

		destroyTensorInKernelPool(&K);
		destroyTensorInInputPool(&S[2*num_iters+i]);

		batch(2*i+1,&gamma,&beta,&moving_mean,&moving_variance,&T[i+1]);
		unaryOperateOnTensorInInputPool(&T[i+1], 2);

	}

	readTensorIntoKernelPool(&K);

	int new_pad[4] = {0,0,0,0};
	updateOutputDescriptorConvTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, new_pad);
	createTensorInOutputPool(&T[2*num_iters+2],pool,1,1);
	new_convTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, new_pad);

	destroyTensor(&K);
	writeTensorFromOutputPool(&T[2*num_iters+2]);
}
