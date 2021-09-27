#include "copyTensor.h"

int copyTensorInMemory(Tensor *src, Tensor *dest)
{
    //address of mempool is typecasted
    MemPool *mp_src = (MemPool*)(src->mem_pool_identifier);
    MemPool *mp_dest = (MemPool*)(dest->mem_pool_identifier);
    //request-resp pipes
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t i,j,num_elems=1,flag=0;

    //get number of bytes
    uint32_t data_size = sizeofTensorDataInBytes(src->descriptor.data_type);


    num_elems = numberOfElementsInTensor(src);
    //
    //  Reads a tensor from mempool. The data received is written
    //  into the write buffer of the requester to the destination
    //  tensor.
    //
    int iter = -1;
    int words_left = CEILING(num_elems * data_size,8);
    //max request is 1024
    for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
		iter ++;
		//last request can be less than 1024
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
