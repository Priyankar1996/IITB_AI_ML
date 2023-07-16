read_vhdl -library aHiR_ieee_proposed ../vhdl_libs/aHiR_ieee_proposed.vhdl
read_vhdl -library ahir ../vhdl_libs/ahir.vhdl
read_vhdl -library GenericGlueStuff ../vhdl_libs/GenericGlueStuff.vhdl
read_vhdl -library GlueModules ../vhdl_libs/GlueModules.vhdl
read_vhdl -library GenericCoreAddOnLib ../vhdl_libs/GenericCoreAddOnLib.vhdl
read_vhdl -library myUartLib ../vhdl_libs/myUartLib.vhdl
read_vhdl -library simpleUartLib ../vhdl_libs/simpleUartLib.vhdl
read_vhdl -library AjitCustom ../vhdl_libs/AjitCustom.vhdl
read_vhdl -library peripherals_lib ../vhdl/peripherals.vhdl
read_vhdl -library ajit_mcore_lib ../vhdl/mcore_4x2x64.vhdl
read_vhdl -library ajit_processor_lib ../vhdl/processor_4x2x64.vhdl
read_edif ../edif/core_2x64.edn
read_xdc ./clocking.xdc 
#synth_design -mode out_of_context -fsm_extraction off -top processor_4x2x64 -part xc7vx690t-ffg1761-2
synth_design -mode out_of_context -fsm_extraction off -top processor_4x2x64 -part xcvu37p-fsvh2892-2L-e
write_edif -force processor_4x2x64.edn
report_timing_summary -file timing.postsynth.rpt -nworst 10
report_utilization -file utilization_post_synth.rpt
report_utilization -hierarchical -file utilization_post_synth.hierarchical.rpt
