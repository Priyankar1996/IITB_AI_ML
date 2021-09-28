// AUTHOR :- AJINKYA RAGHUWANSHI,
//          DEPARTMENT OF ELECTRICAL ENGINEERING, IITB

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "mempool.h"
#include "tensor.h"
#include "zero_padding.h"


void read_write_data(Tensor *src, uint32_t scale_factor, uint32_t constant, Tensor *dest,uint32_t *ind,uint32_t *desti);
uint32_t i[MAX_DIMENSION] = { };
uint32_t ind[MAX_DIMENSION] = { };
uint32_t desti[MAX_DIMENSION] = { };

// Function for creating the indices
void funcn(Tensor *src, Tensor *dest,int n,int scale_factor, int constant){
    // printf("\n func entered !!!");
    if (n == 0){
        // printf("Looping for n=0\n");
        for (i[0] = 0; i[0] < (src->descriptor.dimensions[0]); i[0]++ )
        {
            ind[0] = i[0];
            desti[0] = i[0] +scale_factor;
            // printf("\n ind is %u and desti is %u",ind[0],desti[0]);
            read_write_data(src,scale_factor,constant,dest,ind,desti);
        }
    }
    else{
        // printf("Looping for n-1=%d\n",n-1);
        // funcn(n-1);
        // printf("descriptor is %u",src->descriptor.dimensions[n-1]);
        for(i[n-1] = 0; i[n-1] < (src->descriptor.dimensions[n-1]); i[n-1]++){
            ind[n-1] = i[n-1];
            desti[n-1] = i[n-1] + scale_factor;
            // printf("\n ind is %u and desti is %u",ind[n-1],desti[n-1]);
            funcn(src, dest, n-1, scale_factor,constant);
        }

    }
}

void zeropad(Tensor *src, uint32_t scale_factor, uint32_t constant, Tensor *dest){
    // printf("%d\n", sizeof(i)/sizeof(i[0]));
    
    printf("\n func started !!!");
    // Creating indices and reading as well as writing the tensor
    funcn(src,dest,src->descriptor.number_of_dimensions,scale_factor,constant);
    printf("\n func ended !!!");

}





void read_write_data(Tensor *src, uint32_t scale_factor, uint32_t constant, Tensor *dest,uint32_t *ind,uint32_t *desti){
            // initializeTensor(dest,&constant);
    MemPool *mp_src = (MemPool*)(src->mem_pool_identifier);
    MemPool *mp_dest = (MemPool*)(dest->mem_pool_identifier);
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    

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
            
            
            
            // printf("\n dest of %d is %d and dest of %d is %d",i,desti[0],j,desti[1]);
            // uint32_t *address1 = getTensorEntryIndexOffset(&src,ind);
            uint32_t address1 = getTensorEntryIndexOffset(&(src->descriptor),ind) * sizeof(src->descriptor.data_type);
            // printf("\n index offset of ind is %u",getTensorEntryIndexOffset(&(src->descriptor),ind));
            printf("\n address1 is %u",address1);
            // uint32_t *address2 = getTensorEntryIndexOffset(&dest,desti);
            uint32_t address2 = getTensorEntryIndexOffset(&(dest->descriptor),desti) * sizeof(dest->descriptor.data_type);
            // printf("\n index offset of dest is %u",getTensorEntryIndexOffset(&(dest->descriptor),desti));
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
