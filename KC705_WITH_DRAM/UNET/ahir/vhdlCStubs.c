#include <vhdlCStubs.h>
void acc_generic(uint16_t chl_in,uint16_t ck,uint32_t op_size)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call acc_generic ");
append_int(buffer,3); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint32_t(buffer,op_size); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void access_T(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call access_T ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
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
void concat(uint16_t input1_dim0,uint16_t input1_dim1,uint16_t input1_dim2,uint16_t input2_dim0,uint16_t input2_dim1,uint16_t input2_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index0,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call concat ");
append_int(buffer,12); ADD_SPACE__(buffer);
append_uint16_t(buffer,input1_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,input1_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,input1_dim2); ADD_SPACE__(buffer);
append_uint16_t(buffer,input2_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,input2_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,input2_dim2); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index0); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint8_t concat_core(uint16_t input1_count,uint16_t input2_count,uint32_t output_size,uint8_t index1,uint8_t index2,uint8_t index3)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call concat_core ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,input1_count); ADD_SPACE__(buffer);
append_uint16_t(buffer,input2_count); ADD_SPACE__(buffer);
append_uint32_t(buffer,output_size); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index3); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,8); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint8_t done1 = get_uint8_t(buffer,&ss);
return(done1);
}
void convTranspose(uint16_t inp_dim0,uint16_t inp_dim1,uint16_t inp_dim2,uint16_t ker_dim1,uint16_t ker_dim2,uint16_t stride0,uint16_t padding,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convTranspose ");
append_int(buffer,12); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_dim2); ADD_SPACE__(buffer);
append_uint16_t(buffer,ker_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,ker_dim2); ADD_SPACE__(buffer);
append_uint16_t(buffer,stride0); ADD_SPACE__(buffer);
append_uint16_t(buffer,padding); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void convolution3D_3(uint16_t rb,uint16_t cb,uint16_t chl_out_in,uint16_t chl_in_in,uint16_t rk,uint16_t ck,uint8_t index_in,uint8_t index_k,uint8_t index_out,uint16_t ct,uint16_t shift_val,uint8_t activation)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convolution3D_3 ");
append_int(buffer,12); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_in); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_k); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
append_uint8_t(buffer,activation); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void convolutionSmall(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t chl_in,uint16_t rk,uint16_t ck,uint8_t index_in,uint8_t index_k,uint8_t index_out,uint16_t ct,uint16_t shift_val,uint8_t activation)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convolutionSmall ");
append_int(buffer,12); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_in); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_k); ADD_SPACE__(buffer);
append_uint8_t(buffer,index_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
append_uint8_t(buffer,activation); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void convolveCore(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call convolveCore ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in_read); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void core_generic(uint16_t rb,uint16_t cb,uint16_t chl_in_read,uint16_t chl_out,uint16_t rk,uint16_t ck)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call core_generic ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in_read); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint16_t(buffer,ck); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint8_t ct_core(uint16_t inp_d0,uint16_t inp_d1,uint16_t inp_d2,uint16_t ker_d1,uint16_t ker_d2,uint16_t out_d0,uint16_t out_d1,uint16_t out_d2,uint16_t stride,uint16_t padding,uint8_t index1,uint8_t index3)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call ct_core ");
append_int(buffer,12); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d0); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d1); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d2); ADD_SPACE__(buffer);
append_uint16_t(buffer,ker_d1); ADD_SPACE__(buffer);
append_uint16_t(buffer,ker_d2); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d0); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d1); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d2); ADD_SPACE__(buffer);
append_uint16_t(buffer,stride); ADD_SPACE__(buffer);
append_uint16_t(buffer,padding); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index3); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,8); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint8_t done2 = get_uint8_t(buffer,&ss);
return(done2);
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
void inputModule_generic(uint16_t row_in,uint16_t ct,uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call inputModule_generic ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,row_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,ct); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_in); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,rk); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void kernelModule_generic(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call kernelModule_generic ");
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
void loadKernel(uint16_t chl_in,uint16_t chl_out,uint16_t rk,uint16_t ck,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call loadKernel ");
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
uint64_t readModule_concat(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_concat ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
uint64_t readModule_convTranspose(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_convTranspose ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
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
uint64_t readModule_convolution2(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_convolution2 ");
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
uint64_t readModule_zeropad(uint8_t index,uint32_t address)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call readModule_zeropad ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_uint32_t(buffer,address); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,64); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint64_t data = get_uint64_t(buffer,&ss);
return(data);
}
void sendModule(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t activation,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call sendModule ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
append_uint8_t(buffer,activation); ADD_SPACE__(buffer);
append_uint8_t(buffer,index); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
void sendModule_generic(uint16_t rb,uint16_t cb,uint16_t chl_out,uint16_t shift_val,uint8_t activation,uint8_t index)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call sendModule_generic ");
append_int(buffer,6); ADD_SPACE__(buffer);
append_uint16_t(buffer,rb); ADD_SPACE__(buffer);
append_uint16_t(buffer,cb); ADD_SPACE__(buffer);
append_uint16_t(buffer,chl_out); ADD_SPACE__(buffer);
append_uint16_t(buffer,shift_val); ADD_SPACE__(buffer);
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
void zeropad(uint16_t input_dim0,uint16_t input_dim1,uint16_t input_dim2,uint16_t out_dim0,uint16_t out_dim1,uint16_t out_dim2,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call zeropad ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,input_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,input_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,input_dim2); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim0); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim1); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_dim2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}
uint8_t zeropad_same(uint16_t inp_d0,uint16_t inp_d1,uint16_t inp_d2,uint16_t out_d0,uint16_t out_d1,uint16_t out_d2,uint8_t index1,uint8_t index2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call zeropad_same ");
append_int(buffer,8); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d0); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d1); ADD_SPACE__(buffer);
append_uint16_t(buffer,inp_d2); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d0); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d1); ADD_SPACE__(buffer);
append_uint16_t(buffer,out_d2); ADD_SPACE__(buffer);
append_uint8_t(buffer,index1); ADD_SPACE__(buffer);
append_uint8_t(buffer,index2); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,8); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint8_t done = get_uint8_t(buffer,&ss);
return(done);
}
