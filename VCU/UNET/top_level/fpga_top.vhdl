library ieee;
use ieee.std_logic_1164.all;


library GenericCoreAddOnLib;
use GenericCoreAddOnLib.GenericCoreAddOnPackage.all;

library GlueModules;
use GlueModules.GlueModulesBaseComponents.all;

library GenericGlueStuff;
use GenericGlueStuff.GenericGlueStuffComponents.all;

library simpleUartLib;
use simpleUartLib.all;

Library UNISIM;
use UNISIM.vcomponents.all;

library aHiR_ieee_proposed;
use aHiR_ieee_proposed.math_utility_pkg.all;
use aHiR_ieee_proposed.fixed_pkg.all;
use aHiR_ieee_proposed.float_pkg.all;
library ahir;

library AjitCustom;
use AjitCustom.AjitCustomComponents.all;

library AxiBridgeLib;
use AxiBridgeLib.axi_component_package.all;


entity top_level is
port(
      DEBUG_UART_RX : in std_logic_vector(0 downto 0);
      DEBUG_UART_TX : out std_logic_vector(0 downto 0);
      SERIAL_UART_RX : in std_logic_vector(0 downto 0);
      SERIAL_UART_TX : out std_logic_vector(0 downto 0);
      clk_p : in std_logic;
      clk_n : in std_logic
	);
end entity top_level;

architecture structure of top_level is


  component processor_4x2x64 is -- 
   port( -- 
    CONSOLE_to_SERIAL_RX_pipe_write_data : in std_logic_vector(7 downto 0);
    CONSOLE_to_SERIAL_RX_pipe_write_req  : in std_logic_vector(0  downto 0);
    CONSOLE_to_SERIAL_RX_pipe_write_ack  : out std_logic_vector(0  downto 0);
    EXTERNAL_INTERRUPT : in std_logic_vector(0 downto 0);
    MAIN_MEM_INVALIDATE_pipe_write_data : in std_logic_vector(29 downto 0);
    MAIN_MEM_INVALIDATE_pipe_write_req  : in std_logic_vector(0  downto 0);
    MAIN_MEM_INVALIDATE_pipe_write_ack  : out std_logic_vector(0  downto 0);
    MAIN_MEM_RESPONSE_pipe_write_data : in std_logic_vector(64 downto 0);
    MAIN_MEM_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
    MAIN_MEM_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
    SOC_MONITOR_to_DEBUG_pipe_write_data : in std_logic_vector(7 downto 0);
    SOC_MONITOR_to_DEBUG_pipe_write_req  : in std_logic_vector(0  downto 0);
    SOC_MONITOR_to_DEBUG_pipe_write_ack  : out std_logic_vector(0  downto 0);
    THREAD_RESET : in std_logic_vector(3 downto 0);
    MAIN_MEM_REQUEST_pipe_read_data : out std_logic_vector(109 downto 0);
    MAIN_MEM_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
    MAIN_MEM_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
    PROCESSOR_MODE : out std_logic_vector(15 downto 0);
    SERIAL_TX_to_CONSOLE_pipe_read_data : out std_logic_vector(7 downto 0);
    SERIAL_TX_to_CONSOLE_pipe_read_req  : in std_logic_vector(0  downto 0);
    SERIAL_TX_to_CONSOLE_pipe_read_ack  : out std_logic_vector(0  downto 0);
    SOC_DEBUG_to_MONITOR_pipe_read_data : out std_logic_vector(7 downto 0);
    SOC_DEBUG_to_MONITOR_pipe_read_req  : in std_logic_vector(0  downto 0);
    SOC_DEBUG_to_MONITOR_pipe_read_ack  : out std_logic_vector(0  downto 0);
    clk, reset: in std_logic 
    -- 
  );
  --
  end component processor_4x2x64;
  signal PROCESSOR_MODE: std_logic_vector(15 downto 0);


