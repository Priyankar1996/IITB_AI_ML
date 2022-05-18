// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void maxPool3D();

#define __I16 1

#define __dt__ int16_t

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
uint8_t maxPool4(uint32_t ad, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
	#define maxPool4(addr,addr1,addr2,addr3,addr4) ({0;})
#endif

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

#define __maxPoolOfTensors3D_div__(dst, rs, cs, re, ce, dim1d, dim1, offset1, offset2) ({\
	uint32_t address, add_src;\
	uint16_t row=rs,col=cs,chl=0;\
	uint32_t offset3 = offset1 + offset2;\
	int64_t data_array1,data_array2,data_array3,data_array4;\
	while(1)\
	{\
		__loop_pipeline_var__\
		address = ((chl+offset1*(col+dim1*row)));\
		add_src = chl+((offset1*(col+dim1d*row))<<1);\
		uint8_t done = maxPool4(address,add_src,add_src+offset1,add_src+offset2,add_src+offset3);\
		__increment_mm__(row,col,chl,cs,ce,offset1);\
		if (row == re) break;\
	}\
})
