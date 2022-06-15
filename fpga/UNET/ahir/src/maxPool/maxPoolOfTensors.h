// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>


#define __I8 1

void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
uint8_t maxPool4(uint32_t ad, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint8_t i1, uint8_t i2);

#define __increment_mm__(row,col,chl,max_col,max_chl) ({\
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

#define __maxPoolOfTensors3D_div__( re, ce, dim1d, dim1, offset1, offset2, index1, index2) ({\
	uint32_t address = 0, add_src;\
	uint16_t row=0,col=0,chl=0;\
	uint32_t offset3 = offset1 + offset2;\
	int64_t data_array1,data_array2,data_array3,data_array4;\
	while(1)\
	{\
		__loop_pipeline_var__\
		add_src = chl+((offset1*(col+dim1d*row))<<1);\
		uint8_t done = maxPool4(address,add_src,add_src+offset1,add_src+offset2,add_src+offset3, index1, index2);\
		__increment_mm__(row,col,chl,ce,offset1);\
		address += 1;\
		if (row == re) break;\
	}\
})
