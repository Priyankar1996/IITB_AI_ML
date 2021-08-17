//AUTHOR: 	DEEP SATRA
//          DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.

#define __genRandomTensor_h___

#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"

typedef enum {
	mersenne_Twister, // Used in python
	wichmann_Hill,
	philox,
	combRecursive,
	threefry,
	none
	
} RngType;


//    Random: Generate an n-dimensional tensor of a given shape with pseudo random numbers
//    generates a tensor with pseudo-random values as elements.  
//
//
//    First create the result tensor with empty data,
//    Pass the pointer to this function.
//    The function fills the data and returns.
//
void genRandomTensor(uint32_t seed, RngType t, Tensor* result);