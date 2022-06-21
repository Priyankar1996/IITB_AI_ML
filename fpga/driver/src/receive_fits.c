#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <pthreadUtils.h>
#include <Pipes.h>
#include <pipeHandler.h>


int main(int argc, char* argv[])
{
	while(1)
	{
		uint8_t r;
		r = tbGetUint8();
		fprintf(stdout,"%hhu\n", r);
	}
}

