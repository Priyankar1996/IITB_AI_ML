## set debug_rtd_standalone true, to enable debugging
##   of this rtd, in standalone mode ... 
###################################################
set debug_rtd_standalone false


if { $debug_rtd_standalone } {
  set rt::partid xc7k325tffg900-2
  if { ! [info exists ::env(RT_TMP)] } {
    set ::env(RT_TMP) [pwd]
  } 
  source $::env(SYNTH_COMMON)/task_worker.tcl
} 
set genomeRtd $env(RT_TMP)/14B1381E0.rtd
set parallel_map_command "rt::do_reinfer_area_combined 1"
set rt::parallelMoreOptions "set rt::bannerSuppress true"
puts "this genome's name is base_bank_dual_port_for_xst__parameterized31__GB18"
puts "this genome's rtd file is $genomeRtd"
source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
source $::env(RT_TMP)/parameters.tcl
rt::set_parameter parallelChildUpdateCell false; rt::set_parameter parallelTimingMode false; 
set genomeName base_bank_dual_port_for_xst__parameterized31__GB18
source $::env(SYNTH_COMMON)/synthesizeAGenome.tcl 
set rt::parallelMoreOptions "set rt::bannerSuppress false"
