// Core function

// The function takes an input tensor src, 
// performs num_dims_to_pool-D maxPooling along dimensions specified by dims_to_pool,
// with length = l and stride = stride
// and returns the resultant tensor as dst.
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
//      1. Tensor T's descriptor should be filled
// SUMMARY:
//      Returns the number of elements in the tensor
// SIDE-EFFECTS:
//      None
// ARGUEMENTS:
//      int num_max        : number of elements on which max has to be done
//      int start          : start_index of 
//      void* matrix       :
//      TensorDataType dt  :
//      void * temp        :
// RETURN VALUES:
//      The number of elements in the tensor
void max(int num_max, void* inp_address,  TensorDataType dt, void * temp);

// Computes the 1-D maxPool of tensor src, based on the parameters size,x,l,s,cs,mode
// and stores the resultant tensor as dst
void maxpool1D(Tensor *src, uint32_t size, uint32_t x, int l, int s, int cs, Tensor *dst, int mode);