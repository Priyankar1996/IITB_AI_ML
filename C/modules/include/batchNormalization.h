//AUTHORS: PRIYANKAR SARKAR, AMAN DHAMMANI.
//         DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.

#ifndef _batchNormalization_h____
#define _batchNormalization_h____

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"

// ASSUMPTIONS:
//      1. input has the input tensor's description available in it.
//      2. beta has the parameter beta tensor's description available in it.
//      3. gamma has the parameter gamma tensor's decsription avaiable in it.
//      4. moving_mean has the parameter moving_mean tensor's decsription avaiable in it.
//      5. moving_variance has the parameter moving_variance tensor's description available in it.
// SUMMARY:
//      batchNormalization normalizes the data obtained from a hidden layer.Its job is to take the 
//      outputs from the first hidden layer and normalize them before passing them on as the input 
//      of the next hidden layer.
//      Formula for batch-normalization is:
//                  gamma * {x - moving_mean/sqrt(moving_variance + epsilon)} + beta
// SIDE-EFFECTS:
//      MemPool is modified to indicate that it has allocated the parameters.
// ARGUEMENTS:
//      input : input is the input tensor to be normalized.
//      beta: beta is a trainable parameter.(bias)
//      gamma: gamma is a trainable parameter.(weight)
//      moving_mean: moving_mean is a non-trainable parameter.
//      moving_variance: moving_variance is a non-trainable parameter.
//      epsilon : epsilon is a constant value.

void batchNormalization(Tensor *input, Tensor *beta, Tensor *gamma, 
						Tensor *moving_mean, Tensor *moving_variance, double epsilon);
#endif