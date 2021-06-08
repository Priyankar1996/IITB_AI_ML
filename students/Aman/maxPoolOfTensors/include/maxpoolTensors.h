#include <stdio.h>
#include <assert.h>
#include "../../../Mempool/mempool.h"
#include "../../../Mempool/tensor.h"

enum mode {floor,ceil};

void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);

/*
Arguments:
	src                -> Input tensor
	dst                -> Output tensor
	l                  -> Length of pooling
	stride             -> Stride of pooling
	num_dims_to_pool   -> Number of dimensions to be pooled
	dims_to_pool       -> Array of actual dimensions to be pooled
	mode               -> Mode of operation (floor/ceiling)
*/

// The function takes an input tensor src, 
// performs num_dims_to_pool-D maxPooling along dimensions specified by dims_to_pool,
// with length = l and stride = stride
// and returns the resultant tensor as dst.