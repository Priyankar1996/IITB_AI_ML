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
	int count = 0;
	while(count < 18496)
	{
		uint16_t r;
		r = tbGetUint8();
		fprintf(stdout,"%hu\n", r);
		count++;
	}
}

