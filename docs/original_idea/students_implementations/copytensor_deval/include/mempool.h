#ifndef _mempool_h____
#define _mempool_h____

//
// mem-pool is organized into 4KB pages.
// Each page consists of 512  64-bit dwords.
//
#define MEMPOOL_WORD_SIZE         	8	 // bytes.
#define MEMPOOL_PAGE_SIZE      	  	512	 // words.
#define MAX_SIZE_OF_REQUEST_IN_WORDS    1024	 // words.
#define MAX_MEMPOOL_SIZE_IN_PAGES	1024	 // pages

typedef enum {
	ALLOCATE,
	DEALLOCATE,
	READ,
	WRITE

} MemPoolRequestType;

typedef enum {
	OK,
	NOT_OK
} MemPoolResponseStatus;


typedef uint64_t MemPoolWord;


typedef struct __MemPoolRequest {
 	// allocate/de-allocate/write/read.
	MemPoolRequestType   request_type;

	// this tag is used to ensure last popped is
	// being pushed back.
	uint32_t   request_tag;


	uint32_t  arguments[4];
	// arguments
	//     request_type = allocate
	//          argument[0] = number of pages requested.
	//     request type = deallocate
	//          argument[0] = number of pages to be deallocated
	//	    Note: request_tag is matched against top of
	//	          requester stack.
	//
	//     read
	//          argument_0 = number of words requested
	// 	    argument 1 = start address
	// 	    argument 2 = stride.
	//     write
	//          argument_0 = number of words requested
	// 	    argument 1 = start address
	// 	    argument 2 = stride
	uint64_t write_data[MAX_SIZE_OF_REQUEST_IN_WORDS];

} MemPoolRequest;

typedef struct __MemPoolResponse {
	MemPoolResponseStatus   status;

	// out args.
	uint32_t request_tag;
	uint32_t allocated_base_address;
	uint64_t read_data[MAX_SIZE_OF_REQUEST_IN_WORDS];
} MemPoolResponse;


typedef struct __MemPool {

	uint32_t      mem_pool_index;
	uint32_t      mem_pool_size_in_pages;

	// write and read pointers maintain
	// the free page queue.
	uint32_t      write_pointer;
	uint32_t      read_pointer;
	uint32_t      number_of_free_pages;
	uint64_t      *mem_pool_buffer;

	// we will also maintain requester
	// queue to ensure FIFO discipline in
	// the alloc/dealloc sequence.
	uint32_t      req_write_pointer;
	uint32_t      req_read_pointer;
	uint32_t      *requester_buffer;


} MemPool;

// create and initialize mem-pool.
void initMemPool(MemPool* mp, uint32_t mem_pool_index, uint32_t mem_pool_size_in_pages);

// allocate/de-allocate/read/write.
void memPoolAccess (MemPool* mp, MemPoolRequest* req, MemPoolResponse* resp);

#endif
