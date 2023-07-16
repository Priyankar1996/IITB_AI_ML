// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.1 (lin64) Build 1846317 Fri Apr 14 18:54:47 MDT 2017
// Date        : Sun Apr  3 14:11:32 2022
// Host        : ajit7 running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -force -mode synth_stub /home/kamran/MTP_PRO/kc705/ip/ila/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2017.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[35:0],probe1[3:0],probe2[64:0],probe3[64:0],probe4[0:0],probe5[3:0],probe6[3:0],probe7[3:0]" */;
  input clk;
  input [35:0]probe0;
  input [3:0]probe1;
  input [64:0]probe2;
  input [64:0]probe3;
  input [0:0]probe4;
  input [3:0]probe5;
  input [3:0]probe6;
  input [3:0]probe7;
endmodule
