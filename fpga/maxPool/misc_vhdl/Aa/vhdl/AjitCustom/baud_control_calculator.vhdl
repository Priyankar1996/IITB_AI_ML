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
library AjitCustom;
use AjitCustom.baud_control_calculator_global_package.all;
entity baudControlCalculatorDaemon is -- 
  generic (tag_length : integer); 
  port ( -- 
    BAUD_RATE_SIG : in std_logic_vector(31 downto 0);
    CLK_FREQUENCY_SIG : in std_logic_vector(31 downto 0);
    CLOCK_FREQUENCY_VALID : in std_logic_vector(0 downto 0);
    BAUD_CONTROL_WORD_SIG_pipe_write_req : out  std_logic_vector(0 downto 0);
    BAUD_CONTROL_WORD_SIG_pipe_write_ack : in   std_logic_vector(0 downto 0);
    BAUD_CONTROL_WORD_SIG_pipe_write_data : out  std_logic_vector(31 downto 0);
    BAUD_CONTROL_WORD_VALID_pipe_write_req : out  std_logic_vector(0 downto 0);
    BAUD_CONTROL_WORD_VALID_pipe_write_ack : in   std_logic_vector(0 downto 0);
    BAUD_CONTROL_WORD_VALID_pipe_write_data : out  std_logic_vector(0 downto 0);
    my_gcd_call_reqs : out  std_logic_vector(0 downto 0);
    my_gcd_call_acks : in   std_logic_vector(0 downto 0);
    my_gcd_call_data : out  std_logic_vector(63 downto 0);
    my_gcd_call_tag  :  out  std_logic_vector(0 downto 0);
    my_gcd_return_reqs : out  std_logic_vector(0 downto 0);
    my_gcd_return_acks : in   std_logic_vector(0 downto 0);
    my_gcd_return_data : in   std_logic_vector(31 downto 0);
    my_gcd_return_tag :  in   std_logic_vector(0 downto 0);
    my_div_call_reqs : out  std_logic_vector(0 downto 0);
    my_div_call_acks : in   std_logic_vector(0 downto 0);
    my_div_call_data : out  std_logic_vector(63 downto 0);
    my_div_call_tag  :  out  std_logic_vector(1 downto 0);
    my_div_return_reqs : out  std_logic_vector(0 downto 0);
    my_div_return_acks : in   std_logic_vector(0 downto 0);
    my_div_return_data : in   std_logic_vector(31 downto 0);
    my_div_return_tag :  in   std_logic_vector(1 downto 0);
    tag_in: in std_logic_vector(tag_length-1 downto 0);
    tag_out: out std_logic_vector(tag_length-1 downto 0) ;
    clk : in std_logic;
    reset : in std_logic;
    start_req : in std_logic;
    start_ack : out std_logic;
    fin_req : in std_logic;
    fin_ack   : out std_logic-- 
  );
  -- 
