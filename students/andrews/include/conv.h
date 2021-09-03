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

#define CEILING(x,y) (((x) + (y) - 1) / (y))

/*
	Union used to calculate convolution
	results
	Need separate variables as operations
	are carried out differently for each
	data type
*/
union ConvResult{
	uint8_t res_u8;
	uint16_t res_u16;
	uint32_t res_u32;
	uint64_t res_u64;

	int8_t res_i8;
	int16_t res_i16;
	int32_t res_i32;
	int64_t res_i64;
	
	// float8 res_f8;
	// float16 res_f16;
	float res_f32;
	double res_f64;
};

/*
	NAME:
		convHelper		
	BRIEF:
		Take 2 arrays of same size as input,
		calculate dot product
	INPUTS:
		1. ker_data points to kernel values
		2. img_data points to image values
		3. dtype is data type
		4. ker_start_ds_offset points to how much data to skip
			at the start of ker_data
		5. img_start_ds_offset points to how much data to skip
			at the start of img_data
		6. num_ele_to_operate points to #elements involved in <,>
		7. res points to result object
	ASSUMPTIONS:
		NA
	OPERATION:
		Returns <*ker_data, *img_data> in *res
	SIDE-EFFECTS:
		NA
	RETURN VALUES:
		NA
	FUTURE WORK:
		NA
*/
void convHelper(const int64_t *ker_data, const int64_t *img_data, 
				const TensorDataType dtype,
				const int32_t *ker_start_ds_offset, const int32_t *img_start_ds_offset,
				const uint32_t *num_ele_to_operate, union ConvResult *res);

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
int convTensors(Tensor *inImg, Tensor *kernel, Tensor *outImg, 
					const int stride[], const int padding[]);
#endif