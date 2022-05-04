#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolveTensors.h"

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

SizedTensor_16K T,K,R;
TensorDescriptor desc_T,desc_K,desc_R;
uint8_t stride;

#define __dt__ int16_t

#define __get8xi8__(element) ({\
	element = (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
    	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
	element = (element << 8) + (read_uint8 ("conv_input_pipe"));\
})

#define __send8xi8__(addr) ({\
	uint64_t element = R.data_array[addr];\
	uint8_t out_data[8];\
	out_data[7] = element & 0xFF;\
	element>>=8;\
	out_data[6] = element & 0xFF;\
	element>>=8;\
	out_data[5]= element & 0xFF;\
	element>>=8;\
    	out_data[4] = element & 0xFF;\
	element>>=8;\
	out_data[3] = element & 0xFF;\
	element>>=8;\
	out_data[2] = element & 0xFF;\
	element>>=8;\
    	out_data[1] = element & 0xFF;\
	element>>=8;\
	out_data[0] = element & 0xFF;\
	write_uint8 ("conv_output_pipe",out_data[0]);\
	write_uint8 ("conv_output_pipe",out_data[1]);\
	write_uint8 ("conv_output_pipe",out_data[2]);\
	write_uint8 ("conv_output_pipe",out_data[3]);\
    	write_uint8 ("conv_output_pipe",out_data[4]);\
	write_uint8 ("conv_output_pipe",out_data[5]);\
	write_uint8 ("conv_output_pipe",out_data[6]);\
	write_uint8 ("conv_output_pipe",out_data[7]);\
})

void getInput()
{
	desc_T.row_major_form = read_uint8 ("conv_input_pipe");
    desc_T.number_of_dimensions = read_uint8 ("conv_input_pipe"); 
    int i;
    for(i = 0;i < desc_T.number_of_dimensions;i++){
        desc_T.dimensions[i] = read_uint8 ("conv_input_pipe");
    }

	stride = read_uint8 ("conv_input_pipe");

	desc_K.row_major_form = read_uint8 ("conv_input_pipe");
    desc_K.number_of_dimensions = read_uint8 ("conv_input_pipe");
    for(i = 0;i < desc_K.number_of_dimensions;i++){
        desc_K.dimensions[i] = read_uint8 ("conv_input_pipe");
    }
    
	uint32_t input_size = desc_T.dimensions[0]*desc_T.dimensions[1]*desc_T.dimensions[2];
    uint32_t kernel_size = desc_K.dimensions[0]*desc_K.dimensions[1]*desc_K.dimensions[2]*desc_K.dimensions[3];
    for(i = 0; i < (input_size >> 2)+1; i++)
    {
        uint64_t element;
        __get8xi8__(element);
        T.data_array[i] = element;
    }

    for(i = 0; i < (kernel_size >> 2)+1; i++)
    {
        uint64_t element;
        __get8xi8__(element);
        K.data_array[i] = element;
    }
}

void sendOutput()
{
	write_uint8 ("conv_output_pipe",desc_R.dimensions[0]);\
	write_uint8 ("conv_output_pipe",desc_R.dimensions[1]);\
	write_uint8 ("conv_output_pipe",desc_R.dimensions[2]);\
    uint32_t size = desc_R.dimensions[0] * desc_R.dimensions[1] * desc_R.dimensions[2];
    int i;
    for (i = 0; i < (size >> 2)+1; i++){
        __send8xi8__(i);
    }
}

void convCore1()
{
	uint16_t p_start = read_uint16("core1_req_pipe");
	uint16_t q_start = read_uint16("core1_req_pipe");
	uint16_t r_start = read_uint16("core1_req_pipe");
	uint16_t p_end = read_uint16("core1_req_pipe");
	uint16_t q_end = read_uint16("core1_req_pipe");
	uint16_t r_end = read_uint16("core1_req_pipe");
	__aa_barrier__();	
	__convolveTensors__(T,K,R,stride,desc_T,desc_K,desc_R,p_start,q_start,r_start,p_end,q_end,r_end);
	__aa_barrier__();
	write_uint16("core1_ack_pipe",1);
}

void convCore2()
{
	uint16_t p_start = read_uint16("core2_req_pipe");
	uint16_t q_start = read_uint16("core2_req_pipe");
	uint16_t r_start = read_uint16("core2_req_pipe");
	uint16_t p_end = read_uint16("core2_req_pipe");
	uint16_t q_end = read_uint16("core2_req_pipe");
	uint16_t r_end = read_uint16("core2_req_pipe");
	__aa_barrier__();	
	__convolveTensors__(T,K,R,stride,desc_T,desc_K,desc_R,p_start,q_start,r_start,p_end,q_end,r_end);
	__aa_barrier__();
	write_uint16("core2_ack_pipe",1);
}

void convCore3()
{
	uint16_t p_start = read_uint16("core3_req_pipe");
	uint16_t q_start = read_uint16("core3_req_pipe");
	uint16_t r_start = read_uint16("core3_req_pipe");
	uint16_t p_end = read_uint16("core3_req_pipe");
	uint16_t q_end = read_uint16("core3_req_pipe");
	uint16_t r_end = read_uint16("core3_req_pipe");
	__aa_barrier__();	
	__convolveTensors__(T,K,R,stride,desc_T,desc_K,desc_R,p_start,q_start,r_start,p_end,q_end,r_end);
	__aa_barrier__();
	write_uint16("core3_ack_pipe",1);
}

