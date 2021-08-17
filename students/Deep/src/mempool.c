#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "../include/mempool.h"


void initMemPool(MemPool* mp, uint32_t mem_pool_index, uint32_t mem_pool_size_in_pages)
{
	mp->mem_pool_index = mem_pool_index;
	mp->mem_pool_size_in_pages = mem_pool_size_in_pages;

	mp->requester_buffer  = (uint32_t*) 
				malloc (mem_pool_size_in_pages*sizeof(uint32_t));
	mp->mem_pool_buffer = (uint64_t*)
				malloc (mem_pool_size_in_pages*MEMPOOL_PAGE_SIZE*sizeof(uint64_t));
	mp->write_pointer    = 0;
	mp->read_pointer     = 0;
	mp->number_of_free_pages = mem_pool_size_in_pages;

	mp->req_write_pointer = 0;
	mp->req_read_pointer  = 0;

	mp->requester_buffer[0] = 0;
	mp->mem_pool_buffer[0]  = 0;
}


void allocatePages(MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	MemPoolResponseStatus status = NOT_OK;
	uint32_t n_pages_requested = req->arguments[0];

	if(mp->number_of_free_pages >= n_pages_requested)
	//	
	// enough pages available?
	//
	{
		resp->allocated_base_address               = mp->write_pointer * MEMPOOL_PAGE_SIZE;
		mp->write_pointer = (mp->write_pointer + n_pages_requested) %
					(mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);
		mp->number_of_free_pages -= n_pages_requested;

		mp->requester_buffer[mp->req_write_pointer] = req->request_tag;
	
		uint32_t next_rwp  = (mp->req_write_pointer + 1) % mp->mem_pool_size_in_pages;
		mp->req_write_pointer = next_rwp;

		status = OK;
	}

	resp->request_tag = req->request_tag;
	resp->status = status;
}

void deallocatePages(MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	resp->status = NOT_OK;
	uint32_t n_pages_requested = req->arguments[0];
	
	if((mp->mem_pool_size_in_pages - mp->number_of_free_pages) >= n_pages_requested)
	//
	// number of pages used must be >= number of pages being freed.
	//
	{
		uint32_t fifo_tag = mp->requester_buffer[mp->req_read_pointer];
		if(fifo_tag == req->request_tag)
		{
			mp->req_read_pointer = 
					(mp->req_read_pointer + 1) % mp->mem_pool_size_in_pages;
			mp->number_of_free_pages += n_pages_requested; 
			mp->read_pointer = (mp->read_pointer + (n_pages_requested*MEMPOOL_PAGE_SIZE)) %
							(mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);	
			resp->status = OK;
		}
		else
		{
			fprintf(stderr,"Error: mempool %d, FIFO error (dealloc-requester=%d, "
				" last-alloc-requester=%d\n", 	mp->mem_pool_index,
					req->request_tag, fifo_tag);
		}
	}
}

			
void readDataBlock (MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	resp->status = NOT_OK;

	uint32_t n_words     = req->arguments[0];
	uint32_t start_index = req->arguments[1];

	uint32_t MAXADDR = mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE;
	if(n_words <= MAX_SIZE_OF_REQUEST_IN_WORDS)
	{
		uint32_t I;
		for(I = 0; I < n_words; I++)
		{
			resp->read_data[I] = mp->mem_pool_buffer[(start_index + I) % MAXADDR];
		}
		resp->status = OK;
	} 
}

			
void writeDataBlock (MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	resp->status = NOT_OK;

	uint32_t n_words     = req->arguments[0];
	uint32_t start_index = req->arguments[1];

	uint32_t MAXADDR = mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE;
	if(n_words <= MAX_SIZE_OF_REQUEST_IN_WORDS)
	{
		uint32_t I;
		for(I = 0; I < n_words; I++)
		{
			mp->mem_pool_buffer[(start_index + I) % MAXADDR] = req->write_data[I];
		}

		resp->status = OK;
	} 
}


void memPoolAccess (MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	switch(req->request_type)
	{
		case ALLOCATE:
			allocatePages(mp, req, resp);
			break;
		case DEALLOCATE:
			deallocatePages(mp, req, resp);
			break;
		case READ:
			readDataBlock(mp, req, resp);
			break;
		case WRITE:
			writeDataBlock(mp, req, resp);
			break;
		default:
			fprintf(stderr,"Error:memPoolAccess: unknown request.\n");
			break;
	}
	return;
}

