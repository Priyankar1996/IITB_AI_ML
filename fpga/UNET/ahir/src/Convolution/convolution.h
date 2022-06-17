#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "inttypes.h"

typedef enum __convActivations {
	none,relu,sigmoid
} convActivations;

void convolution3D(uint16_t rb, uint16_t cb, uint16_t chl_out, uint16_t chl_in, uint8_t index_in, uint8_t index_k, uint8_t index_out, uint16_t ct, uint8_t activation)
{
	chl_in >>= 3;
	chl_out >>= 3;
	write_uint16("output_pipe",cb);
	write_uint16("output_pipe",chl_out);
	write_uint16("output_pipe",index_out);
	write_uint16("num_out_pipe",rb);
	write_uint16("num_out_pipe",cb);
	write_uint16("num_out_pipe",chl_in);
	write_uint16("kernel_module_pipe",chl_in);
	write_uint16("kernel_module_pipe",chl_out);
	write_uint16("kernel_module_pipe",index_k);
	write_uint16("input_module_pipe",rb);
	write_uint16("input_module_pipe",ct);
	write_uint16("input_module_pipe",chl_in);
	write_uint16("input_module_pipe",chl_out);
	write_uint16("input_module_pipe",index_in);
	uint8_t ret = read_uint8("input_done_pipe");
}
