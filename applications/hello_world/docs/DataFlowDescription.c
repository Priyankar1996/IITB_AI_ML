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
	one attached pool

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

