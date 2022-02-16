// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void maxPool3D();

#define __I16 1
#define __dim0__(A) ({A.descriptor.descriptor.dimensions[0];})
#define __dim1__(A) ({A.descriptor.descriptor.dimensions[1];})
#define __dim2__(A) ({A.descriptor.descriptor.dimensions[2];})

#define __dt__ int16_t
#define __dt_min_val__ 0x8000

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif
	
#define __increment__(row,col,chl,max_col,max_chl) ({\
	chl++;\
	if (chl == max_chl){\
		chl = 0;\
		col++;\
	}\
	if (col == max_col){\
		col = 0;\
		row++;\
	}\
})
#define __increment2__(row,col,max_col,address,inc1,inc2) ({\
	col+=1;\
	address+=inc1;\
	if (col == max_col){\
		col = 0;\
		row++;\
		address+=inc2;\
	}\
})

#define __maxOperation__(src,l,add_src,dim2,dim1) ({\
		uint16_t my_var_temp0=0,my_var_temp1=0;\
		uint32_t add_inner = add_src;\
		__dt__ min_val = __dt_min_val__;\
		uint32_t val = (dim1-l)*dim2;\
		while (1){\
			uint64_t data_array = src.data_array[add_inner >> 2];\
			__dt__ cmp_val = (data_array >> (((~add_inner) & 3)<<4));\
			if ( cmp_val> min_val) \
				min_val =  cmp_val;\
			__increment2__(my_var_temp1,my_var_temp0,l,add_inner,dim2,val);\
			if (my_var_temp1 == l) break;\
		}\
		min_val;\
	})

#define __maxPoolOfTensors3D__(src, dst, l, stride) ({\
	uint16_t address = 0, add_src;\
	uint32_t offset1 = __dim2__(src);\
	uint16_t dim1 = __dim1__(dst), dim1d = __dim1__(src);\
	uint16_t row=0,col=0,chl=0;\
	uint32_t size = __NumberOfElementsInSizedTensor__(dst);\
	uint64_t element = 0;\
	while(1)\
	{\
		__loop_pipeline_var__\
		add_src = chl+offset1*(col*stride+dim1d*row*stride);\
		__increment__(row,col,chl,dim1,offset1);\
		__dt__ data = __maxOperation__(src,l,add_src,offset1,dim1d);\
		element += data;\
		if ((address&3)==3) dst.data_array[address >> 2] = element;\
		address++;\
		element <<= 16;\
		if (address >= size) break;\
	}\
	if (address&3){\
		element <<= (((~address)&3)<<4);\
		dst.data_array[address >> 2] = element;\
	}\
})
