#include <vhdlCStubs.h>
void fill_input()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call fill_input ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void global_storage_initializer_()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call global_storage_initializer_ ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void maxPool3D(uint16_t cb,uint16_t rb,uint16_t ct,uint16_t chl_out,uint8_t index_in,uint8_t index_out)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call maxPool3D ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_in); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_out); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint8_t maxPool4(uint32_t addr,uint32_t addr1,uint32_t addr2,uint32_t addr3,uint32_t addr4,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call maxPool4 ");
append_int(buffer,7); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr1); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr2); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr3); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr4); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,8); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint8_t output = get_uint8_t(buffer,&ss);
return(output);
}
void progx_xoptx_xo_storage_initializer_()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call progx_xoptx_xo_storage_initializer_ ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint64_t readModule1(uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule1 ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
uint64_t readModule_maxPool(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_maxPool ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
void sendOutput()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call sendOutput ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void systemTOP()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call systemTOP ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint64_t timer()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call timer ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t T = get_uint64_t(buffer,&ss);
return(T);
}
void timerDaemon()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call timerDaemon ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void writeModule1(uint32_t address,uint64_t data)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call writeModule1 ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_uint64_t(buffer,data); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
