-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.1 (lin64) Build 1846317 Fri Apr 14 18:54:47 MDT 2017
-- Date        : Tue May 17 15:30:30 2022
-- Host        : ajit7 running 64-bit Ubuntu 16.04.7 LTS
-- Command     : write_vhdl -force -mode synth_stub /home/kamran/Desktop/all_new/kc705/ip/clk_wiz_0/clk_wiz_0_stub.vhdl
-- Design      : clk_wiz_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_0 is
  Port ( 
    clk_sys_320 : out STD_LOGIC;
    clk_ref_200 : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clk_wiz_0;

architecture stub of clk_wiz_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_sys_320,clk_ref_200,reset,clk_in1_p,clk_in1_n";
begin
end;
