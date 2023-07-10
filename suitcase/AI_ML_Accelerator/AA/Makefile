# build software version of testbench (to check the "desired behaviour")
AHIR_INCLUDE=$(AHIR_RELEASE)/include
AHIR_LIB=$(AHIR_RELEASE)/lib

SOCKETLIB_INCLUDE=$(AHIR_INCLUDE)
SOCKETLIB_LIB=$(AHIR_LIB)

PIPEHANDLER_INCLUDE=$(AHIR_INCLUDE)
PIPEHANDLER_LIB=$(AHIR_LIB)
PTHREADUTILS_INCLUDE=$(AHIR_INCLUDE)
VHDL_LIB=$(AHIR_RELEASE)/vhdl

SRC=./src

all: HW 
LLVM2AAOPTS=-extract_do_while=true --storageinit=true -pipedepths=pipedepths.txt
#LLVM2AAOPTS=--storageinit=true

MODULES=src/acc_proc_test/pipes.aa src/accelerator_processor_interface.aa src/readWriteModules.aa src/ConvAll/conv_compiled.aa 
INCLUDES=-Isrc/ConvAll 

#PROGDEFS=-DUNROLLED
PROGDEFS=
TOPMODULES_ACC= -T accelerator_control_daemon -T accelerator_worker_daemon -T accelerator_interrupt_daemon  -T timerDaemon

# five steps from C to vhdl simulator.
HW: aalink aa2vc  vc2vhdl vhdlsim
AA2C : aalink aa2c aa2cbuild
HW: aalink aa2vc  vc2vhdl  vhdlsim

# C to llvm byte-code.. use clang.
c2llvmbc: src/prog.c
	clang -O3 -m32 -std=gnu89 $(PROGDEFS)  -I$(SOCKETLIB_INCLUDE) -emit-llvm -c src/prog.c $(INCLUDES)
	opt --indvars --loopsimplify prog.o -o prog.opt.o
	llvm-dis prog.opt.o

# llvm byte-code to Aa..
llvmbc2aa:  prog.opt.o 
	llvm2aa $(LLVM2AAOPTS)  prog.opt.o | vcFormat >  prog.aa

# link and optimize
aalink: src/timer.aa prog.aa $(MODULES)
	AaPreprocess -I src/ConvAll src/ConvAll/conv_macro.aa -o src/ConvAll/conv_compiled.aa
	AaLinkExtMem prog.aa src/timer.aa src/decl.aa $(MODULES) | vcFormat > prog.linked.aa
	AaOpt -C prog.linked.aa | vcFormat > prog.linked.C.opt.aa
	AaOpt -B prog.linked.C.opt.aa | vcFormat > prog.linked.opt.aa

# Aa to vC
aa2vc: prog.linked.opt.aa
	Aa2VC -O -C prog.linked.opt.aa | vcFormat > prog.vc

# vC to VHDL
vc2vhdl: prog.vc
	vc2vhdl -S 4 -O -I 8 -a -C -e ai_ml_engine -w -s ghdl $(TOPMODULES_ACC) -f prog.vc # -L src/lib/AiMlAddons.list
	vhdlFormat < ai_ml_engine_global_package.unformatted_vhdl > ai_ml_engine_global_package.vhdl
	vhdlFormat < ai_ml_engine.unformatted_vhdl > ai_ml_engine.vhdl
	rm -f *unformatted_vhdl

vhdlsim: TB GHDL
TB: testbench.c vhdlCStubs.h vhdlCStubs.c
	gcc -c vhdlCStubs.c -I./ -I$(SOCKETLIB_INCLUDE) -Isrc
	gcc -c testbench.c -I./ -I$(SOCKETLIB_INCLUDE) -Isrc
	gcc -o testbench_hw testbench.o vhdlCStubs.o  -L$(SOCKETLIB_LIB) -lSocketLibPipeHandler -lpthread

GHDL: ai_ml_engine.vhdl ai_ml_engine_test_bench.vhdl testbench.c vhdlCStubs.h vhdlCStubs.c
	ghdl --clean
	ghdl --remove
	ghdl -i --work=GhdlLink  $(VHDL_LIB)/GhdlLink.vhdl
	ghdl -i --work=ahir  $(VHDL_LIB)/ahir.vhdl
	ghdl -i --work=aHiR_ieee_proposed  $(VHDL_LIB)/aHiR_ieee_proposed.vhdl
	ghdl -i --work=work ahir_system_global_package.vhdl
	ghdl -i --work=work ahir_system.vhdl
	ghdl -i --work=work ahir_system_test_bench.vhdl
	ghdl -m --work=work -Wl,-L$(SOCKETLIB_LIB) -Wl,-lVhpi ahir_system_test_bench 

clean:
	rm -rf *.o* *.cf *.*vhdl vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw ahir_system_test_bench vhpi.log *.vc *.lso xst *.dot *.aa

PHONY: all clean
