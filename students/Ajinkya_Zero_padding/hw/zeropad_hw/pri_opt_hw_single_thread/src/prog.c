#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <Pipes.h>
#include "pipeHandler.h"
#include "sized_tensor.h"
#include "zero_pad_opt.h"


SizedTensor_16K T,R;
TensorDescriptor des_inp,des_out;

#ifndef SW
void __loop_pipelining_on__(uint32_t pipeline_depth, uint32_t buffering, uint32_t full_rate);
	#define __loop_pipeline_var__ __loop_pipelining_on__(15,1,1);
void __aa_barrier__();
#else
	#define __loop_pipeline_var__ {;}
	#define __aa_barrier__() {;}
#endif

#define __dt__ int16_t

#define __get4xi16__(element) ({\
	element = read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
	element = (element << 8) + read_uint8 ("zeropad_input_pipe");\
})

#define __set4xi16__(addr) ({\
	uint64_t element = R.data_array[addr];\
	uint8_t out_data[8];\
	out_data[7] = element & 0xFF;\
	element>>=8;\
	out_data[6] = element & 0xFF;\
	element>>=8;\
	out_data[5]= element & 0xFF;\
	element>>=8;\
    out_data[4] = element & 0xFF;\
	element>>=8;\
	out_data[3] = element & 0xFF;\
	element>>=8;\
	out_data[2] = element & 0xFF;\
	element>>=8;\
    out_data[1] = element & 0xFF;\
	element>>=8;\
	out_data[0] = element & 0xFFFF;\
	write_uint8 ("zeropad_output_pipe",out_data[0]);\
	write_uint8 ("zeropad_output_pipe",out_data[1]);\
	write_uint8 ("zeropad_output_pipe",out_data[2]);\
	write_uint8 ("zeropad_output_pipe",out_data[3]);\
	write_uint8 ("zeropad_output_pipe",out_data[4]);\
	write_uint8 ("zeropad_output_pipe",out_data[5]);\
	write_uint8 ("zeropad_output_pipe",out_data[6]);\
	write_uint8 ("zeropad_output_pipe",out_data[7]);\
})


void sendOutput(size)
{
    int i;
    for (i = 0; i < (size >> 2); i++){
        __set4xi16__(i);
    }
}

void zeropad3D_A()
{
    uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
    row_high = read_uint8 ("Block0_starting");
    col_high = read_uint8 ("Block0_starting");
    depth_high = read_uint8 ("Block0_starting");    
	out_row_high = read_uint8 ("Block0_starting");
    out_col_high = read_uint8 ("Block0_starting");
    out_depth_high = read_uint8 ("Block0_starting");
    pad = read_uint8 ("Block0_starting");
    #ifdef SW
        fprintf(stderr,"Block-0 started.\n");
    #endif
    __aa_barrier__();
    __zero_pad_opt__(0,(row_high),
                               0,(col_high),0,depth_high,row_high,
                               col_high,depth_high,out_row_high,
                                 out_col_high,out_depth_high,T,pad,R);
    __aa_barrier__();
    #ifdef SW
	    fprintf(stderr,"Block-0 done.\n");
    #endif
	write_uint8 ("Block0_complete", 1);
}

// void zeropad3D_B()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block1_starting");
//     col_high = read_uint8 ("Block1_starting");
//     depth_high = read_uint8 ("Block1_starting");    
// 	out_row_high = read_uint8 ("Block1_starting");
//     out_col_high = read_uint8 ("Block1_starting");
//     out_depth_high = read_uint8 ("Block1_starting");
//     pad = read_uint8 ("Block1_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-1 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__(0,(row_high/2),
//                             (col_high/2),
//                             col_high,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();
//     #ifdef SW
//         fprintf(stderr,"Block-1 done.\n");
//     #endif
//     write_uint8 ("Block1_complete", 1);
// }

// void zeropad3D_C()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block2_starting");
//     col_high = read_uint8 ("Block2_starting");
//     depth_high = read_uint8 ("Block2_starting");    
// 	out_row_high = read_uint8 ("Block2_starting");
//     out_col_high = read_uint8 ("Block2_starting");
//     out_depth_high = read_uint8 ("Block2_starting");
//     pad = read_uint8 ("Block2_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-2 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__((row_high/2),
//                                row_high,0,
//                                (col_high/2),0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();
//     #ifdef SW
//         fprintf(stderr,"Block-2 done.\n");
//     #endif
//     write_uint8 ("Block2_complete", 1);
// }

// void zeropad3D_D()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block3_starting");
//     col_high = read_uint8 ("Block3_starting");
//     depth_high = read_uint8 ("Block3_starting");    
// 	out_row_high = read_uint8 ("Block3_starting");
//     out_col_high = read_uint8 ("Block3_starting");
//     out_depth_high = read_uint8 ("Block3_starting");
//     pad = read_uint8 ("Block3_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-3 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__((row_high/2),
//                                row_high,
//                                (col_high/2),
//                                col_high,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();    
//     #ifdef SW
//         fprintf(stderr,"Block-3 done.\n");
//     #endif
//     write_uint8 ("Block3_complete", 1);
// }

