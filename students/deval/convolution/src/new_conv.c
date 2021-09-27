#include "../include/conv.h"

void convHelper(const int64_t *ker_data, const int64_t *img_data,
                TensorDescriptor *td_ker,
                TensorDescriptor *td_in,
		int *img_data_start_index,
		void *result_array_base,
		int l){
    switch (td_in->data_type)
    {
	case u8:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					uint8_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					uint8_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((uint8_t*)result_array_base) + l) += *(((uint8_t*)img_data) + img_data_array_idx) * *(((uint8_t*)ker_data) + ker_data_array_idx);
				}
			}
		}
	}
            break;
	case u16:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					uint16_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					uint16_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((uint16_t*)result_array_base) + l) += *(((uint16_t*)img_data) + img_data_array_idx) * *(((uint16_t*)ker_data) + ker_data_array_idx);
				}
			}
		}
	}
            break;
	case u32:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					uint32_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					uint32_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((uint32_t*)result_array_base) + l) += *(((uint32_t*)img_data) + img_data_array_idx) * *(((uint32_t*)ker_data) + ker_data_array_idx);
				}
			}
		}
	}
            break;
        case u64:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					uint64_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					uint64_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((uint64_t*)result_array_base) + l) += *(((uint64_t*)img_data) + img_data_array_idx) * *(((uint64_t*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case i8:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int8_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int8_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((int8_t*)result_array_base) + l) += *(((int8_t*)img_data) + img_data_array_idx) * *(((int8_t*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case i16:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int16_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int16_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((int16_t*)result_array_base) + l) += *(((int16_t*)img_data) + img_data_array_idx) * *(((int16_t*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case i32:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int32_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int32_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((int32_t*)result_array_base) + l) += *(((int32_t*)img_data) + img_data_array_idx) * *(((int32_t*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case i64:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int64_t img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int64_t ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((int64_t*)result_array_base) + l) += *(((int64_t*)img_data) + img_data_array_idx) * *(((int64_t*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case float32:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
				for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((float*)result_array_base) + l) += *(((float*)img_data) + img_data_array_idx) * *(((float*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
	case float64:
	{
        	for(int i = 0; i < td_ker->dimensions[0]; i++){
			for(int j = 0; j < td_ker->dimensions[1]; j++){
	  			for(int k = 0; k < td_ker->dimensions[2]; k++){
					int img_indices[3] = {img_data_start_index[0]+i,img_data_start_index[1]+j,k};
					int ker_indices[3] = {i,j,k};
					int img_data_array_idx = getTensorEntryIndexOffset(td_in,img_indices);
					int ker_data_array_idx = getTensorEntryIndexOffset(td_ker,ker_indices);
					*(((double*)result_array_base) + l) += *(((double*)img_data) + img_data_array_idx) * *(((double*)ker_data) + ker_data_array_idx);
					
				}
			}
		}
	}
            break;
        default:
            fprintf(stderr,"ERROR: CONV HELPER INPUTS DATATYPE NOT FOUND\n");
            break;
    }
}

int new_convTensors(Tensor *in_img, Tensor *kernel, Tensor *out_img,
            const int stride[2], const int padding[4]){

	//fprintf(stderr,"INSIDE CONV\n");

    	MemPoolRequest reqKer, reqImg;
    	MemPoolResponse respKer, respImg;

    	TensorDescriptor td_in, td_ker, td_out;

	td_in = in_img->descriptor;
    	td_ker = kernel->descriptor;

    	uint8_t is_row_major = td_in.row_major_form;
    	uint32_t out_H = (td_in.dimensions[0] + padding[0] + padding[1] - td_ker.dimensions[0])/stride[0] + 1;
    	uint32_t out_W = (td_in.dimensions[1] + padding[2] + padding[3] - td_ker.dimensions[1])/stride[1] + 1;
    	uint32_t out_C = 1;

    	out_img->descriptor.row_major_form = is_row_major;
    	out_img->descriptor.number_of_dimensions = 3;
    	out_img->descriptor.data_type = td_in.data_type;
    	out_img->descriptor.dimensions[0] = out_H;
    	out_img->descriptor.dimensions[1] = out_W;
    	out_img->descriptor.dimensions[2] = out_C;

	td_out = out_img->descriptor;

    	uint32_t data_size = sizeofTensorDataInBytes(td_ker.data_type);
    	int num_elems = numberOfElementsInTensor(kernel);
    	//int num_elems_left = num_elems;
  
	//Read kernel data.

    	uint64_t ker_data[1024];
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
            		printf("ERROR : Failed to read the image tensor.");
            		flag = 1;
            		break;
        	}

		for(int idx = (iter)*1024; idx < (iter)*1024 + elements_to_read; idx++)
		{
			ker_data[idx] = respKer.read_data[idx-(iter)*1024];
			printf("%"PRIu64"\n",ker_data[idx]);
		}
    	}

	//Read image data.

	uint64_t img_data[65536];
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
			img_data[idx] = respImg.read_data[idx-(iter)*1024];
			printf("index %d\n",idx);
			printf("%"PRIu64"\n",img_data[idx]);
		}
    	}

	//Perform convolution.
	
	uint64_t res[out_H*out_W];
	memset(res,0,out_H*out_W*sizeof(uint64_t));
	void *result_array_base = res;
	int l = 0;

	for(int p = 0; p < out_H; p++)
	{
		for(int q = 0; q < out_W; q++)
		{
			int img_data_start_index[] = {p*stride[0],q*stride[1]};
			convHelper(ker_data,img_data,&td_ker,&td_in,img_data_start_index,result_array_base,l);
			l++;
		}
	}
	
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+1));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+2));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+3));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+4));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+5));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+6));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+7));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+8));
	printf("%"PRIu64"\n",*(((uint64_t*)result_array_base)+9));

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
printf("THE END\n");
return 0;
}
