#ifndef _unary_inplace_fn_h____
#define _unary_inplace_fn_h____
#include <stdint.h>
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
    ABSOLUTE,
	SIGMOID
} Operation;

// Datatypes supported include: u8, u16, u32, u64, i8, i16, i32, i64, float32, float64.
// 3-stages have been separately shown as an attempt to demonstrate pipelining in hardware model.

// ASSUMPTIONS:
//      1. The memory space for tensor in a mempool is contiguously allocated
//      2. Appropriate datatypes are used as per the input data. 
//  	3. The input tensor and output tensor datatypes are same by default 
// SUMMARY:
//      unaryOperateOnTensor performs unary operation on the given Tensor t
//	and writes the result back to same Tensor t. 
// SIDE-EFFECTS:
//      1. Using unsuitable datatype may lead to wrong results (for eg: unsigned type isn't capable for sigmoid, so in that case function returns back the element itself)
// RETURN VALUES:
//      NULL
void unaryOperateOnTensor_inplace(Tensor* t, Operation op);

// Helper Functions
uint8_t operate_uint8(uint8_t val, Operation op);
uint16_t operate_uint16(uint16_t val, Operation op);
uint32_t operate_uint32(uint32_t val, Operation op);
uint64_t operate_uint64(uint64_t val, Operation op);
int8_t operate_int8(int8_t val, Operation op);
int16_t operate_int16(int16_t val, Operation op);
int32_t operate_int32(int32_t val, Operation op);
int64_t operate_int64(int64_t val, Operation op);
float operate_f32(float val, Operation op);
double operate_f64(double val, Operation op);
#endif
