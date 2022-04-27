#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include "tb_utils.h"
#include "uart_interface.h"

int main(int argc, char* argv[])
{
	if(argc < 2)
	{
		fprintf(stderr,"Usage: %s /dev/ttyUSBx [byte-to-be-sent-repeatedly] \n", argv[0]);
		return(1);
	}

	
 	setUartBlockingFlag(1);
        int tty_fd = setupDebugUartLink(argv[1]);
        if(tty_fd < 0)
        {
                fprintf(stderr,"Error: could not open uart %s\n", argv[1]);
                return (1);
        }

	uint8_t b = 0;
	if(argc > 2)
	{
		b = atoi (argv[2]);
		fprintf(stderr,"Info: byte being sent repeatedly is 0x%x\n", b);
	}
		
	tbSendUint8 (b, stdout);
	return(0);
}
