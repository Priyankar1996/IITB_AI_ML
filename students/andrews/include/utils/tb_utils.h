#ifndef TB_UTILS
#define TB_UTILS

#include "../../tensor.h" 
#include "../../../../docs/original_idea/students_implementations/createTensor/src/createTensor.c" 
#include <math.h>

#define MIN(a,b) (((a)<(b))?(a):(b))

// fills elements of tensor with 
// incremental data if offset != -1
// 0 if offset == -1
void fillTensorValues (Tensor* t,uint32_t num_elems, double offset, MemPoolRequest* req, MemPoolResponse* resp );

// prints 2 dimensional tensor 
// need to take care of datatype manually
void print2dTensor(Tensor* a, MemPoolRequest* req, MemPoolResponse* resp);

// #include "tb_utils.c"

#endif