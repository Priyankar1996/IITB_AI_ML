# build software version of testbench (to check the "desired behaviour")
AHIR_INCLUDE=$(AHIR_RELEASE)/include
AHIR_LIB=$(AHIR_RELEASE)/lib
VHDL_LIB=$(AHIR_RELEASE)/vhdl
SRC=./src
all: HW 
TOVC:aalink aa2vc 
VC2VHDL: vc2vhdl  vhdlsim
AA2VHDLSIM: aa2vc  vc2vhdl  vhdlsim
TOVHDL:TOVC vc2vhdl


TOPMODULES=-T baudControlCalculatorDaemon



# five steps from C to vhdl simulator.
HW: aalink aa2vc  vc2vhdl  

AA2VHDL: aa2vc vc2vhdl 

# Aa to vC
aalink: $(SRC)/core.aa 
	AaLinkExtMem $(SRC)/core.aa | vcFormat > core.linked.aa
	AaOpt -B core.linked.aa | vcFormat > core.linked.opt.aa

aa2vc: core.linked.opt.aa
	Aa2VC -O -C core.linked.opt.aa | vcFormat > core.vc

# vC to VHDL
vc2vhdl: core.vc
	vc2vhdl -H -O -S 4 -I 2 -a -C -e baud_control_calculator -W AjitCustom -w -s ghdl $(TOPMODULES) -f core.vc 
	rm -rf vhdl
	mkdir vhdl
	mkdir vhdl/AjitCustom
	vhdlFormat < baud_control_calculator_global_package.unformatted_vhdl > vhdl/AjitCustom/baud_control_calculator_global_package.vhdl
	vhdlFormat < baud_control_calculator.unformatted_vhdl > vhdl/AjitCustom/baud_control_calculator.vhdl
	vhdlFormat < baud_control_calculator_test_bench.unformatted_vhdl > vhdl/AjitCustom/baud_control_calculator_test_bench.vhdl
	rm *.unformatted_vhdl

clean:
	rm -rf *.o* *.cf *.*vhdl vhdlCStubs.* *.vcd in_data* out_data* testbench_sw testbench_hw afb_axi_core_test_bench vhpi.log *.aa *.vc *.lso xst *.ngc *_xmsgs *.xrpt pipeHandler.log *.srp *.ghw *.dot

PHONY: all clean	
