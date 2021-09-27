#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "copyTensor.h"
#include "createTensor.h"

#define npages 20

MemPool mp1,mp2;
Tensor src,dest;
int _err_ = 0;

void fillTensorDescriptor(Tensor t)
// Takes details from the user about the tensor to be created.
{
    int i,j;
    Tensor dummy;

    printf("Enter the data-type of the tensor:\n");
    printf("0. uint_8\t1. uint16_t\t2. uint32_t\t3. uint64_t\n");
    printf("4. int8_t\t5. int16_t\t6. int32_t\t7. int64_t\n");
    printf("8. float8\t8. float16\t9. float\t10. double\n");
    scanf("%u",&dummy.descriptor.data_type);
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
    t.descriptor.data_type = dummy.descriptor.data_type;
    t.descriptor.row_major_form = dummy.descriptor.row_major_form;
    t.descriptor.number_of_dimensions = dummy.descriptor.number_of_dimensions;
    for (j=0;j<dummy.descriptor.number_of_dimensions;j++)
    {
        t.descriptor.dimensions[j]=dummy.descriptor.dimensions[j];
    }
}

int main()
{
    uint64_t i=0,pages = 0;
    //initialize two mempools
    initMemPool(&mp1,1,npages);
    initMemPool(&mp2,2,npages);

    printf("SOURCE TENSOR\n");
    fillTensorDescriptor(src);
    printf("DESTINATION TENSOR\n");
    fillTensorDescriptor(dest);

    //copy to different mempool
    _err_ = createTensorAtHead(&src,&mp1) || createTensorAtHead(&dest,&mp2) || _err_;
    //copy to same mempool
    //_err_ = createTensorAtHead(&src,&mp1) || createTensorAtHead(&dest,&mp1) || _err_;

    _err_ = copyTensor(&src,&dest);

    printf("Source mempool buffer pointer : %d\n",src.mem_pool_buffer_pointer);
    printf("Destination mempool buffer pointer : %d\n",dest.mem_pool_buffer_pointer);

    if(_err_)
    {
        fprintf(stderr,"Error: EXITING.\n");
        return(1);
    }
    fprintf(stderr,"Info: DONE.\n");

    return(0);
}
