#include "../../../../C/mempool/include/mempool.h"//mempool.h
#include "../../../../C/primitives/include/tensor.h"
#include "../../../../C/primitives/src/tensor.c"
#include "../../../../C/mempool/src/mempool.c"

// max chunk size can be 1024 
#define CHUNK_SIZE      32 // in dwords --> (CHUNK_SIZE*8) bytes 

typedef enum {
	SINE, 
	EXP,
	RELU,
	SQUARE,
    ABSOLUTE
} Operation;