void convCore4()
{
	uint16_t p_start = read_uint16("core4_req_pipe");
	uint16_t q_start = read_uint16("core4_req_pipe");
	uint16_t r_start = read_uint16("core4_req_pipe");
	uint16_t p_end = read_uint16("core4_req_pipe");
	uint16_t q_end = read_uint16("core4_req_pipe");
	uint16_t r_end = read_uint16("core4_req_pipe");
	__aa_barrier__();	
	__convolveTensors__(T,K,R,stride,desc_T,desc_K,desc_R,p_start,q_start,r_start,p_end,q_end,r_end);
	__aa_barrier__();
	write_uint16("core4_ack_pipe",1);
}

void convCore5()
{
	uint16_t p_start = read_uint16("core5_req_pipe");
	uint16_t q_start = read_uint16("core5_req_pipe");
	uint16_t r_start = read_uint16("core5_req_pipe");
	uint16_t p_end = read_uint16("core5_req_pipe");
	uint16_t q_end = read_uint16("core5_req_pipe");
	uint16_t r_end = read_uint16("core5_req_pipe");
	__aa_barrier__();	
	__convolveTensors__(T,K,R,stride,desc_T,desc_K,desc_R,p_start,q_start,r_start,p_end,q_end,r_end);
	__aa_barrier__();
	write_uint16("core5_ack_pipe",1);
}

void conv2D()
{
    getInput();
	__aa_barrier__();
	uint16_t p_start1 = 0;
	uint16_t q_start1 = 0;
	uint16_t r_start1 = 0;
	uint16_t p_end1 = 0;
	uint16_t q_end1 = 4;
	uint16_t r_end1 = 0;

	uint16_t p_start2 = 1;
	uint16_t q_start2 = 0;
	uint16_t r_start2 = 0;
	uint16_t p_end2 = 1;
	uint16_t q_end2 = 4;
	uint16_t r_end2 = 0;
	
	uint16_t p_start3 = 2;
	uint16_t q_start3 = 0;
	uint16_t r_start3 = 0;
	uint16_t p_end3 = 2;
	uint16_t q_end3 = 4;
	uint16_t r_end3 = 0;
	
	uint16_t p_start4 = 3;
	uint16_t q_start4 = 0;
	uint16_t r_start4 = 0;
	uint16_t p_end4 = 3;
	uint16_t q_end4 = 4;
	uint16_t r_end4 = 0;

	uint16_t p_start5 = 4;
	uint16_t q_start5 = 0;
	uint16_t r_start5 = 0;
	uint16_t p_end5 = 4;
	uint16_t q_end5 = 4;
	uint16_t r_end5 = 0;
	__aa_barrier__();
#ifndef SW
	uint64_t start_time = timer();
#endif
	write_uint16("core1_req_pipe",p_start1);
	write_uint16("core1_req_pipe",q_start1);
	write_uint16("core1_req_pipe",r_start1);
	write_uint16("core1_req_pipe",p_end1);
	write_uint16("core1_req_pipe",q_end1);
	write_uint16("core1_req_pipe",r_end1);
	write_uint16("core2_req_pipe",p_start2);
	write_uint16("core2_req_pipe",q_start2);
	write_uint16("core2_req_pipe",r_start2);
	write_uint16("core2_req_pipe",p_end2);
	write_uint16("core2_req_pipe",q_end2);
	write_uint16("core2_req_pipe",r_end2);
	write_uint16("core3_req_pipe",p_start3);
	write_uint16("core3_req_pipe",q_start3);
	write_uint16("core3_req_pipe",r_start3);
	write_uint16("core3_req_pipe",p_end3);
	write_uint16("core3_req_pipe",q_end3);
	write_uint16("core3_req_pipe",r_end3);
	write_uint16("core4_req_pipe",p_start4);
	write_uint16("core4_req_pipe",q_start4);
	write_uint16("core4_req_pipe",r_start4);
	write_uint16("core4_req_pipe",p_end4);
	write_uint16("core4_req_pipe",q_end4);
	write_uint16("core4_req_pipe",r_end4);
	write_uint16("core5_req_pipe",p_start5);
	write_uint16("core5_req_pipe",q_start5);
	write_uint16("core5_req_pipe",r_start5);
	write_uint16("core5_req_pipe",p_end5);
	write_uint16("core5_req_pipe",q_end5);
	write_uint16("core5_req_pipe",r_end5);
	
	__aa_barrier__();
	uint8_t done1 = read_uint16("core1_ack_pipe");
	uint8_t done2 = read_uint16("core2_ack_pipe");
	uint8_t done3 = read_uint16("core3_ack_pipe");
	uint8_t done4 = read_uint16("core4_ack_pipe");
	uint8_t done5 = read_uint16("core5_ack_pipe");
	__aa_barrier__();
#ifndef SW
	uint64_t stop_time = timer();
	uint64_t elapsed_time = stop_time - start_time;
	write_uint64("elapsed_time_pipe", elapsed_time);
#endif
	__aa_barrier__();
    sendOutput();
}
