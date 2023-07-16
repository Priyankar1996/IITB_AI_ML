set AHIR_RELEASE $::env(AHIR_RELEASE)
#set AJIT_PROJECT_HOME $::env(AJIT_PROJECT_HOME)

#create project -in memroy
read_vhdl -library aHiR_ieee_proposed $AHIR_RELEASE/vhdl/aHiR_ieee_proposed.vhdl
read_vhdl -library ahir $AHIR_RELEASE/vhdl/ahir.vhdl
read_vhdl -library GenericGlueStuff ../vhdl_libs/GenericGlueStuff.vhdl
read_vhdl -library GlueModules ../vhdl_libs/GlueModules.vhdl
read_vhdl -library GenericCoreAddOnLib ../vhdl_libs/GenericCoreAddOnLib.vhdl
read_vhdl -library myUartLib ../vhdl_libs/myUartLib.vhdl
read_vhdl -library simpleUartLib ../vhdl_libs/simpleUartLib.vhdl
read_vhdl -library AjitCustom ../vhdl_libs/AjitCustom.vhdl
#
#read_vhdl -library peripherals_lib ../vhdl/peripherals.vhdl
#read_vhdl -library ajit_mcore_lib ../vhdl/mcore_4x2x64.vhdl
#read_vhdl -library ajit_processor_lib ../vhdl/processor_4x2x64.vhdl


read_vhdl -library AiMlAddons ../ahir/src/lib/AiMlAddons.vhdl
read_vhdl -library AxiBridgeLib ../vhdl_libs/AxiBridgeLib.vhdl
read_verilog ../verilog_libs/ACB_to_UI_EA.v
read_vhdl -library work ../ahir/ahir_system_global_package.vhdl
read_vhdl -library work ../ahir/ahir_system.vhdl

# fpga_top
#read_vhdl -library work ../top_level/fpga_top.vhdl
read_vhdl -library work ../top_level/fpga_ahir.vhdl

############# CONSTRAINT FILES ###########
read_xdc ./clocking.xdc 
read_xdc ../constraints/vcu128_constraints.xdc

############# IP CORE FILES #############
set_property part xcvu37p-fsvh2892-2L-e [current_project]
set_property board_part xilinx.com:vcu128:part0:1.2 [current_project]

# set up link to processor edn
#read_edif ../edif/core_2x64.edn
#read_edif processor_4x2x64.edn

# read ip
read_ip ../ip/virtual_reset/virtual_reset.srcs/sources_1/ip/vio_0/vio_0.xci
#read_ip ../ip/clocking_wizard_100Mhz/clocking_wizard_100Mhz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci 
#read_ip ../ip/clocking_wizard_120MHz/clocking_wizard_120MHz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci 
#read_ip ../ip/clocking_wizard_80MHz/clocking_wizard_80MHz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci 
read_ip ../ip/clocking_wizard_150Mhz/clocking_wizard_150Mhz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci 

############### SYNTHESIZE ##############
#synth_design -mode out_of_context -fsm_extraction off -top top_level -part xcvu37p-fsvh2892-2L-e
synth_design -fsm_extraction off -top top_level -part xcvu37p-fsvh2892-2L-e
write_checkpoint -force PostSynthCheckpoint.dcp
report_timing_summary -file timing.postsynth.rpt -nworst 10

report_utilization -file utilization_post_synth.rpt
report_utilization -hierarchical -file utilization_post_synth.hierarchical.rpt

# opt_design, place_design, phys_opt_design, route_design, write-bitstream.
# report timing, utililzation.

opt_design
place_design
phys_opt_design
phys_opt_design
route_design
phys_opt_design
phys_opt_design  -directive Explore

report_timing_summary -file timing.rpt -nworst 10 -verbose
report_utilization -file utilization_post_place_and_route.rpt
report_utilization -hierarchical -file utilization_post_place_and_route.hierarchical.rpt
write_bitstream -force tmp_ai_ml_accelerator.bit
write_debug_probes -force ./probes.ltx