component uartTopGenericEasilyConfigurable is
  generic (
         	baud_rate  : integer:= 115200;
         	clock_frequency : integer := 100000000);
  port ( -- global signals
         reset     : in  std_logic;                     -- global reset input
         clk       : in  std_logic;                     -- global clock input
         -- uart serial signals
         serIn     : in  std_logic;                     -- serial data input
         serOut    : out std_logic;                     -- serial data output
         -- pipe signals for tx/rx.
	 uart_rx_pipe_read_data:  out  std_logic_vector (7 downto 0);
	 uart_rx_pipe_read_req:   in   std_logic_vector (0 downto 0);
	 uart_rx_pipe_read_ack:   out  std_logic_vector (0 downto 0);
	 uart_tx_pipe_write_data: in   std_logic_vector (7 downto 0);
	 uart_tx_pipe_write_req:  in   std_logic_vector (0 downto 0);
	 uart_tx_pipe_write_ack:  out  std_logic_vector (0 downto 0));
  end component;
  
  
  -- vio for reset
  component vio_0 is
  port (
    clk : in std_logic;
    probe_in0 : in std_logic;
    probe_in1 : in std_logic;
    probe_in2 : in std_logic;
    probe_out0 : out std_logic;
    probe_out1 : OUT std_logic;
    probe_out2 : OUT std_logic;
    probe_out3 : OUT std_logic;
    probe_out4 : OUT std_logic
  );
  end component;

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

   signal MAIN_MEM_RESPONSE_pipe_write_data:std_logic_vector(64 downto 0);
   signal MAIN_MEM_RESPONSE_pipe_write_req:std_logic_vector(0 downto 0);
   signal MAIN_MEM_RESPONSE_pipe_write_ack:std_logic_vector(0 downto 0);

   signal MAIN_MEM_REQUEST_pipe_read_data:std_logic_vector(109 downto 0);
   signal MAIN_MEM_REQUEST_pipe_read_req:std_logic_vector(0  downto 0);
   signal MAIN_MEM_REQUEST_pipe_read_ack:std_logic_vector(0  downto 0);
   
   signal reset1,reset2,reset_sync: std_logic;
   signal EXTERNAL_INTERRUPT : std_logic_vector(0 downto 0);
   signal LOGGER_MODE : std_logic_vector(0 downto 0);
   signal clock:std_logic;
   signal lock : std_logic;

   signal MONITOR_to_DEBUG_pipe_write_data : std_logic_vector(7 downto 0);
   signal MONITOR_to_DEBUG_pipe_write_req  : std_logic_vector(0  downto 0);
   signal MONITOR_to_DEBUG_pipe_write_ack  : std_logic_vector(0  downto 0);

   signal DEBUG_to_MONITOR_pipe_read_data : std_logic_vector(7 downto 0);
   signal DEBUG_to_MONITOR_pipe_read_req  : std_logic_vector(0  downto 0);
   signal DEBUG_to_MONITOR_pipe_read_ack  : std_logic_vector(0  downto 0);

   signal CONSOLE_to_SERIAL_RX_pipe_write_data : std_logic_vector(7 downto 0);
   signal CONSOLE_to_SERIAL_RX_pipe_write_req  : std_logic_vector(0  downto 0);
   signal CONSOLE_to_SERIAL_RX_pipe_write_ack  : std_logic_vector(0  downto 0);

   signal SERIAL_TX_to_CONSOLE_pipe_read_data : std_logic_vector(7 downto 0);
   signal SERIAL_TX_to_CONSOLE_pipe_read_req  : std_logic_vector(0  downto 0);
   signal SERIAL_TX_to_CONSOLE_pipe_read_ack  : std_logic_vector(0  downto 0);

   signal CONFIG_UART_BAUD_CONTROL_WORD: std_logic_vector(31 downto 0);
    
   signal INVALIDATE_REQUEST_pipe_write_data : std_logic_vector(29 downto 0);
   signal INVALIDATE_REQUEST_pipe_write_req  : std_logic_vector(0  downto 0);
   signal INVALIDATE_REQUEST_pipe_write_ack  : std_logic_vector(0  downto 0);

   signal reset,reset_clk : std_logic;

   signal CPU_RESET : std_logic_vector(0 downto 0);
   signal DEBUG_MODE : std_logic_vector(0 downto 0);
   signal SINGLE_STEP_MODE : std_logic_vector(0 downto 0);
   signal CPU_MODE : std_logic_vector(1 downto 0);
   
   
