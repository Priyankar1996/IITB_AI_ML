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
	uint32_t ret_value = 0;
	//
	// in row major form, the tensor id's are listed
	// as [0,0], [0,1], [0,2] --> [0,D2-1] -> [1,0] ...
	//   
	int DSTART, DEND, DINCREMENT;
	DSTART = (td->row_major_form ? (td->number_of_dimensions - 1) : 0);
	DEND   = (td->row_major_form ? 0 : (td->number_of_dimensions - 1));
	DINCREMENT = (td->row_major_form ? 1 : -1);

	uint32_t SCALE_FACTOR = 1;
	for(I = DSTART; I != DEND; I = I + DINCREMENT)
	{
		ret_value  +=  SCALE_FACTOR*indices(I);
		SCALE_FACTOR = SCALE_FACTOR * td->dimensions[I];
	}

	return(ret_val);
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
		
		incrementCoordinateVector(td->number_of_dimensions, IVECTOR, td->row_major_form);

		destination_index++;

		if(areCoordinateVectorsEqual(td->number_of_dimensions, IVECTOR, indices_high))
			break;

		
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
		
		incrementCoordinateVector(td->number_of_dimensions, IVECTOR, td->row_major_form);
		source_index++;

		if(areCoordinateVectorsEqual(td->number_of_dimensions, IVECTOR, indices_high))
			break;

	}
	
	return(0);
}

