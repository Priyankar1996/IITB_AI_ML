// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"


#define __updateOutputDescriptorMaxPoolOfTensors__(src, dst, l, stride, num_dims_to_pool, dims_to_pool, mode) {\
	dst.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
	dst.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
	dst.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
	int8_t i = 0,j;\
\
	for (j = 0; j <  src.descriptor.descriptor.number_of_dimensions; j++)\
	{\
		uint32_t x = src.descriptor.descriptor.dimensions[j];\
		if ((j == dims_to_pool[i]) && (i < num_dims_to_pool))\
		{		\
			int32_t factor = (x<l) ? mode : ((mode == 0) ? 1+((x-l)/stride) : 1+((x-1)/stride));\
			dst.descriptor.descriptor.dimensions[j] = factor;\
			i ++;\
		}\
		else\
		{\
			dst.descriptor.descriptor.dimensions[j] = x;\
		}\
	}\
}

// Compute bitmask givne the datatype and its position in the word
#define getBitMask(dsize , position) ({\
	uint64_t mask;\
#if (__U64 || __I64 || __F64)
		mask = (uint64_t)(0xFFFFFFFFFFFFFFFF);\
#endif
#if (__U32 || __I32 || __F32) 
		mask = ((uint64_t)(0xFFFFFFFF) << 32*(position));\
#endif
	switch (dsize)\
	{\
	case 8:\
		mask = (uint64_t)(0xFFFFFFFFFFFFFFFF);\
		break;\
	case 4:\
		mask = ((uint64_t)(0xFFFFFFFF) << 32*(position));\
		break;\
	case 2:\
		mask = ((uint64_t)(0xFFFF) << 16*(position));\
		break;\
	case 1:\
		mask = ((uint64_t)(0xFF) << 8*(position));\
		break;\
	default:\
		break;\
	}\
	mask;\
})

// Core operation of maxPool
// Computes the max of num_max quantities in inp_address starting at indice start based on the datatype
// Returns the data in at location temp
#define maxOperation(num_max,inp_address, dt, temp) ({\
	switch (dt)\
		{\
		case i8:\
		*((int8_t*)temp ) = *((int8_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((int8_t*)(inp_address) +i*8)> *((int8_t*)temp )) *((int8_t*)temp ) = *((int8_t*)(inp_address) +i*8);\
		}\
		break;\
		case float8:\
		case u8:\
		*((uint8_t*)temp ) = *((uint8_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((uint8_t*)(inp_address) +i*8)> *((uint8_t*)temp )) *((uint8_t*)temp ) = *((uint8_t*)(inp_address) +i*8);\
		}\
		break;\
		case i16:\
		*((int16_t*)temp ) = *((int16_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((int16_t*)(inp_address) +i*4)> *((int16_t*)temp )) *((int16_t*)temp ) = *((int16_t*)(inp_address) +i*4);\
		}\
		break;\
		case float16:\
		case u16:\
		*((uint16_t*)temp ) = *((uint16_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((uint16_t*)(inp_address) +i*4)> *((uint16_t*)temp )) *((uint16_t*)temp ) = *((uint16_t*)(inp_address) +i*4);\
		}\
		break;\
		case i32:\
		*((int32_t*)temp ) = *((int32_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((int32_t*)(inp_address) +i*2)> *((int32_t*)temp )) *((int32_t*)temp ) = *((int32_t*)(inp_address) +i*2);\
		}\
		break;\
		case float32:\
		*((float*)temp ) = *((float*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((float*)(inp_address) +i*2)> *((float*)temp )) *((float*)temp ) = *((float*)(inp_address) +i*2);\
		}\
		break;\
		case u32:\
		*((uint32_t*)temp ) = *((uint32_t*)(inp_address));\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((uint32_t*)(inp_address) +i*2)> *((uint32_t*)temp )) *((uint32_t*)temp ) = *((uint32_t*)(inp_address) +i*2);\
		}\
		break;\
		case i64:\
		*((int64_t*)temp) = *((int64_t*)(inp_address) );\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((int64_t*)(inp_address) +i*1)> *((int64_t*)temp)) *((int64_t*)temp) = *((int64_t*)(inp_address) +i*1);\
		}\
		break;\
		case float64:\
		*((double*)temp) = *((double*)(inp_address) );\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((double*)(inp_address) +i*1)> *((double*)temp)) *((double*)temp) = *((double*)(inp_address) +i*1);\
		}\
		break;\
		case u64:\
		*((uint64_t*)temp) = *((uint64_t*)(inp_address) );\
		for (int i = 1;i< num_max;i++)\
		{\
			if (*((uint64_t*)(inp_address) +i*1)> *((uint64_t*)temp)) *((uint64_t*)temp) = *((uint64_t*)(inp_address) +i*1);\
		}\
		break;\
		default:\
			break;\
		}\
})

// Pools one dimension at a time, parameters size , x , l ,s ,cs , mode
// Input tensor src, output dst
#define __maxpool1D__(src, size, x,  l,  s,  cs, dst, mode) ({\
	uint8_t dt = src.descriptor.descriptor.data_type;\
	uint8_t dsize = __sizeOfTensorDataInBytes__(dt);\
	int num_units = size/(x*cs);\
	int num_1D_steps = ((mode == 0) ? 1 + (x-l)/s : 1 + (x-1)/s);\
	if (l>x)\
	{\
		fprintf(stderr,"Warning: Length exceeds dimension.\n");\
		num_1D_steps = mode;\
	}\
