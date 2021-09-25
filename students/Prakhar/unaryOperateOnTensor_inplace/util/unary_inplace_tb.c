#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "../src/unary_inplace_fn.c" 
// tensor.h
#include "../../../priyankar/src/createTensor.c"  // made some edits to createTensor.c 
#define NPAGES 8
#define MIN(a,b) (((a)<(b))?(a):(b))
int fillTensorValues (Tensor* t,uint32_t num_elems, double offset );

MemPool 	pool;
MemPoolRequest 	req;
MemPoolResponse resp;

Tensor a;

int _err_ = 0;

int main(){
    initMemPool(&pool,1,NPAGES);
	//define tensor
	const TensorDataType dataType = float64;
	const int8_t row_major_form = 1;
	const uint32_t ndim  = 2;
	
	uint32_t dims[ndim];
	dims[0] = 10;
	dims[1] = 1;

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
    _err_ = createTensorAtHead(&a,&pool) + _err_;

    if(_err_!=0)
		fprintf(stderr,"create Tensor FAILURE.\n");


	uint32_t element_size = sizeofTensorDataInBytes(a.descriptor.data_type); 

	//fill tensor A values
	double offset = 0;
	fillTensorValues(&a, num_elems, offset);

	//call the function
	unaryOperateOnTensor_inplace(&a, operation);

	//check A (results)
	req.request_type = READ;

	int iter = -1;
	int elements_left = ceil((num_elems*element_size)/8.0);

	for( ; elements_left > 0; elements_left -= MAX_SIZE_OF_REQUEST_IN_WORDS){
		iter ++;
		int elementsToRead = MIN(elements_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		req.request_tag = 1; // confirm dis
		req.arguments[0] =  elementsToRead; 
		req.arguments[1] = a.mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		req.arguments[2] = 1; // stride = 1 as pointwise
		
		memPoolAccess((MemPool *)(a.mem_pool_identifier),&req,&resp); 
		
		if(resp.status == NOT_OK) {
			fprintf(stderr,"read Tensor FAILURE.\n");
			return 0;
		}

		void *array1;
		array1 = resp.read_data;  

		for (int i = 0; i < num_elems ; i++) // again prev was this in place of num_elems: elementsToRead*(8.0/element_size)
		{
			double operand1;

			//change expected 
			double expected_result = i+ offset + iter*MAX_SIZE_OF_REQUEST_IN_WORDS;   //or load from file
			switch (operation){
				case RELU: expected_result = (expected_result>0)? expected_result:0; break;
				case SINE: expected_result = sin(expected_result); break;
				case SQUARE: expected_result *= expected_result; break;
				case ABSOLUTE: expected_result = abs(expected_result); break;
				case EXP: expected_result = exp(expected_result); break;
				case SIGMOID: expected_result = (1/(1+exp(-1*expected_result))); break;
			}

			switch(dataType){
				case u8: ; 
					uint8_t resultu8,ex_resultu8;
					resultu8 = (uint8_t) *(((uint8_t*)array1) + i);
					ex_resultu8 = (uint8_t) expected_result;
					if (resultu8 != ex_resultu8){
						printf("fail at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu8,resultu8);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu8,resultu8);
					}
					break;

				case u16: ;
					uint16_t resultu16,ex_resultu16;
					resultu16 = (uint16_t) *(((uint16_t*)array1) + i);
					ex_resultu16 = (uint16_t) expected_result;
					if (resultu16 != ex_resultu16){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu16,resultu16);
					}
					break;

				case u32: ;
					uint32_t resultu32,ex_resultu32;
					resultu32 = (uint32_t) *(((uint32_t*)array1) + i);
					ex_resultu32 = (uint32_t) expected_result;
					if (resultu32 != ex_resultu32){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu32,resultu32);
					}
					break;

				case u64: ; 
					uint64_t resultu64,ex_resultu64;
					resultu64 = (uint64_t) *(((uint64_t*)array1) + i);
					ex_resultu64 = (uint64_t) expected_result;
					if (resultu64 != ex_resultu64){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %u Output = %u  \n",i,iter, ex_resultu64,resultu64);
					}
					break;
					
				case i8: ;
					int8_t resulti8,ex_resulti8;
					resulti8 = (int8_t) *(((int8_t*)array1) + i);
					ex_resulti8 = (int8_t) expected_result;
					if (resulti8 != ex_resulti8){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti8,resulti8);
					}
					break;

				case i16: ;
					int16_t resulti16,ex_resulti16;
					resulti16 = (int16_t) *(((int16_t*)array1) + i);
					ex_resulti16 = (int16_t) expected_result;
					if (resulti16 != ex_resulti16){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti16,resulti16);
					}
					break;

				case i32: ; 
					int32_t resulti32,ex_resulti32;
					resulti32 = (int32_t) *(((int32_t*)array1) + i);
					ex_resulti32 = (int32_t) expected_result;
					if (resulti32 != ex_resulti32){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti32,resulti32);
					}
					break;

				case i64: ;
					int64_t resulti64,ex_resulti64;
					resulti64 = (int64_t) *(((int64_t*)array1) + i);
					ex_resulti64 = (int64_t) expected_result;
					if (resulti64 != ex_resulti64){
						printf("fail at %d, iter = %d\n",i,iter);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %d Output = %d  \n",i,iter, ex_resulti64,resulti64);
					}
					break;

				// case float8: ;
					// to be added 
					// break;

				// case float16: ;
					// to be added 
					// break;

				case float32: ;
					float resultf32,ex_resultf32;
					resultf32 = (float) *(((float*)array1) + i);
					ex_resultf32 = (float) expected_result;
					if (resultf32 != ex_resultf32){ // check abs(resultf32-ex_resultf32)<eps
						printf("fail at %d, iter = %d Expected Result = %.10f Output = %.10f  \n",i,iter, ex_resultf32,resultf32);
					}
					else{
						printf("pass at %d, iter = %d Expected Result = %.10f Output = %.10f  \n",i,iter, ex_resultf32,resultf32);
					}
					break;

				case float64: ;
					double resultf64,ex_resultf64;
					resultf64 = (double) *(((double*)array1) + i);
					ex_resultf64 = (double) expected_result;
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
}


int fillTensorValues (Tensor* t,uint32_t num_elems, double offset ){
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
		double data;
		data =  i + offset + iter * MAX_SIZE_OF_REQUEST_IN_WORDS; //or read from FILE
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

				// case float8: ;
					// to be added 
					// break;

				// case float16: ;
					// to be added 
					// break;

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
