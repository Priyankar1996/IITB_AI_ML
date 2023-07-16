library ieee;
use ieee.std_logic_1164.all;
package processor_4x2x64_Type_Package is -- 
  subtype unsigned_35_downto_0 is std_logic_vector(35 downto 0);
  subtype unsigned_0_downto_0 is std_logic_vector(0 downto 0);
  subtype unsigned_14_downto_0 is std_logic_vector(14 downto 0);
  subtype unsigned_1_downto_0 is std_logic_vector(1 downto 0);
  subtype unsigned_8_downto_0 is std_logic_vector(8 downto 0);
  subtype unsigned_2_downto_0 is std_logic_vector(2 downto 0);
  subtype unsigned_3_downto_0 is std_logic_vector(3 downto 0);
  subtype unsigned_4_downto_0 is std_logic_vector(4 downto 0);
  subtype unsigned_5_downto_0 is std_logic_vector(5 downto 0);
  subtype unsigned_7_downto_0 is std_logic_vector(7 downto 0);
  subtype unsigned_109_downto_0 is std_logic_vector(109 downto 0);
  subtype unsigned_110_downto_0 is std_logic_vector(110 downto 0);
  subtype unsigned_31_downto_0 is std_logic_vector(31 downto 0);
  subtype unsigned_15_downto_0 is std_logic_vector(15 downto 0);
  subtype unsigned_9_downto_0 is std_logic_vector(9 downto 0);
  subtype unsigned_11_downto_0 is std_logic_vector(11 downto 0);
  subtype unsigned_13_downto_0 is std_logic_vector(13 downto 0);
  -- 
end package;
library ahir;
use ahir.BaseComponents.all;
use ahir.Utilities.all;
use ahir.Subprograms.all;
use ahir.OperatorPackage.all;
use ahir.BaseComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ajit_processor_lib;
use ajit_processor_lib.processor_4x2x64_Type_Package.all;
entity pmodeGen is  -- 
  port (-- 
    PROCESSOR_MODE: out std_logic_vector(15 downto 0);
    TMODE_0_0: in std_logic_vector(3 downto 0);
    TMODE_0_1: in std_logic_vector(3 downto 0);
    TMODE_1_0: in std_logic_vector(3 downto 0);
    TMODE_1_1: in std_logic_vector(3 downto 0);
    TMODE_2_0: in std_logic_vector(3 downto 0);
    TMODE_2_1: in std_logic_vector(3 downto 0);
    TMODE_3_0: in std_logic_vector(3 downto 0);
    TMODE_3_1: in std_logic_vector(3 downto 0);
    clk, reset: in std_logic); --
  --
end entity pmodeGen;
architecture rtlThreadArch of pmodeGen is --
  type ThreadState is (s_pG_rst_state);
  signal current_thread_state : ThreadState;
  signal PROCESSOR_MODE_buffer: unsigned_15_downto_0;
  --
begin -- 
  PROCESSOR_MODE <= PROCESSOR_MODE_buffer;
  process(clk, reset, current_thread_state , TMODE_0_0, TMODE_0_1, TMODE_1_0, TMODE_1_1, TMODE_2_0, TMODE_2_1, TMODE_3_0, TMODE_3_1) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  PROCESSOR_MODE := ( ($slice  TMODE_3_1 1 0)  && ( ($slice  TMODE_3_0 1 0)  && ( ($slice  TMODE_2_1 1 0)  && ( ($slice  TMODE_2_0 1 0)  && ( ($slice  TMODE_1_1 1 0)  && ( ($slice  TMODE_1_0 1 0)  && ( ($slice  TMODE_0_1 1 0)  && ($slice  TMODE_0_0 1 0) ) ) ) ) ) ) ) 
    PROCESSOR_MODE_buffer <= (TMODE_3_1(1 downto 0) & (TMODE_3_0(1 downto 0) & (TMODE_2_1(1 downto 0) & (TMODE_2_0(1 downto 0) & (TMODE_1_1(1 downto 0) & (TMODE_1_0(1 downto 0) & (TMODE_0_1(1 downto 0) & TMODE_0_0(1 downto 0))))))));
    -- case statement 
    case current_thread_state is -- 
      when s_pG_rst_state => -- 
        next_thread_state := s_pG_rst_state;
        next_thread_state := s_pG_rst_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_pG_rst_state;
        -- 
      else -- 
        current_thread_state <= next_thread_state; 
        -- objects to be updated under tick.
        -- specified tick assignments. 
        -- 
      end if; 
      -- 
    end if; 
    --
  end process; 
  --
