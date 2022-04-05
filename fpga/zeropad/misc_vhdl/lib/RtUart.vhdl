library ieee;
use ieee.std_logic_1164.all;

package RtUartComponents is
  component rt_clock_counter is
	port (
			clk, reset: in std_logic;
			one_hz_rt_clock: in std_logic_vector(0 downto 0);
			count_value : out std_logic_vector(31 downto 0)
		);
  end component rt_clock_counter;

  component baud_control_calculator is  -- system 
   port (-- 
     clk : in std_logic;
     reset : in std_logic;
     BAUD_CONTROL_WORD_SIG: out std_logic_vector(31 downto 0);
     BAUD_CONTROL_WORD_VALID: out std_logic_vector(0 downto 0);
     BAUD_RATE_SIG: in std_logic_vector(31 downto 0);
     CLOCK_FREQUENCY_VALID: in std_logic_vector(0 downto 0); -- 
     CLK_FREQUENCY_SIG: in std_logic_vector(31 downto 0));  
  end component; 

  component configurable_self_tuning_uart is
	port (clk, reset: in std_logic; 
		rt_1Hz: in std_logic_vector(0 downto 0); 

		BAUD_RATE: in std_logic_vector(31 downto 0);
		UART_RX: in std_logic_vector(0 downto 0); 
		UART_TX: out std_logic_vector(0 downto 0);

		TX_to_CONSOLE_pipe_write_data: in std_logic_vector(7 downto 0);
		TX_to_CONSOLE_pipe_write_req:  in std_logic_vector(0 downto 0);
		TX_to_CONSOLE_pipe_write_ack:  out std_logic_vector(0 downto 0);

		CONSOLE_to_RX_pipe_read_data : out std_logic_vector(7 downto 0);
		CONSOLE_to_RX_pipe_read_req :  in std_logic_vector(0 downto 0);
		CONSOLE_to_RX_pipe_read_ack :  out std_logic_vector(0 downto 0));
   end component configurable_self_tuning_uart;

end package;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rt_clock_counter is

	port (
			clk, reset: in std_logic;
			one_hz_rt_clock: in std_logic_vector(0 downto 0);
			count_value : out std_logic_vector(31 downto 0)
		);

end entity rt_clock_counter;


architecture Behave of rt_clock_counter is

	signal counter : integer;
	signal last_one_hz_rt_clock, one_hz_rt_clock_synch: std_logic_vector(0 downto 0);
	signal rt_rising, rt_falling: boolean;
	type FsmState is (IDLE, RT_HIGH, RT_LOW);
	signal fsm_state: FsmState;