// void zeropad3D_E()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block4_starting");
//     col_high = read_uint8 ("Block4_starting");
//     depth_high = read_uint8 ("Block4_starting");    
// 	out_row_high = read_uint8 ("Block4_starting");
//     out_col_high = read_uint8 ("Block4_starting");
//     out_depth_high = read_uint8 ("Block4_starting");
//     pad = read_uint8 ("Block4_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-4 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__((row_high/2),
//                                3*(row_high)/4,
//                                0,
//                                (col_high)/2,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();    
//     #ifdef SW
//         fprintf(stderr,"Block-4 done.\n");
//     #endif
//     write_uint8 ("Block4_complete", 1);
// }

// void zeropad3D_F()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block5_starting");
//     col_high = read_uint8 ("Block5_starting");
//     depth_high = read_uint8 ("Block5_starting");    
// 	out_row_high = read_uint8 ("Block5_starting");
//     out_col_high = read_uint8 ("Block5_starting");
//     out_depth_high = read_uint8 ("Block5_starting");
//     pad = read_uint8 ("Block5_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-5 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__((row_high/2),
//                                3*(row_high)/4,
//                                (col_high/2),
//                                col_high,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();    
//     #ifdef SW
//         fprintf(stderr,"Block-5 done.\n");
//     #endif
//     write_uint8 ("Block5_complete", 1);
// }

// void zeropad3D_G()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block6_starting");
//     col_high = read_uint8 ("Block6_starting");
//     depth_high = read_uint8 ("Block6_starting");    
// 	out_row_high = read_uint8 ("Block6_starting");
//     out_col_high = read_uint8 ("Block6_starting");
//     out_depth_high = read_uint8 ("Block6_starting");
//     pad = read_uint8 ("Block6_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-6 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__(3*(row_high/4),
//                                row_high,
//                                0,
//                                (col_high)/2,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();    
//     #ifdef SW
//         fprintf(stderr,"Block-6 done.\n");
//     #endif
//     write_uint8 ("Block6_complete", 1);
// }

// void zeropad3D_H()
// {
//     uint8_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high,pad;
//     row_high = read_uint8 ("Block7_starting");
//     col_high = read_uint8 ("Block7_starting");
//     depth_high = read_uint8 ("Block7_starting");    
// 	out_row_high = read_uint8 ("Block7_starting");
//     out_col_high = read_uint8 ("Block7_starting");
//     out_depth_high = read_uint8 ("Block7_starting");
//     pad = read_uint8 ("Block7_starting");
//     #ifdef SW
//         fprintf(stderr,"Block-7 started.\n");
//     #endif
//     __aa_barrier__();
//     __zero_pad_opt__((3*(row_high)/4),
//                                row_high,
//                                (col_high/2),
//                                col_high,0,depth_high,row_high,
//                                col_high,depth_high,out_row_high,
//                                  out_col_high,out_depth_high,T,pad,R);
//     __aa_barrier__();    
//     #ifdef SW
//         fprintf(stderr,"Block-7 done.\n");
//     #endif
//     write_uint8 ("Block7_complete", 1);
// }
    
