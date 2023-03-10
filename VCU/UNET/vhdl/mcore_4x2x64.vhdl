library ieee;
use ieee.std_logic_1164.all;
package mcore_4x2x64_Type_Package is -- 
  subtype unsigned_7_downto_0 is std_logic_vector(7 downto 0);
  subtype unsigned_3_downto_0 is std_logic_vector(3 downto 0);
  subtype unsigned_0_downto_0 is std_logic_vector(0 downto 0);
  subtype unsigned_35_downto_0 is std_logic_vector(35 downto 0);
  subtype unsigned_109_downto_0 is std_logic_vector(109 downto 0);
  subtype unsigned_110_downto_0 is std_logic_vector(110 downto 0);
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
library ajit_mcore_lib;
use ajit_mcore_lib.mcore_4x2x64_Type_Package.all;
entity blockToNoblock is  -- 
  port (-- 
    NREQ: out std_logic_vector(110 downto 0);
    NREQ_pipe_write_req: out std_logic_vector(0 downto 0);
    NREQ_pipe_write_ack: in std_logic_vector(0 downto 0);
    REQ: in std_logic_vector(109 downto 0);
    REQ_pipe_read_req: out std_logic_vector(0 downto 0);
    REQ_pipe_read_ack: in std_logic_vector(0 downto 0);
    clk, reset: in std_logic); --
  --
end entity blockToNoblock;
architecture rtlThreadArch of blockToNoblock is --
  type ThreadState is (s_sc_b_state);
  signal current_thread_state : ThreadState;
  signal NREQ_buffer: unsigned_110_downto_0;
  constant O1: unsigned_0_downto_0 := "1";
  --
begin -- 
  NREQ <= NREQ_buffer;
  process(clk, reset, current_thread_state , NREQ_pipe_write_ack, REQ, REQ_pipe_read_ack) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  NREQ$req  :=  REQ$ack 
    NREQ_pipe_write_req <= REQ_pipe_read_ack;
    --  $now  REQ$req  :=  NREQ$ack 
    REQ_pipe_read_req <= NREQ_pipe_write_ack;
    --  $now  NREQ := (  O1 &&  REQ) 
    NREQ_buffer <= (O1 & REQ);
    -- case statement 
    case current_thread_state is -- 
      when s_sc_b_state => -- 
        next_thread_state := s_sc_b_state;
        next_thread_state := s_sc_b_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_sc_b_state;
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
library ajit_mcore_lib;
use ajit_mcore_lib.mcore_4x2x64_Type_Package.all;
entity irlPmodeConverter is  -- 
  port (-- 
    IRL4: in std_logic_vector(3 downto 0);
    IRL8: out std_logic_vector(7 downto 0);
    PMODE: in std_logic_vector(7 downto 0);
    PMODE_pipe_read_req: out std_logic_vector(0 downto 0);
    PMODE_pipe_read_ack: in std_logic_vector(0 downto 0);
    PMODES: out std_logic_vector(3 downto 0);
    clk, reset: in std_logic); --
  --
end entity irlPmodeConverter;
architecture rtlThreadArch of irlPmodeConverter is --
  type ThreadState is (s_cccc_i_state);
  signal current_thread_state : ThreadState;
  signal IRL8_buffer: unsigned_7_downto_0;
  signal PMODES_buffer: unsigned_3_downto_0;
  constant o1: unsigned_0_downto_0 := "1";
  constant z4: unsigned_3_downto_0 := "0000";
  --
begin -- 
  IRL8 <= IRL8_buffer;
  PMODES <= PMODES_buffer;
  process(clk, reset, current_thread_state , IRL4, PMODE, PMODE_pipe_read_ack) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  IRL8 := (  z4 &&  IRL4) 
    IRL8_buffer <= (z4 & IRL4);
    --  $now  PMODE$req  :=  o1
    PMODE_pipe_read_req <= o1;
    --  $now  PMODES := ($slice  PMODE 3 0) 
    PMODES_buffer <= PMODE(3 downto 0);
    -- case statement 
    case current_thread_state is -- 
      when s_cccc_i_state => -- 
        next_thread_state := s_cccc_i_state;
        next_thread_state := s_cccc_i_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_cccc_i_state;
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
library ajit_mcore_lib;
use ajit_mcore_lib.mcore_4x2x64_Type_Package.all;
entity resetConverter is  -- 
  port (-- 
    RST4: in std_logic_vector(3 downto 0);
    RST8: out std_logic_vector(7 downto 0);
    clk, reset: in std_logic); --
  --
end entity resetConverter;
architecture rtlThreadArch of resetConverter is --
  type ThreadState is (s_rc_rst_state);
  signal current_thread_state : ThreadState;
  signal RST8_buffer: unsigned_7_downto_0;
  constant z4: unsigned_3_downto_0 := "0000";
  --
begin -- 
  RST8 <= RST8_buffer;
  process(clk, reset, current_thread_state , RST4) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  RST8 := (  z4 &&  RST4) 
    RST8_buffer <= (z4 & RST4);
    -- case statement 
    case current_thread_state is -- 
      when s_rc_rst_state => -- 
        next_thread_state := s_rc_rst_state;
        next_thread_state := s_rc_rst_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_rc_rst_state;
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
library ajit_mcore_lib;
use ajit_mcore_lib.mcore_4x2x64_Type_Package.all;
entity setConfiguration is  -- 
  port (-- 
    CORE_ID_0: out std_logic_vector(7 downto 0);
    CORE_ID_1: out std_logic_vector(7 downto 0);
    CORE_ID_2: out std_logic_vector(7 downto 0);
    CORE_ID_3: out std_logic_vector(7 downto 0);
    IO_MAX_ADDR: out std_logic_vector(35 downto 0);
    IO_MIN_ADDR: out std_logic_vector(35 downto 0);
    clk, reset: in std_logic); --
  --
end entity setConfiguration;
architecture rtlThreadArch of setConfiguration is --
  type ThreadState is (s_sc_i_state);
  signal current_thread_state : ThreadState;
  signal CORE_ID_0_buffer: unsigned_7_downto_0;
  signal CORE_ID_1_buffer: unsigned_7_downto_0;
  signal CORE_ID_2_buffer: unsigned_7_downto_0;
  signal CORE_ID_3_buffer: unsigned_7_downto_0;
  signal IO_MAX_ADDR_buffer: unsigned_35_downto_0;
  signal IO_MIN_ADDR_buffer: unsigned_35_downto_0;
  --
