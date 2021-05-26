#ifndef createTensor_h
#define createTensor_h

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "../../../../../C/mempool/include/mempool.h"
#include "../../../../../C/primitives/include/tensor.h"

void fillTensorDescriptor(Tensor *t);
void printTensorDescriptor(Tensor *t);
int createTensor(Tensor *t,MemPool *mp, MemPoolRequest *mp_req,MemPoolResponse *mp_resp);

#endif