begin


   -- tie it off for this board.
   INVALIDATE_REQUEST_pipe_write_req(0) <= '0'; 
   INVALIDATE_REQUEST_pipe_write_data  <= (others => '0');
   
   -- clock freq = 80MHz, baud-rate=115200.
   -- CONFIG_UART_BAUD_CONTROL_WORD <= X"0bed0048";
   -- clock freq = 100MHz, baud-rate=115200.
   --CONFIG_UART_BAUD_CONTROL_WORD <= X"3be00120";

   clocking : clk_wiz_0
      port map ( 
        -- Clock out ports  
         clk_out1 => clock,  --100Mhz
        -- Status and control signals                
         reset => reset_clk,
         locked => lock,
         -- Clock in ports
         clk_in1_p => clk_p,
         clk_in1_n => clk_n
       );
    
    
    -- VIO for reset 
    virtual_reset : vio_0
 	port map (
    			clk => clock,
			probe_in0 =>  lock,
			probe_in1 =>  CPU_MODE(1),
			probe_in2 =>  CPU_MODE(0),
			probe_out0 => reset_sync,
			probe_out1 => reset_clk,
			probe_out2 => CPU_RESET(0),
			probe_out3 => DEBUG_MODE(0),
			probe_out4 => SINGLE_STEP_MODE(0)
  		);
 
    EXTERNAL_INTERRUPT(0) <= '0';
    LOGGER_MODE(0) <= '0';

    test_inst: processor_4x2x64 port map(
		THREAD_RESET(0) => CPU_RESET(0),
      		THREAD_RESET(1) => DEBUG_MODE(0),
      		THREAD_RESET(2) => SINGLE_STEP_MODE(0),
      		THREAD_RESET(3) => LOGGER_MODE(0),
		EXTERNAL_INTERRUPT => EXTERNAL_INTERRUPT,
		-- only bottom 2 bits used.
		PROCESSOR_MODE => PROCESSOR_MODE,
    		MAIN_MEM_INVALIDATE_pipe_write_data  => INVALIDATE_REQUEST_pipe_write_data ,
    		MAIN_MEM_INVALIDATE_pipe_write_req   => INVALIDATE_REQUEST_pipe_write_req  ,
    		MAIN_MEM_INVALIDATE_pipe_write_ack   => INVALIDATE_REQUEST_pipe_write_ack  ,
    		SOC_MONITOR_to_DEBUG_pipe_write_data  => MONITOR_to_DEBUG_pipe_write_data ,
    		SOC_MONITOR_to_DEBUG_pipe_write_req  => MONITOR_to_DEBUG_pipe_write_req ,
    		SOC_MONITOR_to_DEBUG_pipe_write_ack  => MONITOR_to_DEBUG_pipe_write_ack ,
    		SOC_DEBUG_to_MONITOR_pipe_read_data  => DEBUG_to_MONITOR_pipe_read_data ,
    		SOC_DEBUG_to_MONITOR_pipe_read_req   => DEBUG_to_MONITOR_pipe_read_req  ,
    		SOC_DEBUG_to_MONITOR_pipe_read_ack   => DEBUG_to_MONITOR_pipe_read_ack  ,
    		CONSOLE_to_SERIAL_RX_pipe_write_data  => CONSOLE_to_SERIAL_RX_pipe_write_data ,
    		CONSOLE_to_SERIAL_RX_pipe_write_req  => CONSOLE_to_SERIAL_RX_pipe_write_req ,
    		CONSOLE_to_SERIAL_RX_pipe_write_ack  => CONSOLE_to_SERIAL_RX_pipe_write_ack ,
    		SERIAL_TX_to_CONSOLE_pipe_read_data => SERIAL_TX_to_CONSOLE_pipe_read_data,
    		SERIAL_TX_to_CONSOLE_pipe_read_req  => SERIAL_TX_to_CONSOLE_pipe_read_req ,
    		SERIAL_TX_to_CONSOLE_pipe_read_ack   => SERIAL_TX_to_CONSOLE_pipe_read_ack  ,
      		MAIN_MEM_RESPONSE_pipe_write_data => MAIN_MEM_RESPONSE_pipe_write_data, 
      		MAIN_MEM_RESPONSE_pipe_write_req => MAIN_MEM_RESPONSE_pipe_write_req,
      		MAIN_MEM_RESPONSE_pipe_write_ack => MAIN_MEM_RESPONSE_pipe_write_ack,
      		MAIN_MEM_REQUEST_pipe_read_data => MAIN_MEM_REQUEST_pipe_read_data,
      		MAIN_MEM_REQUEST_pipe_read_req => MAIN_MEM_REQUEST_pipe_read_req,
      		MAIN_MEM_REQUEST_pipe_read_ack => MAIN_MEM_REQUEST_pipe_read_ack,
      		clk => clock,
      		reset => reset_sync
	);
   	CPU_MODE <= PROCESSOR_MODE(1 downto 0);

  bram:acb_sram_stub generic map (addr_width => 22) port map (
      CORE_BUS_REQUEST_PIPE_WRITE_DATA => MAIN_MEM_REQUEST_pipe_read_data,
      CORE_BUS_REQUEST_PIPE_WRITE_REQ  => MAIN_MEM_REQUEST_pipe_read_ack,
      CORE_BUS_REQUEST_PIPE_WRITE_ACK  => MAIN_MEM_REQUEST_pipe_read_req,
      CORE_BUS_RESPONSE_PIPE_READ_DATA => MAIN_MEM_RESPONSE_pipe_write_data,
      CORE_BUS_RESPONSE_PIPE_READ_REQ  => MAIN_MEM_RESPONSE_pipe_write_ack,
      CORE_BUS_RESPONSE_PIPE_READ_ACK  => MAIN_MEM_RESPONSE_pipe_write_req,
      clk => clock, 
      reset => reset_sync
   );


