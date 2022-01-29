#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "../src/unary_fn.c" 
#define NPAGES 8
#define MIN(a,b) (((a)<(b))?(a):(b))
int fillTensorRandomValues (SizedTensor_1024* t,uint32_t num_elems, double pos_range );
// here random values given are in (-pos_range, pos_range)
SizedTensor_1024 a;
SizedTensor_1024 b;
int _err_a = 0;
int _err_b = 0;

int main(){
	////// Input Specs /////////////////
	const TensorDataType dataType = float32;
	const int8_t row_major_form = 1;
	const uint32_t ndim  = 2;
	
	uint32_t dims[ndim];
	dims[0] = 10;
	dims[1] = 10;
	double pos_range = 10.0;
	const Operation operation = SIGMOID;

	a.descriptor.descriptor.data_type = dataType;
	a.descriptor.descriptor.row_major_form = row_major_form;
	a.descriptor.descriptor.number_of_dimensions = ndim;

	uint32_t num_elems = 1; // product of dims (# of elements in tensor)  
	
	for (int i = 0; i < ndim; i++){
		a.descriptor.descriptor.dimensions[i] = dims[i];
		num_elems *= dims[i];
	}
	
	uint32_t element_size = __SizeOfTensorDataInBytes__(a.descriptor.descriptor.data_type); 

	//fill random values in tensor A
	fillTensorRandomValues(&a, num_elems,pos_range);
	//call the function
	unaryOperateOnTensor(&a, &b, operation);
	
	for (int i = 0; i < num_elems ; i++){
		switch(dataType){
			case u8: ; 
				uint8_t resultu8,ex_resultu8, inputu8;
				resultu8 = (uint8_t) *(((uint8_t*)b.data_array) + i);
				inputu8 = (uint8_t) *(((uint8_t*)a.data_array) + i);
				ex_resultu8 = operate_uint8(inputu8, operation);
				if (resultu8 != ex_resultu8){
					printf("fail at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu8,resultu8);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu8,resultu8);
				}
				break;

			case u16: ;
				uint16_t resultu16,ex_resultu16, inputu16;
				resultu16 = (uint16_t) *(((uint16_t*)b.data_array) + i);
				inputu16 = (uint16_t) *(((uint16_t*)a.data_array) + i);
				ex_resultu16 = operate_uint16(inputu16, operation);
				if (resultu16 != ex_resultu16){
					printf("fail at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu16,resultu16);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu16,resultu16);
				}
				break;

			case u32: ;
				uint32_t resultu32,ex_resultu32, inputu32;
				resultu32 = (uint32_t) *(((uint32_t*)b.data_array) + i);
				inputu32 = (uint32_t) *(((uint32_t*)a.data_array) + i);
				ex_resultu32 = operate_uint32(inputu32, operation);
				if (resultu32 != ex_resultu32){
					printf("fail at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu32,resultu32);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu32,resultu32);
				}
				break;

			case u64: ; 
				uint64_t resultu64,ex_resultu64, inputu64;
				resultu64 = (uint64_t) *(((uint64_t*)b.data_array) + i);
				inputu64 = (uint64_t) *(((uint64_t*)a.data_array) + i);
				ex_resultu64 = operate_uint64(inputu64, operation);
				if (resultu64 != ex_resultu64){
					printf("fail at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu64,resultu64);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %u Output = %u  \n",i,0, ex_resultu64,resultu64);
				}
				break;
					
			case i8: ; 
				int8_t resulti8,ex_resulti8, inputi8;
				resulti8 = (int8_t) *(((int8_t*)b.data_array) + i);
				inputi8 = (int8_t) *(((int8_t*)a.data_array) + i);
				ex_resulti8 = operate_int8(inputi8, operation);
				if (resulti8 != ex_resulti8){
					printf("fail at %d, 0 = %d Diff = %d\n",i,0, resulti8-ex_resulti8);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %d Output = %d  \n",i,0, ex_resulti8,resulti8);
				}
				break;

			case i16: ;
				int16_t resulti16,ex_resulti16, inputi16;
				resulti16 = (int16_t) *(((int16_t*)b.data_array) + i);
				inputu16 = (int16_t) *(((int16_t*)a.data_array) + i);
				ex_resulti16 = operate_int16(inputi16, operation);
				if (resulti16 != ex_resulti16){
					printf("fail at %d, 0 = %d Diff = %d\n",i,0, resulti16-ex_resulti16);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %d Output = %d  \n",i,0, ex_resulti16,resulti16);
				}
				break;

			case i32: ;
				int32_t resulti32,ex_resulti32, inputi32;
				resulti32 = (int32_t) *(((int32_t*)b.data_array) + i);
				inputi32 = (int32_t) *(((int32_t*)a.data_array) + i);
				ex_resulti32 = operate_int32(inputi32, operation);
				if (resulti32 != ex_resulti32){
					printf("fail at %d, 0 = %d Diff = %d\n",i,0, resulti32-ex_resulti32);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %d Output = %d  \n",i,0, ex_resulti32,resulti32);
				}
				break;

			case i64: ; 
				int64_t resulti64,ex_resulti64, inputi64;
				resulti64 = (int64_t) *(((int64_t*)b.data_array) + i);
				inputi64 = (int64_t) *(((int64_t*)a.data_array) + i);
				ex_resulti64 = operate_int64(inputi64, operation);
				if (resulti64 != ex_resulti64){
					printf("fail at %d, 0 = %d Diff = %d\n",i,0, resulti64-ex_resulti64);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %d Output = %d  \n",i,0, ex_resulti64,resulti64);
				}
				break;

			case float32: ;
				float resultf32,ex_resultf32,inputf32;
				resultf32 = (float) *(((float*)b.data_array) + i);
				inputf32 = (float) *(((float*)a.data_array) + i);
				ex_resultf32 = operate_f32(inputf32, operation);
				if (resultf32 != ex_resultf32){ // check abs(resultf32-ex_resultf32)<eps
					printf("fail at %d, 0 = %d Diff = %.10f\n",i,0, resultf32-ex_resultf32);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %.10f Output = %.10f  \n",i,0, ex_resultf32,resultf32);
				}
				break;

			case float64: ;
				double resultf64,ex_resultf64, inputf64;
				resultf64 = (double) *(((double*)b.data_array) + i);
				inputf64 = (double) *(((double*)a.data_array) + i);
				ex_resultf64 = operate_f64(inputf64,operation);
				if (resultf64 != ex_resultf64){
					printf("fail at %d, 0 = %d Diff = %.10f\n",i,0, resultf64-ex_resultf64);
				}
				else{
					printf("pass at %d, 0 = %d Expected Result = %.10f Output = %.10f  \n",i,0, ex_resultf64,resultf64);
				}
				break;			
		}
	}	
}

int fillTensorRandomValues(SizedTensor_1024* t,uint32_t num_elems, double pos_range){ // here random values given are in (-pos_range, pos_range)
	uint32_t element_size = __SizeOfTensorDataInBytes__(t->descriptor.descriptor.data_type); 
	TensorDataType dataType = t->descriptor.descriptor.data_type;
 
	for (int i = 0; i < num_elems ; i++) {
		double data1,data2,data;
		data1 =  (double) rand()/((double)RAND_MAX); 
		data2 =  (double) rand()/((double)RAND_MAX); 
		data = (data2-data1)*pos_range;
		switch(dataType){
			case u8: ; 
				uint8_t val8 = (uint8_t) data;
				*(((uint8_t*)t->data_array) + i) = val8;
				printf("Value filled %u \n",*(((uint8_t*)t->data_array) + i));
				break;

			case u16: ;
				uint16_t val16 = (uint16_t) data;
				*(((uint16_t*)t->data_array) + i) = val16;
				printf("Value filled %u \n",*(((uint16_t*)t->data_array) + i));
				break;

			case u32: ;
				uint32_t val32 = (uint32_t) data;
				*(((uint32_t*)t->data_array) + i) = val32;
				printf("Value filled %u \n",*(((uint32_t*)t->data_array) + i));
				break;

			case u64: ; 
				uint64_t val64 = (uint64_t) data;
				*(((uint64_t*)t->data_array) + i) = val64;
				printf("Value filled %u \n",*(((uint64_t*)t->data_array) + i));
				break;
				
			case i8: ;
				int8_t val8i = (int8_t) data;
				*(((int8_t*)t->data_array) + i) = val8i;
				printf("Value filled %d \n",*(((int8_t*)t->data_array) + i));
				break;

			case i16: ;
				int16_t val16i = (int16_t) data;
				*(((int16_t*)t->data_array) + i) = val16i;
				printf("Value filled %d \n",*(((int16_t*)t->data_array) + i));
				break;

			case i32: ; 
				int32_t val32i = (int32_t) data ;
				*(((int32_t*)t->data_array) + i) = val32i;
				printf("Value filled %d \n",*(((int32_t*)t->data_array) + i));
				break;

			case i64: ;
				int64_t val64i = (int64_t) data;
				*(((int64_t*)t->data_array) + i) = val64i;
				printf("Value filled %d \n",*(((int64_t*)t->data_array) + i));
				break;

			case float32: ;
				float val32f = (float) data;
				*(((float*)t->data_array) + i) = val32f;

				printf("Value filled %.10f \n",*(((float*)t->data_array) + i));
				break;

			case float64: ;
				double val64f = (double) data;
				*(((double*)t->data_array) + i) = val64f;
				printf("Value filled %.10f \n",*(((double*)t->data_array) + i));
				break;
		}		
	}
}	