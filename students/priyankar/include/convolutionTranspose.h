#ifndef __convolutionTranspose_h___
#define __convolutionTranspose_h___

#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "mempool.h"
#include "tensor.h"
#include "createTensor.h"
#include "conv.h"


#define CEILING(x,y) (((x) + (y) - 1) / (y))


// ASSUMPTIONS:
//      1. offset has the input tensor's element location.
//      2. td_in has the input tensor's descriptor in it.
//      3. td_out has the output tensor's descriptor available in it.
//      4. k_dims stores the kernel's dimension.
//      5. stride is a convolutional parameter.
//      6. padding is a convolutional parameter.
// SUMMARY:
//      computeUpsampledInputLocation takes in the offset index of a particular 
//      elememt in the input tensor and computes the offset of that location in 
//      the dilated tensor.
// SIDE-EFFECTS:
//      N/A
// RETURN VALUES:
//      N/A
uint32_t computeDilatedTensorOffset(uint32_t offset, TensorDescriptor *td_in,
                                    TensorDescriptor *td_out, uint32_t *k_dims, 
                                    uint32_t *stride, uint32_t padding);


// ASSUMPTIONS:
//      1. input has the input tensor's description available in it.
//      2. kernel has the kernel tensor's decription available in it.
//      3. intermediate has the dilated tensor's description in it.
//      4. stride is a convolutional paramter.
//      5. padding contains the value of the number of rings to be
//         removed(integer value).
//      6. output_padding is a convolutional parameter.
//      7. output has the output tensor's descritption available in it.
// SUMMARY:
//      convTranspose performs tranpose-convolution on the input by dilating
//      the input followed by convolving it with the kernel.
// SIDE-EFFECTS:
//      Mempool is modified to indicate that it has allocated this data
//      to the tensor.
//      All the tensors are modified with the memory location to where 
//      it is allocated.
//      Values in the memory-pool are modified.
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int convTranspose(Tensor *input, Tensor *kernel, Tensor *intermediate, 
                  uint32_t *stride, uint32_t *output_padding, 
                  uint32_t padding,Tensor *output);

#endif

