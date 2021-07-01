#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"

MemPool pool1,pool2;
Tensor a,a_same_pool,a_diff_pool;
int _err_ = 0;

void fillTensorDescriptor(Tensor *t)
// Takes details from the user about the tensor to be created.
{
    int i;
    printf("Enter the data-type of the tensor:\n");
    printf("0. uint_8\t1. uint16_t\t2. uint32_t\t3. uint64_t\n");
    printf("4. int8_t\t5. int16_t\t6. int32_t\t7. int64_t\n");
    printf("8. float8\t8. float16\t9. float\t10. double\n");
    scanf("%u",&t->descriptor.data_type);
    printf("Enter:\t0.Column-Major form \t1.Row-Major form\n");
    scanf("%u",&t->descriptor.row_major_form);
    if(t->descriptor.row_major_form > 1 || t->descriptor.row_major_form<0)
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
    uint8_t i;TensorDataType tdt;
    tdt = t->descriptor.data_type;
    printf("=========================================TENSOR DESCRIPTOR=========================================\n");
    switch(t->descriptor.data_type)
    {
        case u8:    printf("\nDatatype:\tuint8_t\n");
                    break;
        case u16:   printf("\nDatatype:\tuint16_t\n");
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

void compareTensors(Tensor *a,Tensor *b,MemPool *mp_a,MemPool *mp_b)
{
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t i,j,num_elems=1;
    //Read a tensor from mempool into a read_buffer.
    uint32_t data_size = sizeofTensorDataInBytes(a->descriptor.data_type); 
    
    for(i=0;i<a->descriptor.number_of_dimensions;i++)
    {
        num_elems *= a->descriptor.dimensions[i];
    }
    uint32_t flag=1;
    int iter = -1;
    int words_left = CEILING(num_elems * data_size,8);

    for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
		iter ++;
        int elements_to_read = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        
        mp_req.request_type = READ;
        mp_req.arguments[0] = elements_to_read;
        mp_req.arguments[1] = a->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		mp_req.arguments[2] = 1;//stride

        memPoolAccess(mp_a, &mp_req, &mp_resp);
        uint64_t *a;
        a = mp_resp.read_data;

        mp_req.request_type = READ;
        mp_req.arguments[0] = elements_to_read;
        mp_req.arguments[1] = b->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		mp_req.arguments[2] = 1;//stride

        memPoolAccess(mp_b, &mp_req, &mp_resp);
        uint64_t *b;
        b = mp_resp.read_data;

        for (i = 0; i < 1024; i++)
        {
            if(a[i] != b[i])
                flag = flag * 0;
            else   
                flag = flag * 1;
        }
   
    }
    if(flag == 0)
        printf("SUCCESS: Tensors mismatched\n");
    else
        printf("SUCCESS: Tensors matched.\n");
}


int main(int argc,char* argv[])
{
    int i;
    initMemPool(&pool1,1,MAX_MEMPOOL_SIZE_IN_PAGES);
    initMemPool(&pool2,2,MAX_MEMPOOL_SIZE_IN_PAGES);

    fillTensorDescriptor(&a);
    printTensorDescriptor(&a);
    _err_ = createTensor(&a,&pool1)  ||  
            initializeTensor(&a,(float)3.14,&pool1)  ||  _err_;


    fillTensorDescriptor(&a_same_pool);
    printTensorDescriptor(&a_same_pool);
    _err_ = createTensor(&a_same_pool,&pool1)  ||  _err_;


    fillTensorDescriptor(&a_diff_pool);
    printTensorDescriptor(&a_diff_pool);
    _err_ = createTensor(&a_diff_pool,&pool2) || _err_;
    
    _err_ = copyTensor(&a,&a_same_pool,&pool1,&pool1) ||
            copyTensor(&a,&a_diff_pool,&pool1,&pool2) || _err_;

    compareTensors(&a,&a_same_pool,&pool1,&pool1);
    compareTensors(&a,&a_diff_pool,&pool1,&pool2);
    
    _err_ = destroyTensor(&a,&pool1) ||
            destroyTensor(&a_same_pool,&pool1) || 
            destroyTensor(&a_diff_pool,&pool2) || _err_;

    if(_err_)
		  fprintf(stderr,"FAILURE.\n");
	  else
		  fprintf(stderr,"SUCCESS.\n");

	return(_err_);
}