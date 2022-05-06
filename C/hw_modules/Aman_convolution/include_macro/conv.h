// AUTHOR: Aman Dhammani
// Department of Electrical Engineering, IITB

#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "sized_tensor.h"

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})
#define __dim3__(T) ({T.descriptor.descriptor.dimensions[3];})



#ifdef __I16
	#define __dt__ int16_t
	#define dsize 2
#endif

#define __convolve__(in,kernel,row_start,col_start,chl_start) ({\
	__dt__ result = 0;\
    for (int i = row_start; i < row_start+__dim1__(kernel); i++)\
	{\
		if (i < 0) continue;\
		if (i >= __dim0__(in)) continue;\
		for (int j = col_start; j < col_start+__dim2__(kernel); j++)\
		{	\
			if (j < 0) continue;\
			if (j >= __dim0__(in)) continue;\
			for (int k = 0; k < __dim3__(kernel); k++)\
			{\
                __dt__ in_val = (*(__dt__*)in.data_array+((i*__dim1__(in)+j)*__dim2__(in)+k));\
				if (in_val != 0)\
                result += in_val * (*(__dt__*)kernel.data_array + chl_start+((i-row_start)*__dim2__(kernel)+(j-col_start))*__dim3__(kernel)+k);\
			}\
		}\
	}\
    result;\
})

#define __convTensors3D__(in_img, kernel, out_img, stride, padding) ({\
	uint32_t chl_size = __dim3__(kernel)*__dim2__(kernel)*__dim1__(kernel);\
	__dt__ val = 0;\
    uint64_t address=0;\
    for (int row = 0; row < __dim0__(out_img); row++)\
    {\
        for (int col = 0; col < __dim1__(out_img); col++)\
        {\
	        for (int chl = 0; chl < __dim2__(out_img); chl++)\
            {\
				val = __convolve__(in_img,kernel,row*stride[0]-padding[0],col*stride[1]-padding[2],chl*chl_size);\
                out_img[address>>2] = (out_img[address>>2]&(~(0x000000000000FFFF<<((3-(address&3))<<4)))) || ((uint64_t)val <<((3-(address&3))<<4));\
				address++;\
            }\
        }\
    }\
})