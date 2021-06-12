#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "../src/genRandomTensor.c"
#include "../src/mempool.c"
#include "../src/tensor.c"

MemPool 	pool;


#define NPAGES     8

void createTensor (uint32_t ndim, uint32_t* dims, TensorDataType dt, MemPool *mpool, Tensor* result){
	TensorDescriptor t ;
	t.data_type = dt ;
	t.row_major_form = 0 ; //will keep true by default?
	t.number_of_dimensions = ndim ;
	uint32_t j ;
	for(j=0; j<ndim; j++) t.dimensions[j] = dims[j]; 

	result->descriptor = t ;
	result->mem_pool_identifier = mpool ;
	MemPoolRequest 	req;
	MemPoolResponse resp;

	uint32_t ten_sz = sizeofTensorDataInBytes(dt);
	uint32_t total_num = 1 ;
	uint32_t I ;
	for(I=0; I < ndim; I++){
		total_num *= dims[I] ; 
	}	
	uint32_t num_words = (total_num*ten_sz / 8 + ((total_num * ten_sz)%8 != 0) )  ; 
	uint32_t num_pages = num_words / MEMPOOL_PAGE_SIZE + (num_words%MEMPOOL_PAGE_SIZE != 0); 
	for(I = 1; I <= num_pages; I++)
	{

		req.request_type = ALLOCATE;
		req.request_tag  = I;
		req.arguments[0]  = 1;  // 1 page at a time.
	
		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not allocate memory.\n");
			return;
		}
	
		// save information for later use.
		// rtags[I-1] = I;
		// base_addresses[I-1] = resp.allocated_base_address;

		// Write known values into the write page.

		uint32_t curr_writes = (I == num_pages )? num_words % MEMPOOL_PAGE_SIZE : MEMPOOL_PAGE_SIZE ;
		uint32_t J;
		for(J=0; J < curr_writes; J++)
		{
			req.write_data[J] = 17;
		}

		req.request_type = WRITE;
		req.request_tag  = I + num_pages;
		req.arguments[0] = curr_writes;
		req.arguments[1] = resp.allocated_base_address;

		memPoolAccess(&pool, &req, &resp);
		if(resp.status !=  OK)
		{
			fprintf(stderr,"Error: could not write into memory.\n");
			return;
		}
		result->mem_pool_buffer_pointer = resp.allocated_base_address ;
	}

}

