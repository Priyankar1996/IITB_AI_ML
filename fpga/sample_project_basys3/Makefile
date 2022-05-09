AHIR_INCLUDE=$(AHIR_RELEASE)/include
VHDL_LIB=$(AHIR_RELEASE)/vhdl
SOCKETLIB_INCLUDE=$(AHIR_INCLUDE)
SOCKETLIB_LIB=$(AHIR_LIB)

GHDL: ahir/ahir_system.vhdl toplevel/fpga_top.vhdl toplevel/fpga_top_tb.vhdl
	ghdl --clean
	ghdl --remove
	ghdl -i --work=GhdlLink  $(VHDL_LIB)/GhdlLink.vhdl
	ghdl -i --work=ahir  $(VHDL_LIB)/ahir.vhdl
	ghdl -i --work=aHiR_ieee_proposed  $(VHDL_LIB)/aHiR_ieee_proposed.vhdl
	ghdl -i --work=rtuart misc_vhdl/package.vhdl
	ghdl -i --work=work ahir/ahir_system_global_package.vhdl
	ghdl -i --work=work ahir/ahir_system.vhdl
	ghdl -i --work=work toplevel/fpga_top.vhdl
	ghdl -i --work=work toplevel/fpga_top_tb.vhdl
	ghdl -m --work=work fpga_top_tb
	
	