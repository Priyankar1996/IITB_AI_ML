#include <stdlib.h>
#include <stdint.h>
#include <Pipes.h>
#include <stdio.h>
#include "pipeHandler.h"
#include "prog.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
#else
#define __loop_pipelining_on__(pipeline_depth, buffering, full_rate) ;
#endif


uint32_t a_matrix[ORDER][ORDER];
uint32_t b_matrix[ORDER][ORDER];
uint32_t c_matrix[ORDER][ORDER];


void send_output()
{
	uint32_t i,j;
	for(i=0; i < ORDER; i++)
	{
		for (j = 0; j < ORDER; j++)
		{
			write_uint32("result_pipe",c_matrix[i][j]);
		}
	}
}

void get_input()
{
	uint32_t i,j;
	for(i=0; i < ORDER; i++)
	{
		for (j = 0; j < ORDER; j++)
		{
			uint32_t v = read_uint32("in_data_pipe");
			a_matrix[i][j] = v;
		}
	}

#ifdef SW
	fprintf(stderr,"input_module: got a.\n");
#endif
	for(i=0; i < ORDER; i++)
	{
		for (j = 0; j < ORDER; j++)
		{
			uint32_t v = read_uint32("in_data_pipe");
			b_matrix[i][j] = v;
		}
	}

#ifdef SW
	fprintf(stderr,"input_module: got b\n");
#endif
}


#define __mmultiply__(L, H) {\
	uint32_t i,j,k;\
	for(i=L ; i < H; i++)\
	{\
		for (j = 0; j < ORDER; j++)\
		{\
			uint32_t v = 0;\
			for(k = 0; k < ORDER; k++)\
			{\
				__loop_pipelining_on__(15,1,1);\
				/*fprintf(stderr,"m:%d,%d,%d.\n", i,k,j);*/\
				v += a_matrix[i][k]*b_matrix[k][j];\
			}\
			c_matrix[i][j]  = v;\
		}\
	}}


void mmultiplyLower()
{
	uint8_t s = read_uint8("lower_start");
#ifdef SW
	fprintf(stderr,"Start lower.\n");
#endif
	__mmultiply__(0, (ORDER/2));
#ifdef SW
	fprintf(stderr,"Done lower.\n");
#endif
	write_uint8 ("lower_done", s);
}

void mmultiplyUpper()
{
	uint8_t s = read_uint8("upper_start");
#ifdef SW
	fprintf(stderr,"Start upper.\n");
#endif
	__mmultiply__((ORDER/2), ORDER);
#ifdef SW
	fprintf(stderr,"Done upper.\n");
#endif
	write_uint8 ("upper_done", s);
}

void mmultiply ()
{
	get_input();
#ifndef SW
	uint64_t start_time = timer();
#endif
	write_uint8("lower_start", 1);
	write_uint8("upper_start", 1);

	uint8_t  sl = read_uint8("lower_done");
	uint8_t  su = read_uint8("upper_done");

#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	send_output();
}
