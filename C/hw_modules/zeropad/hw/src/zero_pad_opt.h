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
void zeropad3D_E();
void zeropad3D_F();
void zeropad3D_G();
void zeropad3D_H();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dim0__(td) ({td.dimensions[0];})
#define __dim1__(td) ({td.dimensions[1];})
#define __dim2__(td) ({td.dimensions[2];})

#define __zero_pad_opt__(row_low,row_high,col_low,col_high,td_in,td_out,T,pad,R) ({\
	int k = 0;\
	int j1 = col_low,j;\
	int i = row_low;\
	int pad_reg = pad;\
	int dim2T = __dim2__(td_in);\
	int dim1T = __dim1__(td_in);\
	int dim0T = __dim0__(td_in);\
	int dim2R = __dim2__(td_out);\
	int dim1R = __dim1__(td_out);\
	int dim0R = __dim0__(td_out);\
	int dim21T = dim2T*dim1T;\
	int dim21R = dim2R*dim1R;\
	j = j1;\
	while (i < (row_high + 2*pad_reg))\
	{\
		if((i <= (pad_reg-1)) || (i > (row_high+pad_reg-1)) || (j <= (pad_reg-1)) || (j > (col_high+pad_reg-1)))\
				{\
					int dest_data_array_idx = k + dim2R*j + dim21R*i;\
					int dest_data_array_idx_1 = dest_data_array_idx + 1;\
					int dest_data_array_idx_2 = dest_data_array_idx + 2;\
					int dest_data_array_idx_3 = dest_data_array_idx + 3;\
                    R.data_array[dest_data_array_idx >> 2] = 0 ;\
					R.data_array[dest_data_array_idx_1 >> 2] = 0 ;\
					R.data_array[dest_data_array_idx_2 >> 2] = 0 ;\
					R.data_array[dest_data_array_idx_3 >> 2] = 0 ;\
                }\
                else\
				{\
				int img_data_array_idx = (k + dim2T*(j-pad_reg) + dim21T*(i-pad_reg));\
				int dest_data_array_idx = (k + dim2R*(j) + dim21R*(i));\
				int img_data_array_idx_1 = img_data_array_idx + 1;\
				int img_data_array_idx_2 = img_data_array_idx + 2;\
				int img_data_array_idx_3 = img_data_array_idx + 3;\
				int dest_data_array_idx_1 = dest_data_array_idx + 1;\
				int dest_data_array_idx_2 = dest_data_array_idx + 2;\
				int dest_data_array_idx_3 = dest_data_array_idx + 3;\
				R.data_array[dest_data_array_idx >> 2] = T.data_array[img_data_array_idx >> 2];\
				R.data_array[dest_data_array_idx_1 >> 2] = T.data_array[img_data_array_idx_1 >> 2];\
				R.data_array[dest_data_array_idx_2 >> 2] = T.data_array[img_data_array_idx_2 >> 2];\
				R.data_array[dest_data_array_idx_3 >> 2] = T.data_array[img_data_array_idx_3 >> 2];\
				}\
				k+=4;\
		if ((k) >= dim2T)\
		{\
			k = 0;\
			j++;\
			if (j == (col_high + 2*pad_reg))\
			{\
				j = j1;\
				i++;\
			}\
		}\
	}\
})
#endif