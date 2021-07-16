#ifndef _unary_inplace_fn_h____
#define _unary_inplace_fn_h____

#include "../../../../C/mempool/include/mempool.h"//mempool.h
#include "../../../../C/primitives/include/tensor.h"
#include "../../../../C/primitives/src/tensor.c"
#include "../../../../C/mempool/src/mempool.c"

// Maximum allowed chunk size is 1024 
#define CHUNK_SIZE      32 // in dwords --> (CHUNK_SIZE*8) bytes 

typedef enum {
	SINE, 
	EXP,
	RELU,
	SQUARE,
    ABSOLUTE
} Operation;

// Datatypes supported include: u8, u16, u32, u64, i8, i16, i32, i64, float32, float64.
// 3-stages have been separately shown as an attempt to demonstrate pipelining in hardware model.

// ASSUMPTIONS:
//      1. The memory space for tensor in a mempool is contiguously allocated
//      2. Appropriate datatypes are used as per the input data. 
// SUMMARY:
//      unaryOperateOnTensor performs unary operation on the given Tensor t
//		and writes the result back to same Tensor t. 
// SIDE-EFFECTS:
//      NULL
// RETURN VALUES:
//      NULL
void unaryOperateOnTensor_inplace(Tensor* t, Operation op);

#endif