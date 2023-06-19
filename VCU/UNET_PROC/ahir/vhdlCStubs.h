#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <Pipes.h>
#include <SocketLib.h>
uint16_t Divider(uint16_t dividend,uint16_t divisor);
uint32_t TopMult(uint32_t in1,uint32_t in2);
void accelerator_control_daemon();
void accelerator_interrupt_daemon();
void accelerator_worker_daemon();
uint32_t accessAcceleratorRegisters(uint8_t write_bar,uint32_t reg_index,uint32_t reg_value);
void accumulator(uint16_t chl_in,uint16_t ck,uint32_t op_size);
void convolutionAll(uint16_t rb,uint16_t cb,uint16_t rt,uint16_t ct,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint32_t base_address_in1,uint32_t base_address_in2,uint32_t base_address_k,uint32_t base_address_out,uint16_t shift_val,uint16_t pad,uint8_t pool,uint8_t activation);
void convolveCore(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t num_parts,uint16_t max_chl);
void execute_layer();
void global_storage_initializer_();
void inputModule(uint16_t row_in,uint16_t rt,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts_1,uint32_t base_address);
void inputModule8(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint32_t base_address);
void inputModuleCT(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint8_t num_parts,uint32_t base_address);
void inputModuleConcat(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint32_t base_address1,uint32_t base_address2);
void interrupt_daemon();
void kernelModule(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint32_t base_address);
void kernelModule8(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint32_t base_address);
void kernelModule_in1(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint32_t base_address);
void kernelModule_in2(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint32_t base_address);
void kernelModule_in3(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint32_t base_address);
void loadInput_in1(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint32_t base_address);
void loadInput_in2(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint32_t base_address);
void progx_xoptx_xo_storage_initializer_();
uint64_t readModule1(uint32_t address);
uint64_t readModule_convolution(uint32_t base_address,uint32_t address);
uint64_t readModule_convolutionk(uint32_t base_address,uint32_t address);
void sendModule8(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t num_parts,uint16_t max_chl,uint8_t activation,uint32_t base_address);
void set_convolution_layer(uint16_t rb,uint16_t cb,uint16_t rt,uint16_t ct,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint32_t addr_in1,uint32_t addr_in2,uint32_t addr_k,uint8_t addr_out,uint16_t shift_val,uint16_t pad,uint8_t pool,uint8_t activation);
void systemTOP();
void tester_control_daemon();
void timerDaemon();
void writeModule1(uint32_t base_address,uint32_t address,uint64_t data);
void writeTime(uint8_t ind);
uint32_t writeTimeBack();