--  debug_uart_inst: configurable_uart
--  port map ( --
--    CONFIG_UART_BAUD_CONTROL_WORD => CONFIG_UART_BAUD_CONTROL_WORD,
--    CONSOLE_to_RX_pipe_read_data => MONITOR_to_DEBUG_pipe_write_data,
--    CONSOLE_to_RX_pipe_read_req => MONITOR_to_DEBUG_pipe_write_ack,
--    CONSOLE_to_RX_pipe_read_ack => MONITOR_to_DEBUG_pipe_write_req,
--    TX_to_CONSOLE_pipe_write_data => DEBUG_to_MONITOR_pipe_read_data,
--    TX_to_CONSOLE_pipe_write_req => DEBUG_to_MONITOR_pipe_read_ack,
--    TX_to_CONSOLE_pipe_write_ack => DEBUG_to_MONITOR_pipe_read_req,
--    UART_RX => DEBUG_UART_RX,
--    UART_TX => DEBUG_UART_TX,
--    clk => clock, reset => reset_sync
--    ); -- 

--  serial_uart_inst: configurable_uart
--  port map ( --
--    CONFIG_UART_BAUD_CONTROL_WORD => CONFIG_UART_BAUD_CONTROL_WORD,
--    CONSOLE_to_RX_pipe_read_data => CONSOLE_to_SERIAL_RX_pipe_write_data,
--    CONSOLE_to_RX_pipe_read_req => CONSOLE_to_SERIAL_RX_pipe_write_ack,
--    CONSOLE_to_RX_pipe_read_ack => CONSOLE_to_SERIAL_RX_pipe_write_req,
--    TX_to_CONSOLE_pipe_write_data => SERIAL_TX_to_CONSOLE_pipe_read_data,
--    TX_to_CONSOLE_pipe_write_req => SERIAL_TX_to_CONSOLE_pipe_read_ack,
--    TX_to_CONSOLE_pipe_write_ack => SERIAL_TX_to_CONSOLE_pipe_read_req,
--    UART_RX => SERIAL_UART_RX,
--    UART_TX => SERIAL_UART_TX,
--    clk => clock, reset => reset_sync
--    ); --


    debug_uart: uartTopGenericEasilyConfigurable
                    generic map(baud_rate => 115200, clock_frequency => 80000000)
                        port map (
                                reset     => reset_sync,
                                clk       => clock,
                                -- uart serial signals
                                serIn     => DEBUG_UART_RX(0),
                                serOut    => DEBUG_UART_TX(0),
                                -- pipe signals for tx/rx.
                                uart_rx_pipe_read_data  =>  MONITOR_to_DEBUG_pipe_write_data,
                                uart_rx_pipe_read_req   =>  MONITOR_to_DEBUG_pipe_write_ack,
                                uart_rx_pipe_read_ack   =>  MONITOR_to_DEBUG_pipe_write_req,
                                uart_tx_pipe_write_data =>  DEBUG_to_MONITOR_pipe_read_data,
                                uart_tx_pipe_write_req  =>  DEBUG_to_MONITOR_pipe_read_ack,
                                uart_tx_pipe_write_ack  =>  DEBUG_to_MONITOR_pipe_read_req
                        );

    serial_uart: uartTopGenericEasilyConfigurable
                        generic map(baud_rate => 115200, clock_frequency => 80000000)
                        port map (
                                 reset     => reset_sync,
                                clk       => clock,
                                -- uart serial signals
                                serIn     => SERIAL_UART_RX(0),
                                serOut    => SERIAL_UART_TX(0),
                                -- pipe signals for tx/rx.
                                uart_rx_pipe_read_data  =>  CONSOLE_to_SERIAL_RX_pipe_write_data,
                                uart_rx_pipe_read_req   =>  CONSOLE_to_SERIAL_RX_pipe_write_ack,
                                uart_rx_pipe_read_ack   =>  CONSOLE_to_SERIAL_RX_pipe_write_req,
                                uart_tx_pipe_write_data =>  SERIAL_TX_to_CONSOLE_pipe_read_data,
                                uart_tx_pipe_write_req  =>  SERIAL_TX_to_CONSOLE_pipe_read_ack,
                                uart_tx_pipe_write_ack  =>  SERIAL_TX_to_CONSOLE_pipe_read_req
                        );

end structure;

