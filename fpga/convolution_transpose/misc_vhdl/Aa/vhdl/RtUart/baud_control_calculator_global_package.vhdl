-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package baud_control_calculator_global_package is -- 
  component baud_control_calculator is -- 
    port (-- 
      clk : in std_logic;
      reset : in std_logic;
      BAUD_CONTROL_WORD_SIG: out std_logic_vector(31 downto 0);
      BAUD_CONTROL_WORD_VALID: out std_logic_vector(0 downto 0);
      BAUD_RATE_SIG: in std_logic_vector(31 downto 0);
      CLK_FREQUENCY_SIG: in std_logic_vector(31 downto 0);
      CLOCK_FREQUENCY_VALID: in std_logic_vector(0 downto 0)); -- 
    -- 
  end component;
  -- 
end package baud_control_calculator_global_package;
