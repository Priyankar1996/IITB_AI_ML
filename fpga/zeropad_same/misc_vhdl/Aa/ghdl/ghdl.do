ghdl -i --work=ahir_ieee_proposed $AHIR_RELEASE/vhdl/aHiR_ieee_proposed.vhdl
ghdl -i --work=ahir $AHIR_RELEASE/vhdl/ahir.vhdl
ghdl -i --work=AjitCustom ../vhdl/AjitCustom/baud_control_calculator_global_package.vhdl
ghdl -i --work=AjitCustom ../vhdl/AjitCustom/baud_control_calculator.vhdl
ghdl -i test_bench.vhdl
ghdl -m test_bench
