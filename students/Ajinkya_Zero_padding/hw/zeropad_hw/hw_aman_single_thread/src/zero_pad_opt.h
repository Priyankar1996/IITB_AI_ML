//Assumptions : 3D tensor, row_major, int16 data type
#ifndef __zero_pad_opt_h__
#define __zero_pad_opt_h__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"
#include <inttypes.h>
#include <assert.h>

void zeropad3D();
void zeropad3D_A();
void zeropad3D_B();
void zeropad3D_C();
void zeropad3D_D();
// void zeropad3D_E();
// void zeropad3D_F();
// void zeropad3D_G();
// void zeropad3D_H();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dt__ int16_t
#define __dim0__(td) ({td.dimensions[0];})
#define __dim1__(td) ({td.dimensions[1];})
#define __dim2__(td) ({td.dimensions[2];})

#define __zero_pad_opt__(row_low,row_high,col_low,col_high,z_low,z_high,tx,ty,tz,rx,ry,rz,T,pad,R) ({\
	__dt__ k = 0,j1 = col_low,i = row_low,pad_reg = pad,dim2T = tz,\
			dim1T = ty,dim0T = tx,dim2R = rz,\
			dim1R = ry,dim0R = rx,dim21T = dim2T*dim1T,\
			dim21R = dim2R*dim1R,j = j1,break_flag;\
	while (1) {\
		if((i < (pad_reg)) || (i >= (row_high+pad_reg)) || (j < (pad_reg)) || (j >= (col_high+pad_reg))){\
			int dest_data_array_idx = k + dim2R*j + dim21R*i;\
            R.data_array[dest_data_array_idx >> 2] = 0 ;\
            }\
        else{\
			int img_data_array_idx = (k + dim2T*(j-pad_reg) + dim21T*(i-pad_reg));\
			int dest_data_array_idx = (k + dim2R*(j) + dim21R*(i));\
			R.data_array[dest_data_array_idx >> 2] = T.data_array[img_data_array_idx >> 2];\
			}\
		break_flag = __Check_break_flag__(i,j,k,row_high,col_high,dim2T,j1,pad_reg);\
		if(break_flag)\
			break;\
	}\
})

#define __Check_break_flag__(i,j,k,row_high,col_high,dim2T,j1,pad_reg) ({\
	__dt__ flag = 0;\
	if((k+4) < dim2T)\
		k+=4;\
	else {\
		k = 0;\
		j++;\
		if (j == (col_high + (pad_reg<<1)))\
		{\
			j = j1;\
			i++;\
		}\
		if(i == (row_high + (pad_reg<<1)))\
			flag = 1;\
	}\
	flag;\
})
#endif