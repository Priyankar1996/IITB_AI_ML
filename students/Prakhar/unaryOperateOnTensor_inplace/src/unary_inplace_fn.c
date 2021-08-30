#include "../include/unary_inplace_fn.h"
#include<stdint.h>
#include <stdio.h>
#include <math.h>

// int main(){
// 	
// }
// contiguous storage in memory pool for all the data types - assumed
void unaryOperateOnTensor_inplace(Tensor* a, Operation op) {
	// in-place unary operator: performs a = f(a) where f is specified by op
	// supported op --> sine, exp, ReLU, square, absolute

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
		switch(op){ 
			case RELU : // a = RELU(a)
			// for uint types --> i/p = o/p so do nothing 
			// for int types --> check MSB for sign 
			// for float types --> check MSB for sign 
				for(int j=0; j<num_in_cache; j+=1) {
					switch(a_dt){ // unsigned datatypes don't make sense for ReLU 
						// case u8: ;
						// case u16: ;
						// case u32: ;
						// case u64: ; 
						// 	break;
						case i8: ;
							int8_t MSB8 = *(((int8_t*)array) + j);
							MSB8 = ((MSB8>>7)&1);
							if(MSB8 == 1){
								*(((int8_t*)array) + j) = 0;
							} 
							break;
						case float8: ; // to be added
							break;
						case i16: ;
							int16_t MSB16 = *(((int16_t*)array) + j);
							MSB16 = ((MSB16>>15)&1);
							if(MSB16 == 1){
								*(((int16_t*)array) + j) = 0;
							}
							break;
						case float16: ; // to be added
							break;
						case i32: ; 
							int32_t MSB32 = *(((int32_t*)array) + j);
							MSB32 = ((MSB32>>31)&1);
							if(MSB32 == 1){
								*(((int32_t*)array) + j) = 0;
							}
							else{
								*(((int32_t*)array) + j) = *(((int32_t*)array) + j);
							}
							break;
						case float32: ;
							float fval32 = *(((float*)array) + j);
							// ("fval was this: %.10f \n",fval32);
							if(fval32<0){
								*(((float*)array) + j) = 0;
								// printf("Hey \n");
							}
							else{
								*(((float*)array) + j) = fval32;
							}
							break;
						case i64: ; 
							int64_t MSB64 = *(((int64_t*)array) + j);
							MSB64 = ((MSB64>>63)&1);
							if(MSB64 == 1){
								*(((int64_t*)array) + j) = 0;
							}
							break;
						case float64: ;
							double fval64 = *(((double*)array) + j);
							if(fval64<0){
								*(((double*)array) + j) = 0;
							}
							else{
								*(((double*)array) + j) = fval64;
							}
							break;
					}
				}
				break;
			
			case SIGMOID : // a = sigmoid(a) // support only for float32 and float64 as of now 
				for(int j=0; j<num_in_cache; j+=1) {
					switch(a_dt){
						case u8: ;
							uint8_t x_e8ui;
							x_e8ui = *(((uint8_t*)array) + j);
							*(((uint8_t*)array) + j) = (uint8_t) 1/(1+exp(-1*x_e8ui));
							break;

						case u16: ;
							uint16_t x_e16ui;
							x_e16ui = *(((uint16_t*)array) + j);
							*(((uint16_t*)array) + j) = (uint16_t) 1/(1+exp(-1*x_e16ui));
							break;

						case u32: ;
							uint32_t x_e32ui;
							x_e32ui = *(((uint32_t*)array) + j);
							*(((uint32_t*)array) + j) = (uint32_t) 1/(1+exp(-1*x_e32ui));
							break;

						case u64: ;
							uint64_t x_e64ui;
							x_e64ui = *(((uint64_t*)array) + j);
							*(((uint64_t*)array) + j) = (uint64_t) 1/(1+exp(-1*x_e64ui));
							break;

						case i8: ;
							int8_t x_e8i;
							x_e8i = *(((int8_t*)array) + j);
							*(((int8_t*)array) + j) = (int8_t) 1/(1+exp(-1*x_e8i));
							break;

						case i16: ;
							int16_t x_e16i;
							x_e16i = *(((int16_t*)array) + j);
							*(((int16_t*)array) + j) = (int16_t) 1/(1+exp(-1*x_e16i));
							break;

						case i32: ;
							int32_t x_e32i;
							x_e32i = *(((int32_t*)array) + j);
							*(((int32_t*)array) + j) = (int32_t) 1/(1+exp(-1*x_e32i));
							break;

						case i64: ;
							int64_t x_e64i;
							x_e64i = *(((int64_t*)array) + j);
							*(((int64_t*)array) + j) = (int64_t) 1/(1+exp(-1*x_e64i));
							break;

						case float8: ;
							// to be added 
							break;

						case float16: ;
							// to be added 
							break;

						case float32: ;
							float x_e32;
							x_e32 = *(((float*)array) + j);
							*(((float*)array) + j) = (float) 1/(1+exp(-1*x_e32));
							break;

						case float64: ;
							double x_e64;
							x_e64 = *(((double*)array) + j);
							*(((double*)array) + j) = (double) 1/(1+exp(-1*x_e64));
							break;
					}
				}
				break;

			case SQUARE : // a = (a)^2 
				for(int j=0; j<num_in_cache; j++) {
					switch(a_dt){
						case u8: ; 
							uint8_t val8 = *(((uint8_t*)array) + j);
							val8 *= val8;
							*(((uint8_t*)array) + j) = val8;
							break;

						case u16: ;
							uint16_t val16 = *(((uint16_t*)array) + j);
							val16 *= val16;
							*(((uint16_t*)array) + j) = val16;
							break;

						case u32: ;
							uint32_t val32 = *(((uint32_t*)array) + j);
							val32 *= val32;
							*(((uint32_t*)array) + j) = val32;
							break;

						case u64: ; 
							uint64_t val64 = *(((uint64_t*)array) + j);
							val64 *= val64;
							*(((uint64_t*)array) + j) = val64;
							break;

						case i8: ;
							int8_t val8i = *(((int8_t*)array) + j);
							val8i *= val8i;
							*(((int8_t*)array) + j) = val8i;
							break;

						case i16: ;
							int16_t val16i = *(((int16_t*)array) + j);
							val16i *= val16i;
							*(((int16_t*)array) + j) = val16i;
							break;

						case i32: ; 
							int32_t val32i = *(((int32_t*)array) + j);
							val32i *= val32i;
							*(((int32_t*)array) + j) = val32i;
							break;

						case i64: ;
							int64_t val64i = *(((int64_t*)array) + j);
							val64i *= val64i;
							*(((int64_t*)array) + j) = val64i;
							break;

						case float8: ;
							// to be added 
							break;

						case float16: ;
							// to be added 
							break;

						case float32: ;
							float val32f = *(((float*)array) + j);
							printf("Value in fn given %.10f \n",val32f);
							val32f *= val32f;
							*(((float*)array) + j) = val32f;
							
							break;

						case float64: ;
							double val64f = *(((double*)array) + j);
							val64f *= val64f;
							*(((double*)array) + j) = val64f;
							break;

					}
				}
				break;

			case EXP : // a = exp(a) // support only for float32 and float64 as of now 
				for(int j=0; j<num_in_cache; j+=1) {
					switch(a_dt){
						case u8: ;
							uint8_t x_e8ui;
							x_e8ui = *(((uint8_t*)array) + j);
							*(((uint8_t*)array) + j) = (uint8_t) exp(x_e8ui);
							break;

						case u16: ;
							uint16_t x_e16ui;
							x_e16ui = *(((uint16_t*)array) + j);
							*(((uint16_t*)array) + j) = (uint16_t) exp(x_e16ui);
							break;

						case u32: ;
							uint32_t x_e32ui;
							x_e32ui = *(((uint32_t*)array) + j);
							*(((uint32_t*)array) + j) = (uint32_t) exp(x_e32ui);
							break;

						case u64: ;
							uint64_t x_e64ui;
							x_e64ui = *(((uint64_t*)array) + j);
							*(((uint64_t*)array) + j) = (uint64_t) exp(x_e64ui);
							break;

						case i8: ;
							int8_t x_e8i;
							x_e8i = *(((int8_t*)array) + j);
							*(((int8_t*)array) + j) = (int8_t) exp(x_e8i);
							break;

						case i16: ;
							int16_t x_e16i;
							x_e16i = *(((int16_t*)array) + j);
							*(((int16_t*)array) + j) = (int16_t) exp(x_e16i);
							break;

						case i32: ;
							int32_t x_e32i;
							x_e32i = *(((int32_t*)array) + j);
							*(((int32_t*)array) + j) = (int32_t) exp(x_e32i);
							break;

						case i64: ;
							int64_t x_e64i;
							x_e64i = *(((int64_t*)array) + j);
							*(((int64_t*)array) + j) = (int64_t) exp(x_e64i);
							break;

						case float8: ;
							// to be added 
							break;

						case float16: ;
							// to be added 
							break;

						case float32: ;
							float x_e32;
							x_e32 = *(((float*)array) + j);
							*(((float*)array) + j) = (float) exp(x_e32);
							break;

						case float64: ;
							double x_e64;
							x_e64 = *(((double*)array) + j);
							*(((double*)array) + j) = (double) exp(x_e64);
							break;
					}
				}
				break;

			case SINE : // a = sin(a) // support only for float32 and float64 as of now 
				for(int j=0; j<num_in_cache; j+=1) {
					switch(a_dt){
						case u8: ;
							uint8_t x_s8ui;
							x_s8ui = *(((uint8_t*)array) + j);
							*(((uint8_t*)array) + j) = (uint8_t) sin(x_s8ui);
							break;

						case u16: ;
							uint16_t x_s16ui;
							x_s16ui = *(((uint16_t*)array) + j);
							*(((uint16_t*)array) + j) = (uint16_t) sin(x_s16ui);
							break;

						case u32: ;
							uint32_t x_s32ui;
							x_s32ui = *(((uint32_t*)array) + j);
							*(((uint32_t*)array) + j) = (uint32_t) sin(x_s32ui);
							break;

						case u64: ;
							uint64_t x_s64ui;
							x_s64ui = *(((uint64_t*)array) + j);
							*(((uint64_t*)array) + j) = (uint64_t) sin(x_s64ui);
							break;

						case i8: ;
							int8_t x_s8i;
							x_s8i = *(((int8_t*)array) + j);
							*(((int8_t*)array) + j) = (int8_t) sin(x_s8i);
							break;

						case i16: ;
							int16_t x_s16i;
							x_s16i = *(((int16_t*)array) + j);
							*(((int16_t*)array) + j) = (int16_t) sin(x_s16i);
							break;

						case i32: ;
							int32_t x_s32i;
							x_s32i = *(((int32_t*)array) + j);
							*(((int32_t*)array) + j) = (int32_t) sin(x_s32i);
							break;

						case i64: ;
							int64_t x_s64i;
							x_s64i = *(((int64_t*)array) + j);
							*(((int64_t*)array) + j) = (int64_t) sin(x_s64i);
							break;

						case float8: ;
							// to be added 
							break;

						case float16: ;
							// to be added 
							break;

						case float32: ;
							float x_s32;
							x_s32 = *(((float*)array) + j);
							*(((float*)array) + j) = (float) sin(x_s32);
							break;

						case float64: ;
							double x_s64;
							x_s64 = *(((double*)array) + j);
							*(((double*)array) + j) = (double) sin(x_s64);
							break;
					}
				}
				break;

			case ABSOLUTE : // a = |a|
			// for uint types --> i/p = o/p so doesn't make sense
			// for int types --> check MSB for sign 
			// for float types --> check MSB for sign
				for(int j=0; j<num_in_cache; j+=1) {
					switch(a_dt){
						// case u8: ;
						// case u16: ;
						// case u32: ;
						// case u64: ; 
						// 	break;
						case i8: ;
							int8_t MSB8a = *(((int8_t*)array) + j);
							MSB8a = ((MSB8a>>7)&1);
							if(MSB8a == 1){
								*(((int8_t*)array) + j) *= -1;
							}
							break;
						case i16: ;
							int16_t MSB16a = *(((int16_t*)array) + j);
							MSB16a = ((MSB16a>>15)&1);
							if(MSB16a == 1){
								*(((int16_t*)array) + j) *= -1;
							}
							break;
						case i32: ; 
							int32_t MSB32a = *(((int32_t*)array) + j);
							MSB32a = ((MSB32a>>31)&1);
							if(MSB32a == 1){
								*(((int32_t*)array) + j) *= -1;
							}
							break;
						case i64: ;
							int64_t MSB64a = *(((int64_t*)array) + j);
							MSB64a = ((MSB64a>>63)&1);
							if(MSB64a == 1){
								*(((int64_t*)array) + j) *= -1;
							}
							break;
						case float8: ;
							// to be added 
							break;
						case float16: ;
							// to be added 
							break;
						case float32: ; 
							float valf32 = *(((float*)array) + j);
							if(valf32<0){
								*(((float*)array) + j) = -1*valf32;
							}
							else{
								*(((float*)array) + j) = valf32;
							}
							break;

						case float64: ;
							double valf64 = *(((double*)array) + j);
							if(valf64<0){
								*(((double*)array) + j) = -1*valf64;
							}
							else{
								*(((double*)array) + j) = valf64;
							}
							break;
					}
				}
				break;

			default  :
				fprintf(stderr,"Error: unaryOperatorOnTensor: unknown Operation.\n"); // wanted to add which operation was accessed [more info during debug]
				return;
		}

		/////////////////////////////////////////
		// THIRD STAGE of Pipeline : Writing Back 
		/////////////////////////////////////////

		req_a.request_type = WRITE;
		//req_a.write_data = store_here; 
		for(int i=0; i<num_dwords_stored ;i=i+1){
			req_a.write_data[i] = store_here[i];
		}
		memPoolAccess((MemPool *)(a->mem_pool_identifier),&req_a,&mpr);
	}
	return; 
}