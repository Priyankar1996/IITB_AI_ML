library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library AjitCustom;
use AjitCustom.baud_control_calculator_global_package.all;


entity test_bench is -- 
  -- 
end entity;
architecture VhpiLink of test_bench is -- 
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  signal BAUD_CONTROL_WORD_SIG: std_logic_vector(31 downto 0);
  signal BAUD_RATE_SIG: std_logic_vector(31 downto 0);
  signal CLK_FREQUENCY_SIG: std_logic_vector(31 downto 0);
  -- 
begin --
  -- clock/reset generation 
  clk <= not clk after 5 ns;
  -- assert reset for four clocks.
  process
  begin --
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    reset <= '0';
    wait;
    --
  end process;

  BAUD_RATE_SIG <= std_logic_vector(to_unsigned (115200, 32));
  CLK_FREQUENCY_SIG <= std_logic_vector(to_unsigned(100000000,32));

  baud_control_calculator_instance: baud_control_calculator -- 
    port map ( -- 
      clk => clk,
      reset => reset,
      BAUD_CONTROL_WORD_SIG => BAUD_CONTROL_WORD_SIG,
      BAUD_RATE_SIG => BAUD_RATE_SIG,
      CLK_FREQUENCY_SIG => CLK_FREQUENCY_SIG); -- 
  -- 
end VhpiLink;
