#include <vhdlCStubs.h>
uint16_t Divider(uint16_t dividend,uint16_t divisor)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call Divider ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint16_t(buffer,dividend); ADD_SPACE__(buffer);
append_uint16_t(buffer,divisor); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,16); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint16_t quotient = get_uint16_t(buffer,&ss);
return(quotient);
}
uint32_t TopMult(uint32_t in1,uint32_t in2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call TopMult ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint32_t(buffer,in1); ADD_SPACE__(buffer);
append_uint32_t(buffer,in2); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,32); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint32_t output = get_uint32_t(buffer,&ss);
return(output);
}
void accumulator(uint16_t chl_in,uint16_t ck,uint32_t op_size)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call accumulator ");
append_int(buffer,3); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint32_t(buffer,op_size); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void convolutionAll(uint16_t rb,uint16_t cb,uint16_t rt,uint16_t ct,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint8_t index_in1,uint8_t index_in2,uint8_t index_k,uint8_t index_out,uint16_t shift_val,uint16_t pad,uint8_t pool,uint8_t activation)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convolutionAll ");
append_int(buffer,16); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,rt); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_in1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_in2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_k); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,pool); ADD_SPACE__(buffer);
append_uint8_t(buffer,activation); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void convolveCore(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t num_parts,uint16_t max_chl)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convolveCore ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in_read); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts); ADD_SPACE__(buffer);
append_uint16_t(buffer,max_chl); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
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
void inputModule(uint16_t row_in,uint16_t rt,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts_1,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call inputModule ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rt); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts_1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void inputModule8(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call inputModule8 ");
append_int(buffer,7); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void inputModuleCT(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint8_t num_parts,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call inputModuleCT ");
append_int(buffer,5); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void inputModuleConcat(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t rk,uint16_t pad,uint8_t num_parts,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call inputModuleConcat ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule ");
append_int(buffer,5); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule8(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule8 ");
append_int(buffer,5); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule_in1(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule_in1 ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint32_t(buffer,init_addr); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule_in2(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule_in2 ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint32_t(buffer,init_addr); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule_in3(uint32_t init_addr,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule_in3 ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint32_t(buffer,init_addr); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void loadInput_in1(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call loadInput_in1 ");
append_int(buffer,7); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr_init); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts_1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void loadInput_in2(uint32_t addr_init,uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t pad,uint8_t num_parts_1,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call loadInput_in2 ");
append_int(buffer,7); ADD_SPACE__(buffer);
append_uint32_t(buffer,addr_init); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,pad); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts_1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void progx_xoptx_xo_storage_initializer_()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call progx_xoptx_xo_storage_initializer_ ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void readFromSystemPipe(uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readFromSystemPipe ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
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
uint64_t readModule_convolution(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_convolution ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
uint64_t readModule_convolutionk(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_convolutionk ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
void sendModule8(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t num_parts,uint16_t max_chl,uint8_t activation,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call sendModule8 ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
append_uint8_t(buffer,num_parts); ADD_SPACE__(buffer);
append_uint16_t(buffer,max_chl); ADD_SPACE__(buffer);
append_uint8_t(buffer,activation); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
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
void writeModule1(uint8_t index,uint32_t address,uint64_t data)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call writeModule1 ");
append_int(buffer,3); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_uint64_t(buffer,data); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void writeTime(uint8_t ind)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call writeTime ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint8_t(buffer,ind); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint32_t writeTimeBack()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call writeTimeBack ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,32); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint32_t ret_val__ = get_uint32_t(buffer,&ss);
return(ret_val__);
}
