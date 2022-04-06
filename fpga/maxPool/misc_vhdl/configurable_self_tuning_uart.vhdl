library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library AjitCustom;
use AjitCustom.AjitCustomComponents.all;

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
