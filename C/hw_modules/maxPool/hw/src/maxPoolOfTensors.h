// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void maxPool3D();

#define __U16 1
#define __dim0__(A) ({A.descriptor.descriptor.dimensions[0];})
#define __dim1__(A) ({A.descriptor.descriptor.dimensions[1];})
#define __dim2__(A) ({A.descriptor.descriptor.dimensions[2];})

#define __dt__ uint16_t
#define __dt_min_val__ 0

#define __maxOperation__(src,l,add_src) ({\
		__dt__ data = __dt_min_val__;\
		for (uint16_t i = 0; i < l; i++)\
		{\
			for (uint16_t j = 0; j < l; j++)\
			{\
				uint64_t data_array = src.data_array[add_src >> 2];\
				__dt__ cmp_val = (data_array >> 16*(3 - (add_src & 3)));\
				if ( cmp_val> data) \
					data =  cmp_val;\
				add_src+=__dim2__(src);\
			}\
			add_src+=(__dim1__(src)-l)*__dim2__(src);\
		}\
		data;\
	})

#define __maxPoolOfTensors3D__(src, dst, l, stride) ({\
	dst.descriptor.descriptor.number_of_dimensions = src.descriptor.descriptor.number_of_dimensions;\
	uint32_t val = src.descriptor.descriptor.dimensions[0];\
	val-=l;\
	dst.descriptor.descriptor.dimensions[0] = 1+val;\
	val = src.descriptor.descriptor.dimensions[1];\
	val-=l;\
	dst.descriptor.descriptor.dimensions[1] = 1+val;\
	dst.descriptor.descriptor.dimensions[2] = src.descriptor.descriptor.dimensions[2];\
	uint32_t address = 0, add_src;\
	uint16_t row,col,chl;\
	uint64_t element = 0;\
	for (row = 0; row < __dim0__(dst); row++)\
	{\
		for (col = 0; col < __dim1__(dst); col++)\
		{\
			for (chl = 0; chl < __dim2__(dst); chl++)\
			{\
				add_src = chl+__dim2__(src)*(col*stride+__dim1__(src)*row*stride);\
				__dt__ data = __maxOperation__(src,l,add_src);\
				element += data;\
				if ((address & 3) == 3)\
				{\
					dst.data_array[address >> 2] = element;\
				}\
				element <<= 16;\
				address++;\
			}\
		}\
	}\
	if ((address & 3) != 0){\
		element <<= 16*(4 - (address & 3));\
		dst.data_array[address >> 2] = element;\
	}\
})
