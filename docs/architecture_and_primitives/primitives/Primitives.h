// Initialization:
//

//
// Description of the dimensions
// 
typedef struct __TensorConfiguration {

} TensorConfiguration;

//
// Description of a tensor.
//
typedef struct __Tensor {
	TensorConfiguration config;
	TensorData data;
} Tensor;


   
// 1. Constant: Generate an n-dimensional tensor of a given shape with a constant number such as 0 or 1
//
// generates a tensor with constant values and
//
//      result is where the data will be updated.
//
//    First create the result tensor with empty data,
//    Pass the pointer to this function.
//    The function fills the data and returns.
//
void genConstantTensor (int value, Tensor* result);


// 2. Random: Generate an n-dimensional tensor of a given shape with pseudo random numbers
//    generates a tensor with pseudo-random values as elements.  
//
//
//    First create the result tensor with empty data,
//    Pass the pointer to this function.
//    The function fills the data and returns.
//
void genRandomTensor(int seed, RngType t, Tensor* result);

// 3. Input: Copy or take as input one n-dimensional tensor into another of identical shape
//
void copyTensorInMemory (Tensor* src, Tensor* dest);

// 2. Size and shape: For an tensor, compute its size along any dimension
int getTensorSizeAndShape (Tensor* tensor, int dim);

// 3. Slicing: Ability to select as input for another operation an n-m slice of an n-dimensional tensor
//       
void sliceTensorToPipe (Tensor* src, int ndims, int* n, Tensor* result);
//
// Crop?
// Squeeze?
// 

// 4. Zero padding: Extend the size of an n-dimensional tensor to each side by a factor of s, and populate the newly created locations with zeros.
//     Oversampling?
void zeroPadTensor(Tensor* src, int scale_factor, Tensor* result);

// 5. Mathematical functions that can be applied to a scalar:
   //1. Exp
   //2. Tanh
   //3. Cos
   //4. Square
   //5. Power
   //6. Absolute value
   //7. Hinge or ReLU ??

// 6. Point-wise functions: 
void unaryOperateOnTensor (Tensor* a, Operation op, Tensor* result);
void unaryLutOperateOnTensor (Tensor* a, LutPointer op, Tensor* result);
//   Point-wise binary functions.
void binaryOperatorOnTensor (Tensor* a, Tensor* b, Operation op, Tensor* result);
void binaryLutOperatorOnTensor (Tensor* a, Tensor* b, LutPointer op, Tensor* result);

// 7. Maxpool: Given a 2-dimensional tensor of nxm, create a 2d tensor of size (n/l)x(m/l) by selecting the maximum value from every non-overlapping region (patch) of lxl. 
void maxPoolOfTensors (Tensor* src, int l, Tensor* result);
//8. Scalar-tensor operations:
   //1. Scale: Multiply a scalar to all elements of a tensor.
   //2. Add: Add a scalar to all elements of a tensor.
void scalarOperator (Operator op, Scalar* s, Tensor* src, Tensor* result);
//9. Reduction:
   //1. Sum: Reduce an n-dimensional tensor to (n-1)-dimensional by adding elements along one dimension
   //2. Product: Reduce an n-dimensional tensor to (n-1)-dimensional by multiplying elements along one dimension
void reduceTensor (Operator op, Tensor* src, Tensor* result);
//10. Expansion: 
   //1. Replication: Using an n-dimensional tensor create (n+1)-dimensional tensor by replicating the original tensor along a new dimension.
void replicateTensor (int dim_id, Tensor* src, Tensor* result);
//2. Dilation: Expand the size of an n-dimensional tensor in one of its dimensions by inserting zeros between two consecutive indices.
void dilateTensor (int stride, Tensor* a, Tensor* result);
// 11. Concatenation: Take two n-dimensional tensors whose sizes can differ only in one dimension, and concatenate them into a new n-dimensional tensor joined by the only the dimension that is allowed to differ.
void concatTensors (Tensor* a, Tensor*  b, Tensor* result);
// 12. Convolution: Compute the result of convolution between an n-dimensional tensor and another n-dimensional tensor
void convolveTensors (int stride, Tensor* a, Tensor* b, Tensor* result);


