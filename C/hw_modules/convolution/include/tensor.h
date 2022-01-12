#ifndef __tensor_h___
#define __tensor_h___

#define MAX_DIMENSIONS 64

typedef enum __TensorDataType {
	u8, u16, u32, u64,
	i8, i16, i32, i64,
	float8, float16, float32, float64
} TensorDataType;

typedef struct __TensorDescriptor {

	// one data type is enough?
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

uint32_t sizeofTensorDataInBytes(TensorDataType t){
	uint32_t ret_val =  0;
	switch(t)
	{
		case u8:
		case i8:
		case float8:
			ret_val = 1;
			break;
		case u16:
		case i16:
		case float16:
			ret_val = 2;
			break;
		case u32:
		case i32:
		case float32:
			ret_val = 4;
			break;
		case u64:
		case i64:
		case float64:
			ret_val = 8;
			break;
		default:
			break;
	}
	return(ret_val);
}


typedef struct __Tensor{
	TensorDescriptor descriptor;

	// buffer identifier.
	uintptr_t mem_pool_identifier;
	uint32_t  mem_pool_buffer_pointer;

} Tensor;

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

uint32_t numberOfElementsInTensor(Tensor *t);

//
// Given a tensor descriptor, get the index of the
//     byte/half-word/word/double-word
// element in the single-dimensional array in which
// the tensor data is stored.
//
// Specify the index vector  of the element
//    e.g. [2][13][79]
// and get the offset in the array at which you
// can find this element.
//
uint32_t getTensorEntryIndexOffset(TensorDescriptor* td, uint32_t* indices);

//
// Extract the values
//    [3:5][9:9][11:11]
// from the tensor data array and
// store them in section array.
//
uint32_t extractSectionFromTensor(
					TensorDescriptor* td,
					void* tensor_data_array,
					uint32_t* indices_low, uint32_t* indices_high,
					void* section_data_array);
uint32_t updateTensorArrayFromSection( TensorDescriptor* td,
					void* tensor_data_array,
					uint32_t* indices_low, uint32_t* indices_high,
					void* section_data_array);
void copyTensorEntry(TensorDescriptor* td,
				void* dest_byte_array, int dest_index,
				void* src_byte_array, int src_index);

// To be implemented... manipulation of coordinate index vectors.
void copyCoordinateVector (int ndim, uint32_t* vec, uint32_t* init_val);

// vec[] is incremented, using limits in dims.
void incrementCoordinateVector (int ndim, uint32_t* dims, uint32_t* vec, uint8_t row_major_form);
uint32_t areCoordinateVectorsEqual(int ndim, uint32_t* a, uint32_t* b);



#endif