end rtlThreadArch;
library ahir;
use ahir.BaseComponents.all;
use ahir.Utilities.all;
use ahir.Subprograms.all;
use ahir.OperatorPackage.all;
use ahir.BaseComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ajit_processor_lib;
use ajit_processor_lib.processor_4x2x64_Type_Package.all;
entity threadDummy is  -- 
  port (-- 
    tmode: out std_logic_vector(3 downto 0);
    trace: out std_logic_vector(31 downto 0);
    trace_pipe_write_req: out std_logic_vector(0 downto 0);
    trace_pipe_write_ack: in std_logic_vector(0 downto 0);
    clk, reset: in std_logic); --
  --
end entity threadDummy;
architecture rtlThreadArch of threadDummy is --
  type ThreadState is (s_cD_rst_state);
  signal current_thread_state : ThreadState;
  signal tmode_buffer: unsigned_3_downto_0;
  signal trace_buffer: unsigned_31_downto_0;
  --
begin -- 
  tmode <= tmode_buffer;
  trace <= trace_buffer;
  process(clk, reset, current_thread_state , trace_pipe_write_ack) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  tmode :=  ( $unsigned<4> )  0000 
    tmode_buffer <= "0000";
    --  $now  trace$req  :=  ( $unsigned<1> )  0 
    trace_pipe_write_req <= "0";
    --  $now  trace :=  ( $unsigned<32> )  00000000000000000000000000000000 
    trace_buffer <= "00000000000000000000000000000000";
    -- case statement 
    case current_thread_state is -- 
      when s_cD_rst_state => -- 
        next_thread_state := s_cD_rst_state;
        next_thread_state := s_cD_rst_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_cD_rst_state;
        -- 
      else -- 
        current_thread_state <= next_thread_state; 
        -- objects to be updated under tick.
        -- specified tick assignments. 
        -- 
      end if; 
      -- 
    end if; 
    --
  end process; 
  --
end rtlThreadArch;
library ahir;
use ahir.BaseComponents.all;
use ahir.Utilities.all;
use ahir.Subprograms.all;
use ahir.OperatorPackage.all;
use ahir.BaseComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ajit_processor_lib;
use ajit_processor_lib.processor_4x2x64_Type_Package.all;
entity threadStubber is  -- 
  port (-- 
    ilvl: in std_logic_vector(3 downto 0);
    clk, reset: in std_logic); --
  --
end entity threadStubber;
architecture rtlThreadArch of threadStubber is --
  type ThreadState is (s_tS_rst_state);
  signal current_thread_state : ThreadState;
  --
begin -- 
  process(clk, reset, current_thread_state , ilvl) --
    -- declared variables and implied variables 
    variable svar: unsigned_3_downto_0;
    variable tvar: unsigned_3_downto_0;
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  tvar :=  ilvl
    tvar := ilvl;
    -- case statement 
    case current_thread_state is -- 
      when s_tS_rst_state => -- 
        next_thread_state := s_tS_rst_state;
        next_thread_state := s_tS_rst_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_tS_rst_state;
        -- 
      else -- 
        current_thread_state <= next_thread_state; 
        -- objects to be updated under tick.
        -- specified tick assignments. 
        -- 
      end if; 
      -- 
    end if; 
    --
  end process; 
  --
