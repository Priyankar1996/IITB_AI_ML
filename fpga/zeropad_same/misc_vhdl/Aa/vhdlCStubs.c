#include <vhdlCStubs.h>
void baudControlCalculatorDaemon()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call baudControlCalculatorDaemon ");
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
uint32_t my_div(uint32_t A,uint32_t B)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call my_div ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint32_t(buffer,A); ADD_SPACE__(buffer);
append_uint32_t(buffer,B); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,32); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint32_t Q = get_uint32_t(buffer,&ss);
return(Q);
}
uint32_t my_gcd(uint32_t A,uint32_t B)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call my_gcd ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint32_t(buffer,A); ADD_SPACE__(buffer);
append_uint32_t(buffer,B); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,32); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint32_t GCD = get_uint32_t(buffer,&ss);
return(GCD);
}
