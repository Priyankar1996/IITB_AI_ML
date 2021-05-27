#include "createTensor.h"

void fillTensorDescriptor(Tensor *t)
// Takes details from the user about the tensor to be created.
{
    TensorDescriptor td;
    td = t->descriptor;
    int i;
    printf("Enter the data-type of the tensor(0-10):\n");
    printf("0. uint_8\t1. uint16_t\t2. uint32_t\t3. uint64_t\n4. int8_t\t5. int16_t\t6. int32_t\t7. int64_t\n8. float16\t9. float\t10. double\n");
    scanf("%u",&td.data_type);
    printf("Enter:\t1.Row-Major form \t2.Column-Major form\n");
    scanf("%u",&td.row_major_form);
    if(td.row_major_form > 2 || td.row_major_form<1)
    {
        printf("ERROR!SELECT PROPER VALUES.\n");
        exit(0);
    }
    printf("Enter number of dimensions:");
    scanf("%u",&td.number_of_dimensions);
    if(td.number_of_dimensions > 64)
    {
        printf("ERROR! MAX DIMENSION PERMISSIBLE IS 64.");
        exit(0);
    }
    printf("Fill the dimensional array:");
    for (i=0;i<td.number_of_dimensions;i++)
    {
         scanf("%u",&td.dimensions[i]);
    }
}

void printTensorDescriptor(Tensor *t)
{
    TensorDescriptor td;
    td = t-> descriptor;
    uint8_t i;
    printf("=========================================TENSOR DESCRIPTOR=========================================\n");
    switch(td.data_type)
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
    switch(td.row_major_form)
    {
        case 1: printf("Row Major Form\n");
                break;
        case 2: printf("Column Major Form\n");
                break;
    }
    printf("Number of Dimensions:\t%u\n",td.number_of_dimensions);
    printf("Shape:\t(");
    for(i=0;i<(td.number_of_dimensions-1);i++)
    {
        printf("%u,",td.dimensions[i]);
    }
    printf("%u)",td.dimensions[td.number_of_dimensions-1]);   
    printf("\n===================================================================================================\n");
}

int createTensor(Tensor *t,MemPool *mp, MemPoolRequest *mp_req,MemPoolResponse *mp_resp)
{
    //1.Calculate number of pages required to store the tensor.
    uint16_t i,n_elements=1,n_pages;
    TensorDescriptor td;
    td= t->descriptor;
    t->mem_pool_identifier = mp->mem_pool_index;
    t->mem_pool_buffer_pointer = mp->write_pointer;
    for(i=0;i<td.number_of_dimensions;i++)
    {
        n_elements *= i;
    }
    n_pages = ceil((3+t->descriptor.number_of_dimensions+n_elements)/MEMPOOL_PAGE_SIZE);
    printf("%d",n_pages);
    //2.Allocate that many number of pages in the mempool.
    mp_req->request_type = ALLOCATE;
    mp_req->request_tag = mp->write_pointer;
    mp_req->arguments[0] = n_pages;
    // Should this arguement change to #pages when tensor uses more than 1 page to store data?

    memPoolAccess(mp, mp_req, mp_resp);

    if(mp_resp-> status != OK)
    {
        printf("ERROR! Couldn't allocate memory");
        return 1;
    }
    else
    {
        printf("Allocated %d pages for the tensor.",n_pages);
    }
    //3. Store tensorDescriptor in the memory-pool.
    mp_req->write_data[0] = td.data_type;
    mp_req->write_data[1] = td.row_major_form;
    mp_req->write_data[2] = td.number_of_dimensions;
    for(i=0;i<td.number_of_dimensions;i++)
    {
        mp_req->write_data[3+i] = td.dimensions[i];
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
    printf("Wrote TensorDescriptor into Mempool.\n");
    return 0;
}

