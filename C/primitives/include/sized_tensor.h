#ifndef __tensor_h___
#define __tensor_h___

typedef struct __SizedTensor_512 {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[512];
} SizedTensor_512;
typedef struct __SizedTensor_1K {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[1024];
} SizedTensor_1024;
typedef struct __SizedTensor_4K {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[4096];
} SizedTensor_4096;
typedef struct __SizedTensor_16K {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[4096 * 4];
} SizedTensor_16K;
typedef struct __SizedTensor_256K {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[1024 * 256];
} SizedTensor_256K;
typedef struct __SizedTensor_1M {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[1024 * 1024];
} SizedTensor_1M;
typedef struct __SizedTensor_4M {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[4*1024 * 1024];
} SizedTensor_4M;
typedef struct __SizedTensor_8M {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
	uint64_t data_array[8*1024 * 1024];
} SizedTensor_8M;

// TODO: inits for all these types.
#endif
