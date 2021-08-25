#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "mempool.h"
#include "tensor.h"

enum mode {floor,ceil};

// Core function

// The function takes an input tensor src, 
// performs num_dims_to_pool-D maxPooling along dimensions specified by dims_to_pool,
// with length = l and stride = stride
// and returns the resultant tensor as dst.
void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);

// Other auxiliary functions

// Returns the number of elements in the tensor T
uint32_t getSizeOfTensor(Tensor *T);

// Computes the max of num_max elements of data present at matrix of datatype dt,
// starting at index start,
// and stores the result at location temp
void maxWithSpacing(int num_max, int start, void* matrix,  TensorDataType dt, void * temp,int pos);

// Computes the 1-D maxPool of tensor src, based on the parameters size,x,l,s,cs,mode
// and stores the resultant tensor as dst
void maxpool1D(Tensor *src, uint32_t size, uint32_t x, int l, int s, int cs, Tensor *dst, int mode);