begin -- 
  CORE_ID_0 <= CORE_ID_0_buffer;
  CORE_ID_1 <= CORE_ID_1_buffer;
  CORE_ID_2 <= CORE_ID_2_buffer;
  CORE_ID_3 <= CORE_ID_3_buffer;
  IO_MAX_ADDR <= IO_MAX_ADDR_buffer;
  IO_MIN_ADDR <= IO_MIN_ADDR_buffer;
  process(clk, reset, current_thread_state ) --
    -- declared variables and implied variables 
    variable next_thread_state : ThreadState;
    --
  begin -- 
    -- default values 
    next_thread_state := current_thread_state;
    -- default initializations... 
    --  $now  CORE_ID_0 :=  ( $unsigned<8> )  00000000 
    CORE_ID_0_buffer <= "00000000";
    --  $now  CORE_ID_1 :=  ( $unsigned<8> )  00000001 
    CORE_ID_1_buffer <= "00000001";
    --  $now  CORE_ID_2 :=  ( $unsigned<8> )  00000010 
    CORE_ID_2_buffer <= "00000010";
    --  $now  CORE_ID_3 :=  ( $unsigned<8> )  00000011 
    CORE_ID_3_buffer <= "00000011";
    --  $now  IO_MIN_ADDR :=  ( $unsigned<36> )  000011111111111111110000000000000000 
    IO_MIN_ADDR_buffer <= "000011111111111111110000000000000000";
    --  $now  IO_MAX_ADDR :=  ( $unsigned<36> )  000011111111111111111111111111111111 
    IO_MAX_ADDR_buffer <= "000011111111111111111111111111111111";
    -- case statement 
    case current_thread_state is -- 
      when s_sc_i_state => -- 
        next_thread_state := s_sc_i_state;
        next_thread_state := s_sc_i_state;
        --
      --
    end case;
    if (clk'event and clk = '1') then -- 
      if (reset = '1') then -- 
        current_thread_state <= s_sc_i_state;
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
library ajit_mcore_lib;
use ajit_mcore_lib.mcore_4x2x64_Type_Package.all;
--<<<<<
-->>>>>
library GlueModules;
library ajit_core_lib;
library ajit_core_lib;
library ajit_core_lib;
library ajit_core_lib;
library GlueModules;
library GlueModules;
--<<<<<
entity mcore_4x2x64 is -- 
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
end entity mcore_4x2x64;
architecture struct of mcore_4x2x64 is -- 
  signal CACHE_STALL_ENABLE : std_logic_vector(0 downto 0);
  signal CORE_ID_0 : std_logic_vector(7 downto 0);
  signal CORE_ID_1 : std_logic_vector(7 downto 0);
  signal CORE_ID_2 : std_logic_vector(7 downto 0);
  signal CORE_ID_3 : std_logic_vector(7 downto 0);
  signal CORE_REQUEST_0_pipe_write_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_0_pipe_read_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_1_pipe_write_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_1_pipe_read_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_2_pipe_write_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_2_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_2_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_2_pipe_read_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_2_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_2_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_3_pipe_write_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_3_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_3_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_3_pipe_read_data: std_logic_vector(109 downto 0);
  signal CORE_REQUEST_3_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_REQUEST_3_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_0_pipe_write_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_0_pipe_read_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_1_pipe_write_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_1_pipe_read_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_2_pipe_write_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_2_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_2_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_2_pipe_read_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_2_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_2_pipe_read_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_3_pipe_write_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_3_pipe_write_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_3_pipe_write_ack : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_3_pipe_read_data: std_logic_vector(64 downto 0);
  signal CORE_RESPONSE_3_pipe_read_req : std_logic_vector(0  downto 0);
  signal CORE_RESPONSE_3_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_0_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_0_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_0_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_0_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_0_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_1_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_1_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_1_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_1_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_1_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_2_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_2_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_2_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_2_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_2_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_3_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_3_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_3_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_COMMAND_3_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_COMMAND_3_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_0_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_1_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_2_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_write_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_read_data: std_logic_vector(31 downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal DEBUG_RESPONSE_3_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_write_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_read_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_write_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_read_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_write_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_write_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_write_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_read_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_read_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_2_pipe_read_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_write_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_write_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_write_ack : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_read_data: std_logic_vector(29 downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_read_req : std_logic_vector(0  downto 0);
  signal INVALIDATE_TO_CORE_3_pipe_read_ack : std_logic_vector(0  downto 0);
  signal IO_MAX_ADDR : std_logic_vector(35 downto 0);
  signal IO_MIN_ADDR : std_logic_vector(35 downto 0);
  signal IRL8_0_0 : std_logic_vector(7 downto 0);
  signal IRL8_0_1 : std_logic_vector(7 downto 0);
  signal IRL8_1_0 : std_logic_vector(7 downto 0);
  signal IRL8_1_1 : std_logic_vector(7 downto 0);
  signal IRL8_2_0 : std_logic_vector(7 downto 0);
  signal IRL8_2_1 : std_logic_vector(7 downto 0);
  signal IRL8_3_0 : std_logic_vector(7 downto 0);
  signal IRL8_3_1 : std_logic_vector(7 downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_write_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_read_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_write_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_read_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_write_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_write_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_write_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_read_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_read_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_2_pipe_read_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_write_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_write_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_write_ack : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_read_data: std_logic_vector(110 downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_read_req : std_logic_vector(0  downto 0);
  signal NOBLOCK_CORE_REQUEST_3_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_REQUEST_pipe_write_data: std_logic_vector(109 downto 0);
  signal PERIPH_MEM_REQUEST_pipe_write_req : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_REQUEST_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_REQUEST_pipe_read_data: std_logic_vector(109 downto 0);
  signal PERIPH_MEM_REQUEST_pipe_read_req : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_REQUEST_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_write_data: std_logic_vector(64 downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_write_req : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_read_data: std_logic_vector(64 downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_read_req : std_logic_vector(0  downto 0);
  signal PERIPH_MEM_RESPONSE_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_0_0_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_0_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_0_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_0_0_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_0_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_0_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_0_1_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_0_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_0_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_0_1_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_0_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_0_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_1_0_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_1_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_1_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_1_0_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_1_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_1_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_1_1_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_1_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_1_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_1_1_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_1_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_1_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_2_0_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_2_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_2_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_2_0_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_2_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_2_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_2_1_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_2_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_2_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_2_1_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_2_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_2_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_3_0_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_3_0_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_3_0_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_3_0_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_3_0_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_3_0_pipe_read_ack : std_logic_vector(0  downto 0);
  signal PMODE_3_1_pipe_write_data: std_logic_vector(7 downto 0);
  signal PMODE_3_1_pipe_write_req : std_logic_vector(0  downto 0);
  signal PMODE_3_1_pipe_write_ack : std_logic_vector(0  downto 0);
  signal PMODE_3_1_pipe_read_data: std_logic_vector(7 downto 0);
  signal PMODE_3_1_pipe_read_req : std_logic_vector(0  downto 0);
  signal PMODE_3_1_pipe_read_ack : std_logic_vector(0  downto 0);
  signal THREAD_RESET_0_8 : std_logic_vector(7 downto 0);
  signal THREAD_RESET_1_8 : std_logic_vector(7 downto 0);
  component acb_afb_bridge is -- 
    port( -- 
      AFB_BUS_RESPONSE_pipe_write_data : in std_logic_vector(32 downto 0);
      AFB_BUS_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      CORE_BUS_REQUEST_pipe_write_data : in std_logic_vector(109 downto 0);
      CORE_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      CORE_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AFB_BUS_REQUEST_pipe_read_data : out std_logic_vector(73 downto 0);
      AFB_BUS_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      AFB_BUS_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      CORE_BUS_RESPONSE_pipe_read_data : out std_logic_vector(64 downto 0);
      CORE_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for acb_afb_bridge_inst :  acb_afb_bridge -- 
    use entity GlueModules.acb_afb_bridge; -- 
  --<<<<<
  component core_2x64 is -- 
    port( -- 
      CACHE_STALL_ENABLE : in std_logic_vector(0 downto 0);
      CORE_BUS_RESPONSE_pipe_write_data : in std_logic_vector(64 downto 0);
      CORE_BUS_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
      CORE_BUS_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      CORE_ID : in std_logic_vector(7 downto 0);
      ENV_to_AJIT_debug_command_0_pipe_write_data : in std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_0_pipe_write_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_0_pipe_write_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_pipe_write_data : in std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_1_pipe_write_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_pipe_write_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_reset_0 : in std_logic_vector(7 downto 0);
      ENV_to_AJIT_reset_1 : in std_logic_vector(7 downto 0);
      ENV_to_CPU_irl_0 : in std_logic_vector(7 downto 0);
      ENV_to_CPU_irl_1 : in std_logic_vector(7 downto 0);
      INVALIDATE_REQUEST_pipe_write_data : in std_logic_vector(29 downto 0);
      INVALIDATE_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      INVALIDATE_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_0_pipe_read_data : out std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_pipe_read_data : out std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_logger_0_pipe_read_data : out std_logic_vector(31 downto 0);
      AJIT_to_ENV_logger_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_logger_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_logger_1_pipe_read_data : out std_logic_vector(31 downto 0);
      AJIT_to_ENV_logger_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_logger_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_processor_mode_0_pipe_read_data : out std_logic_vector(7 downto 0);
      AJIT_to_ENV_processor_mode_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_processor_mode_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_processor_mode_1_pipe_read_data : out std_logic_vector(7 downto 0);
      AJIT_to_ENV_processor_mode_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_processor_mode_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      CORE_BUS_REQUEST_pipe_read_data : out std_logic_vector(109 downto 0);
      CORE_BUS_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_BUS_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for core_0_inst :  core_2x64 -- 
    use entity ajit_core_lib.core_2x64; -- 
  --<<<<<
  -->>>>>
  for core_1_inst :  core_2x64 -- 
    use entity ajit_core_lib.core_2x64; -- 
  --<<<<<
  -->>>>>
  for core_2_inst :  core_2x64 -- 
    use entity ajit_core_lib.core_2x64; -- 
  --<<<<<
  -->>>>>
  for core_3_inst :  core_2x64 -- 
    use entity ajit_core_lib.core_2x64; -- 
  --<<<<<
  component debug_aggregator_four_core is -- 
    port( -- 
      AJIT_to_ENV_debug_response_0_0_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_0_0_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_0_0_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_0_1_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_0_1_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_0_1_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_0_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_1_0_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_0_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_1_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_1_1_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_1_1_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_2_0_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_2_0_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_2_0_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_2_1_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_2_1_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_2_1_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_3_0_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_3_0_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_3_0_pipe_write_ack  : out std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_3_1_pipe_write_data : in std_logic_vector(31 downto 0);
      AJIT_to_ENV_debug_response_3_1_pipe_write_req  : in std_logic_vector(0  downto 0);
      AJIT_to_ENV_debug_response_3_1_pipe_write_ack  : out std_logic_vector(0  downto 0);
      SOC_MONITOR_to_DEBUG_pipe_write_data : in std_logic_vector(7 downto 0);
      SOC_MONITOR_to_DEBUG_pipe_write_req  : in std_logic_vector(0  downto 0);
      SOC_MONITOR_to_DEBUG_pipe_write_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_0_0_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_0_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_0_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_0_1_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_0_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_0_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_0_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_1_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_1_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_1_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_1_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_2_0_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_2_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_2_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_2_1_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_2_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_2_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_3_0_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_3_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_3_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_3_1_pipe_read_data : out std_logic_vector(31 downto 0);
      ENV_to_AJIT_debug_command_3_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      ENV_to_AJIT_debug_command_3_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_data : out std_logic_vector(7 downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_req  : in std_logic_vector(0  downto 0);
      SOC_DEBUG_to_MONITOR_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for debug_aggr_inst :  debug_aggregator_four_core -- 
    use entity GlueModules.debug_aggregator_four_core; -- 
  --<<<<<
  component coherent_memory_controller_four_core_v2 is -- 
    port( -- 
      IO_CORE_BUS_RESPONSE_pipe_write_data : in std_logic_vector(64 downto 0);
      IO_CORE_BUS_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
      IO_CORE_BUS_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      IO_MAX_ADDR : in std_logic_vector(35 downto 0);
      IO_MIN_ADDR : in std_logic_vector(35 downto 0);
      MAIN_MEM_INVALIDATE_pipe_write_data : in std_logic_vector(29 downto 0);
      MAIN_MEM_INVALIDATE_pipe_write_req  : in std_logic_vector(0  downto 0);
      MAIN_MEM_INVALIDATE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      MAIN_MEM_RESPONSE_pipe_write_data : in std_logic_vector(64 downto 0);
      MAIN_MEM_RESPONSE_pipe_write_req  : in std_logic_vector(0  downto 0);
      MAIN_MEM_RESPONSE_pipe_write_ack  : out std_logic_vector(0  downto 0);
      NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_data : in std_logic_vector(110 downto 0);
      NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_data : in std_logic_vector(110 downto 0);
      NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_data : in std_logic_vector(110 downto 0);
      NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_data : in std_logic_vector(110 downto 0);
      NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      CACHE_STALL_ENABLE : out std_logic_vector(0 downto 0);
      CORE_0_BUS_RESPONSE_pipe_read_data : out std_logic_vector(64 downto 0);
      CORE_0_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_0_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      CORE_1_BUS_RESPONSE_pipe_read_data : out std_logic_vector(64 downto 0);
      CORE_1_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_1_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      CORE_2_BUS_RESPONSE_pipe_read_data : out std_logic_vector(64 downto 0);
      CORE_2_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_2_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      CORE_3_BUS_RESPONSE_pipe_read_data : out std_logic_vector(64 downto 0);
      CORE_3_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      CORE_3_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_0_pipe_read_data : out std_logic_vector(29 downto 0);
      INVALIDATE_TO_CORE_0_pipe_read_req  : in std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_0_pipe_read_ack  : out std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_1_pipe_read_data : out std_logic_vector(29 downto 0);
      INVALIDATE_TO_CORE_1_pipe_read_req  : in std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_1_pipe_read_ack  : out std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_2_pipe_read_data : out std_logic_vector(29 downto 0);
      INVALIDATE_TO_CORE_2_pipe_read_req  : in std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_2_pipe_read_ack  : out std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_3_pipe_read_data : out std_logic_vector(29 downto 0);
      INVALIDATE_TO_CORE_3_pipe_read_req  : in std_logic_vector(0  downto 0);
      INVALIDATE_TO_CORE_3_pipe_read_ack  : out std_logic_vector(0  downto 0);
      IO_CORE_BUS_REQUEST_pipe_read_data : out std_logic_vector(109 downto 0);
      IO_CORE_BUS_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      IO_CORE_BUS_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      MAIN_MEM_REQUEST_pipe_read_data : out std_logic_vector(109 downto 0);
      MAIN_MEM_REQUEST_pipe_read_req  : in std_logic_vector(0  downto 0);
      MAIN_MEM_REQUEST_pipe_read_ack  : out std_logic_vector(0  downto 0);
      clk, reset: in std_logic 
      -- 
    );
    --
  end component;
  -->>>>>
  for mem_ctrllr_inst :  coherent_memory_controller_four_core_v2 -- 
    use entity GlueModules.coherent_memory_controller_four_core_v2; -- 
  --<<<<<
  component resetConverter is  -- 
    port (-- 
      RST4: in std_logic_vector(3 downto 0);
      RST8: out std_logic_vector(7 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for resetConv_str_0 :  resetConverter -- 
    use entity ajit_mcore_lib.resetConverter; -- 
  --<<<<<
  -->>>>>
  for resetConv_str_1 :  resetConverter -- 
    use entity ajit_mcore_lib.resetConverter; -- 
  --<<<<<
  component irlPmodeConverter is  -- 
    port (-- 
      IRL4: in std_logic_vector(3 downto 0);
      IRL8: out std_logic_vector(7 downto 0);
      PMODE: in std_logic_vector(7 downto 0);
      PMODE_pipe_read_req: out std_logic_vector(0 downto 0);
      PMODE_pipe_read_ack: in std_logic_vector(0 downto 0);
      PMODES: out std_logic_vector(3 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for irlResetPmode_0_0 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlResetPmode_0_1 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_1_0 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_1_1 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_2_0 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_2_1 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_3_0 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  -->>>>>
  for irlPmode_3_1 :  irlPmodeConverter -- 
    use entity ajit_mcore_lib.irlPmodeConverter; -- 
  --<<<<<
  component setConfiguration is  -- 
    port (-- 
      CORE_ID_0: out std_logic_vector(7 downto 0);
      CORE_ID_1: out std_logic_vector(7 downto 0);
      CORE_ID_2: out std_logic_vector(7 downto 0);
      CORE_ID_3: out std_logic_vector(7 downto 0);
      IO_MAX_ADDR: out std_logic_vector(35 downto 0);
      IO_MIN_ADDR: out std_logic_vector(35 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for sCS :  setConfiguration -- 
    use entity ajit_mcore_lib.setConfiguration; -- 
  --<<<<<
  component blockToNoblock is  -- 
    port (-- 
      NREQ: out std_logic_vector(110 downto 0);
      NREQ_pipe_write_req: out std_logic_vector(0 downto 0);
      NREQ_pipe_write_ack: in std_logic_vector(0 downto 0);
      REQ: in std_logic_vector(109 downto 0);
      REQ_pipe_read_req: out std_logic_vector(0 downto 0);
      REQ_pipe_read_ack: in std_logic_vector(0 downto 0);
      clk, reset: in std_logic); --
    --
  end component;
  -->>>>>
  for b2n_0 :  blockToNoblock -- 
    use entity ajit_mcore_lib.blockToNoblock; -- 
  --<<<<<
  -->>>>>
  for b2n_1 :  blockToNoblock -- 
    use entity ajit_mcore_lib.blockToNoblock; -- 
  --<<<<<
  -->>>>>
  for b2n_2 :  blockToNoblock -- 
    use entity ajit_mcore_lib.blockToNoblock; -- 
  --<<<<<
  -->>>>>
  for b2n_3 :  blockToNoblock -- 
    use entity ajit_mcore_lib.blockToNoblock; -- 
  --<<<<<
  -- 
begin -- 
  acb_afb_bridge_inst: acb_afb_bridge
  port map ( --
    AFB_BUS_REQUEST_pipe_read_data => AFB_BUS_REQUEST_pipe_read_data,
    AFB_BUS_REQUEST_pipe_read_req => AFB_BUS_REQUEST_pipe_read_req,
    AFB_BUS_REQUEST_pipe_read_ack => AFB_BUS_REQUEST_pipe_read_ack,
    AFB_BUS_RESPONSE_pipe_write_data => AFB_BUS_RESPONSE_pipe_write_data,
    AFB_BUS_RESPONSE_pipe_write_req => AFB_BUS_RESPONSE_pipe_write_req,
    AFB_BUS_RESPONSE_pipe_write_ack => AFB_BUS_RESPONSE_pipe_write_ack,
    CORE_BUS_REQUEST_pipe_write_data => PERIPH_MEM_REQUEST_pipe_read_data,
    CORE_BUS_REQUEST_pipe_write_req => PERIPH_MEM_REQUEST_pipe_read_ack,
    CORE_BUS_REQUEST_pipe_write_ack => PERIPH_MEM_REQUEST_pipe_read_req,
    CORE_BUS_RESPONSE_pipe_read_data => PERIPH_MEM_RESPONSE_pipe_write_data,
    CORE_BUS_RESPONSE_pipe_read_req => PERIPH_MEM_RESPONSE_pipe_write_ack,
    CORE_BUS_RESPONSE_pipe_read_ack => PERIPH_MEM_RESPONSE_pipe_write_req,
    clk => clk, reset => reset 
    ); -- 
  core_0_inst: core_2x64
  port map ( --
    AJIT_to_ENV_debug_response_0_pipe_read_data => DEBUG_RESPONSE_0_0_pipe_write_data,
    AJIT_to_ENV_debug_response_0_pipe_read_req => DEBUG_RESPONSE_0_0_pipe_write_ack,
    AJIT_to_ENV_debug_response_0_pipe_read_ack => DEBUG_RESPONSE_0_0_pipe_write_req,
    AJIT_to_ENV_debug_response_1_pipe_read_data => DEBUG_RESPONSE_0_1_pipe_write_data,
    AJIT_to_ENV_debug_response_1_pipe_read_req => DEBUG_RESPONSE_0_1_pipe_write_ack,
    AJIT_to_ENV_debug_response_1_pipe_read_ack => DEBUG_RESPONSE_0_1_pipe_write_req,
    AJIT_to_ENV_logger_0_pipe_read_data => TRACE_0_0_pipe_read_data,
    AJIT_to_ENV_logger_0_pipe_read_req => TRACE_0_0_pipe_read_req,
    AJIT_to_ENV_logger_0_pipe_read_ack => TRACE_0_0_pipe_read_ack,
    AJIT_to_ENV_logger_1_pipe_read_data => TRACE_0_1_pipe_read_data,
    AJIT_to_ENV_logger_1_pipe_read_req => TRACE_0_1_pipe_read_req,
    AJIT_to_ENV_logger_1_pipe_read_ack => TRACE_0_1_pipe_read_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_data => PMODE_0_0_pipe_write_data,
    AJIT_to_ENV_processor_mode_0_pipe_read_req => PMODE_0_0_pipe_write_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_ack => PMODE_0_0_pipe_write_req,
    AJIT_to_ENV_processor_mode_1_pipe_read_data => PMODE_0_1_pipe_write_data,
    AJIT_to_ENV_processor_mode_1_pipe_read_req => PMODE_0_1_pipe_write_ack,
    AJIT_to_ENV_processor_mode_1_pipe_read_ack => PMODE_0_1_pipe_write_req,
    CACHE_STALL_ENABLE => CACHE_STALL_ENABLE,
    CORE_BUS_REQUEST_pipe_read_data => CORE_REQUEST_0_pipe_write_data,
    CORE_BUS_REQUEST_pipe_read_req => CORE_REQUEST_0_pipe_write_ack,
    CORE_BUS_REQUEST_pipe_read_ack => CORE_REQUEST_0_pipe_write_req,
    CORE_BUS_RESPONSE_pipe_write_data => CORE_RESPONSE_0_pipe_read_data,
    CORE_BUS_RESPONSE_pipe_write_req => CORE_RESPONSE_0_pipe_read_ack,
    CORE_BUS_RESPONSE_pipe_write_ack => CORE_RESPONSE_0_pipe_read_req,
    CORE_ID => CORE_ID_0,
    ENV_to_AJIT_debug_command_0_pipe_write_data => DEBUG_COMMAND_0_0_pipe_read_data,
    ENV_to_AJIT_debug_command_0_pipe_write_req => DEBUG_COMMAND_0_0_pipe_read_ack,
    ENV_to_AJIT_debug_command_0_pipe_write_ack => DEBUG_COMMAND_0_0_pipe_read_req,
    ENV_to_AJIT_debug_command_1_pipe_write_data => DEBUG_COMMAND_0_1_pipe_read_data,
    ENV_to_AJIT_debug_command_1_pipe_write_req => DEBUG_COMMAND_0_1_pipe_read_ack,
    ENV_to_AJIT_debug_command_1_pipe_write_ack => DEBUG_COMMAND_0_1_pipe_read_req,
    ENV_to_AJIT_reset_0 => THREAD_RESET_0_8,
    ENV_to_AJIT_reset_1 => THREAD_RESET_1_8,
    ENV_to_CPU_irl_0 => IRL8_0_0,
    ENV_to_CPU_irl_1 => IRL8_0_1,
    INVALIDATE_REQUEST_pipe_write_data => INVALIDATE_TO_CORE_0_pipe_read_data,
    INVALIDATE_REQUEST_pipe_write_req => INVALIDATE_TO_CORE_0_pipe_read_ack,
    INVALIDATE_REQUEST_pipe_write_ack => INVALIDATE_TO_CORE_0_pipe_read_req,
    clk => clk, reset => reset 
    ); -- 
  core_1_inst: core_2x64
  port map ( --
    AJIT_to_ENV_debug_response_0_pipe_read_data => DEBUG_RESPONSE_1_0_pipe_write_data,
    AJIT_to_ENV_debug_response_0_pipe_read_req => DEBUG_RESPONSE_1_0_pipe_write_ack,
    AJIT_to_ENV_debug_response_0_pipe_read_ack => DEBUG_RESPONSE_1_0_pipe_write_req,
    AJIT_to_ENV_debug_response_1_pipe_read_data => DEBUG_RESPONSE_1_1_pipe_write_data,
    AJIT_to_ENV_debug_response_1_pipe_read_req => DEBUG_RESPONSE_1_1_pipe_write_ack,
    AJIT_to_ENV_debug_response_1_pipe_read_ack => DEBUG_RESPONSE_1_1_pipe_write_req,
    AJIT_to_ENV_logger_0_pipe_read_data => TRACE_1_0_pipe_read_data,
    AJIT_to_ENV_logger_0_pipe_read_req => TRACE_1_0_pipe_read_req,
    AJIT_to_ENV_logger_0_pipe_read_ack => TRACE_1_0_pipe_read_ack,
    AJIT_to_ENV_logger_1_pipe_read_data => TRACE_1_1_pipe_read_data,
    AJIT_to_ENV_logger_1_pipe_read_req => TRACE_1_1_pipe_read_req,
    AJIT_to_ENV_logger_1_pipe_read_ack => TRACE_1_1_pipe_read_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_data => PMODE_1_0_pipe_write_data,
    AJIT_to_ENV_processor_mode_0_pipe_read_req => PMODE_1_0_pipe_write_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_ack => PMODE_1_0_pipe_write_req,
    AJIT_to_ENV_processor_mode_1_pipe_read_data => PMODE_1_1_pipe_write_data,
    AJIT_to_ENV_processor_mode_1_pipe_read_req => PMODE_1_1_pipe_write_ack,
    AJIT_to_ENV_processor_mode_1_pipe_read_ack => PMODE_1_1_pipe_write_req,
    CACHE_STALL_ENABLE => CACHE_STALL_ENABLE,
    CORE_BUS_REQUEST_pipe_read_data => CORE_REQUEST_1_pipe_write_data,
    CORE_BUS_REQUEST_pipe_read_req => CORE_REQUEST_1_pipe_write_ack,
    CORE_BUS_REQUEST_pipe_read_ack => CORE_REQUEST_1_pipe_write_req,
    CORE_BUS_RESPONSE_pipe_write_data => CORE_RESPONSE_1_pipe_read_data,
    CORE_BUS_RESPONSE_pipe_write_req => CORE_RESPONSE_1_pipe_read_ack,
    CORE_BUS_RESPONSE_pipe_write_ack => CORE_RESPONSE_1_pipe_read_req,
    CORE_ID => CORE_ID_1,
    ENV_to_AJIT_debug_command_0_pipe_write_data => DEBUG_COMMAND_1_0_pipe_read_data,
    ENV_to_AJIT_debug_command_0_pipe_write_req => DEBUG_COMMAND_1_0_pipe_read_ack,
    ENV_to_AJIT_debug_command_0_pipe_write_ack => DEBUG_COMMAND_1_0_pipe_read_req,
    ENV_to_AJIT_debug_command_1_pipe_write_data => DEBUG_COMMAND_1_1_pipe_read_data,
    ENV_to_AJIT_debug_command_1_pipe_write_req => DEBUG_COMMAND_1_1_pipe_read_ack,
    ENV_to_AJIT_debug_command_1_pipe_write_ack => DEBUG_COMMAND_1_1_pipe_read_req,
    ENV_to_AJIT_reset_0 => THREAD_RESET_0_8,
    ENV_to_AJIT_reset_1 => THREAD_RESET_1_8,
    ENV_to_CPU_irl_0 => IRL8_1_0,
    ENV_to_CPU_irl_1 => IRL8_1_1,
    INVALIDATE_REQUEST_pipe_write_data => INVALIDATE_TO_CORE_1_pipe_read_data,
    INVALIDATE_REQUEST_pipe_write_req => INVALIDATE_TO_CORE_1_pipe_read_ack,
    INVALIDATE_REQUEST_pipe_write_ack => INVALIDATE_TO_CORE_1_pipe_read_req,
    clk => clk, reset => reset 
    ); -- 
  core_2_inst: core_2x64
  port map ( --
    AJIT_to_ENV_debug_response_0_pipe_read_data => DEBUG_RESPONSE_2_0_pipe_write_data,
    AJIT_to_ENV_debug_response_0_pipe_read_req => DEBUG_RESPONSE_2_0_pipe_write_ack,
    AJIT_to_ENV_debug_response_0_pipe_read_ack => DEBUG_RESPONSE_2_0_pipe_write_req,
    AJIT_to_ENV_debug_response_1_pipe_read_data => DEBUG_RESPONSE_2_1_pipe_write_data,
    AJIT_to_ENV_debug_response_1_pipe_read_req => DEBUG_RESPONSE_2_1_pipe_write_ack,
    AJIT_to_ENV_debug_response_1_pipe_read_ack => DEBUG_RESPONSE_2_1_pipe_write_req,
    AJIT_to_ENV_logger_0_pipe_read_data => TRACE_2_0_pipe_read_data,
    AJIT_to_ENV_logger_0_pipe_read_req => TRACE_2_0_pipe_read_req,
    AJIT_to_ENV_logger_0_pipe_read_ack => TRACE_2_0_pipe_read_ack,
    AJIT_to_ENV_logger_1_pipe_read_data => TRACE_2_1_pipe_read_data,
    AJIT_to_ENV_logger_1_pipe_read_req => TRACE_2_1_pipe_read_req,
    AJIT_to_ENV_logger_1_pipe_read_ack => TRACE_2_1_pipe_read_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_data => PMODE_2_0_pipe_write_data,
    AJIT_to_ENV_processor_mode_0_pipe_read_req => PMODE_2_0_pipe_write_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_ack => PMODE_2_0_pipe_write_req,
    AJIT_to_ENV_processor_mode_1_pipe_read_data => PMODE_2_1_pipe_write_data,
    AJIT_to_ENV_processor_mode_1_pipe_read_req => PMODE_2_1_pipe_write_ack,
    AJIT_to_ENV_processor_mode_1_pipe_read_ack => PMODE_2_1_pipe_write_req,
    CACHE_STALL_ENABLE => CACHE_STALL_ENABLE,
    CORE_BUS_REQUEST_pipe_read_data => CORE_REQUEST_2_pipe_write_data,
    CORE_BUS_REQUEST_pipe_read_req => CORE_REQUEST_2_pipe_write_ack,
    CORE_BUS_REQUEST_pipe_read_ack => CORE_REQUEST_2_pipe_write_req,
    CORE_BUS_RESPONSE_pipe_write_data => CORE_RESPONSE_2_pipe_read_data,
    CORE_BUS_RESPONSE_pipe_write_req => CORE_RESPONSE_2_pipe_read_ack,
    CORE_BUS_RESPONSE_pipe_write_ack => CORE_RESPONSE_2_pipe_read_req,
    CORE_ID => CORE_ID_2,
    ENV_to_AJIT_debug_command_0_pipe_write_data => DEBUG_COMMAND_2_0_pipe_read_data,
    ENV_to_AJIT_debug_command_0_pipe_write_req => DEBUG_COMMAND_2_0_pipe_read_ack,
    ENV_to_AJIT_debug_command_0_pipe_write_ack => DEBUG_COMMAND_2_0_pipe_read_req,
    ENV_to_AJIT_debug_command_1_pipe_write_data => DEBUG_COMMAND_2_1_pipe_read_data,
    ENV_to_AJIT_debug_command_1_pipe_write_req => DEBUG_COMMAND_2_1_pipe_read_ack,
    ENV_to_AJIT_debug_command_1_pipe_write_ack => DEBUG_COMMAND_2_1_pipe_read_req,
    ENV_to_AJIT_reset_0 => THREAD_RESET_0_8,
    ENV_to_AJIT_reset_1 => THREAD_RESET_1_8,
    ENV_to_CPU_irl_0 => IRL8_2_0,
    ENV_to_CPU_irl_1 => IRL8_2_1,
    INVALIDATE_REQUEST_pipe_write_data => INVALIDATE_TO_CORE_2_pipe_read_data,
    INVALIDATE_REQUEST_pipe_write_req => INVALIDATE_TO_CORE_2_pipe_read_ack,
    INVALIDATE_REQUEST_pipe_write_ack => INVALIDATE_TO_CORE_2_pipe_read_req,
    clk => clk, reset => reset 
    ); -- 
  core_3_inst: core_2x64
  port map ( --
    AJIT_to_ENV_debug_response_0_pipe_read_data => DEBUG_RESPONSE_3_0_pipe_write_data,
    AJIT_to_ENV_debug_response_0_pipe_read_req => DEBUG_RESPONSE_3_0_pipe_write_ack,
    AJIT_to_ENV_debug_response_0_pipe_read_ack => DEBUG_RESPONSE_3_0_pipe_write_req,
    AJIT_to_ENV_debug_response_1_pipe_read_data => DEBUG_RESPONSE_3_1_pipe_write_data,
    AJIT_to_ENV_debug_response_1_pipe_read_req => DEBUG_RESPONSE_3_1_pipe_write_ack,
    AJIT_to_ENV_debug_response_1_pipe_read_ack => DEBUG_RESPONSE_3_1_pipe_write_req,
    AJIT_to_ENV_logger_0_pipe_read_data => TRACE_3_0_pipe_read_data,
    AJIT_to_ENV_logger_0_pipe_read_req => TRACE_3_0_pipe_read_req,
    AJIT_to_ENV_logger_0_pipe_read_ack => TRACE_3_0_pipe_read_ack,
    AJIT_to_ENV_logger_1_pipe_read_data => TRACE_3_1_pipe_read_data,
    AJIT_to_ENV_logger_1_pipe_read_req => TRACE_3_1_pipe_read_req,
    AJIT_to_ENV_logger_1_pipe_read_ack => TRACE_3_1_pipe_read_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_data => PMODE_3_0_pipe_write_data,
    AJIT_to_ENV_processor_mode_0_pipe_read_req => PMODE_3_0_pipe_write_ack,
    AJIT_to_ENV_processor_mode_0_pipe_read_ack => PMODE_3_0_pipe_write_req,
    AJIT_to_ENV_processor_mode_1_pipe_read_data => PMODE_3_1_pipe_write_data,
    AJIT_to_ENV_processor_mode_1_pipe_read_req => PMODE_3_1_pipe_write_ack,
    AJIT_to_ENV_processor_mode_1_pipe_read_ack => PMODE_3_1_pipe_write_req,
    CACHE_STALL_ENABLE => CACHE_STALL_ENABLE,
    CORE_BUS_REQUEST_pipe_read_data => CORE_REQUEST_3_pipe_write_data,
    CORE_BUS_REQUEST_pipe_read_req => CORE_REQUEST_3_pipe_write_ack,
    CORE_BUS_REQUEST_pipe_read_ack => CORE_REQUEST_3_pipe_write_req,
    CORE_BUS_RESPONSE_pipe_write_data => CORE_RESPONSE_3_pipe_read_data,
    CORE_BUS_RESPONSE_pipe_write_req => CORE_RESPONSE_3_pipe_read_ack,
    CORE_BUS_RESPONSE_pipe_write_ack => CORE_RESPONSE_3_pipe_read_req,
    CORE_ID => CORE_ID_3,
    ENV_to_AJIT_debug_command_0_pipe_write_data => DEBUG_COMMAND_3_0_pipe_read_data,
    ENV_to_AJIT_debug_command_0_pipe_write_req => DEBUG_COMMAND_3_0_pipe_read_ack,
    ENV_to_AJIT_debug_command_0_pipe_write_ack => DEBUG_COMMAND_3_0_pipe_read_req,
    ENV_to_AJIT_debug_command_1_pipe_write_data => DEBUG_COMMAND_3_1_pipe_read_data,
    ENV_to_AJIT_debug_command_1_pipe_write_req => DEBUG_COMMAND_3_1_pipe_read_ack,
    ENV_to_AJIT_debug_command_1_pipe_write_ack => DEBUG_COMMAND_3_1_pipe_read_req,
    ENV_to_AJIT_reset_0 => THREAD_RESET_0_8,
    ENV_to_AJIT_reset_1 => THREAD_RESET_1_8,
    ENV_to_CPU_irl_0 => IRL8_3_0,
    ENV_to_CPU_irl_1 => IRL8_3_1,
    INVALIDATE_REQUEST_pipe_write_data => INVALIDATE_TO_CORE_3_pipe_read_data,
    INVALIDATE_REQUEST_pipe_write_req => INVALIDATE_TO_CORE_3_pipe_read_ack,
    INVALIDATE_REQUEST_pipe_write_ack => INVALIDATE_TO_CORE_3_pipe_read_req,
    clk => clk, reset => reset 
    ); -- 
  debug_aggr_inst: debug_aggregator_four_core
  port map ( --
    AJIT_to_ENV_debug_response_0_0_pipe_write_data => DEBUG_RESPONSE_0_0_pipe_read_data,
    AJIT_to_ENV_debug_response_0_0_pipe_write_req => DEBUG_RESPONSE_0_0_pipe_read_ack,
    AJIT_to_ENV_debug_response_0_0_pipe_write_ack => DEBUG_RESPONSE_0_0_pipe_read_req,
    AJIT_to_ENV_debug_response_0_1_pipe_write_data => DEBUG_RESPONSE_0_1_pipe_read_data,
    AJIT_to_ENV_debug_response_0_1_pipe_write_req => DEBUG_RESPONSE_0_1_pipe_read_ack,
    AJIT_to_ENV_debug_response_0_1_pipe_write_ack => DEBUG_RESPONSE_0_1_pipe_read_req,
    AJIT_to_ENV_debug_response_1_0_pipe_write_data => DEBUG_RESPONSE_1_0_pipe_read_data,
    AJIT_to_ENV_debug_response_1_0_pipe_write_req => DEBUG_RESPONSE_1_0_pipe_read_ack,
    AJIT_to_ENV_debug_response_1_0_pipe_write_ack => DEBUG_RESPONSE_1_0_pipe_read_req,
    AJIT_to_ENV_debug_response_1_1_pipe_write_data => DEBUG_RESPONSE_1_1_pipe_read_data,
    AJIT_to_ENV_debug_response_1_1_pipe_write_req => DEBUG_RESPONSE_1_1_pipe_read_ack,
    AJIT_to_ENV_debug_response_1_1_pipe_write_ack => DEBUG_RESPONSE_1_1_pipe_read_req,
    AJIT_to_ENV_debug_response_2_0_pipe_write_data => DEBUG_RESPONSE_2_0_pipe_read_data,
    AJIT_to_ENV_debug_response_2_0_pipe_write_req => DEBUG_RESPONSE_2_0_pipe_read_ack,
    AJIT_to_ENV_debug_response_2_0_pipe_write_ack => DEBUG_RESPONSE_2_0_pipe_read_req,
    AJIT_to_ENV_debug_response_2_1_pipe_write_data => DEBUG_RESPONSE_2_1_pipe_read_data,
    AJIT_to_ENV_debug_response_2_1_pipe_write_req => DEBUG_RESPONSE_2_1_pipe_read_ack,
    AJIT_to_ENV_debug_response_2_1_pipe_write_ack => DEBUG_RESPONSE_2_1_pipe_read_req,
    AJIT_to_ENV_debug_response_3_0_pipe_write_data => DEBUG_RESPONSE_3_0_pipe_read_data,
    AJIT_to_ENV_debug_response_3_0_pipe_write_req => DEBUG_RESPONSE_3_0_pipe_read_ack,
    AJIT_to_ENV_debug_response_3_0_pipe_write_ack => DEBUG_RESPONSE_3_0_pipe_read_req,
    AJIT_to_ENV_debug_response_3_1_pipe_write_data => DEBUG_RESPONSE_3_1_pipe_read_data,
    AJIT_to_ENV_debug_response_3_1_pipe_write_req => DEBUG_RESPONSE_3_1_pipe_read_ack,
    AJIT_to_ENV_debug_response_3_1_pipe_write_ack => DEBUG_RESPONSE_3_1_pipe_read_req,
    ENV_to_AJIT_debug_command_0_0_pipe_read_data => DEBUG_COMMAND_0_0_pipe_write_data,
    ENV_to_AJIT_debug_command_0_0_pipe_read_req => DEBUG_COMMAND_0_0_pipe_write_ack,
    ENV_to_AJIT_debug_command_0_0_pipe_read_ack => DEBUG_COMMAND_0_0_pipe_write_req,
    ENV_to_AJIT_debug_command_0_1_pipe_read_data => DEBUG_COMMAND_0_1_pipe_write_data,
    ENV_to_AJIT_debug_command_0_1_pipe_read_req => DEBUG_COMMAND_0_1_pipe_write_ack,
    ENV_to_AJIT_debug_command_0_1_pipe_read_ack => DEBUG_COMMAND_0_1_pipe_write_req,
    ENV_to_AJIT_debug_command_1_0_pipe_read_data => DEBUG_COMMAND_1_0_pipe_write_data,
    ENV_to_AJIT_debug_command_1_0_pipe_read_req => DEBUG_COMMAND_1_0_pipe_write_ack,
    ENV_to_AJIT_debug_command_1_0_pipe_read_ack => DEBUG_COMMAND_1_0_pipe_write_req,
    ENV_to_AJIT_debug_command_1_1_pipe_read_data => DEBUG_COMMAND_1_1_pipe_write_data,
    ENV_to_AJIT_debug_command_1_1_pipe_read_req => DEBUG_COMMAND_1_1_pipe_write_ack,
    ENV_to_AJIT_debug_command_1_1_pipe_read_ack => DEBUG_COMMAND_1_1_pipe_write_req,
    ENV_to_AJIT_debug_command_2_0_pipe_read_data => DEBUG_COMMAND_2_0_pipe_write_data,
    ENV_to_AJIT_debug_command_2_0_pipe_read_req => DEBUG_COMMAND_2_0_pipe_write_ack,
    ENV_to_AJIT_debug_command_2_0_pipe_read_ack => DEBUG_COMMAND_2_0_pipe_write_req,
    ENV_to_AJIT_debug_command_2_1_pipe_read_data => DEBUG_COMMAND_2_1_pipe_write_data,
    ENV_to_AJIT_debug_command_2_1_pipe_read_req => DEBUG_COMMAND_2_1_pipe_write_ack,
    ENV_to_AJIT_debug_command_2_1_pipe_read_ack => DEBUG_COMMAND_2_1_pipe_write_req,
    ENV_to_AJIT_debug_command_3_0_pipe_read_data => DEBUG_COMMAND_3_0_pipe_write_data,
    ENV_to_AJIT_debug_command_3_0_pipe_read_req => DEBUG_COMMAND_3_0_pipe_write_ack,
    ENV_to_AJIT_debug_command_3_0_pipe_read_ack => DEBUG_COMMAND_3_0_pipe_write_req,
    ENV_to_AJIT_debug_command_3_1_pipe_read_data => DEBUG_COMMAND_3_1_pipe_write_data,
    ENV_to_AJIT_debug_command_3_1_pipe_read_req => DEBUG_COMMAND_3_1_pipe_write_ack,
    ENV_to_AJIT_debug_command_3_1_pipe_read_ack => DEBUG_COMMAND_3_1_pipe_write_req,
    SOC_DEBUG_to_MONITOR_pipe_read_data => SOC_DEBUG_to_MONITOR_pipe_read_data,
    SOC_DEBUG_to_MONITOR_pipe_read_req => SOC_DEBUG_to_MONITOR_pipe_read_req,
    SOC_DEBUG_to_MONITOR_pipe_read_ack => SOC_DEBUG_to_MONITOR_pipe_read_ack,
    SOC_MONITOR_to_DEBUG_pipe_write_data => SOC_MONITOR_to_DEBUG_pipe_write_data,
    SOC_MONITOR_to_DEBUG_pipe_write_req => SOC_MONITOR_to_DEBUG_pipe_write_req,
    SOC_MONITOR_to_DEBUG_pipe_write_ack => SOC_MONITOR_to_DEBUG_pipe_write_ack,
    clk => clk, reset => reset 
    ); -- 
  mem_ctrllr_inst: coherent_memory_controller_four_core_v2
  port map ( --
    CACHE_STALL_ENABLE => CACHE_STALL_ENABLE,
    CORE_0_BUS_RESPONSE_pipe_read_data => CORE_RESPONSE_0_pipe_write_data,
    CORE_0_BUS_RESPONSE_pipe_read_req => CORE_RESPONSE_0_pipe_write_ack,
    CORE_0_BUS_RESPONSE_pipe_read_ack => CORE_RESPONSE_0_pipe_write_req,
    CORE_1_BUS_RESPONSE_pipe_read_data => CORE_RESPONSE_1_pipe_write_data,
    CORE_1_BUS_RESPONSE_pipe_read_req => CORE_RESPONSE_1_pipe_write_ack,
    CORE_1_BUS_RESPONSE_pipe_read_ack => CORE_RESPONSE_1_pipe_write_req,
    CORE_2_BUS_RESPONSE_pipe_read_data => CORE_RESPONSE_2_pipe_write_data,
    CORE_2_BUS_RESPONSE_pipe_read_req => CORE_RESPONSE_2_pipe_write_ack,
    CORE_2_BUS_RESPONSE_pipe_read_ack => CORE_RESPONSE_2_pipe_write_req,
    CORE_3_BUS_RESPONSE_pipe_read_data => CORE_RESPONSE_3_pipe_write_data,
    CORE_3_BUS_RESPONSE_pipe_read_req => CORE_RESPONSE_3_pipe_write_ack,
    CORE_3_BUS_RESPONSE_pipe_read_ack => CORE_RESPONSE_3_pipe_write_req,
    INVALIDATE_TO_CORE_0_pipe_read_data => INVALIDATE_TO_CORE_0_pipe_write_data,
    INVALIDATE_TO_CORE_0_pipe_read_req => INVALIDATE_TO_CORE_0_pipe_write_ack,
    INVALIDATE_TO_CORE_0_pipe_read_ack => INVALIDATE_TO_CORE_0_pipe_write_req,
    INVALIDATE_TO_CORE_1_pipe_read_data => INVALIDATE_TO_CORE_1_pipe_write_data,
    INVALIDATE_TO_CORE_1_pipe_read_req => INVALIDATE_TO_CORE_1_pipe_write_ack,
    INVALIDATE_TO_CORE_1_pipe_read_ack => INVALIDATE_TO_CORE_1_pipe_write_req,
    INVALIDATE_TO_CORE_2_pipe_read_data => INVALIDATE_TO_CORE_2_pipe_write_data,
    INVALIDATE_TO_CORE_2_pipe_read_req => INVALIDATE_TO_CORE_2_pipe_write_ack,
    INVALIDATE_TO_CORE_2_pipe_read_ack => INVALIDATE_TO_CORE_2_pipe_write_req,
    INVALIDATE_TO_CORE_3_pipe_read_data => INVALIDATE_TO_CORE_3_pipe_write_data,
    INVALIDATE_TO_CORE_3_pipe_read_req => INVALIDATE_TO_CORE_3_pipe_write_ack,
    INVALIDATE_TO_CORE_3_pipe_read_ack => INVALIDATE_TO_CORE_3_pipe_write_req,
    IO_CORE_BUS_REQUEST_pipe_read_data => PERIPH_MEM_REQUEST_pipe_write_data,
    IO_CORE_BUS_REQUEST_pipe_read_req => PERIPH_MEM_REQUEST_pipe_write_ack,
    IO_CORE_BUS_REQUEST_pipe_read_ack => PERIPH_MEM_REQUEST_pipe_write_req,
    IO_CORE_BUS_RESPONSE_pipe_write_data => PERIPH_MEM_RESPONSE_pipe_read_data,
    IO_CORE_BUS_RESPONSE_pipe_write_req => PERIPH_MEM_RESPONSE_pipe_read_ack,
    IO_CORE_BUS_RESPONSE_pipe_write_ack => PERIPH_MEM_RESPONSE_pipe_read_req,
    IO_MAX_ADDR => IO_MAX_ADDR,
    IO_MIN_ADDR => IO_MIN_ADDR,
    MAIN_MEM_INVALIDATE_pipe_write_data => MAIN_MEM_INVALIDATE_pipe_write_data,
    MAIN_MEM_INVALIDATE_pipe_write_req => MAIN_MEM_INVALIDATE_pipe_write_req,
    MAIN_MEM_INVALIDATE_pipe_write_ack => MAIN_MEM_INVALIDATE_pipe_write_ack,
    MAIN_MEM_REQUEST_pipe_read_data => MAIN_MEM_REQUEST_pipe_read_data,
    MAIN_MEM_REQUEST_pipe_read_req => MAIN_MEM_REQUEST_pipe_read_req,
    MAIN_MEM_REQUEST_pipe_read_ack => MAIN_MEM_REQUEST_pipe_read_ack,
    MAIN_MEM_RESPONSE_pipe_write_data => MAIN_MEM_RESPONSE_pipe_write_data,
    MAIN_MEM_RESPONSE_pipe_write_req => MAIN_MEM_RESPONSE_pipe_write_req,
    MAIN_MEM_RESPONSE_pipe_write_ack => MAIN_MEM_RESPONSE_pipe_write_ack,
    NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_data => NOBLOCK_CORE_REQUEST_0_pipe_read_data,
    NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_req => NOBLOCK_CORE_REQUEST_0_pipe_read_ack,
    NOBLOCK_CORE_0_BUS_REQUEST_pipe_write_ack => NOBLOCK_CORE_REQUEST_0_pipe_read_req,
    NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_data => NOBLOCK_CORE_REQUEST_1_pipe_read_data,
    NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_req => NOBLOCK_CORE_REQUEST_1_pipe_read_ack,
    NOBLOCK_CORE_1_BUS_REQUEST_pipe_write_ack => NOBLOCK_CORE_REQUEST_1_pipe_read_req,
    NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_data => NOBLOCK_CORE_REQUEST_2_pipe_read_data,
    NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_req => NOBLOCK_CORE_REQUEST_2_pipe_read_ack,
    NOBLOCK_CORE_2_BUS_REQUEST_pipe_write_ack => NOBLOCK_CORE_REQUEST_2_pipe_read_req,
    NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_data => NOBLOCK_CORE_REQUEST_3_pipe_read_data,
    NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_req => NOBLOCK_CORE_REQUEST_3_pipe_read_ack,
    NOBLOCK_CORE_3_BUS_REQUEST_pipe_write_ack => NOBLOCK_CORE_REQUEST_3_pipe_read_req,
    clk => clk, reset => reset 
    ); -- 
  resetConv_str_0: resetConverter -- 
    port map ( -- 
      RST4 => THREAD_RESET,
      RST8 => THREAD_RESET_0_8,
      clk => clk, reset => reset--
    ); -- 
  resetConv_str_1: resetConverter -- 
    port map ( -- 
      RST4 => THREAD_RESET,
      RST8 => THREAD_RESET_1_8,
      clk => clk, reset => reset--
    ); -- 
  irlResetPmode_0_0: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_0_0,
      IRL8 => IRL8_0_0,
      PMODE => PMODE_0_0_pipe_read_data,
      PMODE_pipe_read_req => PMODE_0_0_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_0_0_pipe_read_ack,
      PMODES => TMODE_0_0,
      clk => clk, reset => reset--
    ); -- 
  irlResetPmode_0_1: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_0_1,
      IRL8 => IRL8_0_1,
      PMODE => PMODE_0_1_pipe_read_data,
      PMODE_pipe_read_req => PMODE_0_1_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_0_1_pipe_read_ack,
      PMODES => TMODE_0_1,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_1_0: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_1_0,
      IRL8 => IRL8_1_0,
      PMODE => PMODE_1_0_pipe_read_data,
      PMODE_pipe_read_req => PMODE_1_0_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_1_0_pipe_read_ack,
      PMODES => TMODE_1_0,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_1_1: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_1_1,
      IRL8 => IRL8_1_1,
      PMODE => PMODE_1_1_pipe_read_data,
      PMODE_pipe_read_req => PMODE_1_1_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_1_1_pipe_read_ack,
      PMODES => TMODE_1_1,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_2_0: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_2_0,
      IRL8 => IRL8_2_0,
      PMODE => PMODE_2_0_pipe_read_data,
      PMODE_pipe_read_req => PMODE_2_0_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_2_0_pipe_read_ack,
      PMODES => TMODE_2_0,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_2_1: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_2_1,
      IRL8 => IRL8_2_1,
      PMODE => PMODE_2_1_pipe_read_data,
      PMODE_pipe_read_req => PMODE_2_1_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_2_1_pipe_read_ack,
      PMODES => TMODE_2_1,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_3_0: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_3_0,
      IRL8 => IRL8_3_0,
      PMODE => PMODE_3_0_pipe_read_data,
      PMODE_pipe_read_req => PMODE_3_0_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_3_0_pipe_read_ack,
      PMODES => TMODE_3_0,
      clk => clk, reset => reset--
    ); -- 
  irlPmode_3_1: irlPmodeConverter -- 
    port map ( -- 
      IRL4 => IRL_3_1,
      IRL8 => IRL8_3_1,
      PMODE => PMODE_3_1_pipe_read_data,
      PMODE_pipe_read_req => PMODE_3_1_pipe_read_req,
      PMODE_pipe_read_ack => PMODE_3_1_pipe_read_ack,
      PMODES => TMODE_3_1,
      clk => clk, reset => reset--
    ); -- 
  sCS: setConfiguration -- 
    port map ( -- 
      CORE_ID_0 => CORE_ID_0,
      CORE_ID_1 => CORE_ID_1,
      CORE_ID_2 => CORE_ID_2,
      CORE_ID_3 => CORE_ID_3,
      IO_MAX_ADDR => IO_MAX_ADDR,
      IO_MIN_ADDR => IO_MIN_ADDR,
      clk => clk, reset => reset--
    ); -- 
  b2n_0: blockToNoblock -- 
    port map ( -- 
      NREQ => NOBLOCK_CORE_REQUEST_0_pipe_write_data,
      NREQ_pipe_write_req => NOBLOCK_CORE_REQUEST_0_pipe_write_req,
      NREQ_pipe_write_ack => NOBLOCK_CORE_REQUEST_0_pipe_write_ack,
      REQ => CORE_REQUEST_0_pipe_read_data,
      REQ_pipe_read_req => CORE_REQUEST_0_pipe_read_req,
      REQ_pipe_read_ack => CORE_REQUEST_0_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  b2n_1: blockToNoblock -- 
    port map ( -- 
      NREQ => NOBLOCK_CORE_REQUEST_1_pipe_write_data,
      NREQ_pipe_write_req => NOBLOCK_CORE_REQUEST_1_pipe_write_req,
      NREQ_pipe_write_ack => NOBLOCK_CORE_REQUEST_1_pipe_write_ack,
      REQ => CORE_REQUEST_1_pipe_read_data,
      REQ_pipe_read_req => CORE_REQUEST_1_pipe_read_req,
      REQ_pipe_read_ack => CORE_REQUEST_1_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  b2n_2: blockToNoblock -- 
    port map ( -- 
      NREQ => NOBLOCK_CORE_REQUEST_2_pipe_write_data,
      NREQ_pipe_write_req => NOBLOCK_CORE_REQUEST_2_pipe_write_req,
      NREQ_pipe_write_ack => NOBLOCK_CORE_REQUEST_2_pipe_write_ack,
      REQ => CORE_REQUEST_2_pipe_read_data,
      REQ_pipe_read_req => CORE_REQUEST_2_pipe_read_req,
      REQ_pipe_read_ack => CORE_REQUEST_2_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  b2n_3: blockToNoblock -- 
    port map ( -- 
      NREQ => NOBLOCK_CORE_REQUEST_3_pipe_write_data,
      NREQ_pipe_write_req => NOBLOCK_CORE_REQUEST_3_pipe_write_req,
      NREQ_pipe_write_ack => NOBLOCK_CORE_REQUEST_3_pipe_write_ack,
      REQ => CORE_REQUEST_3_pipe_read_data,
      REQ_pipe_read_req => CORE_REQUEST_3_pipe_read_req,
      REQ_pipe_read_ack => CORE_REQUEST_3_pipe_read_ack,
      clk => clk, reset => reset--
    ); -- 
  -- pipe CORE_REQUEST_0 depth set to 0 since it is a P2P pipe.
  CORE_REQUEST_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_REQUEST_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 110,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_REQUEST_0_pipe_read_req,
      read_ack => CORE_REQUEST_0_pipe_read_ack,
      read_data => CORE_REQUEST_0_pipe_read_data,
      write_req => CORE_REQUEST_0_pipe_write_req,
      write_ack => CORE_REQUEST_0_pipe_write_ack,
      write_data => CORE_REQUEST_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_REQUEST_1 depth set to 0 since it is a P2P pipe.
  CORE_REQUEST_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_REQUEST_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 110,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_REQUEST_1_pipe_read_req,
      read_ack => CORE_REQUEST_1_pipe_read_ack,
      read_data => CORE_REQUEST_1_pipe_read_data,
      write_req => CORE_REQUEST_1_pipe_write_req,
      write_ack => CORE_REQUEST_1_pipe_write_ack,
      write_data => CORE_REQUEST_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_REQUEST_2 depth set to 0 since it is a P2P pipe.
  CORE_REQUEST_2_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_REQUEST_2",
      num_reads => 1,
      num_writes => 1,
      data_width => 110,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_REQUEST_2_pipe_read_req,
      read_ack => CORE_REQUEST_2_pipe_read_ack,
      read_data => CORE_REQUEST_2_pipe_read_data,
      write_req => CORE_REQUEST_2_pipe_write_req,
      write_ack => CORE_REQUEST_2_pipe_write_ack,
      write_data => CORE_REQUEST_2_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_REQUEST_3 depth set to 0 since it is a P2P pipe.
  CORE_REQUEST_3_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_REQUEST_3",
      num_reads => 1,
      num_writes => 1,
      data_width => 110,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_REQUEST_3_pipe_read_req,
      read_ack => CORE_REQUEST_3_pipe_read_ack,
      read_data => CORE_REQUEST_3_pipe_read_data,
      write_req => CORE_REQUEST_3_pipe_write_req,
      write_ack => CORE_REQUEST_3_pipe_write_ack,
      write_data => CORE_REQUEST_3_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_RESPONSE_0 depth set to 0 since it is a P2P pipe.
  CORE_RESPONSE_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_RESPONSE_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 65,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_RESPONSE_0_pipe_read_req,
      read_ack => CORE_RESPONSE_0_pipe_read_ack,
      read_data => CORE_RESPONSE_0_pipe_read_data,
      write_req => CORE_RESPONSE_0_pipe_write_req,
      write_ack => CORE_RESPONSE_0_pipe_write_ack,
      write_data => CORE_RESPONSE_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_RESPONSE_1 depth set to 0 since it is a P2P pipe.
  CORE_RESPONSE_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_RESPONSE_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 65,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_RESPONSE_1_pipe_read_req,
      read_ack => CORE_RESPONSE_1_pipe_read_ack,
      read_data => CORE_RESPONSE_1_pipe_read_data,
      write_req => CORE_RESPONSE_1_pipe_write_req,
      write_ack => CORE_RESPONSE_1_pipe_write_ack,
      write_data => CORE_RESPONSE_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_RESPONSE_2 depth set to 0 since it is a P2P pipe.
  CORE_RESPONSE_2_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_RESPONSE_2",
      num_reads => 1,
      num_writes => 1,
      data_width => 65,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_RESPONSE_2_pipe_read_req,
      read_ack => CORE_RESPONSE_2_pipe_read_ack,
      read_data => CORE_RESPONSE_2_pipe_read_data,
      write_req => CORE_RESPONSE_2_pipe_write_req,
      write_ack => CORE_RESPONSE_2_pipe_write_ack,
      write_data => CORE_RESPONSE_2_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe CORE_RESPONSE_3 depth set to 0 since it is a P2P pipe.
  CORE_RESPONSE_3_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe CORE_RESPONSE_3",
      num_reads => 1,
      num_writes => 1,
      data_width => 65,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => CORE_RESPONSE_3_pipe_read_req,
      read_ack => CORE_RESPONSE_3_pipe_read_ack,
      read_data => CORE_RESPONSE_3_pipe_read_data,
      write_req => CORE_RESPONSE_3_pipe_write_req,
      write_ack => CORE_RESPONSE_3_pipe_write_ack,
      write_data => CORE_RESPONSE_3_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe DEBUG_COMMAND_0_0 depth set to 0 since it is a P2P pipe.
  DEBUG_COMMAND_0_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_0_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_0_0_pipe_read_req,
      read_ack => DEBUG_COMMAND_0_0_pipe_read_ack,
      read_data => DEBUG_COMMAND_0_0_pipe_read_data,
      write_req => DEBUG_COMMAND_0_0_pipe_write_req,
      write_ack => DEBUG_COMMAND_0_0_pipe_write_ack,
      write_data => DEBUG_COMMAND_0_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_0_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_0_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_0_1_pipe_read_req,
      read_ack => DEBUG_COMMAND_0_1_pipe_read_ack,
      read_data => DEBUG_COMMAND_0_1_pipe_read_data,
      write_req => DEBUG_COMMAND_0_1_pipe_write_req,
      write_ack => DEBUG_COMMAND_0_1_pipe_write_ack,
      write_data => DEBUG_COMMAND_0_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_1_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_1_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_1_0_pipe_read_req,
      read_ack => DEBUG_COMMAND_1_0_pipe_read_ack,
      read_data => DEBUG_COMMAND_1_0_pipe_read_data,
      write_req => DEBUG_COMMAND_1_0_pipe_write_req,
      write_ack => DEBUG_COMMAND_1_0_pipe_write_ack,
      write_data => DEBUG_COMMAND_1_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_1_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_1_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_1_1_pipe_read_req,
      read_ack => DEBUG_COMMAND_1_1_pipe_read_ack,
      read_data => DEBUG_COMMAND_1_1_pipe_read_data,
      write_req => DEBUG_COMMAND_1_1_pipe_write_req,
      write_ack => DEBUG_COMMAND_1_1_pipe_write_ack,
      write_data => DEBUG_COMMAND_1_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_2_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_2_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_2_0_pipe_read_req,
      read_ack => DEBUG_COMMAND_2_0_pipe_read_ack,
      read_data => DEBUG_COMMAND_2_0_pipe_read_data,
      write_req => DEBUG_COMMAND_2_0_pipe_write_req,
      write_ack => DEBUG_COMMAND_2_0_pipe_write_ack,
      write_data => DEBUG_COMMAND_2_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_2_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_2_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_2_1_pipe_read_req,
      read_ack => DEBUG_COMMAND_2_1_pipe_read_ack,
      read_data => DEBUG_COMMAND_2_1_pipe_read_data,
      write_req => DEBUG_COMMAND_2_1_pipe_write_req,
      write_ack => DEBUG_COMMAND_2_1_pipe_write_ack,
      write_data => DEBUG_COMMAND_2_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_3_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_3_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_3_0_pipe_read_req,
      read_ack => DEBUG_COMMAND_3_0_pipe_read_ack,
      read_data => DEBUG_COMMAND_3_0_pipe_read_data,
      write_req => DEBUG_COMMAND_3_0_pipe_write_req,
      write_ack => DEBUG_COMMAND_3_0_pipe_write_ack,
      write_data => DEBUG_COMMAND_3_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_COMMAND_3_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_COMMAND_3_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_COMMAND_3_1_pipe_read_req,
      read_ack => DEBUG_COMMAND_3_1_pipe_read_ack,
      read_data => DEBUG_COMMAND_3_1_pipe_read_data,
      write_req => DEBUG_COMMAND_3_1_pipe_write_req,
      write_ack => DEBUG_COMMAND_3_1_pipe_write_ack,
      write_data => DEBUG_COMMAND_3_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_0_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_0_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_0_0_pipe_read_req,
      read_ack => DEBUG_RESPONSE_0_0_pipe_read_ack,
      read_data => DEBUG_RESPONSE_0_0_pipe_read_data,
      write_req => DEBUG_RESPONSE_0_0_pipe_write_req,
      write_ack => DEBUG_RESPONSE_0_0_pipe_write_ack,
      write_data => DEBUG_RESPONSE_0_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_0_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_0_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_0_1_pipe_read_req,
      read_ack => DEBUG_RESPONSE_0_1_pipe_read_ack,
      read_data => DEBUG_RESPONSE_0_1_pipe_read_data,
      write_req => DEBUG_RESPONSE_0_1_pipe_write_req,
      write_ack => DEBUG_RESPONSE_0_1_pipe_write_ack,
      write_data => DEBUG_RESPONSE_0_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_1_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_1_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_1_0_pipe_read_req,
      read_ack => DEBUG_RESPONSE_1_0_pipe_read_ack,
      read_data => DEBUG_RESPONSE_1_0_pipe_read_data,
      write_req => DEBUG_RESPONSE_1_0_pipe_write_req,
      write_ack => DEBUG_RESPONSE_1_0_pipe_write_ack,
      write_data => DEBUG_RESPONSE_1_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_1_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_1_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_1_1_pipe_read_req,
      read_ack => DEBUG_RESPONSE_1_1_pipe_read_ack,
      read_data => DEBUG_RESPONSE_1_1_pipe_read_data,
      write_req => DEBUG_RESPONSE_1_1_pipe_write_req,
      write_ack => DEBUG_RESPONSE_1_1_pipe_write_ack,
      write_data => DEBUG_RESPONSE_1_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_2_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_2_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_2_0_pipe_read_req,
      read_ack => DEBUG_RESPONSE_2_0_pipe_read_ack,
      read_data => DEBUG_RESPONSE_2_0_pipe_read_data,
      write_req => DEBUG_RESPONSE_2_0_pipe_write_req,
      write_ack => DEBUG_RESPONSE_2_0_pipe_write_ack,
      write_data => DEBUG_RESPONSE_2_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_2_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_2_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_2_1_pipe_read_req,
      read_ack => DEBUG_RESPONSE_2_1_pipe_read_ack,
      read_data => DEBUG_RESPONSE_2_1_pipe_read_data,
      write_req => DEBUG_RESPONSE_2_1_pipe_write_req,
      write_ack => DEBUG_RESPONSE_2_1_pipe_write_ack,
      write_data => DEBUG_RESPONSE_2_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_3_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_3_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_3_0_pipe_read_req,
      read_ack => DEBUG_RESPONSE_3_0_pipe_read_ack,
      read_data => DEBUG_RESPONSE_3_0_pipe_read_data,
      write_req => DEBUG_RESPONSE_3_0_pipe_write_req,
      write_ack => DEBUG_RESPONSE_3_0_pipe_write_ack,
      write_data => DEBUG_RESPONSE_3_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  DEBUG_RESPONSE_3_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe DEBUG_RESPONSE_3_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 32,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => DEBUG_RESPONSE_3_1_pipe_read_req,
      read_ack => DEBUG_RESPONSE_3_1_pipe_read_ack,
      read_data => DEBUG_RESPONSE_3_1_pipe_read_data,
      write_req => DEBUG_RESPONSE_3_1_pipe_write_req,
      write_ack => DEBUG_RESPONSE_3_1_pipe_write_ack,
      write_data => DEBUG_RESPONSE_3_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  INVALIDATE_TO_CORE_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe INVALIDATE_TO_CORE_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 30,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => INVALIDATE_TO_CORE_0_pipe_read_req,
      read_ack => INVALIDATE_TO_CORE_0_pipe_read_ack,
      read_data => INVALIDATE_TO_CORE_0_pipe_read_data,
      write_req => INVALIDATE_TO_CORE_0_pipe_write_req,
      write_ack => INVALIDATE_TO_CORE_0_pipe_write_ack,
      write_data => INVALIDATE_TO_CORE_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  INVALIDATE_TO_CORE_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe INVALIDATE_TO_CORE_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 30,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => INVALIDATE_TO_CORE_1_pipe_read_req,
      read_ack => INVALIDATE_TO_CORE_1_pipe_read_ack,
      read_data => INVALIDATE_TO_CORE_1_pipe_read_data,
      write_req => INVALIDATE_TO_CORE_1_pipe_write_req,
      write_ack => INVALIDATE_TO_CORE_1_pipe_write_ack,
      write_data => INVALIDATE_TO_CORE_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  INVALIDATE_TO_CORE_2_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe INVALIDATE_TO_CORE_2",
      num_reads => 1,
      num_writes => 1,
      data_width => 30,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => INVALIDATE_TO_CORE_2_pipe_read_req,
      read_ack => INVALIDATE_TO_CORE_2_pipe_read_ack,
      read_data => INVALIDATE_TO_CORE_2_pipe_read_data,
      write_req => INVALIDATE_TO_CORE_2_pipe_write_req,
      write_ack => INVALIDATE_TO_CORE_2_pipe_write_ack,
      write_data => INVALIDATE_TO_CORE_2_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  INVALIDATE_TO_CORE_3_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe INVALIDATE_TO_CORE_3",
      num_reads => 1,
      num_writes => 1,
      data_width => 30,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => INVALIDATE_TO_CORE_3_pipe_read_req,
      read_ack => INVALIDATE_TO_CORE_3_pipe_read_ack,
      read_data => INVALIDATE_TO_CORE_3_pipe_read_data,
      write_req => INVALIDATE_TO_CORE_3_pipe_write_req,
      write_ack => INVALIDATE_TO_CORE_3_pipe_write_ack,
      write_data => INVALIDATE_TO_CORE_3_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe NOBLOCK_CORE_REQUEST_0 depth set to 0 since it is a P2P pipe.
  -- this is marked as a non-blocking pipe... InputPorts should take care of it! 
  NOBLOCK_CORE_REQUEST_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe NOBLOCK_CORE_REQUEST_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 111,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => NOBLOCK_CORE_REQUEST_0_pipe_read_req,
      read_ack => NOBLOCK_CORE_REQUEST_0_pipe_read_ack,
      read_data => NOBLOCK_CORE_REQUEST_0_pipe_read_data,
      write_req => NOBLOCK_CORE_REQUEST_0_pipe_write_req,
      write_ack => NOBLOCK_CORE_REQUEST_0_pipe_write_ack,
      write_data => NOBLOCK_CORE_REQUEST_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe NOBLOCK_CORE_REQUEST_1 depth set to 0 since it is a P2P pipe.
  -- this is marked as a non-blocking pipe... InputPorts should take care of it! 
  NOBLOCK_CORE_REQUEST_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe NOBLOCK_CORE_REQUEST_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 111,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => NOBLOCK_CORE_REQUEST_1_pipe_read_req,
      read_ack => NOBLOCK_CORE_REQUEST_1_pipe_read_ack,
      read_data => NOBLOCK_CORE_REQUEST_1_pipe_read_data,
      write_req => NOBLOCK_CORE_REQUEST_1_pipe_write_req,
      write_ack => NOBLOCK_CORE_REQUEST_1_pipe_write_ack,
      write_data => NOBLOCK_CORE_REQUEST_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe NOBLOCK_CORE_REQUEST_2 depth set to 0 since it is a P2P pipe.
  -- this is marked as a non-blocking pipe... InputPorts should take care of it! 
  NOBLOCK_CORE_REQUEST_2_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe NOBLOCK_CORE_REQUEST_2",
      num_reads => 1,
      num_writes => 1,
      data_width => 111,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => NOBLOCK_CORE_REQUEST_2_pipe_read_req,
      read_ack => NOBLOCK_CORE_REQUEST_2_pipe_read_ack,
      read_data => NOBLOCK_CORE_REQUEST_2_pipe_read_data,
      write_req => NOBLOCK_CORE_REQUEST_2_pipe_write_req,
      write_ack => NOBLOCK_CORE_REQUEST_2_pipe_write_ack,
      write_data => NOBLOCK_CORE_REQUEST_2_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe NOBLOCK_CORE_REQUEST_3 depth set to 0 since it is a P2P pipe.
  -- this is marked as a non-blocking pipe... InputPorts should take care of it! 
  NOBLOCK_CORE_REQUEST_3_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe NOBLOCK_CORE_REQUEST_3",
      num_reads => 1,
      num_writes => 1,
      data_width => 111,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => NOBLOCK_CORE_REQUEST_3_pipe_read_req,
      read_ack => NOBLOCK_CORE_REQUEST_3_pipe_read_ack,
      read_data => NOBLOCK_CORE_REQUEST_3_pipe_read_data,
      write_req => NOBLOCK_CORE_REQUEST_3_pipe_write_req,
      write_ack => NOBLOCK_CORE_REQUEST_3_pipe_write_ack,
      write_data => NOBLOCK_CORE_REQUEST_3_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PERIPH_MEM_REQUEST_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PERIPH_MEM_REQUEST",
      num_reads => 1,
      num_writes => 1,
      data_width => 110,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => PERIPH_MEM_REQUEST_pipe_read_req,
      read_ack => PERIPH_MEM_REQUEST_pipe_read_ack,
      read_data => PERIPH_MEM_REQUEST_pipe_read_data,
      write_req => PERIPH_MEM_REQUEST_pipe_write_req,
      write_ack => PERIPH_MEM_REQUEST_pipe_write_ack,
      write_data => PERIPH_MEM_REQUEST_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- pipe PERIPH_MEM_RESPONSE depth set to 0 since it is a P2P pipe.
  PERIPH_MEM_RESPONSE_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PERIPH_MEM_RESPONSE",
      num_reads => 1,
      num_writes => 1,
      data_width => 65,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 0 --
    )
    port map( -- 
      read_req => PERIPH_MEM_RESPONSE_pipe_read_req,
      read_ack => PERIPH_MEM_RESPONSE_pipe_read_ack,
      read_data => PERIPH_MEM_RESPONSE_pipe_read_data,
      write_req => PERIPH_MEM_RESPONSE_pipe_write_req,
      write_ack => PERIPH_MEM_RESPONSE_pipe_write_ack,
      write_data => PERIPH_MEM_RESPONSE_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_0_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_0_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_0_0_pipe_read_req,
      read_ack => PMODE_0_0_pipe_read_ack,
      read_data => PMODE_0_0_pipe_read_data,
      write_req => PMODE_0_0_pipe_write_req,
      write_ack => PMODE_0_0_pipe_write_ack,
      write_data => PMODE_0_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_0_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_0_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_0_1_pipe_read_req,
      read_ack => PMODE_0_1_pipe_read_ack,
      read_data => PMODE_0_1_pipe_read_data,
      write_req => PMODE_0_1_pipe_write_req,
      write_ack => PMODE_0_1_pipe_write_ack,
      write_data => PMODE_0_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_1_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_1_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_1_0_pipe_read_req,
      read_ack => PMODE_1_0_pipe_read_ack,
      read_data => PMODE_1_0_pipe_read_data,
      write_req => PMODE_1_0_pipe_write_req,
      write_ack => PMODE_1_0_pipe_write_ack,
      write_data => PMODE_1_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_1_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_1_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_1_1_pipe_read_req,
      read_ack => PMODE_1_1_pipe_read_ack,
      read_data => PMODE_1_1_pipe_read_data,
      write_req => PMODE_1_1_pipe_write_req,
      write_ack => PMODE_1_1_pipe_write_ack,
      write_data => PMODE_1_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_2_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_2_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_2_0_pipe_read_req,
      read_ack => PMODE_2_0_pipe_read_ack,
      read_data => PMODE_2_0_pipe_read_data,
      write_req => PMODE_2_0_pipe_write_req,
      write_ack => PMODE_2_0_pipe_write_ack,
      write_data => PMODE_2_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_2_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_2_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_2_1_pipe_read_req,
      read_ack => PMODE_2_1_pipe_read_ack,
      read_data => PMODE_2_1_pipe_read_data,
      write_req => PMODE_2_1_pipe_write_req,
      write_ack => PMODE_2_1_pipe_write_ack,
      write_data => PMODE_2_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_3_0_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_3_0",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_3_0_pipe_read_req,
      read_ack => PMODE_3_0_pipe_read_ack,
      read_data => PMODE_3_0_pipe_read_data,
      write_req => PMODE_3_0_pipe_write_req,
      write_ack => PMODE_3_0_pipe_write_ack,
      write_data => PMODE_3_0_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  PMODE_3_1_inst:  PipeBase -- 
    generic map( -- 
      name => "pipe PMODE_3_1",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      signal_mode => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => PMODE_3_1_pipe_read_req,
      read_ack => PMODE_3_1_pipe_read_ack,
      read_data => PMODE_3_1_pipe_read_data,
      write_req => PMODE_3_1_pipe_write_req,
      write_ack => PMODE_3_1_pipe_write_ack,
      write_data => PMODE_3_1_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- 
end struct;