void preetyprint(Tensor *result){
	union ufloat {
    	float f;
    	uint32_t u;
	} t1 ;

	union udouble {
		double d ;
		uint64_t u;
	} tb ;

	MemPoolRequest 	req;
	MemPoolResponse resp;
	uint32_t ten_sz = sizeofTensorDataInBytes(result->descriptor.data_type);
	uint32_t num_dims = result->descriptor.number_of_dimensions ;
	//uint32_t sqr = result.descriptor.dimensions[0] ;
	uint32_t total_num = 1 ;
	uint32_t I ;
	for(I = 0; I < num_dims; I++){
		total_num *= result->descriptor.dimensions[I] ; 
	}
	// ceil is replaced as below. ceil(a/b) = a/b + (a%b != 0)
	uint32_t num_words = (total_num*ten_sz / 8 + ((total_num * ten_sz)%8 != 0) )  ; 
	uint32_t num_requests = num_words / MAX_SIZE_OF_REQUEST_IN_WORDS + (num_words%MAX_SIZE_OF_REQUEST_IN_WORDS != 0); 
	/*
	uint32_t out_num = 1, out ;
	uint32_t I;
	for(I=2; I < num_dims; I++){
		out_num *= result.descriptor.dimensions[I] ; 
	}
	*/	

	if(num_dims == 0)printf("[]\n");
	/*
	else if(num_dims == 1){
		uint16_t I, track = 0;
		for(I = 0; I < num_requests; I++){
			uint32_t curr_reads = (I == num_requests - 1)? num_words % MAX_SIZE_OF_REQUEST_IN_WORDS : MAX_SIZE_OF_REQUEST_IN_WORDS ;
			// read and print.
			req.request_type = READ;
			// req.request_tag ; // not reqd
			req.arguments[0] = curr_reads; // 1024 words mostly.
			req.arguments[1] = result->mem_pool_buffer_pointer + I*MAX_SIZE_OF_REQUEST_IN_WORDS;
			req.arguments[2] = 1 ;

			memPoolAccess(result->mem_pool_identifier, &req, &resp);
			if(resp.status !=  OK)
			{
				fprintf(stderr,"Error: could not read from memory.\n");
				break;
			}	

			uint64_t k;
			switch(result->descriptor.data_type){
				case u8: 
					for(k=0; k<curr_reads;k++){
						uint64_t read_word = resp.read_data[k];
						uint8_t iter ;
						for(iter = 0; iter < 8; iter++){
							uint8_t ti = (read_word>>8*(iter)) &0xff ;
							if (track == total_num) break;
							printf("%d ", ti);
							//track ++ ;
						}

					}	
					break;
				case i8:
					for(k=0; k<curr_reads;k++){
						uint64_t read_word = resp.read_data[k];
						uint8_t iter ;
						for(iter = 0; iter < 8; iter++){
							int8_t ti = (read_word>>8*(iter)) &0xff ;
							if (track == total_num) break;
							printf("%d ", ti);
							//track ++ ;
						}

					}
					break ;				
				default:
					break;				
			}		
		}
	}
	*/
	else{
		uint16_t I, track = 1;
		for(I = 0; I < num_requests; I++){
			uint32_t curr_reads = (I == num_requests - 1)? num_words % MAX_SIZE_OF_REQUEST_IN_WORDS : MAX_SIZE_OF_REQUEST_IN_WORDS ;
			// read and print.
			req.request_type = READ;
			// req.request_tag ; // not reqd
			req.arguments[0] = curr_reads; // 1024 words mostly.
			req.arguments[1] = result->mem_pool_buffer_pointer + I*MAX_SIZE_OF_REQUEST_IN_WORDS;
			req.arguments[2] = 1 ;

			memPoolAccess(result->mem_pool_identifier, &req, &resp);
			if(resp.status !=  OK)
			{
				fprintf(stderr,"Error: could not read from memory.\n");
				break;
			}	

			uint64_t k;
			uint64_t dim0, dimp ;
			if (num_dims > 1) dim0 = result->descriptor.dimensions[1] ;
			else  dim0 = total_num;
			if (num_dims > 1) dimp = result->descriptor.dimensions[0] * result->descriptor.dimensions[1] ;
			else dimp =  result->descriptor.dimensions[0] + 1 ;
			switch(result->descriptor.data_type){

				case u8: 
					for(k=0; k<curr_reads;k++){
						uint64_t read_word = resp.read_data[k];
						uint8_t iter ;
						for(iter = 0; iter < 8; iter++){
							uint8_t ti = (read_word>>8*(iter)) &0xff ;
							if (track == total_num + 1) break;
							(track % dim0)?  printf("%3d  ", ti) : printf("%3d\n", ti);
							if (!(track % dimp)) printf("\n");
							track ++ ;
						}

					}	
					break ;
				case i8:
					for(k=0; k<curr_reads;k++){
						uint64_t read_word = resp.read_data[k];
						uint8_t iter ;
						for(iter = 0; iter < 8; iter++){
							int8_t ti = (read_word>>8*(iter)) &0xff ;
							if (track == total_num + 1) break;
							(track % dim0)?  printf("%4d  ", ti) : printf("%3d\n", ti);
							if (!(track % dimp)) printf("\n");
							track ++ ;
						}

					}	
					break;
				case float32:
					for(k=0; k<curr_reads;k++){
						uint64_t read_word = resp.read_data[k];
						uint8_t iter ;
						for(iter = 0; iter < 2; iter++){
							t1.u = (read_word>>32*(iter)) & 0xffffffff ;
							if (track == total_num + 1) break;
							(track % dim0)?  printf("%0.7f  ", t1.f) : printf("%0.7f\n", t1.f);
							if (!(track % dimp)) printf("\n");
							track ++ ;
						}
					}	
					break;										
				default: //float64
					for(k=0; k<curr_reads;k++){
						tb.u = resp.read_data[k];
						if (track == total_num + 1) break;
						(track % dim0)?  printf("%0.15f  ", tb.d) : printf("%0.15f\n", tb.d);
						if (!(track % dimp)) printf("\n");
						track ++ ;	
					}					
			}		
		}
	}
	printf("\n");
}


int main(int argc, char const *argv[])
{	
	//let mem_pool_index be 1. Let NPAGES be randomly 8.  
	initMemPool(&pool, 1, NPAGES);	

	uint32_t ndim = 2 ;
	uint32_t dims[] = {4,2};  
	TensorDataType dt = float64 ;
	Tensor *result ;

    createTensor( ndim, dims, dt, &pool, result);
	printf("--------Initial Tensor-------\n\n");
	preetyprint(result)	;
	printf("-----------------------\n\n");
	printf("--------Random Tensor-------\n\n");
	RngType r = mersenne_Twister ;
    genRandomTensor(17, r, result) ;
	preetyprint(result)	;

	return 0;
}