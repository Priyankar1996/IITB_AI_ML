// Core function

// The function takes an input tensor src, 
// performs num_dims_to_pool-D maxPooling along dimensions specified by dims_to_pool,
// with length = l and stride = stride
// and returns the resultant tensor as dst.
void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);

// Other auxiliary functions

// Returns the number of elements in the tensor T
uint32_t getSizeOfTensor(Tensor *T);

// Computes the bitmask based on datatype and position in the word
// dsize can be 1(u8,i8,float8),2(u16,i16,float16),4(u32,i32,float32),8(u64,i64,float64)
// position lies between 0 and (8/dsize - 1), both boundaries included
//Verify this statement // 0 returns the MSB,
uint64_t getBitMask(uint8_t dsize , uint8_t position);
 
 // Computes the max of num_max elements of data present at matrix of datatype dt,
// starting at index start,
// and stores the result at location temp
void maxWithSpacing(int num_max, int start, void* matrix,  TensorDataType dt, void * temp);

// Computes the 1-D maxPool of tensor src, based on the parameters size,x,l,s,cs,mode
// and stores the resultant tensor as dst
void maxpool1D(Tensor *src, uint32_t size, uint32_t x, int l, int s, int cs, Tensor *dst, int mode);