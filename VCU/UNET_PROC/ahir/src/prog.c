#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "convolution.h"

#define NUM_LAYERS 18
void __aa_barrier__();

uint64_t readModule1 (uint32_t);
void writeModule1 (uint32_t, uint32_t, uint64_t);
void convolutionAll (uint16_t rb, uint16_t cb, uint16_t rt, uint16_t ct, uint16_t chl_out, uint16_t chl_in, uint16_t rk, uint16_t ck, uint32_t index_in1, uint32_t index_in2, uint32_t index_k, uint32_t index_out, uint16_t shift_val,uint16_t pad, uint8_t pool, uint8_t activation);

uint64_t global_time_val[20];

void writeTime(uint8_t ind)
{
	write_uint8 ("system_output_pipe",201);
	global_time_val[ind] = read_uint64("time_val");
	write_uint8 ("system_output_pipe",202);
}

writeTimeBack()
{
	for (int i = 0; i < 19; i++)
	{
	uint64_t elapsed_time = global_time_val[i];
	uint8_t out_data[8];\
	out_data[7] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[6] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[5] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[4] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[3] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[2] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[1] = elapsed_time & 0xFF;\
	elapsed_time>>=8;\
	out_data[0] = elapsed_time & 0xFF;\
	__aa_barrier__();
	write_uint8 ("debug_output_pipe",out_data[0]);\
	write_uint8 ("debug_output_pipe",out_data[1]);\
	write_uint8 ("debug_output_pipe",out_data[2]);\
	write_uint8 ("debug_output_pipe",out_data[3]);\
	write_uint8 ("debug_output_pipe",out_data[4]);\
	write_uint8 ("debug_output_pipe",out_data[5]);\
	write_uint8 ("debug_output_pipe",out_data[6]);\
	write_uint8 ("debug_output_pipe",out_data[7]);\
	}
	
}

uint32_t accessAcceleratorRegisters (uint8_t write_bar,
					uint32_t reg_index,
					uint32_t reg_value)
{
	uint64_t cmd = write_bar;
	cmd = (cmd << 31) | reg_index;
	cmd = (cmd << 32) | reg_value;
	write_uint64 ("tester_control_command", cmd);
	uint32_t ret_val = read_uint32("tester_control_response");

#ifdef DEBUG_PRINT
	fprintf(stderr,"accessAcceleratorRegisters: 0x%x 0x%x 0x%x 0x%x\n",
					write_bar, reg_index, reg_value, ret_val);
#endif
	return(ret_val);
}

void execute_layer()
{

	write_uint8 ("system_output_pipe",100);
	accessAcceleratorRegisters (0,0, 0x7);
	write_uint8 ("system_output_pipe",101);
	// wait until interrupt is 0.
	while(1)
	{
		if(!read_uint8("ACCELERATOR_INTERRUPT_8"))
			break;
	}

	write_uint8 ("system_output_pipe",102);
	// wait until interrupt is 1
	while(1)
	{
		if(read_uint8("ACCELERATOR_INTERRUPT_8"))
			break;
	}
	// disable everything..
	write_uint8 ("system_output_pipe",103);
	accessAcceleratorRegisters (0,0, 0x0);
	write_uint8 ("system_output_pipe",104);
}

void set_convolution_layer (uint16_t rb, uint16_t cb, uint16_t rt, uint16_t ct, uint16_t chl_out, uint16_t chl_in, uint16_t rk, uint16_t ck, uint32_t addr_in1, uint32_t addr_in2, uint32_t addr_k, uint8_t addr_out, uint16_t shift_val,uint16_t pad, uint8_t pool, uint8_t activation)
{
	write_uint8 ("system_output_pipe",001);
	uint32_t word_to_send;
	word_to_send = (((uint32_t) rb) << 16) + cb;
	accessAcceleratorRegisters(0,1,word_to_send);
	word_to_send = (((uint32_t) rt) << 16) + ct;
	accessAcceleratorRegisters(0,2,word_to_send);
	word_to_send = (((uint32_t) chl_out) << 16) + chl_in;
	accessAcceleratorRegisters(0,3,word_to_send);
	word_to_send = (((uint32_t) rk) << 16) + ck;
	accessAcceleratorRegisters(0,4,word_to_send);
	word_to_send = (((uint32_t) shift_val) << 16) + pad;
	accessAcceleratorRegisters(0,5,word_to_send);
	word_to_send = (((uint16_t) pool) << 8) + activation;
	accessAcceleratorRegisters(0,6,word_to_send);
	word_to_send = addr_in1;
	accessAcceleratorRegisters(0,7,word_to_send);
	word_to_send = addr_in2;
	accessAcceleratorRegisters(0,8,word_to_send);
	word_to_send = addr_out;
	accessAcceleratorRegisters(0,9,word_to_send);
	word_to_send = addr_k;
	accessAcceleratorRegisters(0,10,word_to_send);
	write_uint8 ("system_output_pipe",002);
}

