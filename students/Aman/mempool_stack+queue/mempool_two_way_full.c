#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "mempool.h"

void initMemPool(MemPool* mp, uint32_t mem_pool_index, uint32_t mem_pool_size_in_pages)
{
	mp->mem_pool_index = mem_pool_index;
	mp->mem_pool_size_in_pages = mem_pool_size_in_pages;

	mp->requester_buffer  = (uint32_t*) 
				malloc (mem_pool_size_in_pages*sizeof(uint32_t));
	mp->mem_pool_buffer = (uint64_t*)
				malloc (mem_pool_size_in_pages*MEMPOOL_PAGE_SIZE*sizeof(uint64_t));

	// head_pointer is not part of the allocated memory, but the tail_pointer is.
	// Number of allocated pages = (head_pointer - tail_pointer) % mem_pool_size_in_pages
	// Initially head_pointer and tail_pointer are both set to 0.
	// Thus, no pages allocated initially, and all pages are free.
	mp->head_pointer    = 0;
	mp->tail_pointer     = 0;
	mp->number_of_free_pages = mem_pool_size_in_pages;

	mp->req_head_pointer = 0;
	mp->req_tail_pointer  = 0;

	mp->requester_buffer[0] = 0;
	mp->mem_pool_buffer[0]  = 0;
}

// Head corresponds to the pointer that increases on allocation from its end
void allocatePagesAtHead(MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	MemPoolResponseStatus status = NOT_OK;
	uint32_t n_pages_requested = req->arguments[0];

	if(mp->number_of_free_pages >= n_pages_requested)
	//	
	// enough pages available?
	//
	
	{
		// New address of allocation
		resp->allocated_base_address = mp->head_pointer * MEMPOOL_PAGE_SIZE;
		
		// Adding at head, so increment head_pointer
		mp->head_pointer = (mp->head_pointer + n_pages_requested) %
					(mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);

		// Update number of free pages
		mp->number_of_free_pages -= n_pages_requested;

		// Add request_tag to requester_buffer
		mp->requester_buffer[mp->req_head_pointer] = req->request_tag;
	
		// Update req_head_pointer
		uint32_t next_rwp  = (mp->req_head_pointer + 1) % mp->mem_pool_size_in_pages;
		mp->req_head_pointer = next_rwp;

		// return OK
		status = OK;
	}

	resp->request_tag = req->request_tag;
	resp->status = status;
}

void allocatePagesAtTail(MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp)
{
	MemPoolResponseStatus status = NOT_OK;
	uint32_t n_pages_requested = req->arguments[0];

	if(mp->number_of_free_pages >= n_pages_requested)
	//	
	// enough pages available?
	//

	{
		// New address of allocation
		// Adding at tail, so new address will be less than tail_pointer
		// Tail pointer will be decremented by n_pages_requested.
		// Added (mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE) to ensure that
		// the address lies in a meaningful range
		uint32_t address = (mp->tail_pointer + (mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE)
					- n_pages_requested) % (mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);
		resp->allocated_base_address  = address;
		mp->tail_pointer = address;

		// Update number of free pages
		mp->number_of_free_pages -= n_pages_requested;

		// Add request_tag to requester_buffer
		mp->requester_buffer[mp->req_tail_pointer] = req->request_tag;
	
		// Update req_head_pointer
		uint32_t next_rwp  = (mp->req_tail_pointer + mp->mem_pool_size_in_pages - 1) % mp->mem_pool_size_in_pages;
		mp->req_tail_pointer = next_rwp;

		// return OK
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
		// Tags for deallocation at head and tail respectively
		uint32_t head_tag = mp->requester_buffer[(mp->req_head_pointer + mp->mem_pool_size_in_pages -
												1)%mp->mem_pool_size_in_pages];
		uint32_t tail_tag = mp->requester_buffer[mp->req_tail_pointer];

		// Deallocation at tail
		if(tail_tag == req->request_tag)
		{
			mp->req_tail_pointer = 
					(mp->req_tail_pointer + 1) % mp->mem_pool_size_in_pages;
			mp->number_of_free_pages += n_pages_requested; 
			mp->tail_pointer = (mp->tail_pointer + (n_pages_requested*MEMPOOL_PAGE_SIZE)) %
							(mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);	
			resp->status = OK;
		}

		// Deallocation at head
		else if(head_tag == req->request_tag)
		{
			mp->req_head_pointer = 
					(mp->req_head_pointer + mp->mem_pool_size_in_pages - 1) % mp->mem_pool_size_in_pages;
			mp->number_of_free_pages += n_pages_requested; 
			mp->head_pointer = (mp->head_pointer + (mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE) -
							(n_pages_requested*MEMPOOL_PAGE_SIZE)) %
							(mp->mem_pool_size_in_pages * MEMPOOL_PAGE_SIZE);	
			resp->status = OK;
		}
		else
		{
			fprintf(stderr,"Error: mempool %d, Mempool contiguity error (dealloc-requester=%d, "
				" allowed dealloc-requesters={%d,%d}\n", 	mp->mem_pool_index,
					req->request_tag, tail_tag,head_tag);
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
		case ALLOCATE_AT_HEAD:
			allocatePagesAtHead(mp, req, resp);
			break;
		case ALLOCATE_AT_TAIL:
			allocatePagesAtTail(mp, req, resp);
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