begin
	process(clk, reset)
	begin
		if(clk'event and clk = '1') then
			one_hz_rt_clock_synch <= one_hz_rt_clock;
			last_one_hz_rt_clock  <= one_hz_rt_clock_synch;
		end if;
	end process;

	rt_rising  <= (one_hz_rt_clock_synch(0) = '1') and (last_one_hz_rt_clock(0) = '0');
	rt_falling <= (one_hz_rt_clock_synch(0) = '0') and (last_one_hz_rt_clock(0) = '1');

	-- counter
	process(clk, reset, fsm_state, counter, rt_rising, rt_falling)
		variable latch_counter_var: boolean;
		variable next_counter_var : integer;
		variable next_fsm_state_var : FsmState;
	begin
		latch_counter_var := false;
		next_counter_var  := counter;
		next_fsm_state_var := fsm_state;

		case fsm_state is 
			when IDLE => 
				if rt_rising then
					next_counter_var := 0;
					next_fsm_state_var := RT_HIGH;
				end if;
			when RT_HIGH =>
				next_counter_var := (counter + 1);
				if(rt_falling) then
					next_fsm_state_var := RT_LOW;
				end if;
			when RT_LOW =>
				if(rt_rising) then
					latch_counter_var := true;
					next_counter_var := 0;
					next_fsm_state_var := RT_HIGH;
				else
					next_counter_var := (counter + 1);
				end if;
		end case;

		if(clk'event and clk = '1') then
			if(reset = '1') then
				counter <= 0;
				count_value <= (others => '0');				
				fsm_state <= IDLE;
			else
				counter <= next_counter_var;
				fsm_state <= next_fsm_state_var;

				if(latch_counter_var) then
					count_value <= std_logic_vector(to_unsigned(counter, 32));
				end if;

			end if;
		end if;
	end process;

end Behave; 
-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package baud_control_calculator_global_package is -- 
  component baud_control_calculator is -- 
    port (-- 
      clk : in std_logic;
      reset : in std_logic); -- 
    -- 
  end component;
  -- 
end package baud_control_calculator_global_package;
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
library GhdlLink;
use GhdlLink.Utility_Package.all;
use GhdlLink.Vhpi_Foreign.all;
entity baud_control_calculator_Test_Bench is -- 
  -- 
end entity;
architecture VhpiLink of baud_control_calculator_Test_Bench is -- 
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  -- 
begin --
  -- clock/reset generation 
  clk <= not clk after 5 ns;
  -- assert reset for four clocks.
  process
  begin --
    Vhpi_Initialize;
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    reset <= '0';
    while true loop --
      wait until clk = '0';
      Vhpi_Listen;
      Vhpi_Send;
      --
    end loop;
    wait;
    --
  end process;
  -- connect all the top-level modules to Vhpi
  baud_control_calculator_instance: baud_control_calculator -- 
    port map ( -- 
      clk => clk,
      reset => reset); -- 
  -- 
end VhpiLink;
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RtUart;
use RtUart.RtUartComponents.all;

library simpleUartLib;
use simpleUartLib.uartPackage.all;

entity configurable_self_tuning_uart is
	port (clk, reset: in std_logic; 
		rt_1Hz: in std_logic_vector(0 downto 0); 

		BAUD_RATE: in std_logic_vector(31 downto 0);
		UART_RX: in std_logic_vector(0 downto 0); 
		UART_TX: out std_logic_vector(0 downto 0);

		TX_to_CONSOLE_pipe_write_data: in std_logic_vector(7 downto 0);
		TX_to_CONSOLE_pipe_write_req:  in std_logic_vector(0 downto 0);
		TX_to_CONSOLE_pipe_write_ack:  out std_logic_vector(0 downto 0);

		CONSOLE_to_RX_pipe_read_data : out std_logic_vector(7 downto 0);
		CONSOLE_to_RX_pipe_read_req :  in std_logic_vector(0 downto 0);
		CONSOLE_to_RX_pipe_read_ack :  out std_logic_vector(0 downto 0));
end entity configurable_self_tuning_uart;


architecture Struct of configurable_self_tuning_uart is

	signal baud_control_word: std_logic_vector(31 downto 0);
	signal baud_control_word_valid: std_logic;
	signal clock_frequency_valid: std_logic;
        signal clock_frequency  : std_logic_vector(31 downto 0);
    				
	signal counter : integer;
	signal reset_uart: std_logic;

	constant Z32: std_logic_vector(31 downto 0) := (others => '0');
	signal soft_reset: std_logic;
begin

	--------------------------------------------------------------
	-- soft reset
	--------------------------------------------------------------
	process(clk, reset)
	begin
		if(clk'event and clk = '1') then
			if(reset_uart = '1') then
				counter <= 0;
				soft_reset <= '1';
			else 
				if(counter = 255) then
					soft_reset <= '0';
					counter <= 0;
				else
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;

	-------------------------------------------------------
	-- estimate the clock frequency
	-------------------------------------------------------
	rt_ctr_inst: rt_clock_counter
		port map (clk => clk, 
				reset => reset,
				one_hz_rt_clock => rt_1Hz,
				count_value => clock_frequency);	
	clock_frequency_valid <= '1' when (clock_frequency /= Z32) else '0';
	reset_uart <= '1' when ((reset = '1') or  (baud_control_word_valid = '0')) else '0';

	-------------------------------------------------------
	-- calculate the baud control word.
	-------------------------------------------------------
	bcc_inst: baud_control_calculator
		port map (clk => clk, reset => reset,
				BAUD_CONTROL_WORD_SIG => baud_control_word,
				BAUD_CONTROL_WORD_VALID(0) => baud_control_word_valid,
				BAUD_RATE_SIG => BAUD_RATE,
				CLK_FREQUENCY_SIG => clock_frequency,
				CLOCK_FREQUENCY_VALID(0) => clock_frequency_valid);

	-------------------------------------------------------
	-- The UART!
	-------------------------------------------------------
	uart_inst: uartTopPortConfigurable
		port map (
				reset => reset_uart,
				clk => clk,
				soft_reset => soft_reset,
				serIn     => UART_RX(0),	
				serOut    => UART_TX(0),	
				baudFreq  =>  baud_control_word(11 downto 0),
				baudLimit => baud_control_word(31 downto 16),
	 			uart_rx_pipe_read_data => CONSOLE_to_RX_pipe_read_data,
	 			uart_rx_pipe_read_req => CONSOLE_to_RX_pipe_read_req,
	 			uart_rx_pipe_read_ack => CONSOLE_to_RX_pipe_read_ack,
	 			uart_tx_pipe_write_data => TX_to_CONSOLE_pipe_write_data,
	 			uart_tx_pipe_write_req => TX_to_CONSOLE_pipe_write_req,
	 			uart_tx_pipe_write_ack => TX_to_CONSOLE_pipe_write_ack
		);
end Struct;
