#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "../include/tensor.h"
#include <assert.h>

uint32_t sizeofTensorDataInBytes(TensorDataType t)
{
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

uint32_t numberOfElementsInTensor(Tensor *t)
{
	int i;
	uint32_t num_elems = 1;
	for(i=0;i<t->descriptor.number_of_dimensions;i++)
		num_elems *= t->descriptor.dimensions[i];
	return num_elems;
}

void copyCoordinateVector (int ndim, uint32_t* vec, uint32_t* init_val)
{
	int I;
	for(I = 0; I < ndim; I++)
		vec[I] = init_val[I];
}

void incrementCoordinateVector (int ndim, uint32_t* dims, uint32_t* vec, uint8_t row_major_form)
{
	int Istart, Iend, deltaI;
	Istart = (row_major_form ?  ndim - 1 : 0);
	Iend   = (ndim - 1) - Istart;
	deltaI = (row_major_form ? -1 : 1);

	int I;
	int CARRY = 0;
	for(I = Istart; I != Iend; I += deltaI)
	{
		if((vec[I] + CARRY) == dims[I])
		{
			vec[I] = 0;
			CARRY = 1;
		}
		else
		{
			vec[I] += 1;
			CARRY = 0;
		}
	}
}

uint32_t areCoordinateVectorsEqual(int ndim, uint32_t* a, uint32_t* b)
{
	int I;
	uint32_t ret_val = 1;
	for(I = 0; I < ndim; I++)
	{
		if(a[I] != b[I])
		{
			ret_val = 0;
			break;
		}
	}
	return(ret_val);
}


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
uint32_t getTensorEntryIndexOffset(TensorDescriptor* td, uint32_t* indices)
{
	uint32_t ret_value = 0,I;
	//
	// in row major form, the tensor id's are listed
	// as [0,0], [0,1], [0,2] --> [0,D2-1] -> [1,0] ...
	//   
	// in column major form 
	//    [0,0] [1,0] .... [D1-1,0] [0,1] ....
	//
	// 3d row major form...
	//  000 001 002  ... 00D3-1 010 011 ....
	//
	int DSTART, DEND, DINCREMENT;
	DSTART = (td->row_major_form ? (td->number_of_dimensions - 1) : 0);
	DEND   = (td->row_major_form ? 0 : (td->number_of_dimensions - 1));
	DINCREMENT = (td->row_major_form ? -1 : 1);

	uint32_t SCALE_FACTOR = 1;
	for(I = DSTART; I != DEND + DINCREMENT; I = I + DINCREMENT)
	{
		ret_value  +=  SCALE_FACTOR*indices[I];
		SCALE_FACTOR*= (td->dimensions[I]);
	}
	return(ret_value);
}


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
					void* section_data_array)
{
	uint32_t IVECTOR[MAX_DIMENSIONS];
	

	copyCoordinateVector(td->number_of_dimensions, IVECTOR, indices_low);
	uint32_t destination_index = 0;
	while(1)
	{
		uint32_t source_index = getTensorEntryIndexOffset(td, IVECTOR);
		copyTensorEntry(td, section_data_array, destination_index, 
					tensor_data_array, source_index);

		if(areCoordinateVectorsEqual(td->number_of_dimensions, IVECTOR, indices_high))
			break;

		destination_index++;
		incrementCoordinateVector(td->number_of_dimensions, td->dimensions, IVECTOR, td->row_major_form);
	}

	return(0);
}


uint32_t updateTensorArrayFromSection(TensorDescriptor* td, 
					void* tensor_data_array,
					uint32_t* indices_low, uint32_t* indices_high,
					void* section_data_array)
{
	uint32_t IVECTOR[MAX_DIMENSIONS];
	
	copyCoordinateVector(td->number_of_dimensions, IVECTOR, indices_low);
	uint32_t source_index = 0;
	while(1)
	{
		uint32_t destination_index = getTensorEntryIndexOffset(td, IVECTOR);
		copyTensorEntry(td, tensor_data_array, destination_index, 
					section_data_array, source_index);
		
		incrementCoordinateVector(td->number_of_dimensions, td->dimensions, IVECTOR, td->row_major_form);
		source_index++;

		if(areCoordinateVectorsEqual(td->number_of_dimensions, IVECTOR, indices_high))
			break;

	}
	
	return(0);
}

void copyTensorEntry(TensorDescriptor* td,
				void* dest_byte_array, int dest_index,
				void* src_byte_array, int src_index)
{
	uint32_t dsize = sizeofTensorDataInBytes(td->data_type);
	
	switch(dsize)
	{
		case 1: 
			*(((uint8_t*)dest_byte_array) + dest_index) = *(((uint8_t*)src_byte_array) + src_index);
			break;
		case 2: 
			*(((uint16_t*)dest_byte_array) + dest_index) = *(((uint16_t*)src_byte_array) + src_index);
			break;
		case 4: 
			*(((uint32_t*)dest_byte_array) + dest_index) = *(((uint32_t*)src_byte_array) + src_index);
			break;
		case 8: 
			*(((uint64_t*)dest_byte_array) + dest_index) = *(((uint64_t*)src_byte_array) + src_index);
			break;
		default:
			assert(0);
	}
}


