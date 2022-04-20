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

all: HW 
LLVM2AAOPTS=-extract_do_while=true --storageinit=true -pipedepths=pipedepths.txt
#LLVM2AAOPTS=--storageinit=true


#PROGDEFS=-DUNROLLED
PROGDEFS=
TOPMODULES=-T zeropad3D -T zeropad3D_A -T zeropad3D_B -T zeropad3D_C -T zeropad3D_D -T zeropad3D_E -T zeropad3D_F -T zeropad3D_G -T zeropad3D_H

# five steps from C to vhdl simulator.
HW: c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl
C2VHDL : c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl
AA2VHDL: aa2vc vc2vhdl vhdlsim

# C to llvm byte-code.. use clang.
c2llvmbc: src/prog.c src/zero_pad_opt.h
	clang -O3 -std=gnu89 $(PROGDEFS)  -I$(SOCKETLIB_INCLUDE) -emit-llvm -c src/prog.c -I$(SIZED_TENSOR)
	opt --indvars --loopsimplify prog.o -o prog.opt.o
	llvm-dis prog.opt.o

# llvm byte-code to Aa..
llvmbc2aa:  prog.opt.o 
	llvm2aa $(LLVM2AAOPTS)  prog.opt.o | vcFormat >  prog.aa

# link and optimize
aalink: prog.aa
	AaLinkExtMem prog.aa | vcFormat > prog.linked.aa
	AaOpt -C prog.linked.aa | vcFormat > prog.linked.C.opt.aa
	AaOpt -B prog.linked.C.opt.aa | vcFormat > prog.linked.opt.aa

# Aa to vC
aa2vc: prog.linked.opt.aa
	Aa2VC -O -C prog.linked.opt.aa | vcFormat > prog.vc

# vC to VHDL
vc2vhdl: prog.vc
	vc2vhdl -D -S 4 -O -I 8 -v -a -C -e ahir_system -w -s ghdl $(TOPMODULES) -f prog.vc 
	vhdlFormat < ahir_system_global_package.unformatted_vhdl > ahir_system_global_package.vhdl
	vhdlFormat < ahir_system.unformatted_vhdl > ahir_system.vhdl
	vhdlFormat < ahir_system_test_bench.unformatted_vhdl > ahir_system_test_bench.vhdl
	rm -f *unformatted_vhdl

clean:
	rm -rf *.o* *.cf vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw ahir_system_test_bench vhpi.log *.vc *.lso xst *.dot *.aa

PHONY: all clean	
