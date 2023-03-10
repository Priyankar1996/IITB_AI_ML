#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <Pipes.h>
#include <SocketLib.h>
uint16_t Divider(uint16_t dividend,uint16_t divisor);
uint32_t TopMult(uint32_t in1,uint32_t in2);
void accumulator(uint16_t chl_in,uint16_t ck,uint32_t op_size);
void convolutionAll(uint16_t rb,uint16_t cb,uint16_t rt,uint16_t ct,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint8_t index_in1,uint8_t index_in2,uint8_t index_k,uint8_t index_out,uint16_t shift_val,uint16_t pad,uint8_t pool,uint8_t activation);
void convolveCore(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t num_parts,uint16_t max_chl);
void fill_input();
void global_storage_initializer_();
void inputModule(uint16_t row_in,uint16_t rt,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts_1,uint8_t index);
void inputModule8(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint8_t index);
void inputModuleCT(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint8_t num_parts,uint8_t index);
void inputModuleConcat(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint8_t index1,uint8_t index2);
void kernelModule(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void kernelModule8(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void kernelModule_in1(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void kernelModule_in2(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void kernelModule_in3(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index);
void loadInput_in1(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint8_t index);
void loadInput_in2(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint8_t index);
void progx_xoptx_xo_storage_initializer_();
void readFromSystemPipe(uint8_t index);
uint64_t readModule1(uint32_t address);
uint64_t readModule_convolution(uint8_t index,uint32_t address);
uint64_t readModule_convolutionk(uint8_t index,uint32_t address);
void sendModule8(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t num_parts,uint16_t max_chl,uint8_t activation,uint8_t index);
void sendOutput();
void systemTOP();
uint64_t timer();
void timerDaemon();
void writeModule1(uint8_t index,uint32_t address,uint64_t data);
void writeTime(uint8_t ind);
uint32_t writeTimeBack();
