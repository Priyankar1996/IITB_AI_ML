Description:
	The function copies src tensor from mp_src to dest tensor in mp_dest.
1)The function assumes that a tensor src is allocated and initialized in some mem pool.
2)The function generates a read request of one/multiple word to src tensor.
3)Store the word in a local temporary buffer.
4)Generates write request of that temporary buffer to dest tensor.
