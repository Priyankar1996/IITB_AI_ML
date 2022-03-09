# build software version of testbench (to check the "desired behaviour")
AHIR_INCLUDE=$(AHIR_RELEASE)/include
AHIR_LIB=$(AHIR_RELEASE)/lib

SOCKETLIB_INCLUDE=$(AHIR_INCLUDE)
SOCKETLIB_LIB=$(AHIR_LIB)

PIPEHANDLER_INCLUDE=$(AHIR_INCLUDE)
PIPEHANDLER_LIB=$(AHIR_LIB)
PTHREADUTILS_INCLUDE=$(AHIR_INCLUDE)
VHDL_LIB=$(AHIR_RELEASE)/vhdl

SIZED_TENSOR=../../../primitives/include

all: SW HW 
LLVM2AAOPTS=-extract_do_while=true --storageinit=true -pipedepths=pipedepths.txt
#LLVM2AAOPTS=--storageinit=true


#PROGDEFS=-DUNROLLED
PROGDEFS=
TOPMODULES=-T timerDaemon -T maxPool3D -T maxPoolCore1 -T maxPoolCore2 -T maxPoolCore3 -T maxPoolCore4


# compile with SW defined.
# note the use of IOLIB in building the testbench.
SW: src/prog.c testbench.c 
	gcc -g -c -DSW $(PROGDEFS) -I$(PIPEHANDLER_INCLUDE) src/prog.c -I$(SIZED_TENSOR)/ -Isrc
	gcc -g -c -DSW $(PROGDEFS) -I$(PIPEHANDLER_INCLUDE) -I$(PTHREADUTILS_INCLUDE) -Isrc -I$(SIZED_TENSOR)/ testbench.c
	gcc -g -o testbench_sw prog.o testbench.o -L$(PIPEHANDLER_LIB) -lPipeHandler -lpthread

# five steps from C to vhdl simulator.
HW: c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl  vhdlsim
C2VHDL : c2llvmbc llvmbc2aa  aalink aa2vc  vc2vhdl
AA2VHDL: aa2vc vc2vhdl vhdlsim

# C to llvm byte-code.. use clang.
c2llvmbc: src/prog.c src/maxPoolOfTensors.h
	clang -O3 -std=gnu89 $(PROGDEFS)  -I$(SOCKETLIB_INCLUDE) -emit-llvm -c src/prog.c -I$(SIZED_TENSOR)
	opt --indvars --loopsimplify prog.o -o prog.opt.o
	llvm-dis prog.opt.o

# llvm byte-code to Aa..
llvmbc2aa:  prog.opt.o 
	llvm2aa $(LLVM2AAOPTS)  prog.opt.o | vcFormat >  prog.aa

# link and optimize
aalink:  timer.aa prog.aa
	AaLinkExtMem timer.aa prog.aa | vcFormat > prog.linked.aa
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

# build testbench and ghdl executable
# note the use of SOCKETLIB in building the testbench.
vhdlsim: TB GHDL
TB: testbench.c vhdlCStubs.h vhdlCStubs.c
	gcc -c vhdlCStubs.c -I./ -I$(SOCKETLIB_INCLUDE) -I$(SIZED_TENSOR) -Isrc
	gcc -c testbench.c -I./ -I$(SOCKETLIB_INCLUDE) -I$(SIZED_TENSOR) -Isrc
	gcc -o testbench_hw testbench.o vhdlCStubs.o  -L$(SOCKETLIB_LIB) -lSocketLibPipeHandler -lpthread

GHDL: ahir_system.vhdl ahir_system_test_bench.vhdl testbench.c vhdlCStubs.h vhdlCStubs.c
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
	rm -rf *.o* *.cf *.*vhdl vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw ahir_system_test_bench vhpi.log *.vc *.lso xst *.dot

PHONY: all clean	
