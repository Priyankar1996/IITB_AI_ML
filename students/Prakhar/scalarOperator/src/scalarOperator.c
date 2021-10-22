#include <stdint.h>
#include <stdio.h>
#include "../include/scalarOperator.h"
#include <math.h>
uint8_t add_scale_uint8(uint8_t val, Operator op, uint8_t scalar_val){
	switch(op){
		case ADD: return ((uint8_t) (val+scalar_val));
		case MULT : return ((uint8_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
uint16_t add_scale_uint16(uint16_t val, Operator op, uint16_t scalar_val){
	switch(op){
		case ADD: return ((uint16_t) (val+scalar_val));
		case MULT : return ((uint16_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
uint32_t add_scale_uint32(uint32_t val, Operator op, uint32_t scalar_val){
	switch(op){
		case ADD: return ((uint32_t) (val+scalar_val));
		case MULT : return ((uint32_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
uint64_t add_scale_uint64(uint64_t val, Operator op, uint64_t scalar_val){
	switch(op){
		case ADD: return ((uint64_t) (val+scalar_val));
		case MULT : return ((uint64_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
int8_t add_scale_int8(int8_t val, Operator op, int8_t scalar_val){
	switch(op){
		case ADD: return ((int8_t) (val+scalar_val));
		case MULT : return ((int8_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
int16_t add_scale_int16(int16_t val, Operator op, int16_t scalar_val){
	switch(op){
		case ADD: return ((int16_t) (val+scalar_val));
		case MULT : return ((int16_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
int32_t add_scale_int32(int32_t val, Operator op, int32_t scalar_val){
	switch(op){
		case ADD: return ((int32_t) (val+scalar_val));
		case MULT : return ((int32_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
int64_t add_scale_int64(int64_t val, Operator op, int64_t scalar_val){
	switch(op){
		case ADD: return ((int64_t) (val+scalar_val));
		case MULT : return ((int64_t) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
float add_scale_f32(float val, Operator op, float scalar_val){
	switch(op){
		case ADD: return ((float) (val+scalar_val));
		case MULT : return ((float) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
double add_scale_f64(double val, Operator op, double scalar_val){
	switch(op){
		case ADD: return ((double) (val+scalar_val));
		case MULT : return ((double) (val*scalar_val));
		default: ;
			fprintf(stderr,"Error: scalarOperator: unknown Operation.\n");
			return 0;
	}
}
// contiguous storage in memory pool for all the data types - assumed
void scalarOperator (Operator op, void* s, Tensor* a, Tensor* b){
	// (scale or add) point-wise operator: performs result = src.*s or src.+s as chosen by op
	// src --> a  || result --> b
	// supported op --> add, multiplication

	TensorDescriptor td_a = a->descriptor;
	TensorDataType a_dt = a->descriptor.data_type;
	uint32_t element_size = sizeofTensorDataInBytes(a_dt); 
	uint32_t n_dim = td_a.number_of_dimensions; // number of dimensions

	uint32_t num_elems = 1; // product of dims (# of elements in tensor)  

	for(uint32_t i=0; i<n_dim; i+=1) {
		num_elems *= td_a.dimensions[i];
	}
	printf("Value of num_elems %d \n",num_elems);
	int total_dwords = (ceil((num_elems*element_size)/8.0)); //number of dwords of the tensor (assuming positive)
	int num_iter = (total_dwords%CHUNK_SIZE) ?  (1+(total_dwords/CHUNK_SIZE)) : (total_dwords/CHUNK_SIZE); // 63/16 --> in the loop 16 16 16 15
	
	// Calculating Scalar value as per its datatype, which is assumed same as tensor datatype
	// Defining in global space to avoid dereferencing to obtain it again and again
	uint8_t s_8ui = *((uint8_t*)s);
	uint16_t s_16ui = *((uint16_t*)s);
	uint32_t s_32ui = *((uint32_t*)s);
	uint64_t s_64ui = *((uint64_t*)s);
	int8_t s_8i = *((int8_t*)s);
	int16_t s_16i = *((int16_t*)s);
	int32_t s_32i = *((int32_t*)s);
	int64_t s_64i = *((int64_t*)s);
	float s_32f = *((float*)s);
	double s_64f = *((double*)s);

	for(int k=0; k<num_iter;k=k+1){
		printf("Iteration %d: \n",k+1);
		int num_in_cache; // number of elements in CHUNK
		int num_dwords_stored; // number of dwords to be stored in CHUNK
		if((k==num_iter-1)&&(total_dwords%CHUNK_SIZE!=0)){
			num_in_cache = num_elems%((CHUNK_SIZE*8)/element_size);
			num_dwords_stored = total_dwords%CHUNK_SIZE;
		}
		else{
			num_in_cache = (CHUNK_SIZE*8)/element_size;
			num_dwords_stored = CHUNK_SIZE;
		}	
		printf("num_in_chunk = %d \n",num_in_cache);
		printf("num_dwords_stored = %d \n",num_dwords_stored);
		/////////////////////////////////////////////////
		// FIRST STAGE of Pipeline : Fetching from Memory 
		/////////////////////////////////////////////////

		MemPoolRequest req_a;
		req_a.request_type = READ;
		req_a.request_tag = 1; // ? not much used in READ and WRITE
		req_a.arguments[0] = num_dwords_stored; //number of dwords requested 
		req_a.arguments[1] = a->mem_pool_buffer_pointer+ k*CHUNK_SIZE;
		req_a.arguments[2] = 1; // stride = 1 as pointwise
		MemPoolResponse mpr;
		memPoolAccess((MemPool *)(a->mem_pool_identifier),&req_a,&mpr); // as in 104 of test_mempool.c

		uint64_t store_here[CHUNK_SIZE]; // initialized an empty array with required size for storing from copyTensor. 
		void *array;
		array = store_here;  
		for(int i=0; i<num_in_cache; i=i+1){ // initially was num_dwords stored
			copyTensorEntry(&td_a,array,i,mpr.read_data,i);
		}

		/////////////////////////////////////
		// SECOND STAGE of Pipeline : Compute  
		/////////////////////////////////////
		for(int j=0; j<num_in_cache; j++) {
			switch(a_dt){ 
				case u8  : ;
					uint8_t x_8ui = *(((uint8_t*)array) + j);
					*(((uint8_t*)array) + j) = add_scale_uint8(x_8ui,op,s_8ui);
					break;
				case u16 : ;
					uint16_t x_16ui = *(((uint16_t*)array) + j);
					*(((uint16_t*)array) + j) = add_scale_uint16(x_16ui,op,s_16ui);
					break;
				case u32 : ;
					uint32_t x_32ui = *(((uint32_t*)array) + j);
					*(((uint32_t*)array) + j) = add_scale_uint32(x_32ui,op,s_32ui);
					break;
				case u64 : ;
					uint64_t x_64ui = *(((uint64_t*)array) + j);
					*(((uint64_t*)array) + j) = add_scale_uint64(x_64ui,op,s_64ui);
					break;
				case i8	 : ;
					int8_t x_8i = *(((int8_t*)array) + j);
					*(((int8_t*)array) + j) = add_scale_int8(x_8i,op,s_8i);
					break;
				case i16 : ;
					int16_t x_16i = *(((int16_t*)array) + j);
					*(((int16_t*)array) + j) = add_scale_int16(x_16i,op,s_16i);
					break;
				case i32 : ; 
					int32_t x_32i = *(((int32_t*)array) + j);
					*(((int32_t*)array) + j) = add_scale_int32(x_32i,op,s_32i);
					break;
				case i64 : ; 
					int64_t x_64i = *(((int64_t*)array) + j);
					*(((int64_t*)array) + j) = add_scale_int64(x_64i,op,s_64i);
					break;
				case float32: ;
					float x_32f = *(((float*)array) + j);
					*(((float*)array) + j) = add_scale_f32(x_32f,op, s_32f);
					break;
				case float64: ;
					double x_64f = *(((double*)array) + j);
					*(((double*)array) + j) = add_scale_f64(x_64f,op,s_64f);
					break;
				default: ;
					fprintf(stderr,"Error: scalarOperator: unknown OR unsupported DataType\n");
					return;
			}
		}
		/////////////////////////////////////////
		// THIRD STAGE of Pipeline : Writing Back 
		/////////////////////////////////////////

		req_a.request_type = WRITE;
		//req_a.write_data = store_here; 
		for(int i=0; i<num_dwords_stored ;i=i+1){
			req_a.write_data[i] = store_here[i];
		}
		memPoolAccess((MemPool *)(b->mem_pool_identifier),&req_a,&mpr);
	}
	return; 
}

void scalarOperator_inplace(Operator op, void* s, Tensor* src){
	scalarOperator(op,s,src,src);
}