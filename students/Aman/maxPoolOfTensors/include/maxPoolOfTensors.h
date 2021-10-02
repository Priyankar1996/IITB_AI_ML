// AUTHOR : Aman Dhammani
// Dept. Of Eelctrical Engineering, IITB

#ifndef __maxPoolOfTensors_h__
#define __maxPoolOfTensors_h__

// ASSUMPTIONS:
//      1. All assumptions encapsulated in those of maxPoolOfTensors()
// SUMMARY:
//      Performs num_dims_to_pool-D maxPooling along dimensions specified by dims_to_pool
// 		with length = l and stride = stride
// SIDE-EFFECTS:
//      Updates mempool locations corresponding to dst
// ARGUEMENTS:
//      Tensor *src			: Pointer to source tensor
//		Tensor *dst			: Output tensor pointer, can be same as input
//		int l				: Length of pooling
//		int stride			: Stride for pooling
//		int num_dims_to_pool: Number of dimensions to pool
//		int * dims_to_pool	: Array storing the actual dimensions to pool
//		int mode			: Mode (0 = floor, 1 = ceiling)
// RETURN VALUES:
//      NULL
void maxPoolOfTensors (Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);

// Other auxiliary functions


// ASSUMPTIONS:
//      1. Tensor T's descriptor should be filled
// SUMMARY:
//      Returns the number of elements in the tensor
// SIDE-EFFECTS:
//      None
// ARGUEMENTS:
//      Tensor* T : Pointer to T
// RETURN VALUES:
//      The number of elements in the tensor
uint32_t getSizeOfTensor(Tensor *T);


void updateOutputSizeMaxPoolOfTensors(Tensor *src, Tensor *dst, int l, int stride, int num_dims_to_pool,int * dims_to_pool, int mode);

// ASSUMPTIONS:
//      1. The system where compilation is done has a Little Endian architecture
// SUMMARY:
//      Returns a bitmask with the bits specified by the position and datatype are high
// SIDE-EFFECTS:
//      None
// ARGUEMENTS:
//      uint8_t dsize   : Size in bytes of the datatype used (1,2,4,8)
//      uint8_t position: Position in the word (0 means LSB)
// RETURN VALUES:
//      A 64bit unsigned integer that serves as bitmask
uint64_t getBitMask(uint8_t dsize , uint8_t position);
 
// ASSUMPTIONS:
//      1. The data is spaced 64 bit apart in inp_tensor
// SUMMARY:
//      Returns the maximum of num_max elements in array starting at inp_address
// SIDE-EFFECTS:
//      Updates value stored at address 'temp'
// ARGUEMENTS:
//      int num_max        : Number of elements on which max has to be done
//      void* inp_address  : The start address of the set of inputs
//      TensorDataType dt  : Datatype of values
//      void * temp        : The address where the output is to be stored 
// RETURN VALUES:
//      NULL
void maxOperation(int num_max, void* inp_address,  TensorDataType dt, void * temp);

// ASSUMPTIONS:
//      1. All assumptions encapsulated in those of maxPoolOfTensors()
// SUMMARY:
//      Performs 1-dimensional pooling on src, and stores the result on dst
// SIDE-EFFECTS:
//      Updates mempool locations corresponding to dst
// ARGUEMENTS:
//      Tensor *src		: Pointer to source tensor
//		uint32_t size	: Size of source tensor
//		uint32_t x		: Length of dimension to pool
//		int l			: Length of pooling
//		int s			: Stride for pooling
//		int cs			: Continuous section - i.e. no. of elements in unrolled lower dimensions
//		Tensor *dst		: Output tensor pointer, can be same as input
//		int mode		: Mode (0 = floor, 1 = ceiling)
// RETURN VALUES:
//      NULL
void maxpool1D(Tensor *src, uint32_t size, uint32_t x, int l, int s, int cs, Tensor *dst, int mode);

#endif