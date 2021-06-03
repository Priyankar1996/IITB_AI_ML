#ifndef _createTensor_h____
#define _createTensor_h____
// The function "createTensor" helps in allocating spaces to tensors in mempool.
// It starts with storing the "TensorDescriptor" in the mempool followed an empty
// space in mempool required to fill in the tensor.


void fillTensorDescriptor(Tensor *t);
//This method Takes input from user about the tensor's decription.
void printTensorDescriptor(Tensor *t);
// Prints the tensor descriptor.
int createTensor(Tensor *t,MemPool *mp, MemPoolRequest *mp_req,MemPoolResponse *mp_resp);
// Allocate spaces in the mempool for the tensor according to the description provided.
// Returns '0' if operation is successful, else '1'.

#endif