#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"

void fillTensorDescriptor(Tensor *t)
// Takes details from the user about the tensor to be created.
{
    int i;
    printf("Enter the data-type of the tensor(0-10):\n");
    printf("0. uint_8\t1. uint16_t\t2. uint32_t\t3. uint64_t\n4. int8_t\t5. int16_t\t6. int32_t\t7. int64_t\n8. float16\t9. float\t10. double\n");
    scanf("%u",&t->descriptor.data_type);
    printf("Enter:\t1.Row-Major form \t2.Column-Major form\n");
    scanf("%u",&t->descriptor.row_major_form);
    if(t->descriptor.row_major_form > 2 || t->descriptor.row_major_form<1)
    {
        printf("ERROR!SELECT PROPER VALUES.\n");
        exit(0);
    }
    printf("Enter number of dimensions:");
    scanf("%u",&t->descriptor.number_of_dimensions);
    if(t->descriptor.number_of_dimensions > 64)
    {
        printf("ERROR! MAX DIMENSION PERMISSIBLE IS 64.");
        exit(0);
    }
    printf("Fill the dimensional array:");
    for (i=0;i<t->descriptor.number_of_dimensions;i++)
    {
         scanf("%u",&t->descriptor.dimensions[i]);
    }
}

void printTensorDescriptor(Tensor *t)
{
    uint8_t i;
    printf("=========================================TENSOR DESCRIPTOR=========================================\n");
    switch(t->descriptor.data_type)
    {
        case u8:    printf("Datatype:\tuint8_t\n");
                    break;
        case u16:   printf("Datatype:\tuint16_t\n");
                    break;
        case u32:   printf("Datatype:\tuint32_t\n");
                    break;
        case u64:   printf("Datatype:\tuint64_t\n");
                    break;
        case i8:    printf("Datatype:\tint8_t\n");
                    break;
        case i16:   printf("Datatype:\tint16_t\n");
                    break;
        case i32:   printf("Datatype:\tint32_t\n");
                    break; 
        case i64:   printf("Datatype:\tint64_t\n");
                    break;
        case float16:printf("Datatype:\tfloat16\n");
                    break;
        case float32:printf("Datatype:\tfloat\n");
                    break;
        case float64:printf("Datatype:\tdouble\n");
                    break;
    }
    printf("Ordering Format :\t");
    switch(t->descriptor.row_major_form)
    {
        case 1: printf("Row Major Form\n");
                break;
        case 2: printf("Column Major Form\n");
                break;
    }
    printf("Number of Dimensions:\t%u\n",t->descriptor.number_of_dimensions);
    printf("Shape:\t(");
    for(i=0;i<(t->descriptor.number_of_dimensions-1);i++)
    {
        printf("%u,",t->descriptor.dimensions[i]);
    }
    printf("%u)",t->descriptor.dimensions[t->descriptor.number_of_dimensions-1]);   
    printf("\n===================================================================================================\n");
}

int createTensor(Tensor *t,MemPool *mp, MemPoolRequest *mp_req,MemPoolResponse *mp_resp)
{
    //1.Calculate number of pages required to store the tensor.
    uint16_t i,n_elements=1,n_pages;
    t->mem_pool_identifier = mp->mem_pool_index;
    t->mem_pool_buffer_pointer = mp->write_pointer;
    for(i=0;i<t->descriptor.number_of_dimensions;i++)
    {
        n_elements *= t->descriptor.dimensions[i];
    }
    n_pages = (uint16_t)((3+t->descriptor.number_of_dimensions+n_elements)/MEMPOOL_PAGE_SIZE);
    uint16_t x = (3+t->descriptor.number_of_dimensions+n_elements) % MEMPOOL_PAGE_SIZE;
    
    if((3+t->descriptor.number_of_dimensions+n_elements) % MEMPOOL_PAGE_SIZE > 0)
        n_pages++ ;
        
    //2.Allocate that many number of pages in the mempool.
    mp_req->request_type = ALLOCATE;
    mp_req->request_tag = mp->write_pointer;
    mp_req->arguments[0] = n_pages;

    memPoolAccess(mp, mp_req, mp_resp);

    if(mp_resp-> status != OK)
    {
        printf("ERROR! Couldn't allocate memory.\n");
        return(1);
    }
    else
    {
        printf("Allocated %d pages for the tensor.\n",n_pages);
        printf("Allocated base address is %d,%d\n",mp_resp->allocated_base_address,t->mem_pool_buffer_pointer);
        //3. Store tensorDescriptor in the memory-pool.
        mp_req->write_data[0] = t->descriptor.data_type;
        mp_req->write_data[1] = t->descriptor.row_major_form;
        mp_req->write_data[2] = t->descriptor.number_of_dimensions;
        for(i=0;i<t->descriptor.number_of_dimensions;i++)
        {
            mp_req->write_data[3+i] = t->descriptor.dimensions[i];
        }
        mp_req->request_type = WRITE;
        mp_req->request_tag = n_pages;
        mp_req->arguments[0] = MEMPOOL_PAGE_SIZE;
	    mp_req->arguments[1] = mp_resp->allocated_base_address;

        memPoolAccess(mp, mp_req, mp_resp);
        if(mp_resp->status !=  OK)
	    {
	    	printf("Error: could not write into memory.\n");
		    return(1);
	    }
        else
        {
            printf("Wrote TensorDescriptor into Mempool.\n");
            return(0);
        }
    }
}