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
// Tensor a[5],a_diff_pool[5];
Tensor a,a_diff_pool;
int _err_ = 0;

#define MAX_PAGES 20

void fillTensorDescriptor(Tensor *t)
// Takes details from the user about the tensor to be created.
{
    int i,j;Tensor dummy;
    
    printf("Enter the data-type of the tensor:\n");
    printf("0. uint_8\t1. uint16_t\t2. uint32_t\t3. uint64_t\n");
    printf("4. int8_t\t5. int16_t\t6. int32_t\t7. int64_t\n");
    printf("8. float8\t8. float16\t9. float\t10. double\n");
    scanf("%d",&dummy.descriptor.data_type);
    printf("Enter:\t0.Column-Major form \t1.Row-Major form\n");
    scanf("%u",&dummy.descriptor.row_major_form);
    if(dummy.descriptor.row_major_form > 1 || dummy.descriptor.row_major_form<0)
    {
        printf("ERROR!SELECT PROPER VALUES.\n");
        exit(0);
    }
    printf("Enter number of dimensions:");
    scanf("%u",&dummy.descriptor.number_of_dimensions);
    if(dummy.descriptor.number_of_dimensions > 64)
    {
        printf("ERROR! MAX DIMENSION PERMISSIBLE IS 64.");
        exit(0);
    }
    printf("Fill the dimensional array:");
    for (i=0;i<dummy.descriptor.number_of_dimensions;i++)
    {
         scanf("%u",&dummy.descriptor.dimensions[i]);
    }
    for(i=0;i<5;i++)
    {
        t[i].descriptor.data_type = dummy.descriptor.data_type;
        t[i].descriptor.row_major_form = dummy.descriptor.row_major_form;
        t[i].descriptor.number_of_dimensions = dummy.descriptor.number_of_dimensions;
        for (j=0;j<dummy.descriptor.number_of_dimensions;j++)
        {
            t[i].descriptor.dimensions[j]=dummy.descriptor.dimensions[j];
        }
    }
}

float sizeofsrc(Tensor *src)
{
    uint64_t i = 0;
    float size_src = 1.0;
    uint32_t ndim_src = src->descriptor.number_of_dimensions;
    uint32_t *dims_src;
    //dims_src = src->descriptor.dimensions;
    for(i=0;i<ndim_src;i++)
    {
        //printf("%d\n",*dims_src);
        size_src = size_src * (src->descriptor.dimensions[i]);
        //dims_src = dims_src + 1;
    }
    printf("Number of data blocks in src : %f\n",size_src);
    return size_src;
}

void print_Tensor(Tensor *t){
    MemPoolRequest req;
    req.request_tag = 0;
    MemPoolResponse resp;
    //number of blocks.
    float size_of_src;
    size_of_src = sizeofsrc(t);

    uint32_t npages,rem;
    uint32_t consta = 512.0;
    npages = ceil(size_of_src/512);

    //blocks required for last page.
    rem = (uint32_t) size_of_src % consta;
    //generate read req for one word at a time from src.
    //store it into temp_buffer.
    //generate write req for dest tensor.
    uint64_t src_base = t->mem_pool_buffer_pointer;
    uint64_t temp_buffer;
    uint32_t k;
    for(k=0; k < (npages-1)*MEMPOOL_PAGE_SIZE + rem; k++)
    {
        //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;

        //generate read request for src
        memPoolAccess((MemPool*)t->mem_pool_identifier, &req, &resp);

        //store into a temporary local buffer.
        
        printf("Temporary buffer value : %d",resp.read_data[0]);
        src_base++;
    }

}



int main(int argc,char* argv[])
{
    uint64_t i=0,pages = 0;
    initMemPool(&pool1,1,MAX_PAGES);
    initMemPool(&pool2,2,MAX_PAGES);

    fillTensorDescriptor(&a);
    // a.descriptor.data_type = 
    // fillTensorDescriptor(&a_diff_pool);
    uint32_t scale_factor,constant;
    printf("Enter the scale factor:");
    scanf("%u",&scale_factor);
    a_diff_pool.descriptor.data_type = a.descriptor.data_type;
    a_diff_pool.descriptor.row_major_form = a.descriptor.row_major_form;
    a_diff_pool.descriptor.number_of_dimensions = a.descriptor.number_of_dimensions;
    for (i=0;i<a.descriptor.number_of_dimensions;i++)
    {
        a_diff_pool.descriptor.dimensions[i] = a.descriptor.dimensions[i];
    }
    
    printf("Enter the constant to initialize the tensor:");
    scanf("%u",&constant);
    // while (i<5)
    // {
        _err_ = createTensorAtHead(&a,&pool1) || 
                createTensorAtHead(&a_diff_pool,&pool2) ||
                initializeTensor(&a_diff_pool,&constant) ||
                _err_;
        printf("%d",_err_);
        printf("\n Completed!!");  
        zeropad(&a,scale_factor,constant,&a_diff_pool);
        printf("\n ZeroPad Completed!!");
        print_Tensor(&a);
        print_Tensor(&a_diff_pool);
        printf("\n Print Completed!!");        
        // if(_err_)
        //   break;
	    // else
        //   i++;
    // } 
    
}