end rtlThreadArch;
library ahir;
use ahir.BaseComponents.all;
use ahir.Utilities.all;
use ahir.Subprograms.all;
use ahir.OperatorPackage.all;
use ahir.BaseComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ajit_processor_lib;
use ajit_processor_lib.processor_4x2x64_Type_Package.all;
entity traceStubber is  -- 
  port (-- 
    trace: in std_logic_vector(31 downto 0);
    trace_pipe_read_req: out std_logic_vector(0 downto 0);
    trace_pipe_read_ack: in std_logic_vector(0 downto 0);
    clk, reset: in std_logic); --
  --
end entity traceStubber;
architecture rtlThreadArch of traceStubber is --
  type ThreadState is (s_tS_rst_state);
  signal current_thread_state : ThreadState;
  --
begin -- 
  process(clk, reset, current_thread_state , trace, trace_pipe_read_ack) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  trace$req  :=  ( $unsigned<1> )  0 
    trace_pipe_read_req <= "0";
    -- case statement 
    case current_thread_state is -- 
      when s_tS_rst_state => -- 
        next_thread_state := s_tS_rst_state;
        next_thread_state := s_tS_rst_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_tS_rst_state;
        -- 
      else -- 
        current_thread_state <= next_thread_state; 
        -- objects to be updated under tick.
        -- specified tick assignments. 
        -- 
      end if; 
      -- 
    end if; 
    --
  end process; 
  --
