#include "../include/conv.h"

//computes convolution of one window
void convHelper(void *ker_data, void *img_data,
                TensorDescriptor *td_ker,
                TensorDescriptor *td_in,
		int *img_data_start_index,
		void *result_array_base,
		int l){
//printf("INSIDE CONV HELPER\n");

        for(int i = 0; i < td_ker->dimensions[1]; i++){
		for(int j = 0; j < td_ker->dimensions[2]; j++){
			for(int k = 0; k < td_ker->dimensions[3]; k++){
				//printf("%dx%dx%d\n",i,j,k);
				int img_index[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
				int ker_index[4] = {img_data_start_index[2],i,j,k};
				int img_data_array_idx = getTensorEntryIndexOffset(td_in,img_index);
				//printf("img data array idx %d\n",img_data_array_idx);
				int ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_index);
				//printf("ker data array idx %d\n",ker_data_array_idx);
				switch (td_in->data_type)
    				{
					case u8:
						*(((uint8_t*)result_array_base) + l) += *(((uint8_t*)img_data) + img_data_array_idx) * *(((uint8_t*)ker_data) + ker_data_array_idx);
						break;
					case u16:
						*(((uint16_t*)result_array_base) + l) += *(((uint16_t*)img_data) + img_data_array_idx) * *(((uint16_t*)ker_data) + ker_data_array_idx);
						break;
					case u32:
						*(((uint32_t*)result_array_base) + l) += *(((uint32_t*)img_data) + img_data_array_idx) * *(((uint32_t*)ker_data) + ker_data_array_idx);
						break;
					case u64:
						*(((uint64_t*)result_array_base) + l) += *(((uint64_t*)img_data) + img_data_array_idx) * *(((uint64_t*)ker_data) + ker_data_array_idx);
						break;
					case i8:
						*(((int8_t*)result_array_base) + l) += *(((int8_t*)img_data) + img_data_array_idx) * *(((int8_t*)ker_data) + ker_data_array_idx);
						break;
					case i16:
						*(((int16_t*)result_array_base) + l) += *(((int16_t*)img_data) + img_data_array_idx) * *(((int16_t*)ker_data) + ker_data_array_idx);
						break;
					case i32:
						*(((int32_t*)result_array_base) + l) += *(((int32_t*)img_data) + img_data_array_idx) * *(((int32_t*)ker_data) + ker_data_array_idx);
						break;
					case i64:
						*(((int64_t*)result_array_base) + l) += *(((int64_t*)img_data) + img_data_array_idx) * *(((int64_t*)ker_data) + ker_data_array_idx);
						break;
					case float32:
						*(((float*)result_array_base) + l) += *(((float*)img_data) + img_data_array_idx) * *(((float*)ker_data) + ker_data_array_idx);
						break;
					case float64:
						*(((double*)result_array_base) + l) += *(((double*)img_data) + img_data_array_idx) * *(((double*)ker_data) + ker_data_array_idx);
						break;
					default:
            					fprintf(stderr,"ERROR: CONV HELPER INPUTS DATATYPE NOT FOUND\n");
           					break;
				}
			}
		}
	}
}