\
	uint64_t temp_new , temp_old[l], temp_buffer, bitmask;\
\
	uint32_t i=0,j=0,k=0;\
	for (i = 0;i<num_units;i++)\
	{	\
		for (k = 0;k < cs;k++)\
		{\
			for (j = 0; j < num_1D_steps; j++)\
			{	\
				uint64_t address = i*num_1D_steps*cs+k+j*cs;\
				uint32_t var_max = ((l < x - j*s) ? l : x - j*s);\
				for (uint32_t var = 0; var < var_max; var++)\
				{\
					temp_old[var] = src.data_array[(i*x*cs+k+(j*s+var)*cs)*dsize/8] >> (8*dsize*((i*x*cs+k+(j*s+var)*cs)%(8/dsize)));\
					bitmask = getBitMask(dsize,0);\
					temp_old[var] = temp_old[var]&bitmask;\
				}\
				maxOperation(var_max, temp_old, dt, &temp_new);\
				bitmask = ~getBitMask(dsize,address%(8/dsize));\
				uint64_t temp_another = dst.data_array[((address*dsize)/8)];\
				dst.data_array[((address*dsize)/8)] = (temp_another & bitmask) + ((temp_new & getBitMask(dsize,0)) << (8*dsize*((address%(8/dsize)))));\
			}\
		}\
	}\
})

#define __maxPoolOfTensors__(src, dst, l, stride, num_dims_to_pool, dims_to_pool, mode) ({\
	dst.descriptor.descriptor.row_major_form = src.descriptor.descriptor.row_major_form;\
	dst.descriptor.descriptor.data_type = src.descriptor.descriptor.data_type;\
	dst.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
	int8_t i = 0,j;\
	for (j = 0; j <  src.descriptor.descriptor.number_of_dimensions; j++)\
	{\
		uint32_t x = src.descriptor.descriptor.dimensions[j];\
		if ((j == dims_to_pool[i]) && (i < num_dims_to_pool))\
		{		\
			int32_t factor = (x<l) ? mode : ((mode == 0) ? 1+((x-l)/stride) : 1+((x-1)/stride));\
			dst.descriptor.descriptor.dimensions[j] = factor;\
			i ++;\
		}\
		else\
		{\
			dst.descriptor.descriptor.dimensions[j] = x;\
		}\
	}\
	uint8_t row_major = src.descriptor.descriptor.row_major_form;\
	uint64_t size = __NumberOfElementsInSizedTensor__(src);\
	uint32_t x;\
	int64_t cs = 1;\
	int8_t iStart,iEnd,iInc,jStart,jEnd,jInc;\
	if (row_major == 1)\
	{\
		iStart = num_dims_to_pool - 1;\
		iInc = -1;\
		iEnd = 0;\
		jStart = src.descriptor.descriptor.number_of_dimensions - 1;\
		jEnd = -1;\
		jInc = -1;\
	}\
	else\
	{\
		iStart = 0;\
		iInc = 1;\
		iEnd = num_dims_to_pool - 1;\
		jEnd = src.descriptor.descriptor.number_of_dimensions;\
		jStart = 0;\
		jInc = 1;\
	}\
	i = iStart;\
	if (num_dims_to_pool == 1)\
	{\
		for (j = jStart; j != jEnd;j += jInc)\
		{\
			x = src.descriptor.descriptor.dimensions[j];\
			if (j == dims_to_pool[0])\
			{	\
				__maxpool1D__(src, size, x, l, stride, cs, dst, mode);\
				int32_t factor = (x<l) ? mode : ((mode == 0) ? 1+((x-l)/stride) : 1+((x-1)/stride));\
				size = size*factor/x;\
				cs *= factor;\
			}\
			else\
			{\
				cs *= x;\
			}\
		}\
	}\
	SizedTensor_16K temp_Tensor;\
	temp_Tensor.descriptor.descriptor = src.descriptor.descriptor;\
	for (j = jStart; j != jEnd;j += jInc)\
	{\
		x = src.descriptor.descriptor.dimensions[j];\
		if ((j == dims_to_pool[i]) && (i != (iEnd+iInc)))\
		{\
			\
			if (i == iStart)\
			{\
				__maxpool1D__(src, size, x, l, stride, cs, temp_Tensor, mode);\
			}\
			else if	(i == iEnd)\
			{\
				__maxpool1D__(temp_Tensor, size, x, l, stride, cs, dst, mode);\
			}\
			else \
			{\
				__maxpool1D__(temp_Tensor, size, x, l, stride, cs, temp_Tensor, mode);\
			}\
			\
			int32_t factor = (x<l) ? mode : ((mode == 0) ? 1+((x-l)/stride) : 1+((x-1)/stride));\
			size = size*factor/x;\
			dst.descriptor.descriptor.dimensions[j] = factor;\
			cs *= factor;\
			i += iInc;\
		}\
		else\
		{\
			dst.descriptor.descriptor.dimensions[j] = x;\
			cs *= x;\
		}\
	}\
})
