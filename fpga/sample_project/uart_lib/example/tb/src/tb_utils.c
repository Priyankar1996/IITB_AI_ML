#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "uart_interface.h"

uint32_t tb_sent_uint8_count = 0;
uint32_t tb_recv_uint8_count = 0;

int    end_of_file_reached  = 0;
uint8_t tbGetUint8(FILE* fp)
{
	uint8_t ret_val;
#ifdef FREADWRITE
	int n = fread((void*) &ret_val, 1, 1, fp);
#else
	ret_val = recvByte();

#endif
	tb_recv_uint8_count++;
	return(ret_val);
}

void	tbSendUint8(uint8_t X, FILE* fp)
{
#ifdef FREADWRITE
	fwrite(&X, 1,1 , fp);
#else
	while(1)
	{
		int n = sendByte(X);
		if(n==1)
			break;
	}

#endif
	tb_sent_uint8_count++;
}


uint16_t tbGetUint16(FILE* fp)
{
	uint8_t b0 = tbGetUint8(fp);
	uint8_t b1 = tbGetUint8(fp);

	uint16_t ret_val = b0;
	ret_val = (ret_val << 8) | b1;
	return(ret_val);
}
void	 tbSendUint16(uint16_t X, FILE* fp)
{
	uint8_t b0 = (X >> 8);
	uint8_t b1 = X & 0xff;

	tbSendUint8(b0, fp);
	tbSendUint8(b1, fp);
}

uint32_t tbGetUint32(FILE* fp)
{
	uint16_t h0 = tbGetUint16(fp);
	uint16_t h1 = tbGetUint16(fp);

	uint32_t ret_val = h0;
	ret_val = (ret_val << 16) | h1;
	return(ret_val);
}

void	tbSendUint32(uint32_t X, FILE* fp)
{
	uint16_t h0 = (X >> 16);
	uint16_t h1 = (X & 0xffff);

	tbSendUint16(h0, fp);
	tbSendUint16(h1, fp);
}

float 	tbGetFloat(FILE* fp)
{
	uint32_t uval = tbGetUint32(fp);
	float ret_val = *((float*) &uval);
	return(ret_val);
}

void	tbSendFloat(float X, FILE* fp)
{
	uint32_t sval = *((uint32_t*) &X);
	tbSendUint32(sval, fp);
}

uint64_t tbGetUint64(FILE* fp)
{
	uint32_t u0 = tbGetUint32(fp);
	uint32_t u1 = tbGetUint32(fp);

	uint64_t rval = u0;
	rval  = (rval << 32) | u1;
	return(rval);
}

void	 tbSendUint64(uint64_t X, FILE* fp)
{
	uint32_t u1 = (X & 0xffffffff);
	X = (((uint64_t) X) >> 32);
	uint32_t u0 = (X & 0xffffffff);

	tbSendUint32(u0, fp);
	tbSendUint32(u1, fp);
}

double 	 tbGetDouble(FILE* fp)
{
	uint64_t u = tbGetUint64(fp);
	double rval = *((double*) &u);
	return(rval);
}

void	 tbSendDouble(double X, FILE* fp)
{
	uint64_t u = *((uint64_t*) &X);
	tbSendUint64(u, fp);
}




