# build software version of testbench (to check the "desired behaviour")
AHIR_INCLUDE=$(AHIR_RELEASE)/include
AHIR_LIB=$(AHIR_RELEASE)/lib

SOCKETLIB_INCLUDE=$(AHIR_INCLUDE)
SOCKETLIB_LIB=$(AHIR_LIB)

PIPEHANDLER_INCLUDE=$(AHIR_INCLUDE)
PIPEHANDLER_LIB=$(AHIR_LIB)
PTHREADUTILS_INCLUDE=$(AHIR_INCLUDE)
VHDL_LIB=$(AHIR_RELEASE)/vhdl

FPGA=../../../../fpga/Aman_convolution/ahir

CONVH_FILE=convolution_multipipe.h
CONVAA_FILE=src/conv.aa

SIZED_TENSOR=../../../primitives/include

all: HW 
LLVM2AAOPTS=-extract_do_while=true --storageinit=true -pipedepths=pipedepths.txt
#LLVM2AAOPTS=--storageinit=true


#PROGDEFS=-DUNROLLED
PROGDEFS=
TOPMODULES=-T timerDaemon -T topModule
SRC=./

# five steps from C to vhdl simulator.
HW: aalink aa2vc  vc2vhdl  vhdlsim
C2VHDL : aalink aa2vc  vc2vhdl
fpga : aalink aa2vc  fpga_vc2vhdl
AA2VHDL: aa2vc vc2vhdl vhdlsim
AA2C : aalink aa2c aa2cbuild
# link and optimize
aalink:  src/timer.aa src/prog.aa src/*
	AaPreprocess -I src/ src/conv_macro.aa -o conv_2.aa
	AaLinkExtMem src/timer.aa src/prog.aa conv_2.aa| vcFormat > prog.linked.aa
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

fpga_vc2vhdl: prog.vc
	vc2vhdl -S 4 -O -I 8 -v -a -C -e ahir_system -w -s ghdl $(TOPMODULES) -f prog.vc 
	vhdlFormat < ahir_system_global_package.unformatted_vhdl > $(FPGA)/ahir_system_global_package.vhdl
	vhdlFormat < ahir_system.unformatted_vhdl > $(FPGA)/ahir_system.vhdl
	vhdlFormat < ahir_system_test_bench.unformatted_vhdl > $(FPGA)/ahir_system_test_bench.vhdl

aa2c: prog.linked.opt.aa
	Aa2C $(TOPMODULES) -o aa2c prog.linked.opt.aa

aa2cbuild: aa2c/aa_c_model.c  aa2c/aa_c_model_internal.h aa2c/aa_c_model.h
	gcc -g -c -DSW -I$(PIPEHANDLER_INCLUDE) -Iaa2c/ aa2c/aa_c_model.c -o aa2c/aa_c_model.o
	gcc -g -c -DSW -I$(PIPEHANDLER_INCLUDE) -I$(PTHREADUTILS_INCLUDE) -I$(SIZED_TENSOR) -Iaa2c/ -I$(SRC) $(SRC)/testbench.c -o aa2c/testbench.o
	gcc -g -o testbench_sw aa2c/aa_c_model.o aa2c/testbench.o -L$(PIPEHANDLER_LIB) -lPipeHandler -lpthread -lBitVectors -lSockPipes


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
	rm -rf *.o* *.cf *.*vhdl vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw ahir_system_test_bench vhpi.log *.vc *.lso xst *.dot *.aa aa2c/*

PHONY: all clean	
