# Unary Operator

void unaryOperateOnTensor(Tensor* a, Operation op)

## Description: 
_inplace pointwise unary operator for tensors_\
input: tensor, operation | output: modified tensor\
The operator modifies the given Tensor a to the required output (for eg. sin(a), exp(a),... etc.)

## Support: 
5 mathematical functions namely SINE, EXP, RELU, ABSOLUTE and SQUARE are supported. \
Datatypes supported include: u8, u16, u32, u64, i8, i16, i32, i64, float32, float64. 

## Implementation:
The function consisted of 3 steps: 
- Reading a chunk of memory from the tensor's MemPool and storing it in locally defined array. 
- Applying the operation specifed in argument to the local array.
- Writing back the local array to the chunk of memory initially read from in the first step. (* as inplace operator)

The 3 steps mentioned above can be translated to 3 stages in a pipeline, which will be beneficial when going to HW model. 
A 3-staged pipeline (Fetch, Compute, Writeback) has been modelled in C for this function. This has been done by splitting the various stages in code. \
issue: pipelined execution in C model (which is sequential)

## Testing:
Tests can be performed by executing the file unary_tb.c. In this file, required datatype, operation and tensor description (number of dimensions and values of dimensions) can be specified as required. Values are filled in the tensor by fillTensorValues function. \
The output shown after an execution shows: 
- Values filled by the fillTensorValues function
- Total number of elements in tensor
- Number of double words (num_dwords_stored) and number of elements (num_in_chunk) in the memory chunk for every iteration
- Pass/Fail status for every element of tensor, alongwith expected result and output

## TODO:
float8 and float16 are not added yet \
More mathematical functions can be added [reccomendations needed] \
(tanh, power, hinge)

## Warning:
Datatypes limits and usage must be according to the standards set, otherwise may result in garbage values. \
For eg. Feeding -1 to a u8 datatype leads to 255 being stored, and may not yield the desired result. 
