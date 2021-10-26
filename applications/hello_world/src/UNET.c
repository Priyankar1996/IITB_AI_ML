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


// translate and scale of 
void batch(int x,
		MemPool*kernel_pool,
		Tensor*gamma,
		Tensor*beta,
		Tensor*moving_mean,
		Tensor*moving_variance,
		Tensor*T)
{
        char next_file[100];
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

        batchNormalization(T, beta, gamma, moving_mean, moving_variance, 0.001);

        destroyTensor(gamma);
        destroyTensor(beta);
        destroyTensor(moving_mean);
        destroyTensor(moving_variance);
}


//
// What are the inputs to this program?
//   Dang! these seem to be hardwired!!  CHANGE IT
//
//              
// INPUTS...
//    num_iters = 3
//   "Updated_weights/T0.csv"
//		contains the source image...
//   "Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv"
//           for %d=0,2,4   (these are specified kernels)
//
// INTERMEDIATES (for debugging)...
//   "intermediateTensors/EncoderIn%d.txt"
//	     for %d = 0,1,2  (intermediate outputs after each iteration).
//   "intermediateTensors/Conv%d.txt"
//           for %d = 0,2,4  (intermediate result of convolution)
//    etc...
//
// OUTPUTS
//    "GeneratedImage.csv", the final image...
//
int main()
{
    //Create and initialize mempools.
    int num_pools = 1;
    int num_pools_k = 1;
    int num_pools_r = 1;
    
    MemPool pool[num_pools];
    for (int i = 0; i < num_pools; i++)
        initMemPool(pool+i,i+1,MAX_MEMPOOL_SIZE_IN_PAGES);

    MemPool kernel_pool[num_pools_k];
    for (int i = 0; i < num_pools_k; i++)
        initMemPool(kernel_pool+i,num_pools+i+1,MAX_MEMPOOL_SIZE_IN_PAGES);
    
    MemPool r_pool[num_pools_r];
    for (int i = 0; i < num_pools_r; i++)
        initMemPool(r_pool+i,num_pools+num_pools_k+i+1,MAX_MEMPOOL_SIZE_IN_PAGES);


    int num_iters = 3;
    
    Tensor T[2*num_iters+3];
    Tensor K;
    Tensor S[5*num_iters];
    Tensor R[4*num_iters];
    Tensor beta, gamma, moving_mean, moving_variance;

    int pad[4] = {1,1,1,1};
    int str = 1;
    int stride[2] = {str,str};
    int dim_to_pool[2] = {0,1};
    int pad_deconv = 1;

    readTensorFromFile("Updated_weights/T0.csv",&T[0],pool);

    char next_file[100];
    char write_file[60];
    //encoding loop
    for(int i=0;i<num_iters;i++)
    {
        fprintf(stderr,"Entering encoder loop %d\n",i+1);

        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i,2*i);
        //Read kernel_tensor from file and create.
        readTensorFromFile(next_file,&K, kernel_pool);
        fprintf(stderr,"K is %u\n",getSizeOfTensor(&K));
        sprintf(write_file,"intermediateTensors/EncoderIn%d.txt",i);
        writeTensorToFile(write_file,&T[i]);

        //Calculate the size of the output_tensor and create.
        updateOutputDescriptorConvTensors(&T[i], &K, &S[i], stride, pad);
        createTensor(&S[i],pool,1,1);
        //Convolution of input_image with kernel(Stage-1).
        new_convTensors(&T[i], &K, &S[i] ,stride,pad );
        sprintf(write_file,"intermediateTensors/Conv%d.txt",2*i);
        writeTensorToFile(write_file,&S[i]);

        //Destroy the input and kernel.
        destroyTensor(&K);
        destroyTensor(&T[i]);
        //Batch normalize the data for cleanup.
        batch(2*i,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[i]);
        sprintf(write_file,"intermediateTensors/BN%d.txt",2*i);
        writeTensorToFile(write_file,&S[i]);
        //point-wise-non-linearity (rectification) on the intermediate tensor.
        unaryOperateOnTensor_inplace(&S[i], 2);
        sprintf(write_file,"intermediateTensors/Relu%d.txt",2*i);
        writeTensorToFile(write_file,&S[i]);

        //Load the kernel for convolution(Stage-2).
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i+1,2*i+1);
        readTensorFromFile(next_file,&K, kernel_pool);
        fprintf(stderr,"K is %u\n",getSizeOfTensor(&K));


        //Compute output size, create the tensor and convolve.
        updateOutputDescriptorConvTensors(&S[i], &K, &R[i], stride, pad);
        createTensor(&R[i],r_pool,1,1);
        new_convTensors(&S[i], &K, &R[i] ,stride,pad );
        sprintf(write_file,"intermediateTensors/Conv%d.txt",2*i+1);
        writeTensorToFile(write_file,&R[i]);

        //Destroy intermediate tensors.
        destroyTensor(&K);
        destroyTensor(&S[i]);

        //Final batch_normalize and linear rectification.
        batch(2*i+1,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&R[i]);
        sprintf(write_file,"intermediateTensors/BN%d.txt",2*i+1);
        writeTensorToFile(write_file,&R[i]);

        unaryOperateOnTensor_inplace(&R[i], 2);
        sprintf(write_file,"intermediateTensors/Relu%d.txt",2*i+1);
        writeTensorToFile(write_file,&R[i]);
        //Maxpool the output tensor of previous stage for dimensionality reduction.
        updateOutputDescriptorMaxPoolOfTensors(&R[i], &T[i+1], str, str, 2,dim_to_pool, 0);
        createTensor(&T[i+1],pool,1,1);
        maxPoolOfTensors(&R[i], &T[i+1], 2, 2, 2,dim_to_pool, 0);
        sprintf(write_file,"intermediateTensors/MP%d.txt",i);
        writeTensorToFile(write_file,&T[i+1]);

        fprintf(stderr,"Completed encoder loop %d\n",i+1);
    } 

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*num_iters,2*num_iters);
    readTensorFromFile(next_file,&K, kernel_pool);

    updateOutputDescriptorConvTensors(&T[num_iters], &K, &S[num_iters], stride, pad);
    createTensor(&S[num_iters],pool,1,1);
    new_convTensors(&T[num_iters], &K, &S[num_iters], stride, pad);
    sprintf(write_file,"intermediateTensors/Conv%d.txt",2*num_iters);
    writeTensorToFile(write_file,&S[num_iters]);

    destroyTensor(&T[num_iters]);
    destroyTensor(&K);

    // What is "batch"?
    batch(2*num_iters,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[num_iters]);
    sprintf(write_file,"intermediateTensors/BN%d.txt",2*num_iters);
    writeTensorToFile(write_file,&S[num_iters]);

    unaryOperateOnTensor_inplace(&S[num_iters],2);
    sprintf(write_file,"intermediateTensors/Relu%d.txt",2*num_iters);
    writeTensorToFile(write_file,&S[num_iters]);

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*num_iters+1,2*num_iters+1);
    readTensorFromFile(next_file,&K, kernel_pool);

    updateOutputDescriptorConvTensors(&S[num_iters], &K, &T[num_iters+1], stride, pad);
    createTensor(&T[num_iters+1],r_pool,1,1);
    new_convTensors(&S[num_iters], &K, &T[num_iters+1] ,stride,pad );
    sprintf(write_file,"intermediateTensors/Conv%d.txt",2*num_iters+1);
    writeTensorToFile(write_file,&T[num_iters+1]);

    destroyTensor(&K);
    destroyTensor(&S[num_iters]);

    batch(2*num_iters+1,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&T[num_iters+1]);
    sprintf(write_file,"intermediateTensors/BN%d.txt",2*num_iters+1);
    writeTensorToFile(write_file,&T[num_iters+1]);

    unaryOperateOnTensor_inplace(&T[num_iters+1],2);
    sprintf(write_file,"intermediateTensors/Relu%d.txt",2*num_iters+1);
    writeTensorToFile(write_file,&T[num_iters+1]);
    //decoding loop
    for(int i = num_iters+1; i <= 2*num_iters; i++)
    {
        fprintf(stderr,"Entering decoder loop %d\n",i-num_iters);

        sprintf(next_file,"Updated_weights/Parameters/ConvT/%dconv2d_transpose_%dkernel.csv",i-num_iters-1,i-num_iters-1);
        readTensorFromFile(next_file,&K, kernel_pool);
        //ConvTranpose for enhancement.
        uint32_t str_dec[2] = {2,2};
        updateOutputSDescriptorDilateTensors(&T[i], &K, str_dec, &S[i]);
        createTensor(&S[i],pool,1,1);
        dilateTensor(&T[i],&K, str_dec, &S[i]);
        sprintf(write_file,"intermediateTensors/Dilate%d.txt",i-num_iters-1);
        writeTensorToFile(write_file,&S[i]);

        destroyTensor(&T[i]);
        
        updateOutputSDescriptorDepadTensors(&S[i], pad_deconv, &S[num_iters+i]);
        createTensor(&S[num_iters+i],pool,1,1);
        dePadTensor(&S[i],pad_deconv,&S[num_iters+i]);
        sprintf(write_file,"intermediateTensors/Depad%d.txt",i-num_iters-1);
        writeTensorToFile(write_file,&S[num_iters+i]);

        destroyTensor(&S[i]);

        updateOutputDescriptorConvTensors(&S[num_iters+i], &K, &S[i+3*num_iters], stride, pad);
        createTensor(&S[i+3*num_iters],pool,1,1);
        new_convTensors(&S[num_iters+i], &K, &S[i+3*num_iters] ,stride,pad );
        sprintf(write_file,"intermediateTensors/ConvT%d.txt",i-num_iters-1);
        writeTensorToFile(write_file,&S[3*num_iters+i]);

        destroyTensor(&K);
        destroyTensor(&S[i+num_iters]);
        
        //Concat output tensor of convTranspose with that of the convolved tensor from input state.
        updateOutputDescriptorConcatTensors( &S[3*num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i], 2);
        createTensor(&R[num_iters+i],pool,1,1);
        concatTensorsAlongDim(&S[3*num_iters+i],&R[i-2*(i-num_iters)],&R[num_iters+i],2);
        sprintf(write_file,"intermediateTensors/Concat%d.txt",i-num_iters-1);
        writeTensorToFile(write_file,&R[num_iters+i]);

        destroyTensor(&S[i+3*num_iters]);

        //Convolve,batch-normalize and linear rectification in two stages.
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i,2*i);
        readTensorFromFile(next_file,&K, kernel_pool);
        fprintf(stderr,"Size of K :%u\n",getSizeOfTensor(&K));

        updateOutputDescriptorConvTensors(&R[num_iters+i], &K, &S[2*num_iters+i], stride, pad);
        createTensor(&S[2*num_iters+i],pool,1,1);
        new_convTensors(&R[num_iters+i], &K, &S[2*num_iters+i] ,stride,pad );
        sprintf(write_file,"intermediateTensors/Conv%d.txt",2*i);
        writeTensorToFile(write_file,&S[2*num_iters+i]);

        destroyTensor(&K);
        destroyTensor(&R[num_iters+i]);

        batch(2*i,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&S[2*num_iters+i]);
        sprintf(write_file,"intermediateTensors/BN%d.txt",2*i);
        writeTensorToFile(write_file,&S[2*num_iters+i]);

        unaryOperateOnTensor_inplace(&S[2*num_iters+i], 2);
        sprintf(write_file,"intermediateTensors/Relu%d.txt",2*i);
        writeTensorToFile(write_file,&S[2*num_iters+i]);
        
        sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",2*i+1,2*i+1);
        readTensorFromFile(next_file,&K, kernel_pool);
        fprintf(stderr,"Size of K :%u\n",getSizeOfTensor(&K));

        updateOutputDescriptorConvTensors(&S[2*num_iters+i], &K, &T[i+1], stride, pad);
        createTensor(&T[i+1],pool,1,1);
        new_convTensors(&S[2*num_iters+i], &K, &T[i+1] ,stride,pad );
        sprintf(write_file,"intermediateTensors/Conv%d.txt",2*i+1);
        writeTensorToFile(write_file,&T[i+1]);

        destroyTensor(&K);
        destroyTensor(&S[2*num_iters+i]);

        batch(2*i+1,kernel_pool,&gamma,&beta,&moving_mean,&moving_variance,&T[i+1]);
        sprintf(write_file,"intermediateTensors/BN%d.txt",2*i+1);
        writeTensorToFile(write_file,&T[i+1]);

        unaryOperateOnTensor_inplace(&T[i+1], 2);
        sprintf(write_file,"intermediateTensors/Relu%d.txt",2*i+1);
        writeTensorToFile(write_file,&T[i+1]);

        fprintf(stderr,"Completed decoder loop %d\n",i-num_iters);

    }

    sprintf(next_file,"Updated_weights/Parameters/Conv/%dconv2d_%dkernel.csv",4*num_iters+2,4*num_iters+2);
    readTensorFromFile(next_file,&K, kernel_pool);
    fprintf(stderr,"Size of K :%u\n",getSizeOfTensor(&K));

    int new_pad[4] = {0,0,0,0};
    updateOutputDescriptorConvTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, new_pad);
    createTensor(&T[2*num_iters+2],pool,1,1);
    new_convTensors(&T[2*num_iters+1],&K, &T[2*num_iters+2], stride, new_pad);

    destroyTensor(&K);
    writeTensorToFile("GeneratedImage.csv",&T[2*num_iters+2]);
}
