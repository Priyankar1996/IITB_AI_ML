// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

// #define __F64 1

#define __dim0__(T) ({T.descriptor.descriptor.dimensions[0];})
#define __dim1__(T) ({T.descriptor.descriptor.dimensions[1];})
#define __dim2__(T) ({T.descriptor.descriptor.dimensions[2];})

#ifdef __U64
	#define __dt__ uint64_t
	#define __dt_min_val__ 0
#endif
#ifdef __U32
	#define __dt__ uint32_t
	#define __dt_min_val__ 0
#endif
#ifdef __U16
	#define __dt__ uint16_t
	#define __dt_min_val__ 0
#endif
#ifdef __U8
	#define __dt__ uint8_t
	#define __dt_min_val__ 0
#endif
#ifdef __I64
	#define __dt__ int64_t
	#define __dt_min_val__ 0x8000000000000000
#endif
#ifdef __I32
	#define __dt__ int32_t
	#define __dt_min_val__ 0x80000000
#endif
#ifdef __I16
	#define __dt__ int16_t
	#define __dt_min_val__ 0x8000
#endif
#ifdef __I8
	#define __dt__ int8_t
	#define __dt_min_val__ 0x80
#endif
#ifdef __F64
	#define __dt__ double
	#define __dt_min_val__ -DBL_MAX
#endif
#ifdef __F32
	#define __dt__ float
	#define __dt_min_val__ -FLT_MAX
#endif
#ifdef __F16
	#define __dt__ uint16_t
	#define __dt_min_val__ 0
#endif
#ifdef __F8
	#define __dt__ uint8_t
	#define __dt_min_val__ 0
#endif

#define __maxOperation__(src,l,add_src) ({\
		__dt__ data = __dt_min_val__;\
		for (uint16_t i = 0; i < l; i++)\
		{\
			for (uint16_t j = 0; j < l; j++)\
			{\
				if ( (*((__dt__*)src.data_array + add_src))> data) \
					data =  (*((__dt__*)src.data_array + add_src));\
				add_src+=__dim2__(src);\
			}\
			add_src+=(__dim1__(src)-l)*__dim2__(src);\
		}\
		data;\
	})

#define __maxPoolOfTensors3D__(src, dst, l, stride) ({\
	dst.descriptor.descriptor = src.descriptor.descriptor;\
	__dim0__(dst) = (__dim0__(src)<l) ? 0 : 1+((__dim0__(src)-l)/stride);\
	__dim1__(dst) = (__dim1__(src)<l) ? 0 : 1+((__dim1__(src)-l)/stride);\
	uint32_t address = 0, add_src;\
	for (uint16_t row = 0; row < __dim0__(dst); row++)\
	{\
		for (uint16_t col = 0; col < __dim1__(dst); col++)\
		{\
			for (uint16_t chl = 0; chl < __dim2__(dst); chl++)\
			{\
			add_src = chl+__dim2__(src)*(col*stride+__dim1__(src)*row*stride);\
			__dt__ data = __maxOperation__(src,l,add_src);\
			*((__dt__*)dst.data_array+address) = data;\
			address++;\
			}\
		}\
	}\
})
