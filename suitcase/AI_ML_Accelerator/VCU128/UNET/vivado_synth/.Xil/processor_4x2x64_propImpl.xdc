set_property SRC_FILE_INFO {cfile:/home/tools_shared/ajit_systems_repository/boards/ajitmp/processor_4x2x64/vivado_synth/clocking.xdc rfile:../clocking.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_clock -add -name clk -period 10.00 -waveform {0 5}   [get_ports clk_p]
