-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package ahir_system_global_package is -- 
  constant R_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant T_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant col_high_base_address : std_logic_vector(0 downto 0) := "0";
  constant count_base_address : std_logic_vector(0 downto 0) := "0";
  constant depth_high_base_address : std_logic_vector(0 downto 0) := "0";
  constant des_inp_base_address : std_logic_vector(6 downto 0) := "0000000";
  constant des_out_base_address : std_logic_vector(6 downto 0) := "0000000";
  constant pad_base_address : std_logic_vector(0 downto 0) := "0";
  constant row_high_base_address : std_logic_vector(0 downto 0) := "0";
  -- 
end package ahir_system_global_package;
