#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "mempool.h"
#include "tensor.h"
// #include "createTensor.h"
#include "zero_padding.h"

void zeropad(Tensor *src, uint32_t scale_factor, uint32_t constant, Tensor *dest){
    // initializeTensor(dest,&constant);
    MemPool *mp_src = (MemPool*)(src->mem_pool_identifier);
    MemPool *mp_dest = (MemPool*)(dest->mem_pool_identifier);
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    // uint32_t i,j,num_elems = 1,flag = 0;

    // uint32_t data_size = sizeofTensorDataInBytes(src->descriptor.data_type);

    // num_elems = numberofElementsInTensor(src);

    uint32_t i,j,k,l,m,n,p,q,r,s,t;

    //  MemPoolRequest mp_req;
    mp_req.request_tag = 0;
    // MemPoolResponse mp_resp;

    //generate read mp_req for one word at a time from src.
    //store it into temp_buffer.
    //generate write mp_req for dest tensor.
    uint32_t src_base = src->mem_pool_buffer_pointer;
    uint32_t temp_buffer;
    // uint32_t k;

    //store the base address of dest tensor.
    uint32_t dest_base = dest->mem_pool_buffer_pointer;
    dest_base = mp_resp.allocated_base_address;
    dest->mem_pool_buffer_pointer = mp_resp.allocated_base_address;
    ///////////////////////////////////////

    switch (src->descriptor.number_of_dimensions)
    {
    case 1:
        // Code for a single dimension
        for (i = 0; i < (src->descriptor.dimensions[0]); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer,,);
            uint32_t desti[1] = {i+scale_factor};
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),&i) * sizeof(src->descriptor.data_type);
            printf("address 1 is %u",address1);
            // uint32_t address1 = sizeof(src->descriptor.data_type) * i; 
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);
            printf("address 2 is %u",address2);
            // uint32_t address2 = sizeof(dest->descriptor.data_type) * desti[1];             

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)(src->mem_pool_identifier), &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        
        break;
    case 2:
        // Code for 2 dimensional Tensor
        for (j = 0; j < (src->descriptor.dimensions[1] ); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0]); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            printf("\n i is %d and j is %d",i,j);
            uint32_t ind[2] = {i,j};
            uint32_t desti[2] = {i+scale_factor,j + scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,ind);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            printf("\n address1 is %u",address1);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);
            printf("\n address2 is %u",address2);

            

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////

        
        }
        }
        
        break;
    case 3:
        // Code for 3 dimensional Tensor
        for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            printf("\n i is %d and j is %d and k is %d",i,j,k);
            uint32_t ind[3] = {i,j,k};
            uint32_t desti[3] = {i+scale_factor,j+scale_factor,k+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            printf("\n address1 is %u",address1);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);
            printf("\n address2 is %u",address2);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

        // src_base++;
        // dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        
        break;
    case 4:
        // Code for 4 dimensional Tensor
        for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1] ); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[4] = {i,j,k,l};
            uint32_t desti[4] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[5] = {i,j,k,l,m};
            uint32_t desti[5] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[6] = {i,j,k,l,m,n};
            uint32_t desti[6] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        // Code for 7 dimensional tensor
        for (p = 0; p < (src->descriptor.dimensions[6] ); p++)
        {
            for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[7] = {i,j,k,l,m,n,p};
            uint32_t desti[7] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
    case 8:
        // Code for 8 dimensional tensor
        for (q = 0; q < (src->descriptor.dimensions[7] ); q++)
        {
            for (p = 0; p < (src->descriptor.dimensions[6] ); p++)
        {
            for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[8] = {i,j,k,l,m,n,p,q};
            uint32_t desti[8] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor,q+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        }
        break;
    case 9:
        // Code for 9 dimensional tensor
        for (r = 0; r < (src->descriptor.dimensions[8] ); r++)
        {
            for (q = 0; q < (src->descriptor.dimensions[7] ); q++)
        {
            for (p = 0; p < (src->descriptor.dimensions[6] ); p++)
        {
            for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[9] = {i,j,k,l,m,n,p,q,r};
            uint32_t desti[9] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor,q+scale_factor,r+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        }
        }
        break;
    case 10:
        // Code for 10 dimensional tensor
        for (s = 0; s < (src->descriptor.dimensions[9] ); s++)
        {
            for (r = 0; r < (src->descriptor.dimensions[8] ); r++)
        {
            for (q = 0; q < (src->descriptor.dimensions[7] ); q++)
        {
            for (p = 0; p < (src->descriptor.dimensions[6] ); p++)
        {
            for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[10] = {i,j,k,l,m,n,p,q,r,s};
            uint32_t desti[10] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor,q+scale_factor,r+scale_factor,s+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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
        }
        }
        }
        break;
        case 11:
        // Code for 11 dimensional tensor
        for (t = 0; t < (src->descriptor.dimensions[10]); t++)
        {
            for (s = 0; s < (src->descriptor.dimensions[9] ); s++)
        {
            for (r = 0; r < (src->descriptor.dimensions[8] ); r++)
        {
            for (q = 0; q < (src->descriptor.dimensions[7] ); q++)
        {
            for (p = 0; p < (src->descriptor.dimensions[6] ); p++)
        {
            for (n = 0; n < (src->descriptor.dimensions[5] ); n++)
        {
            for (m = 0; m < (src->descriptor.dimensions[4] ); m++)
        {
            for (l = 0; l < (src->descriptor.dimensions[3] ); l++)
        {
            for (k = 0; k < (src->descriptor.dimensions[2] ); k++)
        {
            for (j = 0; j < (src->descriptor.dimensions[1]); j++)
        {
            for (i = 0; i < (src->descriptor.dimensions[0] ); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(src->mem_pool_buffer_pointer + size_to_leave(src->descriptor.dimensions[0]),,);
            uint32_t ind[11] = {i,j,k,l,m,n,p,q,r,s,t};
            uint32_t desti[11] = {i+scale_factor,j+scale_factor,k+scale_factor,l+scale_factor,m+scale_factor,n+scale_factor,p+scale_factor,q+scale_factor,r+scale_factor,s+scale_factor,t+scale_factor};
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,i);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = src_base + address1;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)src->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", src_base + address1);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", src_base + address1);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = dest_base + address2;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)dest->mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", dest_base + address2);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);

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