#include <stdio.h>
#include <assert.h>


// Returns the number of elements in the tensor T
uint32_t getSizeOfTensor(Tensor *T);

// Reads the tensor data into an array starting at address array
void fillArrayFromTensor(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array);

// Writes the data present at array into the tensor data
void fillTensorFromArray(Tensor *T, MemPoolRequest *req, MemPoolResponse *resp, int size, void *array);

// Computes the bitmask based on datatype and position in the word
// dsize can be 1(u8,i8,float8),2(u16,i16,float16),4(u32,i32,float32),8(u64,i64,float64)
// position lies between 0 and (8/dsize - 1), both boundaries included
// Assuming little endian architecture
uint64_t getBitMask(uint8_t dsize , uint8_t position);
