//AUTHOR: PRAKHAR DIWAN
//         DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.
#ifndef _unary_fn_h____
#define _unary_fn_h____

#include <stdint.h>
#include "mempool.h"//mempool.h
#include "tensor.h"

// Maximum allowed chunk size is 1024 
#define CHUNK_SIZE      32 // in dwords --> (CHUNK_SIZE*8) bytes 

// Description of available Operation types
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
// 		3. The input tensor and output tensor datatypes are same by default 
// SUMMARY:
//      unaryOperateOnTensor performs unary operation on the given src Tensor
//		and writes the result to dest Tensor
// SIDE-EFFECTS:
//      MemPools of src and dest should be non-overlapping else will lead to issues
// RETURN VALUES:
//      NULL
void unaryOperateOnTensor(Tensor* src,Tensor* dest, Operation op);
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
