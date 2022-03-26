#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void zeropad3D();
void zeropad3D_A();
void zeropad3D_B();
void zeropad3D_C();
void zeropad3D_D();

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
#else
	#define __loop_pipeline_var__ {;}
#endif

#define __dim0__(desc) ({desc.dimensions[0];})
#define __dim1__(desc) ({desc.dimensions[1];})
#define __dim2__(desc) ({desc.dimensions[2];})

#define __zero_pad_opt__(inp,out,desc_inp,desc_out,p_start,q_start,p_end,q_end,pad) ({\
    desc_out.data_type = i16;\
    desc_out.number_of_dimensions = 3;\
    desc_out.row_major_form = 1;\
    desc_out.dimensions[0] = __dim0__(desc_inp) + 2*pad;\
	desc_out.dimensions[1] = __dim1__(desc_inp) + 2*pad;\
	desc_out.dimensions[2] = __dim2__(desc_inp);\
	int count = 0;\
	int pad_reg = pad;\
	int k = 0;\
	int j1 = q_start,j;\
	int i = p_start;\
	int dim2T = __dim2__(desc_inp);\
	int dim1T = __dim1__(desc_inp);\
	int dim0T = __dim0__(desc_inp);\
	int dim2R = __dim2__(desc_out);\
	int dim1R = __dim1__(desc_out);\
	int dim0R = __dim0__(desc_out);\
	int dim21T = dim2T*dim1T;\
	int dim21R = dim2R*dim1R;\
	j = j1;\
	uint64_t img_data;\
    for(i = q_start ;i < (q_end+(2*pad_reg)); i++)\
        for(j = p_start ;j< (p_end+(2*pad_reg)); j++)\
			for(k=0;k<dim2R;k++)\
            {\
                if((i <= (pad_reg-1)) || (i > (q_end+pad_reg-1)) || (j <= (pad_reg-1)) || (j > (p_end+pad_reg-1)))\
				{\
					int out_data_array_idx = k + dim2R*j + dim21R*i;\
                    out.data_array[out_data_array_idx >> 2] = 0 ;\
                }\
                else\
				{\
					int out_data_array_idx = k + dim2R*j + dim21R*i;\
					int inp_data_array_idx = k + dim2T*(j-pad_reg) + dim21T*(i-pad_reg);\
					out.data_array[out_data_array_idx >> 2] = inp.data_array[inp_data_array_idx >> 2];\
				}\
			}\
})

#define __getOneBlock__(array64bit,position)({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})

#define __putOneBlock__(array64bit,position,result)({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
})
