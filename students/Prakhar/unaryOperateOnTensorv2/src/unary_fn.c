#include "../include/unary_fn.h"
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

void unaryOperateOnTensor(SizedTensor_1024* a, SizedTensor_1024* b, Operation op) {
	// unary operator: performs b = f(a) where f is specified by op
	// src --> a  || dest --> b
	// supported op --> sine, exp, ReLU, square, absolute

	SizedTensorDescriptor std_a = a->descriptor;
	TensorDescriptor td_a = std_a.descriptor;
	TensorDataType a_dt = td_a.data_type;
	uint32_t element_size = __SizeOfTensorDataInBytes__(a_dt); 
	uint32_t n_dim = td_a.number_of_dimensions; // number of dimensions
	uint32_t num_elems = 1; // product of dims (# of elements in tensor)  
	for(uint32_t i=0; i<n_dim; i+=1) {
		num_elems *= td_a.dimensions[i];
	}
	
	for(int j=0; j<num_elems; j++) {
		switch(a_dt){ 
			case u8  : ;
				uint8_t x_8ui = *(((uint8_t*)a->data_array) + j);
				*(((uint8_t*)b->data_array) + j) = operate_uint8(x_8ui,op);
				break;
			case u16 : ;
				uint16_t x_16ui = *(((uint16_t*)a->data_array) + j);
				*(((uint16_t*)b->data_array) + j) = operate_uint16(x_16ui,op);
				break;
			case u32 : ;
				uint32_t x_32ui = *(((uint32_t*)a->data_array) + j);
				*(((uint32_t*)b->data_array) + j) = operate_uint32(x_32ui,op);
				break;
			case u64 : ;
				uint64_t x_64ui = *(((uint64_t*)a->data_array) + j);
				*(((uint64_t*)b->data_array) + j) = operate_uint64(x_64ui,op);
				break;
			case i8	 : ;
				int8_t x_8i = *(((int8_t*)a->data_array) + j);
				*(((int8_t*)b->data_array) + j) = operate_int8(x_8i,op);
				break;
			case i16 : ;
				int16_t x_16i = *(((int16_t*)a->data_array) + j);
				*(((int16_t*)b->data_array) + j) = operate_int16(x_16i,op);
				break;
			case i32 : ; 
				int32_t x_32i = *(((int32_t*)a->data_array) + j);
				*(((int32_t*)b->data_array) + j) = operate_int32(x_32i,op);
				break;
			case i64 : ; 
				int64_t x_64i = *(((int64_t*)a->data_array) + j);
				*(((int64_t*)b->data_array) + j) = operate_int64(x_64i,op);
				break;
			case float8 : ; // to be added
				break;
			case float16 : ; // to be added
				break;
			case float32: ;
				float x_32f = *(((float*)a->data_array) + j);
				*(((float*)b->data_array) + j) = operate_f32(x_32f,op);
				break;
			case float64: ;
				double x_64f = *(((double*)a->data_array) + j);
				*(((double*)b->data_array) + j) = operate_f64(x_64f,op);
				break;
			default: ;
				fprintf(stderr,"Error: unaryOperatorOnTensor_inplace: unknown DataType\n");
				return;
		}
	}
	return; 
}