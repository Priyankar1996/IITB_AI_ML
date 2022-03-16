set AHIR_RELEASE $::env(AHIR_RELEASE)
set AJIT_PROJECT_HOME $::env(AJIT_PROJECT_HOME)

read_vhdl -library ahir_ieee_proposed $AHIR_RELEASE/vhdl/aHiR_ieee_proposed.vhdl
read_vhdl -library ahir $AHIR_RELEASE/vhdl/ahirXilinx.vhdl
read_vhdl -library simpleUartLib ../misc_vhdl/lib/simpleUartLib.vhdl
read_vhdl -library RtUart ../misc_vhdl/lib/RtUart.vhdl
read_vhdl -library work ../ahir/ahir_system.vhdl
read_vhdl ../toplevel/fpga_top.vhdl

############# CONSTRAINT FILE ###########
read_xdc ../constraint/kc705.xdc

############# IP CORE FILES #############
set_property part xc7k325tffg900-2 [current_project]
set_property board_part xilinx.com:kc705:part0:1.1 [current_project]

################### standlone proto core ################
read_ip   ../ip/ClkWiz80MHz/ClockingWizFor80MHz/ClockingWizFor80MHz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci

############### SYNTHESIZE ##############
synth_design -fsm_extraction off -top fpga_top -part xc7k325tffg900-2
write_checkpoint -force PostSynthCheckpoint.dcp
report_timing_summary -file timing.postsynth.rpt -nworst 4

report_utilization -file utilization_post_synth.rpt
report_utilization -hierarchical -file utilization_post_synth.hierarchical.rpt
opt_design  
place_design  -directive Explore
place_design -post_place_opt 
phys_opt_design  -directive Explore
route_design  -directive Explore
write_checkpoint -force PostPlaceRouteCheckpoint.dcp
report_timing_summary -file timing.rpt -nworst 10 -verbose
report_utilization -file utilization_post_place_and_route.rpt
report_utilization -hierarchical -file utilization_post_place_and_route.hierarchical.rpt
write_bitstream -force sample_project.kc705.bit