void zeropad3D()
{
    uint16_t row_high,col_high,depth_high,out_row_high,out_col_high,out_depth_high;
    uint8_t pad;
    // des_inp.data_type = i16;
    uint16_t row_major_form = read_uint8 ("zeropad_input_pipe");
    row_major_form = (row_major_form << 8) + read_uint8 ("zeropad_input_pipe");
    uint16_t number_of_dimensions = read_uint8 ("zeropad_input_pipe");
    number_of_dimensions = (number_of_dimensions << 8) + read_uint8 ("zeropad_input_pipe");
    int i;
    // for(i = 0;i < des_inp.number_of_dimensions;i++){
    //     des_inp.dimensions[i] = read_uint8 ("zeropad_input_pipe");
    // }
    row_high = read_uint8 ("zeropad_input_pipe");
    row_high = (row_high << 8) + read_uint8 ("zeropad_input_pipe");
    col_high = read_uint8 ("zeropad_input_pipe");
    col_high = (col_high << 8) + read_uint8 ("zeropad_input_pipe");
    depth_high = read_uint8 ("zeropad_input_pipe");
    depth_high = (depth_high << 8) + read_uint8 ("zeropad_input_pipe");

    pad = read_uint8 ("zeropad_input_pipe");
    
	out_row_high = read_uint8 ("zeropad_input_pipe");
    out_row_high = (out_row_high << 8) + read_uint8 ("zeropad_input_pipe");
    out_col_high = read_uint8 ("zeropad_input_pipe");
    out_col_high = (out_col_high << 8) + read_uint8 ("zeropad_input_pipe");
    out_depth_high = read_uint8 ("zeropad_input_pipe");
    out_depth_high = (out_depth_high << 8) + read_uint8 ("zeropad_input_pipe");
    
	// uint64_t input_size = __NumberOfElementsInSizedTensor__(T);
    uint64_t input_size = row_high*col_high*depth_high;
    
    for(i = 0; i < (input_size >> 3); i ++)
    {
        uint64_t element;
        __get4xi16__(element);
        T.data_array[i] = element;
    }

#ifndef SW
    __aa_barrier__();
    uint64_t start_time = timer();
    __aa_barrier__();
#endif
    write_uint8("Block0_starting", row_high);
    write_uint8("Block0_starting", col_high);
    write_uint8("Block0_starting", depth_high);
    write_uint8("Block0_starting", out_row_high);
    write_uint8("Block0_starting", out_col_high);
    write_uint8("Block0_starting", out_depth_high);
    write_uint8("Block0_starting", pad);
    
    // write_uint8("Block1_starting", row_high);
    // write_uint8("Block1_starting", col_high);
    // write_uint8("Block1_starting", depth_high);
    // write_uint8("Block1_starting", out_row_high);
    // write_uint8("Block1_starting", out_col_high);
    // write_uint8("Block1_starting", out_depth_high);
    // write_uint8("Block1_starting", pad);

    // write_uint8("Block2_starting", row_high);
    // write_uint8("Block2_starting", col_high);
    // write_uint8("Block2_starting", depth_high);
    // write_uint8("Block2_starting", out_row_high);
    // write_uint8("Block2_starting", out_col_high);
    // write_uint8("Block2_starting", out_depth_high);
    // write_uint8("Block2_starting", pad);

    // write_uint8("Block3_starting", row_high);
    // write_uint8("Block3_starting", col_high);
    // write_uint8("Block3_starting", depth_high);
    // write_uint8("Block3_starting", out_row_high);
    // write_uint8("Block3_starting", out_col_high);
    // write_uint8("Block3_starting", out_depth_high);
    // write_uint8("Block3_starting", pad);

    // write_uint8("Block4_starting", row_high);
    // write_uint8("Block4_starting", col_high);
    // write_uint8("Block4_starting", depth_high);
    // write_uint8("Block4_starting", out_row_high);
    // write_uint8("Block4_starting", out_col_high);
    // write_uint8("Block4_starting", out_depth_high);
    // write_uint8("Block4_starting", pad);

    // write_uint8("Block5_starting", row_high);
    // write_uint8("Block5_starting", col_high);
    // write_uint8("Block5_starting", depth_high);
    // write_uint8("Block5_starting", out_row_high);
    // write_uint8("Block5_starting", out_col_high);
    // write_uint8("Block5_starting", out_depth_high);
    // write_uint8("Block5_starting", pad);

    // write_uint8("Block6_starting", row_high);
    // write_uint8("Block6_starting", col_high);
    // write_uint8("Block6_starting", depth_high);
    // write_uint8("Block6_starting", out_row_high);
    // write_uint8("Block6_starting", out_col_high);
    // write_uint8("Block6_starting", out_depth_high);
    // write_uint8("Block6_starting", pad);

    // write_uint8("Block7_starting", row_high);
    // write_uint8("Block7_starting", col_high);
    // write_uint8("Block7_starting", depth_high);
    // write_uint8("Block7_starting", out_row_high);
    // write_uint8("Block7_starting", out_col_high);
    // write_uint8("Block7_starting", out_depth_high);
    // write_uint8("Block7_starting", pad);

    __aa_barrier__();

    uint16_t s0 = read_uint8("Block0_complete");
    // uint16_t s1 = read_uint8("Block1_complete");
    // uint16_t s2 = read_uint8("Block2_complete");
    // uint16_t s3 = read_uint8("Block3_complete");
    // uint16_t s4 = read_uint8("Block4_complete");
    // uint16_t s5 = read_uint8("Block5_complete");
    // uint16_t s6 = read_uint8("Block6_complete");
    // uint16_t s7 = read_uint8("Block7_complete"); 


    __aa_barrier__();
#ifndef SW
    uint64_t stop_time = timer();
    uint64_t elapsed_time = stop_time - start_time;
    __aa_barrier__();
	uint8_t time_data[8];
	time_data[7] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[6] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[5] = elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[4] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[3] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[2] = elapsed_time & 0xFF;
	elapsed_time>>=8;
    time_data[1] = elapsed_time & 0xFF;
	elapsed_time>>=8;
	time_data[0] = elapsed_time & 0xFF;
	write_uint8 ("zeropad_output_pipe",time_data[0]);
	write_uint8 ("zeropad_output_pipe",time_data[1]);
	write_uint8 ("zeropad_output_pipe",time_data[2]);
	write_uint8 ("zeropad_output_pipe",time_data[3]);
    write_uint8 ("zeropad_output_pipe",time_data[4]);
	write_uint8 ("zeropad_output_pipe",time_data[5]);
	write_uint8 ("zeropad_output_pipe",time_data[6]);
	write_uint8 ("zeropad_output_pipe",time_data[7]);
#endif    
    __aa_barrier__();

    sendOutput(out_row_high * out_col_high * out_depth_high); 
}