/*
int main(int argc, char **argv)
{
	int row_outs[NUM_LAYERS] = {224,224,112,112,56,56,28,28,56,56,56,112,112,112,224,224,224,224};
	int col_outs[NUM_LAYERS] = {224,224,112,112,56,56,28,28,56,56,56,112,112,112,224,224,224,224};
	int row_ins[NUM_LAYERS] = {224,224,112,112,56,56,28,28,28,56,56,56,112,112,112,224,224,224};
	int col_ins[NUM_LAYERS] = {224,224,112,112,56,56,28,28,28,56,56,56,112,112,112,224,224,224};
	int chl_outs[NUM_LAYERS] = {64,64,128,128,256,256,512,512,256,256,256,128,128,128,64,64,64,3};
	int chl_ins[NUM_LAYERS] = {3,64,64,128,128,256,256,512,512,512,256,256,256,128,128,128,64,3};
	int row_ks[NUM_LAYERS] = {3,3,3,3,3,3,3,3,2,3,3,2,3,3,2,3,3,3};
	int col_ks[NUM_LAYERS] = {3,3,3,3,3,3,3,3,2,3,3,2,3,3,2,3,3,3};
	int addr_in1s[NUM_LAYERS] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int addr_in2s[NUM_LAYERS] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int addr_outs[NUM_LAYERS] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int addr_ks[NUM_LAYERS]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int shift_vals[NUM_LAYERS] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
       	int pads[NUM_LAYERS] = {1,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,1};
	int pools[NUM_LAYERS] = {0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0};
	int activations[NUM_LAYERS] = {relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,relu,sigmoid};

	register_signal("ACCELERATOR_INTERRUPT_8",8);

		for (int i = 0; i < NUM_LAYERS; i++)
	{
		set_convolution_layer(
			row_outs[i], col_outs[i], row_ins[i], col_ins[i],
			chl_outs[i], chl_ins[i], row_ks[i], col_ks[i],
			addr_in1s[i], addr_in2s[i], addr_ks[i], add_outs[i],
			shift_vals[i], pads[i], pools[i], activations[i]
			);
		execute_layer();
		writeTime(i);
	}

		return(0);
}
*/

void systemTOP()
{
	// 0
	uint8_t start = read_uint8("debug_input_pipe");
	uint8_t end = read_uint8("system_input_pipe");
	__aa_barrier__();
	set_convolution_layer(224,224,224,224,64,3,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(1);
	set_convolution_layer(224,224,224,224,64,64,3,3,0,0,0,0,0,1,1,relu);
	execute_layer();
	writeTime(2);
	set_convolution_layer(112,112,112,112,128,64,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(3);
	set_convolution_layer(112,112,112,112,128,128,3,3,0,0,0,0,0,1,1,relu);
	execute_layer();
	writeTime(4);
	set_convolution_layer(56,56,56,56,256,128,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(5);
	set_convolution_layer(56,56,56,56,256,256,3,3,0,0,0,0,0,1,1,relu);
	execute_layer();
	writeTime(6);
	set_convolution_layer(28,28,28,28,512,256,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(7);
	set_convolution_layer(28,28,28,28,512,512,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(8);
	set_convolution_layer(56,56,28,28,256,512,2,2,0,0,0,0,0,0,0,relu);
	execute_layer();
	writeTime(9);
	set_convolution_layer(56,56,56,56,256,512,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(10);
	set_convolution_layer(56,56,56,56,256,256,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(11);
	set_convolution_layer(112,112,56,56,128,256,2,2,0,0,0,0,0,0,0,relu);
	execute_layer();
	writeTime(12);
	set_convolution_layer(112,112,112,112,128,256,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(13);
	set_convolution_layer(112,112,112,112,128,128,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(14);
	set_convolution_layer(224,224,112,112,64,128,2,2,0,0,0,0,0,0,0,relu);
	execute_layer();
	writeTime(15);
	set_convolution_layer(224,224,224,224,64,128,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(16);
	set_convolution_layer(224,224,224,224,64,64,3,3,0,0,0,0,0,1,0,relu);
	execute_layer();
	writeTime(17);
	set_convolution_layer(224,224,224,224,3,64,3,3,0,0,0,0,0,1,0,sigmoid);
	execute_layer();
	writeTime(18);
	__aa_barrier__();
	writeTimeBack();
}
