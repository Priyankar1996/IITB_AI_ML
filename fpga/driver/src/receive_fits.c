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
		uint32_t r;
		int n = fscanf(stdin,"0x%x", &r);
		if( n == EOF)
			break;

		fprintf(stdout," 0x%x ", r & 0xff);

	}
}
