#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "../src/unary_fn.c" 
// tensor.h
#include "../../../priyankar/src/createTensor.c"  // made some edits to createTensor.c 
#define NPAGES 8
#define MIN(a,b) (((a)<(b))?(a):(b))
int fillTensorRandomValues (Tensor* t,uint32_t num_elems, double pos_range );
// here random values given are in (-pos_range, pos_range)
MemPool 	pool_a;
MemPool 	pool_b;

MemPoolRequest 	req;
MemPoolResponse resp;
MemPoolRequest req1;
MemPoolResponse resp1;

Tensor a;
Tensor b;
int _err_a = 0;
int _err_b = 0;

int main(){
    initMemPool(&pool_a,1,NPAGES);
	initMemPool(&pool_b,1,NPAGES);
	//define tensor
	////// Input Specs /////////////////
	const TensorDataType dataType = float32;
	const int8_t row_major_form = 1;
	const uint32_t ndim  = 2;
	
	uint32_t dims[ndim];
	dims[0] = 10;
	dims[1] = 10;
	double pos_range = 10.0;
	const Operation operation = SIGMOID;

	a.descriptor.data_type = dataType;
	a.descriptor.row_major_form = row_major_form;
	a.descriptor.number_of_dimensions = ndim;

	uint32_t num_elems = 1; // product of dims (# of elements in tensor)  
	
	for (int i = 0; i < ndim; i++){
		a.descriptor.dimensions[i] = dims[i];
		num_elems *= dims[i];
	}
	// printf("num_elems = %d", num_elems);
	//create tensor
    _err_a = createTensorAtHead(&a,&pool_a) + _err_a;
    if(_err_a!=0){
		fprintf(stderr,"create Tensor a FAILURE.\n");
	}
	_err_b = createTensorAtHead(&b,&pool_b) + _err_b;
    if(_err_b!=0){
		fprintf(stderr,"create Tensor a FAILURE.\n");
	}

	uint32_t element_size = sizeofTensorDataInBytes(a.descriptor.data_type); 

	//fill random values in tensor A
	fillTensorRandomValues(&a, num_elems,pos_range);
	//call the function
	unaryOperateOnTensor(&a, &b, operation);
	// MatchTensorValues(&b,&c);
	//check A (results)
	req.request_type = READ;
	req1.request_type = READ;
	int iter = -1;
	int elements_left = ceil((num_elems*element_size)/8.0);
	// request 1 and 2 must be separate
	for( ; elements_left > 0; elements_left -= MAX_SIZE_OF_REQUEST_IN_WORDS){
		iter ++;
		int elementsToRead = MIN(elements_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		req.request_tag = 1; // confirm dis
		req.arguments[0] =  elementsToRead; 
		req.arguments[1] = b.mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		req.arguments[2] = 1; // stride = 1 as pointwise

		req1.request_tag = 1; // confirm dis
		req1.arguments[0] =  elementsToRead; 
		req1.arguments[1] = a.mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		req1.arguments[2] = 1; // stride = 1 as pointwise
		
		memPoolAccess((MemPool *)(b.mem_pool_identifier),&req,&resp); 
		
		if(resp.status == NOT_OK) {
			fprintf(stderr,"read Tensor FAILURE.\n");
			return 0;
		}

		void *array1;  // contains the from Tensor b i.e. output tensor
		array1 = resp.read_data;

		memPoolAccess((MemPool *)(a.mem_pool_identifier),&req1,&resp1); 
		
		if(resp1.status == NOT_OK) {
			fprintf(stderr,"read Tensor FAILURE.\n");
			return 0;
		}

		void *array2;  // contains data from input tensor a 
		array2 = resp1.read_data;

		for (int i = 0; i < num_elems ; i++) // again prev was this in place of num_elems: elementsToRead*(8.0/element_size)
		{
			switch(dataType){
				case u8: ; 
					uint8_t resultu8,ex_resultu8, inputu8;
					resultu8 = (uint8_t) *(((uint8_t*)array1) + i);
					inputu8 = (uint8_t) *(((uint8_t*)array2) + i);
					ex_resultu8 = operate_uint8(inputu8, operation);
					if (resultu8 != ex_resultu8){
						printf("fail at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu8,resultu8);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu8,resultu8);
					}
					break;

				case u16: ;
					uint16_t resultu16,ex_resultu16, inputu16;
					resultu16 = (uint16_t) *(((uint16_t*)array1) + i);
					inputu16 = (uint16_t) *(((uint16_t*)array2) + i);
					ex_resultu16 = operate_uint16(inputu16, operation);
					if (resultu16 != ex_resultu16){
						printf("fail at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu16,resultu16);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu16,resultu16);
					}
					break;

				case u32: ;
					uint32_t resultu32,ex_resultu32, inputu32;
					resultu32 = (uint32_t) *(((uint32_t*)array1) + i);
					inputu32 = (uint32_t) *(((uint32_t*)array2) + i);
					ex_resultu32 = operate_uint32(inputu32, operation);
					if (resultu32 != ex_resultu32){
						printf("fail at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu32,resultu32);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu32,resultu32);
					}
					break;

				case u64: ; 
					uint64_t resultu64,ex_resultu64, inputu64;
					resultu64 = (uint64_t) *(((uint64_t*)array1) + i);
					inputu64 = (uint64_t) *(((uint64_t*)array2) + i);
					ex_resultu64 = operate_uint64(inputu64, operation);
					if (resultu64 != ex_resultu64){
						printf("fail at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu64,resultu64);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu64,resultu64);
					}
					break;
					
				case i8: ; 
					int8_t resulti8,ex_resulti8, inputi8;
					resulti8 = (int8_t) *(((int8_t*)array1) + i);
					inputi8 = (int8_t) *(((int8_t*)array2) + i);
					ex_resulti8 = operate_int8(inputi8, operation);
					if (resulti8 != ex_resulti8){
						printf("fail at %d, iter = %d Diff = %d\n",i,iter, resulti8-ex_resulti8);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti8,resulti8);
					}
					break;

				case i16: ;
					int16_t resulti16,ex_resulti16, inputi16;
					resulti16 = (int16_t) *(((int16_t*)array1) + i);
					inputu16 = (int16_t) *(((int16_t*)array2) + i);
					ex_resulti16 = operate_int16(inputi16, operation);
					if (resulti16 != ex_resulti16){
						printf("fail at %d, iter = %d Diff = %d\n",i,iter, resulti16-ex_resulti16);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti16,resulti16);
					}
					break;

				case i32: ;
					int32_t resulti32,ex_resulti32, inputi32;
					resulti32 = (int32_t) *(((int32_t*)array1) + i);
					inputi32 = (int32_t) *(((int32_t*)array2) + i);
					ex_resulti32 = operate_int32(inputi32, operation);
					if (resulti32 != ex_resulti32){
						printf("fail at %d, iter = %d Diff = %d\n",i,iter, resulti32-ex_resulti32);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti32,resulti32);
					}
					break;

				case i64: ; 
					int64_t resulti64,ex_resulti64, inputi64;
					resulti64 = (int64_t) *(((int64_t*)array1) + i);
					inputi64 = (int64_t) *(((int64_t*)array2) + i);
					ex_resulti64 = operate_int64(inputi64, operation);
					if (resulti64 != ex_resulti64){
						printf("fail at %d, iter = %d Diff = %d\n",i,iter, resulti64-ex_resulti64);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti64,resulti64);
					}
					break;

				case float32: ;
					float resultf32,ex_resultf32,inputf32;
					resultf32 = (float) *(((float*)array1) + i);
					inputf32 = (float) *(((float*)array2) + i);
					ex_resultf32 = operate_f32(inputf32, operation);
					if (resultf32 != ex_resultf32){ // check abs(resultf32-ex_resultf32)<eps
						printf("fail at %d, iter = %d Diff = %.10f\n",i,iter, resultf32-ex_resultf32);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %.10f Output = %.10f  \n",i,iter, ex_resultf32,resultf32);
					}
					break;

				case float64: ;
					double resultf64,ex_resultf64, inputf64;
					resultf64 = (double) *(((double*)array1) + i);
					inputf64 = (double) *(((double*)array2) + i);
					ex_resultf64 = operate_f64(inputf64,operation);
					if (resultf64 != ex_resultf64){
						printf("fail at %d, iter = %d Diff = %.10f\n",i,iter, resultf64-ex_resultf64);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %.10f Output = %.10f  \n",i,iter, ex_resultf64,resultf64);
					}
					break;			
			}
		}	
	}
	destroyTensor(&a);
	destroyTensor(&b);
}

int fillTensorRandomValues(Tensor* t,uint32_t num_elems, double pos_range){ // here random values given are in (-pos_range, pos_range)
	uint32_t element_size = sizeofTensorDataInBytes(t->descriptor.data_type); 
	TensorDataType dataType = t->descriptor.data_type;

	req.request_type = WRITE;
	req.request_tag = 1; // confirm dis

	int iter = -1; 
	int elements_left = ceil((num_elems*element_size)/8.0);
	for( ; elements_left > 0; elements_left -= MAX_SIZE_OF_REQUEST_IN_WORDS){
		iter ++;
		int elementsToWrite = MIN(elements_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		req.arguments[0] =  elementsToWrite; 
		req.arguments[1] = t->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		req.arguments[2] = 1; // stride = 1 as pointwise
		
		void *array;
		array = req.write_data;  

		for (int i = 0; i < num_elems ; i++) //iniatal fix:(8.0/element_size)*elementsToWrite (previosly)
		{
		double data1,data2,data;
		data1 =  (double) rand()/((double)RAND_MAX); 
		data2 =  (double) rand()/((double)RAND_MAX); 
		data = (data2-data1)*pos_range;
			switch(dataType){
			case u8: ; 
				uint8_t val8 = (uint8_t) data;
				*(((uint8_t*)array) + i) = val8;
				printf("Value filled %u \n",*(((uint8_t*)array) + i));
				break;

			case u16: ;
				uint16_t val16 = (uint16_t) data;
				*(((uint16_t*)array) + i) = val16;
				printf("Value filled %u \n",*(((uint16_t*)array) + i));
				break;

			case u32: ;
				uint32_t val32 = (uint32_t) data;
				*(((uint32_t*)array) + i) = val32;
				printf("Value filled %u \n",*(((uint32_t*)array) + i));
				break;

			case u64: ; 
				uint64_t val64 = (uint64_t) data;
				*(((uint64_t*)array) + i) = val64;
				printf("Value filled %u \n",*(((uint64_t*)array) + i));
				break;
				
			case i8: ;
				int8_t val8i = (int8_t) data;
				*(((int8_t*)array) + i) = val8i;
				printf("Value filled %d \n",*(((int8_t*)array) + i));
				break;

			case i16: ;
				int16_t val16i = (int16_t) data;
				*(((int16_t*)array) + i) = val16i;
				printf("Value filled %d \n",*(((int16_t*)array) + i));
				break;

			case i32: ; 
				int32_t val32i = (int32_t) data ;
				*(((int32_t*)array) + i) = val32i;
				printf("Value filled %d \n",*(((int32_t*)array) + i));
				break;

			case i64: ;
				int64_t val64i = (int64_t) data;
				*(((int64_t*)array) + i) = val64i;
				printf("Value filled %d \n",*(((int64_t*)array) + i));
				break;

			case float32: ;
				float val32f = (float) data;
				*(((float*)array) + i) = val32f;

				printf("Value filled %.10f \n",*(((float*)array) + i));
				break;

			case float64: ;
				double val64f = (double) data;
				*(((double*)array) + i) = val64f;
				printf("Value filled %.10f \n",*(((double*)array) + i));
				break;
			}		
		}

		memPoolAccess((MemPool *)(t->mem_pool_identifier), &req, &resp); 

		if(resp.status == OK) {
			return 0;
		}else {
			fprintf(stderr,"write Tensor FAILURE.\n");
			return -1;
		}
	}	
}
