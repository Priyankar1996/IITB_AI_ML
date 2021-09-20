#ifndef _zeropadtensor_h___
#define _zeropadtensor_h___

// The function "zeropadtensor" creates a new tensor for zero padding 
// It creates it from the src tensor by reading and then writing the 
// destination tensor according to scale factor provded. 

// Create tensor functon: Creates a new tensor for zero padding


// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
//      2. mp is the pointer to mempool to be used by createTensor.
// SUMMARY:
//      createTensoratHead allocates spaces for the tensor from the specified
//      mempool at head.
// SIDE-EFFECTS:
//      Mempool is modified to indicate that it has allocated this data
//      to the tensor.
//      Tensor *t is modified with the memory location to where
//      it is allocated.
//      Values in the memory pool are not modified.
// ARGUEMENTS:
//      t :- t is the tensor to be created.
//     mp :- mp is the mempool in which the tensor will be created
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int createTensor(Tensor *t,MemPool *mp);



// ASSUMPTIONS:
//      1. td has the tensor descriptor already available in it.
//      2. indices is the location of the element to be found in the tensor
//         are already avilable.
// SUMMARY:
//      Given a tensor descriptor, get the index of the
//      byte/half-word/word/double-word
//      element in the single-dimensional array in which
//      the tensor data is stored
// SIDE-EFFECTS:
//      NA
// ARGUEMENTS:
//      td :- gives the tensor descriptor available of the tensor.
//      indices :- location of the element to be found in the tensor.
// RETURN VALUES:
//      The calculated location of the index relative to the first element
//      based in the ROW/COLUMN major format, in the format of 32 bit integer.
uint32_t getTensorEntryIndexOffset(TensorDescriptor *td, uint32_t *indices);




// ASSUMPTIONS:
//      1. mp is the pointer to mempool to be used by createTensor.    
// SUMMARY:
//      Initializes the mempool with the index and number of pages
// SIDE-EFFECTS:
//      Mempool is modified to indicate that it has allocated this data
//      to the tensor.
//      Values in the mempool are modified
// ARGUEMENTS:
//      mp :- It is the mempool pointer
//      mem_pool_index :- assigns the mempool its index according to the user
//      mem_pool_size_in_pages :- Number of pages for the mempool declaration are provided 
//                                here
// RETURN VALUES:
//      NA
void initMemPool(MemPool* mp, uint32_t mem_pool_index, uint32_t mem_pool_size_in_pages);
 


// ASSUMPTIONS:
//      1. t has the tensor descriptor already available in it.
// SUMMARY:
//      Describe the tensor
//      About data type, number of dimensions,
//      Row or column major, dimensions sizes
// SIDE-EFFECTS:
//      Describes the details about the tensor that are stored in the 
//      tensor descriptor.
// ARGUEMENTS:
//      t :- gives the location to the tensor currently accessed
// RETURN VALUES:
//      NA
void fillTensorDescriptor(Tensor t[]);




// ASSUMPTIONS:
//      1. source (src) tensor is already declared with its description
//      2. destination (dest) tensor is already declared taking into scale factor into account
//         , with its description.
// SUMMARY:
//      Zero padding of the tensor : Adds outer layer of constant (mostly 0) to the pre-existing 
//      src tensor to create the dest tensor, in all dimensions 
// SIDE-EFFECTS:
//      The data stored in the destination tensor is changes according to the src and the 
//      constant as well as the scale factor bby which we want to pad the src tensor
// ARGUEMENTS:
//      scr :- pointer to the source tensor
//      scale_factor :- The factor of layer which is added to each dimension for zero padding
//      constant :- The constant which is to be added for the zero-padding (generally 0) , but can be 
//                  changed by mentioning as the constant to be added in place of zero
//      dest :- pointer to the destination tensor
// RETURN VALUES:
//      NA
void zeropad(Tensor* src, uint32_t scale_factor, uint32_t constant, Tensor* dest);


#endif