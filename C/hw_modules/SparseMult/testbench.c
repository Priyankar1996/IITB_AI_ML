#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>

#include "vhdlCStubs.h"


int main(int argc, char**argv){

	fprintf(stderr,"Entering testbench main program\n");
	fprintf(stderr,"Start time %ld\n", read_uint64("output_pipe"));
	int i_max = 100;
	
	for (int i = 1; i <= i_max; i++){
		if (i < i_max)
			write_uint64("input_pipe",7445858815525322822);
//			write_uint64("input_pipe",9064528483713091);
//			write_uint64("input_pipe",9007353879068739);
		else
			write_uint64("input_pipe",257);
		fprintf(stderr,"SENT element %d\n",i);
	}

	fprintf(stderr,"Time taken is for information load is %ld\n",read_uint64("output_pipe"));
	fprintf(stderr,"End time for computation is %ld\n",read_uint64("output_pipe"));

return 0;

}
