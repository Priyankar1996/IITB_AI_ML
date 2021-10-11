#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include "tensor.h"
#include "mempool.h"
#include "createTensor.h"
#include "genRandomTensor.h"
#include "mtwist.h"

// tensor is filled in space. No new space given.

// this function initializes seed as per the chosen PRNG
void my_srand(RngType t, uint32_t seed){
	switch(t){
		case mersenne_Twister :
			mt_seed32new(seed) ;
			break ;
		default:
			srand(seed);
	}
}

// this function generates uint64 random number as per the chosen PRNG
uint64_t my_rand(RngType t){
	switch(t){
		case mersenne_Twister : 
			return mt_llrand();
		default : ;
			uint64_t r = 0;
			uint8_t i ;
			for (i=0; i<64; i += 30 /*15*/) {
				r = r*((uint64_t)RAND_MAX + 1) + rand();
			}
			return r;
	}	
}

// this function fills the tenspr "result" 
// It fills result at the same place in memory
// From uint64 random number, other data type numbers are generated by mod, division methods
void genRandomTensor(uint32_t seed, RngType t, Tensor* result)
{	
	// For interconversion of bits and float representations
	union ufloat {
    float f;
    uint32_t u;
	} t1,t2 ;

	union udouble {
		double d ;
		uint64_t u;
	} tb ;

	uint32_t ten_sz = sizeofTensorDataInBytes(result->descriptor.data_type);
	uint32_t num_dims = result->descriptor.number_of_dimensions ;
	uint32_t total_num = 1 ;
	uint32_t I ;
	for (I=0; I < num_dims; I++)	total_num *= result->descriptor.dimensions[I] ; 

	// ceil is replaced as below. ceil(a/b) = a/b + (a%b != 0)
	uint32_t num_words = CEILING(total_num*ten_sz, 8) ; 
	uint32_t num_requests = CEILING(num_words, MAX_SIZE_OF_REQUEST_IN_WORDS); 
	// This switch statement can later be removed competely
	switch (t)
	{
		case wichmann_Hill:
			fprintf(stderr,"Error: Function not ready yet.\n");
			break;
		case philox:
			fprintf(stderr,"Error: Function not ready yet.\n");
			break;
		case threefry:
			fprintf(stderr,"Error: Function not ready yet.\n");
			break;
		default:
			my_srand(t, seed);
			// seed as per algorithm
			MemPoolRequest tr_req ;
			uint32_t K;
			for (K=0; K < num_requests ; K++ ){
				uint32_t J ;
				uint32_t curr_writes = (K == num_requests - 1)? num_words % MAX_SIZE_OF_REQUEST_IN_WORDS : MAX_SIZE_OF_REQUEST_IN_WORDS ;

				switch(result->descriptor.data_type){
					case u8:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 8 : 8 ;
							uptill = (uptill)? uptill : 8 ;
							uint8_t inn ;
							uint64_t data = 0;
							//printf("uptil %d\n",uptill );
							for(inn = 0; inn < uptill; inn++){
								uint8_t tem_data = my_rand(t) % UINT8_MAX ;
								data |= (((long unsigned)tem_data << 8*(inn)) & ((long unsigned)0xff << 8*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;
					case u16:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 4 : 4 ;
							uptill = (uptill)? uptill : 4 ;
							uint8_t inn ;
							uint64_t data = 0;
							for(inn = 0; inn < uptill; inn++){
								uint16_t tem_data = my_rand(t) % UINT16_MAX;
								data |= (((long unsigned)tem_data << 16*(inn)) & ((long unsigned)0xffff << 16*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;	
					case u32:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 2 : 2 ;
							uptill = (uptill)? uptill : 2 ;
							uint8_t inn ;
							uint64_t data = 0;
							for(inn = 0; inn < uptill; inn++){
								uint32_t tem_data = my_rand(t) % UINT32_MAX;
								data |= (((long unsigned)tem_data << 32*(inn)) & ((long unsigned)0xffffffff << 32*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;		
					case u64:
						for (J=0; J<curr_writes; J++){
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = my_rand(t);
						} 
						break ;	
					case i8:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 8 : 8 ;
							uptill = (uptill)? uptill : 8 ;
							uint8_t inn ;
							uint64_t data = 0;
							for(inn = 0; inn < uptill; inn++){
								int8_t tem_data = (int64_t)(my_rand(t) - UINT64_MAX/2) % INT8_MAX ;
								data |= (((long unsigned)tem_data << 8*(inn)) & ((long unsigned)0xff << 8*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;	
					case i16:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 4 : 4 ;
							uptill = (uptill)? uptill : 4 ;
							uint8_t inn ;
							uint64_t data = 0;
							for(inn = 0; inn < uptill; inn++){
								int16_t tem_data = (int64_t)(my_rand(t) - UINT64_MAX/2) % INT16_MAX ;
								data |= (((long unsigned)tem_data << 16*(inn)) & ((long unsigned)0xffff << 16*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;		
					case i32:
						for (J=0; J<curr_writes; J++){
							uint8_t uptill = ((K == num_requests - 1) && (J == curr_writes - 1))? total_num % 2 : 2 ;
							uptill = (uptill)? uptill : 2 ;
							uint8_t inn ;
							uint64_t data = 0;
							for(inn = 0; inn < uptill; inn++){
								int32_t tem_data = (int64_t)(my_rand(t) - UINT64_MAX/2) % INT32_MAX ;
								data |= (((long unsigned)tem_data << 32*(inn)) & ((long unsigned)0xffffffff << 32*(inn) ) );
							}
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						} 
						break ;	
					case i64:
						for (J=0; J<curr_writes; J++) tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = (int64_t)(my_rand(t) - UINT64_MAX/2) % INT64_MAX;
						break ;	
					case float32:
						// returns random number in range [0, 1] scaling can be done as required by user later.
						//union ufloat t1, t2 ;	
						for (J=0; J<curr_writes; J++){
							t1.f = (float)my_rand(t)/UINT64_MAX ;							
							t2.f = (float)my_rand(t)/UINT64_MAX ;
							//printf("ori %f %f \n",t1.f,t2.f );
							uint64_t data = 0 ;
							uint64_t u1 = t1.u ;
							uint64_t u2 = t2.u ;
							data |= (((long unsigned)u2 << 32) & ((long unsigned)0xffffffff << 32)) | (u1) ;
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = data;
						}
						break ;	
					default : //float64
						for (J=0; J<curr_writes; J++) {
							tb.d = (double)my_rand(t)/UINT64_MAX  ;
							//printf("ori %lf \n",tb.d);
							tr_req.write_data[J + K*MAX_SIZE_OF_REQUEST_IN_WORDS] = tb.u;
						}		
				}
				
				tr_req.request_type = WRITE;
				tr_req.request_tag  = K + 1;
				tr_req.arguments[0] = curr_writes;
				tr_req.arguments[1] = result->mem_pool_buffer_pointer + K*MAX_SIZE_OF_REQUEST_IN_WORDS;	
				tr_req.arguments[2] = 1 ;

				MemPoolResponse tr_resp;
				memPoolAccess((MemPool *)result->mem_pool_identifier, &tr_req, &tr_resp);
				if(tr_resp.status !=  OK)
				{
					fprintf(stderr,"Error: could not write into memory.\n");
					return;
				}
			} 

	}
}

