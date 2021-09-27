#ifndef _copyTensor_h____
#define _copyTensor_h____

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"

#define CEILING(x,y) (((x) + (y) - 1) / (y))
#define MIN(a,b) (((a)<(b))?(a):(b))

int copyTensor(Tensor *src, Tensor *dest);

#endif
