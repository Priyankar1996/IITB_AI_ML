-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package ahir_system_global_package is -- 
  constant desc_input_base_address : std_logic_vector(6 downto 0) := "0000000";
  constant desc_kernel_base_address : std_logic_vector(6 downto 0) := "0000000";
  constant desc_output_base_address : std_logic_vector(6 downto 0) := "0000000";
  constant input_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant kernel_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant output_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant padding_base_address : std_logic_vector(0 downto 0) := "0";
  constant stride_base_address : std_logic_vector(0 downto 0) := "0";
  -- 
end package ahir_system_global_package;
