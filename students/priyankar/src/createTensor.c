#include "createTensor.h"

int createTensor(Tensor *t,MemPool *mp)
{
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    //
    // Calculate number of pages required to store the tensor.
    //
    uint16_t i,num_elems=1,n_pages;
    uint32_t dataSize = sizeofTensorDataInBytes(t->descriptor.data_type);
    t->mem_pool_identifier = mp->mem_pool_index;
    t->mem_pool_buffer_pointer = mp->write_pointer*512;
    for(i=0;i<t->descriptor.number_of_dimensions;i++)
    {
        num_elems *= t->descriptor.dimensions[i];
    }

    n_pages = CEILING(CEILING((3+MAX_DIMENSIONS)*4 + num_elems*dataSize,8),MEMPOOL_PAGE_SIZE);
    //    
    //Allocate that many pages in the mempool.
    //
    mp_req.request_type = ALLOCATE;
    mp_req.request_tag = t->mem_pool_buffer_pointer ;
    mp_req.arguments[0] = n_pages;

    memPoolAccess(mp, &mp_req, &mp_resp);

    if(mp_resp. status != OK)
    {
        printf("ERROR: Couldn't allocate memory.\n");
        return(1);
    }
    else
    {
        printf("SUCCESS: Allocated %d page(s).%u\n",n_pages);
        //
        //Store tensorDescriptor in the memory-pool.
        //
        void *array;
        array = mp_req.write_data;

		*(((uint32_t*)array) + 1) = t->descriptor.data_type;
        *(((uint32_t*)array) + 2) = t->descriptor.row_major_form;
        *(((uint32_t*)array) + 3) = t->descriptor.number_of_dimensions;
        for(i=0;i<t->descriptor.number_of_dimensions;i++)
        {
            *(((uint32_t*)array) + 3 + i) = t->descriptor.dimensions[i];
        }
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp->write_pointer+1*1024;
        mp_req.arguments[0] = CEILING((3+MAX_DIMENSIONS)*4,8);
	    mp_req.arguments[1] = t->mem_pool_buffer_pointer;
        memPoolAccess(mp, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
	    {
	    	printf("ERROR: Could not write TensorDescriptor into Mempool.\n");
		    return(1);
	    }
        else
        {
            printf("SUCCESS: Wrote TensorDescriptor into Mempool.\n");
            t->mem_pool_buffer_pointer += (uint64_t)34;
            return(0);
        }
    }
}

int initializeTensor (Tensor* t, uint64_t initial_value, MemPool* mp)
{
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
	uint32_t data_size = sizeofTensorDataInBytes(t->descriptor.data_type); 
    uint32_t i,num_elems = 1;
    
	TensorDataType dataType = t->descriptor.data_type;

    for(i=0;i<t->descriptor.number_of_dimensions;i++)
    {
        num_elems *= t->descriptor.dimensions[i];
    }
	mp_req.request_type = WRITE;
	//mp_req.request_tag = mp->write_pointer+2*1024; 

	/*if(offset == -1){
		data = 0;
	}else{
		data = offset-1 ; //or read from FILE
	}*/

	int iter = -1;
	int words_left = CEILING(num_elems*data_size,8);
    //
    // Writes 1024 words in every iteration.
    //
	for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS){
		iter ++;
		int elementsToWrite = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		mp_req.arguments[0] = elementsToWrite; 
		mp_req.arguments[1] = t->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		mp_req.arguments[2] = 1; // stride = 1 as pointwise

		void *array;
		array = mp_req.write_data;  

		for (i = 0; i < elementsToWrite*8/data_size; i++)
		{
			switch(dataType){
			case u8: ; 
				uint8_t val8 = (uint8_t) initial_value;
				*(((uint8_t*)array) + i) = val8;
				break;

			case u16: ;
				uint16_t val16 = (uint16_t) initial_value;
				*(((uint16_t*)array) + i) = val16;
				break;

			case u32: ;
				uint32_t val32 = (uint32_t) initial_value;
				*(((uint32_t*)array) + i) = val32;
				break;

			case u64: ; 
				uint64_t val64 = (uint64_t) initial_value;
				*(((uint64_t*)array) + i) = val64;
				break;
				
			case i8: ;
				int8_t val8i = (int8_t) initial_value;
				*(((int8_t*)array) + i) = val8i;
				break;

			case i16: ;
				int16_t val16i = (int16_t) initial_value;
				*(((int16_t*)array) + i) = val16i;
				break;

			case i32: ; 
				int32_t val32i = (int32_t) initial_value ;
				*(((int32_t*)array) + i) = val32i;
				break;

			case i64: ;
				int64_t val64i = (int64_t) initial_value;
				*(((int64_t*)array) + i) = val64i;
				break;

			// case float8: ;
				// to be added 
				// break;

			// case float16: ;
				// to be added 
				// break;

			case float32: ;
				float val32f = (float) initial_value;
				*(((float*)array) + i) = val32f;
				break;

			case float64: ;
				double val64f = (double) initial_value;
				*(((double*)array) + i) = val64f;
				break;
				
			}		
		}
		memPoolAccess(mp, &mp_req, &mp_resp); 
		if(mp_resp.status == OK) 
        {
            printf("SUCCESS: Tensor initialised.\n");
            return(0);
		}
        else 
        {
			printf("ERROR: Failed to initialise tensor.\n");
			return(1);
		}
	}	
}

