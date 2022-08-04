// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_4,Vivado 2017.1" *)
module fifo_generator_0(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  prog_full, prog_empty);
  input clk;
  input srst;
  input [109:0]din;
  input wr_en;
  input rd_en;
  output [109:0]dout;
  output full;
  output empty;
  output prog_full;
  output prog_empty;
endmodule
