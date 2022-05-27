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
		uint16_t r;
		r = tbGetUint16();
		fprintf(stdout,"%hu\n", r);
	}
}
