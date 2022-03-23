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
	/*Loop for Zero initialization*/\
	while (i < p_end + pad)\
	{\
		int out_data_array_idx = k + dim2R*j + dim21R*i;\
		out.data_array[out_data_array_idx >> 2] = 0;\
		k++;\
		if(k == dim2R)\
		{\
			k = 0;\
			j++;\
			if(j == q_end + pad)\
			{\
				j = j1;\
				i++;\
			}\
		}\
	}\
	k = 0;\
	i = p_start;\
	j = j1;\
	/*Loop for element transfer*/\
	while (i < p_end)\
	{\
		int img_data_array_idx = k + dim2T*j + dim21T*i;;\
		/*read one 64 bit block after four 16 bit values have been read*/\
		if((count - 4*(count >> 2)) == 0)\
		{\
			__getOneTensorBlock__(inp,img_data,img_data_array_idx);\
		}\
		/*get the offset of one 16 bit block from one 64 bit block*/\
		uint8_t temp_img_rem = img_data_array_idx - 4*(img_data_array_idx >> 2);\
		/*get one 16 bit value*/\
		int16_t img_one_block = __getOneBlock__(img_data,temp_img_rem);\
		count++;\
		/*pack four 16 bit value into one 64 bit tensor block*/\
		int out_data_array_idx = k + dim2R*(j+pad) + dim21R*(i+pad);\;\
		uint8_t temp_out_rem = out_data_array_idx - 4*(out_data_array_idx >> 2);\
		out.data_array[out_data_array_idx >> 2] = 0;\
		k++;\
		if(k == dim2T)\
		{\
			k = 0;\
			j++;\
			if(j == q_end)\
			{\
				j = j1;\
				i++;\
			}\
		}\
	}\
})


#define __getOneTensorBlock__(tnsr,data,index)({\
	data = tnsr.data_array[index >> 2];\
})

#define __getOneBlock__(array64bit,position)({\
	int16_t result = (int16_t)((array64bit >> (position*16)) & 0x000000000000FFFF);\
	result;\
})

#define __putOneBlock__(array64bit,position,result)({\
	array64bit = array64bit | (((uint64_t)result) << (position*16));\
})
