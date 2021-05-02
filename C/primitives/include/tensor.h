#ifndef __tensor_h___
#define __tensor_h___

#define MAX_DIMENSIONS 64;

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


typedef struct __Tensor{
	TensorDescriptor descriptor;

	// buffer identifier.
	uint16_t mem_pool_identifier;
	uint32_t mem_pool_buffer_pointer;

} Tensor;


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
uint32_t updateTensorArrayFromSection(
					TensorDescriptor* td, 
					void* tensor_data_array,
					uint32_t* indices_low, uint32_t* indices_high,
					void* section_data_array);


// start
void createTensor (uint32_t ndim, uint32_t* dims, TensorDataType dt, uint16_t mempool, Tensor* result);


#endif
