#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <Pipes.h>
#include <SocketLib.h>
void fill_input();
void global_storage_initializer_();
void maxPool3D(uint16_t cb,uint16_t rb,uint16_t ct,uint16_t chl_out,uint8_t index_in,uint8_t index_out);
uint8_t maxPool4(uint32_t addr,uint32_t addr1,uint32_t addr2,uint32_t addr3,uint32_t addr4,uint8_t index1,uint8_t index2);
void progx_xoptx_xo_storage_initializer_();
uint64_t readModule1(uint32_t address);
uint64_t readModule_maxPool(uint8_t index,uint32_t address);
void sendOutput();
void systemTOP();
uint64_t timer();
void timerDaemon();
void writeModule1(uint32_t address,uint64_t data);
