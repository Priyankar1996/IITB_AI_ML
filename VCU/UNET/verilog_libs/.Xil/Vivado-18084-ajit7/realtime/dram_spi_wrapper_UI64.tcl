# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "./.Xil/Vivado-18084-ajit7/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7k325tffg900-2

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog -sv {
      /home/kamran/my_xil_dir/Vivado/2017.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
      /home/kamran/my_xil_dir/Vivado/2017.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv
    }
      rt::read_verilog {
      ./.Xil/Vivado-18084-ajit7/realtime/fifo_generator_1_stub.v
      ./.Xil/Vivado-18084-ajit7/realtime/fifo_generator_2_stub.v
      ./.Xil/Vivado-18084-ajit7/realtime/fifo_generator_3_stub.v
      ./.Xil/Vivado-18084-ajit7/realtime/mig_7series_0_stub.v
      ./.Xil/Vivado-18084-ajit7/realtime/ila_0_stub.v
      ./.Xil/Vivado-18084-ajit7/realtime/clk_wiz_0_stub.v
      /home/kamran/MTP_PRO/kc705/verilog_libs/ACB_to_UI.v
      /home/kamran/MTP_PRO/kc705/verilog_libs/ACB_tgen.v
    }
      rt::read_vhdl -lib ahir /home/kamran/MTP_PRO/kc705/vhdl_libs/ahir.vhdl
      rt::read_vhdl -lib ahir_ieee_proposed /home/kamran/MTP_PRO/kc705/vhdl_libs/aHiR_ieee_proposed.vhdl
      rt::read_vhdl -lib AjitCustom /home/kamran/MTP_PRO/kc705/vhdl_libs/AjitCustom.vhdl
      rt::read_vhdl -lib simpleUartLib /home/kamran/MTP_PRO/kc705/vhdl_libs/simpleUartLib.vhdl
      rt::read_vhdl -lib GenericCoreAddonLib /home/kamran/MTP_PRO/kc705/vhdl_libs/GenericCoreAddOnLib.vhdl
      rt::read_vhdl -lib GenericGlueStuff /home/kamran/MTP_PRO/kc705/vhdl_libs/GenericGlueStuff.vhdl
      rt::read_vhdl -lib GlueModules /home/kamran/MTP_PRO/kc705/vhdl_libs/GlueModules.vhdl
      rt::read_vhdl -lib AxiBridgeLib /home/kamran/MTP_PRO/kc705/vhdl_libs/AxiBridgeLib.vhdl
      rt::read_vhdl -lib work /home/kamran/MTP_PRO/kc705/vhdl/dram_spi_wrapper_ui64.vhdl
      rt::read_vhdl -lib xpm /home/kamran/my_xil_dir/Vivado/2017.1/data/ip/xpm/xpm_VCOMP.vhd
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top dram_spi_wrapper_UI64
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
# MODE: 
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "./.Xil/Vivado-18084-ajit7/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
      rt::run_rtlelab -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }

    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
