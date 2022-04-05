#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include "tb_utils.h"
#include "uart_interface.h"


int decodeAdcData(uint8_t v)
{
	int ret_val = 1;
	if((v & 0x3) == 1)
		ret_val = 3;
	else if((v & 0x3) == 2)
		ret_val = -1;	
	else if((v & 0x3) == 3)
		ret_val = -3;	
	
	return(ret_val);
}


void dump8 (FILE* fp, uint8_t x)
{
	uint8_t x0 = (x >> 6) & 0x3;
	fprintf(fp,"%d\n", decodeAdcData(x0));

	uint8_t x1 = (x >> 4) & 0x3;
	fprintf(fp,"%d\n", decodeAdcData(x1));

	uint8_t x2 = (x >> 2) & 0x3;
	fprintf(fp,"%d\n", decodeAdcData(x2));

	uint8_t x3 = x & 0x3;
	fprintf(fp,"%d\n", decodeAdcData(x3));
}

int main(int argc, char* argv[])
{
	int I=0;
	if(argc < 2)
	{
		fprintf(stderr,"Usage %s /dev/ttyUSBx < /dev/ttyUSBx\n", argv[0]);
		return(1);
	}

 	setUartBlockingFlag(1);
        int tty_fd = setupDebugUartLink(argv[1]);
        if(tty_fd < 0)
        {
                fprintf(stderr,"Error: could not open uart %s\n", argv[1]);
                return (1);
        }

	FILE* dev_fp = stdin;
	FILE* adc_fp = fopen("ADC_DATA.TXT", "w");
	
	while(1)
	{
		I++;

		// read 4-samples of ADC data.	
		uint32_t adc_word = tbGetUint8(dev_fp);
		dump8 (adc_fp, adc_word);

		fprintf(stderr,"Received %d adc samples.\n", I*4);
		if((I % 1024) == 0)
		{
			fprintf(stderr,"Received %d adc samples.\n", I*4);
		}

		if(I == (32*1024))
			break;
	}

	fclose(adc_fp);
}
