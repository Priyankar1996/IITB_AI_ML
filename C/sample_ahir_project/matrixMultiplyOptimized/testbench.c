#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include "prog.h"
//
// the next two inclusions are
// to be used in the software version
//  
#ifdef SW
#include <pipeHandler.h>
#include <Pipes.h>
#include <pthreadUtils.h>
#include "prog.h"
#else
#include "vhdlCStubs.h"
#endif

//
//
uint32_t a_matrix[ORDER][ORDER], b_matrix[ORDER][ORDER], expected_c_matrix[ORDER][ORDER], c_matrix[ORDER][ORDER];

void Exit(int sig)
{
	fprintf(stderr, "## Break! ##\n");
	exit(0);
}

#ifdef SW
DEFINE_THREAD(mmultiply);
DEFINE_THREAD(mmultiplyLower);
DEFINE_THREAD(mmultiplyUpper);
#endif

void write_matrices()
{
	uint32_t i,j;
        for(i = 0; i < ORDER; i++) 
	{
        	for(j = 0; j < ORDER; j++) 
		{
			write_uint32("in_data_pipe",a_matrix[i][j]);
		}
	}
	fprintf(stderr,"Sent a.\n");

        for(i = 0; i < ORDER; i++) 
	{
        	for(j = 0; j < ORDER; j++) 
		{
			write_uint32("in_data_pipe",b_matrix[i][j]);
		}
	}
	fprintf(stderr,"Sent b.\n");
}


void read_result_matrix()
{
	uint32_t i,j;
        for(i = 0; i < ORDER; i++) 
	{
        	for(j = 0; j < ORDER; j++) 
		{
			c_matrix[i][j]= read_uint32("result_pipe");
		}
	}
}


int main(int argc, char* argv[])
{
	signal(SIGINT,  Exit);
  	signal(SIGTERM, Exit);
  	signal(SIGSEGV, Exit);

        int i,j,k;

        srand(100);

        for(i = 0; i < ORDER; i++)
	{
        	for(j = 0; j < ORDER; j++)
		{
			a_matrix[i][j] = rand();
			b_matrix[i][j] = rand();
		}
	}

        for(i = 0; i < ORDER; i++)
	{
        	for(j = 0; j < ORDER; j++)
		{
			expected_c_matrix[i][j] = 0;
        		for(k = 0; k < ORDER; k++)
				expected_c_matrix[i][j] += a_matrix[i][k] * b_matrix[k][j];
		}
	}
	
#ifdef SW
	init_pipe_handler();
	register_pipe ("in_data_pipe", 2, 32, PIPE_FIFO_MODE);
	register_pipe ("result_pipe", 2, 32, PIPE_FIFO_MODE);

	PTHREAD_DECL(mmultiply);
	PTHREAD_DECL(mmultiplyLower);
	PTHREAD_DECL(mmultiplyUpper);
	PTHREAD_CREATE(mmultiply);
	PTHREAD_CREATE(mmultiplyLower);
	PTHREAD_CREATE(mmultiplyUpper);
#endif

	write_matrices();
	read_result_matrix();



	fprintf(stdout,"results: \n ");
	for(i = 0; i < ORDER; i++)
	{
		for(j = 0; j < ORDER; j++)
		{
			if(expected_c_matrix[i][j] == c_matrix[i][j])
				fprintf(stdout,"result[%d][%d] = %d\n", i, j, c_matrix[i][j]);
			else
				fprintf(stdout,"Error: result[%d][%d] = %d, expected = %d\n", 
						i, j, c_matrix[i][j], expected_c_matrix[i][j]);

		}
	}
	fprintf(stdout,"done\n");

#ifndef  SW
	uint64_t et = read_uint64("elapsed_time_pipe");
	fprintf(stderr,"Elapsed time = %d.\n", et);
#endif

#ifdef SW
	PTHREAD_CANCEL(mmultiplyLower);
	PTHREAD_CANCEL(mmultiplyUpper);
	close_pipe_handler();
#endif
}
