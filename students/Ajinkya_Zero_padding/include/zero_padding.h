#ifndef _zeropadtensor_h___
#define _zeropadtensor_h___

// The function "zeropadtensor" creates a new tensor for zero padding 
// It creates it from the src tensor by reading and then writing the 
// destination tensor according to scale factor provded. 

// Create tensor functon: Creates a new tensor for zero padding
int createTensor(Tensor *t,MemPool *mp, MemPoolRequest *mp_req,MemPoolResponse *mp_resp);

// Given a tensor descriptor, get the index of the
// byte/half-word/word/double-word
// element in the single-dimensional array in which
// the tensor data is stored
uint32_t getTensorEntryIndexOffset(TensorDescriptor *td, uint32_t *indices);

// Fills a tensor with a user defined value at each element
void getConstantTensor(int value, Tensor* result);

// Gets the of data
uint32_t sizeofTensorDataInBytes(TensorDataType t);

// Copy data from src to zero padded tensor
void copyTensorEntry(TensorDescriptor* td,void* dest_byte_array, int dest_index, void* src_byte_array, int src_index);


// Used for zero padding
void zeropadtensor(Tensor* src, uint32_t scale_factor, uint32_t constant, Tensor* result);


#endif