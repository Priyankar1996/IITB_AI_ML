-- VHDL produced by vc2vhdl from virtual circuit (vc) description 
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.floatoperatorpackage.all;
use ahir.utilities.all;
library RtUart;
use RtUart.baud_control_calculator_global_package.all;
entity baud_control_calculator is  -- system 
  port (-- 
    clk : in std_logic;
    reset : in std_logic); -- 
  -- 
end entity; 
architecture baud_control_calculator_arch  of baud_control_calculator is -- system-architecture 
  -- 
begin -- 
  -- 
end baud_control_calculator_arch;
