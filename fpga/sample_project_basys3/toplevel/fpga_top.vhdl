library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RtUart;
use RtUart.RtUartComponents.all;

-- library unisim;
-- use unisim.vcomponents.all; -- for 7-series FPGA's

entity fpga_top is
port(
      Rx : in std_logic;
      Tx : out std_logic;
      LED: out std_logic_vector(7 downto 0);
      CLK100MHZ: in std_logic;
      btnC: in std_logic
    );
end entity fpga_top;

architecture structure of fpga_top is

	signal RT_1HZ: std_logic;
	signal BAUD_RATE : std_logic_vector(31 downto 0);
	signal reset_sync : std_logic;
	
	component ahir_system is  -- system 
  	port (-- 
    		clk : in std_logic;
    		reset : in std_logic;
    		data_in_pipe_write_data: in std_logic_vector(7 downto 0);
    		data_in_pipe_write_req : in std_logic_vector(0 downto 0);
    		data_in_pipe_write_ack : out std_logic_vector(0 downto 0);
    		data_out_pipe_read_data: out std_logic_vector(7 downto 0);
    		data_out_pipe_read_req : in std_logic_vector(0 downto 0);
    		data_out_pipe_read_ack : out std_logic_vector(0 downto 0)); -- 
  		-- 
	end component; 
    	signal data_in_pipe_write_data: std_logic_vector(7 downto 0);
    	signal data_in_pipe_write_req : std_logic_vector(0 downto 0);
    	signal data_in_pipe_write_ack : std_logic_vector(0 downto 0);
    	signal data_out_pipe_read_data: std_logic_vector(7 downto 0);
    	signal data_out_pipe_read_req : std_logic_vector(0 downto 0);
    	signal data_out_pipe_read_ack : std_logic_vector(0 downto 0); -- 

	signal COUNTER: integer;
	signal LED_SIG: std_logic;
	constant CLK_FREQUENCY: integer := 100000000;
begin
	------------------------------------------------------------
	-- RT clock generation
	------------------------------------------------------------
	process(CLK100MHz, reset_sync)
	begin
		if(CLK100MHz'event and CLK100MHz ='1') then
			if(reset_sync = '1') then
				COUNTER <= 0;
				RT_1HZ <= '0';
				LED_SIG <= '1';
			else
				if (COUNTER = (CLK_FREQUENCY/2)-1) then
					RT_1HZ <= not RT_1HZ;
					COUNTER <= 0;
					LED_SIG <= not LED_SIG;
				else
					COUNTER <= COUNTER + 1;
				end if;
			end if;
		end if;
	end process;

	ahir_inst: ahir_system
		port map (
    			CLK => CLK100MHz, RESET => RESET_SYNC,
    			data_in_pipe_write_data => data_in_pipe_write_data,
    			data_in_pipe_write_req => data_in_pipe_write_req,
    			data_in_pipe_write_ack  => data_in_pipe_write_ack ,
    			data_out_pipe_read_data => data_out_pipe_read_data,
    			data_out_pipe_read_req  => data_out_pipe_read_req ,
    			data_out_pipe_read_ack  => data_out_pipe_read_ack 
		);
	LED <= data_out_pipe_read_data;
	uart_inst:
		configurable_self_tuning_uart
			port map (
					CLK => CLK100MHz, RESET => RESET_SYNC,
					rt_1Hz(0) => RT_1HZ,
					BAUD_RATE => BAUD_RATE,
					UART_RX(0) => Rx,
					UART_TX(0) => Tx,
					TX_to_CONSOLE_pipe_write_data => data_out_pipe_read_data,
					TX_to_CONSOLE_pipe_write_req => data_out_pipe_read_ack,
					TX_to_CONSOLE_pipe_write_ack => data_out_pipe_read_req,
					CONSOLE_to_RX_pipe_read_data  => data_in_pipe_write_data ,
					CONSOLE_to_RX_pipe_read_req  => data_in_pipe_write_ack ,
					CONSOLE_to_RX_pipe_read_ack => data_in_pipe_write_req
				);
				BAUD_RATE <= std_logic_vector(to_unsigned(115200, 32));
				
				process (CLK100MHz)
				begin
					assert false report "UART CONSOLE2RX " & integer'image(to_integer(unsigned(data_in_pipe_write_data))) severity note;
					assert false report "UART CONSOLE2RX(0) " & std_logic'image(data_in_pipe_write_data(0)) severity note;
    		if (CLK100MHz'event and CLK100MHz = '1') then
			reset_sync <= btnC;
    		end if;
        end process;

end structure;
