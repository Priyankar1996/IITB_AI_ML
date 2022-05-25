#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>
#include <pthreadUtils.h>
#include <Pipes.h>
#include <pipeHandler.h>

#include "tb_utils.h"
#ifdef FPGA
#include "uart_interface.h"
#endif

void Exit(int sig)
{
	fprintf(stderr, "## Break! ##\n");
	exit(0);
}

int main(int argc, char* argv[])
{
	float result;
	int I, J;


	if(argc < 2)
	{
		fprintf(stderr,"Usage: %s  <tty> < infile\n", 
				argv[0]);
		return(1);
	}

	signal(SIGINT,  Exit);
	signal(SIGTERM, Exit);

	setUartBlockingFlag(1);
	int tty_fd = setupDebugUartLink(argv[1]);
	if(tty_fd < 0)
	{
		fprintf(stderr,"Error: could not open uart %s\n", argv[5]);
		return (1);
	}
	

	while(1)
	{
		uint16_t x;
		fscanf(stdin,"%hu",&x);
		if(x == 65535)
		break;
		tbSendUint16 (x);
		fprintf(stderr,"sent %hu.\n", x);
	}

	return(0);
}
