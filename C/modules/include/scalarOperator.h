//AUTHOR: PRAKHAR DIWAN
//         DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.
#ifndef _scalarOperator_h____
#define _scalarOperator_h____

#include <stdint.h>
#include "mempool.h"//mempool.h
#include "tensor.h" //tensor.h

// Maximum allowed chunk size is 1024 
#define CHUNK_SIZE      32 // in dwords --> (CHUNK_SIZE*8) bytes 

// Description of available Operation types
typedef enum {
	ADD, 
	MULT
} Operator;

// Datatypes supported include: u8, u16, u32, u64, i8, i16, i32, i64, float32, float64.
// 3-stages have been separately shown as an attempt to demonstrate pipelining in hardware model.

// ASSUMPTIONS:
//      1. The memory space for tensor in a mempool is contiguously allocated
//      2. Appropriate datatypes are used as per the input data.
// 		3. The input tensor and output tensor datatypes are same by default 
// 		4. The scalar value used matches the tensor data type appropriately 
// SUMMARY:
//      scalarOperator performs point-wise add/mult operation with given scalar value on the input src Tensor
//		and writes the result to result Tensor
// SIDE-EFFECTS:
//      MemPools of src and dest should be non-overlapping else will lead to issues
// RETURN VALUES:
void scalarOperator(Operator op, void* s, Tensor* src, Tensor* result);
void scalarOperator_inplace(Operator op, void* s, Tensor* src);

// Helper Functions
uint8_t add_scale_uint8(uint8_t x_8ui,Operator op,uint8_t s_8ui);
uint16_t add_scale_uint16(uint16_t x_16ui,Operator op,uint16_t s_16ui);
uint32_t add_scale_uint32(uint32_t x_32ui,Operator op,uint32_t s_32ui);
uint64_t add_scale_uint64(uint64_t x_64ui,Operator op,uint64_t s_64ui);
int8_t add_scale_int8(int8_t x_8i,Operator op,int8_t s_8i);
int16_t add_scale_int16(int16_t x_16i,Operator op,int16_t s_16i);
int32_t add_scale_int32(int32_t x_32i,Operator op,int32_t s_32i);
int64_t add_scale_int64(int64_t x_64i,Operator op,int64_t s_64i);
float add_scale_f32(float x_32f,Operator op,float s_32f);
double add_scale_f64(double x_64f,Operator op,double s_64f);
#endif
