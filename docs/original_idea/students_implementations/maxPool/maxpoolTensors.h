#include <stdio.h>
#include "../../Mempool/mempool.h"
#include "../../Mempool/tensor.h"

enum mode {floor,ceil};

extern void maxPoolOfTensors (Tensor *T, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);
