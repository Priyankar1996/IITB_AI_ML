#include "../include/unary_inplace_fn.h"
#include<stdint.h>
#include <stdio.h>
#include <math.h>

uint8_t operate_uint8(uint8_t val, Operation op){
	switch(op){
		case SINE: return ((uint8_t) sin(val));
		case EXP : return ((uint8_t) exp(val));
		case RELU: return val;
		case SQUARE: return (val*val);
		case ABSOLUTE: return val;
		case SIGMOID: return val; 
		default: ;
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

uint16_t operate_uint16(uint16_t val, Operation op){
	switch(op){
		case SINE: return ((uint16_t) sin(val));
		case EXP : return ((uint16_t) exp(val));
		case RELU: return val;
		case SQUARE: return (val*val);
		case ABSOLUTE: return val;
		case SIGMOID: return val; 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

uint32_t operate_uint32(uint32_t val, Operation op){
	switch(op){
		case SINE: return ((uint32_t) sin(val));
		case EXP : return ((uint32_t) exp(val));
		case RELU: return val;
		case SQUARE: return (val*val);
		case ABSOLUTE: return val;
		case SIGMOID: return val; 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

uint64_t operate_uint64(uint64_t val, Operation op){
	switch(op){
		case SINE: return ((uint64_t) sin(val));
		case EXP : return ((uint64_t) exp(val));
		case RELU: return val;
		case SQUARE: return (val*val);
		case ABSOLUTE: return val;
		case SIGMOID: return val; 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

int8_t operate_int8(int8_t val, Operation op){
	switch(op){
		case SINE: return ((int8_t) sin(val));
		case EXP : return ((int8_t) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((int8_t) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

int16_t operate_int16(int16_t val, Operation op){
	switch(op){
		case SINE: return ((int16_t) sin(val));
		case EXP : return ((int16_t) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((int16_t) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

int32_t operate_int32(int32_t val, Operation op){
	switch(op){
		case SINE: return ((int32_t) sin(val));
		case EXP : return ((int32_t) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((int32_t) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

int64_t operate_int64(int64_t val, Operation op){
	switch(op){
		case SINE: return ((int64_t) sin(val));
		case EXP : return ((int64_t) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((int64_t) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0;
	}
}

float operate_f32(float val, Operation op){
	switch(op){
		case SINE: return ((float) sin(val));
		case EXP : return ((float) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((float) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0.0;
	}
}

double operate_f64(double val, Operation op){
	switch(op){
		case SINE: return ((double) sin(val));
		case EXP : return ((double) exp(val));
		case RELU: return ((val<0)?0:val);
		case SQUARE: return (val*val);
		case ABSOLUTE: return ((val<0)?(-1*val):val);
		case SIGMOID: return ((double) (1/(1+exp(-1*val)))); 
		default: 
			fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown Operation.\n");
			return 0.0;
	}
}

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
		for(int j=0; j<num_in_cache; j++) {
			switch(a_dt){ 
				case u8  : ;
					uint8_t x_8ui = *(((uint8_t*)array) + j);
					*(((uint8_t*)array) + j) = operate_uint8(x_8ui,op);
					break;
				case u16 : ;
					uint16_t x_16ui = *(((uint16_t*)array) + j);
					*(((uint16_t*)array) + j) = operate_uint16(x_16ui,op);
					break;
				case u32 : ;
					uint32_t x_32ui = *(((uint32_t*)array) + j);
					*(((uint32_t*)array) + j) = operate_uint32(x_32ui,op);
					break;
				case u64 : ;
					uint64_t x_64ui = *(((uint64_t*)array) + j);
					*(((uint64_t*)array) + j) = operate_uint64(x_64ui,op);
					break;
				case i8	 : ;
					int8_t x_8i = *(((int8_t*)array) + j);
					*(((int8_t*)array) + j) = operate_int8(x_8i,op);
					break;
				case i16 : ;
					int16_t x_16i = *(((int16_t*)array) + j);
					*(((int16_t*)array) + j) = operate_int16(x_16i,op);
					break;
				case i32 : ; 
					int32_t x_32i = *(((int32_t*)array) + j);
					*(((int32_t*)array) + j) = operate_int32(x_32i,op);
					break;
				case i64 : ; 
					int64_t x_64i = *(((int64_t*)array) + j);
					*(((int64_t*)array) + j) = operate_int64(x_64i,op);
					break;
				case float8 : ; // to be added
					break;
				case float16 : ; // to be added
					break;
				case float32: ;
					float x_32f = *(((float*)array) + j);
					*(((float*)array) + j) = operate_f32(x_32f,op);
					break;
				case float64: ;
					double x_64f = *(((double*)array) + j);
					*(((double*)array) + j) = operate_f64(x_64f,op);
					break;
				default: ;
					fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown DataType\n");
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
		memPoolAccess((MemPool *)(a->mem_pool_identifier),&req_a,&mpr);
	}
	return; 
}