end entity baudControlCalculatorDaemon;
architecture baudControlCalculatorDaemon_arch of baudControlCalculatorDaemon is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector((tag_length + 0)-1 downto 0);
  signal default_zero_sig: std_logic;
  signal in_buffer_write_req: std_logic;
  signal in_buffer_write_ack: std_logic;
  signal in_buffer_unload_req_symbol: Boolean;
  signal in_buffer_unload_ack_symbol: Boolean;
  signal out_buffer_data_in, out_buffer_data_out: std_logic_vector((tag_length + 0)-1 downto 0);
  signal out_buffer_read_req: std_logic;
  signal out_buffer_read_ack: std_logic;
  signal out_buffer_write_req_symbol: Boolean;
  signal out_buffer_write_ack_symbol: Boolean;
  signal tag_ub_out, tag_ilock_out: std_logic_vector(tag_length-1 downto 0);
  signal tag_push_req, tag_push_ack, tag_pop_req, tag_pop_ack: std_logic;
  signal tag_unload_req_symbol, tag_unload_ack_symbol, tag_write_req_symbol, tag_write_ack_symbol: Boolean;
  signal tag_ilock_write_req_symbol, tag_ilock_write_ack_symbol, tag_ilock_read_req_symbol, tag_ilock_read_ack_symbol: Boolean;
  signal start_req_sig, fin_req_sig, start_ack_sig, fin_ack_sig: std_logic; 
  signal input_sample_reenable_symbol: Boolean;
  -- input port buffer signals
  -- output port buffer signals
  signal baudControlCalculatorDaemon_CP_295_start: Boolean;
  signal baudControlCalculatorDaemon_CP_295_symbol: Boolean;
  -- volatile/operator module components. 
  component my_gcd is -- 
    generic (tag_length : integer); 
    port ( -- 
      A : in  std_logic_vector(31 downto 0);
      B : in  std_logic_vector(31 downto 0);
      GCD : out  std_logic_vector(31 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  component my_div is -- 
    generic (tag_length : integer); 
    port ( -- 
      A : in  std_logic_vector(31 downto 0);
      B : in  std_logic_vector(31 downto 0);
      Q : out  std_logic_vector(31 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  -- links between control-path and data-path
  signal WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_1 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_1 : boolean;
  signal W_clock_valid_135_inst_req_0 : boolean;
  signal W_clock_valid_135_inst_ack_0 : boolean;
  signal W_clock_valid_135_inst_req_1 : boolean;
  signal W_clock_valid_135_inst_ack_1 : boolean;
  signal if_stmt_138_branch_req_0 : boolean;
  signal if_stmt_138_branch_ack_1 : boolean;
  signal if_stmt_138_branch_ack_0 : boolean;
  signal CONCAT_u16_u32_150_inst_req_0 : boolean;
  signal CONCAT_u16_u32_150_inst_ack_0 : boolean;
  signal CONCAT_u16_u32_150_inst_req_1 : boolean;
  signal CONCAT_u16_u32_150_inst_ack_1 : boolean;
  signal CONCAT_u28_u32_159_inst_req_0 : boolean;
  signal CONCAT_u28_u32_159_inst_ack_0 : boolean;
  signal CONCAT_u28_u32_159_inst_req_1 : boolean;
  signal CONCAT_u28_u32_159_inst_ack_1 : boolean;
  signal call_stmt_164_call_req_0 : boolean;
  signal call_stmt_164_call_ack_0 : boolean;
  signal call_stmt_164_call_req_1 : boolean;
  signal call_stmt_164_call_ack_1 : boolean;
  signal call_stmt_168_call_req_0 : boolean;
  signal call_stmt_168_call_ack_0 : boolean;
  signal call_stmt_168_call_req_1 : boolean;
  signal call_stmt_168_call_ack_1 : boolean;
  signal call_stmt_172_call_req_0 : boolean;
  signal call_stmt_172_call_ack_0 : boolean;
  signal call_stmt_172_call_req_1 : boolean;
  signal call_stmt_172_call_ack_1 : boolean;
  signal SUB_u32_u32_176_inst_req_0 : boolean;
  signal SUB_u32_u32_176_inst_ack_0 : boolean;
  signal SUB_u32_u32_176_inst_req_1 : boolean;
  signal SUB_u32_u32_176_inst_ack_1 : boolean;
  signal CONCAT_u20_u32_188_inst_req_0 : boolean;
  signal CONCAT_u20_u32_188_inst_ack_0 : boolean;
  signal CONCAT_u20_u32_188_inst_req_1 : boolean;
  signal CONCAT_u20_u32_188_inst_ack_1 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_1 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_1 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_0 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_1 : boolean;
  signal WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "baudControlCalculatorDaemon_input_buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      data_width => tag_length + 0) -- 
    port map(write_req => in_buffer_write_req, -- 
      write_ack => in_buffer_write_ack, 
      write_data => in_buffer_data_in,
      unload_req => in_buffer_unload_req_symbol, 
      unload_ack => in_buffer_unload_ack_symbol, 
      read_data => in_buffer_data_out,
      clk => clk, reset => reset); -- 
  in_buffer_data_in(tag_length-1 downto 0) <= tag_in;
  tag_ub_out <= in_buffer_data_out(tag_length-1 downto 0);
  in_buffer_write_req <= start_req;
  start_ack <= in_buffer_write_ack;
  in_buffer_unload_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 32) := "in_buffer_unload_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= in_buffer_unload_ack_symbol & input_sample_reenable_symbol;
    gj_in_buffer_unload_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => in_buffer_unload_req_symbol, clk => clk, reset => reset); --
  end block;
  -- join of all unload_ack_symbols.. used to trigger CP.
  baudControlCalculatorDaemon_CP_295_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "baudControlCalculatorDaemon_out_buffer", -- 
      buffer_size => 1,
      full_rate => false,
      data_width => tag_length + 0) --
    port map(write_req => out_buffer_write_req_symbol, -- 
      write_ack => out_buffer_write_ack_symbol, 
      write_data => out_buffer_data_in,
      read_req => out_buffer_read_req, 
      read_ack => out_buffer_read_ack, 
      read_data => out_buffer_data_out,
      clk => clk, reset => reset); -- 
  out_buffer_data_in(tag_length-1 downto 0) <= tag_ilock_out;
  tag_out <= out_buffer_data_out(tag_length-1 downto 0);
  out_buffer_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 0);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
    constant joinName: string(1 to 32) := "out_buffer_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= baudControlCalculatorDaemon_CP_295_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
    gj_out_buffer_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => out_buffer_write_req_symbol, clk => clk, reset => reset); --
  end block;
  -- write-to output-buffer produces  reenable input sampling
  input_sample_reenable_symbol <= out_buffer_write_ack_symbol;
  -- fin-req/ack level protocol..
  out_buffer_read_req <= fin_req;
  fin_ack <= out_buffer_read_ack;
  ----- tag-queue --------------------------------------------------
  -- interlock buffer for TAG.. to provide required buffering.
  tagIlock: InterlockBuffer -- 
    generic map(name => "tag-interlock-buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      in_data_width => tag_length,
      out_data_width => tag_length) -- 
    port map(write_req => tag_ilock_write_req_symbol, -- 
      write_ack => tag_ilock_write_ack_symbol, 
      write_data => tag_ub_out,
      read_req => tag_ilock_read_req_symbol, 
      read_ack => tag_ilock_read_ack_symbol, 
      read_data => tag_ilock_out, 
      clk => clk, reset => reset); -- 
  -- tag ilock-buffer control logic. 
  tag_ilock_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 31) := "tag_ilock_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= baudControlCalculatorDaemon_CP_295_start & tag_ilock_write_ack_symbol;
    gj_tag_ilock_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_write_req_symbol, clk => clk, reset => reset); --
  end block;
  tag_ilock_read_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
    constant joinName: string(1 to 30) := "tag_ilock_read_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= baudControlCalculatorDaemon_CP_295_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  baudControlCalculatorDaemon_CP_295: Block -- control-path 
    signal baudControlCalculatorDaemon_CP_295_elements: BooleanArray(32 downto 0);
    -- 
  begin -- 
    baudControlCalculatorDaemon_CP_295_elements(0) <= baudControlCalculatorDaemon_CP_295_start;
    baudControlCalculatorDaemon_CP_295_symbol <= baudControlCalculatorDaemon_CP_295_elements(3);
    -- CP-element group 0:  transition  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	1 
    -- CP-element group 0:  members (5) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 assign_stmt_132/$entry
      -- CP-element group 0: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_sample_start_
      -- CP-element group 0: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Sample/$entry
      -- CP-element group 0: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Sample/req
      -- 
    req_308_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_308_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(0), ack => WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_0); -- 
    -- CP-element group 1:  transition  input  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	0 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	2 
    -- CP-element group 1:  members (6) 
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_sample_completed_
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_update_start_
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Sample/$exit
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Sample/ack
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Update/$entry
      -- CP-element group 1: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Update/req
      -- 
    ack_309_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 1_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(1)); -- 
    req_313_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_313_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(1), ack => WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_1); -- 
    -- CP-element group 2:  branch  transition  place  input  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	1 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	31 
    -- CP-element group 2:  members (10) 
      -- CP-element group 2: 	 assign_stmt_132/$exit
      -- CP-element group 2: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_update_completed_
      -- CP-element group 2: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Update/$exit
      -- CP-element group 2: 	 assign_stmt_132/WPIPE_BAUD_CONTROL_WORD_VALID_130_Update/ack
      -- CP-element group 2: 	 branch_block_stmt_133/$entry
      -- CP-element group 2: 	 branch_block_stmt_133/branch_block_stmt_133__entry__
      -- CP-element group 2: 	 branch_block_stmt_133/merge_stmt_134__entry__
      -- CP-element group 2: 	 branch_block_stmt_133/merge_stmt_134_dead_link/$entry
      -- CP-element group 2: 	 branch_block_stmt_133/merge_stmt_134__entry___PhiReq/$entry
      -- CP-element group 2: 	 branch_block_stmt_133/merge_stmt_134__entry___PhiReq/$exit
      -- 
    ack_314_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(2)); -- 
    -- CP-element group 3:  transition  place  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: successors 
    -- CP-element group 3:  members (3) 
      -- CP-element group 3: 	 $exit
      -- CP-element group 3: 	 branch_block_stmt_133/$exit
      -- CP-element group 3: 	 branch_block_stmt_133/branch_block_stmt_133__exit__
      -- 
    baudControlCalculatorDaemon_CP_295_elements(3) <= false; 
    -- CP-element group 4:  transition  input  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	31 
    -- CP-element group 4: successors 
    -- CP-element group 4:  members (3) 
      -- CP-element group 4: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_sample_completed_
      -- CP-element group 4: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Sample/$exit
      -- CP-element group 4: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Sample/ack
      -- 
    ack_344_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 4_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_clock_valid_135_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(4)); -- 
    -- CP-element group 5:  branch  transition  place  input  output  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	31 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	6 
    -- CP-element group 5: 	7 
    -- CP-element group 5:  members (25) 
      -- CP-element group 5: 	 branch_block_stmt_133/assign_stmt_137__exit__
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138__entry__
      -- CP-element group 5: 	 branch_block_stmt_133/assign_stmt_137/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_update_completed_
      -- CP-element group 5: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Update/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Update/ack
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_dead_link/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Sample/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Sample/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Sample/rr
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Sample/ra
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Update/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Update/$exit
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Update/cr
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/NOT_u1_u1_140/SplitProtocol/Update/ca
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_eval_test/branch_req
      -- CP-element group 5: 	 branch_block_stmt_133/NOT_u1_u1_140_place
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_if_link/$entry
      -- CP-element group 5: 	 branch_block_stmt_133/if_stmt_138_else_link/$entry
      -- 
    ack_349_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_clock_valid_135_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(5)); -- 
    branch_req_373_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_373_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(5), ack => if_stmt_138_branch_req_0); -- 
    -- CP-element group 6:  transition  place  input  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	5 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	31 
    -- CP-element group 6:  members (5) 
      -- CP-element group 6: 	 branch_block_stmt_133/if_stmt_138_if_link/$exit
      -- CP-element group 6: 	 branch_block_stmt_133/if_stmt_138_if_link/if_choice_transition
      -- CP-element group 6: 	 branch_block_stmt_133/wait_on_clock
      -- CP-element group 6: 	 branch_block_stmt_133/wait_on_clock_PhiReq/$entry
      -- CP-element group 6: 	 branch_block_stmt_133/wait_on_clock_PhiReq/$exit
      -- 
    if_choice_transition_378_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 6_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_138_branch_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(6)); -- 
    -- CP-element group 7:  merge  branch  transition  place  input  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	5 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	32 
    -- CP-element group 7:  members (7) 
      -- CP-element group 7: 	 branch_block_stmt_133/if_stmt_138__exit__
      -- CP-element group 7: 	 branch_block_stmt_133/merge_stmt_143__entry__
      -- CP-element group 7: 	 branch_block_stmt_133/if_stmt_138_else_link/$exit
      -- CP-element group 7: 	 branch_block_stmt_133/if_stmt_138_else_link/else_choice_transition
      -- CP-element group 7: 	 branch_block_stmt_133/merge_stmt_143_dead_link/$entry
      -- CP-element group 7: 	 branch_block_stmt_133/merge_stmt_143__entry___PhiReq/$entry
      -- CP-element group 7: 	 branch_block_stmt_133/merge_stmt_143__entry___PhiReq/$exit
      -- 
    else_choice_transition_382_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 7_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_138_branch_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(7)); -- 
    -- CP-element group 8:  transition  input  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	32 
    -- CP-element group 8: successors 
    -- CP-element group 8:  members (3) 
      -- CP-element group 8: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_sample_completed_
      -- CP-element group 8: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Sample/$exit
      -- CP-element group 8: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Sample/ra
      -- 
    ra_395_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 8_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u16_u32_150_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(8)); -- 
    -- CP-element group 9:  fork  transition  input  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	32 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	12 
    -- CP-element group 9: 	18 
    -- CP-element group 9:  members (3) 
      -- CP-element group 9: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_update_completed_
      -- CP-element group 9: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Update/$exit
      -- CP-element group 9: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Update/ca
      -- 
    ca_400_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 9_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u16_u32_150_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(9)); -- 
    -- CP-element group 10:  transition  input  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	32 
    -- CP-element group 10: successors 
    -- CP-element group 10:  members (3) 
      -- CP-element group 10: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_sample_completed_
      -- CP-element group 10: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Sample/$exit
      -- CP-element group 10: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Sample/ra
      -- 
    ra_409_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u28_u32_159_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(10)); -- 
    -- CP-element group 11:  fork  transition  input  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	32 
    -- CP-element group 11: successors 
    -- CP-element group 11: 	15 
    -- CP-element group 11: 	12 
    -- CP-element group 11:  members (3) 
      -- CP-element group 11: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_update_completed_
      -- CP-element group 11: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Update/$exit
      -- CP-element group 11: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Update/ca
      -- 
    ca_414_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u28_u32_159_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(11)); -- 
    -- CP-element group 12:  join  transition  output  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	11 
    -- CP-element group 12: 	9 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	13 
    -- CP-element group 12:  members (3) 
      -- CP-element group 12: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_sample_start_
      -- CP-element group 12: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Sample/$entry
      -- CP-element group 12: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Sample/crr
      -- 
    crr_422_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_422_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(12), ack => call_stmt_164_call_req_0); -- 
    baudControlCalculatorDaemon_cp_element_group_12: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 47) := "baudControlCalculatorDaemon_cp_element_group_12"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= baudControlCalculatorDaemon_CP_295_elements(11) & baudControlCalculatorDaemon_CP_295_elements(9);
      gj_baudControlCalculatorDaemon_cp_element_group_12 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => baudControlCalculatorDaemon_CP_295_elements(12), clk => clk, reset => reset); --
    end block;
    -- CP-element group 13:  transition  input  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	12 
    -- CP-element group 13: successors 
    -- CP-element group 13:  members (3) 
      -- CP-element group 13: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_sample_completed_
      -- CP-element group 13: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Sample/$exit
      -- CP-element group 13: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Sample/cra
      -- 
    cra_423_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_164_call_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(13)); -- 
    -- CP-element group 14:  fork  transition  input  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	32 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14: 	18 
    -- CP-element group 14:  members (3) 
      -- CP-element group 14: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_update_completed_
      -- CP-element group 14: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Update/$exit
      -- CP-element group 14: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Update/cca
      -- 
    cca_428_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_164_call_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(14)); -- 
    -- CP-element group 15:  join  transition  output  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: 	11 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	16 
    -- CP-element group 15:  members (3) 
      -- CP-element group 15: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_sample_start_
      -- CP-element group 15: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Sample/$entry
      -- CP-element group 15: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Sample/crr
      -- 
    crr_436_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_436_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(15), ack => call_stmt_168_call_req_0); -- 
    baudControlCalculatorDaemon_cp_element_group_15: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 47) := "baudControlCalculatorDaemon_cp_element_group_15"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= baudControlCalculatorDaemon_CP_295_elements(14) & baudControlCalculatorDaemon_CP_295_elements(11);
      gj_baudControlCalculatorDaemon_cp_element_group_15 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => baudControlCalculatorDaemon_CP_295_elements(15), clk => clk, reset => reset); --
    end block;
    -- CP-element group 16:  transition  input  bypass 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	15 
    -- CP-element group 16: successors 
    -- CP-element group 16:  members (3) 
      -- CP-element group 16: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_sample_completed_
      -- CP-element group 16: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Sample/$exit
      -- CP-element group 16: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Sample/cra
      -- 
    cra_437_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 16_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_168_call_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(16)); -- 
    -- CP-element group 17:  fork  transition  input  bypass 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: 	32 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	24 
    -- CP-element group 17: 	21 
    -- CP-element group 17:  members (3) 
      -- CP-element group 17: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_update_completed_
      -- CP-element group 17: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Update/$exit
      -- CP-element group 17: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Update/cca
      -- 
    cca_442_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 17_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_168_call_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(17)); -- 
    -- CP-element group 18:  join  transition  output  bypass 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	14 
    -- CP-element group 18: 	9 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	19 
    -- CP-element group 18:  members (3) 
      -- CP-element group 18: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_sample_start_
      -- CP-element group 18: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Sample/$entry
      -- CP-element group 18: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Sample/crr
      -- 
    crr_450_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_450_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(18), ack => call_stmt_172_call_req_0); -- 
    baudControlCalculatorDaemon_cp_element_group_18: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 47) := "baudControlCalculatorDaemon_cp_element_group_18"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= baudControlCalculatorDaemon_CP_295_elements(14) & baudControlCalculatorDaemon_CP_295_elements(9);
      gj_baudControlCalculatorDaemon_cp_element_group_18 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => baudControlCalculatorDaemon_CP_295_elements(18), clk => clk, reset => reset); --
    end block;
    -- CP-element group 19:  transition  input  bypass 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	18 
    -- CP-element group 19: successors 
    -- CP-element group 19:  members (3) 
      -- CP-element group 19: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_sample_completed_
      -- CP-element group 19: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Sample/$exit
      -- CP-element group 19: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Sample/cra
      -- 
    cra_451_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 19_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_172_call_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(19)); -- 
    -- CP-element group 20:  transition  input  bypass 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	32 
    -- CP-element group 20: successors 
    -- CP-element group 20: 	21 
    -- CP-element group 20:  members (3) 
      -- CP-element group 20: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_update_completed_
      -- CP-element group 20: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Update/$exit
      -- CP-element group 20: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Update/cca
      -- 
    cca_456_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 20_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_172_call_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(20)); -- 
    -- CP-element group 21:  join  transition  output  bypass 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	20 
    -- CP-element group 21: 	17 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	22 
    -- CP-element group 21:  members (3) 
      -- CP-element group 21: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_sample_start_
      -- CP-element group 21: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Sample/$entry
      -- CP-element group 21: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Sample/rr
      -- 
    rr_464_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_464_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(21), ack => SUB_u32_u32_176_inst_req_0); -- 
    baudControlCalculatorDaemon_cp_element_group_21: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 47) := "baudControlCalculatorDaemon_cp_element_group_21"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= baudControlCalculatorDaemon_CP_295_elements(20) & baudControlCalculatorDaemon_CP_295_elements(17);
      gj_baudControlCalculatorDaemon_cp_element_group_21 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => baudControlCalculatorDaemon_CP_295_elements(21), clk => clk, reset => reset); --
    end block;
    -- CP-element group 22:  transition  input  bypass 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	21 
    -- CP-element group 22: successors 
    -- CP-element group 22:  members (3) 
      -- CP-element group 22: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_sample_completed_
      -- CP-element group 22: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Sample/$exit
      -- CP-element group 22: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Sample/ra
      -- 
    ra_465_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 22_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => SUB_u32_u32_176_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(22)); -- 
    -- CP-element group 23:  transition  input  bypass 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: 	32 
    -- CP-element group 23: successors 
    -- CP-element group 23: 	24 
    -- CP-element group 23:  members (3) 
      -- CP-element group 23: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_update_completed_
      -- CP-element group 23: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Update/$exit
      -- CP-element group 23: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Update/ca
      -- 
    ca_470_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 23_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => SUB_u32_u32_176_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(23)); -- 
    -- CP-element group 24:  join  transition  output  bypass 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	23 
    -- CP-element group 24: 	17 
    -- CP-element group 24: successors 
    -- CP-element group 24: 	25 
    -- CP-element group 24:  members (3) 
      -- CP-element group 24: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_sample_start_
      -- CP-element group 24: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Sample/$entry
      -- CP-element group 24: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Sample/rr
      -- 
    rr_478_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_478_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(24), ack => CONCAT_u20_u32_188_inst_req_0); -- 
    baudControlCalculatorDaemon_cp_element_group_24: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 47) := "baudControlCalculatorDaemon_cp_element_group_24"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= baudControlCalculatorDaemon_CP_295_elements(23) & baudControlCalculatorDaemon_CP_295_elements(17);
      gj_baudControlCalculatorDaemon_cp_element_group_24 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => baudControlCalculatorDaemon_CP_295_elements(24), clk => clk, reset => reset); --
    end block;
    -- CP-element group 25:  transition  input  bypass 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	24 
    -- CP-element group 25: successors 
    -- CP-element group 25:  members (3) 
      -- CP-element group 25: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_sample_completed_
      -- CP-element group 25: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Sample/$exit
      -- CP-element group 25: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Sample/ra
      -- 
    ra_479_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 25_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u20_u32_188_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(25)); -- 
    -- CP-element group 26:  transition  input  output  bypass 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	32 
    -- CP-element group 26: successors 
    -- CP-element group 26: 	27 
    -- CP-element group 26:  members (6) 
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_update_completed_
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Update/$exit
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Update/ca
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_sample_start_
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Sample/$entry
      -- CP-element group 26: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Sample/req
      -- 
    ca_484_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 26_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => CONCAT_u20_u32_188_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(26)); -- 
    req_492_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_492_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(26), ack => WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_0); -- 
    -- CP-element group 27:  transition  input  output  bypass 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: 	26 
    -- CP-element group 27: successors 
    -- CP-element group 27: 	28 
    -- CP-element group 27:  members (6) 
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_sample_completed_
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_update_start_
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Sample/$exit
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Sample/ack
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Update/$entry
      -- CP-element group 27: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Update/req
      -- 
    ack_493_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 27_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(27)); -- 
    req_497_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_497_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(27), ack => WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_1); -- 
    -- CP-element group 28:  transition  place  input  output  bypass 
    -- CP-element group 28: predecessors 
    -- CP-element group 28: 	27 
    -- CP-element group 28: successors 
    -- CP-element group 28: 	29 
    -- CP-element group 28:  members (10) 
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189__exit__
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_193__entry__
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/$exit
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_update_completed_
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Update/$exit
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/WPIPE_BAUD_CONTROL_WORD_SIG_178_Update/ack
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_193/$entry
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_sample_start_
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Sample/$entry
      -- CP-element group 28: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Sample/req
      -- 
    ack_498_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 28_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(28)); -- 
    req_509_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_509_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(28), ack => WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_0); -- 
    -- CP-element group 29:  transition  input  output  bypass 
    -- CP-element group 29: predecessors 
    -- CP-element group 29: 	28 
    -- CP-element group 29: successors 
    -- CP-element group 29: 	30 
    -- CP-element group 29:  members (6) 
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_sample_completed_
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_update_start_
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Sample/$exit
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Sample/ack
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Update/$entry
      -- CP-element group 29: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Update/req
      -- 
    ack_510_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 29_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_0, ack => baudControlCalculatorDaemon_CP_295_elements(29)); -- 
    req_514_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_514_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(29), ack => WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_1); -- 
    -- CP-element group 30:  transition  place  input  bypass 
    -- CP-element group 30: predecessors 
    -- CP-element group 30: 	29 
    -- CP-element group 30: successors 
    -- CP-element group 30: 	32 
    -- CP-element group 30:  members (8) 
      -- CP-element group 30: 	 branch_block_stmt_133/assign_stmt_193__exit__
      -- CP-element group 30: 	 branch_block_stmt_133/loopback
      -- CP-element group 30: 	 branch_block_stmt_133/assign_stmt_193/$exit
      -- CP-element group 30: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_update_completed_
      -- CP-element group 30: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Update/$exit
      -- CP-element group 30: 	 branch_block_stmt_133/assign_stmt_193/WPIPE_BAUD_CONTROL_WORD_VALID_191_Update/ack
      -- CP-element group 30: 	 branch_block_stmt_133/loopback_PhiReq/$entry
      -- CP-element group 30: 	 branch_block_stmt_133/loopback_PhiReq/$exit
      -- 
    ack_515_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 30_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_1, ack => baudControlCalculatorDaemon_CP_295_elements(30)); -- 
    -- CP-element group 31:  merge  fork  transition  place  output  bypass 
    -- CP-element group 31: predecessors 
    -- CP-element group 31: 	6 
    -- CP-element group 31: 	2 
    -- CP-element group 31: successors 
    -- CP-element group 31: 	5 
    -- CP-element group 31: 	4 
    -- CP-element group 31:  members (13) 
      -- CP-element group 31: 	 branch_block_stmt_133/merge_stmt_134__exit__
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137__entry__
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/$entry
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_sample_start_
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_update_start_
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Sample/$entry
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Sample/req
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Update/$entry
      -- CP-element group 31: 	 branch_block_stmt_133/assign_stmt_137/assign_stmt_137_Update/req
      -- CP-element group 31: 	 branch_block_stmt_133/merge_stmt_134_PhiReqMerge
      -- CP-element group 31: 	 branch_block_stmt_133/merge_stmt_134_PhiAck/$entry
      -- CP-element group 31: 	 branch_block_stmt_133/merge_stmt_134_PhiAck/$exit
      -- CP-element group 31: 	 branch_block_stmt_133/merge_stmt_134_PhiAck/dummy
      -- 
    req_343_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_343_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(31), ack => W_clock_valid_135_inst_req_0); -- 
    req_348_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_348_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(31), ack => W_clock_valid_135_inst_req_1); -- 
    baudControlCalculatorDaemon_CP_295_elements(31) <= OrReduce(baudControlCalculatorDaemon_CP_295_elements(6) & baudControlCalculatorDaemon_CP_295_elements(2));
    -- CP-element group 32:  merge  fork  transition  place  output  bypass 
    -- CP-element group 32: predecessors 
    -- CP-element group 32: 	30 
    -- CP-element group 32: 	7 
    -- CP-element group 32: successors 
    -- CP-element group 32: 	14 
    -- CP-element group 32: 	11 
    -- CP-element group 32: 	23 
    -- CP-element group 32: 	20 
    -- CP-element group 32: 	17 
    -- CP-element group 32: 	10 
    -- CP-element group 32: 	9 
    -- CP-element group 32: 	8 
    -- CP-element group 32: 	26 
    -- CP-element group 32:  members (34) 
      -- CP-element group 32: 	 branch_block_stmt_133/merge_stmt_143__exit__
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189__entry__
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_sample_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Sample/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Sample/rr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u16_u32_150_Update/cr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_sample_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Sample/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Sample/rr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u28_u32_159_Update/cr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_164_Update/ccr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_168_Update/ccr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/call_stmt_172_Update/ccr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/SUB_u32_u32_176_Update/cr
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_update_start_
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/assign_stmt_151_to_assign_stmt_189/CONCAT_u20_u32_188_Update/cr
      -- CP-element group 32: 	 branch_block_stmt_133/merge_stmt_143_PhiReqMerge
      -- CP-element group 32: 	 branch_block_stmt_133/merge_stmt_143_PhiAck/$entry
      -- CP-element group 32: 	 branch_block_stmt_133/merge_stmt_143_PhiAck/$exit
      -- CP-element group 32: 	 branch_block_stmt_133/merge_stmt_143_PhiAck/dummy
      -- 
    rr_394_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_394_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => CONCAT_u16_u32_150_inst_req_0); -- 
    cr_399_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_399_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => CONCAT_u16_u32_150_inst_req_1); -- 
    rr_408_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_408_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => CONCAT_u28_u32_159_inst_req_0); -- 
    cr_413_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_413_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => CONCAT_u28_u32_159_inst_req_1); -- 
    ccr_427_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_427_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => call_stmt_164_call_req_1); -- 
    ccr_441_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_441_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => call_stmt_168_call_req_1); -- 
    ccr_455_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_455_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => call_stmt_172_call_req_1); -- 
    cr_469_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_469_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => SUB_u32_u32_176_inst_req_1); -- 
    cr_483_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_483_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => baudControlCalculatorDaemon_CP_295_elements(32), ack => CONCAT_u20_u32_188_inst_req_1); -- 
    baudControlCalculatorDaemon_CP_295_elements(32) <= OrReduce(baudControlCalculatorDaemon_CP_295_elements(30) & baudControlCalculatorDaemon_CP_295_elements(7));
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal BF_168 : std_logic_vector(31 downto 0);
    signal BL_177 : std_logic_vector(31 downto 0);
    signal BLx_172 : std_logic_vector(31 downto 0);
    signal BRx16_160 : std_logic_vector(31 downto 0);
    signal CONCAT_u16_u20_183_wire : std_logic_vector(19 downto 0);
    signal CONCAT_u20_u32_188_wire : std_logic_vector(31 downto 0);
    signal GCD_164 : std_logic_vector(31 downto 0);
    signal NOT_u1_u1_140_wire : std_logic_vector(0 downto 0);
    signal RPIPE_BAUD_RATE_SIG_153_wire : std_logic_vector(31 downto 0);
    signal RPIPE_CLK_FREQUENCY_SIG_145_wire : std_logic_vector(31 downto 0);
    signal RPIPE_CLOCK_FREQUENCY_VALID_136_wire : std_logic_vector(0 downto 0);
    signal SS_151 : std_logic_vector(31 downto 0);
    signal clock_valid_137 : std_logic_vector(0 downto 0);
    signal konst_131_wire_constant : std_logic_vector(0 downto 0);
    signal konst_192_wire_constant : std_logic_vector(0 downto 0);
    signal slice_147_wire : std_logic_vector(15 downto 0);
    signal slice_155_wire : std_logic_vector(27 downto 0);
    signal slice_180_wire : std_logic_vector(15 downto 0);
    signal slice_187_wire : std_logic_vector(11 downto 0);
    signal type_cast_149_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_158_wire_constant : std_logic_vector(3 downto 0);
    signal type_cast_182_wire_constant : std_logic_vector(3 downto 0);
    -- 
  begin -- 
    konst_131_wire_constant <= "0";
    konst_192_wire_constant <= "1";
    type_cast_149_wire_constant <= "0000000000000000";
    type_cast_158_wire_constant <= "0000";
    type_cast_182_wire_constant <= "0000";
    -- flow-through slice operator slice_147_inst
    slice_147_wire <= RPIPE_CLK_FREQUENCY_SIG_145_wire(31 downto 16);
    -- flow-through slice operator slice_155_inst
    slice_155_wire <= RPIPE_BAUD_RATE_SIG_153_wire(27 downto 0);
    -- flow-through slice operator slice_180_inst
    slice_180_wire <= BL_177(15 downto 0);
    -- flow-through slice operator slice_187_inst
    slice_187_wire <= BF_168(11 downto 0);
    W_clock_valid_135_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_clock_valid_135_inst_req_0;
      W_clock_valid_135_inst_ack_0<= wack(0);
      rreq(0) <= W_clock_valid_135_inst_req_1;
      W_clock_valid_135_inst_ack_1<= rack(0);
      W_clock_valid_135_inst : InterlockBuffer generic map ( -- 
        name => "W_clock_valid_135_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 1,
        out_data_width => 1,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => RPIPE_CLOCK_FREQUENCY_VALID_136_wire,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => clock_valid_137,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    if_stmt_138_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= NOT_u1_u1_140_wire;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_138_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_138_branch_req_0,
          ack0 => if_stmt_138_branch_ack_0,
          ack1 => if_stmt_138_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator CONCAT_u16_u20_183_inst
    process(slice_180_wire) -- 
      variable tmp_var : std_logic_vector(19 downto 0); -- 
    begin -- 
      ApConcat_proc(slice_180_wire, type_cast_182_wire_constant, tmp_var);
      CONCAT_u16_u20_183_wire <= tmp_var; --
    end process;
    -- shared split operator group (1) : CONCAT_u16_u32_150_inst 
    ApConcat_group_1: Block -- 
      signal data_in: std_logic_vector(15 downto 0);
      signal data_out: std_logic_vector(31 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= slice_147_wire;
      SS_151 <= data_out(31 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= CONCAT_u16_u32_150_inst_req_0;
      CONCAT_u16_u32_150_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= CONCAT_u16_u32_150_inst_req_1;
      CONCAT_u16_u32_150_inst_ack_1 <= ackR_unguarded(0);
      ApConcat_group_1_gI: SplitGuardInterface generic map(name => "ApConcat_group_1_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL,
        sa_in => ackL,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      UnsharedOperator: UnsharedOperatorWithBuffering -- 
        generic map ( -- 
          operator_id => "ApConcat",
          name => "ApConcat_group_1",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 16,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 32,
          constant_operand => "0000000000000000",
          constant_width => 16,
          buffering  => 1,
          flow_through => false,
          full_rate  => false,
          use_constant  => true
          --
        ) 
        port map ( -- 
          reqL => reqL(0),
          ackL => ackL(0),
          reqR => reqR(0),
          ackR => ackR(0),
          dataL => data_in, 
          dataR => data_out,
          clk => clk,
          reset => reset); -- 
      -- 
    end Block; -- split operator group 1
    -- shared split operator group (2) : CONCAT_u20_u32_188_inst 
    ApConcat_group_2: Block -- 
      signal data_in: std_logic_vector(31 downto 0);
      signal data_out: std_logic_vector(31 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= CONCAT_u16_u20_183_wire & slice_187_wire;
      CONCAT_u20_u32_188_wire <= data_out(31 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= CONCAT_u20_u32_188_inst_req_0;
      CONCAT_u20_u32_188_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= CONCAT_u20_u32_188_inst_req_1;
      CONCAT_u20_u32_188_inst_ack_1 <= ackR_unguarded(0);
      ApConcat_group_2_gI: SplitGuardInterface generic map(name => "ApConcat_group_2_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL,
        sa_in => ackL,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      UnsharedOperator: UnsharedOperatorWithBuffering -- 
        generic map ( -- 
          operator_id => "ApConcat",
          name => "ApConcat_group_2",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 20,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 12, 
          num_inputs    => 2,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 32,
          constant_operand => "0",
          constant_width => 1,
          buffering  => 1,
          flow_through => false,
          full_rate  => false,
          use_constant  => false
          --
        ) 
        port map ( -- 
          reqL => reqL(0),
          ackL => ackL(0),
          reqR => reqR(0),
          ackR => ackR(0),
          dataL => data_in, 
          dataR => data_out,
          clk => clk,
          reset => reset); -- 
      -- 
    end Block; -- split operator group 2
    -- shared split operator group (3) : CONCAT_u28_u32_159_inst 
    ApConcat_group_3: Block -- 
      signal data_in: std_logic_vector(27 downto 0);
      signal data_out: std_logic_vector(31 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= slice_155_wire;
      BRx16_160 <= data_out(31 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= CONCAT_u28_u32_159_inst_req_0;
      CONCAT_u28_u32_159_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= CONCAT_u28_u32_159_inst_req_1;
      CONCAT_u28_u32_159_inst_ack_1 <= ackR_unguarded(0);
      ApConcat_group_3_gI: SplitGuardInterface generic map(name => "ApConcat_group_3_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL,
        sa_in => ackL,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      UnsharedOperator: UnsharedOperatorWithBuffering -- 
        generic map ( -- 
          operator_id => "ApConcat",
          name => "ApConcat_group_3",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 28,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 32,
          constant_operand => "0000",
          constant_width => 4,
          buffering  => 1,
          flow_through => false,
          full_rate  => false,
          use_constant  => true
          --
        ) 
        port map ( -- 
          reqL => reqL(0),
          ackL => ackL(0),
          reqR => reqR(0),
          ackR => ackR(0),
          dataL => data_in, 
          dataR => data_out,
          clk => clk,
          reset => reset); -- 
      -- 
    end Block; -- split operator group 3
    -- unary operator NOT_u1_u1_140_inst
    process(clock_valid_137) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", clock_valid_137, tmp_var);
      NOT_u1_u1_140_wire <= tmp_var; -- 
    end process;
    -- shared split operator group (5) : SUB_u32_u32_176_inst 
    ApIntSub_group_5: Block -- 
      signal data_in: std_logic_vector(63 downto 0);
      signal data_out: std_logic_vector(31 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= BLx_172 & BF_168;
      BL_177 <= data_out(31 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= SUB_u32_u32_176_inst_req_0;
      SUB_u32_u32_176_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= SUB_u32_u32_176_inst_req_1;
      SUB_u32_u32_176_inst_ack_1 <= ackR_unguarded(0);
      ApIntSub_group_5_gI: SplitGuardInterface generic map(name => "ApIntSub_group_5_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL,
        sa_in => ackL,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      UnsharedOperator: UnsharedOperatorWithBuffering -- 
        generic map ( -- 
          operator_id => "ApIntSub",
          name => "ApIntSub_group_5",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 32,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 32, 
          num_inputs    => 2,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 32,
          constant_operand => "0",
          constant_width => 1,
          buffering  => 1,
          flow_through => false,
          full_rate  => false,
          use_constant  => false
          --
        ) 
        port map ( -- 
          reqL => reqL(0),
          ackL => ackL(0),
          reqR => reqR(0),
          ackR => ackR(0),
          dataL => data_in, 
          dataR => data_out,
          clk => clk,
          reset => reset); -- 
      -- 
    end Block; -- split operator group 5
    -- read from input-signal BAUD_RATE_SIG
    RPIPE_BAUD_RATE_SIG_153_wire <= BAUD_RATE_SIG;
    -- read from input-signal CLK_FREQUENCY_SIG
    RPIPE_CLK_FREQUENCY_SIG_145_wire <= CLK_FREQUENCY_SIG;
    -- read from input-signal CLOCK_FREQUENCY_VALID
    RPIPE_CLOCK_FREQUENCY_VALID_136_wire <= CLOCK_FREQUENCY_VALID;
    -- shared outport operator group (0) : WPIPE_BAUD_CONTROL_WORD_SIG_178_inst 
    OutportGroup_0: Block -- 
      signal data_in: std_logic_vector(31 downto 0);
      signal sample_req, sample_ack : BooleanArray( 0 downto 0);
      signal update_req, update_ack : BooleanArray( 0 downto 0);
      signal sample_req_unguarded, sample_ack_unguarded : BooleanArray( 0 downto 0);
      signal update_req_unguarded, update_ack_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      sample_req_unguarded(0) <= WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_0;
      WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(0) <= WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_req_1;
      WPIPE_BAUD_CONTROL_WORD_SIG_178_inst_ack_1 <= update_ack_unguarded(0);
      guard_vector(0)  <=  '1';
      data_in <= CONCAT_u20_u32_188_wire;
      BAUD_CONTROL_WORD_SIG_write_0_gI: SplitGuardInterface generic map(name => "BAUD_CONTROL_WORD_SIG_write_0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => sample_req_unguarded,
        sr_out => sample_req,
        sa_in => sample_ack,
        sa_out => sample_ack_unguarded,
        cr_in => update_req_unguarded,
        cr_out => update_req,
        ca_in => update_ack,
        ca_out => update_ack_unguarded,
        guards => guard_vector); -- 
      BAUD_CONTROL_WORD_SIG_write_0: OutputPortRevised -- 
        generic map ( name => "BAUD_CONTROL_WORD_SIG", data_width => 32, num_reqs => 1, input_buffering => inBUFs, full_rate => false,
        no_arbitration => false)
        port map (--
          sample_req => sample_req , 
          sample_ack => sample_ack , 
          update_req => update_req , 
          update_ack => update_ack , 
          data => data_in, 
          oreq => BAUD_CONTROL_WORD_SIG_pipe_write_req(0),
          oack => BAUD_CONTROL_WORD_SIG_pipe_write_ack(0),
          odata => BAUD_CONTROL_WORD_SIG_pipe_write_data(31 downto 0),
          clk => clk, reset => reset -- 
        );-- 
      -- 
    end Block; -- outport group 0
    -- shared outport operator group (1) : WPIPE_BAUD_CONTROL_WORD_VALID_130_inst WPIPE_BAUD_CONTROL_WORD_VALID_191_inst 
    OutportGroup_1: Block -- 
      signal data_in: std_logic_vector(1 downto 0);
      signal sample_req, sample_ack : BooleanArray( 1 downto 0);
      signal update_req, update_ack : BooleanArray( 1 downto 0);
      signal sample_req_unguarded, sample_ack_unguarded : BooleanArray( 1 downto 0);
      signal update_req_unguarded, update_ack_unguarded : BooleanArray( 1 downto 0);
      signal guard_vector : std_logic_vector( 1 downto 0);
      constant inBUFs : IntegerArray(1 downto 0) := (1 => 0, 0 => 0);
      constant guardFlags : BooleanArray(1 downto 0) := (0 => false, 1 => false);
      constant guardBuffering: IntegerArray(1 downto 0)  := (0 => 2, 1 => 2);
      -- 
    begin -- 
      sample_req_unguarded(1) <= WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_0;
      sample_req_unguarded(0) <= WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_0;
      WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_0 <= sample_ack_unguarded(1);
      WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(1) <= WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_req_1;
      update_req_unguarded(0) <= WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_req_1;
      WPIPE_BAUD_CONTROL_WORD_VALID_130_inst_ack_1 <= update_ack_unguarded(1);
      WPIPE_BAUD_CONTROL_WORD_VALID_191_inst_ack_1 <= update_ack_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      data_in <= konst_131_wire_constant & konst_192_wire_constant;
      BAUD_CONTROL_WORD_VALID_write_1_gI: SplitGuardInterface generic map(name => "BAUD_CONTROL_WORD_VALID_write_1_gI", nreqs => 2, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => sample_req_unguarded,
        sr_out => sample_req,
        sa_in => sample_ack,
        sa_out => sample_ack_unguarded,
        cr_in => update_req_unguarded,
        cr_out => update_req,
        ca_in => update_ack,
        ca_out => update_ack_unguarded,
        guards => guard_vector); -- 
      BAUD_CONTROL_WORD_VALID_write_1: OutputPortRevised -- 
        generic map ( name => "BAUD_CONTROL_WORD_VALID", data_width => 1, num_reqs => 2, input_buffering => inBUFs, full_rate => false,
        no_arbitration => false)
        port map (--
          sample_req => sample_req , 
          sample_ack => sample_ack , 
          update_req => update_req , 
          update_ack => update_ack , 
          data => data_in, 
          oreq => BAUD_CONTROL_WORD_VALID_pipe_write_req(0),
          oack => BAUD_CONTROL_WORD_VALID_pipe_write_ack(0),
          odata => BAUD_CONTROL_WORD_VALID_pipe_write_data(0 downto 0),
          clk => clk, reset => reset -- 
        );-- 
      -- 
    end Block; -- outport group 1
    -- shared call operator group (0) : call_stmt_164_call 
    my_gcd_call_group_0: Block -- 
      signal data_in: std_logic_vector(63 downto 0);
      signal data_out: std_logic_vector(31 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      reqL_unguarded(0) <= call_stmt_164_call_req_0;
      call_stmt_164_call_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= call_stmt_164_call_req_1;
      call_stmt_164_call_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      my_gcd_call_group_0_gI: SplitGuardInterface generic map(name => "my_gcd_call_group_0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL_unregulated,
        sa_in => ackL_unregulated,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      data_in <= SS_151 & BRx16_160;
      GCD_164 <= data_out(31 downto 0);
      CallReq: InputMuxWithBuffering -- 
        generic map (name => "InputMuxWithBuffering",
        iwidth => 64,
        owidth => 64,
        buffering => inBUFs,
        full_rate =>  false,
        twidth => 1,
        nreqs => 1,
        registered_output => false,
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          dataL => data_in, 
          reqR => my_gcd_call_reqs(0),
          ackR => my_gcd_call_acks(0),
          dataR => my_gcd_call_data(63 downto 0),
          tagR => my_gcd_call_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      CallComplete: OutputDemuxBaseWithBuffering -- 
        generic map ( -- 
          iwidth => 32,
          owidth => 32,
          detailed_buffering_per_output => outBUFs, 
          full_rate => false, 
          twidth => 1,
          name => "OutputDemuxBaseWithBuffering",
          nreqs => 1) -- 
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          reqL => my_gcd_return_acks(0), -- cross-over
          ackL => my_gcd_return_reqs(0), -- cross-over
          dataL => my_gcd_return_data(31 downto 0),
          tagL => my_gcd_return_tag(0 downto 0),
          clk => clk,
          reset => reset -- 
        ); -- 
      -- 
    end Block; -- call group 0
    -- shared call operator group (1) : call_stmt_168_call call_stmt_172_call 
    my_div_call_group_1: Block -- 
      signal data_in: std_logic_vector(127 downto 0);
      signal data_out: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 1 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 1 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 1 downto 0);
      signal guard_vector : std_logic_vector( 1 downto 0);
      constant inBUFs : IntegerArray(1 downto 0) := (1 => 1, 0 => 1);
      constant outBUFs : IntegerArray(1 downto 0) := (1 => 1, 0 => 1);
      constant guardFlags : BooleanArray(1 downto 0) := (0 => false, 1 => false);
      constant guardBuffering: IntegerArray(1 downto 0)  := (0 => 2, 1 => 2);
      -- 
    begin -- 
      reqL_unguarded(1) <= call_stmt_168_call_req_0;
      reqL_unguarded(0) <= call_stmt_172_call_req_0;
      call_stmt_168_call_ack_0 <= ackL_unguarded(1);
      call_stmt_172_call_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(1) <= call_stmt_168_call_req_1;
      reqR_unguarded(0) <= call_stmt_172_call_req_1;
      call_stmt_168_call_ack_1 <= ackR_unguarded(1);
      call_stmt_172_call_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      my_div_call_group_1_accessRegulator_0: access_regulator_base generic map (name => "my_div_call_group_1_accessRegulator_0", num_slots => 1) -- 
        port map (req => reqL_unregulated(0), -- 
          ack => ackL_unregulated(0),
          regulated_req => reqL(0),
          regulated_ack => ackL(0),
          release_req => reqR(0),
          release_ack => ackR(0),
          clk => clk, reset => reset); -- 
      my_div_call_group_1_accessRegulator_1: access_regulator_base generic map (name => "my_div_call_group_1_accessRegulator_1", num_slots => 1) -- 
        port map (req => reqL_unregulated(1), -- 
          ack => ackL_unregulated(1),
          regulated_req => reqL(1),
          regulated_ack => ackL(1),
          release_req => reqR(1),
          release_ack => ackR(1),
          clk => clk, reset => reset); -- 
      my_div_call_group_1_gI: SplitGuardInterface generic map(name => "my_div_call_group_1_gI", nreqs => 2, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL_unregulated,
        sa_in => ackL_unregulated,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      data_in <= BRx16_160 & GCD_164 & SS_151 & GCD_164;
      BF_168 <= data_out(63 downto 32);
      BLx_172 <= data_out(31 downto 0);
      CallReq: InputMuxWithBuffering -- 
        generic map (name => "InputMuxWithBuffering",
        iwidth => 128,
        owidth => 64,
        buffering => inBUFs,
        full_rate =>  false,
        twidth => 2,
        nreqs => 2,
        registered_output => false,
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          dataL => data_in, 
          reqR => my_div_call_reqs(0),
          ackR => my_div_call_acks(0),
          dataR => my_div_call_data(63 downto 0),
          tagR => my_div_call_tag(1 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      CallComplete: OutputDemuxBaseWithBuffering -- 
        generic map ( -- 
          iwidth => 32,
          owidth => 64,
          detailed_buffering_per_output => outBUFs, 
          full_rate => false, 
          twidth => 2,
          name => "OutputDemuxBaseWithBuffering",
          nreqs => 2) -- 
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          reqL => my_div_return_acks(0), -- cross-over
          ackL => my_div_return_reqs(0), -- cross-over
          dataL => my_div_return_data(31 downto 0),
          tagL => my_div_return_tag(1 downto 0),
          clk => clk,
          reset => reset -- 
        ); -- 
      -- 
    end Block; -- call group 1
    -- 
  end Block; -- data_path
  -- 
end baudControlCalculatorDaemon_arch;
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
library AjitCustom;
use AjitCustom.baud_control_calculator_global_package.all;
entity my_div is -- 
  generic (tag_length : integer); 
  port ( -- 
    A : in  std_logic_vector(31 downto 0);
    B : in  std_logic_vector(31 downto 0);
    Q : out  std_logic_vector(31 downto 0);
    tag_in: in std_logic_vector(tag_length-1 downto 0);
    tag_out: out std_logic_vector(tag_length-1 downto 0) ;
    clk : in std_logic;
    reset : in std_logic;
    start_req : in std_logic;
    start_ack : out std_logic;
    fin_req : in std_logic;
    fin_ack   : out std_logic-- 
  );
  -- 
end entity my_div;
architecture my_div_arch of my_div is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector((tag_length + 64)-1 downto 0);
  signal default_zero_sig: std_logic;
  signal in_buffer_write_req: std_logic;
  signal in_buffer_write_ack: std_logic;
  signal in_buffer_unload_req_symbol: Boolean;
  signal in_buffer_unload_ack_symbol: Boolean;
  signal out_buffer_data_in, out_buffer_data_out: std_logic_vector((tag_length + 32)-1 downto 0);
  signal out_buffer_read_req: std_logic;
  signal out_buffer_read_ack: std_logic;
  signal out_buffer_write_req_symbol: Boolean;
  signal out_buffer_write_ack_symbol: Boolean;
  signal tag_ub_out, tag_ilock_out: std_logic_vector(tag_length-1 downto 0);
  signal tag_push_req, tag_push_ack, tag_pop_req, tag_pop_ack: std_logic;
  signal tag_unload_req_symbol, tag_unload_ack_symbol, tag_write_req_symbol, tag_write_ack_symbol: Boolean;
  signal tag_ilock_write_req_symbol, tag_ilock_write_ack_symbol, tag_ilock_read_req_symbol, tag_ilock_read_ack_symbol: Boolean;
  signal start_req_sig, fin_req_sig, start_ack_sig, fin_ack_sig: std_logic; 
  signal input_sample_reenable_symbol: Boolean;
  -- input port buffer signals
  signal A_buffer :  std_logic_vector(31 downto 0);
  signal A_update_enable: Boolean;
  signal B_buffer :  std_logic_vector(31 downto 0);
  signal B_update_enable: Boolean;
  -- output port buffer signals
  signal Q_buffer :  std_logic_vector(31 downto 0);
  signal Q_update_enable: Boolean;
  signal my_div_CP_159_start: Boolean;
  signal my_div_CP_159_symbol: Boolean;
  -- volatile/operator module components. 
  -- links between control-path and data-path
  signal phi_stmt_89_ack_0 : boolean;
  signal W_Q_125_inst_req_0 : boolean;
  signal W_Q_125_inst_ack_0 : boolean;
  signal if_stmt_120_branch_req_0 : boolean;
  signal if_stmt_120_branch_ack_1 : boolean;
  signal if_stmt_120_branch_ack_0 : boolean;
  signal A_87_buf_req_0 : boolean;
  signal A_87_buf_ack_0 : boolean;
  signal A_87_buf_req_1 : boolean;
  signal A_87_buf_ack_1 : boolean;
  signal phi_stmt_85_req_0 : boolean;
  signal phi_stmt_89_req_0 : boolean;
  signal ntA_111_88_buf_req_0 : boolean;
  signal ntA_111_88_buf_ack_0 : boolean;
  signal ntA_111_88_buf_req_1 : boolean;
  signal ntA_111_88_buf_ack_1 : boolean;
  signal phi_stmt_85_req_1 : boolean;
  signal ntQ_119_93_buf_req_0 : boolean;
  signal ntQ_119_93_buf_ack_0 : boolean;
  signal ntQ_119_93_buf_req_1 : boolean;
  signal ntQ_119_93_buf_ack_1 : boolean;
  signal phi_stmt_89_req_1 : boolean;
  signal phi_stmt_85_ack_0 : boolean;
  signal W_Q_125_inst_req_1 : boolean;
  signal W_Q_125_inst_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "my_div_input_buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      data_width => tag_length + 64) -- 
    port map(write_req => in_buffer_write_req, -- 
      write_ack => in_buffer_write_ack, 
      write_data => in_buffer_data_in,
      unload_req => in_buffer_unload_req_symbol, 
      unload_ack => in_buffer_unload_ack_symbol, 
      read_data => in_buffer_data_out,
      clk => clk, reset => reset); -- 
  in_buffer_data_in(31 downto 0) <= A;
  A_buffer <= in_buffer_data_out(31 downto 0);
  in_buffer_data_in(63 downto 32) <= B;
  B_buffer <= in_buffer_data_out(63 downto 32);
  in_buffer_data_in(tag_length + 63 downto 64) <= tag_in;
  tag_ub_out <= in_buffer_data_out(tag_length + 63 downto 64);
  in_buffer_write_req <= start_req;
  start_ack <= in_buffer_write_ack;
  in_buffer_unload_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 32) := "in_buffer_unload_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= in_buffer_unload_ack_symbol & input_sample_reenable_symbol;
    gj_in_buffer_unload_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => in_buffer_unload_req_symbol, clk => clk, reset => reset); --
  end block;
  -- join of all unload_ack_symbols.. used to trigger CP.
  my_div_CP_159_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "my_div_out_buffer", -- 
      buffer_size => 1,
      full_rate => false,
      data_width => tag_length + 32) --
    port map(write_req => out_buffer_write_req_symbol, -- 
      write_ack => out_buffer_write_ack_symbol, 
      write_data => out_buffer_data_in,
      read_req => out_buffer_read_req, 
      read_ack => out_buffer_read_ack, 
      read_data => out_buffer_data_out,
      clk => clk, reset => reset); -- 
  out_buffer_data_in(31 downto 0) <= Q_buffer;
  Q <= out_buffer_data_out(31 downto 0);
  out_buffer_data_in(tag_length + 31 downto 32) <= tag_ilock_out;
  tag_out <= out_buffer_data_out(tag_length + 31 downto 32);
  out_buffer_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 0);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
    constant joinName: string(1 to 32) := "out_buffer_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= my_div_CP_159_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
    gj_out_buffer_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => out_buffer_write_req_symbol, clk => clk, reset => reset); --
  end block;
  -- write-to output-buffer produces  reenable input sampling
  input_sample_reenable_symbol <= out_buffer_write_ack_symbol;
  -- fin-req/ack level protocol..
  out_buffer_read_req <= fin_req;
  fin_ack <= out_buffer_read_ack;
  ----- tag-queue --------------------------------------------------
  -- interlock buffer for TAG.. to provide required buffering.
  tagIlock: InterlockBuffer -- 
    generic map(name => "tag-interlock-buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      in_data_width => tag_length,
      out_data_width => tag_length) -- 
    port map(write_req => tag_ilock_write_req_symbol, -- 
      write_ack => tag_ilock_write_ack_symbol, 
      write_data => tag_ub_out,
      read_req => tag_ilock_read_req_symbol, 
      read_ack => tag_ilock_read_ack_symbol, 
      read_data => tag_ilock_out, 
      clk => clk, reset => reset); -- 
  -- tag ilock-buffer control logic. 
  tag_ilock_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 31) := "tag_ilock_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= my_div_CP_159_start & tag_ilock_write_ack_symbol;
    gj_tag_ilock_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_write_req_symbol, clk => clk, reset => reset); --
  end block;
  tag_ilock_read_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
    constant joinName: string(1 to 30) := "tag_ilock_read_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= my_div_CP_159_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  my_div_CP_159: Block -- control-path 
    signal my_div_CP_159_elements: BooleanArray(22 downto 0);
    -- 
  begin -- 
    my_div_CP_159_elements(0) <= my_div_CP_159_start;
    my_div_CP_159_symbol <= my_div_CP_159_elements(22);
    -- CP-element group 0:  branch  transition  place  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	4 
    -- CP-element group 0:  members (5) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 branch_block_stmt_83/$entry
      -- CP-element group 0: 	 branch_block_stmt_83/branch_block_stmt_83__entry__
      -- CP-element group 0: 	 branch_block_stmt_83/merge_stmt_84__entry__
      -- CP-element group 0: 	 branch_block_stmt_83/merge_stmt_84_dead_link/$entry
      -- 
    -- CP-element group 1:  merge  branch  transition  place  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	20 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	2 
    -- CP-element group 1: 	3 
    -- CP-element group 1:  members (13) 
      -- CP-element group 1: 	 branch_block_stmt_83/merge_stmt_84__exit__
      -- CP-element group 1: 	 branch_block_stmt_83/assign_stmt_103_to_assign_stmt_119__entry__
      -- CP-element group 1: 	 branch_block_stmt_83/assign_stmt_103_to_assign_stmt_119__exit__
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120__entry__
      -- CP-element group 1: 	 branch_block_stmt_83/assign_stmt_103_to_assign_stmt_119/$entry
      -- CP-element group 1: 	 branch_block_stmt_83/assign_stmt_103_to_assign_stmt_119/$exit
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_dead_link/$entry
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_eval_test/$entry
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_eval_test/$exit
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_eval_test/branch_req
      -- CP-element group 1: 	 branch_block_stmt_83/R_continue_flag_121_place
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_if_link/$entry
      -- CP-element group 1: 	 branch_block_stmt_83/if_stmt_120_else_link/$entry
      -- 
    branch_req_183_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_183_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(1), ack => if_stmt_120_branch_req_0); -- 
    my_div_CP_159_elements(1) <= my_div_CP_159_elements(20);
    -- CP-element group 2:  fork  transition  place  input  output  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	1 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	11 
    -- CP-element group 2: 	14 
    -- CP-element group 2: 	10 
    -- CP-element group 2: 	13 
    -- CP-element group 2:  members (18) 
      -- CP-element group 2: 	 branch_block_stmt_83/if_stmt_120_if_link/$exit
      -- CP-element group 2: 	 branch_block_stmt_83/if_stmt_120_if_link/if_choice_transition
      -- CP-element group 2: 	 branch_block_stmt_83/loopback
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/req
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/req
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Sample/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Sample/req
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Update/$entry
      -- CP-element group 2: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Update/req
      -- 
    if_choice_transition_188_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_120_branch_ack_1, ack => my_div_CP_159_elements(2)); -- 
    req_244_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_244_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(2), ack => ntA_111_88_buf_req_0); -- 
    req_249_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_249_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(2), ack => ntA_111_88_buf_req_1); -- 
    req_264_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_264_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(2), ack => ntQ_119_93_buf_req_0); -- 
    req_269_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_269_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(2), ack => ntQ_119_93_buf_req_1); -- 
    -- CP-element group 3:  merge  fork  transition  place  input  output  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: 	1 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	21 
    -- CP-element group 3: 	22 
    -- CP-element group 3:  members (12) 
      -- CP-element group 3: 	 assign_stmt_127/$entry
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_sample_start_
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_update_start_
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_Sample/$entry
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_Sample/req
      -- CP-element group 3: 	 branch_block_stmt_83/$exit
      -- CP-element group 3: 	 branch_block_stmt_83/branch_block_stmt_83__exit__
      -- CP-element group 3: 	 branch_block_stmt_83/if_stmt_120__exit__
      -- CP-element group 3: 	 branch_block_stmt_83/if_stmt_120_else_link/$exit
      -- CP-element group 3: 	 branch_block_stmt_83/if_stmt_120_else_link/else_choice_transition
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_Update/$entry
      -- CP-element group 3: 	 assign_stmt_127/assign_stmt_127_Update/req
      -- 
    else_choice_transition_192_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 3_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_120_branch_ack_0, ack => my_div_CP_159_elements(3)); -- 
    req_288_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_288_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(3), ack => W_Q_125_inst_req_0); -- 
    req_293_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_293_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(3), ack => W_Q_125_inst_req_1); -- 
    -- CP-element group 4:  fork  transition  output  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	0 
    -- CP-element group 4: successors 
    -- CP-element group 4: 	8 
    -- CP-element group 4: 	5 
    -- CP-element group 4: 	6 
    -- CP-element group 4:  members (10) 
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/req
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/req
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/$entry
      -- CP-element group 4: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/phi_stmt_89_sources/$entry
      -- 
    req_218_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_218_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(4), ack => A_87_buf_req_1); -- 
    req_213_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_213_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(4), ack => A_87_buf_req_0); -- 
    my_div_CP_159_elements(4) <= my_div_CP_159_elements(0);
    -- CP-element group 5:  transition  input  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	4 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	7 
    -- CP-element group 5:  members (2) 
      -- CP-element group 5: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/$exit
      -- CP-element group 5: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/ack
      -- 
    ack_214_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => A_87_buf_ack_0, ack => my_div_CP_159_elements(5)); -- 
    -- CP-element group 6:  transition  input  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	4 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	7 
    -- CP-element group 6:  members (2) 
      -- CP-element group 6: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/$exit
      -- CP-element group 6: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/ack
      -- 
    ack_219_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 6_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => A_87_buf_ack_1, ack => my_div_CP_159_elements(6)); -- 
    -- CP-element group 7:  join  transition  output  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	5 
    -- CP-element group 7: 	6 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	9 
    -- CP-element group 7:  members (4) 
      -- CP-element group 7: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/$exit
      -- CP-element group 7: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/$exit
      -- CP-element group 7: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/$exit
      -- CP-element group 7: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_85/phi_stmt_85_req
      -- 
    phi_stmt_85_req_220_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_85_req_220_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(7), ack => phi_stmt_85_req_0); -- 
    my_div_cp_element_group_7: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 25) := "my_div_cp_element_group_7"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(5) & my_div_CP_159_elements(6);
      gj_my_div_cp_element_group_7 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(7), clk => clk, reset => reset); --
    end block;
    -- CP-element group 8:  transition  output  delay-element  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	4 
    -- CP-element group 8: successors 
    -- CP-element group 8: 	9 
    -- CP-element group 8:  members (4) 
      -- CP-element group 8: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/$exit
      -- CP-element group 8: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/phi_stmt_89_sources/$exit
      -- CP-element group 8: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/phi_stmt_89_sources/type_cast_92_konst_delay_trans
      -- CP-element group 8: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/phi_stmt_89/phi_stmt_89_req
      -- 
    phi_stmt_89_req_228_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_89_req_228_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(8), ack => phi_stmt_89_req_0); -- 
    -- Element group my_div_CP_159_elements(8) is a control-delay.
    cp_element_8_delay: control_delay_element  generic map(name => " 8_delay", delay_value => 1)  port map(req => my_div_CP_159_elements(4), ack => my_div_CP_159_elements(8), clk => clk, reset =>reset);
    -- CP-element group 9:  join  transition  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	8 
    -- CP-element group 9: 	7 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	17 
    -- CP-element group 9:  members (1) 
      -- CP-element group 9: 	 branch_block_stmt_83/merge_stmt_84__entry___PhiReq/$exit
      -- 
    my_div_cp_element_group_9: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 25) := "my_div_cp_element_group_9"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(8) & my_div_CP_159_elements(7);
      gj_my_div_cp_element_group_9 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(9), clk => clk, reset => reset); --
    end block;
    -- CP-element group 10:  transition  input  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	2 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	12 
    -- CP-element group 10:  members (2) 
      -- CP-element group 10: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/$exit
      -- CP-element group 10: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Sample/ack
      -- 
    ack_245_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntA_111_88_buf_ack_0, ack => my_div_CP_159_elements(10)); -- 
    -- CP-element group 11:  transition  input  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	2 
    -- CP-element group 11: successors 
    -- CP-element group 11: 	12 
    -- CP-element group 11:  members (2) 
      -- CP-element group 11: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/$exit
      -- CP-element group 11: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/Update/ack
      -- 
    ack_250_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntA_111_88_buf_ack_1, ack => my_div_CP_159_elements(11)); -- 
    -- CP-element group 12:  join  transition  output  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	11 
    -- CP-element group 12: 	10 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	16 
    -- CP-element group 12:  members (4) 
      -- CP-element group 12: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/$exit
      -- CP-element group 12: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/$exit
      -- CP-element group 12: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_sources/Interlock/$exit
      -- CP-element group 12: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_85/phi_stmt_85_req
      -- 
    phi_stmt_85_req_251_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_85_req_251_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(12), ack => phi_stmt_85_req_1); -- 
    my_div_cp_element_group_12: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_div_cp_element_group_12"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(11) & my_div_CP_159_elements(10);
      gj_my_div_cp_element_group_12 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(12), clk => clk, reset => reset); --
    end block;
    -- CP-element group 13:  transition  input  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	2 
    -- CP-element group 13: successors 
    -- CP-element group 13: 	15 
    -- CP-element group 13:  members (2) 
      -- CP-element group 13: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Sample/$exit
      -- CP-element group 13: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Sample/ack
      -- 
    ack_265_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntQ_119_93_buf_ack_0, ack => my_div_CP_159_elements(13)); -- 
    -- CP-element group 14:  transition  input  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	2 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14:  members (2) 
      -- CP-element group 14: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Update/$exit
      -- CP-element group 14: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/Update/ack
      -- 
    ack_270_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntQ_119_93_buf_ack_1, ack => my_div_CP_159_elements(14)); -- 
    -- CP-element group 15:  join  transition  output  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: 	13 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	16 
    -- CP-element group 15:  members (4) 
      -- CP-element group 15: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/$exit
      -- CP-element group 15: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/$exit
      -- CP-element group 15: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_sources/Interlock/$exit
      -- CP-element group 15: 	 branch_block_stmt_83/loopback_PhiReq/phi_stmt_89/phi_stmt_89_req
      -- 
    phi_stmt_89_req_271_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_89_req_271_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_div_CP_159_elements(15), ack => phi_stmt_89_req_1); -- 
    my_div_cp_element_group_15: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_div_cp_element_group_15"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(14) & my_div_CP_159_elements(13);
      gj_my_div_cp_element_group_15 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(15), clk => clk, reset => reset); --
    end block;
    -- CP-element group 16:  join  transition  bypass 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	15 
    -- CP-element group 16: 	12 
    -- CP-element group 16: successors 
    -- CP-element group 16: 	17 
    -- CP-element group 16:  members (1) 
      -- CP-element group 16: 	 branch_block_stmt_83/loopback_PhiReq/$exit
      -- 
    my_div_cp_element_group_16: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_div_cp_element_group_16"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(15) & my_div_CP_159_elements(12);
      gj_my_div_cp_element_group_16 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(16), clk => clk, reset => reset); --
    end block;
    -- CP-element group 17:  merge  fork  transition  place  bypass 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: 	9 
    -- CP-element group 17: 	16 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	19 
    -- CP-element group 17: 	18 
    -- CP-element group 17:  members (2) 
      -- CP-element group 17: 	 branch_block_stmt_83/merge_stmt_84_PhiReqMerge
      -- CP-element group 17: 	 branch_block_stmt_83/merge_stmt_84_PhiAck/$entry
      -- 
    my_div_CP_159_elements(17) <= OrReduce(my_div_CP_159_elements(9) & my_div_CP_159_elements(16));
    -- CP-element group 18:  transition  input  bypass 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	17 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	20 
    -- CP-element group 18:  members (1) 
      -- CP-element group 18: 	 branch_block_stmt_83/merge_stmt_84_PhiAck/phi_stmt_85_ack
      -- 
    phi_stmt_85_ack_276_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 18_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_85_ack_0, ack => my_div_CP_159_elements(18)); -- 
    -- CP-element group 19:  transition  input  bypass 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	17 
    -- CP-element group 19: successors 
    -- CP-element group 19: 	20 
    -- CP-element group 19:  members (1) 
      -- CP-element group 19: 	 branch_block_stmt_83/merge_stmt_84_PhiAck/phi_stmt_89_ack
      -- 
    phi_stmt_89_ack_277_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 19_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_89_ack_0, ack => my_div_CP_159_elements(19)); -- 
    -- CP-element group 20:  join  transition  bypass 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	19 
    -- CP-element group 20: 	18 
    -- CP-element group 20: successors 
    -- CP-element group 20: 	1 
    -- CP-element group 20:  members (1) 
      -- CP-element group 20: 	 branch_block_stmt_83/merge_stmt_84_PhiAck/$exit
      -- 
    my_div_cp_element_group_20: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_div_cp_element_group_20"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_div_CP_159_elements(19) & my_div_CP_159_elements(18);
      gj_my_div_cp_element_group_20 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_div_CP_159_elements(20), clk => clk, reset => reset); --
    end block;
    -- CP-element group 21:  transition  input  bypass 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	3 
    -- CP-element group 21: successors 
    -- CP-element group 21:  members (3) 
      -- CP-element group 21: 	 assign_stmt_127/assign_stmt_127_sample_completed_
      -- CP-element group 21: 	 assign_stmt_127/assign_stmt_127_Sample/$exit
      -- CP-element group 21: 	 assign_stmt_127/assign_stmt_127_Sample/ack
      -- 
    ack_289_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 21_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_Q_125_inst_ack_0, ack => my_div_CP_159_elements(21)); -- 
    -- CP-element group 22:  transition  input  bypass 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	3 
    -- CP-element group 22: successors 
    -- CP-element group 22:  members (5) 
      -- CP-element group 22: 	 assign_stmt_127/$exit
      -- CP-element group 22: 	 assign_stmt_127/assign_stmt_127_update_completed_
      -- CP-element group 22: 	 $exit
      -- CP-element group 22: 	 assign_stmt_127/assign_stmt_127_Update/$exit
      -- CP-element group 22: 	 assign_stmt_127/assign_stmt_127_Update/ack
      -- 
    ack_294_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 22_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_Q_125_inst_ack_1, ack => my_div_CP_159_elements(22)); -- 
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal ADD_u32_u32_116_wire : std_logic_vector(31 downto 0);
    signal A_87_buffered : std_logic_vector(31 downto 0);
    signal NEQ_u32_u1_98_wire : std_logic_vector(0 downto 0);
    signal SUB_u32_u32_108_wire : std_logic_vector(31 downto 0);
    signal UGE_u32_u1_101_wire : std_logic_vector(0 downto 0);
    signal continue_flag_103 : std_logic_vector(0 downto 0);
    signal konst_115_wire_constant : std_logic_vector(31 downto 0);
    signal konst_97_wire_constant : std_logic_vector(31 downto 0);
    signal ntA_111 : std_logic_vector(31 downto 0);
    signal ntA_111_88_buffered : std_logic_vector(31 downto 0);
    signal ntQ_119 : std_logic_vector(31 downto 0);
    signal ntQ_119_93_buffered : std_logic_vector(31 downto 0);
    signal tA_85 : std_logic_vector(31 downto 0);
    signal tQ_89 : std_logic_vector(31 downto 0);
    signal type_cast_92_wire_constant : std_logic_vector(31 downto 0);
    -- 
  begin -- 
    konst_115_wire_constant <= "00000000000000000000000000000001";
    konst_97_wire_constant <= "00000000000000000000000000000000";
    type_cast_92_wire_constant <= "00000000000000000000000000000000";
    phi_stmt_85: Block -- phi operator 
      signal idata: std_logic_vector(63 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= A_87_buffered & ntA_111_88_buffered;
      req <= phi_stmt_85_req_0 & phi_stmt_85_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_85",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 32) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_85_ack_0,
          idata => idata,
          odata => tA_85,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_85
    phi_stmt_89: Block -- phi operator 
      signal idata: std_logic_vector(63 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= type_cast_92_wire_constant & ntQ_119_93_buffered;
      req <= phi_stmt_89_req_0 & phi_stmt_89_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_89",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 32) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_89_ack_0,
          idata => idata,
          odata => tQ_89,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_89
    -- flow-through select operator MUX_110_inst
    ntA_111 <= SUB_u32_u32_108_wire when (continue_flag_103(0) /=  '0') else tA_85;
    -- flow-through select operator MUX_118_inst
    ntQ_119 <= ADD_u32_u32_116_wire when (continue_flag_103(0) /=  '0') else tQ_89;
    A_87_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= A_87_buf_req_0;
      A_87_buf_ack_0<= wack(0);
      rreq(0) <= A_87_buf_req_1;
      A_87_buf_ack_1<= rack(0);
      A_87_buf : InterlockBuffer generic map ( -- 
        name => "A_87_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => A_buffer,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => A_87_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_Q_125_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_Q_125_inst_req_0;
      W_Q_125_inst_ack_0<= wack(0);
      rreq(0) <= W_Q_125_inst_req_1;
      W_Q_125_inst_ack_1<= rack(0);
      W_Q_125_inst : InterlockBuffer generic map ( -- 
        name => "W_Q_125_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => tQ_89,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => Q_buffer,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    ntA_111_88_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= ntA_111_88_buf_req_0;
      ntA_111_88_buf_ack_0<= wack(0);
      rreq(0) <= ntA_111_88_buf_req_1;
      ntA_111_88_buf_ack_1<= rack(0);
      ntA_111_88_buf : InterlockBuffer generic map ( -- 
        name => "ntA_111_88_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => ntA_111,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ntA_111_88_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    ntQ_119_93_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= ntQ_119_93_buf_req_0;
      ntQ_119_93_buf_ack_0<= wack(0);
      rreq(0) <= ntQ_119_93_buf_req_1;
      ntQ_119_93_buf_ack_1<= rack(0);
      ntQ_119_93_buf : InterlockBuffer generic map ( -- 
        name => "ntQ_119_93_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => ntQ_119,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ntQ_119_93_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    if_stmt_120_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= continue_flag_103;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_120_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_120_branch_req_0,
          ack0 => if_stmt_120_branch_ack_0,
          ack1 => if_stmt_120_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator ADD_u32_u32_116_inst
    process(tQ_89) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntAdd_proc(tQ_89, konst_115_wire_constant, tmp_var);
      ADD_u32_u32_116_wire <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_102_inst
    process(NEQ_u32_u1_98_wire, UGE_u32_u1_101_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NEQ_u32_u1_98_wire, UGE_u32_u1_101_wire, tmp_var);
      continue_flag_103 <= tmp_var; --
    end process;
    -- binary operator NEQ_u32_u1_98_inst
    process(tA_85) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntNe_proc(tA_85, konst_97_wire_constant, tmp_var);
      NEQ_u32_u1_98_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u32_u32_108_inst
    process(tA_85, B_buffer) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntSub_proc(tA_85, B_buffer, tmp_var);
      SUB_u32_u32_108_wire <= tmp_var; --
    end process;
    -- binary operator UGE_u32_u1_101_inst
    process(tA_85, B_buffer) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUge_proc(tA_85, B_buffer, tmp_var);
      UGE_u32_u1_101_wire <= tmp_var; --
    end process;
    -- 
  end Block; -- data_path
  -- 
end my_div_arch;
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
library AjitCustom;
use AjitCustom.baud_control_calculator_global_package.all;
entity my_gcd is -- 
  generic (tag_length : integer); 
  port ( -- 
    A : in  std_logic_vector(31 downto 0);
    B : in  std_logic_vector(31 downto 0);
    GCD : out  std_logic_vector(31 downto 0);
    tag_in: in std_logic_vector(tag_length-1 downto 0);
    tag_out: out std_logic_vector(tag_length-1 downto 0) ;
    clk : in std_logic;
    reset : in std_logic;
    start_req : in std_logic;
    start_ack : out std_logic;
    fin_req : in std_logic;
    fin_ack   : out std_logic-- 
  );
  -- 
end entity my_gcd;
architecture my_gcd_arch of my_gcd is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector((tag_length + 64)-1 downto 0);
  signal default_zero_sig: std_logic;
  signal in_buffer_write_req: std_logic;
  signal in_buffer_write_ack: std_logic;
  signal in_buffer_unload_req_symbol: Boolean;
  signal in_buffer_unload_ack_symbol: Boolean;
  signal out_buffer_data_in, out_buffer_data_out: std_logic_vector((tag_length + 32)-1 downto 0);
  signal out_buffer_read_req: std_logic;
  signal out_buffer_read_ack: std_logic;
  signal out_buffer_write_req_symbol: Boolean;
  signal out_buffer_write_ack_symbol: Boolean;
  signal tag_ub_out, tag_ilock_out: std_logic_vector(tag_length-1 downto 0);
  signal tag_push_req, tag_push_ack, tag_pop_req, tag_pop_ack: std_logic;
  signal tag_unload_req_symbol, tag_unload_ack_symbol, tag_write_req_symbol, tag_write_ack_symbol: Boolean;
  signal tag_ilock_write_req_symbol, tag_ilock_write_ack_symbol, tag_ilock_read_req_symbol, tag_ilock_read_ack_symbol: Boolean;
  signal start_req_sig, fin_req_sig, start_ack_sig, fin_ack_sig: std_logic; 
  signal input_sample_reenable_symbol: Boolean;
  -- input port buffer signals
  signal A_buffer :  std_logic_vector(31 downto 0);
  signal A_update_enable: Boolean;
  signal B_buffer :  std_logic_vector(31 downto 0);
  signal B_update_enable: Boolean;
  -- output port buffer signals
  signal GCD_buffer :  std_logic_vector(31 downto 0);
  signal GCD_update_enable: Boolean;
  signal my_gcd_CP_0_start: Boolean;
  signal my_gcd_CP_0_symbol: Boolean;
  -- volatile/operator module components. 
  -- links between control-path and data-path
  signal AND_u1_u1_33_inst_req_0 : boolean;
  signal MUX_51_inst_req_0 : boolean;
  signal MUX_51_inst_ack_0 : boolean;
  signal MUX_51_inst_req_1 : boolean;
  signal MUX_51_inst_ack_1 : boolean;
  signal AND_u1_u1_33_inst_ack_0 : boolean;
  signal AND_u1_u1_33_inst_req_1 : boolean;
  signal AND_u1_u1_33_inst_ack_1 : boolean;
  signal ntA_62_16_buf_req_0 : boolean;
  signal ntA_62_16_buf_ack_0 : boolean;
  signal if_stmt_73_branch_req_0 : boolean;
  signal if_stmt_73_branch_ack_1 : boolean;
  signal if_stmt_73_branch_ack_0 : boolean;
  signal A_15_buf_req_0 : boolean;
  signal A_15_buf_ack_0 : boolean;
  signal A_15_buf_req_1 : boolean;
  signal A_15_buf_ack_1 : boolean;
  signal phi_stmt_13_req_0 : boolean;
  signal B_19_buf_req_0 : boolean;
  signal B_19_buf_ack_0 : boolean;
  signal B_19_buf_req_1 : boolean;
  signal B_19_buf_ack_1 : boolean;
  signal phi_stmt_17_req_0 : boolean;
  signal ntA_62_16_buf_req_1 : boolean;
  signal ntA_62_16_buf_ack_1 : boolean;
  signal phi_stmt_13_req_1 : boolean;
  signal ntB_72_20_buf_req_0 : boolean;
  signal ntB_72_20_buf_ack_0 : boolean;
  signal ntB_72_20_buf_req_1 : boolean;
  signal ntB_72_20_buf_ack_1 : boolean;
  signal phi_stmt_17_req_1 : boolean;
  signal phi_stmt_13_ack_0 : boolean;
  signal phi_stmt_17_ack_0 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "my_gcd_input_buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      data_width => tag_length + 64) -- 
    port map(write_req => in_buffer_write_req, -- 
      write_ack => in_buffer_write_ack, 
      write_data => in_buffer_data_in,
      unload_req => in_buffer_unload_req_symbol, 
      unload_ack => in_buffer_unload_ack_symbol, 
      read_data => in_buffer_data_out,
      clk => clk, reset => reset); -- 
  in_buffer_data_in(31 downto 0) <= A;
  A_buffer <= in_buffer_data_out(31 downto 0);
  in_buffer_data_in(63 downto 32) <= B;
  B_buffer <= in_buffer_data_out(63 downto 32);
  in_buffer_data_in(tag_length + 63 downto 64) <= tag_in;
  tag_ub_out <= in_buffer_data_out(tag_length + 63 downto 64);
  in_buffer_write_req <= start_req;
  start_ack <= in_buffer_write_ack;
  in_buffer_unload_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 32) := "in_buffer_unload_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= in_buffer_unload_ack_symbol & input_sample_reenable_symbol;
    gj_in_buffer_unload_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => in_buffer_unload_req_symbol, clk => clk, reset => reset); --
  end block;
  -- join of all unload_ack_symbols.. used to trigger CP.
  my_gcd_CP_0_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "my_gcd_out_buffer", -- 
      buffer_size => 1,
      full_rate => false,
      data_width => tag_length + 32) --
    port map(write_req => out_buffer_write_req_symbol, -- 
      write_ack => out_buffer_write_ack_symbol, 
      write_data => out_buffer_data_in,
      read_req => out_buffer_read_req, 
      read_ack => out_buffer_read_ack, 
      read_data => out_buffer_data_out,
      clk => clk, reset => reset); -- 
  out_buffer_data_in(31 downto 0) <= GCD_buffer;
  GCD <= out_buffer_data_out(31 downto 0);
  out_buffer_data_in(tag_length + 31 downto 32) <= tag_ilock_out;
  tag_out <= out_buffer_data_out(tag_length + 31 downto 32);
  out_buffer_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 0);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
    constant joinName: string(1 to 32) := "out_buffer_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= my_gcd_CP_0_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
    gj_out_buffer_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => out_buffer_write_req_symbol, clk => clk, reset => reset); --
  end block;
  -- write-to output-buffer produces  reenable input sampling
  input_sample_reenable_symbol <= out_buffer_write_ack_symbol;
  -- fin-req/ack level protocol..
  out_buffer_read_req <= fin_req;
  fin_ack <= out_buffer_read_ack;
  ----- tag-queue --------------------------------------------------
  -- interlock buffer for TAG.. to provide required buffering.
  tagIlock: InterlockBuffer -- 
    generic map(name => "tag-interlock-buffer", -- 
      buffer_size => 1,
      bypass_flag => false,
      in_data_width => tag_length,
      out_data_width => tag_length) -- 
    port map(write_req => tag_ilock_write_req_symbol, -- 
      write_ack => tag_ilock_write_ack_symbol, 
      write_data => tag_ub_out,
      read_req => tag_ilock_read_req_symbol, 
      read_ack => tag_ilock_read_ack_symbol, 
      read_data => tag_ilock_out, 
      clk => clk, reset => reset); -- 
  -- tag ilock-buffer control logic. 
  tag_ilock_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
    constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
    constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
    constant joinName: string(1 to 31) := "tag_ilock_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 2); -- 
  begin -- 
    preds <= my_gcd_CP_0_start & tag_ilock_write_ack_symbol;
    gj_tag_ilock_write_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_write_req_symbol, clk => clk, reset => reset); --
  end block;
  tag_ilock_read_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
    constant joinName: string(1 to 30) := "tag_ilock_read_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= my_gcd_CP_0_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  my_gcd_CP_0: Block -- control-path 
    signal my_gcd_CP_0_elements: BooleanArray(27 downto 0);
    -- 
  begin -- 
    my_gcd_CP_0_elements(0) <= my_gcd_CP_0_start;
    my_gcd_CP_0_symbol <= my_gcd_CP_0_elements(8);
    -- CP-element group 0:  branch  transition  place  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	9 
    -- CP-element group 0:  members (5) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 branch_block_stmt_11/$entry
      -- CP-element group 0: 	 branch_block_stmt_11/branch_block_stmt_11__entry__
      -- CP-element group 0: 	 branch_block_stmt_11/merge_stmt_12__entry__
      -- CP-element group 0: 	 branch_block_stmt_11/merge_stmt_12_dead_link/$entry
      -- 
    -- CP-element group 1:  merge  fork  transition  place  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	27 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	5 
    -- CP-element group 1: 	2 
    -- CP-element group 1: 	4 
    -- CP-element group 1: 	3 
    -- CP-element group 1:  members (15) 
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_update_start_
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_sample_start_
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Sample/$entry
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Sample/rr
      -- CP-element group 1: 	 branch_block_stmt_11/merge_stmt_12__exit__
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72__entry__
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/$entry
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_sample_start_
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_update_start_
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_start/$entry
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_start/req
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_complete/$entry
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_complete/req
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Update/$entry
      -- CP-element group 1: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Update/cr
      -- 
    rr_24_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_24_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(1), ack => AND_u1_u1_33_inst_req_0); -- 
    req_38_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_38_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(1), ack => MUX_51_inst_req_0); -- 
    req_43_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_43_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(1), ack => MUX_51_inst_req_1); -- 
    cr_29_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_29_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(1), ack => AND_u1_u1_33_inst_req_1); -- 
    my_gcd_CP_0_elements(1) <= my_gcd_CP_0_elements(27);
    -- CP-element group 2:  transition  input  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	1 
    -- CP-element group 2: successors 
    -- CP-element group 2:  members (3) 
      -- CP-element group 2: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_sample_completed_
      -- CP-element group 2: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Sample/$exit
      -- CP-element group 2: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Sample/ra
      -- 
    ra_25_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => AND_u1_u1_33_inst_ack_0, ack => my_gcd_CP_0_elements(2)); -- 
    -- CP-element group 3:  transition  input  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: 	1 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	6 
    -- CP-element group 3:  members (3) 
      -- CP-element group 3: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_update_completed_
      -- CP-element group 3: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Update/$exit
      -- CP-element group 3: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/AND_u1_u1_33_Update/ca
      -- 
    ca_30_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 3_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => AND_u1_u1_33_inst_ack_1, ack => my_gcd_CP_0_elements(3)); -- 
    -- CP-element group 4:  transition  input  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	1 
    -- CP-element group 4: successors 
    -- CP-element group 4:  members (3) 
      -- CP-element group 4: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_sample_completed_
      -- CP-element group 4: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_start/$exit
      -- CP-element group 4: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_start/ack
      -- 
    ack_39_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 4_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_51_inst_ack_0, ack => my_gcd_CP_0_elements(4)); -- 
    -- CP-element group 5:  transition  input  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	1 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	6 
    -- CP-element group 5:  members (3) 
      -- CP-element group 5: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_update_completed_
      -- CP-element group 5: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_complete/$exit
      -- CP-element group 5: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/MUX_51_complete/ack
      -- 
    ack_44_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_51_inst_ack_1, ack => my_gcd_CP_0_elements(5)); -- 
    -- CP-element group 6:  branch  join  transition  place  output  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	5 
    -- CP-element group 6: 	3 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	7 
    -- CP-element group 6: 	8 
    -- CP-element group 6:  members (10) 
      -- CP-element group 6: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72__exit__
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73__entry__
      -- CP-element group 6: 	 branch_block_stmt_11/assign_stmt_34_to_assign_stmt_72/$exit
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_dead_link/$entry
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_eval_test/$entry
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_eval_test/$exit
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_eval_test/branch_req
      -- CP-element group 6: 	 branch_block_stmt_11/R_continue_flag_74_place
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_if_link/$entry
      -- CP-element group 6: 	 branch_block_stmt_11/if_stmt_73_else_link/$entry
      -- 
    branch_req_52_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_52_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(6), ack => if_stmt_73_branch_req_0); -- 
    my_gcd_cp_element_group_6: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 25) := "my_gcd_cp_element_group_6"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(5) & my_gcd_CP_0_elements(3);
      gj_my_gcd_cp_element_group_6 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(6), clk => clk, reset => reset); --
    end block;
    -- CP-element group 7:  fork  transition  place  input  output  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	6 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	20 
    -- CP-element group 7: 	17 
    -- CP-element group 7: 	18 
    -- CP-element group 7: 	21 
    -- CP-element group 7:  members (18) 
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/req
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/if_stmt_73_if_link/$exit
      -- CP-element group 7: 	 branch_block_stmt_11/if_stmt_73_if_link/if_choice_transition
      -- CP-element group 7: 	 branch_block_stmt_11/loopback
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/req
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/req
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/$entry
      -- CP-element group 7: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/req
      -- 
    if_choice_transition_57_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 7_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_73_branch_ack_1, ack => my_gcd_CP_0_elements(7)); -- 
    req_125_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_125_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(7), ack => ntA_62_16_buf_req_0); -- 
    req_130_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_130_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(7), ack => ntA_62_16_buf_req_1); -- 
    req_145_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_145_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(7), ack => ntB_72_20_buf_req_0); -- 
    req_150_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_150_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(7), ack => ntB_72_20_buf_req_1); -- 
    -- CP-element group 8:  merge  transition  place  input  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	6 
    -- CP-element group 8: successors 
    -- CP-element group 8:  members (6) 
      -- CP-element group 8: 	 $exit
      -- CP-element group 8: 	 branch_block_stmt_11/$exit
      -- CP-element group 8: 	 branch_block_stmt_11/branch_block_stmt_11__exit__
      -- CP-element group 8: 	 branch_block_stmt_11/if_stmt_73__exit__
      -- CP-element group 8: 	 branch_block_stmt_11/if_stmt_73_else_link/$exit
      -- CP-element group 8: 	 branch_block_stmt_11/if_stmt_73_else_link/else_choice_transition
      -- 
    else_choice_transition_61_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 8_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_73_branch_ack_0, ack => my_gcd_CP_0_elements(8)); -- 
    -- CP-element group 9:  fork  transition  output  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	0 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	10 
    -- CP-element group 9: 	14 
    -- CP-element group 9: 	11 
    -- CP-element group 9: 	13 
    -- CP-element group 9:  members (15) 
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/req
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/req
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/req
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/$entry
      -- CP-element group 9: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/req
      -- 
    req_107_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_107_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(9), ack => B_19_buf_req_1); -- 
    req_102_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_102_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(9), ack => B_19_buf_req_0); -- 
    req_87_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_87_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(9), ack => A_15_buf_req_1); -- 
    req_82_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_82_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(9), ack => A_15_buf_req_0); -- 
    my_gcd_CP_0_elements(9) <= my_gcd_CP_0_elements(0);
    -- CP-element group 10:  transition  input  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	9 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	12 
    -- CP-element group 10:  members (2) 
      -- CP-element group 10: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/$exit
      -- CP-element group 10: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/ack
      -- 
    ack_83_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => A_15_buf_ack_0, ack => my_gcd_CP_0_elements(10)); -- 
    -- CP-element group 11:  transition  input  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	9 
    -- CP-element group 11: successors 
    -- CP-element group 11: 	12 
    -- CP-element group 11:  members (2) 
      -- CP-element group 11: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/$exit
      -- CP-element group 11: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/ack
      -- 
    ack_88_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => A_15_buf_ack_1, ack => my_gcd_CP_0_elements(11)); -- 
    -- CP-element group 12:  join  transition  output  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	10 
    -- CP-element group 12: 	11 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	16 
    -- CP-element group 12:  members (4) 
      -- CP-element group 12: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/$exit
      -- CP-element group 12: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/$exit
      -- CP-element group 12: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/$exit
      -- CP-element group 12: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_13/phi_stmt_13_req
      -- 
    phi_stmt_13_req_89_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_13_req_89_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(12), ack => phi_stmt_13_req_0); -- 
    my_gcd_cp_element_group_12: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_12"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(10) & my_gcd_CP_0_elements(11);
      gj_my_gcd_cp_element_group_12 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(12), clk => clk, reset => reset); --
    end block;
    -- CP-element group 13:  transition  input  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	9 
    -- CP-element group 13: successors 
    -- CP-element group 13: 	15 
    -- CP-element group 13:  members (2) 
      -- CP-element group 13: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/$exit
      -- CP-element group 13: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/ack
      -- 
    ack_103_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => B_19_buf_ack_0, ack => my_gcd_CP_0_elements(13)); -- 
    -- CP-element group 14:  transition  input  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	9 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14:  members (2) 
      -- CP-element group 14: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/$exit
      -- CP-element group 14: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/ack
      -- 
    ack_108_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => B_19_buf_ack_1, ack => my_gcd_CP_0_elements(14)); -- 
    -- CP-element group 15:  join  transition  output  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: 	13 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	16 
    -- CP-element group 15:  members (4) 
      -- CP-element group 15: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/$exit
      -- CP-element group 15: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/$exit
      -- CP-element group 15: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/$exit
      -- CP-element group 15: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/phi_stmt_17/phi_stmt_17_req
      -- 
    phi_stmt_17_req_109_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_17_req_109_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(15), ack => phi_stmt_17_req_0); -- 
    my_gcd_cp_element_group_15: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_15"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(14) & my_gcd_CP_0_elements(13);
      gj_my_gcd_cp_element_group_15 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(15), clk => clk, reset => reset); --
    end block;
    -- CP-element group 16:  join  transition  bypass 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	15 
    -- CP-element group 16: 	12 
    -- CP-element group 16: successors 
    -- CP-element group 16: 	24 
    -- CP-element group 16:  members (1) 
      -- CP-element group 16: 	 branch_block_stmt_11/merge_stmt_12__entry___PhiReq/$exit
      -- 
    my_gcd_cp_element_group_16: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_16"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(15) & my_gcd_CP_0_elements(12);
      gj_my_gcd_cp_element_group_16 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(16), clk => clk, reset => reset); --
    end block;
    -- CP-element group 17:  transition  input  bypass 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: 	7 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	19 
    -- CP-element group 17:  members (2) 
      -- CP-element group 17: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/ack
      -- CP-element group 17: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Sample/$exit
      -- 
    ack_126_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 17_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntA_62_16_buf_ack_0, ack => my_gcd_CP_0_elements(17)); -- 
    -- CP-element group 18:  transition  input  bypass 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	7 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	19 
    -- CP-element group 18:  members (2) 
      -- CP-element group 18: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/$exit
      -- CP-element group 18: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/Update/ack
      -- 
    ack_131_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 18_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntA_62_16_buf_ack_1, ack => my_gcd_CP_0_elements(18)); -- 
    -- CP-element group 19:  join  transition  output  bypass 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	17 
    -- CP-element group 19: 	18 
    -- CP-element group 19: successors 
    -- CP-element group 19: 	23 
    -- CP-element group 19:  members (4) 
      -- CP-element group 19: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/$exit
      -- CP-element group 19: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/$exit
      -- CP-element group 19: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_sources/Interlock/$exit
      -- CP-element group 19: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_13/phi_stmt_13_req
      -- 
    phi_stmt_13_req_132_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_13_req_132_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(19), ack => phi_stmt_13_req_1); -- 
    my_gcd_cp_element_group_19: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_19"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(17) & my_gcd_CP_0_elements(18);
      gj_my_gcd_cp_element_group_19 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(19), clk => clk, reset => reset); --
    end block;
    -- CP-element group 20:  transition  input  bypass 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	7 
    -- CP-element group 20: successors 
    -- CP-element group 20: 	22 
    -- CP-element group 20:  members (2) 
      -- CP-element group 20: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/$exit
      -- CP-element group 20: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Sample/ack
      -- 
    ack_146_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 20_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntB_72_20_buf_ack_0, ack => my_gcd_CP_0_elements(20)); -- 
    -- CP-element group 21:  transition  input  bypass 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	7 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	22 
    -- CP-element group 21:  members (2) 
      -- CP-element group 21: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/$exit
      -- CP-element group 21: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/Update/ack
      -- 
    ack_151_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 21_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ntB_72_20_buf_ack_1, ack => my_gcd_CP_0_elements(21)); -- 
    -- CP-element group 22:  join  transition  output  bypass 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	20 
    -- CP-element group 22: 	21 
    -- CP-element group 22: successors 
    -- CP-element group 22: 	23 
    -- CP-element group 22:  members (4) 
      -- CP-element group 22: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/$exit
      -- CP-element group 22: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/$exit
      -- CP-element group 22: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_sources/Interlock/$exit
      -- CP-element group 22: 	 branch_block_stmt_11/loopback_PhiReq/phi_stmt_17/phi_stmt_17_req
      -- 
    phi_stmt_17_req_152_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_17_req_152_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => my_gcd_CP_0_elements(22), ack => phi_stmt_17_req_1); -- 
    my_gcd_cp_element_group_22: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_22"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(20) & my_gcd_CP_0_elements(21);
      gj_my_gcd_cp_element_group_22 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(22), clk => clk, reset => reset); --
    end block;
    -- CP-element group 23:  join  transition  bypass 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: 	19 
    -- CP-element group 23: 	22 
    -- CP-element group 23: successors 
    -- CP-element group 23: 	24 
    -- CP-element group 23:  members (1) 
      -- CP-element group 23: 	 branch_block_stmt_11/loopback_PhiReq/$exit
      -- 
    my_gcd_cp_element_group_23: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_23"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(19) & my_gcd_CP_0_elements(22);
      gj_my_gcd_cp_element_group_23 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(23), clk => clk, reset => reset); --
    end block;
    -- CP-element group 24:  merge  fork  transition  place  bypass 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	23 
    -- CP-element group 24: 	16 
    -- CP-element group 24: successors 
    -- CP-element group 24: 	26 
    -- CP-element group 24: 	25 
    -- CP-element group 24:  members (2) 
      -- CP-element group 24: 	 branch_block_stmt_11/merge_stmt_12_PhiReqMerge
      -- CP-element group 24: 	 branch_block_stmt_11/merge_stmt_12_PhiAck/$entry
      -- 
    my_gcd_CP_0_elements(24) <= OrReduce(my_gcd_CP_0_elements(23) & my_gcd_CP_0_elements(16));
    -- CP-element group 25:  transition  input  bypass 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	24 
    -- CP-element group 25: successors 
    -- CP-element group 25: 	27 
    -- CP-element group 25:  members (1) 
      -- CP-element group 25: 	 branch_block_stmt_11/merge_stmt_12_PhiAck/phi_stmt_13_ack
      -- 
    phi_stmt_13_ack_157_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 25_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_13_ack_0, ack => my_gcd_CP_0_elements(25)); -- 
    -- CP-element group 26:  transition  input  bypass 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	24 
    -- CP-element group 26: successors 
    -- CP-element group 26: 	27 
    -- CP-element group 26:  members (1) 
      -- CP-element group 26: 	 branch_block_stmt_11/merge_stmt_12_PhiAck/phi_stmt_17_ack
      -- 
    phi_stmt_17_ack_158_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 26_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_17_ack_0, ack => my_gcd_CP_0_elements(26)); -- 
    -- CP-element group 27:  join  transition  bypass 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: 	26 
    -- CP-element group 27: 	25 
    -- CP-element group 27: successors 
    -- CP-element group 27: 	1 
    -- CP-element group 27:  members (1) 
      -- CP-element group 27: 	 branch_block_stmt_11/merge_stmt_12_PhiAck/$exit
      -- 
    my_gcd_cp_element_group_27: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 26) := "my_gcd_cp_element_group_27"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= my_gcd_CP_0_elements(26) & my_gcd_CP_0_elements(25);
      gj_my_gcd_cp_element_group_27 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => my_gcd_CP_0_elements(27), clk => clk, reset => reset); --
    end block;
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal AND_u1_u1_29_wire : std_logic_vector(0 downto 0);
    signal A_15_buffered : std_logic_vector(31 downto 0);
    signal B_19_buffered : std_logic_vector(31 downto 0);
    signal EQ_u32_u1_38_wire : std_logic_vector(0 downto 0);
    signal EQ_u32_u1_42_wire : std_logic_vector(0 downto 0);
    signal EQ_u32_u1_45_wire : std_logic_vector(0 downto 0);
    signal MUX_50_wire : std_logic_vector(31 downto 0);
    signal NEQ_u32_u1_32_wire : std_logic_vector(0 downto 0);
    signal OR_u1_u1_46_wire : std_logic_vector(0 downto 0);
    signal SUB_u32_u32_59_wire : std_logic_vector(31 downto 0);
    signal SUB_u32_u32_69_wire : std_logic_vector(31 downto 0);
    signal UGT_u32_u1_25_wire : std_logic_vector(0 downto 0);
    signal UGT_u32_u1_28_wire : std_logic_vector(0 downto 0);
    signal UGT_u32_u1_56_wire : std_logic_vector(0 downto 0);
    signal UGT_u32_u1_66_wire : std_logic_vector(0 downto 0);
    signal continue_flag_34 : std_logic_vector(0 downto 0);
    signal konst_24_wire_constant : std_logic_vector(31 downto 0);
    signal konst_27_wire_constant : std_logic_vector(31 downto 0);
    signal konst_41_wire_constant : std_logic_vector(31 downto 0);
    signal konst_44_wire_constant : std_logic_vector(31 downto 0);
    signal konst_47_wire_constant : std_logic_vector(31 downto 0);
    signal ntA_62 : std_logic_vector(31 downto 0);
    signal ntA_62_16_buffered : std_logic_vector(31 downto 0);
    signal ntB_72 : std_logic_vector(31 downto 0);
    signal ntB_72_20_buffered : std_logic_vector(31 downto 0);
    signal tA_13 : std_logic_vector(31 downto 0);
    signal tB_17 : std_logic_vector(31 downto 0);
    signal type_cast_49_wire_constant : std_logic_vector(31 downto 0);
    -- 
  begin -- 
    konst_24_wire_constant <= "00000000000000000000000000000001";
    konst_27_wire_constant <= "00000000000000000000000000000001";
    konst_41_wire_constant <= "00000000000000000000000000000001";
    konst_44_wire_constant <= "00000000000000000000000000000001";
    konst_47_wire_constant <= "00000000000000000000000000000001";
    type_cast_49_wire_constant <= "00000000000000000000000000000000";
    phi_stmt_13: Block -- phi operator 
      signal idata: std_logic_vector(63 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= A_15_buffered & ntA_62_16_buffered;
      req <= phi_stmt_13_req_0 & phi_stmt_13_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_13",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 32) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_13_ack_0,
          idata => idata,
          odata => tA_13,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_13
    phi_stmt_17: Block -- phi operator 
      signal idata: std_logic_vector(63 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= B_19_buffered & ntB_72_20_buffered;
      req <= phi_stmt_17_req_0 & phi_stmt_17_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_17",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 32) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_17_ack_0,
          idata => idata,
          odata => tB_17,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_17
    -- flow-through select operator MUX_50_inst
    MUX_50_wire <= konst_47_wire_constant when (OR_u1_u1_46_wire(0) /=  '0') else type_cast_49_wire_constant;
    MUX_51_inst_block : block -- 
      signal sample_req, sample_ack, update_req, update_ack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      sample_req(0) <= MUX_51_inst_req_0;
      MUX_51_inst_ack_0<= sample_ack(0);
      update_req(0) <= MUX_51_inst_req_1;
      MUX_51_inst_ack_1<= update_ack(0);
      MUX_51_inst: SelectSplitProtocol generic map(name => "MUX_51_inst", data_width => 32, buffering => 1, flow_through => false, full_rate => false) -- 
        port map( x => tA_13, y => MUX_50_wire, sel => EQ_u32_u1_38_wire, z => GCD_buffer, sample_req => sample_req(0), sample_ack => sample_ack(0), update_req => update_req(0), update_ack => update_ack(0), clk => clk, reset => reset); -- 
      -- 
    end block;
    -- flow-through select operator MUX_61_inst
    ntA_62 <= SUB_u32_u32_59_wire when (UGT_u32_u1_56_wire(0) /=  '0') else tA_13;
    -- flow-through select operator MUX_71_inst
    ntB_72 <= SUB_u32_u32_69_wire when (UGT_u32_u1_66_wire(0) /=  '0') else tB_17;
    A_15_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= A_15_buf_req_0;
      A_15_buf_ack_0<= wack(0);
      rreq(0) <= A_15_buf_req_1;
      A_15_buf_ack_1<= rack(0);
      A_15_buf : InterlockBuffer generic map ( -- 
        name => "A_15_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => A_buffer,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => A_15_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    B_19_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= B_19_buf_req_0;
      B_19_buf_ack_0<= wack(0);
      rreq(0) <= B_19_buf_req_1;
      B_19_buf_ack_1<= rack(0);
      B_19_buf : InterlockBuffer generic map ( -- 
        name => "B_19_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => B_buffer,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => B_19_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    ntA_62_16_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= ntA_62_16_buf_req_0;
      ntA_62_16_buf_ack_0<= wack(0);
      rreq(0) <= ntA_62_16_buf_req_1;
      ntA_62_16_buf_ack_1<= rack(0);
      ntA_62_16_buf : InterlockBuffer generic map ( -- 
        name => "ntA_62_16_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => ntA_62,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ntA_62_16_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    ntB_72_20_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= ntB_72_20_buf_req_0;
      ntB_72_20_buf_ack_0<= wack(0);
      rreq(0) <= ntB_72_20_buf_req_1;
      ntB_72_20_buf_ack_1<= rack(0);
      ntB_72_20_buf : InterlockBuffer generic map ( -- 
        name => "ntB_72_20_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => ntB_72,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ntB_72_20_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    if_stmt_73_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= continue_flag_34;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_73_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_73_branch_req_0,
          ack0 => if_stmt_73_branch_ack_0,
          ack1 => if_stmt_73_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator AND_u1_u1_29_inst
    process(UGT_u32_u1_25_wire, UGT_u32_u1_28_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(UGT_u32_u1_25_wire, UGT_u32_u1_28_wire, tmp_var);
      AND_u1_u1_29_wire <= tmp_var; --
    end process;
    -- shared split operator group (1) : AND_u1_u1_33_inst 
    ApIntAnd_group_1: Block -- 
      signal data_in: std_logic_vector(1 downto 0);
      signal data_out: std_logic_vector(0 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= AND_u1_u1_29_wire & NEQ_u32_u1_32_wire;
      continue_flag_34 <= data_out(0 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= AND_u1_u1_33_inst_req_0;
      AND_u1_u1_33_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= AND_u1_u1_33_inst_req_1;
      AND_u1_u1_33_inst_ack_1 <= ackR_unguarded(0);
      ApIntAnd_group_1_gI: SplitGuardInterface generic map(name => "ApIntAnd_group_1_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
        port map(clk => clk, reset => reset,
        sr_in => reqL_unguarded,
        sr_out => reqL,
        sa_in => ackL,
        sa_out => ackL_unguarded,
        cr_in => reqR_unguarded,
        cr_out => reqR,
        ca_in => ackR,
        ca_out => ackR_unguarded,
        guards => guard_vector); -- 
      UnsharedOperator: UnsharedOperatorWithBuffering -- 
        generic map ( -- 
          operator_id => "ApIntAnd",
          name => "ApIntAnd_group_1",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 1,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 1, 
          num_inputs    => 2,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 1,
          constant_operand => "0",
          constant_width => 1,
          buffering  => 1,
          flow_through => false,
          full_rate  => false,
          use_constant  => false
          --
        ) 
        port map ( -- 
          reqL => reqL(0),
          ackL => ackL(0),
          reqR => reqR(0),
          ackR => ackR(0),
          dataL => data_in, 
          dataR => data_out,
          clk => clk,
          reset => reset); -- 
      -- 
    end Block; -- split operator group 1
    -- binary operator EQ_u32_u1_38_inst
    process(tA_13, tB_17) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(tA_13, tB_17, tmp_var);
      EQ_u32_u1_38_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u32_u1_42_inst
    process(tA_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(tA_13, konst_41_wire_constant, tmp_var);
      EQ_u32_u1_42_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u32_u1_45_inst
    process(tB_17) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(tB_17, konst_44_wire_constant, tmp_var);
      EQ_u32_u1_45_wire <= tmp_var; --
    end process;
    -- binary operator NEQ_u32_u1_32_inst
    process(tA_13, tB_17) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntNe_proc(tA_13, tB_17, tmp_var);
      NEQ_u32_u1_32_wire <= tmp_var; --
    end process;
    -- binary operator OR_u1_u1_46_inst
    process(EQ_u32_u1_42_wire, EQ_u32_u1_45_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(EQ_u32_u1_42_wire, EQ_u32_u1_45_wire, tmp_var);
      OR_u1_u1_46_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u32_u32_59_inst
    process(tA_13, tB_17) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntSub_proc(tA_13, tB_17, tmp_var);
      SUB_u32_u32_59_wire <= tmp_var; --
    end process;
    -- binary operator SUB_u32_u32_69_inst
    process(tB_17, tA_13) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntSub_proc(tB_17, tA_13, tmp_var);
      SUB_u32_u32_69_wire <= tmp_var; --
    end process;
    -- binary operator UGT_u32_u1_25_inst
    process(tA_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(tA_13, konst_24_wire_constant, tmp_var);
      UGT_u32_u1_25_wire <= tmp_var; --
    end process;
    -- binary operator UGT_u32_u1_28_inst
    process(tB_17) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(tB_17, konst_27_wire_constant, tmp_var);
      UGT_u32_u1_28_wire <= tmp_var; --
    end process;
    -- binary operator UGT_u32_u1_56_inst
    process(tA_13, tB_17) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(tA_13, tB_17, tmp_var);
      UGT_u32_u1_56_wire <= tmp_var; --
    end process;
    -- binary operator UGT_u32_u1_66_inst
    process(tB_17, tA_13) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(tB_17, tA_13, tmp_var);
      UGT_u32_u1_66_wire <= tmp_var; --
    end process;
    -- 
  end Block; -- data_path
  -- 
end my_gcd_arch;
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
library AjitCustom;
use AjitCustom.baud_control_calculator_global_package.all;
entity baud_control_calculator is  -- system 
  port (-- 
    clk : in std_logic;
    reset : in std_logic;
    BAUD_CONTROL_WORD_SIG: out std_logic_vector(31 downto 0);
    BAUD_CONTROL_WORD_VALID: out std_logic_vector(0 downto 0);
    BAUD_RATE_SIG: in std_logic_vector(31 downto 0);
    CLK_FREQUENCY_SIG: in std_logic_vector(31 downto 0);
    CLOCK_FREQUENCY_VALID: in std_logic_vector(0 downto 0)); -- 
  -- 
end entity; 
architecture baud_control_calculator_arch  of baud_control_calculator is -- system-architecture 
  -- declarations related to module baudControlCalculatorDaemon
  component baudControlCalculatorDaemon is -- 
    generic (tag_length : integer); 
    port ( -- 
      BAUD_RATE_SIG : in std_logic_vector(31 downto 0);
      CLK_FREQUENCY_SIG : in std_logic_vector(31 downto 0);
      CLOCK_FREQUENCY_VALID : in std_logic_vector(0 downto 0);
      BAUD_CONTROL_WORD_SIG_pipe_write_req : out  std_logic_vector(0 downto 0);
      BAUD_CONTROL_WORD_SIG_pipe_write_ack : in   std_logic_vector(0 downto 0);
      BAUD_CONTROL_WORD_SIG_pipe_write_data : out  std_logic_vector(31 downto 0);
      BAUD_CONTROL_WORD_VALID_pipe_write_req : out  std_logic_vector(0 downto 0);
      BAUD_CONTROL_WORD_VALID_pipe_write_ack : in   std_logic_vector(0 downto 0);
      BAUD_CONTROL_WORD_VALID_pipe_write_data : out  std_logic_vector(0 downto 0);
      my_gcd_call_reqs : out  std_logic_vector(0 downto 0);
      my_gcd_call_acks : in   std_logic_vector(0 downto 0);
      my_gcd_call_data : out  std_logic_vector(63 downto 0);
      my_gcd_call_tag  :  out  std_logic_vector(0 downto 0);
      my_gcd_return_reqs : out  std_logic_vector(0 downto 0);
      my_gcd_return_acks : in   std_logic_vector(0 downto 0);
      my_gcd_return_data : in   std_logic_vector(31 downto 0);
      my_gcd_return_tag :  in   std_logic_vector(0 downto 0);
      my_div_call_reqs : out  std_logic_vector(0 downto 0);
      my_div_call_acks : in   std_logic_vector(0 downto 0);
      my_div_call_data : out  std_logic_vector(63 downto 0);
      my_div_call_tag  :  out  std_logic_vector(1 downto 0);
      my_div_return_reqs : out  std_logic_vector(0 downto 0);
      my_div_return_acks : in   std_logic_vector(0 downto 0);
      my_div_return_data : in   std_logic_vector(31 downto 0);
      my_div_return_tag :  in   std_logic_vector(1 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  -- argument signals for module baudControlCalculatorDaemon
  signal baudControlCalculatorDaemon_tag_in    : std_logic_vector(1 downto 0) := (others => '0');
  signal baudControlCalculatorDaemon_tag_out   : std_logic_vector(1 downto 0);
  signal baudControlCalculatorDaemon_start_req : std_logic;
  signal baudControlCalculatorDaemon_start_ack : std_logic;
  signal baudControlCalculatorDaemon_fin_req   : std_logic;
  signal baudControlCalculatorDaemon_fin_ack : std_logic;
  -- declarations related to module my_div
  component my_div is -- 
    generic (tag_length : integer); 
    port ( -- 
      A : in  std_logic_vector(31 downto 0);
      B : in  std_logic_vector(31 downto 0);
      Q : out  std_logic_vector(31 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  -- argument signals for module my_div
  signal my_div_A :  std_logic_vector(31 downto 0);
  signal my_div_B :  std_logic_vector(31 downto 0);
  signal my_div_Q :  std_logic_vector(31 downto 0);
  signal my_div_in_args    : std_logic_vector(63 downto 0);
  signal my_div_out_args   : std_logic_vector(31 downto 0);
  signal my_div_tag_in    : std_logic_vector(2 downto 0) := (others => '0');
  signal my_div_tag_out   : std_logic_vector(2 downto 0);
  signal my_div_start_req : std_logic;
  signal my_div_start_ack : std_logic;
  signal my_div_fin_req   : std_logic;
  signal my_div_fin_ack : std_logic;
  -- caller side aggregated signals for module my_div
  signal my_div_call_reqs: std_logic_vector(0 downto 0);
  signal my_div_call_acks: std_logic_vector(0 downto 0);
  signal my_div_return_reqs: std_logic_vector(0 downto 0);
  signal my_div_return_acks: std_logic_vector(0 downto 0);
  signal my_div_call_data: std_logic_vector(63 downto 0);
  signal my_div_call_tag: std_logic_vector(1 downto 0);
  signal my_div_return_data: std_logic_vector(31 downto 0);
  signal my_div_return_tag: std_logic_vector(1 downto 0);
  -- declarations related to module my_gcd
  component my_gcd is -- 
    generic (tag_length : integer); 
    port ( -- 
      A : in  std_logic_vector(31 downto 0);
      B : in  std_logic_vector(31 downto 0);
      GCD : out  std_logic_vector(31 downto 0);
      tag_in: in std_logic_vector(tag_length-1 downto 0);
      tag_out: out std_logic_vector(tag_length-1 downto 0) ;
      clk : in std_logic;
      reset : in std_logic;
      start_req : in std_logic;
      start_ack : out std_logic;
      fin_req : in std_logic;
      fin_ack   : out std_logic-- 
    );
    -- 
  end component;
  -- argument signals for module my_gcd
  signal my_gcd_A :  std_logic_vector(31 downto 0);
  signal my_gcd_B :  std_logic_vector(31 downto 0);
  signal my_gcd_GCD :  std_logic_vector(31 downto 0);
  signal my_gcd_in_args    : std_logic_vector(63 downto 0);
  signal my_gcd_out_args   : std_logic_vector(31 downto 0);
  signal my_gcd_tag_in    : std_logic_vector(1 downto 0) := (others => '0');
  signal my_gcd_tag_out   : std_logic_vector(1 downto 0);
  signal my_gcd_start_req : std_logic;
  signal my_gcd_start_ack : std_logic;
  signal my_gcd_fin_req   : std_logic;
  signal my_gcd_fin_ack : std_logic;
  -- caller side aggregated signals for module my_gcd
  signal my_gcd_call_reqs: std_logic_vector(0 downto 0);
  signal my_gcd_call_acks: std_logic_vector(0 downto 0);
  signal my_gcd_return_reqs: std_logic_vector(0 downto 0);
  signal my_gcd_return_acks: std_logic_vector(0 downto 0);
  signal my_gcd_call_data: std_logic_vector(63 downto 0);
  signal my_gcd_call_tag: std_logic_vector(0 downto 0);
  signal my_gcd_return_data: std_logic_vector(31 downto 0);
  signal my_gcd_return_tag: std_logic_vector(0 downto 0);
  -- aggregate signals for write to pipe BAUD_CONTROL_WORD_SIG
  signal BAUD_CONTROL_WORD_SIG_pipe_write_data: std_logic_vector(31 downto 0);
  signal BAUD_CONTROL_WORD_SIG_pipe_write_req: std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_SIG_pipe_write_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for write to pipe BAUD_CONTROL_WORD_VALID
  signal BAUD_CONTROL_WORD_VALID_pipe_write_data: std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_VALID_pipe_write_req: std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_VALID_pipe_write_ack: std_logic_vector(0 downto 0);
  -- gated clock signal declarations.
  -- 
begin -- 
  -- module baudControlCalculatorDaemon
  baudControlCalculatorDaemon_instance:baudControlCalculatorDaemon-- 
    generic map(tag_length => 2)
    port map(-- 
      start_req => baudControlCalculatorDaemon_start_req,
      start_ack => baudControlCalculatorDaemon_start_ack,
      fin_req => baudControlCalculatorDaemon_fin_req,
      fin_ack => baudControlCalculatorDaemon_fin_ack,
      clk => clk,
      reset => reset,
      BAUD_RATE_SIG => BAUD_RATE_SIG,
      CLK_FREQUENCY_SIG => CLK_FREQUENCY_SIG,
      CLOCK_FREQUENCY_VALID => CLOCK_FREQUENCY_VALID,
      BAUD_CONTROL_WORD_SIG_pipe_write_req => BAUD_CONTROL_WORD_SIG_pipe_write_req(0 downto 0),
      BAUD_CONTROL_WORD_SIG_pipe_write_ack => BAUD_CONTROL_WORD_SIG_pipe_write_ack(0 downto 0),
      BAUD_CONTROL_WORD_SIG_pipe_write_data => BAUD_CONTROL_WORD_SIG_pipe_write_data(31 downto 0),
      BAUD_CONTROL_WORD_VALID_pipe_write_req => BAUD_CONTROL_WORD_VALID_pipe_write_req(0 downto 0),
      BAUD_CONTROL_WORD_VALID_pipe_write_ack => BAUD_CONTROL_WORD_VALID_pipe_write_ack(0 downto 0),
      BAUD_CONTROL_WORD_VALID_pipe_write_data => BAUD_CONTROL_WORD_VALID_pipe_write_data(0 downto 0),
      my_gcd_call_reqs => my_gcd_call_reqs(0 downto 0),
      my_gcd_call_acks => my_gcd_call_acks(0 downto 0),
      my_gcd_call_data => my_gcd_call_data(63 downto 0),
      my_gcd_call_tag => my_gcd_call_tag(0 downto 0),
      my_gcd_return_reqs => my_gcd_return_reqs(0 downto 0),
      my_gcd_return_acks => my_gcd_return_acks(0 downto 0),
      my_gcd_return_data => my_gcd_return_data(31 downto 0),
      my_gcd_return_tag => my_gcd_return_tag(0 downto 0),
      my_div_call_reqs => my_div_call_reqs(0 downto 0),
      my_div_call_acks => my_div_call_acks(0 downto 0),
      my_div_call_data => my_div_call_data(63 downto 0),
      my_div_call_tag => my_div_call_tag(1 downto 0),
      my_div_return_reqs => my_div_return_reqs(0 downto 0),
      my_div_return_acks => my_div_return_acks(0 downto 0),
      my_div_return_data => my_div_return_data(31 downto 0),
      my_div_return_tag => my_div_return_tag(1 downto 0),
      tag_in => baudControlCalculatorDaemon_tag_in,
      tag_out => baudControlCalculatorDaemon_tag_out-- 
    ); -- 
  -- module will be run forever 
  baudControlCalculatorDaemon_tag_in <= (others => '0');
  baudControlCalculatorDaemon_auto_run: auto_run generic map(use_delay => true)  port map(clk => clk, reset => reset, start_req => baudControlCalculatorDaemon_start_req, start_ack => baudControlCalculatorDaemon_start_ack,  fin_req => baudControlCalculatorDaemon_fin_req,  fin_ack => baudControlCalculatorDaemon_fin_ack);
  -- module my_div
  my_div_A <= my_div_in_args(63 downto 32);
  my_div_B <= my_div_in_args(31 downto 0);
  my_div_out_args <= my_div_Q ;
  -- call arbiter for module my_div
  my_div_arbiter: SplitCallArbiter -- 
    generic map( --
      name => "SplitCallArbiter", num_reqs => 1,
      call_data_width => 64,
      return_data_width => 32,
      callee_tag_length => 1,
      caller_tag_length => 2--
    )
    port map(-- 
      call_reqs => my_div_call_reqs,
      call_acks => my_div_call_acks,
      return_reqs => my_div_return_reqs,
      return_acks => my_div_return_acks,
      call_data  => my_div_call_data,
      call_tag  => my_div_call_tag,
      return_tag  => my_div_return_tag,
      call_mtag => my_div_tag_in,
      return_mtag => my_div_tag_out,
      return_data =>my_div_return_data,
      call_mreq => my_div_start_req,
      call_mack => my_div_start_ack,
      return_mreq => my_div_fin_req,
      return_mack => my_div_fin_ack,
      call_mdata => my_div_in_args,
      return_mdata => my_div_out_args,
      clk => clk, 
      reset => reset --
    ); --
  my_div_instance:my_div-- 
    generic map(tag_length => 3)
    port map(-- 
      A => my_div_A,
      B => my_div_B,
      Q => my_div_Q,
      start_req => my_div_start_req,
      start_ack => my_div_start_ack,
      fin_req => my_div_fin_req,
      fin_ack => my_div_fin_ack,
      clk => clk,
      reset => reset,
      tag_in => my_div_tag_in,
      tag_out => my_div_tag_out-- 
    ); -- 
  -- module my_gcd
  my_gcd_A <= my_gcd_in_args(63 downto 32);
  my_gcd_B <= my_gcd_in_args(31 downto 0);
  my_gcd_out_args <= my_gcd_GCD ;
  -- call arbiter for module my_gcd
  my_gcd_arbiter: SplitCallArbiter -- 
    generic map( --
      name => "SplitCallArbiter", num_reqs => 1,
      call_data_width => 64,
      return_data_width => 32,
      callee_tag_length => 1,
      caller_tag_length => 1--
    )
    port map(-- 
      call_reqs => my_gcd_call_reqs,
      call_acks => my_gcd_call_acks,
      return_reqs => my_gcd_return_reqs,
      return_acks => my_gcd_return_acks,
      call_data  => my_gcd_call_data,
      call_tag  => my_gcd_call_tag,
      return_tag  => my_gcd_return_tag,
      call_mtag => my_gcd_tag_in,
      return_mtag => my_gcd_tag_out,
      return_data =>my_gcd_return_data,
      call_mreq => my_gcd_start_req,
      call_mack => my_gcd_start_ack,
      return_mreq => my_gcd_fin_req,
      return_mack => my_gcd_fin_ack,
      call_mdata => my_gcd_in_args,
      return_mdata => my_gcd_out_args,
      clk => clk, 
      reset => reset --
    ); --
  my_gcd_instance:my_gcd-- 
    generic map(tag_length => 2)
    port map(-- 
      A => my_gcd_A,
      B => my_gcd_B,
      GCD => my_gcd_GCD,
      start_req => my_gcd_start_req,
      start_ack => my_gcd_start_ack,
      fin_req => my_gcd_fin_req,
      fin_ack => my_gcd_fin_ack,
      clk => clk,
      reset => reset,
      tag_in => my_gcd_tag_in,
      tag_out => my_gcd_tag_out-- 
    ); -- 
  BAUD_CONTROL_WORD_SIG_Signal: SignalBase -- 
    generic map( -- 
      name => "pipe BAUD_CONTROL_WORD_SIG",
      volatile_flag => false,
      num_writes => 1,
      data_width => 32 --
    ) 
    port map( -- 
      read_data => BAUD_CONTROL_WORD_SIG,
      write_req => BAUD_CONTROL_WORD_SIG_pipe_write_req,
      write_ack => BAUD_CONTROL_WORD_SIG_pipe_write_ack,
      write_data => BAUD_CONTROL_WORD_SIG_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  BAUD_CONTROL_WORD_VALID_Signal: SignalBase -- 
    generic map( -- 
      name => "pipe BAUD_CONTROL_WORD_VALID",
      volatile_flag => false,
      num_writes => 1,
      data_width => 1 --
    ) 
    port map( -- 
      read_data => BAUD_CONTROL_WORD_VALID,
      write_req => BAUD_CONTROL_WORD_VALID_pipe_write_req,
      write_ack => BAUD_CONTROL_WORD_VALID_pipe_write_ack,
      write_data => BAUD_CONTROL_WORD_VALID_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- input signal-pipe BAUD_RATE_SIG accessed directly. 
  -- input signal-pipe CLK_FREQUENCY_SIG accessed directly. 
  -- input signal-pipe CLOCK_FREQUENCY_VALID accessed directly. 
  -- gated clock generators 
  -- 
end baud_control_calculator_arch;