int destroyTensor(Tensor *t, MemPool *mp)
{
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t data_size = sizeofTensorDataInBytes(t->descriptor.data_type); 
    uint32_t i,num_elems = 1,n_pages;
    for(i=0;i<t->descriptor.number_of_dimensions;i++)
    {
        num_elems *= t->descriptor.dimensions[i];
    }
        
    n_pages = CEILING(CEILING((3+MAX_DIMENSIONS)*4+num_elems*data_size,8),MEMPOOL_PAGE_SIZE);
    //
    // Deallocates the pages provided to the tensor.
    //
    t->mem_pool_buffer_pointer -= (uint64_t)34;
    mp_req.request_type = DEALLOCATE;
    mp_req.request_tag = t->mem_pool_buffer_pointer;
    mp_req.arguments[0] = n_pages;
    mp_req.arguments[1] = t->mem_pool_buffer_pointer;
    

    memPoolAccess(mp, &mp_req, &mp_resp);

    if(mp_resp.status != OK)
    {
        printf("ERROR: Couldn't destroy tensor.\n");
        return(1);  
    }
    else
    {
        printf("SUCCESS: Tensor destroyed.\n");
        return(0);
    }
}

int copyTensor(Tensor *src, Tensor *dest, MemPool *mp_src, MemPool *mp_dest)
{
   
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t i,j,num_elems=1,flag=0;
    
    uint32_t data_size = sizeofTensorDataInBytes(src->descriptor.data_type); 
    
    for(i=0;i<src->descriptor.number_of_dimensions;i++)
    {
        num_elems *= src->descriptor.dimensions[i];
    }
    //
    //  Reads a tensor from mempool. The data received is written 
    //  into the write buffer of the requester to the destination
    //  tensor.
    //
    int iter = -1;
    int words_left = CEILING(num_elems * data_size,8);
    for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
		iter ++;
        int elements_to_read = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        
        mp_req.request_type = READ;
        mp_req.arguments[0] = elements_to_read;
        mp_req.arguments[1] = src->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		mp_req.arguments[2] = 1;//stride

        memPoolAccess(mp_src, &mp_req, &mp_resp);
        if(mp_resp.status !=OK)
        {
            printf("ERROR: Failed to read the source tensor.");
            flag = 1;
            break;
        }
        
        for(j=0;j<MAX_SIZE_OF_REQUEST_IN_WORDS;j++)
            mp_req.write_data[j] = mp_resp.read_data[j];
        
        mp_req.request_type = WRITE;
        mp_req.arguments[0] = elements_to_read;
        mp_req.arguments[1] = dest->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
        mp_req.arguments[2] = 1;

        memPoolAccess(mp_dest, &mp_req, &mp_resp);
        if(mp_resp.status !=OK)
        {
            printf("ERROR: Failed to copy tensor.");
            flag =1 ;
            break;
        }
    }
    if(flag == 0)
        printf("SUCCESS: Tensor copied to specified location.\n");
    return flag;
}