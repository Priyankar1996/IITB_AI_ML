#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "../../../../../C/mempool/include/mempool.h"
#include "../../../../../C/primitives/include/tensor.h"

#define NPAGES 8

MemPool 	pool;
MemPoolRequest 	req;
MemPoolResponse resp;

Tensor *a;
Tensor *b;

int _err_ = 0;

int main(int argc,char* argv[])
{
    
    initMemPool(&pool,1,NPAGES);

    fillTensorDescriptor(a);
    fillTensorDescriptor(b);

    printTensorDescriptor(a);
    printTensorDescriptor(b);
    
    _err_ = createTensor(a,&pool,&req,&resp) || _err_;
    _err_ = createTensor(b,&pool,&req,&resp) || _err_;
    if(_err_)
		fprintf(stderr,"FAILURE.\n");
	else
		fprintf(stderr,"SUCCESS.\n");

	return(_err_);
}