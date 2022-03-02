// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void maxPool3D();
void maxPoolCore1();
void maxPoolCore2();
void maxPoolCore3();
void maxPoolCore4();

#define __I16 1
#define __dim0__(A) ({A.descriptor.descriptor.dimensions[0];})
#define __dim1__(A) ({A.descriptor.descriptor.dimensions[1];})
#define __dim2__(A) ({A.descriptor.descriptor.dimensions[2];})
#define __dim22__(A) ({A.descriptor.descriptor.dimensions[2]>>2;})

#define __dt__ int16_t
#define __dt_min_val__ 0x8000

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
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

#define __increment_mm__(row,col,chl,min_col,max_col,max_chl) ({\
	chl++;\
	if (chl == max_chl){\
		chl = 0;\
		col++;\
	}\
	if (col == max_col){\
		col = min_col;\
		row++;\
	}\
})

#define __maxOperation4__(src,add_src, offset1 ,offset2) ({\
		__dt__ min_val1 , min_val2, min_val3, min_val4,\
		min_val5, min_val6, min_val7, min_val8,\
		min_val9, min_val10, min_val11, min_val12;\
		uint32_t add_1 = add_src + offset1;\
		uint32_t add_2 = add_src + offset2;\
		uint32_t add_3 = add_src + offset1 + offset2;\
		int64_t data_array1 = src.data_array[add_src];\
		__dt__ cmp_val11 = data_array1;\
		__dt__ cmp_val12 = data_array1 >> 16;\
		__dt__ cmp_val13 = data_array1 >> 32;\
		__dt__ cmp_val14 = data_array1 >> 48;\
		int64_t data_array2 = src.data_array[add_1];\
		__dt__ cmp_val21 = data_array2;\
		__dt__ cmp_val22 = data_array2 >> 16;\
		__dt__ cmp_val23 = data_array2 >> 32;\
		__dt__ cmp_val24 = data_array2 >> 48;\
		int64_t data_array3 = src.data_array[add_2];\
		__dt__ cmp_val31 = data_array3;\
		__dt__ cmp_val32 = data_array3 >> 16;\
		__dt__ cmp_val33 = data_array3 >> 32;\
		__dt__ cmp_val34 = data_array3 >> 48;\
		int64_t data_array4 = src.data_array[add_3];\
		__dt__ cmp_val41 = data_array4;\
		__dt__ cmp_val42 = data_array4 >> 16;\
		__dt__ cmp_val43 = data_array4 >> 32;\
		__dt__ cmp_val44 = data_array4 >> 48;\
		if ( cmp_val11> cmp_val21) min_val1 =  cmp_val11; else min_val1 = cmp_val21;\
		if ( cmp_val12> cmp_val22) min_val2 =  cmp_val12; else min_val2 = cmp_val22;\
		if ( cmp_val13> cmp_val23) min_val3 =  cmp_val13; else min_val3 = cmp_val23;\
		if ( cmp_val14> cmp_val24) min_val4 =  cmp_val14; else min_val4 = cmp_val24;\
		if ( cmp_val31> cmp_val41) min_val5 =  cmp_val31; else min_val5 = cmp_val41;\
		if ( cmp_val32> cmp_val42) min_val6 =  cmp_val32; else min_val6 = cmp_val42;\
		if ( cmp_val33> cmp_val43) min_val7 =  cmp_val33; else min_val7 = cmp_val43;\
		if ( cmp_val34> cmp_val44) min_val8 =  cmp_val34; else min_val8 = cmp_val44;\
		if (min_val1 > min_val5) min_val9 = min_val1; else min_val9 = min_val5;\
		if (min_val2 > min_val6) min_val10 = min_val2; else min_val10 = min_val6;\
		if (min_val3 > min_val7) min_val11 = min_val3; else min_val11 = min_val7;\
		if (min_val4 > min_val8) min_val12 = min_val4; else min_val12 = min_val8;\
		int64_t element1 = min_val12;\
		int64_t element2 = min_val11;\
		int64_t element3 = min_val10;\
		int64_t element4 = min_val9;\
		element1 <<= 48;\
		element2 <<= 32;\
		element3 <<= 16;\
		int64_t element = element1 + element2 + element3 + element4;\
		element;\
	})

#define __maxPoolOfTensors3D__(src, dst, stride) ({\
	uint32_t address = 0, add_src;\
	uint16_t dim1 = __dim1__(dst), dim1d = __dim1__(src);\
	uint32_t offset1 = __dim22__(src), offset2 = dim1d*offset1;\
	uint16_t row=0,col=0,chl=0;\
	uint32_t dim0 = __dim0__(dst);\
	while(1)\
	{\
		__loop_pipeline_var__\
		add_src = chl+offset1*stride*(col+dim1d*row);\
		dst.data_array[address] = __maxOperation4__(src,add_src,offset1,offset2);\
		address++;\
		__increment__(row,col,chl,dim1,offset1);\
		if (row == dim0) break;\
	}\
})

#define __maxPoolOfTensors3D_div__(src, dst, stride, rs, cs, re, ce) ({\
	uint32_t address, add_src;\
	uint16_t dim1d = __dim1__(src), dim1 = __dim1__(dst);\
	uint32_t offset1 = __dim22__(dst), offset2 = dim1d*offset1;\
	uint16_t row=rs,col=cs,chl=0;\
	while(1)\
	{\
		__loop_pipeline_var__\
		address = chl+offset1*(col+dim1*row);\
		add_src = chl+offset1*stride*(col+dim1d*row);\
		dst.data_array[address] = __maxOperation4__(src,add_src,offset1,offset2);\
		__increment_mm__(row,col,chl,cs,ce,offset1);\
		if (row == re) break;\
	}\
})