int new_convTensors(Tensor *in_img, Tensor *kernel, Tensor *out_img, const int stride[2], const int padding[4]){

	fprintf(stderr,"INSIDE CONV\n");

    	MemPoolRequest reqKer, reqImg;
    	MemPoolResponse respKer, respImg;

    	TensorDescriptor td_in, td_ker, td_out;

	td_in = in_img->descriptor;
    	td_ker = kernel->descriptor;
	
	//if(td_ker.dimensions[2] != td_in.dimensions[2])
	//{
	//	printf("ERROR : IMAGE-KERNEL DIMENSIONS MISMATCH\n");
	//	return 0;
	//}

    	uint8_t is_row_major = td_in.row_major_form;
    	uint32_t out_H = (td_in.dimensions[0] + padding[0] + padding[1] - td_ker.dimensions[1])/stride[0] + 1;
    	uint32_t out_W = (td_in.dimensions[1] + padding[2] + padding[3] - td_ker.dimensions[2])/stride[1] + 1;
	uint32_t out_C;
	if(td_ker.number_of_dimensions > 3)
		out_C = td_ker.dimensions[0];
	else
		out_C = 1;

    	out_img->descriptor.row_major_form = is_row_major;
    	out_img->descriptor.data_type = td_in.data_type;
    	out_img->descriptor.dimensions[0] = out_H;
    	out_img->descriptor.dimensions[1] = out_W;
    	out_img->descriptor.dimensions[2] = out_C;

	td_out = out_img->descriptor;

    	uint32_t data_size = sizeofTensorDataInBytes(td_ker.data_type);
    	int num_elems = numberOfElementsInTensor(kernel);
    	//int num_elems_left = num_elems;
  
	//Read kernel data.
	uint64_t ker_data[td_ker.dimensions[0]*td_ker.dimensions[1]*td_ker.dimensions[2]*td_ker.dimensions[3]];

	//uint64_t ker_data_array_base;
	//uint64_t *ker_data = &ker_data_array_base;
    	int iter = -1;
    	int flag;
    	int words_left = CEILING(num_elems * data_size,8);
    	//max request is 1024
    	for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    	{
		iter++;
		//last request can be less than 1024
        	int elements_to_read = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		//printf("elements to read %d\n",elements_to_read);
        	reqKer.request_type = READ;
        	reqKer.arguments[0] = elements_to_read;
        	reqKer.arguments[1] = kernel->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		reqKer.arguments[2] = 1;//stride

        	memPoolAccess((MemPool*)kernel->mem_pool_identifier,&reqKer,&respKer);
        	if(respKer.status !=OK)
        	{
            		printf("ERROR : Failed to read the kernel tensor.");
            		flag = 1;
            		break;
        	}

		for(int idx = (iter)*1024; idx < (iter)*1024 + elements_to_read; idx++)
		{
			*(((uint64_t*)ker_data)+idx) = respKer.read_data[idx-(iter)*1024];
			//printf("%"PRIu64"\n",ker_data[idx]);
		}
    	}
	printf("Completed kernel read\n");

	//Read image data.
	uint64_t img_data[td_in.dimensions[0]*td_in.dimensions[1]*td_in.dimensions[2]];

	//uint64_t img_data_array_base;
	//uint64_t *img_data = &img_data_array_base;
	iter = -1;
	int img_num_elems = numberOfElementsInTensor(in_img);
	int img_words_left = CEILING(img_num_elems * data_size,8);
	for( ; img_words_left > 0; img_words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    	{
			iter++;
			//last request can be less than 1024
        	int elements_to_read = MIN(img_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        	reqImg.request_type = READ;
        	reqImg.arguments[0] = elements_to_read;
        	reqImg.arguments[1] = in_img->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		reqImg.arguments[2] = 1;//stride

        	memPoolAccess((MemPool*)in_img->mem_pool_identifier,&reqImg,&respImg);
        	if(respImg.status !=OK)
        	{
            		printf("ERROR: Failed to read the source tensor.");
            		flag = 1;
            		break;
        	}

		for(int idx = (iter)*1024; idx < (iter)*1024 + elements_to_read; idx++)
		{
			*(((uint64_t*)img_data)+idx) = respImg.read_data[idx-(iter)*1024];
			//printf("index %d\n",idx);
			//printf("%"PRIu64"\n",img_data[idx]);
		}
    	}
	printf("Completed image read\n");

	//Perform convolution.
	
	uint64_t res[out_H*out_W*out_C];
	memset(res,0,out_H*out_W*out_C*sizeof(uint64_t));
	void *result_array_base = res;
	int l = 0;

	for(int p = 0; p < out_H; p++)
	{
		for(int q = 0; q < out_W; q++)
		{
			for(int r = 0; r < out_C; r++)
			{
				int img_data_start_index[] = {p*stride[0],q*stride[1],r};
				convHelper(ker_data,img_data,&td_ker,&td_in,img_data_start_index,result_array_base,l);
				//printf("loop %d\n",l);
				l++;
			}
		}
	}
	printf("Completed conv\n");

	//write back the result to tensor.

	iter = -1;
	int out_img_num_elems = numberOfElementsInTensor(out_img);
	int out_img_words_left = CEILING(out_img_num_elems * data_size,8);
	for( ; out_img_words_left > 0; out_img_words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    	{
		iter++;
		//last request can be less than 1024
        	int elements_to_write = MIN(out_img_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        	reqImg.request_type = WRITE;
        	reqImg.arguments[0] = elements_to_write;
        	reqImg.arguments[1] = out_img->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		reqImg.arguments[2] = 1;//stride
		for(int i = 0; i < elements_to_write; i++)
		{
			reqImg.write_data[i] = res[i + iter*1024];
		}

        	memPoolAccess((MemPool*)out_img->mem_pool_identifier,&reqImg,&respImg);
        	if(respImg.status !=OK)
        	{
            		printf("ERROR: Failed to write the output tensor.");
            		flag = 1;
            		break;
        	}
	}
printf("%dx%dx%d conv %dx%dx%dx%d = %dx%dx%d\n",td_in.dimensions[0],td_in.dimensions[1],td_in.dimensions[2],td_ker.dimensions[0],td_ker.dimensions[1],td_ker.dimensions[2],td_ker.dimensions[3],td_out.dimensions[0],td_out.dimensions[1],td_out.dimensions[2]);
printf("THE END\n");
return 0;
}