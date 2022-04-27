read_vhdl -library ahir_ieee_proposed ../vhdl_libs/aHiR_ieee_proposed.vhdl
read_vhdl -library ahir ../vhdl_libs/ahir.vhdl
read_vhdl -library simpleUartLib ../misc_vhdl/lib/simpleUartLib.vhdl
read_vhdl -library RtUart ../misc_vhdl/lib/RtUart.vhdl
read_vhdl -library work ../ahir/ahir_system_global_package.vhdl
read_vhdl -library work ../ahir/ahir_system.vhdl
read_vhdl ../toplevel/fpga_top.vhdl

############# CONSTRAINT FILE ###########
read_xdc ../constraint/basys3.xdc

############### SYNTHESIZE ##############
synth_design -fsm_extraction off -top fpga_top -part xc7a35tcpg236-3
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
