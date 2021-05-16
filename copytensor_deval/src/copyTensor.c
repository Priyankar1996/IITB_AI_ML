#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "mempool.h"

#define TENSOR_SIZE 512

typedef struct __Tensor {
	uint32_t tnsr[TENSOR_SIZE];
} Tensor;

Tensor a;
Tensor b;

void fillTensor(Tensor *src)
{
    register int LOOP = 0;
    for(LOOP = 0; LOOP < TENSOR_SIZE; LOOP++)
	{
		src->tnsr[LOOP] = LOOP + 1;
		printf("%d \t",src->tnsr[LOOP]);
	}
}

void copyTensor(Tensor *src, Tensor *dest)
{
	register int LOOP = 0;
    memcpy(&dest, &src, sizeof(src));
	for(LOOP = 0; LOOP < TENSOR_SIZE; LOOP++)
	{
		//dest->tnsr[LOOP] = src->tnsr[LOOP];
		printf("%d \t",dest->tnsr[LOOP]);
	}
}

void main()
{
	fillTensor(&a);
	printf("\n");
	copyTensor(&a,&b);
}
