#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <Pipes.h>
#include <SocketLib.h>
void acc_generic(uint16_t chl_in,uint16_t ck,uint32_t op_size);
void access_T(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint8_t index);
void accumulator(uint16_t chl_in,uint16_t ck,uint32_t op_size);
void concat(uint16_t input1_dim0,uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0,uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index0,uint8_t index1,uint8_t index2);
uint8_t concat_core(uint16_t input1_count,uint16_t input2_count,uint32_t output_size,uint8_t index1,uint8_t index2,uint8_t index3);
void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1,uint8_t index2);
void convolution3D_3(uint16_t rb,uint16_t cb,uint16_t chl_out_in,uint16_t chl_in_in,uint16_t rk,uint16_t ck,uint8_t index_in,uint8_t index_k,uint8_t index_out,uint16_t ct,uint16_t shift_val,uint8_t activation);
void convolutionSmall(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint8_t index_in,uint8_t index_k,uint8_t index_out,uint16_t ct,uint16_t shift_val,uint8_t activation);
void convolveCore(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck);
void core_generic(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck);
uint8_t ct_core(uint16_t inp_d0,uint16_t inp_d1,uint16_t inp_d2,uint16_t ker_d1,uint16_t ker_d2,uint16_t out_d0,uint16_t out_d1,uint16_t out_d2,uint16_t stride,uint16_t padding,uint8_t index1,uint8_t index3);
void fill_input();
void global_storage_initializer_();
void inputModule_generic(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint8_t index);
void kernelModule_generic(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void loadKernel(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void maxPool3D(uint16_t cb,uint16_t rb,uint16_t ct,uint16_t chl_out,uint8_t index_in,uint8_t index_out);
uint8_t maxPool4(uint32_t addr,uint32_t addr1,uint32_t addr2,uint32_t addr3,uint32_t addr4,uint8_t index1,uint8_t index2);
void progx_xoptx_xo_storage_initializer_();
void readFromSystemPipe(uint8_t index);
uint64_t readModule1(uint32_t address);
uint64_t readModule_concat(uint8_t index,uint32_t address);
uint64_t readModule_convTranspose(uint8_t index,uint32_t address);
uint64_t readModule_convolution(uint8_t index,uint32_t address);
uint64_t readModule_convolution2(uint8_t index,uint32_t address);
uint64_t readModule_convolutionk(uint8_t index,uint32_t address);
uint64_t readModule_maxPool(uint8_t index,uint32_t address);
uint64_t readModule_zeropad(uint8_t index,uint32_t address);
void sendModule(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t activation,uint8_t index);
void sendModule_generic(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t activation,uint8_t index);
void sendOutput();
void systemTOP();
uint64_t timer();
void timerDaemon();
void writeModule1(uint8_t index,uint32_t address,uint64_t data);
void zeropad(uint16_t input_dim0,uint16_t input_dim1,uint16_t input_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1,uint8_t index2);
uint8_t zeropad_same(uint16_t inp_d0,uint16_t inp_d1,uint16_t inp_d2,uint16_t out_d0,uint16_t out_d1,uint16_t out_d2,uint8_t index1,uint8_t index2);
