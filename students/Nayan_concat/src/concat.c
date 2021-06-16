MemPoolRequest req;
MemPoolResponse resp;

int concatTensors (Tensor* a, Tensor*  b, Tensor* result){
    TensorDescriptor td_a, td_b,td_r;

    td_a = a->descriptor;
    td_b = b->descriptor;
    td_r = result->descriptor;
    if (td_a.row_major_form != td_b.row_major_form || td_a.number_of_dimensions != td_b.number_of_dimensions || td_a.data_type != td_b.data_type)
    {
        fprintf(stderr,"ERROR: invalid tensor input\n");
        return -1;
    }

    uint32_t dx = -1,tot_elem=1,n_dims;  
    n_dims = td_a.number_of_dimensions;
    for (uint32_t i = 0; i < n_dims; i++)
    {
        if(td_a.dimensions[i] != td_b.dimensions[i]){
            if(dx == -1){
                dx = i;
            }else {
                fprintf(stderr,"ERROR: more than 1 dimension unequal\n");
                return -1;
            }
        }
        tot_elem *= td_a.dimensions[i];
    }
    if(dx == -1){
        fprintf(stderr,"ERROR: no dimension unequal\n");
        return -1;
    }
    printf("dx = %d\n",dx);

    uint32_t index_start[MAX_DIMENSIONS], index_end[MAX_DIMENSIONS];
    uint32_t result_start[MAX_DIMENSIONS], result_end[MAX_DIMENSIONS];
    uint32_t mem_start[MAX_DIMENSIONS], mem_end[MAX_DIMENSIONS];

    for (uint32_t i = 0; i < n_dims; i++)
    {
        index_start[i] = 0;
        index_end[i] = 0;
        result_start[i] = 0;
        result_end[i] = 0;
        mem_start[i]=0;
        mem_end[i]=0;
    }

    uint32_t dataSize = sizeofTensorDataInBytes(td_a.data_type);
    int32_t DSTART,DINCREMENT,DEND;
    int iter = -1;
    
    DINCREMENT = (td_a.row_major_form ? -1 : 1);
    DEND =  (td_a.row_major_form ? -1 : n_dims);
    DSTART = dx + DINCREMENT ;

    uint32_t tot_iter = 1;
    for (uint32_t i = DSTART; i != DEND; i+=DINCREMENT)
    {
        tot_iter *= td_a.dimensions[i];
    }

    int Istart, Iend, deltaI,alt=1;
    TensorDescriptor* td;
    Tensor* t;
    for(iter=0 ;iter < 2*tot_iter; iter++ ){          
        // printf("requested %d\n",iter);
        printf ("-----------------------------------------------\n");
        
        //3. switch tensor
        if(iter%2 ==0){
            td = &td_a; 
            t = a;
            printf("A ");
        }else{
            td = &td_b;
            t = b;
            printf("B ");
        }

        //4. find start and end index
        //find index_start
        if (iter > 1 && iter%2 == 0){
            incrementCoordinateVectorFromDim(n_dims, dx, td->dimensions, index_start, td->row_major_form);
        }

        //find index_end
        DINCREMENT = (td->row_major_form ? -1 : 1);
        DSTART = (td->row_major_form ? n_dims-1 : 0);
        DEND =  dx+DINCREMENT;
        for (uint32_t i = DSTART; i != DEND; i+=DINCREMENT)
        {
            index_end[i] = td->dimensions[i]-1;
        }
        DINCREMENT = (td->row_major_form ? -1 : 1);
        DEND =  (td->row_major_form ? -1 : n_dims);
        DSTART =dx+DINCREMENT;
        for (uint32_t i = DSTART; i != DEND; i+=DINCREMENT)
        {
            index_end[i] = index_start[i];
        }

        printf(" index ");
        for (uint32_t i = 0; i < n_dims; i++)
        {
            printf("%4d,",index_start[i]);
        }
        printf(" : ");
        for (uint32_t i = 0; i < n_dims; i++)
        {
            printf("%4d,",index_end[i]);
        }
        printf("\n");

        //5. request elements required to copy
        uint32_t n_elem=1;
        n_elem=getTensorEntryIndexOffset(td,index_end)-getTensorEntryIndexOffset(td,index_start)+1;

        int32_t words_left = ceil(n_elem*dataSize/8.0);
        uint32_t elements_toCopy,is_lessThan1024Words=0;
        
        if (words_left < MAX_SIZE_OF_REQUEST_IN_WORDS){
            is_lessThan1024Words = 1;
        }

        int32_t iterMem = -1;
        for (; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
        {   
            iterMem++;
            // if(iter>0){        
            //     incrementCoordinateVector(n_dims,td_r.dimensions,result_start,td_r.row_major_form);
            // }
            req.request_type = READ;
            req.request_tag = 1; // confirm dis
            req.arguments[2] = 1; // stride = 1 as pointwise
            if (words_left+1 < MAX_SIZE_OF_REQUEST_IN_WORDS && is_lessThan1024Words == 1 ){
                elements_toCopy = n_elem;
                req.arguments[0] =  words_left+1; 
                req.arguments[1] = t->mem_pool_buffer_pointer+getTensorEntryIndexOffset(td,index_start)*dataSize/8;
                copyCoordinateVector(n_dims,mem_start,index_start);
                copyCoordinateVector(n_dims,mem_end,index_end);
            }else if (words_left+1 < MAX_SIZE_OF_REQUEST_IN_WORDS){
                // last iteration
                elements_toCopy = n_elem-iterMem*MAX_SIZE_OF_REQUEST_IN_WORDS*8/dataSize;
                req.arguments[0] = words_left; 
                copyCoordinateVector(n_dims,mem_start,mem_end);
                incrementCoordinateVector(n_dims,td->dimensions, mem_start,td->row_major_form);
                incrementCoordinateVectorByOffset(n_dims,elements_toCopy,td->dimensions,mem_end,td->row_major_form);
                req.arguments[1] = t->mem_pool_buffer_pointer+getTensorEntryIndexOffset(td,mem_start)*dataSize/8;
            }else if (iterMem == 0) {
                // first iteration
                elements_toCopy = MAX_SIZE_OF_REQUEST_IN_WORDS*8/dataSize;
                req.arguments[0] = MAX_SIZE_OF_REQUEST_IN_WORDS;
                copyCoordinateVector(n_dims,mem_start,index_start);
                copyCoordinateVector(n_dims,mem_end,index_start);
                incrementCoordinateVectorByOffset(n_dims,elements_toCopy-1,td->dimensions,mem_end,td->row_major_form);          
                req.arguments[1] = t->mem_pool_buffer_pointer+getTensorEntryIndexOffset(td,mem_start)*dataSize/8;
            }else {
                elements_toCopy = MAX_SIZE_OF_REQUEST_IN_WORDS*8/dataSize;
                req.arguments[0] = MAX_SIZE_OF_REQUEST_IN_WORDS;
                copyCoordinateVector(n_dims,mem_start,mem_end);
                incrementCoordinateVector(n_dims,td->dimensions, mem_start,td->row_major_form);
                incrementCoordinateVectorByOffset(n_dims,elements_toCopy,td->dimensions,mem_end,td->row_major_form);
                req.arguments[1] = t->mem_pool_buffer_pointer+getTensorEntryIndexOffset(td,mem_start)*dataSize/8;
            }
            printf("    mem %d",iterMem);
            for (uint32_t i = 0; i < n_dims; i++)
            {
                printf("%4d,",mem_start[i]);
            }
            printf(" : ");
            for (uint32_t i = 0; i < n_dims; i++)
            {
                printf("%4d,",mem_end[i]);
            }
            printf(" -> ");
            for (uint32_t i = 0; i < n_dims; i++)
            {
                printf("%4d,",result_start[i]);
            }
            printf("\n");

            memPoolAccess(t->mem_pool_identifier,&req,&resp); 
            
            if(resp.status == NOT_OK) {
                fprintf(stderr,"read Tensor FAILURE.\n");
                return -1;
            }
            
            //6. copy all the values till dx starting from d0/dn-1 depending row/column major from both tensor to result
            void *array1, *array2;
            array1 = resp.read_data;  
            array2 = req.write_data;
            uint32_t offset;

            uint32_t copySrcOffset = getTensorEntryIndexOffset(td,mem_start);
            copySrcOffset /= 8/dataSize;
            copySrcOffset *= 8/dataSize;
            offset  =getTensorEntryIndexOffset(&td_r,result_start);
            uint32_t copyDestOffset;
            copyDestOffset = offset%(8/dataSize);
            req.arguments[0] += ceil(copyDestOffset/8.0);
            req.arguments[0] = MIN(req.arguments[0],MAX_SIZE_OF_REQUEST_IN_WORDS);

            req.write_data[0]=result->mem_pool_identifier->mem_pool_buffer[offset*dataSize/8+result->mem_pool_buffer_pointer];
            req.write_data[words_left-1]=result->mem_pool_identifier->mem_pool_buffer[offset*dataSize/8+result->mem_pool_buffer_pointer+words_left-1];

            copyTensorArray(td,array1,mem_start,mem_end,array2,copySrcOffset,copyDestOffset);

            req.request_type = WRITE;
            req.request_tag = 1; // confirm dis
            req.arguments[1] = result->mem_pool_buffer_pointer + offset*dataSize/8;
                        
            memPoolAccess(result->mem_pool_identifier,&req,&resp); 
            
            //7. incement result_start goto 3
            incrementCoordinateVectorByOffset(n_dims,elements_toCopy,td_r.dimensions,result_start,td_r.row_major_form);
        	
            
            // printf("\nTensor Result\n");
        	// print2dTensor(result,&req,&resp);
        }
    }
}


void incrementCoordinateVectorFromDim (int ndim, int dim_start, uint32_t* dims, uint32_t* vec, uint8_t row_major_form)
{
	int Istart, Iend, deltaI;
    Iend   = (row_major_form ? -1 : ndim);
    deltaI = (row_major_form ? -1 : 1);
    Istart = dim_start + deltaI;

	int I;
	int CARRY = 0;
	vec[Istart] += 1;
	if(vec[Istart]==dims[Istart]){
		for(I = Istart; I != Iend; I += deltaI)
		{
			if((vec[I] + CARRY) == dims[I])
			{
				vec[I] = 0;
				CARRY = 1;
			}
			else
			{	
				vec[I] += 1;
				CARRY = 0;
                break;
			}
		}
	}
}

void incrementCoordinateVectorByOffset (int ndim, int offset, uint32_t* dims, uint32_t* vec, uint8_t row_major_form)
{
	int Istart, Iend, deltaI;
	Istart = (row_major_form ?  ndim - 1 : 0);
	deltaI = (row_major_form ? -1 : 1);
	Iend   = (ndim - 1) - Istart+deltaI;

	int I;
	int CARRY = 0;
    int SCALE_FACTOR[MAX_DIMENSIONS];
    SCALE_FACTOR[Istart] = 1;
    Istart += deltaI;
	for(I = Istart; I != Iend; I += deltaI)
	{   
        SCALE_FACTOR[I] = SCALE_FACTOR[I-deltaI]*dims[I-deltaI];
	}

	Istart = (row_major_form ?  0 : ndim -1);
	deltaI = (row_major_form ? 1 : -1);
	Iend   = (ndim - 1) - Istart+ deltaI;
	for(I = Istart; I != Iend; I += deltaI)
	{   
        int temp = offset/SCALE_FACTOR[I];
        vec[I] += temp;
        if(vec[I] == dims[I]){
            int CARRY = 0;
            for (int i = I; i != Istart-deltaI; i-=deltaI)
            {
                if((vec[i] + CARRY) == dims[i])
                {
                    vec[i] = 0;
                    CARRY = 1;
                }
                else
                {	
                    vec[i] += 1;
                    CARRY = 0;
                    break;
                }
            }
            
        }
        offset -= temp*SCALE_FACTOR[I]; 
        if(vec[I] > dims[I]){
            fprintf(stderr, "ERROR: offset too high");
            // return -1;
        }
    }
}

uint32_t copyTensorArray(	
					TensorDescriptor* td, 
					void* tensor_data_array,
					uint32_t* indices_low, uint32_t* indices_high,
					void* section_data_array,
					uint32_t src_offset,uint32_t dest_offset)
{
	uint32_t IVECTOR[MAX_DIMENSIONS];
	

	copyCoordinateVector(td->number_of_dimensions, IVECTOR, indices_low);
	uint32_t destination_index = dest_offset;
	while(1)
	{
		uint32_t source_index = getTensorEntryIndexOffset(td, IVECTOR) - src_offset;
		copyTensorEntry(td, section_data_array, destination_index, 
					tensor_data_array, source_index);

		if(areCoordinateVectorsEqual(td->number_of_dimensions, IVECTOR, indices_high))
			break;

		destination_index++;
		incrementCoordinateVector(td->number_of_dimensions, td->dimensions, IVECTOR, td->row_major_form);
	}

	return(0);
}
