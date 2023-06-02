# build software version of testbench (to check the "desired behaviour")
AHIR_INCLUDE=$(AHIR_RELEASE)/include
AHIR_LIB=$(AHIR_RELEASE)/lib

SOCKETLIB_INCLUDE=$(AHIR_INCLUDE)
SOCKETLIB_LIB=$(AHIR_LIB)

PIPEHANDLER_INCLUDE=$(AHIR_INCLUDE)
PIPEHANDLER_LIB=$(AHIR_LIB)
PTHREADUTILS_INCLUDE=$(AHIR_INCLUDE)
VHDL_LIB=$(AHIR_RELEASE)/vhdl

SIZED_TENSOR=../../../C/primitives/include
SRC=./src

all: HW 
LLVM2AAOPTS=-extract_do_while=true --storageinit=true -pipedepths=pipedepths.txt
#LLVM2AAOPTS=--storageinit=true

MODULES=src/acc_proc_test/pipes.aa src/acc_proc_test/tester.aa src/accelerator_processor_interface.aa src/readWriteModules.aa src/ConvAll/conv_compiled.aa 
# src/concat/concat.aa src/convTranspose/ct_core.aa
INCLUDES=-Isrc/ConvAll 
# -Isrc/concat -Isrc/convTranspose

#PROGDEFS=-DUNROLLED
PROGDEFS=
TOPMODULES=-T systemTOP -T timerDaemon -T accelerator_control_daemon -T accelerator_worker_daemon  -T interrupt_daemon -T accelerator_interrupt_daemon -T tester_control_daemon

# five steps from C to vhdl simulator.
HW: c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl
C2VHDL : c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl
AA2VHDL: aalink aa2vc vc2vhdl
AA2C : c2llvmbc llvmbc2aa aalink aa2c aa2cbuild

# C to llvm byte-code.. use clang.
c2llvmbc: src/prog.c
	clang -O3 -m32 -std=gnu89 $(PROGDEFS)  -I$(SOCKETLIB_INCLUDE) -emit-llvm -c src/prog.c -I$(SIZED_TENSOR) $(INCLUDES)
	opt --indvars --loopsimplify prog.o -o prog.opt.o
	llvm-dis prog.opt.o

# llvm byte-code to Aa..
llvmbc2aa:  prog.opt.o 
	llvm2aa $(LLVM2AAOPTS)  prog.opt.o | vcFormat >  prog.aa

# link and optimize
aalink: src/timer.aa prog.aa $(MODULES)
	AaPreprocess -I src/ConvAll src/ConvAll/conv_macro.aa -o src/ConvAll/conv_compiled.aa
	AaLinkExtMem src/timer.aa src/decl.aa $(MODULES) prog.aa | vcFormat > prog.linked.aa
	AaOpt -C prog.linked.aa | vcFormat > prog.linked.C.opt.aa
	AaOpt -B prog.linked.C.opt.aa | vcFormat > prog.linked.opt.aa

# Aa to vC
aa2vc: prog.linked.opt.aa
	Aa2VC -O -C prog.linked.opt.aa | vcFormat > prog.vc

# vC to VHDL
vc2vhdl: prog.vc
	vc2vhdl -S 4 -O -I 8 -a -C -e ahir_system -w -s ghdl $(TOPMODULES) -f prog.vc -L src/lib/AiMlAddons.list
	vhdlFormat < ahir_system_global_package.unformatted_vhdl > ahir_system_global_package.vhdl
	vhdlFormat < ahir_system.unformatted_vhdl > ahir_system.vhdl
	vhdlFormat < ahir_system_test_bench.unformatted_vhdl > ahir_system_test_bench.vhdl
	rm -f *unformatted_vhdl

aa2c: prog.linked.opt.aa
	Aa2C $(TOPMODULES) -o aa2c prog.linked.opt.aa

aa2cbuild: aa2c/aa_c_model.c  aa2c/aa_c_model_internal.h aa2c/aa_c_model.h
	gcc -g -c -DSW -I$(PIPEHANDLER_INCLUDE) -Iaa2c/ aa2c/aa_c_model.c -o aa2c/aa_c_model.o
	gcc -g -c -DSW -I$(PIPEHANDLER_INCLUDE) -I$(PTHREADUTILS_INCLUDE) -Iaa2c/ -I$(SRC) $(SRC)/testbench.c -o aa2c/testbench.o
	gcc -g -o testbench_sw aa2c/aa_c_model.o aa2c/testbench.o -L$(PIPEHANDLER_LIB) -lPipeHandler -lpthread -lBitVectors -lSockPipes

clean:
	rm -rf *.o* *.cf *.*vhdl vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw ahir_system_test_bench vhpi.log *.vc *.lso xst *.dot *.aa

PHONY: all clean
