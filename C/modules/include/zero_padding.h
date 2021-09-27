// AUTHOR :- AJINKYA RAGHUWANSHI
//           DEPARTMENT OF ELECTRICAL ENGINEERING, IITB

#ifndef _zeropadtensor_h___
#define _zeropadtensor_h___

// The function "zeropadtensor" creates a new tensor for zero padding 
// It creates it from the src tensor by reading and then writing the 
// destination tensor according to scale factor provded. 

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
