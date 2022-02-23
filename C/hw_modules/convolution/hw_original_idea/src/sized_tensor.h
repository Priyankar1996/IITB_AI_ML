#ifndef __tensor_h___
#define __tensor_h___

#define MAX_DIMENSIONS 64

typedef enum __TensorDataType {
	u8, u16, u32, u64,
	i8, i16, i32, i64,
	float8, float16, float32, float64
} TensorDataType;

typedef struct __TensorDescriptor {

	TensorDataType data_type;

	// data can be in row-major form
	// or column major form.
	//
	// row-major [0][0], [0][1] etc...
	// column-major [0][0], [1][0] etc...
	uint8_t row_major_form;

	uint32_t number_of_dimensions;
	uint32_t dimensions[MAX_DIMENSIONS];

} TensorDescriptor;

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

#define __NumberOfElementsInSizedTensor__(st) ({\
	int i, num_elems=1;\
	for (i=0;i<st.descriptor.descriptor.number_of_dimensions;i++)\
		num_elems *= st.descriptor.descriptor.dimensions[i];\
	num_elems;\
})

#define __sizeOfTensorDataInBytes__(st) ({\
	uint32_t ret_val =  0;\
	switch(st)\
	{\
		case u8:\
		case i8:\
		case float8:\
			ret_val = 1;\
			break;\
		case u16:\
		case i16:\
		case float16:\
			ret_val = 2;\
			break;\
		case u32:\
		case i32:\
		case float32:\
			ret_val = 4;\
			break;\
		case u64:\
		case i64:\
		case float64:\
			ret_val = 8;\
			break;\
		default:\
			break;\
	}\
	ret_val;\
	})

#define __GetTensorEntryIndexOffset__(st, indices) ({\
	int ret_value = 0,I,SCALE_FACTOR = 1;\
	int DSTART = (st.descriptor.descriptor.row_major_form ? (st.descriptor.descriptor.number_of_dimensions - 1) : 0);\
	int DEND   = (st.descriptor.descriptor.row_major_form ? 0 : (st.descriptor.descriptor.number_of_dimensions - 1));\
	int DINCREMENT = (st.descriptor.descriptor.row_major_form ? -1 : 1);\
	for (I = DSTART; I != DEND + DINCREMENT; I = I + DINCREMENT){\
		ret_value  +=  SCALE_FACTOR*indices[I];\
		SCALE_FACTOR*= (st.descriptor.descriptor.dimensions[I]);\
	}\
	ret_value;\
})
#endif
