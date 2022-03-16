library ieee;
use ieee.std_logic_1164.all;

package RtLibComponents is
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
