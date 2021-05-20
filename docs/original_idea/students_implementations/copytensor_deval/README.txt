-----void CopyTensor(Tensor *src, Tensor *dest, MemPool *mp)-----

Description:
	The function copies src to dest in mempool mp.
1)The function assumes that a tensor src is allocated and initialized in some mem pool.
2)The function takes src and it will create a tensor dest in mem pool mp.
3)Then copy the contents of src to dest.
