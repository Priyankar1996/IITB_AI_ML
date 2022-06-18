-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package ahir_system_global_package is -- 
  constant CD1_1_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant CD1_2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant CD2_1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant CD2_2_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant CD3_1_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant CD3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant CE1_1_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant CE1_2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant CE2_1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant CE2_2_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant CE3_1_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant CE3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant CM1_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant CM2_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant CO1_base_address : std_logic_vector(19 downto 0) := "00000000000000000000";
  constant CO2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant CO3_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant KD1_1_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant KD1_2_base_address : std_logic_vector(12 downto 0) := "0000000000000";
  constant KD2_1_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant KD2_2_base_address : std_logic_vector(14 downto 0) := "000000000000000";
  constant KD3_1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant KD3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant KE1_1_base_address : std_logic_vector(8 downto 0) := "000000000";
  constant KE1_2_base_address : std_logic_vector(12 downto 0) := "0000000000000";
  constant KE2_1_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant KE2_2_base_address : std_logic_vector(14 downto 0) := "000000000000000";
  constant KE3_1_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant KE3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant KL_base_address : std_logic_vector(8 downto 0) := "000000000";
  constant KM1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant KM2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant KT1_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant KT2_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant KT3_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant M1_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant M2_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant M3_base_address : std_logic_vector(14 downto 0) := "000000000000000";
  constant T1_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant T2_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant T3_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant ZD1_1_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant ZD1_2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant ZD2_1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant ZD2_2_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant ZD3_1_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant ZD3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant ZE1_1_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant ZE1_2_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant ZE2_1_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant ZE2_2_base_address : std_logic_vector(17 downto 0) := "000000000000000000";
  constant ZE3_1_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant ZE3_2_base_address : std_logic_vector(16 downto 0) := "00000000000000000";
  constant ZL_base_address : std_logic_vector(18 downto 0) := "0000000000000000000";
  constant ZM1_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant ZM2_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant input_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  constant output_base_address : std_logic_vector(15 downto 0) := "0000000000000000";
  -- 
end package ahir_system_global_package;
