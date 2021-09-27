#ifndef __conv_h___
#define __conv_h___

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"

#define CEILING(x,y) (((x) + (y) - 1) / (y))


/*
	NAME:
		convTensors
	BRIEF:
		Take image and kernel as input, output the convolution
	INPUTS:
		1. inImg points to source image
		2. kernel points to convolution kernel
		3. outImg points to destination image
		4. MemPool points to storage place
		5. stride is a convolution parameter
		6. padding is conv parameter
	ASSUMPTIONS:
		1. Row Major: dataSize * C is smaller than 1024 words
		2. Kernel is small enough to fit in 1 page
		3. Inputs given in form of 3d kernel. (Can put other dimensions as 1)
		4. int64 or float64 data
	OPERATION:
		Convolves inImg with kernel with given stride, padding
	SIDE-EFFECTS:
		NA
	RETURN VALUES:
		0 on Success, -1 on Failure.
	FUTURE WORK:
		1. Provision for all data type
		2. Higher dimensional kernel?
		3. Speed Up/ check other options provided by PyTorch
*/
int convTensors(Tensor *inImg, Tensor *kernel, Tensor *outImg, MemPool *mp,
					const int stride[], const int padding[]);
#endif