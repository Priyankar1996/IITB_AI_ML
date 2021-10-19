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
#else
#include "aa_c_model.h"
#endif

#define ORDER 16
	
uint64_t expected_values[2*ORDER];
uint64_t values[2*ORDER];

void Exit(int sig)
{
	fprintf(stderr, "## Break! ##\n");
	exit(0);
}


uint32_t allocatePage(uint16_t tag, uint8_t from_head, uint16_t number_of_words)
{
	uint32_t ret_val = 0;
	uint64_t req = (from_head ? 1 : 2); // alloc from head/tail
	req = (req << 16) | tag; // tag
	req = (req << 8) | 1; // number of arguments.
	req = (req << 32) | number_of_words; // request 16 words.

#ifdef SW
	write_uint64("REQUEST_PIPE", req);
#else
	sock_write_uint64("REQUEST_PIPE", req);
#endif
	uint64_t resp = read_uint64("RESPONSE_PIPE");
	if(resp >> 56)
	{
		fprintf(stderr,"Error: in allocate for tag %d.\n", tag);
	}
	ret_val = (resp & 0xffffffff);
	fprintf(stderr,"Info: allocatePage returns 0x%x for tag %d.\n", ret_val, tag);
	return(ret_val);
}

uint8_t deallocatePage(uint16_t tag, uint32_t number_of_pages)
{
	uint8_t retval = 0;
	uint64_t req = 3;
	req = (req << 16) | tag;
	req = (req << 8)  | 1;
	req = (req << 32) | number_of_pages;

#ifdef SW
	write_uint64("REQUEST_PIPE", req);
#else
	sock_write_uint64("REQUEST_PIPE", req);
#endif

	uint64_t resp = read_uint64("RESPONSE_PIPE");
	if(resp >> 56)
	{
		fprintf(stderr,"Error: in de-allocate for tag %d.\n", tag);
		retval = 1;
	}
	else
	{
		fprintf(stderr,"Info: deallocate for tag %d.\n", tag);
	}
	return(retval);
}

uint8_t writeToMem(uint16_t tag, uint32_t nwords, uint32_t base_addr, uint32_t stride, uint64_t* buf)
{
	uint8_t ret_val = 0;
	uint64_t req = 5;
	req = (req << 16) | tag; // tag
	req = (req << 8) | 3; // number of arguments.
	req = (req << 32) | nwords; // arg 0
#ifdef SW
	write_uint64("REQUEST_PIPE", req);
#else
	sock_write_uint64("REQUEST_PIPE", req);
#endif

	uint64_t req2 = base_addr;  // arg 1
	req2 = (req2 << 32) | stride; // arg 2

#ifdef SW
	write_uint64("REQUEST_PIPE", req2);
	write_uint64_n ("REQUEST_PIPE", buf, nwords);
	uint64_t resp = read_uint64("RESPONSE_PIPE");
#else
	sock_write_uint64("REQUEST_PIPE", req2);
	sock_write_uint64_n ("REQUEST_PIPE", buf, nwords);
	uint64_t resp = sock_read_uint64("RESPONSE_PIPE");
#endif


	if(resp >> 56)
	{
		fprintf(stderr,"Error: in write.\n");
		ret_val = 1;
	}
	return(ret_val);
}

uint8_t readFromMem(uint16_t tag, uint32_t nwords, uint32_t base_addr, uint32_t stride, uint64_t* buf)
{
	uint8_t ret_val = 0;
	uint64_t req = 4;
	req = (req << 16) | tag; // tag
	req = (req << 8) | 3; // number of arguments.
	req = (req << 32) | nwords; // arg 0
#ifdef SW
	write_uint64("REQUEST_PIPE", req);
#else
	sock_write_uint64("REQUEST_PIPE", req);
#endif

	uint64_t req2 = base_addr;  // arg 1
	req2 = (req2 << 32) | stride; // arg 2
#ifdef SW
	write_uint64("REQUEST_PIPE", req2);
	uint64_t resp = read_uint64("RESPONSE_PIPE");
	read_uint64_n ("RESPONSE_PIPE", buf, nwords);
#else
	sock_write_uint64("REQUEST_PIPE", req2);
	uint64_t resp = sock_read_uint64("RESPONSE_PIPE");
	sock_read_uint64_n ("RESPONSE_PIPE", buf, nwords);
#endif

	if(resp >> 56)
	{
		fprintf(stderr,"Error: in read.\n");
		ret_val = 1;
	}
	return(ret_val);
}




int main(int argc, char* argv[])
{
	signal(SIGINT,  Exit);
  	signal(SIGTERM, Exit);
	int I;

#ifdef AA2C
	init_pipe_handler();
	start_daemons(stdout,1);
#endif

	int SWEEP = 0;
	for(SWEEP = 0; SWEEP < 4; SWEEP++)
	{
		for(I = 0; I < 2*ORDER; I++)
			expected_values[I] = I + SWEEP;

		// allocate ORDER pages.
		uint32_t base_addr_0 = allocatePage(SWEEP+1,(SWEEP & 0x1),ORDER);
		uint32_t base_addr_1 = allocatePage(SWEEP+2,(SWEEP & 0x1),ORDER);

		// write to both blocks.
		writeToMem (2*SWEEP+1, ORDER, base_addr_0, 1, expected_values);
		writeToMem (2*SWEEP+1, ORDER, base_addr_1, 1, &(expected_values[ORDER]));

		// read back
		readFromMem(3*SWEEP, ORDER, base_addr_0, 1, values);
		readFromMem(3*SWEEP, ORDER, base_addr_1, 1, &(values[ORDER]));


		for(I = 0; I < 2*ORDER; I++)
		{
			if(values[I] != expected_values[I])
				fprintf(stderr,"Error: mismatch at I=%d, val=0x%x, expected=0x%x\n", values[I], expected_values[I]);
		}

		deallocatePage(SWEEP+2, ORDER);
		deallocatePage(SWEEP+1, ORDER);
	}


	return(0);
}
