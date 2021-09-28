#ifndef __conv_h___
#define __conv_h___

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"
#include <inttypes.h>
#include <string.h>

#define CEILING(x,y) (((x) + (y) - 1) / (y))
#define MIN(a,b) (((a)<(b))?(a):(b))
/*
	NAME:
		convHelper
	BRIEF:
		Take 2 arrays of same size as input,
		calculate dot product
	INPUTS:
		1. ker_data points to kernel values
		2. img_data points to image values
		3. kernel descriptor
		4. image descriptor
		5. convolve start index
		6. base address of convolution result
		7. loop value
	ASSUMPTIONS:
		NA
	OPERATION:
		perform dot product of the image matrix patch with kernel.
	SIDE-EFFECTS:
		NA
	RETURN VALUES:
		NA
	FUTURE WORK:
		NA
*/
void convHelper(const int64_t *ker_data, const int64_t *img_data,
                TensorDescriptor *td_ker,
                TensorDescriptor *td_in,
		int *img_data_start_index,
		void *result_array_base,
		int l);



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
int convTensors(Tensor *inImg, Tensor *kernel, Tensor *outImg,
					const int stride[], const int padding[]);
#endif