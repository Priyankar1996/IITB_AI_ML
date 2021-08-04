#include "createTensor.h"
#include "zero_padding.h"

int zeropad(Tensor *src, uint32_t scale_factor, uint32_t constant, Tensor *dest){
    initializeTensor(dest,constant);
    MemPool *mp_src = (Mempool *)(src->mem_pool_identifier);
    MemPool *mp_dest = (Mempool *)(dest->mem_pool_identifier);
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    // uint32_t i,j,num_elems = 1,flag = 0;

    // uint32_t data_size = sizeofTensorDataInBytes(src->descriptor.data_type);

    // num_elems = numberofElementsInTensor(src);



    //  MemPoolRequest req;
    req.request_tag = 0;
    // MemPoolResponse resp;

    //generate read req for one word at a time from src.
    //store it into temp_buffer.
    //generate write req for dest tensor.
    uint32_t src_base = src->mem_pool_buffer_pointer;
    uint32_t temp_buffer;
    // uint32_t k;

    //store the base address of dest tensor.
    uint32_t dest_base = dest->mem_pool_buffer_pointer;
    dest_base = resp.allocated_base_address;
    result->mem_pool_buffer_pointer = resp.allocated_base_address;
    ///////////////////////////////////////

    switch (src->descriptor.number_of_dimensions)
    {
    case 1:
        // Code for a single dimension
        for (uint32_t i = 0; i < (src->descriptor.dimensions[0]); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer,,);
            uint32_t desti[1] = {i+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        
        break;
    case 2:
        // Code for 2 dimensional Tensor
        for (uint32_t j = 0; j < (src->descriptor.dimensions[1] ); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0]); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[2] = {i,j};
            uint32_t desti[2] = {i+scale_factor,j + scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,ind);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        
        break;
    case 3:
        // Code for 3 dimensional Tensor
        for (uint32_t k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (uint32_t j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[3] = {i,j,k};
            uint32_t desti[3] = {i+scale_factor,j+scale_factor,k+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        
        break;
    case 4:
        // Code for 4 dimensional Tensor
        for (uint32_t l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (uint32_t k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (uint32_t j = 0; j < (src->descriptor.dimensions[1] ); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[4] = {i,j,k,l};
            uint32_t desti[4] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        
        break;
    case 5:
        // Code for 5 dimensional Tensor
        for (uint32_t m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (uint32_t l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (uint32_t k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (uint32_t j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[5] = {i,j,k,l,m};
            uint32_t desti[5] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        }
        
        break;
    case 6:
        // Code for 6 dimensional tensor
        for (uint32_t n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (uint32_t m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (uint32_t l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (uint32_t k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (uint32_t j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[6] = {i,j,k,l,m,n};
            uint32_t desti[6] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        }
        }
        break;
    case 7:
        // Code for 6 dimensional tensor
        for (uint32_t p = 0; p < (src->descriptor.dimensions[p] ); p++)
        {
            for (uint32_t n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (uint32_t m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (uint32_t l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (uint32_t k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (uint32_t j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (uint32_t i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[7] = {i,j,k,l,m,n,p};
            uint32_t desti[7] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor};
            uint32_t *address1 = getTensorEntryIndexOffset(src,i);
            uint32_t *address2 = getTensorEntryIndexOffset(src,desti);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base + address1;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(&mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base + address2;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(&mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        }
        }
        }
        break;     
    default:
        printf("Check the Tensor for errors");
        break;
    }
}


    

}