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


	if(argc < 5)
	{
		fprintf(stderr,"Usage: %s  <tty> < infile\n", 
				argv[0]);
		return(1);
	}

	signal(SIGINT,  Exit);
	signal(SIGTERM, Exit);

	setUartBlockingFlag(1);
	int tty_fd = setupDebugUartLink(argv[4]);
	if(tty_fd < 0)
	{
		fprintf(stderr,"Error: could not open uart %s\n", argv[5]);
		return (1);
	}
	

	while(!feof(stdin))
	{
		uint8_t x;
		int n = fscanf(stdin, "&x", x);
		if(n == EOF)
			break;

		tbSendUint8 (x);
	}

	return(0);
}
