#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"
#include "zero_padding.h"

MemPool pool1,pool2;
Tensor a[5],a_diff_pool[5];
int _err_ = 0;

#define MAX_PAGES 20

void fillTensorDescriptor(Tensor t[])
// Takes details from the user about the tensor to be created.
{
    int i,j;Tensor dummy;
    
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





int main(int argc,char* argv[])
{
    uint64_t i=0,pages = 0;
    initMemPool(&pool1,1,MAX_PAGES);
    initMemPool(&pool2,2,MAX_PAGES);

    fillTensorDescriptor(a);
    fillTensorDescriptor(a_diff_pool);
    uint32_t scale_factor,constant;
    ptintf("Enter the scale factor:");
    scanf("%u",&scale_factor);
    ptintf("Enter the constant to initialize the tensor:");
    scanf("%u",&constant);
    while (i<5)
    {
        _err_ = createTensor(a+i,&pool1) || 
                createTensor(a_diff_pool+i,&pool2) ||
                initializeTensor(a_diff_pool,constant) ||
                _err_;
        
        _err_ = zeropad(a,scale_factor,constant,a_diff_pool) || _err_;

        
        if(_err_)
          break;
	    else
          i++;
    } 
    
}