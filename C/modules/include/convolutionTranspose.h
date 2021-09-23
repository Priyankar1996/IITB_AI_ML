//AUTHORS: PRIYANKAR SARKAR, NAYAN BARHATE, DEVAL PATEL.
//         DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.

#ifndef __convolutionTranspose_h___
#define __convolutionTranspose_h___

#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "mempool.h"
#include "tensor.h"

#define MIN(a,b) (((a)<(b))?(a):(b))
#define CEILING(x,y) (((x) + (y) - 1) / (y))


// ASSUMPTIONS:
//      1. input has the input tensor's description available in it.
//      2. kernel has the kernel tensor's decription available in it.
//      3. stride is a convolutional paramter.
//      4. output has the output tensor's descritption available in it.
// SUMMARY:
//      Dilatetensor dilates the input tensor such that the kernel placed
//      on the top-left corner of the input tensor has atleast one element
//      of the Tensor in it.
// SIDE-EFFECTS:
//      N/A
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int dilateTensor(Tensor *input, Tensor *kernel, uint32_t *stride, Tensor *output);

// ASSUMPTIONS:
//      1. input has the input tensor's description available in it.
//      2. padding contains the value of the number of rings to be
//         removed(integer value).
//      3. output_padding is a convolutional parameter.
//      4. output has the output tensor's descritption available in it.
// SUMMARY:
//      DePad tensor removes the provided number of outer rings from
//      input tensor.
// SIDE-EFFECTS:
//      N/A
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int dePadTensor(Tensor *input, uint32_t padding, Tensor *output);

#endif

