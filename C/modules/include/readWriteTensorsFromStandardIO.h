//AUTHOR: PRIYANKAR SARKAR
//        DEPT. OF ELECTRICAL ENGINEERING, IIT-BOMBAY.
#ifndef _readWriteTensorsFromStandardIO_h____
#define _readWriteTensorsFromStandardIO_h____

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "mempool.h"
#include "tensor.h"


// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
//      2. filename is the name of the dataset's csv file.         
// SUMMARY:
//      Reads data from the csv file and writes them into the 
//      memory-pool.
// SIDE-EFFECTS:
//      Mempool is modified to indicate that it has allocated 
//      this data to the tensor.
//      Values in the memory pool are not modified.
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int readTensorFromFile(char *filename, Tensor *t, MemPool *mp);

// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
//      2. filename is the name of the csv-file where the 
//         resultant data will be stored.
// SUMMARY:
//      Reads a tensor from the memory-pool and writes them into
//      the csv file.
// SIDE-EFFECTS:
//      NA
// RETURN VALUES:
//      0 on Success, 1 on Failure.
int writeTensorToFile(char *filename, Tensor *t);
// Can we assume the writen Tensor into FILE will be data-labels only?
#endif