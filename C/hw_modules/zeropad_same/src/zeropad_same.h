#ifndef __zeropad_same_h__
#define __zeropad_same_h__


#define __CheckEndOfWhile__(dim0,dim1,dim2,dim0_high,dim1_high,dim2_high) ({\
    uint8_t end_flag = 0;\
    if(dim2 < dim2_high-1) {\
	    dim2++;\
    }\
	else {\
	    dim2=0;\
        dim1++;\
    }\
	if(dim1 == dim1_high) {\
	    dim0++;\
        dim1=0;\
    }\
    if(dim0 == dim0_high)\
        end_flag = 1;\
    end_flag;\
})
//Check bytecounts of input and output.
#define zeropad1(input_dim0,input_dim1,input_dim2,out_dim0,out_dim1,out_dim2) ({\
uint8_t input_value,input_byte_count = 0,output_byte_count = 0,pad=(out_dim0 - input_dim0)>>1,target_hit;\
uint32_t incr_out_offset = 0,target_out_offset = out_dim2*(pad + out_dim1*pad),add_src=0,add_out=0;\
uint16_t o0=0,o1=0,o2=0;\
uint64_t value = 0,input_word = T[0].data_array[add_src];\
while (1) {\
    __loop_pipeline_var__\
	if(incr_out_offset == target_out_offset) {\
        target_hit = 1;\
		input_value = (input_word>>(56- 8*input_byte_count++))& 0xFF;\
		value = (value << 8) + input_value;\
	}\
	else {\
        target_hit = 0;\
		value = (value << 8);\
    }\
    if(input_byte_count == 8) {\
        input_byte_count = 0;\
        add_src = add_src + 1;\
        input_word = T[0].data_array[add_src];\
    }\
    if(target_hit == 1)\
        target_out_offset = (o0>=pad && o0<=(out_dim0-pad-1) && o1==(out_dim1-pad-1) && o2==out_dim2-1) ? (target_out_offset+2*pad*input_dim2+1) : (target_out_offset+1);\
    incr_out_offset++;\
	output_byte_count++;\
	if(output_byte_count == 8) {\
		output_byte_count = 0;\
		T[1].data_array[add_out] = value;\
		value = 0;\
		add_out++;\		
    }\		
	uint8_t flag = __CheckEndOfWhile__(o0,o1,o2,out_dim0,out_dim1,out_dim2);\
	if(flag == 1)\
		break;\
    }\	
})

#endif