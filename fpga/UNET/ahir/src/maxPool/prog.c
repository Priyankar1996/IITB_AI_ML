#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"

void maxPool3D(uint16_t cb, uint16_t rb, uint16_t ct, uint16_t chl_out, uint8_t index_in, uint8_t index_out)
{
	uint16_t ce = cb;
	uint16_t re = rb;
	uint16_t dim1d = ct;
	uint16_t offset1 = chl_out>>3, offset2 = dim1d*offset1;
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	__aa_barrier__();
	__maxPoolOfTensors3D_div__( 0, 0, re,ce,dim1d,ce,offset1,offset2, index_in, index_out);
	__aa_barrier__();
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	__aa_barrier__();
	sendB (cb*rb*chl_out);
}
