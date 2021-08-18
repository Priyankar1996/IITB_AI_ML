#ifndef _copyTensorInMemory_h____
#define _copyTensorInMemory_h____

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"

int copyTensorInMemory(Tensor *src, Tensor *dest);

#endif
