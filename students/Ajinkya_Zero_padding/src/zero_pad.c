// AUTHOR :- AJINKYA RAGHUWANSHI,
//          DEPARTMENT OF ELECTRICAL ENGINEERING, IITB

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"
#include "zero_padding.h"

MemPool pool1,pool2;
// Pre-defining the tensor for future operations
Tensor a,a_diff_pool;
// Creating a variable in order to detect error
int _err_ = 0;

#define MAX_PAGES 20


void zero_pad_3d(Tensor *src, uint32_t scale_factor, Tensor *dest)
{
     int pad = scale_factor;
                int n1 = src->descriptor.dimensions[0];
                int n2 = src->descriptor.dimensions[1];
                int n3 = src->descriptor.dimensions[2];

                int size = src->descriptor.data_type;
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

    uint32_t address1, address2;

                for(int k=0;k<n3;k++){
	    int idx   = 0;
	    int width = 0;
	//  jump only n2 times
	//
	    for(int jump= (n1+2*pad)*(n2+2*pad)*k + ((n1+2*pad)*pad) + pad ; 
	    width     <       n2		                      ; 
	    jump = jump + ((n1) + 2*pad)     )
	    {
		for(int i=0;i<n1;i++)
		{
			//dest[jump + i ] = source[ (n1*n2*k) + idx*n1 + i ]; 
			// n1*n2 is size of smaller array 
            {
                 address1 = src_base + size * ((n1*n2*k) + idx*n1 + i);
                 address2 = dest_base + size * (jump + i);
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




            }
		}
		idx   = idx   + 1 ;
		width = width + 1 ;

	    }
        }
}

void zero_pad_2d(Tensor *src, uint32_t scale_factor, Tensor *dest)
{
            int pad = scale_factor;
                int n1 = src->descriptor.dimensions[0];
                int n2 = src->descriptor.dimensions[1];
                int n3 = 1;

                int size = src->descriptor.data_type;
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

    uint32_t address1, address2;

                for(int k=0;k<n3;k++){
	    int idx   = 0;
	    int width = 0;
	//  jump only n2 times
	//
	    for(int jump= (n1+2*pad)*(n2+2*pad)*k + ((n1+2*pad)*pad) + pad ; 
	    width     <       n2		                      ; 
	    jump = jump + ((n1) + 2*pad)     )
	    {
		for(int i=0;i<n1;i++)
		{
			//dest[jump + i ] = source[ (n1*n2*k) + idx*n1 + i ]; 
			// n1*n2 is size of smaller array 
            {
                 address1 = src_base + size * ((n1*n2*k) + idx*n1 + i);
                 address2 = dest_base + size * (jump + i);
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




            }
		}
		idx   = idx   + 1 ;
		width = width + 1 ;

	    }
        }
}


void zero_pad_1d(Tensor *src, uint32_t scale_factor, Tensor *dest)
{
    int pad = scale_factor;
                int n1 = src->descriptor.dimensions[0];
                int n2 = 1;
                int n3 = 1;

                int size = src->descriptor.data_type;
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

    uint32_t address1, address2;

                for(int k=0;k<n3;k++){
	    int idx   = 0;
	    int width = 0;
	//  jump only n2 times
	//
	    for(int jump= (n1+2*pad)*(n2+2*pad)*k + ((n1+2*pad)*pad) + pad ; 
	    width     <       n2		                      ; 
	    jump = jump + ((n1) + 2*pad)     )
	    {
		for(int i=0;i<n1;i++)
		{
			//dest[jump + i ] = source[ (n1*n2*k) + idx*n1 + i ]; 
			// n1*n2 is size of smaller array 
            {
                 address1 = src_base + size * ((n1*n2*k) + idx*n1 + i);
                 address2 = dest_base + size * (jump + i);
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




            }
		}
		idx   = idx   + 1 ;
		width = width + 1 ;

	    }
        }
}










void zero_pad(Tensor *src, uint32_t scale_factor,Tensor *dest){
    int num = src->descriptor.number_of_dimensions;
    switch (num)
    {
        case 1:
            zero_pad_1d(src,scale_factor,dest);
            break;
        case 2:
            zero_pad_2d(src,scale_factor,dest);
            break;
        case 3:
            zero_pad_3d(src,scale_factor,dest);
            break;
        default:
            printf("ERROR! NUMBER OF DIMENSIONS NOT SUPPORTED.\n");
            exit(0);
    }
    
}

