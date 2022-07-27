# edit this to pick up lib vhdl files from ../vhdl_libs
read_vhdl -library ahir ../vhdl_libs/ahir.vhdl
read_vhdl -library ahir_ieee_proposed ../vhdl_libs/aHiR_ieee_proposed.vhdl
# etc...
read_vhdl -library AjitCustom ../vhdl_libs/AjitCustom.vhdl
read_vhdl -library simpleUartLib ../vhdl_libs/simpleUartLib.vhdl
read_vhdl -library GenericCoreAddonLib ../vhdl_libs/GenericCoreAddOnLib.vhdl
read_vhdl -library GenericGlueStuff ../vhdl_libs/GenericGlueStuff.vhdl
read_vhdl -library GlueModules ../vhdl_libs/GlueModules.vhdl
read_vhdl -library AxiBridgeLib ../vhdl_libs/AxiBridgeLib.vhdl

read_verilog ../verilog_libs/ACB_to_UI_EA.v
# the wrapper..
read_vhdl -library work ../vhdl/toplevel_1x2x32.vhdl


############# CONSTRAINT FILE ###########
read_xdc ../constraints/kc705_dram_spi_flash_xadc.xdc

############# IP CORE FILES #############
set_property part xc7k325tffg900-2 [current_project]
set_property board_part xilinx.com:kc705:part0:1.1 [current_project]

################### standlone proto core ################
# read from ../ip/
read_ip ../ip/mig_7series_0/mig_7series_0.xci
read_ip ../ip/ila/ila_0/ila_0.xci
read_ip ../ip/clk_wiz_0/clk_wiz_0.xci
read_ip ../ip/fifo_generator_1/fifo_generator_1.xci
read_ip ../ip/fifo_generator_2/fifo_generator_2.xci
read_ip ../ip/fifo_generator_3/fifo_generator_3.xci
read_ip ../ip/fifo_generator_4/fifo_generator_4.xci


#read_ip ../ip/clk_wiz_0.xci

## core edif file
read_edif ../ngc/processor_1x2x32.ngc 
## read_edif ../ngc/processor_1x2x32.ngc

############### SYNTHESIZE ##############

synth_design -fsm_extraction off  -top dram_spi_wrapper_ui64 -part xc7k325tffg900-2
write_checkpoint -force PostSynthCheckpoint.dcp
report_timing_summary -file timing.postsynth.rpt -nworst 4

report_utilization -file utilization_post_synth.rpt
report_utilization -hierarchical -file utilization_post_synth.hierarchical.rpt
opt_design
opt_design
place_design
phys_opt_design
route_design
phys_opt_design
phys_opt_design
phys_opt_design
write_checkpoint -force PostPlaceRouteCheckpoint.dcp
report_timing_summary -file timing.rpt -nworst 10 -verbose
report_utilization -file utilization_post_place_and_route.rpt
report_utilization -hierarchical -file utilization_post_place_and_route.hierarchical.rpt
write_bitstream -force processor_1x2x32_ACB_UI_kc705.bit


