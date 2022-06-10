// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <float.h>
#include "sized_tensor.h"

void convolution3D();
void convolve();
void sendModule();

#define __I16 1

#define __dt__ int16_t
#define __dt_min_val__ 0x8000

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
void loadKernelChannel(uint64_t start, uint64_t end, uint8_t pingpong);
void access_T(uint16_t nc, uint16_t r, uint16_t c, uint16_t r1, uint16_t ch, uint16_t a);
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
	#define access_T(val,a,b,c,d,e) ({;})
	#define loadKernelChannel(s,e,p) ({0;})
#endif

#define __increment_mm__(row,col,max_col) ({\
	col++;\
	if (col == max_col){\
		col = 0;\
		row++;\
	}\
})
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

#define __convolution3D_div__( cb , rb, chl_out, chl_in, ct, rk, ck) ({\
	uint16_t num_cont = ck*chl_in;\
	uint32_t size_kernel = num_cont*rk;\
	uint16_t chl=0;\
	while(1)\
	{\
		write_uint16("num_out_pipe",rb);\
		write_uint16("num_out_pipe",cb);\
		loadKernelChannel(chl*size_kernel,(chl+1)*size_kernel,chl&1);\
		access_T(num_cont,rb,cb-1,rk-1, chl_in , ct);\
		chl++;\
		if (chl == chl_out) break;\
	}\
	uint8_t done = read_uint8("input_done_pipe");\
})
