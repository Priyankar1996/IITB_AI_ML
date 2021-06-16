void print2dTensor(Tensor* a, MemPoolRequest* req, MemPoolResponse* resp){
	uint32_t num_elems = a->descriptor.dimensions[0]*a->descriptor.dimensions[1];
	
	TensorDescriptor td;
	td = a->descriptor;

	uint32_t index[MAX_DIMENSIONS],indices_high[MAX_DIMENSIONS];
    
    for ( int i = 0; i < MAX_DIMENSIONS; i++)
    {
        index[i]=0;
        indices_high[i]=td.dimensions[i]-1;
    }
    // indices_high[1]=0;
    // indices_high[0]=0;
	uint32_t nelem=1;
	for (int i = 0; i < td.number_of_dimensions; i++)
	{
		nelem *= td.dimensions[i];
	}
	int32_t datasize = sizeofTensorDataInBytes(td.data_type);		
	req->request_type=READ;
	// if(td.number_of_dimensions != 2 ){return;}

	int iter = -1,i,j;
	int words_left = ceil((num_elems*datasize)/8.0);
	
	void* base = a->mem_pool_identifier->mem_pool_buffer + a->mem_pool_buffer_pointer;
	while (1)
    {    
        // int DSTART, DEND, DINCREMENT;
        printf("\ndimension ");

    	for(uint32_t I = 0; I != td.number_of_dimensions-2; I++){
            printf("%d ",index[I]);
        }
        printf("0 0\n");

        for(i=0;i<td.dimensions[td.number_of_dimensions-2];i++)
        {
            for(j=0;j<td.dimensions[td.number_of_dimensions-1];j++)
            {
                int64_t data;
                index[td.number_of_dimensions-2] = i;
                index[td.number_of_dimensions-1] = j;
                int k = getTensorEntryIndexOffset(&td,index);
                switch(td.data_type)
                {
                    case u8:
                    case i8:
                    case float8:
                        data = *((uint8_t*)base + k);
                        break;
                    case u16:
                    case i16:
                    case float16:
                        data = *((uint16_t*)base + k);
                        break;
                    case u32:
                    case i32:
                    case float32:
                        data = *((uint32_t*)base + k);
                        break;
                    case u64:
                    case i64:
                    case float64:
                        data = *((uint64_t*)base + k);
                        break;
                    default:
                        break;
                }
                printf("%4d ",data);
                // printf("%" PRIx64 "",data);
            }
            printf("\n");
        }
		if(areCoordinateVectorsEqual(td.number_of_dimensions, index, indices_high))
			break;
        incrementCoordinateVector(td.number_of_dimensions,td.dimensions,index,1);


    }
}

int fillTensorValues (Tensor* t,uint32_t num_elems, double offset, MemPoolRequest* req, MemPoolResponse* resp ){
	uint32_t element_size = sizeofTensorDataInBytes(t->descriptor.data_type); 
	TensorDataType dataType = t->descriptor.data_type;

	req->request_type = WRITE;
	req->request_tag = 1; // confirm dis
	double data;
	if(offset == -1){
		data = 0;
	}else{
		data = offset-1 ; //or read from FILE
	}

	int iter = -1;
	int words_left = ceil((num_elems*element_size)/8.0);
	for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS){
		iter ++;
		int elementsToWrite = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
		req->arguments[0] =  elementsToWrite; 
		req->arguments[1] = t->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		req->arguments[2] = 1; // stride = 1 as pointwise

		void *array;
		array = req->write_data;  

		for (int i = 0; i < elementsToWrite*8/element_size; i++)
		{
			if(offset == -1){
				data = 0;
			}else{
				data ++ ; //or read from FILE
			}

			// printf("%f\n",data);
			switch(dataType){
			case u8: ; 
				uint8_t val8 = (uint8_t) data;
				*(((uint8_t*)array) + i) = val8;
				break;

			case u16: ;
				uint16_t val16 = (uint16_t) data;
				*(((uint16_t*)array) + i) = val16;
				break;

			case u32: ;
				uint32_t val32 = (uint32_t) data;
				*(((uint32_t*)array) + i) = val32;
				break;

			case u64: ; 
				uint64_t val64 = (uint64_t) data;
				*(((uint64_t*)array) + i) = val64;
				break;
				
			case i8: ;
				int8_t val8i = (int8_t) data;
				*(((int8_t*)array) + i) = val8i;
				break;

			case i16: ;
				int16_t val16i = (int16_t) data;
				*(((int16_t*)array) + i) = val16i;
				break;

			case i32: ; 
				int32_t val32i = (int32_t) data ;
				*(((int32_t*)array) + i) = val32i;
				break;

			case i64: ;
				int64_t val64i = (int64_t) data;
				*(((int64_t*)array) + i) = val64i;
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
				break;

			case float64: ;
				double val64f = (double) data;
				*(((double*)array) + i) = val64f;
				break;
				
			}		
		}

		memPoolAccess(t->mem_pool_identifier, req, resp); 

		if(resp->status == OK) {
			// return 0;
		}else {
			fprintf(stderr,"write Tensor FAILURE.\n");
			return -1;
		}
	}	
}