end rtlThreadArch;
library ahir;
use ahir.BaseComponents.all;
use ahir.Utilities.all;
use ahir.Subprograms.all;
use ahir.OperatorPackage.all;
use ahir.BaseComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-->>>>>
library ajit_processor_lib;
use ajit_processor_lib.processor_4x2x64_Type_Package.all;
--<<<<<
-->>>>>
library ajit_mcore_lib;
library peripherals_lib;
--<<<<<
entity processor_4x2x64 is -- 
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
end entity processor_4x2x64;
architecture struct of processor_4x2x64 is -- 
  signal AFB_BUS_REQUEST_pipe_write_data: std_logic_vector(73 downto 0);
  signal AFB_BUS_REQUEST_pipe_write_req : std_logic_vector(0  downto 0);
  signal AFB_BUS_REQUEST_pipe_write_ack : std_logic_vector(0  downto 0);
  signal AFB_BUS_REQUEST_pipe_read_data: std_logic_vector(73 downto 0);
  signal AFB_BUS_REQUEST_pipe_read_req : std_logic_vector(0  downto 0);
  signal AFB_BUS_REQUEST_pipe_read_ack : std_logic_vector(0  downto 0);
  signal AFB_BUS_RESPONSE_pipe_write_data: std_logic_vector(32 downto 0);
  signal AFB_BUS_RESPONSE_pipe_write_req : std_logic_vector(0  downto 0);
  signal AFB_BUS_RESPONSE_pipe_write_ack : std_logic_vector(0  downto 0);
  signal AFB_BUS_RESPONSE_pipe_read_data: std_logic_vector(32 downto 0);
  signal AFB_BUS_RESPONSE_pipe_read_req : std_logic_vector(0  downto 0);
  signal AFB_BUS_RESPONSE_pipe_read_ack : std_logic_vector(0  downto 0);
  signal IRL_0_0 : std_logic_vector(3 downto 0);
  signal IRL_0_1 : std_logic_vector(3 downto 0);
  signal IRL_1_0 : std_logic_vector(3 downto 0);
  signal IRL_1_1 : std_logic_vector(3 downto 0);
  signal IRL_2_0 : std_logic_vector(3 downto 0);
  signal IRL_2_1 : std_logic_vector(3 downto 0);
  signal IRL_3_0 : std_logic_vector(3 downto 0);
  signal IRL_3_1 : std_logic_vector(3 downto 0);
  signal TMODE_0_0 : std_logic_vector(3 downto 0);
  signal TMODE_0_1 : std_logic_vector(3 downto 0);
  signal TMODE_1_0 : std_logic_vector(3 downto 0);
  signal TMODE_1_1 : std_logic_vector(3 downto 0);
  signal TMODE_2_0 : std_logic_vector(3 downto 0);
  signal TMODE_2_1 : std_logic_vector(3 downto 0);
  signal TMODE_3_0 : std_logic_vector(3 downto 0);
  signal TMODE_3_1 : std_logic_vector(3 downto 0);
  signal TRACE_0_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_0_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_0_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_0_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_0_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_0_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_0_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_0_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_0_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_0_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_0_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_0_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_1_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_1_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_1_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_1_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_1_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_1_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_1_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_1_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_1_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_1_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_1_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_1_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_2_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_2_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_2_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_2_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_2_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_2_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_2_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_2_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_2_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_2_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_2_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_2_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_3_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_3_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_3_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_3_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_3_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_3_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal TRACE_3_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal TRACE_3_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal TRACE_3_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal TRACE_3_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal TRACE_3_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal TRACE_3_1_pipe_read_ack : std_logic_vector(0  downto 0);
  component mcore_4x2x64 is -- 
    port( -- 
      AFB_BUS_RESPONSE_pipe_write_data : in std_logic_vector(32 downto 0);
      AFB_BUS_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      IRL_0_0 : in std_logic_vector(3 downto 0);
      IRL_0_1 : in std_logic_vector(3 downto 0);
      IRL_1_0 : in std_logic_vector(3 downto 0);
      IRL_1_1 : in std_logic_vector(3 downto 0);
      IRL_2_0 : in std_logic_vector(3 downto 0);
      IRL_2_1 : in std_logic_vector(3 downto 0);
      IRL_3_0 : in std_logic_vector(3 downto 0);
      IRL_3_1 : in std_logic_vector(3 downto 0);
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
      AFB_BUS_REQUEST_pipe_read_data : out std_logic_vector(73 downto 0);
      AFB_BUS_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      MAIN_MEM_REQUEST_pipe_read_data : out std_logic_vector(109 downto 0);
      MAIN_MEM_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      MAIN_MEM_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_data : out std_logic_vector(7 downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_req  : in std_logic_vector(0  downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TMODE_0_0 : out std_logic_vector(3 downto 0);
      TMODE_0_1 : out std_logic_vector(3 downto 0);
      TMODE_1_0 : out std_logic_vector(3 downto 0);
      TMODE_1_1 : out std_logic_vector(3 downto 0);
      TMODE_2_0 : out std_logic_vector(3 downto 0);
      TMODE_2_1 : out std_logic_vector(3 downto 0);
      TMODE_3_0 : out std_logic_vector(3 downto 0);
      TMODE_3_1 : out std_logic_vector(3 downto 0);
      TRACE_0_0_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_0_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_0_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_0_1_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_0_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_0_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_1_0_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_1_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_1_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_1_1_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_1_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_1_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_2_0_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_2_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_2_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_2_1_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_2_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_2_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_3_0_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_3_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_3_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      TRACE_3_1_pipe_read_data : out std_logic_vector(31 downto 0);
      TRACE_3_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      TRACE_3_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for mcore_inst :  mcore_4x2x64 -- 
    use entity ajit_mcore_lib.mcore_4x2x64; -- 
  --<<<<<
  component peripherals is -- 
    port( -- 
      AFB_BUS_REQUEST_pipe_write_data : in std_logic_vector(73 downto 0);
      AFB_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      CONSOLE_to_SERIAL_RX_pipe_write_data : in std_logic_vector(7 downto 0);
      CONSOLE_to_SERIAL_RX_pipe_write_req  : in std_logic_vector(0  downto 0);
      CONSOLE_to_SERIAL_RX_pipe_write_ack  : out std_logic_vector(0  downto 0);
      EXTERNAL_INTERRUPT : in std_logic_vector(0 downto 0);
      AFB_BUS_RESPONSE_pipe_read_data : out std_logic_vector(32 downto 0);
      AFB_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      INTR_LEVEL_0_0 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_0_1 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_1_0 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_1_1 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_2_0 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_2_1 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_3_0 : out std_logic_vector(3 downto 0);
      INTR_LEVEL_3_1 : out std_logic_vector(3 downto 0);
      SERIAL_TX_to_CONSOLE_pipe_read_data : out std_logic_vector(7 downto 0);
      SERIAL_TX_to_CONSOLE_pipe_read_req  : in std_logic_vector(0  downto 0);
      SERIAL_TX_to_CONSOLE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for peripherals_isnt :  peripherals -- 
    use entity peripherals_lib.peripherals; -- 
  --<<<<<
  component pmodeGen is  -- 
    port (-- 
      PROCESSOR_MODE: out std_logic_vector(15 downto 0);
      TMODE_0_0: in std_logic_vector(3 downto 0);
      TMODE_0_1: in std_logic_vector(3 downto 0);
      TMODE_1_0: in std_logic_vector(3 downto 0);
      TMODE_1_1: in std_logic_vector(3 downto 0);
      TMODE_2_0: in std_logic_vector(3 downto 0);
      TMODE_2_1: in std_logic_vector(3 downto 0);
      TMODE_3_0: in std_logic_vector(3 downto 0);
      TMODE_3_1: in std_logic_vector(3 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for pmodeGenString :  pmodeGen -- 
    use entity ajit_processor_lib.pmodeGen; -- 
  --<<<<<
  component traceStubber is  -- 
    port (-- 
      trace: in std_logic_vector(31 downto 0);
      trace_pipe_read_req: out std_logic_vector(0 downto 0);
      trace_pipe_read_ack: in std_logic_vector(0 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for traceStubber_00 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_01 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_10 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_11 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_20 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_21 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_30 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -->>>>>
  for traceStubber_31 :  traceStubber -- 
    use entity ajit_processor_lib.traceStubber; -- 
  --<<<<<
  -- 
begin -- 
  mcore_inst: mcore_4x2x64
  port map ( --
    AFB_BUS_REQUEST_pipe_read_data => AFB_BUS_REQUEST_pipe_write_data,
    AFB_BUS_REQUEST_pipe_read_req => AFB_BUS_REQUEST_pipe_write_ack,
    AFB_BUS_REQUEST_pipe_read_ack => AFB_BUS_REQUEST_pipe_write_req,
    AFB_BUS_RESPONSE_pipe_write_data => AFB_BUS_RESPONSE_pipe_read_data,
    AFB_BUS_RESPONSE_pipe_write_req => AFB_BUS_RESPONSE_pipe_read_ack,
    AFB_BUS_RESPONSE_pipe_write_ack => AFB_BUS_RESPONSE_pipe_read_req,
    IRL_0_0 => IRL_0_0,
    IRL_0_1 => IRL_0_1,
    IRL_1_0 => IRL_1_0,
    IRL_1_1 => IRL_1_1,
    IRL_2_0 => IRL_2_0,
    IRL_2_1 => IRL_2_1,
    IRL_3_0 => IRL_3_0,
    IRL_3_1 => IRL_3_1,
    MAIN_MEM_INVALIDATE_pipe_write_data => MAIN_MEM_INVALIDATE_pipe_write_data,
    MAIN_MEM_INVALIDATE_pipe_write_req => MAIN_MEM_INVALIDATE_pipe_write_req,
    MAIN_MEM_INVALIDATE_pipe_write_ack => MAIN_MEM_INVALIDATE_pipe_write_ack,
    MAIN_MEM_REQUEST_pipe_read_data => MAIN_MEM_REQUEST_pipe_read_data,
    MAIN_MEM_REQUEST_pipe_read_req => MAIN_MEM_REQUEST_pipe_read_req,
    MAIN_MEM_REQUEST_pipe_read_ack => MAIN_MEM_REQUEST_pipe_read_ack,
    MAIN_MEM_RESPONSE_pipe_write_data => MAIN_MEM_RESPONSE_pipe_write_data,
    MAIN_MEM_RESPONSE_pipe_write_req => MAIN_MEM_RESPONSE_pipe_write_req,
    MAIN_MEM_RESPONSE_pipe_write_ack => MAIN_MEM_RESPONSE_pipe_write_ack,
    SOC_DEBUG_to_MONITOR_pipe_read_data => SOC_DEBUG_to_MONITOR_pipe_read_data,
    SOC_DEBUG_to_MONITOR_pipe_read_req => SOC_DEBUG_to_MONITOR_pipe_read_req,
    SOC_DEBUG_to_MONITOR_pipe_read_ack => SOC_DEBUG_to_MONITOR_pipe_read_ack,
    SOC_MONITOR_to_DEBUG_pipe_write_data => SOC_MONITOR_to_DEBUG_pipe_write_data,
    SOC_MONITOR_to_DEBUG_pipe_write_req => SOC_MONITOR_to_DEBUG_pipe_write_req,
    SOC_MONITOR_to_DEBUG_pipe_write_ack => SOC_MONITOR_to_DEBUG_pipe_write_ack,
    THREAD_RESET => THREAD_RESET,
    TMODE_0_0 => TMODE_0_0,
    TMODE_0_1 => TMODE_0_1,
    TMODE_1_0 => TMODE_1_0,
    TMODE_1_1 => TMODE_1_1,
    TMODE_2_0 => TMODE_2_0,
    TMODE_2_1 => TMODE_2_1,
    TMODE_3_0 => TMODE_3_0,
    TMODE_3_1 => TMODE_3_1,
    TRACE_0_0_pipe_read_data => TRACE_0_0_pipe_write_data,
    TRACE_0_0_pipe_read_req => TRACE_0_0_pipe_write_ack,
    TRACE_0_0_pipe_read_ack => TRACE_0_0_pipe_write_req,
    TRACE_0_1_pipe_read_data => TRACE_0_1_pipe_write_data,
    TRACE_0_1_pipe_read_req => TRACE_0_1_pipe_write_ack,
    TRACE_0_1_pipe_read_ack => TRACE_0_1_pipe_write_req,
    TRACE_1_0_pipe_read_data => TRACE_1_0_pipe_write_data,
    TRACE_1_0_pipe_read_req => TRACE_1_0_pipe_write_ack,
    TRACE_1_0_pipe_read_ack => TRACE_1_0_pipe_write_req,
    TRACE_1_1_pipe_read_data => TRACE_1_1_pipe_write_data,
    TRACE_1_1_pipe_read_req => TRACE_1_1_pipe_write_ack,
    TRACE_1_1_pipe_read_ack => TRACE_1_1_pipe_write_req,
    TRACE_2_0_pipe_read_data => TRACE_2_0_pipe_write_data,
    TRACE_2_0_pipe_read_req => TRACE_2_0_pipe_write_ack,
    TRACE_2_0_pipe_read_ack => TRACE_2_0_pipe_write_req,
    TRACE_2_1_pipe_read_data => TRACE_2_1_pipe_write_data,
    TRACE_2_1_pipe_read_req => TRACE_2_1_pipe_write_ack,
    TRACE_2_1_pipe_read_ack => TRACE_2_1_pipe_write_req,
    TRACE_3_0_pipe_read_data => TRACE_3_0_pipe_write_data,
    TRACE_3_0_pipe_read_req => TRACE_3_0_pipe_write_ack,
    TRACE_3_0_pipe_read_ack => TRACE_3_0_pipe_write_req,
    TRACE_3_1_pipe_read_data => TRACE_3_1_pipe_write_data,
    TRACE_3_1_pipe_read_req => TRACE_3_1_pipe_write_ack,
    TRACE_3_1_pipe_read_ack => TRACE_3_1_pipe_write_req,
    clk => clk, reset => reset 
    ); -- 
  peripherals_isnt: peripherals
  port map ( --
    AFB_BUS_REQUEST_pipe_write_data => AFB_BUS_REQUEST_pipe_read_data,
    AFB_BUS_REQUEST_pipe_write_req => AFB_BUS_REQUEST_pipe_read_ack,
    AFB_BUS_REQUEST_pipe_write_ack => AFB_BUS_REQUEST_pipe_read_req,
    AFB_BUS_RESPONSE_pipe_read_data => AFB_BUS_RESPONSE_pipe_write_data,
    AFB_BUS_RESPONSE_pipe_read_req => AFB_BUS_RESPONSE_pipe_write_ack,
    AFB_BUS_RESPONSE_pipe_read_ack => AFB_BUS_RESPONSE_pipe_write_req,
    CONSOLE_to_SERIAL_RX_pipe_write_data => CONSOLE_to_SERIAL_RX_pipe_write_data,
    CONSOLE_to_SERIAL_RX_pipe_write_req => CONSOLE_to_SERIAL_RX_pipe_write_req,
    CONSOLE_to_SERIAL_RX_pipe_write_ack => CONSOLE_to_SERIAL_RX_pipe_write_ack,
    EXTERNAL_INTERRUPT => EXTERNAL_INTERRUPT,
    INTR_LEVEL_0_0 => IRL_0_0,
    INTR_LEVEL_0_1 => IRL_0_1,
    INTR_LEVEL_1_0 => IRL_1_0,
    INTR_LEVEL_1_1 => IRL_1_1,
    INTR_LEVEL_2_0 => IRL_2_0,
    INTR_LEVEL_2_1 => IRL_2_1,
    INTR_LEVEL_3_0 => IRL_3_0,
    INTR_LEVEL_3_1 => IRL_3_1,
    SERIAL_TX_to_CONSOLE_pipe_read_data => SERIAL_TX_to_CONSOLE_pipe_read_data,
    SERIAL_TX_to_CONSOLE_pipe_read_req => SERIAL_TX_to_CONSOLE_pipe_read_req,
    SERIAL_TX_to_CONSOLE_pipe_read_ack => SERIAL_TX_to_CONSOLE_pipe_read_ack,
    clk => clk, reset => reset 
    ); -- 
  pmodeGenString: pmodeGen -- 
    port map ( -- 
      PROCESSOR_MODE => PROCESSOR_MODE,
      TMODE_0_0 => TMODE_0_0,
      TMODE_0_1 => TMODE_0_1,
      TMODE_1_0 => TMODE_1_0,
      TMODE_1_1 => TMODE_1_1,
      TMODE_2_0 => TMODE_2_0,
      TMODE_2_1 => TMODE_2_1,
      TMODE_3_0 => TMODE_3_0,
      TMODE_3_1 => TMODE_3_1,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_00: traceStubber -- 
    port map ( -- 
      trace => TRACE_0_0_pipe_read_data,
      trace_pipe_read_req => TRACE_0_0_pipe_read_req,
      trace_pipe_read_ack => TRACE_0_0_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_01: traceStubber -- 
    port map ( -- 
      trace => TRACE_0_1_pipe_read_data,
      trace_pipe_read_req => TRACE_0_1_pipe_read_req,
      trace_pipe_read_ack => TRACE_0_1_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_10: traceStubber -- 
    port map ( -- 
      trace => TRACE_1_0_pipe_read_data,
      trace_pipe_read_req => TRACE_1_0_pipe_read_req,
      trace_pipe_read_ack => TRACE_1_0_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_11: traceStubber -- 
    port map ( -- 
      trace => TRACE_1_1_pipe_read_data,
      trace_pipe_read_req => TRACE_1_1_pipe_read_req,
      trace_pipe_read_ack => TRACE_1_1_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_20: traceStubber -- 
    port map ( -- 
      trace => TRACE_2_0_pipe_read_data,
      trace_pipe_read_req => TRACE_2_0_pipe_read_req,
      trace_pipe_read_ack => TRACE_2_0_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_21: traceStubber -- 
    port map ( -- 
      trace => TRACE_2_1_pipe_read_data,
      trace_pipe_read_req => TRACE_2_1_pipe_read_req,
      trace_pipe_read_ack => TRACE_2_1_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_30: traceStubber -- 
    port map ( -- 
      trace => TRACE_3_0_pipe_read_data,
      trace_pipe_read_req => TRACE_3_0_pipe_read_req,
      trace_pipe_read_ack => TRACE_3_0_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  traceStubber_31: traceStubber -- 
    port map ( -- 
      trace => TRACE_3_1_pipe_read_data,
      trace_pipe_read_req => TRACE_3_1_pipe_read_req,
      trace_pipe_read_ack => TRACE_3_1_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  AFB_BUS_REQUEST_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe AFB_BUS_REQUEST",
      num_reads => 1,
      num_writes => 1,
      data_width => 74,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => AFB_BUS_REQUEST_pipe_read_req,
      read_ack => AFB_BUS_REQUEST_pipe_read_ack,
      read_data => AFB_BUS_REQUEST_pipe_read_data,
      write_req => AFB_BUS_REQUEST_pipe_write_req,
      write_ack => AFB_BUS_REQUEST_pipe_write_ack,
      write_data => AFB_BUS_REQUEST_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  AFB_BUS_RESPONSE_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe AFB_BUS_RESPONSE",
      num_reads => 1,
      num_writes => 1,
      data_width => 33,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => AFB_BUS_RESPONSE_pipe_read_req,
      read_ack => AFB_BUS_RESPONSE_pipe_read_ack,
      read_data => AFB_BUS_RESPONSE_pipe_read_data,
      write_req => AFB_BUS_RESPONSE_pipe_write_req,
      write_ack => AFB_BUS_RESPONSE_pipe_write_ack,
      write_data => AFB_BUS_RESPONSE_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_0_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_0_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_0_0_pipe_read_req,
      read_ack => TRACE_0_0_pipe_read_ack,
      read_data => TRACE_0_0_pipe_read_data,
      write_req => TRACE_0_0_pipe_write_req,
      write_ack => TRACE_0_0_pipe_write_ack,
      write_data => TRACE_0_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_0_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_0_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_0_1_pipe_read_req,
      read_ack => TRACE_0_1_pipe_read_ack,
      read_data => TRACE_0_1_pipe_read_data,
      write_req => TRACE_0_1_pipe_write_req,
      write_ack => TRACE_0_1_pipe_write_ack,
      write_data => TRACE_0_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_1_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_1_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_1_0_pipe_read_req,
      read_ack => TRACE_1_0_pipe_read_ack,
      read_data => TRACE_1_0_pipe_read_data,
      write_req => TRACE_1_0_pipe_write_req,
      write_ack => TRACE_1_0_pipe_write_ack,
      write_data => TRACE_1_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_1_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_1_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_1_1_pipe_read_req,
      read_ack => TRACE_1_1_pipe_read_ack,
      read_data => TRACE_1_1_pipe_read_data,
      write_req => TRACE_1_1_pipe_write_req,
      write_ack => TRACE_1_1_pipe_write_ack,
      write_data => TRACE_1_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_2_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_2_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_2_0_pipe_read_req,
      read_ack => TRACE_2_0_pipe_read_ack,
      read_data => TRACE_2_0_pipe_read_data,
      write_req => TRACE_2_0_pipe_write_req,
      write_ack => TRACE_2_0_pipe_write_ack,
      write_data => TRACE_2_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_2_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_2_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_2_1_pipe_read_req,
      read_ack => TRACE_2_1_pipe_read_ack,
      read_data => TRACE_2_1_pipe_read_data,
      write_req => TRACE_2_1_pipe_write_req,
      write_ack => TRACE_2_1_pipe_write_ack,
      write_data => TRACE_2_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_3_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_3_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_3_0_pipe_read_req,
      read_ack => TRACE_3_0_pipe_read_ack,
      read_data => TRACE_3_0_pipe_read_data,
      write_req => TRACE_3_0_pipe_write_req,
      write_ack => TRACE_3_0_pipe_write_ack,
      write_data => TRACE_3_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  TRACE_3_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe TRACE_3_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 3 --
    )
    port map( -- 
      read_req => TRACE_3_1_pipe_read_req,
      read_ack => TRACE_3_1_pipe_read_ack,
      read_data => TRACE_3_1_pipe_read_data,
      write_req => TRACE_3_1_pipe_write_req,
      write_ack => TRACE_3_1_pipe_write_ack,
      write_data => TRACE_3_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- 
end struct;
