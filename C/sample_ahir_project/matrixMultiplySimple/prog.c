#include <stdlib.h>
#include <stdint.h>
#include <Pipes.h>
#include <stdio.h>
#include "pipeHandler.h"
#include "prog.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
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

void mmultiply()
{
	uint32_t i,j,k;

#ifndef SW
	uint64_t start_time = timer();
#endif
	while(1)
	{
		get_input();
		for(i=0; i < ORDER; i++)
		{
			for (j = 0; j < ORDER; j++)
			{
				uint32_t v = 0;
				for(k = 0; k < ORDER; k ++)
				{ 
#ifndef SW
					__loop_pipelining_on__(15,1,1);
#endif
					v += a_matrix[i][k]*b_matrix[k][j];
				}

				c_matrix[i][j]  = v;
			}
		}
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
		send_output();
	}
}


