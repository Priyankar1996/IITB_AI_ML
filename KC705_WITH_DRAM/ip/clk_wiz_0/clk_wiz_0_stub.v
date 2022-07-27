// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.1 (lin64) Build 1846317 Fri Apr 14 18:54:47 MDT 2017
// Date        : Tue May 17 15:30:30 2022
// Host        : ajit7 running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -force -mode synth_stub /home/kamran/Desktop/all_new/kc705/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_sys_320, clk_ref_200, reset, clk_in1_p, 
  clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_sys_320,clk_ref_200,reset,clk_in1_p,clk_in1_n" */;
  output clk_sys_320;
  output clk_ref_200;
  input reset;
  input clk_in1_p;
  input clk_in1_n;
endmodule
