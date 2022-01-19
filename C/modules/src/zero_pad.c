// AUTHOR :- AJINKYA RAGHUWANSHI,
//          DEPARTMENT OF ELECTRICAL ENGINEERING, IITB

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"
#include "zero_pad.h"
#include "inttypes.h"

MemPool pool_temp;
// Pre-defining the tensor for future operations
Tensor temp;
// Creating a variable in order to detect error
int _err_ = 0;

#define MAX_PAGES 1024


void zero_pad_3d(Tensor *src, uint32_t scale_factor, Tensor *dest)
{
     initMemPool(&pool_temp,2,MAX_PAGES);
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
    uint64_t temp_buffer;
    // uint32_t k;

    //store the base address of dest tensor.
    uint32_t dest_base = dest->mem_pool_buffer_pointer;
    dest_base = mp_resp.allocated_base_address;
    dest->mem_pool_buffer_pointer = mp_resp.allocated_base_address;

    uint32_t address1, address2;
    uint32_t temp_address;



    temp.descriptor.data_type = dest->descriptor.data_type;
    temp.descriptor.row_major_form = dest->descriptor.row_major_form;
    temp.descriptor.number_of_dimensions = dest->descriptor.number_of_dimensions;
    for (int i=0;i<dest->descriptor.number_of_dimensions;i++)
    {
        temp.descriptor.dimensions[i] = dest->descriptor.dimensions[i];
    }
	
    uint32_t temp_size = temp.descriptor.data_type;
    uint32_t temp_base = temp.mem_pool_buffer_pointer;
    temp_base = mp_resp.allocated_base_address;
    temp.mem_pool_buffer_pointer = mp_resp.allocated_base_address;
	//Exit function if there is any error
    _err_ = createTensorAtHead(&temp,&pool_temp) + _err_;
	if(_err_ != 0){
		fprintf(stderr, "ERROR : Create tensor failed at temparary\n");
		exit(1);
	}

    _err_ = initializeTensor(&temp,&pool_temp) + _err_;
    if(_err_ != 0){
        fprintf(stderr, "ERROR : Initialize tensor failed\n");
        exit(1);
    }

    int idx   = 0;
	int width = 0;
	//  
	//
	for(int i=0
	   ;    i<n1 
	   ;    i++)
	{
		for(int j=0
		   ;    j<n2
		   ;    j++ )
		{
			for(int k=0;k<n3;k++)
			{
				//dest[(n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))]
				//	=source[k+n3*j+n2*n3*i];

                {
<<<<<<< HEAD
                 address1 = ( 1) * (k+n3*j+n2*n3*i);
                 temp_address = (1) * ((n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad)));
=======
                 address1 = (size + 1) * (k+n3*j+n2*n3*i);
                 temp_address = (size + 1) * ((n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad)));
>>>>>>> 95ccc8fecbba7d15c2bd7e014cefd800044f6b11
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
        printf("%"PRIu64"\n",temp_buffer);
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        mp_req.request_type = WRITE;
        mp_req.request_tag = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = temp_base + temp_address;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", temp_base + temp_address);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", temp_base + temp_address);




            }

			}
		}
	}
	// dest2 defined below dest 	
	// padding code uptill now remains same 
	// new code added here
	// use dest matrix/array here 
	int index=0;
	int jump_matrix = (n1+2*pad)*(n2+2*pad); // this is used in for loop 
	int row_jump    = (n1+2*pad);            // dummy vars for understanding 
	int column_jump = (n2+2*pad);            // dummy vars for understanding 
	
	printf("the r,g,b printed with column traversal of matrix :-->\n");	
        for(int i=0;i<n1+2*pad;i++)
	{
		for(int j=0;j<n2+2*pad;j++)
		{
			for(int k=0;k<n3;k++)
			{
			    //dest2[index] = dest[ k*jump_matrix +  j*(n1+2*pad) + i ]; // 
		            //printf("%d ",dest2[index]);
			    //index = index + 1 ;
			    // here dest2 will contain the required output in sequential form 
                
                 {
<<<<<<< HEAD
                 temp_address = (1) * (k*jump_matrix +  j*(n1+2*pad) + i );
                 address2 = ( 1) * (index);
=======
                 temp_address = (size + 1) * (k*jump_matrix +  j*(n1+2*pad) + i );
                 address2 = (size + 1) * (index);
>>>>>>> 95ccc8fecbba7d15c2bd7e014cefd800044f6b11
                 index = index + 1 ;
                /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = temp_base + temp_address;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", temp_base + temp_address);
        }
        //fprintf(stderr,"\nInfo: read from block %d.\n", temp_base + temp_address);

        //store into a temporary local buffer.
        temp_buffer = mp_resp.read_data[0];
        printf("%"PRIu64"\n",temp_buffer);
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
        //fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);




            }



			}
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
    uint32_t temp_address;



    temp.descriptor.data_type = dest->descriptor.data_type;
    temp.descriptor.row_major_form = dest->descriptor.row_major_form;
    temp.descriptor.number_of_dimensions = dest->descriptor.number_of_dimensions;
    for (int i=0;i<dest->descriptor.number_of_dimensions;i++)
    {
        temp.descriptor.dimensions[i] = dest->descriptor.dimensions[i];
    }
	
    uint32_t temp_size = temp.descriptor.data_type;
    uint32_t temp_base = temp.mem_pool_buffer_pointer;
    temp_base = mp_resp.allocated_base_address;
    temp.mem_pool_buffer_pointer = mp_resp.allocated_base_address;
	//Exit function if there is any error
    _err_ = createTensorAtHead(&temp,&pool_temp) + _err_;
	if(_err_ != 0){
		fprintf(stderr, "ERROR : Create tensor failed\n");
		exit(1);
	}

    _err_ = initializeTensor(&temp,&pool_temp) + _err_;
    if(_err_ != 0){
        fprintf(stderr, "ERROR : Initialize tensor failed\n");
        exit(1);
    }

    int idx   = 0;
	int width = 0;
	//  
	//
	for(int i=0
	   ;    i<n1 
	   ;    i++)
	{
		for(int j=0
		   ;    j<n2
		   ;    j++ )
		{
			for(int k=0;k<n3;k++)
			{
				//dest[(n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))]
				//	=source[k+n3*j+n2*n3*i];

                {
                 address1 = (size + 1) * (k+n3*j+n2*n3*i);
                 temp_address = (size + 1) * ((n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad)));
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
        mp_req.arguments[1] = temp_base + temp_address;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", temp_base + temp_address);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", temp_base + temp_address);




            }

			}
		}
	}
	// dest2 defined below dest 	
	// padding code uptill now remains same 
	// new code added here
	// use dest matrix/array here 
	int index=0;
	int jump_matrix = (n1+2*pad)*(n2+2*pad); // this is used in for loop 
	int row_jump    = (n1+2*pad);            // dummy vars for understanding 
	int column_jump = (n2+2*pad);            // dummy vars for understanding 
	
	printf("the r,g,b printed with column traversal of matrix :-->\n");	
        for(int i=0;i<n1+2*pad;i++)
	{
		for(int j=0;j<n2+2*pad;j++)
		{
			for(int k=0;k<n3;k++)
			{
			    //dest2[index] = dest[ k*jump_matrix +  j*(n1+2*pad) + i ]; // 
		            //printf("%d ",dest2[index]);
			    //index = index + 1 ;
			    // here dest2 will contain the required output in sequential form 
                
                 {
                 temp_address = (size + 1) * (k*jump_matrix +  j*(n1+2*pad) + i );
                 address2 = (size + 1) * (index);
                 index = index + 1 ;
                /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = temp_base + temp_address;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", temp_base + temp_address);
        }
        //fprintf(stderr,"\nInfo: read from block %d.\n", temp_base + temp_address);

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
        //fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);




            }



			}
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
    uint32_t temp_address;



    temp.descriptor.data_type = dest->descriptor.data_type;
    temp.descriptor.row_major_form = dest->descriptor.row_major_form;
    temp.descriptor.number_of_dimensions = dest->descriptor.number_of_dimensions;
    for (int i=0;i<dest->descriptor.number_of_dimensions;i++)
    {
        temp.descriptor.dimensions[i] = dest->descriptor.dimensions[i];
    }
	
    uint32_t temp_size = temp.descriptor.data_type;
    uint32_t temp_base = temp.mem_pool_buffer_pointer;
    temp_base = mp_resp.allocated_base_address;
    temp.mem_pool_buffer_pointer = mp_resp.allocated_base_address;
	//Exit function if there is any error
    _err_ = createTensorAtHead(&temp,&pool_temp) + _err_;
	if(_err_ != 0){
		fprintf(stderr, "ERROR : Create tensor failed\n");
		exit(1);
	}

    _err_ = initializeTensor(&temp,&pool_temp) + _err_;
    if(_err_ != 0){
        fprintf(stderr, "ERROR : Initialize tensor failed\n");
        exit(1);
    }

    int idx   = 0;
	int width = 0;
	//  
	//
	for(int i=0
	   ;    i<n1 
	   ;    i++)
	{
		for(int j=0
		   ;    j<n2
		   ;    j++ )
		{
			for(int k=0;k<n3;k++)
			{
				//dest[(n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad))]
				//	=source[k+n3*j+n2*n3*i];

                {
                 address1 = (size + 1) * (k+n3*j+n2*n3*i);
                 temp_address = (size + 1) * ((n1+2*pad+pad)+i+j*(n1+2*pad)+(k*(n1+2*pad)*(n2+2*pad)));
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
        mp_req.arguments[1] = temp_base + temp_address;
        mp_req.write_data[0] = temp_buffer;

        //generate write mp_req for dest.
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", temp_base + temp_address);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", temp_base + temp_address);




            }

			}
		}
	}
	// dest2 defined below dest 	
	// padding code uptill now remains same 
	// new code added here
	// use dest matrix/array here 
	int index=0;
	int jump_matrix = (n1+2*pad)*(n2+2*pad); // this is used in for loop 
	int row_jump    = (n1+2*pad);            // dummy vars for understanding 
	int column_jump = (n2+2*pad);            // dummy vars for understanding 
	
	printf("the r,g,b printed with column traversal of matrix :-->\n");	
        for(int i=0;i<n1+2*pad;i++)
	{
		for(int j=0;j<n2+2*pad;j++)
		{
			for(int k=0;k<n3;k++)
			{
			    //dest2[index] = dest[ k*jump_matrix +  j*(n1+2*pad) + i ]; // 
		            //printf("%d ",dest2[index]);
			    //index = index + 1 ;
			    // here dest2 will contain the required output in sequential form 
                
                 {
                 temp_address = (size + 1) * (k*jump_matrix +  j*(n1+2*pad) + i );
                 address2 = (size + 1) * (index);
                 index = index + 1 ;
                /////////////////////////////////////////////
            //read one word at a time from src tensor
        mp_req.request_type = READ;
        mp_req.request_tag  = mp_req.request_tag + 1;
        mp_req.arguments[0] = 1;
        mp_req.arguments[1] = temp_base + temp_address;
        //printf("mp_req arguments[1] is %d",mp_req.arguments[1]);

        //generate read request for src
        memPoolAccess((MemPool*)temp.mem_pool_identifier, &mp_req, &mp_resp);
        if(mp_resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", temp_base + temp_address);
        }
        //fprintf(stderr,"\nInfo: read from block %d.\n", temp_base + temp_address);

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
        //fprintf(stderr,"\nInfo: wrote into block %d.\n", dest_base + address2);




            }



			}
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

