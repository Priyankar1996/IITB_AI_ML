# Utils File
unary_tb.c is testbench used for verification of unaryOperateOnTensor function. 
It defines a new function fillTensorValues(Tensor* t,uint32_t num_elems, double offset), which is used for filling the values in the tensor. It assigns contiguous integer values from offset to (num_elems+offset) (exclusive), i.e. all integers in range [offset, num_elems+offset). 
There were minor changes in createTensor function which were performed. 