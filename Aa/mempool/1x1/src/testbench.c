#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <pthreadUtils.h>
#include <Pipes.h>
#include <pipeHandler.h>
#ifndef SW
#include "vhdlCStubs.h"
#endif

#define ORDER 16
	
uint64_t expected_values[ORDER];
uint64_t values[ORDER];

void Exit(int sig)
{
	fprintf(stderr, "## Break! ##\n");
	exit(0);
}


void allocatePage()
{
	// IN PROGRESS....
	uint64_t req = 1; // alloc
	req = (req << 8) | 1; // tag
	req = (req << 24);
	req = (req << 32) | 16; // request 16 words.
}


int main(int argc, char* argv[])
{
	signal(SIGINT,  Exit);
  	signal(SIGTERM, Exit);
	int I;
	for(I = 0; I < ORDER; I++)
		expected_values[I] = I;

	uint32_t base_addr = allocatePage();
	writeValues();
	readValues();
	deallocatePage();

	for(I = 0; I < ORDER; I++)
	{
		if(values[I] != expected_values[I])
			fprintf(stderr,"Error: mismatch at I=%d, val=0x%x, expected=0x%x\n", values[I], expected_values[I]);
	}


	return(0);
}
