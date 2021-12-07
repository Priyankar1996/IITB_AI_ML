    //Create and initialize mempools.
    int num_pools = 1;
    int num_pools_k = 1;
    int num_pools_r = 1;
    
    MemPool pool[num_pools];
    for (int i = 0; i < num_pools; i++)
        initMemPool(pool+i,i+1,MAX_MEMPOOL_SIZE_IN_PAGES);

    MemPool kernel_pool[num_pools_k];
    for (int i = 0; i < num_pools_k; i++)
        initMemPool(kernel_pool+i,num_pools+i+1,MAX_MEMPOOL_SIZE_IN_PAGES);
    
    MemPool r_pool[num_pools_r];
    for (int i = 0; i < num_pools_r; i++)
        initMemPool(r_pool+i,num_pools+num_pools_k+i+1,MAX_MEMPOOL_SIZE_IN_PAGES);


----------------------------------------------------------------------
Action 1:
	input fifo from outside world
	attached to a single pool..

	output fifos to two actions.

	read descriptor from input file
	create tensor in pool

        pass descriptor to first and second output arcs.
-------------------------------------------------------------------------
	action 1 will be attached to mempool 1.

	input fifo of action  will be mapped to some input fifo in the
	system.

-------------------------------------------------------------------------
Action 2: (iteration 0)
	input fifo from outside world.
	output fifos to two actions.

	read descriptor from input file
	create tensor in pool

        pass descriptor to first and second output arcs.

	Comment: action 2 is a copy of action 1.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 3:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 4: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 5: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 6:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 7:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 8:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 9:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 10:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 11:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 12:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 13:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	reads descriptors for R
	figures out output tensor descriptor for maxPool
	creates tensor for T in attached pool
			
	send T descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 14:
	input fifo 
	attached to a single pool..

	output fifos to one action.

	read descriptor from input 
	create tensor in pool

        pass descriptor to 15th arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 15:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	performs maxPoolOperation on tensors.

		writes the output to a file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 16: (iteration 1)
	input fifo from outside world.
	output fifos to two actions.

	read descriptor from input file
	create tensor in pool

        pass descriptor to first and second output arcs.

	Comment: action 2 is a copy of action 1.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 17:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 18: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 19: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 20:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 21:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 22:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 23:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 24:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 25:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 26:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 27:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	reads descriptors for R
	figures out output tensor descriptor for maxPool
	creates tensor for T in attached pool
			
	send T descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 28:
	input fifo 
	attached to a single pool..

	output fifos to one action.

	read descriptor from input 
	create tensor in pool

        pass descriptor to 15th arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 29:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	performs maxPoolOperation on tensors.

		writes the output to a file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 30: (iteration 2)
	input fifo from outside world.
	output fifos to two actions.

	read descriptor from input file
	create tensor in pool

        pass descriptor to first and second output arcs.

	Comment: action 2 is a copy of action 1.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 31:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 32: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 33: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 34:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 35:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 36:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 37:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 38:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 39:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 40:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 41:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	reads descriptors for R
	figures out output tensor descriptor for maxPool
	creates tensor for T in attached pool
			
	send T descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 42:
	input fifo 
	attached to a single pool..

	output fifos to one action.

	read descriptor from input 
	create tensor in pool

        pass descriptor to 15th arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 43:
	five input fifos.
		four from external world
	one output fifo.
	one attached pool.

	performs maxPoolOperation on tensors.

		writes the output to a file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 44:
	input fifo 
	attached to a single pool..

	output fifos to one action.

	read descriptor from input 
	create tensor in kernel pool.

        pass descriptor to 45th arc.
--------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 45:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 46: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 47:
	one input fifo,
	one pool attached.
	
	It will destroy the tensor T.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 48:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 49:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 50:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 51:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 52nd output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 52:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 53:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-------------------------------------------------------------------------
Action 54:
	input fifo 
	attached to a single pool..

	output fifos to one action.

	read descriptor from input 
	create tensor in kernel pool.

        pass descriptor to 55th arc.
--------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 55:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 56: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 57:
	one input fifo,
	one pool attached.
	
	It will destroy the tensor T.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 58: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 59:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 60:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 64th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 61:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 64th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 62:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 64th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 63:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 64th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 64:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 65:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends T to the decoding stage.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 66:
Read Kernel from file
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 67:
Obtain the size of the tensor descriptor of input
and kernel and create the dilated tensor.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 68:
perform dilation operation on the tensor with input,
kernel and stride value. Write the tensor to a file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 69:
Destroy the input tensor to the dilation operation.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 69:
Obtain the size of the tensor descriptor for depadding
the tensor and create the depadded tensor.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 70:
Perform depad operation on the tensor with pad values and
tensor as input, write the tensor to a file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 71:
Destroy the input tensor to the depad operation.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 72:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 73: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 74: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 75:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 76: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 77: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 78:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 79:
	two input fifo.
	one attached pool.
	one output fifo.

	Updates the shape of the tensor descriptor for
	concatenating two tensors and creates the tensor too.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 80:
	three input fifo.
	one attached pool.
	one output fifo.

	concats the two tensors along a particular dimension
	and obtains the output tensor.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 81:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor S from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 82:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 83: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 84: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 85:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 86:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 87:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 88:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 89:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 90:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 91:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 92:
	One input fifo.
	One attached tensor.

	Destroys the kernel tensor.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 93:
	One input fifo.
	One attached tensor.

	Destroys the input tensor to unary operation.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 94:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 95: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 96: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 97:  
	two input fifos.
	one output fifo.
	one attached pool.

	reads descriptors for T and K,
	figures out output tensor descriptor for convolution
	creates tensort for S in attached pool
			
	send S descriptor to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 98: 
	three input fifos.
	three mempools attached.
	one output fifo

	it will get three descriptors Td, Kd, Sd
	convolve to produce S.
	destroy K, 

	send Sd to output fifo.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 99: 
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor K from mempool.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 100:
	one input fifo
	one attached pool.

	reads descriptor for K.

	destroys tensor T from mempool.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 101:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(beta)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 102:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(gamma)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

----------------------------------------------------------------------
Action 103:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_mean)
	create tensor in pool

        pass descriptor to 11th output arcs.
------------------------------------------------------------------------

------------------------------------------------------------------------
Action 104:
	input fifo from outside world
	attached to a single pool..

	output fifos to one action.

	read descriptor from input file(moving_variance)
	create tensor in pool

        pass descriptor to 11th output arcs.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 105:
	five input fifos.
	two attached pool.
	one output fifo.

	reads the descriptors of the tensors created from
	action 7 to 10 and action 4.  

	performs batch_normalization on tensors.

	pass descriptor to the next arc.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 106:
	two input fifos one from external world.
	one attached pool.
	one output fifo.

	obtains the descriptor of the input tensor,
	performs unary operation based on the input
	obtained from the external world.

	Sends R to the output file.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 107:
	One input fifo.
	One attached pool.

	Destroy the kernel tensor.
-------------------------------------------------------------------------

-------------------------------------------------------------------------
Action 108:
	One input fifo.
	One attached pool.

	Write the output tensor to a file. This is the final
	output containing the generated image.
-------------------------------------------------------------------------