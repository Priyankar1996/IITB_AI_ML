// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.1 (lin64) Build 1846317 Fri Apr 14 18:54:47 MDT 2017
// Date        : Wed Apr 13 15:29:17 2022
// Host        : ajit7 running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/kamran/my_xil_dir/Vivado/2017.1/new_acb_to_ui/new_acb_to_ui.srcs/sources_1/ip/vio_1/vio_1_stub.v
// Design      : vio_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2017.1" *)
module vio_1(clk, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[35:0]" */;
  input clk;
  output [35:0]probe_out0;
endmodule
