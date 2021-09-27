AUTHORS : DEVAL PATEL, ANDREWS
#ifndef __conv_h___
#define __conv_h___
/*
	Uncomment the following 4 lines when using in
	main git directory IITB_AI_ML

	NOTE:
		- error in including mempool.h in file
			"../../../C/mempool/src/mempool.c"
*/
// #include "../../../C/mempool/include/mempool.h"
// #include "../../../C/primitives/include/tensor.h"
// #include "../../../C/primitives/src/tensor.c"
// #include "../../../C/mempool/src/mempool.c"

/*
	Uncomment the following 2 lines for local testing
*/
// #include "../../../C/primitives/include/alphabet.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"
#include<inttypes.h>
#include<string.h>

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
		4. stride is a convolution parameter
	ASSUMPTIONS:
		1. Row Major: dataSize * C is smaller than 1024 words
		2. Col Major:
		3. kernel contains only 1 filter
		4. #dim of inImg, kernel = 3
	OPERATION:
		Convolves inImg with kernel with stride=stride
	SIDE-EFFECTS:
		NA
	RETURN VALUES:
		0 on Success, -1 on Failure.
	FUTURE WORK:
		1. allow for padding - currently padding to be 0
		2. allow for any size of kernel/image
		3. rework the code to optimize for sliding windows
		4. check other options provided by PyTorch
*/
int new_convTensors(Tensor *inImg, Tensor *kernel, Tensor *outImg,
					const int stride[], const int padding[]);
#endif
