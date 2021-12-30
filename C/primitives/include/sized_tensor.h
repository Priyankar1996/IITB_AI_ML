#ifndef __tensor_h___
#define __tensor_h___
typedef struct __SizedTensorDescriptor {
	TensorDescriptor descriptor;
	uint32_t tensor_size;
} SizedTensorDescriptor;


typedef struct __SizedTensor_512 {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[512];
} SizedTensor_512;
typedef struct __SizedTensor_1K {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[1024];
} SizedTensor_1024;
typedef struct __SizedTensor_4K {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[4096];
} SizedTensor_4096;
typedef struct __SizedTensor_16K {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[4096 * 4];
} SizedTensor_16K;
typedef struct __SizedTensor_256K {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[1024 * 256];
} SizedTensor_256K;
typedef struct __SizedTensor_1M {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[1024 * 1024];
} SizedTensor_1M;
typedef struct __SizedTensor_4M {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[4*1024 * 1024];
} SizedTensor_4M;
typedef struct __SizedTensor_8M {
	SizedTensorDescriptor descriptor;
	uint64_t data_array[8*1024 * 1024];
} SizedTensor_8M;

#define __SizedTensorDescriptor__(st) 	(st.descriptor.descriptor)
#define __SizedTensorSize__(st) 	(st.descriptor.tensor_size)

#endif
