#ifndef _testCreateTensor_h____
#define _testCreateTensor_h____

// Sequence of tests performed are:
// 1. 3 tensors are created, 2 of them stored in the same
//    pool and 1 is in the other one.
// 2. 1 of the two tensors in the same mempool is initialised.
// 3. Values of the initialised tensor are copied into the 
//    remaining two and is compared.


// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
// SUMMARY:
//      Fills the tensor descriptor with user inputs.
// SIDE-EFFECTS:
//      Modifies the tensor.
// RETURN VALUE:
//      No return value.
void fillTensorDescriptor(Tensor *t);

// ASSUMPTIONS:
//      1. t has the tensor's description available in it.
// SUMMARY:
//      Prints the tensor descriptor.
// SIDE-EFFECTS:
//      No side effects.
// RETURN VALUE:
//      No return value.
void printTensorDescriptor(Tensor *t);

//ASSUMPTIONS:
//      1. a has the tensor's description available in it.
//      2. b has the tensor's description available in it.
//      3. mp_a is a pointer to the mempool where tensor a
//         is stored.
//      4. mp_b is a pointer to the mempool where tensor b
//         is stored.
//SUMMARY:
//      Compares the values of the tensors.
//SIDE-EFFECTS:
//      No side effects.
//RETURN VALUE:
//      No return value.
void compareTensors(Tensor *a,Tensor *b,MemPool *mp_a,MemPool *mp_b);

#endif
