//AUTHORS: PRIYANKAR SARKAR, NAYAN BARHATE, DEVAL PATEL.
//         DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.
#ifndef _createTensor_h____
#define _createTensor_h____

#define MIN(a,b) (((a)<(b))?(a):(b))
#define CEILING(x,y) (((x) + (y) - 1) / (y))

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"

// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
//      2. mp is the pointer to mempool to be used by createTensor.
// SUMMARY:
//      createTensor allocates spaces for the tensor from the specified
//      mempool.
// SIDE-EFFECTS:
//      Mempool is modified to indicate that it has allocated this data
//      to the tensor.
//      Tensor *t is modified with the memory location to where
//      it is allocated.
//      Values in the memory pool are not modified.
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int createTensor(Tensor *t,MemPool *mp);

// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
// SUMMARY:
//      destroyTensor deallocates the pages containing the tensor  
//      from the specified mempool in a FIFO manner.
// SIDE-EFFECTS:
//      Mempool is modified to indicate increment in number of
//      available free pages.
//      Values in the memory pool are modified.
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int destroyTensor(Tensor *t);


// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
//      2. initial_value is the pointer to the initial value to be
//	   stored in the tensor.     
// SUMMARY:
//      initializeTensor fills up the memory allocated to the tensor
//      with an initial value.
// SIDE-EFFECTS:
//      Mempool is modified to indicate a write operation on it.
//      Values in the memory pool are modified.
// RETURN VALUES:
//       0 on Success, 1 on Failure.
int initializeTensor(Tensor *t,void* initial_value);


// ASSUMPTIONS:
//      1. src has the source tensor's description available in it.
//      2. dest has the destination tensor's description available 
//         in it.
// SUMMARY:
//      copyTensor reads data from src tensor and writes them 
//      to dest tensor.
// SIDE-EFFECTS:
//      The dest mempool is modified indicating a write operation.
//      Values in the dest mempool are modified.
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int copyTensor(Tensor *src, Tensor *dest);

#endif
