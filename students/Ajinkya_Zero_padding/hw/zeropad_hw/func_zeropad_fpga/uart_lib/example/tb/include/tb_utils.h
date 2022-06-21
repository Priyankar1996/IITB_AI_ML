#ifndef __tb_utils_h____
#define __tb_utils_h____
#include <stdio.h>

uint8_t tbGetUint8(FILE* fp);
void	tbSendUint8(uint8_t X, FILE* fp);

uint16_t tbGetUint16(FILE* fp);
void	 tbSendUint16(uint16_t X, FILE* fp);

uint32_t tbGetUint32(FILE* fp);
void	 tbSendUint32(uint32_t X, FILE* fp);

float 	tbGetFloat(FILE* fp);
void	tbSendFloat(float X, FILE* fp);

uint64_t tbGetUint64(FILE* fp);
void	 tbSendUint64(uint64_t X, FILE* fp);

double 	 tbGetDouble(FILE* fp);
void	 tbSendDouble(double X, FILE* fp);



#endif
