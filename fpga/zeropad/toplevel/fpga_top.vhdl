library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all; -- for 7-series FPGA's

library RtUart;
use RtUart.RtUartComponents.all;


entity fpga_top is
port(
      Rx : in std_logic;
      Tx : out std_logic;
      clk_p,clk_n, reset,reset_clk: in std_logic
    );
end entity fpga_top;

architecture structure of fpga_top is

	signal RT_1HZ: std_logic;
	signal BAUD_RATE : std_logic_vector(31 downto 0);

	signal reset2,reset1,reset_sync,clk,lock : std_logic;
	component clk_wiz_0
  		port
   			(-- Clock in ports
    				-- Clock out ports
    				clk_out1          : out    std_logic;
    				-- Status and control signals
    				reset             : in     std_logic;
    				locked            : out    std_logic;
    				clk_in1_p         : in     std_logic;
    				clk_in1_n         : in     std_logic
   			);
	end component;
	
	component ahir_system is  -- system 
  	port (-- 
		clk : in std_logic;
		reset : in std_logic;
		zeropad_input_pipe_pipe_write_data: in std_logic_vector(15 downto 0);
		zeropad_input_pipe_pipe_write_req : in std_logic_vector(0 downto 0);
		zeropad_input_pipe_pipe_write_ack : out std_logic_vector(0 downto 0);
		zeropad_output_pipe_pipe_read_data: out std_logic_vector(15 downto 0);
		zeropad_output_pipe_pipe_read_req : in std_logic_vector(0 downto 0);
		zeropad_output_pipe_pipe_read_ack : out std_logic_vector(0 downto 0)); -- 
  		-- 
	end component; 
    	signal zeropad_input_pipe_pipe_write_data: std_logic_vector(7 downto 0);
    	signal zeropad_input_pipe_pipe_write_req : std_logic_vector(0 downto 0);
    	signal zeropad_input_pipe_pipe_write_ack : std_logic_vector(0 downto 0);
    	signal zeropad_output_pipe_pipe_read_data: std_logic_vector(7 downto 0);
    	signal zeropad_output_pipe_pipe_read_req : std_logic_vector(0 downto 0);
    	signal zeropad_output_pipe_pipe_read_ack : std_logic_vector(0 downto 0); -- 

	signal COUNTER: integer;
	constant CLK_FREQUENCY: integer := 80000000;
begin
	------------------------------------------------------------
	-- RT clock generation
	------------------------------------------------------------
	process(clk, reset_sync)
	begin
		if(clk'event and clk ='1') then
			if(reset = '1') then
				COUNTER <= 0;
				RT_1HZ <= '0';
			else
				if (COUNTER = (CLK_FREQUENCY/2)-1) then
					RT_1HZ <= not RT_1HZ;
					COUNTER <= 0;
				else
					COUNTER <= COUNTER + 1;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------
	-- Generate 80MHz from differential 200MHz clock.
	------------------------------------------------------------
	clocking : clk_wiz_0
   		port map ( 
  			-- Clock out ports  
   			clk_out1 => CLK,
  			-- Status and control signals                
   			reset => reset_clk,
   			locked => lock,
   			-- Clock in ports
   			clk_in1_p => clk_p,
   			clk_in1_n => clk_n
 		);

	ahir_inst: ahir_system
		port map (
    			CLK => CLK, RESET => RESET_SYNC,
    			zeropad_input_pipe_pipe_write_data => zeropad_input_pipe_pipe_write_data,
    			zeropad_input_pipe_pipe_write_req => zeropad_input_pipe_pipe_write_req,
    			zeropad_input_pipe_pipe_write_ack  => zeropad_input_pipe_pipe_write_ack ,
    			zeropad_output_pipe_pipe_read_data => zeropad_output_pipe_pipe_read_data,
    			zeropad_output_pipe_pipe_read_req  => zeropad_output_pipe_pipe_read_req ,
    			zeropad_output_pipe_pipe_read_ack  => zeropad_output_pipe_pipe_read_ack 
		);
	uart_inst:
		configurable_self_tuning_uart
			port map (
					CLK => CLK, RESET => RESET_SYNC,
					rt_1Hz(0) => RT_1HZ,
					BAUD_RATE => BAUD_RATE,
					UART_RX(0) => Rx,
					UART_TX(0) => Tx,
					TX_to_CONSOLE_pipe_write_data => zeropad_output_pipe_pipe_read_data,
					TX_to_CONSOLE_pipe_write_req => zeropad_output_pipe_pipe_read_ack,
					TX_to_CONSOLE_pipe_write_ack => zeropad_output_pipe_pipe_read_req,
					CONSOLE_to_RX_pipe_read_data  => zeropad_input_pipe_pipe_write_data ,
					CONSOLE_to_RX_pipe_read_req  => zeropad_input_pipe_pipe_write_ack ,
					CONSOLE_to_RX_pipe_read_ack => zeropad_input_pipe_pipe_write_req
				);


	BAUD_RATE <= std_logic_vector(to_unsigned(115200, 32));

 	process (CLK)
  	begin
    		if (CLK'event and CLK = '1') then
			reset_sync <= reset2;
			reset2 <= reset1;
			reset1 <= reset;
    		end if;
       end process;

end structure;
