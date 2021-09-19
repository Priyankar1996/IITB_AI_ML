#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "mempool.h"

#define NPAGES     8

MemPool 	pool;
MemPoolRequest 	req;
MemPoolResponse resp;

int _err_ = 0;

int allocateAndFillPages(uint32_t* rtags, uint32_t* base_addresses)
{
	
	uint32_t I;
	for(I = 1; I <= NPAGES; I++)
	{

		req.request_type = (I&1) ? ALLOCATE_AT_HEAD : ALLOCATE_AT_TAIL;
		req.request_tag  = I;
		req.arguments[0]  = 1;  // 1 page at a time.
	
		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not allocate memory.\n");
			return(1);
		}
	
		// save information for later use.
		rtags[I-1] = I;
		base_addresses[I-1] = resp.allocated_base_address;

		// Write known values into the write page.
		uint32_t J;
		for(J=0; J < MEMPOOL_PAGE_SIZE; J++)
		{
			req.write_data[J] = I*J;
		}

		req.request_type = WRITE;
		req.request_tag  = I + NPAGES;
		req.arguments[0] = MEMPOOL_PAGE_SIZE;
		req.arguments[1] = resp.allocated_base_address;



		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not write into memory.\n");
			return(1);
		}

		fprintf(stderr,"Info: wrote into page %d.\n", I);
	}

	return(0);
}


//
// Note: deallocate in reverse order of allocate.
//   return non-zero on error.
//
int readAndDeallocatePages(uint32_t* rtags, uint32_t* base_addresses)
{
	int error_flag = 0;
	int I;
	for(I = 1; I <= NPAGES; I++)
	{
		// read and check.
		req.request_type = READ;
		req.request_tag  = I + NPAGES;
		req.arguments[0] = MEMPOOL_PAGE_SIZE; // 512 words.
		req.arguments[1] = base_addresses[NPAGES-I];

		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not read from memory.\n");
			error_flag = 1;
			break;
		}

		uint32_t J;
		for(J = 0; J < MEMPOOL_PAGE_SIZE; J++)
		{
			if(resp.read_data[J] != (NPAGES-I+1)*J)
			{
				fprintf(stderr,"Error: read error page %d index %d\n", I, J);
				error_flag = 1;
			}
		}

		// Now deallocate
		req.request_type = DEALLOCATE;
		req.request_tag  = rtags[NPAGES-I];
		req.arguments[0] = 1;		// 1 page to be deallocated.
		req.arguments[1] = base_addresses[NPAGES-I];

		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not deallocate memory.\n");
			error_flag = 1;
			break;
		}

		fprintf(stderr,"Info: read from page %d.\n", I);
		
	}
	return(error_flag);
}



int main (int argc, char* argv[])
{
	_err_ = 0;

	initMemPool(&pool, 1, NPAGES);	
	
	uint32_t request_tags[NPAGES];
	uint32_t base_addresses[NPAGES];


	// Allocate and fill pages
	_err_ = allocateAndFillPages(request_tags, base_addresses) || _err_;

	// read and deallocate.
	_err_ =  readAndDeallocatePages(request_tags, base_addresses) || _err_;

	if(_err_)
		fprintf(stderr,"FAILURE.\n");
	else
		fprintf(stderr,"SUCCESS.\n");

	return(_err_);
}


