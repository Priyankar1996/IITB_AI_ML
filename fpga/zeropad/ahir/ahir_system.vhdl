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
library work;
use work.ahir_system_global_package.all;
entity timer is -- 
  generic (tag_length : integer); 
  port ( -- 
    c : out  std_logic_vector(63 downto 0);
    memory_space_2_lr_req : out  std_logic_vector(0 downto 0);
    memory_space_2_lr_ack : in   std_logic_vector(0 downto 0);
    memory_space_2_lr_addr : out  std_logic_vector(0 downto 0);
    memory_space_2_lr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_2_lc_req : out  std_logic_vector(0 downto 0);
    memory_space_2_lc_ack : in   std_logic_vector(0 downto 0);
    memory_space_2_lc_data : in   std_logic_vector(63 downto 0);
    memory_space_2_lc_tag :  in  std_logic_vector(0 downto 0);
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
end entity timer;
architecture timer_arch of timer is -- 
  -- always true...
  signal always_true_symbol: Boolean;
  signal in_buffer_data_in, in_buffer_data_out: std_logic_vector((tag_length + 0)-1 downto 0);
  signal default_zero_sig: std_logic;
  signal in_buffer_write_req: std_logic;
  signal in_buffer_write_ack: std_logic;
  signal in_buffer_unload_req_symbol: Boolean;
  signal in_buffer_unload_ack_symbol: Boolean;
  signal out_buffer_data_in, out_buffer_data_out: std_logic_vector((tag_length + 64)-1 downto 0);
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
  signal c_buffer :  std_logic_vector(63 downto 0);
  signal c_update_enable: Boolean;
  signal timer_CP_26_start: Boolean;
  signal timer_CP_26_symbol: Boolean;
  -- volatile/operator module components. 
  -- links between control-path and data-path
  signal LOAD_count_26_load_0_req_0 : boolean;
  signal LOAD_count_26_load_0_ack_0 : boolean;
  signal LOAD_count_26_load_0_req_1 : boolean;
  signal LOAD_count_26_load_0_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "timer_input_buffer", -- 
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
  timer_CP_26_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "timer_out_buffer", -- 
      buffer_size => 1,
      full_rate => false,
      data_width => tag_length + 64) --
    port map(write_req => out_buffer_write_req_symbol, -- 
      write_ack => out_buffer_write_ack_symbol, 
      write_data => out_buffer_data_in,
      read_req => out_buffer_read_req, 
      read_ack => out_buffer_read_ack, 
      read_data => out_buffer_data_out,
      clk => clk, reset => reset); -- 
  out_buffer_data_in(63 downto 0) <= c_buffer;
  c <= out_buffer_data_out(63 downto 0);
  out_buffer_data_in(tag_length + 63 downto 64) <= tag_ilock_out;
  tag_out <= out_buffer_data_out(tag_length + 63 downto 64);
  out_buffer_write_req_symbol_join: block -- 
    constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
    constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 0);
    constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
    constant joinName: string(1 to 32) := "out_buffer_write_req_symbol_join"; 
    signal preds: BooleanArray(1 to 3); -- 
  begin -- 
    preds <= timer_CP_26_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
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
    preds <= timer_CP_26_start & tag_ilock_write_ack_symbol;
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
    preds <= timer_CP_26_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  timer_CP_26: Block -- control-path 
    signal timer_CP_26_elements: BooleanArray(2 downto 0);
    -- 
  begin -- 
    timer_CP_26_elements(0) <= timer_CP_26_start;
    timer_CP_26_symbol <= timer_CP_26_elements(2);
    -- CP-element group 0:  fork  transition  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	1 
    -- CP-element group 0: 	2 
    -- CP-element group 0:  members (14) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 assign_stmt_27/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_sample_start_
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_update_start_
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_word_address_calculated
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_root_address_calculated
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Sample/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/word_0/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/word_0/rr
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Update/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/word_0/$entry
      -- CP-element group 0: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/word_0/cr
      -- 
    cr_58_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_58_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timer_CP_26_elements(0), ack => LOAD_count_26_load_0_req_1); -- 
    rr_47_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_47_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timer_CP_26_elements(0), ack => LOAD_count_26_load_0_req_0); -- 
    -- CP-element group 1:  transition  input  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	0 
    -- CP-element group 1: successors 
    -- CP-element group 1:  members (5) 
      -- CP-element group 1: 	 assign_stmt_27/LOAD_count_26_sample_completed_
      -- CP-element group 1: 	 assign_stmt_27/LOAD_count_26_Sample/$exit
      -- CP-element group 1: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/$exit
      -- CP-element group 1: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/word_0/$exit
      -- CP-element group 1: 	 assign_stmt_27/LOAD_count_26_Sample/word_access_start/word_0/ra
      -- 
    ra_48_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 1_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => LOAD_count_26_load_0_ack_0, ack => timer_CP_26_elements(1)); -- 
    -- CP-element group 2:  transition  input  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	0 
    -- CP-element group 2: successors 
    -- CP-element group 2:  members (11) 
      -- CP-element group 2: 	 $exit
      -- CP-element group 2: 	 assign_stmt_27/$exit
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_update_completed_
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/$exit
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/$exit
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/word_0/$exit
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/word_access_complete/word_0/ca
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/LOAD_count_26_Merge/$entry
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/LOAD_count_26_Merge/$exit
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/LOAD_count_26_Merge/merge_req
      -- CP-element group 2: 	 assign_stmt_27/LOAD_count_26_Update/LOAD_count_26_Merge/merge_ack
      -- 
    ca_59_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => LOAD_count_26_load_0_ack_1, ack => timer_CP_26_elements(2)); -- 
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal LOAD_count_26_data_0 : std_logic_vector(63 downto 0);
    signal LOAD_count_26_word_address_0 : std_logic_vector(0 downto 0);
    -- 
  begin -- 
    LOAD_count_26_word_address_0 <= "0";
    -- equivalence LOAD_count_26_gather_scatter
    process(LOAD_count_26_data_0) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := LOAD_count_26_data_0;
      ov(63 downto 0) := iv;
      c_buffer <= ov(63 downto 0);
      --
    end process;
    -- shared load operator group (0) : LOAD_count_26_load_0 
    LoadGroup0: Block -- 
      signal data_in: std_logic_vector(0 downto 0);
      signal data_out: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated: BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      reqL_unguarded(0) <= LOAD_count_26_load_0_req_0;
      LOAD_count_26_load_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= LOAD_count_26_load_0_req_1;
      LOAD_count_26_load_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      LoadGroup0_gI: SplitGuardInterface generic map(name => "LoadGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      data_in <= LOAD_count_26_word_address_0;
      LOAD_count_26_data_0 <= data_out(63 downto 0);
      LoadReq: LoadReqSharedWithInputBuffers -- 
        generic map ( name => "LoadGroup0", addr_width => 1,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          dataL => data_in, 
          mreq => memory_space_2_lr_req(0),
          mack => memory_space_2_lr_ack(0),
          maddr => memory_space_2_lr_addr(0 downto 0),
          mtag => memory_space_2_lr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      LoadComplete: LoadCompleteShared -- 
        generic map ( name => "LoadGroup0 load-complete ",
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        detailed_buffering_per_output => outBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          mreq => memory_space_2_lc_req(0),
          mack => memory_space_2_lc_ack(0),
          mdata => memory_space_2_lc_data(63 downto 0),
          mtag => memory_space_2_lc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- load group 0
    -- 
  end Block; -- data_path
  -- 
end timer_arch;
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
library work;
use work.ahir_system_global_package.all;
entity timerDaemon is -- 
  generic (tag_length : integer); 
  port ( -- 
    memory_space_2_sr_req : out  std_logic_vector(0 downto 0);
    memory_space_2_sr_ack : in   std_logic_vector(0 downto 0);
    memory_space_2_sr_addr : out  std_logic_vector(0 downto 0);
    memory_space_2_sr_data : out  std_logic_vector(63 downto 0);
    memory_space_2_sr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_2_sc_req : out  std_logic_vector(0 downto 0);
    memory_space_2_sc_ack : in   std_logic_vector(0 downto 0);
    memory_space_2_sc_tag :  in  std_logic_vector(0 downto 0);
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
end entity timerDaemon;
architecture timerDaemon_arch of timerDaemon is -- 
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
  signal timerDaemon_CP_65_start: Boolean;
  signal timerDaemon_CP_65_symbol: Boolean;
  -- volatile/operator module components. 
  -- links between control-path and data-path
  signal do_while_stmt_31_branch_req_0 : boolean;
  signal phi_stmt_33_req_0 : boolean;
  signal phi_stmt_33_req_1 : boolean;
  signal phi_stmt_33_ack_0 : boolean;
  signal ADD_u64_u64_37_inst_req_0 : boolean;
  signal ADD_u64_u64_37_inst_ack_0 : boolean;
  signal ADD_u64_u64_37_inst_req_1 : boolean;
  signal ADD_u64_u64_37_inst_ack_1 : boolean;
  signal STORE_count_41_store_0_req_0 : boolean;
  signal STORE_count_41_store_0_ack_0 : boolean;
  signal STORE_count_41_store_0_req_1 : boolean;
  signal STORE_count_41_store_0_ack_1 : boolean;
  signal do_while_stmt_31_branch_ack_0 : boolean;
  signal do_while_stmt_31_branch_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "timerDaemon_input_buffer", -- 
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
  timerDaemon_CP_65_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "timerDaemon_out_buffer", -- 
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
    preds <= timerDaemon_CP_65_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
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
    preds <= timerDaemon_CP_65_start & tag_ilock_write_ack_symbol;
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
    preds <= timerDaemon_CP_65_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  timerDaemon_CP_65: Block -- control-path 
    signal timerDaemon_CP_65_elements: BooleanArray(39 downto 0);
    -- 
  begin -- 
    timerDaemon_CP_65_elements(0) <= timerDaemon_CP_65_start;
    timerDaemon_CP_65_symbol <= timerDaemon_CP_65_elements(1);
    -- CP-element group 0:  transition  place  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	2 
    -- CP-element group 0:  members (4) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 branch_block_stmt_30/$entry
      -- CP-element group 0: 	 branch_block_stmt_30/branch_block_stmt_30__entry__
      -- CP-element group 0: 	 branch_block_stmt_30/do_while_stmt_31__entry__
      -- 
    -- CP-element group 1:  transition  place  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	39 
    -- CP-element group 1: successors 
    -- CP-element group 1:  members (4) 
      -- CP-element group 1: 	 $exit
      -- CP-element group 1: 	 branch_block_stmt_30/$exit
      -- CP-element group 1: 	 branch_block_stmt_30/branch_block_stmt_30__exit__
      -- CP-element group 1: 	 branch_block_stmt_30/do_while_stmt_31__exit__
      -- 
    timerDaemon_CP_65_elements(1) <= timerDaemon_CP_65_elements(39);
    -- CP-element group 2:  transition  place  bypass  pipeline-parent 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	0 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	8 
    -- CP-element group 2:  members (2) 
      -- CP-element group 2: 	 branch_block_stmt_30/do_while_stmt_31/$entry
      -- CP-element group 2: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31__entry__
      -- 
    timerDaemon_CP_65_elements(2) <= timerDaemon_CP_65_elements(0);
    -- CP-element group 3:  merge  place  bypass  pipeline-parent 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	39 
    -- CP-element group 3:  members (1) 
      -- CP-element group 3: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31__exit__
      -- 
    -- Element group timerDaemon_CP_65_elements(3) is bound as output of CP function.
    -- CP-element group 4:  merge  place  bypass  pipeline-parent 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: successors 
    -- CP-element group 4: 	7 
    -- CP-element group 4:  members (1) 
      -- CP-element group 4: 	 branch_block_stmt_30/do_while_stmt_31/loop_back
      -- 
    -- Element group timerDaemon_CP_65_elements(4) is bound as output of CP function.
    -- CP-element group 5:  branch  transition  place  bypass  pipeline-parent 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	10 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	37 
    -- CP-element group 5: 	38 
    -- CP-element group 5:  members (3) 
      -- CP-element group 5: 	 branch_block_stmt_30/do_while_stmt_31/condition_done
      -- CP-element group 5: 	 branch_block_stmt_30/do_while_stmt_31/loop_exit/$entry
      -- CP-element group 5: 	 branch_block_stmt_30/do_while_stmt_31/loop_taken/$entry
      -- 
    timerDaemon_CP_65_elements(5) <= timerDaemon_CP_65_elements(10);
    -- CP-element group 6:  branch  place  bypass  pipeline-parent 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	36 
    -- CP-element group 6: successors 
    -- CP-element group 6:  members (1) 
      -- CP-element group 6: 	 branch_block_stmt_30/do_while_stmt_31/loop_body_done
      -- 
    timerDaemon_CP_65_elements(6) <= timerDaemon_CP_65_elements(36);
    -- CP-element group 7:  transition  bypass  pipeline-parent 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	4 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	16 
    -- CP-element group 7:  members (1) 
      -- CP-element group 7: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/back_edge_to_loop_body
      -- 
    timerDaemon_CP_65_elements(7) <= timerDaemon_CP_65_elements(4);
    -- CP-element group 8:  transition  bypass  pipeline-parent 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	2 
    -- CP-element group 8: successors 
    -- CP-element group 8: 	18 
    -- CP-element group 8:  members (1) 
      -- CP-element group 8: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/first_time_through_loop_body
      -- 
    timerDaemon_CP_65_elements(8) <= timerDaemon_CP_65_elements(2);
    -- CP-element group 9:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	12 
    -- CP-element group 9: 	13 
    -- CP-element group 9: 	35 
    -- CP-element group 9: 	31 
    -- CP-element group 9:  members (4) 
      -- CP-element group 9: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/$entry
      -- CP-element group 9: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/loop_body_start
      -- CP-element group 9: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_word_address_calculated
      -- CP-element group 9: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_root_address_calculated
      -- 
    -- Element group timerDaemon_CP_65_elements(9) is bound as output of CP function.
    -- CP-element group 10:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	35 
    -- CP-element group 10: 	15 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	5 
    -- CP-element group 10:  members (1) 
      -- CP-element group 10: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/condition_evaluated
      -- 
    condition_evaluated_89_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " condition_evaluated_89_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(10), ack => do_while_stmt_31_branch_req_0); -- 
    timerDaemon_cp_element_group_10: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 3);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_10"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(35) & timerDaemon_CP_65_elements(15);
      gj_timerDaemon_cp_element_group_10 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(10), clk => clk, reset => reset); --
    end block;
    -- CP-element group 11:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	12 
    -- CP-element group 11: marked-predecessors 
    -- CP-element group 11: 	15 
    -- CP-element group 11: successors 
    -- CP-element group 11:  members (2) 
      -- CP-element group 11: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/aggregated_phi_sample_req
      -- CP-element group 11: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_sample_start__ps
      -- 
    timerDaemon_cp_element_group_11: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_11"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(12) & timerDaemon_CP_65_elements(15);
      gj_timerDaemon_cp_element_group_11 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(11), clk => clk, reset => reset); --
    end block;
    -- CP-element group 12:  join  transition  bypass  pipeline-parent 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	9 
    -- CP-element group 12: marked-predecessors 
    -- CP-element group 12: 	14 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	11 
    -- CP-element group 12:  members (1) 
      -- CP-element group 12: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_sample_start_
      -- 
    timerDaemon_cp_element_group_12: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_12"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(9) & timerDaemon_CP_65_elements(14);
      gj_timerDaemon_cp_element_group_12 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(12), clk => clk, reset => reset); --
    end block;
    -- CP-element group 13:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	9 
    -- CP-element group 13: marked-predecessors 
    -- CP-element group 13: 	33 
    -- CP-element group 13: successors 
    -- CP-element group 13:  members (3) 
      -- CP-element group 13: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/aggregated_phi_update_req
      -- CP-element group 13: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_update_start_
      -- CP-element group 13: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_update_start__ps
      -- 
    timerDaemon_cp_element_group_13: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_13"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(9) & timerDaemon_CP_65_elements(33);
      gj_timerDaemon_cp_element_group_13 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(13), clk => clk, reset => reset); --
    end block;
    -- CP-element group 14:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	36 
    -- CP-element group 14: marked-successors 
    -- CP-element group 14: 	12 
    -- CP-element group 14:  members (3) 
      -- CP-element group 14: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/aggregated_phi_sample_ack
      -- CP-element group 14: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_sample_completed_
      -- CP-element group 14: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_sample_completed__ps
      -- 
    -- Element group timerDaemon_CP_65_elements(14) is bound as output of CP function.
    -- CP-element group 15:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	10 
    -- CP-element group 15: 	31 
    -- CP-element group 15: marked-successors 
    -- CP-element group 15: 	11 
    -- CP-element group 15:  members (3) 
      -- CP-element group 15: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/aggregated_phi_update_ack
      -- CP-element group 15: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_update_completed_
      -- CP-element group 15: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_update_completed__ps
      -- 
    -- Element group timerDaemon_CP_65_elements(15) is bound as output of CP function.
    -- CP-element group 16:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	7 
    -- CP-element group 16: successors 
    -- CP-element group 16:  members (1) 
      -- CP-element group 16: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_loopback_trigger
      -- 
    timerDaemon_CP_65_elements(16) <= timerDaemon_CP_65_elements(7);
    -- CP-element group 17:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: successors 
    -- CP-element group 17:  members (2) 
      -- CP-element group 17: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_loopback_sample_req
      -- CP-element group 17: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_loopback_sample_req_ps
      -- 
    phi_stmt_33_loopback_sample_req_104_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_33_loopback_sample_req_104_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(17), ack => phi_stmt_33_req_0); -- 
    -- Element group timerDaemon_CP_65_elements(17) is bound as output of CP function.
    -- CP-element group 18:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	8 
    -- CP-element group 18: successors 
    -- CP-element group 18:  members (1) 
      -- CP-element group 18: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_entry_trigger
      -- 
    timerDaemon_CP_65_elements(18) <= timerDaemon_CP_65_elements(8);
    -- CP-element group 19:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: successors 
    -- CP-element group 19:  members (2) 
      -- CP-element group 19: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_entry_sample_req
      -- CP-element group 19: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_entry_sample_req_ps
      -- 
    phi_stmt_33_entry_sample_req_107_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_33_entry_sample_req_107_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(19), ack => phi_stmt_33_req_1); -- 
    -- Element group timerDaemon_CP_65_elements(19) is bound as output of CP function.
    -- CP-element group 20:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: successors 
    -- CP-element group 20:  members (2) 
      -- CP-element group 20: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_phi_mux_ack
      -- CP-element group 20: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/phi_stmt_33_phi_mux_ack_ps
      -- 
    phi_stmt_33_phi_mux_ack_110_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 20_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_33_ack_0, ack => timerDaemon_CP_65_elements(20)); -- 
    -- CP-element group 21:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	23 
    -- CP-element group 21:  members (1) 
      -- CP-element group 21: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_sample_start__ps
      -- 
    -- Element group timerDaemon_CP_65_elements(21) is bound as output of CP function.
    -- CP-element group 22:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: successors 
    -- CP-element group 22: 	24 
    -- CP-element group 22:  members (1) 
      -- CP-element group 22: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_update_start__ps
      -- 
    -- Element group timerDaemon_CP_65_elements(22) is bound as output of CP function.
    -- CP-element group 23:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: 	21 
    -- CP-element group 23: marked-predecessors 
    -- CP-element group 23: 	25 
    -- CP-element group 23: successors 
    -- CP-element group 23: 	25 
    -- CP-element group 23:  members (3) 
      -- CP-element group 23: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_sample_start_
      -- CP-element group 23: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Sample/$entry
      -- CP-element group 23: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Sample/rr
      -- 
    rr_123_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_123_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(23), ack => ADD_u64_u64_37_inst_req_0); -- 
    timerDaemon_cp_element_group_23: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_23"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(21) & timerDaemon_CP_65_elements(25);
      gj_timerDaemon_cp_element_group_23 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(23), clk => clk, reset => reset); --
    end block;
    -- CP-element group 24:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	22 
    -- CP-element group 24: marked-predecessors 
    -- CP-element group 24: 	26 
    -- CP-element group 24: successors 
    -- CP-element group 24: 	26 
    -- CP-element group 24:  members (3) 
      -- CP-element group 24: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_update_start_
      -- CP-element group 24: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Update/$entry
      -- CP-element group 24: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Update/cr
      -- 
    cr_128_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_128_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(24), ack => ADD_u64_u64_37_inst_req_1); -- 
    timerDaemon_cp_element_group_24: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_24"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(22) & timerDaemon_CP_65_elements(26);
      gj_timerDaemon_cp_element_group_24 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(24), clk => clk, reset => reset); --
    end block;
    -- CP-element group 25:  join  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	23 
    -- CP-element group 25: successors 
    -- CP-element group 25: marked-successors 
    -- CP-element group 25: 	23 
    -- CP-element group 25:  members (4) 
      -- CP-element group 25: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_sample_completed__ps
      -- CP-element group 25: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_sample_completed_
      -- CP-element group 25: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Sample/$exit
      -- CP-element group 25: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Sample/ra
      -- 
    ra_124_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 25_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u64_u64_37_inst_ack_0, ack => timerDaemon_CP_65_elements(25)); -- 
    -- CP-element group 26:  join  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	24 
    -- CP-element group 26: successors 
    -- CP-element group 26: marked-successors 
    -- CP-element group 26: 	24 
    -- CP-element group 26:  members (4) 
      -- CP-element group 26: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_update_completed__ps
      -- CP-element group 26: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_update_completed_
      -- CP-element group 26: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Update/$exit
      -- CP-element group 26: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/ADD_u64_u64_37_Update/ca
      -- 
    ca_129_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 26_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u64_u64_37_inst_ack_1, ack => timerDaemon_CP_65_elements(26)); -- 
    -- CP-element group 27:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: successors 
    -- CP-element group 27:  members (4) 
      -- CP-element group 27: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_sample_start__ps
      -- CP-element group 27: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_sample_completed__ps
      -- CP-element group 27: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_sample_start_
      -- CP-element group 27: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_sample_completed_
      -- 
    -- Element group timerDaemon_CP_65_elements(27) is bound as output of CP function.
    -- CP-element group 28:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 28: predecessors 
    -- CP-element group 28: successors 
    -- CP-element group 28: 	30 
    -- CP-element group 28:  members (2) 
      -- CP-element group 28: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_update_start__ps
      -- CP-element group 28: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_update_start_
      -- 
    -- Element group timerDaemon_CP_65_elements(28) is bound as output of CP function.
    -- CP-element group 29:  join  transition  bypass  pipeline-parent 
    -- CP-element group 29: predecessors 
    -- CP-element group 29: 	30 
    -- CP-element group 29: successors 
    -- CP-element group 29:  members (1) 
      -- CP-element group 29: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_update_completed__ps
      -- 
    timerDaemon_CP_65_elements(29) <= timerDaemon_CP_65_elements(30);
    -- CP-element group 30:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 30: predecessors 
    -- CP-element group 30: 	28 
    -- CP-element group 30: successors 
    -- CP-element group 30: 	29 
    -- CP-element group 30:  members (1) 
      -- CP-element group 30: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/type_cast_39_update_completed_
      -- 
    -- Element group timerDaemon_CP_65_elements(30) is a control-delay.
    cp_element_30_delay: control_delay_element  generic map(name => " 30_delay", delay_value => 1)  port map(req => timerDaemon_CP_65_elements(28), ack => timerDaemon_CP_65_elements(30), clk => clk, reset =>reset);
    -- CP-element group 31:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 31: predecessors 
    -- CP-element group 31: 	9 
    -- CP-element group 31: 	15 
    -- CP-element group 31: marked-predecessors 
    -- CP-element group 31: 	33 
    -- CP-element group 31: successors 
    -- CP-element group 31: 	33 
    -- CP-element group 31:  members (9) 
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_sample_start_
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/$entry
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/STORE_count_41_Split/$entry
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/STORE_count_41_Split/$exit
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/STORE_count_41_Split/split_req
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/STORE_count_41_Split/split_ack
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/$entry
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/word_0/$entry
      -- CP-element group 31: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/word_0/rr
      -- 
    rr_159_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_159_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(31), ack => STORE_count_41_store_0_req_0); -- 
    timerDaemon_cp_element_group_31: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 3,1 => 3,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_31"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(9) & timerDaemon_CP_65_elements(15) & timerDaemon_CP_65_elements(33);
      gj_timerDaemon_cp_element_group_31 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(31), clk => clk, reset => reset); --
    end block;
    -- CP-element group 32:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 32: predecessors 
    -- CP-element group 32: marked-predecessors 
    -- CP-element group 32: 	34 
    -- CP-element group 32: successors 
    -- CP-element group 32: 	34 
    -- CP-element group 32:  members (5) 
      -- CP-element group 32: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_update_start_
      -- CP-element group 32: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/$entry
      -- CP-element group 32: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/$entry
      -- CP-element group 32: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/word_0/$entry
      -- CP-element group 32: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/word_0/cr
      -- 
    cr_170_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_170_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => timerDaemon_CP_65_elements(32), ack => STORE_count_41_store_0_req_1); -- 
    timerDaemon_cp_element_group_32: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_32"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= timerDaemon_CP_65_elements(34);
      gj_timerDaemon_cp_element_group_32 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(32), clk => clk, reset => reset); --
    end block;
    -- CP-element group 33:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 33: predecessors 
    -- CP-element group 33: 	31 
    -- CP-element group 33: successors 
    -- CP-element group 33: marked-successors 
    -- CP-element group 33: 	13 
    -- CP-element group 33: 	31 
    -- CP-element group 33:  members (5) 
      -- CP-element group 33: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_sample_completed_
      -- CP-element group 33: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/$exit
      -- CP-element group 33: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/$exit
      -- CP-element group 33: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/word_0/$exit
      -- CP-element group 33: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Sample/word_access_start/word_0/ra
      -- 
    ra_160_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 33_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => STORE_count_41_store_0_ack_0, ack => timerDaemon_CP_65_elements(33)); -- 
    -- CP-element group 34:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 34: predecessors 
    -- CP-element group 34: 	32 
    -- CP-element group 34: successors 
    -- CP-element group 34: 	36 
    -- CP-element group 34: marked-successors 
    -- CP-element group 34: 	32 
    -- CP-element group 34:  members (5) 
      -- CP-element group 34: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_update_completed_
      -- CP-element group 34: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/$exit
      -- CP-element group 34: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/$exit
      -- CP-element group 34: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/word_0/$exit
      -- CP-element group 34: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/STORE_count_41_Update/word_access_complete/word_0/ca
      -- 
    ca_171_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 34_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => STORE_count_41_store_0_ack_1, ack => timerDaemon_CP_65_elements(34)); -- 
    -- CP-element group 35:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 35: predecessors 
    -- CP-element group 35: 	9 
    -- CP-element group 35: successors 
    -- CP-element group 35: 	10 
    -- CP-element group 35:  members (1) 
      -- CP-element group 35: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/loop_body_delay_to_condition_start
      -- 
    -- Element group timerDaemon_CP_65_elements(35) is a control-delay.
    cp_element_35_delay: control_delay_element  generic map(name => " 35_delay", delay_value => 1)  port map(req => timerDaemon_CP_65_elements(9), ack => timerDaemon_CP_65_elements(35), clk => clk, reset =>reset);
    -- CP-element group 36:  join  transition  bypass  pipeline-parent 
    -- CP-element group 36: predecessors 
    -- CP-element group 36: 	34 
    -- CP-element group 36: 	14 
    -- CP-element group 36: successors 
    -- CP-element group 36: 	6 
    -- CP-element group 36:  members (1) 
      -- CP-element group 36: 	 branch_block_stmt_30/do_while_stmt_31/do_while_stmt_31_loop_body/$exit
      -- 
    timerDaemon_cp_element_group_36: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 3,1 => 3);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "timerDaemon_cp_element_group_36"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= timerDaemon_CP_65_elements(34) & timerDaemon_CP_65_elements(14);
      gj_timerDaemon_cp_element_group_36 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => timerDaemon_CP_65_elements(36), clk => clk, reset => reset); --
    end block;
    -- CP-element group 37:  transition  input  bypass  pipeline-parent 
    -- CP-element group 37: predecessors 
    -- CP-element group 37: 	5 
    -- CP-element group 37: successors 
    -- CP-element group 37:  members (2) 
      -- CP-element group 37: 	 branch_block_stmt_30/do_while_stmt_31/loop_exit/$exit
      -- CP-element group 37: 	 branch_block_stmt_30/do_while_stmt_31/loop_exit/ack
      -- 
    ack_176_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 37_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_31_branch_ack_0, ack => timerDaemon_CP_65_elements(37)); -- 
    -- CP-element group 38:  transition  input  bypass  pipeline-parent 
    -- CP-element group 38: predecessors 
    -- CP-element group 38: 	5 
    -- CP-element group 38: successors 
    -- CP-element group 38:  members (2) 
      -- CP-element group 38: 	 branch_block_stmt_30/do_while_stmt_31/loop_taken/$exit
      -- CP-element group 38: 	 branch_block_stmt_30/do_while_stmt_31/loop_taken/ack
      -- 
    ack_180_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 38_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_31_branch_ack_1, ack => timerDaemon_CP_65_elements(38)); -- 
    -- CP-element group 39:  transition  bypass  pipeline-parent 
    -- CP-element group 39: predecessors 
    -- CP-element group 39: 	3 
    -- CP-element group 39: successors 
    -- CP-element group 39: 	1 
    -- CP-element group 39:  members (1) 
      -- CP-element group 39: 	 branch_block_stmt_30/do_while_stmt_31/$exit
      -- 
    timerDaemon_CP_65_elements(39) <= timerDaemon_CP_65_elements(3);
    timerDaemon_do_while_stmt_31_terminator_181: loop_terminator -- 
      generic map (name => " timerDaemon_do_while_stmt_31_terminator_181", max_iterations_in_flight =>3) 
      port map(loop_body_exit => timerDaemon_CP_65_elements(6),loop_continue => timerDaemon_CP_65_elements(38),loop_terminate => timerDaemon_CP_65_elements(37),loop_back => timerDaemon_CP_65_elements(4),loop_exit => timerDaemon_CP_65_elements(3),clk => clk, reset => reset); -- 
    phi_stmt_33_phi_seq_138_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= timerDaemon_CP_65_elements(16);
      timerDaemon_CP_65_elements(21)<= src_sample_reqs(0);
      src_sample_acks(0)  <= timerDaemon_CP_65_elements(25);
      timerDaemon_CP_65_elements(22)<= src_update_reqs(0);
      src_update_acks(0)  <= timerDaemon_CP_65_elements(26);
      timerDaemon_CP_65_elements(17) <= phi_mux_reqs(0);
      triggers(1)  <= timerDaemon_CP_65_elements(18);
      timerDaemon_CP_65_elements(27)<= src_sample_reqs(1);
      src_sample_acks(1)  <= timerDaemon_CP_65_elements(27);
      timerDaemon_CP_65_elements(28)<= src_update_reqs(1);
      src_update_acks(1)  <= timerDaemon_CP_65_elements(29);
      timerDaemon_CP_65_elements(19) <= phi_mux_reqs(1);
      phi_stmt_33_phi_seq_138 : phi_sequencer_v2-- 
        generic map (place_capacity => 3, ntriggers => 2, name => "phi_stmt_33_phi_seq_138") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => timerDaemon_CP_65_elements(11), 
          phi_sample_ack => timerDaemon_CP_65_elements(14), 
          phi_update_req => timerDaemon_CP_65_elements(13), 
          phi_update_ack => timerDaemon_CP_65_elements(15), 
          phi_mux_ack => timerDaemon_CP_65_elements(20), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    entry_tmerge_90_block : block -- 
      signal preds : BooleanArray(0 to 1);
      begin -- 
        preds(0)  <= timerDaemon_CP_65_elements(7);
        preds(1)  <= timerDaemon_CP_65_elements(8);
        entry_tmerge_90 : transition_merge -- 
          generic map(name => " entry_tmerge_90")
          port map (preds => preds, symbol_out => timerDaemon_CP_65_elements(9));
          -- 
    end block;
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal ADD_u64_u64_37_wire : std_logic_vector(63 downto 0);
    signal STORE_count_41_data_0 : std_logic_vector(63 downto 0);
    signal STORE_count_41_word_address_0 : std_logic_vector(0 downto 0);
    signal konst_36_wire_constant : std_logic_vector(63 downto 0);
    signal konst_45_wire_constant : std_logic_vector(0 downto 0);
    signal ncount_33 : std_logic_vector(63 downto 0);
    signal type_cast_39_wire_constant : std_logic_vector(63 downto 0);
    -- 
  begin -- 
    STORE_count_41_word_address_0 <= "0";
    konst_36_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
    konst_45_wire_constant <= "1";
    type_cast_39_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
    phi_stmt_33: Block -- phi operator 
      signal idata: std_logic_vector(127 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= ADD_u64_u64_37_wire & type_cast_39_wire_constant;
      req <= phi_stmt_33_req_0 & phi_stmt_33_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_33",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 64) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_33_ack_0,
          idata => idata,
          odata => ncount_33,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_33
    -- equivalence STORE_count_41_gather_scatter
    process(ncount_33) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ncount_33;
      ov(63 downto 0) := iv;
      STORE_count_41_data_0 <= ov(63 downto 0);
      --
    end process;
    do_while_stmt_31_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= konst_45_wire_constant;
      branch_instance: BranchBase -- 
        generic map( name => "do_while_stmt_31_branch", condition_width => 1,  bypass_flag => true)
        port map( -- 
          condition => condition_sig,
          req => do_while_stmt_31_branch_req_0,
          ack0 => do_while_stmt_31_branch_ack_0,
          ack1 => do_while_stmt_31_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- shared split operator group (0) : ADD_u64_u64_37_inst 
    ApIntAdd_group_0: Block -- 
      signal data_in: std_logic_vector(63 downto 0);
      signal data_out: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= ncount_33;
      ADD_u64_u64_37_wire <= data_out(63 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= ADD_u64_u64_37_inst_req_0;
      ADD_u64_u64_37_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ADD_u64_u64_37_inst_req_1;
      ADD_u64_u64_37_inst_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_0_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_0",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 64,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 64,
          constant_operand => "0000000000000000000000000000000000000000000000000000000000000001",
          constant_width => 64,
          buffering  => 1,
          flow_through => false,
          full_rate  => true,
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
    end Block; -- split operator group 0
    -- shared store operator group (0) : STORE_count_41_store_0 
    StoreGroup0: Block -- 
      signal addr_in: std_logic_vector(0 downto 0);
      signal data_in: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 3);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 4);
      -- 
    begin -- 
      reqL_unguarded(0) <= STORE_count_41_store_0_req_0;
      STORE_count_41_store_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= STORE_count_41_store_0_req_1;
      STORE_count_41_store_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      StoreGroup0_gI: SplitGuardInterface generic map(name => "StoreGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      addr_in <= STORE_count_41_word_address_0;
      data_in <= STORE_count_41_data_0;
      StoreReq: StoreReqSharedWithInputBuffers -- 
        generic map ( name => "StoreGroup0 Req ", addr_width => 1,
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map (--
          reqL => reqL , 
          ackL => ackL , 
          addr => addr_in, 
          data => data_in, 
          mreq => memory_space_2_sr_req(0),
          mack => memory_space_2_sr_ack(0),
          maddr => memory_space_2_sr_addr(0 downto 0),
          mdata => memory_space_2_sr_data(63 downto 0),
          mtag => memory_space_2_sr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        );--
      StoreComplete: StoreCompleteShared -- 
        generic map ( -- 
          name => "StoreGroup0 Complete ",
          num_reqs => 1,
          detailed_buffering_per_output => outBUFs,
          tag_length => 1 -- 
        )
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          mreq => memory_space_2_sc_req(0),
          mack => memory_space_2_sc_ack(0),
          mtag => memory_space_2_sc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- store group 0
    -- 
  end Block; -- data_path
  -- 
end timerDaemon_arch;
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
library work;
use work.ahir_system_global_package.all;
entity zeropad3D is -- 
  generic (tag_length : integer); 
  port ( -- 
    memory_space_0_lr_req : out  std_logic_vector(0 downto 0);
    memory_space_0_lr_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_lr_addr : out  std_logic_vector(13 downto 0);
    memory_space_0_lr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_0_lc_req : out  std_logic_vector(0 downto 0);
    memory_space_0_lc_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_lc_data : in   std_logic_vector(63 downto 0);
    memory_space_0_lc_tag :  in  std_logic_vector(0 downto 0);
    memory_space_1_sr_req : out  std_logic_vector(0 downto 0);
    memory_space_1_sr_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_sr_addr : out  std_logic_vector(13 downto 0);
    memory_space_1_sr_data : out  std_logic_vector(63 downto 0);
    memory_space_1_sr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_1_sc_req : out  std_logic_vector(0 downto 0);
    memory_space_1_sc_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_sc_tag :  in  std_logic_vector(0 downto 0);
    Block0_complete_pipe_read_req : out  std_logic_vector(0 downto 0);
    Block0_complete_pipe_read_ack : in   std_logic_vector(0 downto 0);
    Block0_complete_pipe_read_data : in   std_logic_vector(15 downto 0);
    zeropad_input_pipe_pipe_read_req : out  std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_read_ack : in   std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_read_data : in   std_logic_vector(7 downto 0);
    zeropad_output_pipe_pipe_write_req : out  std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_write_ack : in   std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_write_data : out  std_logic_vector(7 downto 0);
    Block0_starting_pipe_write_req : out  std_logic_vector(0 downto 0);
    Block0_starting_pipe_write_ack : in   std_logic_vector(0 downto 0);
    Block0_starting_pipe_write_data : out  std_logic_vector(15 downto 0);
    timer_call_reqs : out  std_logic_vector(0 downto 0);
    timer_call_acks : in   std_logic_vector(0 downto 0);
    timer_call_tag  :  out  std_logic_vector(1 downto 0);
    timer_return_reqs : out  std_logic_vector(0 downto 0);
    timer_return_acks : in   std_logic_vector(0 downto 0);
    timer_return_data : in   std_logic_vector(63 downto 0);
    timer_return_tag :  in   std_logic_vector(1 downto 0);
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
end entity zeropad3D;
architecture zeropad3D_arch of zeropad3D is -- 
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
  signal zeropad3D_CP_182_start: Boolean;
  signal zeropad3D_CP_182_symbol: Boolean;
  -- volatile/operator module components. 
  component timer is -- 
    generic (tag_length : integer); 
    port ( -- 
      c : out  std_logic_vector(63 downto 0);
      memory_space_2_lr_req : out  std_logic_vector(0 downto 0);
      memory_space_2_lr_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_lr_addr : out  std_logic_vector(0 downto 0);
      memory_space_2_lr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_2_lc_req : out  std_logic_vector(0 downto 0);
      memory_space_2_lc_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_lc_data : in   std_logic_vector(63 downto 0);
      memory_space_2_lc_tag :  in  std_logic_vector(0 downto 0);
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
  signal type_cast_551_inst_req_1 : boolean;
  signal type_cast_561_inst_req_1 : boolean;
  signal type_cast_561_inst_ack_1 : boolean;
  signal type_cast_571_inst_req_0 : boolean;
  signal type_cast_571_inst_ack_0 : boolean;
  signal type_cast_451_inst_req_1 : boolean;
  signal ptr_deref_459_store_0_ack_0 : boolean;
  signal call_stmt_517_call_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_783_inst_ack_0 : boolean;
  signal ptr_deref_459_store_0_req_0 : boolean;
  signal type_cast_397_inst_req_0 : boolean;
  signal if_stmt_809_branch_req_0 : boolean;
  signal RPIPE_Block0_complete_513_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_503_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_503_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_503_inst_req_0 : boolean;
  signal type_cast_551_inst_req_0 : boolean;
  signal type_cast_531_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_506_inst_req_0 : boolean;
  signal type_cast_531_inst_ack_0 : boolean;
  signal type_cast_451_inst_ack_0 : boolean;
  signal if_stmt_809_branch_ack_0 : boolean;
  signal type_cast_415_inst_ack_1 : boolean;
  signal type_cast_415_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_783_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_506_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_491_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_503_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_491_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_789_inst_req_0 : boolean;
  signal type_cast_551_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_506_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_req_0 : boolean;
  signal phi_stmt_310_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_497_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_491_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_req_1 : boolean;
  signal RPIPE_Block0_complete_513_inst_req_1 : boolean;
  signal type_cast_531_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_491_inst_req_0 : boolean;
  signal type_cast_551_inst_ack_1 : boolean;
  signal type_cast_561_inst_req_0 : boolean;
  signal type_cast_561_inst_ack_0 : boolean;
  signal call_stmt_484_call_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_786_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_795_inst_ack_0 : boolean;
  signal type_cast_571_inst_req_1 : boolean;
  signal type_cast_571_inst_ack_1 : boolean;
  signal type_cast_531_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_786_inst_ack_1 : boolean;
  signal type_cast_415_inst_ack_0 : boolean;
  signal type_cast_451_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_req_0 : boolean;
  signal call_stmt_517_call_ack_1 : boolean;
  signal call_stmt_484_call_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_ack_0 : boolean;
  signal type_cast_415_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_497_inst_ack_1 : boolean;
  signal type_cast_379_inst_ack_1 : boolean;
  signal type_cast_230_inst_req_0 : boolean;
  signal type_cast_230_inst_ack_0 : boolean;
  signal type_cast_230_inst_req_1 : boolean;
  signal type_cast_230_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_789_inst_ack_0 : boolean;
  signal type_cast_239_inst_req_0 : boolean;
  signal type_cast_239_inst_ack_0 : boolean;
  signal type_cast_379_inst_req_1 : boolean;
  signal type_cast_239_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_783_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_509_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_509_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_497_inst_ack_0 : boolean;
  signal type_cast_67_inst_req_0 : boolean;
  signal type_cast_67_inst_ack_0 : boolean;
  signal type_cast_67_inst_req_1 : boolean;
  signal type_cast_67_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_ack_1 : boolean;
  signal type_cast_521_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_497_inst_req_0 : boolean;
  signal type_cast_80_inst_req_0 : boolean;
  signal type_cast_80_inst_ack_0 : boolean;
  signal type_cast_80_inst_req_1 : boolean;
  signal type_cast_80_inst_ack_1 : boolean;
  signal type_cast_541_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_ack_1 : boolean;
  signal type_cast_521_inst_req_1 : boolean;
  signal type_cast_92_inst_req_0 : boolean;
  signal type_cast_92_inst_ack_0 : boolean;
  signal type_cast_92_inst_req_1 : boolean;
  signal type_cast_92_inst_ack_1 : boolean;
  signal call_stmt_517_call_ack_0 : boolean;
  signal type_cast_541_inst_req_1 : boolean;
  signal WPIPE_Block0_starting_509_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_ack_1 : boolean;
  signal type_cast_105_inst_req_0 : boolean;
  signal type_cast_105_inst_ack_0 : boolean;
  signal type_cast_105_inst_req_1 : boolean;
  signal type_cast_105_inst_ack_1 : boolean;
  signal call_stmt_517_call_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_509_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_ack_1 : boolean;
  signal type_cast_117_inst_req_0 : boolean;
  signal type_cast_117_inst_ack_0 : boolean;
  signal type_cast_117_inst_req_1 : boolean;
  signal type_cast_117_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_req_1 : boolean;
  signal type_cast_130_inst_req_0 : boolean;
  signal type_cast_130_inst_ack_0 : boolean;
  signal type_cast_130_inst_req_1 : boolean;
  signal type_cast_130_inst_ack_1 : boolean;
  signal type_cast_541_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_500_inst_ack_1 : boolean;
  signal if_stmt_473_branch_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_ack_1 : boolean;
  signal type_cast_521_inst_ack_0 : boolean;
  signal type_cast_142_inst_req_0 : boolean;
  signal type_cast_142_inst_ack_0 : boolean;
  signal type_cast_142_inst_req_1 : boolean;
  signal type_cast_142_inst_ack_1 : boolean;
  signal type_cast_541_inst_req_0 : boolean;
  signal WPIPE_Block0_starting_500_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_795_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_ack_1 : boolean;
  signal type_cast_521_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_795_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_ack_0 : boolean;
  signal type_cast_155_inst_req_0 : boolean;
  signal type_cast_155_inst_ack_0 : boolean;
  signal type_cast_155_inst_req_1 : boolean;
  signal type_cast_155_inst_ack_1 : boolean;
  signal if_stmt_473_branch_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_494_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_494_inst_req_1 : boolean;
  signal type_cast_167_inst_req_0 : boolean;
  signal type_cast_167_inst_ack_0 : boolean;
  signal type_cast_167_inst_req_1 : boolean;
  signal type_cast_167_inst_ack_1 : boolean;
  signal if_stmt_809_branch_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_ack_1 : boolean;
  signal phi_stmt_681_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_req_0 : boolean;
  signal type_cast_180_inst_req_0 : boolean;
  signal type_cast_180_inst_ack_0 : boolean;
  signal type_cast_180_inst_req_1 : boolean;
  signal type_cast_180_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_783_inst_req_0 : boolean;
  signal WPIPE_Block0_starting_500_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_500_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_ack_1 : boolean;
  signal WPIPE_Block0_starting_494_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_494_inst_req_0 : boolean;
  signal type_cast_192_inst_req_0 : boolean;
  signal type_cast_192_inst_ack_0 : boolean;
  signal type_cast_192_inst_req_1 : boolean;
  signal type_cast_192_inst_ack_1 : boolean;
  signal if_stmt_473_branch_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_ack_1 : boolean;
  signal ptr_deref_459_store_0_ack_1 : boolean;
  signal type_cast_205_inst_req_0 : boolean;
  signal type_cast_205_inst_ack_0 : boolean;
  signal type_cast_205_inst_req_1 : boolean;
  signal type_cast_205_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_ack_1 : boolean;
  signal ptr_deref_459_store_0_req_1 : boolean;
  signal type_cast_488_inst_ack_1 : boolean;
  signal type_cast_217_inst_req_0 : boolean;
  signal type_cast_217_inst_ack_0 : boolean;
  signal type_cast_488_inst_req_1 : boolean;
  signal type_cast_217_inst_req_1 : boolean;
  signal type_cast_217_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_ack_0 : boolean;
  signal WPIPE_Block0_starting_506_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_ack_1 : boolean;
  signal type_cast_239_inst_ack_1 : boolean;
  signal type_cast_433_inst_ack_1 : boolean;
  signal type_cast_433_inst_req_1 : boolean;
  signal type_cast_488_inst_ack_0 : boolean;
  signal type_cast_243_inst_req_0 : boolean;
  signal type_cast_243_inst_ack_0 : boolean;
  signal type_cast_243_inst_req_1 : boolean;
  signal type_cast_243_inst_ack_1 : boolean;
  signal type_cast_397_inst_ack_1 : boolean;
  signal type_cast_397_inst_req_1 : boolean;
  signal type_cast_433_inst_ack_0 : boolean;
  signal type_cast_433_inst_req_0 : boolean;
  signal type_cast_488_inst_req_0 : boolean;
  signal type_cast_247_inst_req_0 : boolean;
  signal type_cast_451_inst_ack_1 : boolean;
  signal type_cast_247_inst_ack_0 : boolean;
  signal type_cast_247_inst_req_1 : boolean;
  signal type_cast_247_inst_ack_1 : boolean;
  signal RPIPE_Block0_complete_513_inst_ack_0 : boolean;
  signal RPIPE_Block0_complete_513_inst_req_0 : boolean;
  signal call_stmt_484_call_ack_1 : boolean;
  signal call_stmt_484_call_req_1 : boolean;
  signal type_cast_397_inst_ack_0 : boolean;
  signal if_stmt_282_branch_req_0 : boolean;
  signal if_stmt_282_branch_ack_1 : boolean;
  signal if_stmt_282_branch_ack_0 : boolean;
  signal array_obj_ref_322_index_offset_req_0 : boolean;
  signal array_obj_ref_322_index_offset_ack_0 : boolean;
  signal array_obj_ref_322_index_offset_req_1 : boolean;
  signal array_obj_ref_322_index_offset_ack_1 : boolean;
  signal addr_of_323_final_reg_req_0 : boolean;
  signal addr_of_323_final_reg_ack_0 : boolean;
  signal addr_of_323_final_reg_req_1 : boolean;
  signal addr_of_323_final_reg_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_789_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_789_inst_ack_1 : boolean;
  signal type_cast_330_inst_req_0 : boolean;
  signal type_cast_330_inst_ack_0 : boolean;
  signal type_cast_330_inst_req_1 : boolean;
  signal type_cast_330_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_339_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_339_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_339_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_339_inst_ack_1 : boolean;
  signal type_cast_343_inst_req_0 : boolean;
  signal type_cast_343_inst_ack_0 : boolean;
  signal type_cast_343_inst_req_1 : boolean;
  signal type_cast_343_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_357_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_357_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_357_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_357_inst_ack_1 : boolean;
  signal type_cast_361_inst_req_0 : boolean;
  signal type_cast_361_inst_ack_0 : boolean;
  signal type_cast_361_inst_req_1 : boolean;
  signal type_cast_361_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_375_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_375_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_375_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_375_inst_ack_1 : boolean;
  signal type_cast_379_inst_req_0 : boolean;
  signal type_cast_379_inst_ack_0 : boolean;
  signal type_cast_581_inst_req_0 : boolean;
  signal type_cast_581_inst_ack_0 : boolean;
  signal type_cast_581_inst_req_1 : boolean;
  signal type_cast_581_inst_ack_1 : boolean;
  signal type_cast_591_inst_req_0 : boolean;
  signal type_cast_591_inst_ack_0 : boolean;
  signal type_cast_591_inst_req_1 : boolean;
  signal type_cast_591_inst_ack_1 : boolean;
  signal type_cast_601_inst_req_0 : boolean;
  signal type_cast_601_inst_ack_0 : boolean;
  signal type_cast_601_inst_req_1 : boolean;
  signal type_cast_601_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_603_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_603_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_795_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_603_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_603_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_606_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_606_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_606_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_606_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_609_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_609_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_609_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_609_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_612_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_612_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_612_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_612_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_615_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_615_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_615_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_615_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_618_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_618_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_618_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_618_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_621_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_621_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_621_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_621_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_624_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_624_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_624_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_624_inst_ack_1 : boolean;
  signal type_cast_630_inst_req_0 : boolean;
  signal type_cast_630_inst_ack_0 : boolean;
  signal type_cast_630_inst_req_1 : boolean;
  signal type_cast_630_inst_ack_1 : boolean;
  signal type_cast_634_inst_req_0 : boolean;
  signal type_cast_634_inst_ack_0 : boolean;
  signal type_cast_634_inst_req_1 : boolean;
  signal type_cast_634_inst_ack_1 : boolean;
  signal phi_stmt_310_ack_0 : boolean;
  signal type_cast_638_inst_req_0 : boolean;
  signal type_cast_638_inst_ack_0 : boolean;
  signal type_cast_638_inst_req_1 : boolean;
  signal type_cast_638_inst_ack_1 : boolean;
  signal if_stmt_668_branch_req_0 : boolean;
  signal phi_stmt_681_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_786_inst_ack_0 : boolean;
  signal if_stmt_668_branch_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_786_inst_req_0 : boolean;
  signal if_stmt_668_branch_ack_0 : boolean;
  signal type_cast_677_inst_req_0 : boolean;
  signal type_cast_677_inst_ack_0 : boolean;
  signal type_cast_677_inst_req_1 : boolean;
  signal type_cast_677_inst_ack_1 : boolean;
  signal phi_stmt_681_req_1 : boolean;
  signal phi_stmt_310_req_1 : boolean;
  signal type_cast_316_inst_ack_1 : boolean;
  signal type_cast_687_inst_ack_1 : boolean;
  signal type_cast_316_inst_req_1 : boolean;
  signal array_obj_ref_693_index_offset_req_0 : boolean;
  signal array_obj_ref_693_index_offset_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_792_inst_ack_1 : boolean;
  signal array_obj_ref_693_index_offset_req_1 : boolean;
  signal array_obj_ref_693_index_offset_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_792_inst_req_1 : boolean;
  signal addr_of_694_final_reg_req_0 : boolean;
  signal addr_of_694_final_reg_ack_0 : boolean;
  signal addr_of_694_final_reg_req_1 : boolean;
  signal addr_of_694_final_reg_ack_1 : boolean;
  signal type_cast_316_inst_ack_0 : boolean;
  signal type_cast_316_inst_req_0 : boolean;
  signal type_cast_687_inst_req_1 : boolean;
  signal ptr_deref_698_load_0_req_0 : boolean;
  signal ptr_deref_698_load_0_ack_0 : boolean;
  signal ptr_deref_698_load_0_req_1 : boolean;
  signal ptr_deref_698_load_0_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_780_inst_req_0 : boolean;
  signal type_cast_702_inst_req_0 : boolean;
  signal type_cast_702_inst_ack_0 : boolean;
  signal type_cast_702_inst_req_1 : boolean;
  signal type_cast_702_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_780_inst_ack_1 : boolean;
  signal type_cast_712_inst_req_0 : boolean;
  signal type_cast_712_inst_ack_0 : boolean;
  signal type_cast_687_inst_ack_0 : boolean;
  signal type_cast_712_inst_req_1 : boolean;
  signal type_cast_712_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_780_inst_req_1 : boolean;
  signal type_cast_722_inst_req_0 : boolean;
  signal type_cast_722_inst_ack_0 : boolean;
  signal type_cast_687_inst_req_0 : boolean;
  signal type_cast_722_inst_req_1 : boolean;
  signal type_cast_722_inst_ack_1 : boolean;
  signal type_cast_732_inst_req_0 : boolean;
  signal type_cast_732_inst_ack_0 : boolean;
  signal type_cast_732_inst_req_1 : boolean;
  signal type_cast_732_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_780_inst_ack_0 : boolean;
  signal type_cast_742_inst_req_0 : boolean;
  signal type_cast_742_inst_ack_0 : boolean;
  signal type_cast_742_inst_req_1 : boolean;
  signal type_cast_742_inst_ack_1 : boolean;
  signal type_cast_752_inst_req_0 : boolean;
  signal type_cast_752_inst_ack_0 : boolean;
  signal type_cast_752_inst_req_1 : boolean;
  signal type_cast_752_inst_ack_1 : boolean;
  signal type_cast_762_inst_req_0 : boolean;
  signal type_cast_762_inst_ack_0 : boolean;
  signal type_cast_762_inst_req_1 : boolean;
  signal type_cast_762_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_792_inst_ack_0 : boolean;
  signal type_cast_772_inst_req_0 : boolean;
  signal type_cast_772_inst_ack_0 : boolean;
  signal type_cast_772_inst_req_1 : boolean;
  signal type_cast_772_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_792_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_774_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_774_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_774_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_774_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_777_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_777_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_777_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_777_inst_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "zeropad3D_input_buffer", -- 
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
  zeropad3D_CP_182_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "zeropad3D_out_buffer", -- 
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
    preds <= zeropad3D_CP_182_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
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
    preds <= zeropad3D_CP_182_start & tag_ilock_write_ack_symbol;
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
    preds <= zeropad3D_CP_182_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  zeropad3D_CP_182: Block -- control-path 
    signal zeropad3D_CP_182_elements: BooleanArray(255 downto 0);
    -- 
  begin -- 
    zeropad3D_CP_182_elements(0) <= zeropad3D_CP_182_start;
    zeropad3D_CP_182_symbol <= zeropad3D_CP_182_elements(255);
    -- CP-element group 0:  fork  transition  place  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	40 
    -- CP-element group 0: 	28 
    -- CP-element group 0: 	36 
    -- CP-element group 0: 	32 
    -- CP-element group 0: 	48 
    -- CP-element group 0: 	52 
    -- CP-element group 0: 	56 
    -- CP-element group 0: 	60 
    -- CP-element group 0: 	44 
    -- CP-element group 0: 	64 
    -- CP-element group 0: 	67 
    -- CP-element group 0: 	70 
    -- CP-element group 0: 	73 
    -- CP-element group 0: 	1 
    -- CP-element group 0: 	12 
    -- CP-element group 0: 	16 
    -- CP-element group 0: 	20 
    -- CP-element group 0: 	24 
    -- CP-element group 0:  members (59) 
      -- CP-element group 0: 	 $entry
      -- CP-element group 0: 	 branch_block_stmt_49/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/branch_block_stmt_49__entry__
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281__entry__
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_sample_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/rr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/cr
      -- 
    rr_246_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_246_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => RPIPE_zeropad_input_pipe_51_inst_req_0); -- 
    cr_685_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_685_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_230_inst_req_1); -- 
    cr_699_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_699_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_239_inst_req_1); -- 
    cr_321_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_321_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_67_inst_req_1); -- 
    cr_349_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_349_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_80_inst_req_1); -- 
    cr_377_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_377_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_92_inst_req_1); -- 
    cr_405_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_405_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_105_inst_req_1); -- 
    cr_433_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_433_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_117_inst_req_1); -- 
    cr_461_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_461_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_130_inst_req_1); -- 
    cr_489_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_489_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_142_inst_req_1); -- 
    cr_517_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_517_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_155_inst_req_1); -- 
    cr_545_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_545_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_167_inst_req_1); -- 
    cr_573_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_573_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_180_inst_req_1); -- 
    cr_601_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_601_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_192_inst_req_1); -- 
    cr_629_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_629_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_205_inst_req_1); -- 
    cr_657_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_657_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_217_inst_req_1); -- 
    cr_713_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_713_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_243_inst_req_1); -- 
    cr_727_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_727_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_247_inst_req_1); -- 
    -- CP-element group 1:  transition  input  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	0 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	2 
    -- CP-element group 1:  members (6) 
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_sample_completed_
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_update_start_
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/$exit
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/ra
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/$entry
      -- CP-element group 1: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/cr
      -- 
    ra_247_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 1_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_51_inst_ack_0, ack => zeropad3D_CP_182_elements(1)); -- 
    cr_251_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_251_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(1), ack => RPIPE_zeropad_input_pipe_51_inst_req_1); -- 
    -- CP-element group 2:  transition  input  output  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	1 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	3 
    -- CP-element group 2:  members (6) 
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_update_completed_
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/$exit
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/ca
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_sample_start_
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/$entry
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/rr
      -- 
    ca_252_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_51_inst_ack_1, ack => zeropad3D_CP_182_elements(2)); -- 
    rr_260_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_260_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(2), ack => RPIPE_zeropad_input_pipe_54_inst_req_0); -- 
    -- CP-element group 3:  transition  input  output  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: 	2 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	4 
    -- CP-element group 3:  members (6) 
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_sample_completed_
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_update_start_
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/$exit
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/ra
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/$entry
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/cr
      -- 
    ra_261_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 3_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_54_inst_ack_0, ack => zeropad3D_CP_182_elements(3)); -- 
    cr_265_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_265_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(3), ack => RPIPE_zeropad_input_pipe_54_inst_req_1); -- 
    -- CP-element group 4:  transition  input  output  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	3 
    -- CP-element group 4: successors 
    -- CP-element group 4: 	5 
    -- CP-element group 4:  members (6) 
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/$entry
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/rr
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_update_completed_
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/$exit
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/ca
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_sample_start_
      -- 
    ca_266_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 4_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_54_inst_ack_1, ack => zeropad3D_CP_182_elements(4)); -- 
    rr_274_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_274_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(4), ack => RPIPE_zeropad_input_pipe_57_inst_req_0); -- 
    -- CP-element group 5:  transition  input  output  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	4 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	6 
    -- CP-element group 5:  members (6) 
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_update_start_
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/$exit
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/ra
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/$entry
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/cr
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_sample_completed_
      -- 
    ra_275_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_57_inst_ack_0, ack => zeropad3D_CP_182_elements(5)); -- 
    cr_279_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_279_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(5), ack => RPIPE_zeropad_input_pipe_57_inst_req_1); -- 
    -- CP-element group 6:  transition  input  output  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	5 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	7 
    -- CP-element group 6:  members (6) 
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_update_completed_
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/$exit
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/ca
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_sample_start_
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/$entry
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/rr
      -- 
    ca_280_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 6_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_57_inst_ack_1, ack => zeropad3D_CP_182_elements(6)); -- 
    rr_288_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_288_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(6), ack => RPIPE_zeropad_input_pipe_60_inst_req_0); -- 
    -- CP-element group 7:  transition  input  output  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	6 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	8 
    -- CP-element group 7:  members (6) 
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_sample_completed_
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_update_start_
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/$exit
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/ra
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/$entry
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/cr
      -- 
    ra_289_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 7_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_60_inst_ack_0, ack => zeropad3D_CP_182_elements(7)); -- 
    cr_293_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_293_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(7), ack => RPIPE_zeropad_input_pipe_60_inst_req_1); -- 
    -- CP-element group 8:  transition  input  output  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	7 
    -- CP-element group 8: successors 
    -- CP-element group 8: 	9 
    -- CP-element group 8:  members (6) 
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_update_completed_
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/$exit
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/ca
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_sample_start_
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/$entry
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/rr
      -- 
    ca_294_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 8_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_60_inst_ack_1, ack => zeropad3D_CP_182_elements(8)); -- 
    rr_302_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_302_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(8), ack => RPIPE_zeropad_input_pipe_63_inst_req_0); -- 
    -- CP-element group 9:  transition  input  output  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	8 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	10 
    -- CP-element group 9:  members (6) 
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_sample_completed_
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_update_start_
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/$exit
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/ra
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/$entry
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/cr
      -- 
    ra_303_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 9_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_63_inst_ack_0, ack => zeropad3D_CP_182_elements(9)); -- 
    cr_307_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_307_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(9), ack => RPIPE_zeropad_input_pipe_63_inst_req_1); -- 
    -- CP-element group 10:  fork  transition  input  output  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	9 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	11 
    -- CP-element group 10: 	13 
    -- CP-element group 10:  members (9) 
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_update_completed_
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/$exit
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/ca
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_sample_start_
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/$entry
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/rr
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_sample_start_
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/$entry
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/rr
      -- 
    ca_308_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_63_inst_ack_1, ack => zeropad3D_CP_182_elements(10)); -- 
    rr_316_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_316_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(10), ack => type_cast_67_inst_req_0); -- 
    rr_330_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_330_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(10), ack => RPIPE_zeropad_input_pipe_76_inst_req_0); -- 
    -- CP-element group 11:  transition  input  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	10 
    -- CP-element group 11: successors 
    -- CP-element group 11:  members (3) 
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_sample_completed_
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/$exit
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/ra
      -- 
    ra_317_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_67_inst_ack_0, ack => zeropad3D_CP_182_elements(11)); -- 
    -- CP-element group 12:  transition  input  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	0 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	65 
    -- CP-element group 12:  members (3) 
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_update_completed_
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/$exit
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/ca
      -- 
    ca_322_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 12_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_67_inst_ack_1, ack => zeropad3D_CP_182_elements(12)); -- 
    -- CP-element group 13:  transition  input  output  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	10 
    -- CP-element group 13: successors 
    -- CP-element group 13: 	14 
    -- CP-element group 13:  members (6) 
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_sample_completed_
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_update_start_
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/$exit
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/ra
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/$entry
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/cr
      -- 
    ra_331_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_76_inst_ack_0, ack => zeropad3D_CP_182_elements(13)); -- 
    cr_335_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_335_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(13), ack => RPIPE_zeropad_input_pipe_76_inst_req_1); -- 
    -- CP-element group 14:  fork  transition  input  output  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	13 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14: 	17 
    -- CP-element group 14:  members (9) 
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_update_completed_
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/$exit
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/ca
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_sample_start_
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/$entry
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/rr
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_sample_start_
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/$entry
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/rr
      -- 
    ca_336_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_76_inst_ack_1, ack => zeropad3D_CP_182_elements(14)); -- 
    rr_344_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_344_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(14), ack => type_cast_80_inst_req_0); -- 
    rr_358_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_358_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(14), ack => RPIPE_zeropad_input_pipe_88_inst_req_0); -- 
    -- CP-element group 15:  transition  input  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: successors 
    -- CP-element group 15:  members (3) 
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_sample_completed_
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/$exit
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/ra
      -- 
    ra_345_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 15_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_80_inst_ack_0, ack => zeropad3D_CP_182_elements(15)); -- 
    -- CP-element group 16:  transition  input  bypass 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	0 
    -- CP-element group 16: successors 
    -- CP-element group 16: 	65 
    -- CP-element group 16:  members (3) 
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_update_completed_
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/$exit
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/ca
      -- 
    ca_350_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 16_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_80_inst_ack_1, ack => zeropad3D_CP_182_elements(16)); -- 
    -- CP-element group 17:  transition  input  output  bypass 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: 	14 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	18 
    -- CP-element group 17:  members (6) 
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_sample_completed_
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_update_start_
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/$exit
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/ra
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/$entry
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/cr
      -- 
    ra_359_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 17_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_88_inst_ack_0, ack => zeropad3D_CP_182_elements(17)); -- 
    cr_363_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_363_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(17), ack => RPIPE_zeropad_input_pipe_88_inst_req_1); -- 
    -- CP-element group 18:  fork  transition  input  output  bypass 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	17 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	19 
    -- CP-element group 18: 	21 
    -- CP-element group 18:  members (9) 
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_update_completed_
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/$exit
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/ca
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_sample_start_
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/$entry
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/rr
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_sample_start_
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/$entry
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/rr
      -- 
    ca_364_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 18_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_88_inst_ack_1, ack => zeropad3D_CP_182_elements(18)); -- 
    rr_372_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_372_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(18), ack => type_cast_92_inst_req_0); -- 
    rr_386_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_386_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(18), ack => RPIPE_zeropad_input_pipe_101_inst_req_0); -- 
    -- CP-element group 19:  transition  input  bypass 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	18 
    -- CP-element group 19: successors 
    -- CP-element group 19:  members (3) 
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_sample_completed_
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/$exit
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/ra
      -- 
    ra_373_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 19_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_92_inst_ack_0, ack => zeropad3D_CP_182_elements(19)); -- 
    -- CP-element group 20:  transition  input  bypass 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	0 
    -- CP-element group 20: successors 
    -- CP-element group 20: 	68 
    -- CP-element group 20:  members (3) 
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_update_completed_
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/$exit
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/ca
      -- 
    ca_378_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 20_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_92_inst_ack_1, ack => zeropad3D_CP_182_elements(20)); -- 
    -- CP-element group 21:  transition  input  output  bypass 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	18 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	22 
    -- CP-element group 21:  members (6) 
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_sample_completed_
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_update_start_
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/$exit
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/ra
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/$entry
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/cr
      -- 
    ra_387_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 21_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_101_inst_ack_0, ack => zeropad3D_CP_182_elements(21)); -- 
    cr_391_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_391_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(21), ack => RPIPE_zeropad_input_pipe_101_inst_req_1); -- 
    -- CP-element group 22:  fork  transition  input  output  bypass 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	21 
    -- CP-element group 22: successors 
    -- CP-element group 22: 	23 
    -- CP-element group 22: 	25 
    -- CP-element group 22:  members (9) 
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_update_completed_
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/$exit
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/ca
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_sample_start_
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/$entry
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/rr
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_sample_start_
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/$entry
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/rr
      -- 
    ca_392_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 22_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_101_inst_ack_1, ack => zeropad3D_CP_182_elements(22)); -- 
    rr_400_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_400_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(22), ack => type_cast_105_inst_req_0); -- 
    rr_414_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_414_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(22), ack => RPIPE_zeropad_input_pipe_113_inst_req_0); -- 
    -- CP-element group 23:  transition  input  bypass 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: 	22 
    -- CP-element group 23: successors 
    -- CP-element group 23:  members (3) 
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_sample_completed_
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/$exit
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/ra
      -- 
    ra_401_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 23_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_105_inst_ack_0, ack => zeropad3D_CP_182_elements(23)); -- 
    -- CP-element group 24:  transition  input  bypass 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	0 
    -- CP-element group 24: successors 
    -- CP-element group 24: 	68 
    -- CP-element group 24:  members (3) 
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_update_completed_
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/$exit
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/ca
      -- 
    ca_406_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 24_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_105_inst_ack_1, ack => zeropad3D_CP_182_elements(24)); -- 
    -- CP-element group 25:  transition  input  output  bypass 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	22 
    -- CP-element group 25: successors 
    -- CP-element group 25: 	26 
    -- CP-element group 25:  members (6) 
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_sample_completed_
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_update_start_
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/$exit
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/ra
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/$entry
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/cr
      -- 
    ra_415_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 25_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_113_inst_ack_0, ack => zeropad3D_CP_182_elements(25)); -- 
    cr_419_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_419_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(25), ack => RPIPE_zeropad_input_pipe_113_inst_req_1); -- 
    -- CP-element group 26:  fork  transition  input  output  bypass 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	25 
    -- CP-element group 26: successors 
    -- CP-element group 26: 	29 
    -- CP-element group 26: 	27 
    -- CP-element group 26:  members (9) 
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_update_completed_
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/$exit
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/ca
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_sample_start_
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/$entry
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/rr
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_sample_start_
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/$entry
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/rr
      -- 
    ca_420_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 26_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_113_inst_ack_1, ack => zeropad3D_CP_182_elements(26)); -- 
    rr_442_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_442_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(26), ack => RPIPE_zeropad_input_pipe_126_inst_req_0); -- 
    rr_428_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_428_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(26), ack => type_cast_117_inst_req_0); -- 
    -- CP-element group 27:  transition  input  bypass 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: 	26 
    -- CP-element group 27: successors 
    -- CP-element group 27:  members (3) 
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_sample_completed_
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/$exit
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/ra
      -- 
    ra_429_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 27_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_117_inst_ack_0, ack => zeropad3D_CP_182_elements(27)); -- 
    -- CP-element group 28:  transition  input  bypass 
    -- CP-element group 28: predecessors 
    -- CP-element group 28: 	0 
    -- CP-element group 28: successors 
    -- CP-element group 28: 	71 
    -- CP-element group 28:  members (3) 
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_update_completed_
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/$exit
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/ca
      -- 
    ca_434_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 28_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_117_inst_ack_1, ack => zeropad3D_CP_182_elements(28)); -- 
    -- CP-element group 29:  transition  input  output  bypass 
    -- CP-element group 29: predecessors 
    -- CP-element group 29: 	26 
    -- CP-element group 29: successors 
    -- CP-element group 29: 	30 
    -- CP-element group 29:  members (6) 
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_sample_completed_
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_update_start_
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/$exit
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/ra
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/$entry
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/cr
      -- 
    ra_443_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 29_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_126_inst_ack_0, ack => zeropad3D_CP_182_elements(29)); -- 
    cr_447_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_447_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(29), ack => RPIPE_zeropad_input_pipe_126_inst_req_1); -- 
    -- CP-element group 30:  fork  transition  input  output  bypass 
    -- CP-element group 30: predecessors 
    -- CP-element group 30: 	29 
    -- CP-element group 30: successors 
    -- CP-element group 30: 	33 
    -- CP-element group 30: 	31 
    -- CP-element group 30:  members (9) 
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_update_completed_
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/$exit
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/ca
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_sample_start_
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/$entry
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/rr
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_sample_start_
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/$entry
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/rr
      -- 
    ca_448_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 30_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_126_inst_ack_1, ack => zeropad3D_CP_182_elements(30)); -- 
    rr_456_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_456_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(30), ack => type_cast_130_inst_req_0); -- 
    rr_470_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_470_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(30), ack => RPIPE_zeropad_input_pipe_138_inst_req_0); -- 
    -- CP-element group 31:  transition  input  bypass 
    -- CP-element group 31: predecessors 
    -- CP-element group 31: 	30 
    -- CP-element group 31: successors 
    -- CP-element group 31:  members (3) 
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_sample_completed_
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/$exit
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/ra
      -- 
    ra_457_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 31_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_130_inst_ack_0, ack => zeropad3D_CP_182_elements(31)); -- 
    -- CP-element group 32:  transition  input  bypass 
    -- CP-element group 32: predecessors 
    -- CP-element group 32: 	0 
    -- CP-element group 32: successors 
    -- CP-element group 32: 	71 
    -- CP-element group 32:  members (3) 
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_update_completed_
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/$exit
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/ca
      -- 
    ca_462_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 32_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_130_inst_ack_1, ack => zeropad3D_CP_182_elements(32)); -- 
    -- CP-element group 33:  transition  input  output  bypass 
    -- CP-element group 33: predecessors 
    -- CP-element group 33: 	30 
    -- CP-element group 33: successors 
    -- CP-element group 33: 	34 
    -- CP-element group 33:  members (6) 
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_sample_completed_
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_update_start_
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/$exit
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/ra
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/$entry
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/cr
      -- 
    ra_471_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 33_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_138_inst_ack_0, ack => zeropad3D_CP_182_elements(33)); -- 
    cr_475_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_475_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(33), ack => RPIPE_zeropad_input_pipe_138_inst_req_1); -- 
    -- CP-element group 34:  fork  transition  input  output  bypass 
    -- CP-element group 34: predecessors 
    -- CP-element group 34: 	33 
    -- CP-element group 34: successors 
    -- CP-element group 34: 	37 
    -- CP-element group 34: 	35 
    -- CP-element group 34:  members (9) 
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_update_completed_
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/$exit
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/ca
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_sample_start_
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/$entry
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/rr
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_sample_start_
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/$entry
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/rr
      -- 
    ca_476_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 34_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_138_inst_ack_1, ack => zeropad3D_CP_182_elements(34)); -- 
    rr_498_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_498_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(34), ack => RPIPE_zeropad_input_pipe_151_inst_req_0); -- 
    rr_484_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_484_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(34), ack => type_cast_142_inst_req_0); -- 
    -- CP-element group 35:  transition  input  bypass 
    -- CP-element group 35: predecessors 
    -- CP-element group 35: 	34 
    -- CP-element group 35: successors 
    -- CP-element group 35:  members (3) 
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_sample_completed_
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/$exit
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/ra
      -- 
    ra_485_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 35_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_142_inst_ack_0, ack => zeropad3D_CP_182_elements(35)); -- 
    -- CP-element group 36:  transition  input  bypass 
    -- CP-element group 36: predecessors 
    -- CP-element group 36: 	0 
    -- CP-element group 36: successors 
    -- CP-element group 36: 	74 
    -- CP-element group 36:  members (3) 
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_update_completed_
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/$exit
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/ca
      -- 
    ca_490_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 36_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_142_inst_ack_1, ack => zeropad3D_CP_182_elements(36)); -- 
    -- CP-element group 37:  transition  input  output  bypass 
    -- CP-element group 37: predecessors 
    -- CP-element group 37: 	34 
    -- CP-element group 37: successors 
    -- CP-element group 37: 	38 
    -- CP-element group 37:  members (6) 
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_sample_completed_
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_update_start_
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/$exit
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/ra
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/$entry
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/cr
      -- 
    ra_499_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 37_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_151_inst_ack_0, ack => zeropad3D_CP_182_elements(37)); -- 
    cr_503_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_503_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(37), ack => RPIPE_zeropad_input_pipe_151_inst_req_1); -- 
    -- CP-element group 38:  fork  transition  input  output  bypass 
    -- CP-element group 38: predecessors 
    -- CP-element group 38: 	37 
    -- CP-element group 38: successors 
    -- CP-element group 38: 	39 
    -- CP-element group 38: 	41 
    -- CP-element group 38:  members (9) 
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_update_completed_
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/$exit
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/ca
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_sample_start_
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/$entry
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/rr
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_sample_start_
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/$entry
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/rr
      -- 
    ca_504_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 38_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_151_inst_ack_1, ack => zeropad3D_CP_182_elements(38)); -- 
    rr_526_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_526_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(38), ack => RPIPE_zeropad_input_pipe_163_inst_req_0); -- 
    rr_512_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_512_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(38), ack => type_cast_155_inst_req_0); -- 
    -- CP-element group 39:  transition  input  bypass 
    -- CP-element group 39: predecessors 
    -- CP-element group 39: 	38 
    -- CP-element group 39: successors 
    -- CP-element group 39:  members (3) 
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_sample_completed_
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/$exit
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/ra
      -- 
    ra_513_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 39_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_155_inst_ack_0, ack => zeropad3D_CP_182_elements(39)); -- 
    -- CP-element group 40:  transition  input  bypass 
    -- CP-element group 40: predecessors 
    -- CP-element group 40: 	0 
    -- CP-element group 40: successors 
    -- CP-element group 40: 	74 
    -- CP-element group 40:  members (3) 
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_update_completed_
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/$exit
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/ca
      -- 
    ca_518_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 40_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_155_inst_ack_1, ack => zeropad3D_CP_182_elements(40)); -- 
    -- CP-element group 41:  transition  input  output  bypass 
    -- CP-element group 41: predecessors 
    -- CP-element group 41: 	38 
    -- CP-element group 41: successors 
    -- CP-element group 41: 	42 
    -- CP-element group 41:  members (6) 
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_sample_completed_
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_update_start_
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/$exit
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/ra
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/$entry
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/cr
      -- 
    ra_527_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 41_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_163_inst_ack_0, ack => zeropad3D_CP_182_elements(41)); -- 
    cr_531_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_531_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(41), ack => RPIPE_zeropad_input_pipe_163_inst_req_1); -- 
    -- CP-element group 42:  fork  transition  input  output  bypass 
    -- CP-element group 42: predecessors 
    -- CP-element group 42: 	41 
    -- CP-element group 42: successors 
    -- CP-element group 42: 	43 
    -- CP-element group 42: 	45 
    -- CP-element group 42:  members (9) 
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_update_completed_
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/$exit
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/ca
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_sample_start_
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/$entry
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/rr
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_sample_start_
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/$entry
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/rr
      -- 
    ca_532_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 42_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_163_inst_ack_1, ack => zeropad3D_CP_182_elements(42)); -- 
    rr_540_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_540_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(42), ack => type_cast_167_inst_req_0); -- 
    rr_554_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_554_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(42), ack => RPIPE_zeropad_input_pipe_176_inst_req_0); -- 
    -- CP-element group 43:  transition  input  bypass 
    -- CP-element group 43: predecessors 
    -- CP-element group 43: 	42 
    -- CP-element group 43: successors 
    -- CP-element group 43:  members (3) 
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_sample_completed_
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/$exit
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/ra
      -- 
    ra_541_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 43_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_167_inst_ack_0, ack => zeropad3D_CP_182_elements(43)); -- 
    -- CP-element group 44:  transition  input  bypass 
    -- CP-element group 44: predecessors 
    -- CP-element group 44: 	0 
    -- CP-element group 44: successors 
    -- CP-element group 44: 	74 
    -- CP-element group 44:  members (3) 
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_update_completed_
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/$exit
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/ca
      -- 
    ca_546_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 44_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_167_inst_ack_1, ack => zeropad3D_CP_182_elements(44)); -- 
    -- CP-element group 45:  transition  input  output  bypass 
    -- CP-element group 45: predecessors 
    -- CP-element group 45: 	42 
    -- CP-element group 45: successors 
    -- CP-element group 45: 	46 
    -- CP-element group 45:  members (6) 
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_sample_completed_
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_update_start_
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/$exit
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/ra
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/$entry
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/cr
      -- 
    ra_555_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 45_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_176_inst_ack_0, ack => zeropad3D_CP_182_elements(45)); -- 
    cr_559_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_559_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(45), ack => RPIPE_zeropad_input_pipe_176_inst_req_1); -- 
    -- CP-element group 46:  fork  transition  input  output  bypass 
    -- CP-element group 46: predecessors 
    -- CP-element group 46: 	45 
    -- CP-element group 46: successors 
    -- CP-element group 46: 	47 
    -- CP-element group 46: 	49 
    -- CP-element group 46:  members (9) 
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_update_completed_
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/$exit
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/ca
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_sample_start_
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/$entry
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/rr
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_sample_start_
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/$entry
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/rr
      -- 
    ca_560_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 46_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_176_inst_ack_1, ack => zeropad3D_CP_182_elements(46)); -- 
    rr_568_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_568_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(46), ack => type_cast_180_inst_req_0); -- 
    rr_582_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_582_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(46), ack => RPIPE_zeropad_input_pipe_188_inst_req_0); -- 
    -- CP-element group 47:  transition  input  bypass 
    -- CP-element group 47: predecessors 
    -- CP-element group 47: 	46 
    -- CP-element group 47: successors 
    -- CP-element group 47:  members (3) 
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_sample_completed_
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/$exit
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/ra
      -- 
    ra_569_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 47_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_180_inst_ack_0, ack => zeropad3D_CP_182_elements(47)); -- 
    -- CP-element group 48:  transition  input  bypass 
    -- CP-element group 48: predecessors 
    -- CP-element group 48: 	0 
    -- CP-element group 48: successors 
    -- CP-element group 48: 	74 
    -- CP-element group 48:  members (3) 
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_update_completed_
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/$exit
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/ca
      -- 
    ca_574_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 48_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_180_inst_ack_1, ack => zeropad3D_CP_182_elements(48)); -- 
    -- CP-element group 49:  transition  input  output  bypass 
    -- CP-element group 49: predecessors 
    -- CP-element group 49: 	46 
    -- CP-element group 49: successors 
    -- CP-element group 49: 	50 
    -- CP-element group 49:  members (6) 
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_sample_completed_
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_update_start_
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/$exit
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/ra
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/$entry
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/cr
      -- 
    ra_583_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 49_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_188_inst_ack_0, ack => zeropad3D_CP_182_elements(49)); -- 
    cr_587_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_587_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(49), ack => RPIPE_zeropad_input_pipe_188_inst_req_1); -- 
    -- CP-element group 50:  fork  transition  input  output  bypass 
    -- CP-element group 50: predecessors 
    -- CP-element group 50: 	49 
    -- CP-element group 50: successors 
    -- CP-element group 50: 	51 
    -- CP-element group 50: 	53 
    -- CP-element group 50:  members (9) 
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_update_completed_
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/$exit
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/ca
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_sample_start_
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/$entry
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/rr
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_sample_start_
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/$entry
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/rr
      -- 
    ca_588_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 50_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_188_inst_ack_1, ack => zeropad3D_CP_182_elements(50)); -- 
    rr_596_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_596_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(50), ack => type_cast_192_inst_req_0); -- 
    rr_610_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_610_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(50), ack => RPIPE_zeropad_input_pipe_201_inst_req_0); -- 
    -- CP-element group 51:  transition  input  bypass 
    -- CP-element group 51: predecessors 
    -- CP-element group 51: 	50 
    -- CP-element group 51: successors 
    -- CP-element group 51:  members (3) 
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_sample_completed_
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/$exit
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/ra
      -- 
    ra_597_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 51_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_192_inst_ack_0, ack => zeropad3D_CP_182_elements(51)); -- 
    -- CP-element group 52:  transition  input  bypass 
    -- CP-element group 52: predecessors 
    -- CP-element group 52: 	0 
    -- CP-element group 52: successors 
    -- CP-element group 52: 	74 
    -- CP-element group 52:  members (3) 
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_update_completed_
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/$exit
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/ca
      -- 
    ca_602_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 52_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_192_inst_ack_1, ack => zeropad3D_CP_182_elements(52)); -- 
    -- CP-element group 53:  transition  input  output  bypass 
    -- CP-element group 53: predecessors 
    -- CP-element group 53: 	50 
    -- CP-element group 53: successors 
    -- CP-element group 53: 	54 
    -- CP-element group 53:  members (6) 
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_sample_completed_
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_update_start_
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/$exit
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/ra
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/$entry
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/cr
      -- 
    ra_611_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 53_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_201_inst_ack_0, ack => zeropad3D_CP_182_elements(53)); -- 
    cr_615_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_615_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(53), ack => RPIPE_zeropad_input_pipe_201_inst_req_1); -- 
    -- CP-element group 54:  fork  transition  input  output  bypass 
    -- CP-element group 54: predecessors 
    -- CP-element group 54: 	53 
    -- CP-element group 54: successors 
    -- CP-element group 54: 	55 
    -- CP-element group 54: 	57 
    -- CP-element group 54:  members (9) 
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_update_completed_
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/$exit
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/ca
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_sample_start_
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/$entry
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/rr
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_sample_start_
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/$entry
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/rr
      -- 
    ca_616_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 54_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_201_inst_ack_1, ack => zeropad3D_CP_182_elements(54)); -- 
    rr_624_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_624_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(54), ack => type_cast_205_inst_req_0); -- 
    rr_638_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_638_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(54), ack => RPIPE_zeropad_input_pipe_213_inst_req_0); -- 
    -- CP-element group 55:  transition  input  bypass 
    -- CP-element group 55: predecessors 
    -- CP-element group 55: 	54 
    -- CP-element group 55: successors 
    -- CP-element group 55:  members (3) 
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_sample_completed_
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/$exit
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/ra
      -- 
    ra_625_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 55_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_205_inst_ack_0, ack => zeropad3D_CP_182_elements(55)); -- 
    -- CP-element group 56:  transition  input  bypass 
    -- CP-element group 56: predecessors 
    -- CP-element group 56: 	0 
    -- CP-element group 56: successors 
    -- CP-element group 56: 	74 
    -- CP-element group 56:  members (3) 
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_update_completed_
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/$exit
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/ca
      -- 
    ca_630_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 56_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_205_inst_ack_1, ack => zeropad3D_CP_182_elements(56)); -- 
    -- CP-element group 57:  transition  input  output  bypass 
    -- CP-element group 57: predecessors 
    -- CP-element group 57: 	54 
    -- CP-element group 57: successors 
    -- CP-element group 57: 	58 
    -- CP-element group 57:  members (6) 
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_sample_completed_
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_update_start_
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/$exit
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/ra
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/$entry
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/cr
      -- 
    ra_639_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 57_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_213_inst_ack_0, ack => zeropad3D_CP_182_elements(57)); -- 
    cr_643_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_643_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(57), ack => RPIPE_zeropad_input_pipe_213_inst_req_1); -- 
    -- CP-element group 58:  fork  transition  input  output  bypass 
    -- CP-element group 58: predecessors 
    -- CP-element group 58: 	57 
    -- CP-element group 58: successors 
    -- CP-element group 58: 	59 
    -- CP-element group 58: 	61 
    -- CP-element group 58:  members (9) 
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_update_completed_
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/$exit
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/ca
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_sample_start_
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/$entry
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/rr
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_sample_start_
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/$entry
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/rr
      -- 
    ca_644_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 58_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_213_inst_ack_1, ack => zeropad3D_CP_182_elements(58)); -- 
    rr_652_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_652_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(58), ack => type_cast_217_inst_req_0); -- 
    rr_666_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_666_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(58), ack => RPIPE_zeropad_input_pipe_226_inst_req_0); -- 
    -- CP-element group 59:  transition  input  bypass 
    -- CP-element group 59: predecessors 
    -- CP-element group 59: 	58 
    -- CP-element group 59: successors 
    -- CP-element group 59:  members (3) 
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_sample_completed_
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/$exit
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/ra
      -- 
    ra_653_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 59_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_217_inst_ack_0, ack => zeropad3D_CP_182_elements(59)); -- 
    -- CP-element group 60:  transition  input  bypass 
    -- CP-element group 60: predecessors 
    -- CP-element group 60: 	0 
    -- CP-element group 60: successors 
    -- CP-element group 60: 	74 
    -- CP-element group 60:  members (3) 
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_update_completed_
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/$exit
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/ca
      -- 
    ca_658_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 60_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_217_inst_ack_1, ack => zeropad3D_CP_182_elements(60)); -- 
    -- CP-element group 61:  transition  input  output  bypass 
    -- CP-element group 61: predecessors 
    -- CP-element group 61: 	58 
    -- CP-element group 61: successors 
    -- CP-element group 61: 	62 
    -- CP-element group 61:  members (6) 
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_sample_completed_
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_update_start_
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/$exit
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/ra
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/$entry
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/cr
      -- 
    ra_667_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 61_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_226_inst_ack_0, ack => zeropad3D_CP_182_elements(61)); -- 
    cr_671_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_671_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(61), ack => RPIPE_zeropad_input_pipe_226_inst_req_1); -- 
    -- CP-element group 62:  transition  input  output  bypass 
    -- CP-element group 62: predecessors 
    -- CP-element group 62: 	61 
    -- CP-element group 62: successors 
    -- CP-element group 62: 	63 
    -- CP-element group 62:  members (6) 
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_sample_start_
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/$entry
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/rr
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_update_completed_
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/$exit
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/ca
      -- 
    ca_672_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 62_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_226_inst_ack_1, ack => zeropad3D_CP_182_elements(62)); -- 
    rr_680_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_680_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(62), ack => type_cast_230_inst_req_0); -- 
    -- CP-element group 63:  transition  input  bypass 
    -- CP-element group 63: predecessors 
    -- CP-element group 63: 	62 
    -- CP-element group 63: successors 
    -- CP-element group 63:  members (3) 
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_sample_completed_
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/$exit
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/ra
      -- 
    ra_681_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 63_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_230_inst_ack_0, ack => zeropad3D_CP_182_elements(63)); -- 
    -- CP-element group 64:  transition  input  bypass 
    -- CP-element group 64: predecessors 
    -- CP-element group 64: 	0 
    -- CP-element group 64: successors 
    -- CP-element group 64: 	74 
    -- CP-element group 64:  members (3) 
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_update_completed_
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/$exit
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/ca
      -- 
    ca_686_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 64_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_230_inst_ack_1, ack => zeropad3D_CP_182_elements(64)); -- 
    -- CP-element group 65:  join  transition  output  bypass 
    -- CP-element group 65: predecessors 
    -- CP-element group 65: 	12 
    -- CP-element group 65: 	16 
    -- CP-element group 65: successors 
    -- CP-element group 65: 	66 
    -- CP-element group 65:  members (3) 
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_sample_start_
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/$entry
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/rr
      -- 
    rr_694_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_694_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(65), ack => type_cast_239_inst_req_0); -- 
    zeropad3D_cp_element_group_65: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_65"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(12) & zeropad3D_CP_182_elements(16);
      gj_zeropad3D_cp_element_group_65 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(65), clk => clk, reset => reset); --
    end block;
    -- CP-element group 66:  transition  input  bypass 
    -- CP-element group 66: predecessors 
    -- CP-element group 66: 	65 
    -- CP-element group 66: successors 
    -- CP-element group 66:  members (3) 
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_sample_completed_
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/$exit
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/ra
      -- 
    ra_695_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 66_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_239_inst_ack_0, ack => zeropad3D_CP_182_elements(66)); -- 
    -- CP-element group 67:  transition  input  bypass 
    -- CP-element group 67: predecessors 
    -- CP-element group 67: 	0 
    -- CP-element group 67: successors 
    -- CP-element group 67: 	74 
    -- CP-element group 67:  members (3) 
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_update_completed_
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/$exit
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/ca
      -- 
    ca_700_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 67_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_239_inst_ack_1, ack => zeropad3D_CP_182_elements(67)); -- 
    -- CP-element group 68:  join  transition  output  bypass 
    -- CP-element group 68: predecessors 
    -- CP-element group 68: 	20 
    -- CP-element group 68: 	24 
    -- CP-element group 68: successors 
    -- CP-element group 68: 	69 
    -- CP-element group 68:  members (3) 
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_sample_start_
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/$entry
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/rr
      -- 
    rr_708_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_708_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(68), ack => type_cast_243_inst_req_0); -- 
    zeropad3D_cp_element_group_68: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_68"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(20) & zeropad3D_CP_182_elements(24);
      gj_zeropad3D_cp_element_group_68 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(68), clk => clk, reset => reset); --
    end block;
    -- CP-element group 69:  transition  input  bypass 
    -- CP-element group 69: predecessors 
    -- CP-element group 69: 	68 
    -- CP-element group 69: successors 
    -- CP-element group 69:  members (3) 
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_sample_completed_
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/$exit
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/ra
      -- 
    ra_709_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 69_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_243_inst_ack_0, ack => zeropad3D_CP_182_elements(69)); -- 
    -- CP-element group 70:  transition  input  bypass 
    -- CP-element group 70: predecessors 
    -- CP-element group 70: 	0 
    -- CP-element group 70: successors 
    -- CP-element group 70: 	74 
    -- CP-element group 70:  members (3) 
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_update_completed_
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/$exit
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/ca
      -- 
    ca_714_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 70_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_243_inst_ack_1, ack => zeropad3D_CP_182_elements(70)); -- 
    -- CP-element group 71:  join  transition  output  bypass 
    -- CP-element group 71: predecessors 
    -- CP-element group 71: 	28 
    -- CP-element group 71: 	32 
    -- CP-element group 71: successors 
    -- CP-element group 71: 	72 
    -- CP-element group 71:  members (3) 
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_sample_start_
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/$entry
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/rr
      -- 
    rr_722_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_722_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(71), ack => type_cast_247_inst_req_0); -- 
    zeropad3D_cp_element_group_71: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_71"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(28) & zeropad3D_CP_182_elements(32);
      gj_zeropad3D_cp_element_group_71 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(71), clk => clk, reset => reset); --
    end block;
    -- CP-element group 72:  transition  input  bypass 
    -- CP-element group 72: predecessors 
    -- CP-element group 72: 	71 
    -- CP-element group 72: successors 
    -- CP-element group 72:  members (3) 
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_sample_completed_
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/$exit
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/ra
      -- 
    ra_723_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 72_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_247_inst_ack_0, ack => zeropad3D_CP_182_elements(72)); -- 
    -- CP-element group 73:  transition  input  bypass 
    -- CP-element group 73: predecessors 
    -- CP-element group 73: 	0 
    -- CP-element group 73: successors 
    -- CP-element group 73: 	74 
    -- CP-element group 73:  members (3) 
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_update_completed_
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/$exit
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/ca
      -- 
    ca_728_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 73_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_247_inst_ack_1, ack => zeropad3D_CP_182_elements(73)); -- 
    -- CP-element group 74:  branch  join  transition  place  output  bypass 
    -- CP-element group 74: predecessors 
    -- CP-element group 74: 	40 
    -- CP-element group 74: 	36 
    -- CP-element group 74: 	48 
    -- CP-element group 74: 	52 
    -- CP-element group 74: 	56 
    -- CP-element group 74: 	60 
    -- CP-element group 74: 	44 
    -- CP-element group 74: 	64 
    -- CP-element group 74: 	67 
    -- CP-element group 74: 	70 
    -- CP-element group 74: 	73 
    -- CP-element group 74: successors 
    -- CP-element group 74: 	75 
    -- CP-element group 74: 	76 
    -- CP-element group 74:  members (10) 
      -- CP-element group 74: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281__exit__
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282__entry__
      -- CP-element group 74: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/$exit
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_dead_link/$entry
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_eval_test/$entry
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_eval_test/$exit
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_eval_test/branch_req
      -- CP-element group 74: 	 branch_block_stmt_49/R_cmp314_283_place
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_if_link/$entry
      -- CP-element group 74: 	 branch_block_stmt_49/if_stmt_282_else_link/$entry
      -- 
    branch_req_736_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_736_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(74), ack => if_stmt_282_branch_req_0); -- 
    zeropad3D_cp_element_group_74: block -- 
      constant place_capacities: IntegerArray(0 to 10) := (0 => 1,1 => 1,2 => 1,3 => 1,4 => 1,5 => 1,6 => 1,7 => 1,8 => 1,9 => 1,10 => 1);
      constant place_markings: IntegerArray(0 to 10)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0,9 => 0,10 => 0);
      constant place_delays: IntegerArray(0 to 10) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0,9 => 0,10 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_74"; 
      signal preds: BooleanArray(1 to 11); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(40) & zeropad3D_CP_182_elements(36) & zeropad3D_CP_182_elements(48) & zeropad3D_CP_182_elements(52) & zeropad3D_CP_182_elements(56) & zeropad3D_CP_182_elements(60) & zeropad3D_CP_182_elements(44) & zeropad3D_CP_182_elements(64) & zeropad3D_CP_182_elements(67) & zeropad3D_CP_182_elements(70) & zeropad3D_CP_182_elements(73);
      gj_zeropad3D_cp_element_group_74 : generic_join generic map(name => joinName, number_of_predecessors => 11, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(74), clk => clk, reset => reset); --
    end block;
    -- CP-element group 75:  merge  transition  place  input  bypass 
    -- CP-element group 75: predecessors 
    -- CP-element group 75: 	74 
    -- CP-element group 75: successors 
    -- CP-element group 75: 	242 
    -- CP-element group 75:  members (18) 
      -- CP-element group 75: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/merge_stmt_288__exit__
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307__entry__
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307__exit__
      -- CP-element group 75: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody
      -- CP-element group 75: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_if_link/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_if_link/if_choice_transition
      -- CP-element group 75: 	 branch_block_stmt_49/entry_bbx_xnph316
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/entry_bbx_xnph316_PhiReq/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/entry_bbx_xnph316_PhiReq/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/merge_stmt_288_PhiReqMerge
      -- CP-element group 75: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/dummy
      -- CP-element group 75: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/$entry
      -- 
    if_choice_transition_741_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 75_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_282_branch_ack_1, ack => zeropad3D_CP_182_elements(75)); -- 
    -- CP-element group 76:  transition  place  input  bypass 
    -- CP-element group 76: predecessors 
    -- CP-element group 76: 	74 
    -- CP-element group 76: successors 
    -- CP-element group 76: 	248 
    -- CP-element group 76:  members (5) 
      -- CP-element group 76: 	 branch_block_stmt_49/entry_forx_xend_PhiReq/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/entry_forx_xend_PhiReq/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/if_stmt_282_else_link/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/if_stmt_282_else_link/else_choice_transition
      -- CP-element group 76: 	 branch_block_stmt_49/entry_forx_xend
      -- 
    else_choice_transition_745_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 76_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_282_branch_ack_0, ack => zeropad3D_CP_182_elements(76)); -- 
    -- CP-element group 77:  transition  input  bypass 
    -- CP-element group 77: predecessors 
    -- CP-element group 77: 	247 
    -- CP-element group 77: successors 
    -- CP-element group 77: 	116 
    -- CP-element group 77:  members (3) 
      -- CP-element group 77: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_sample_complete
      -- CP-element group 77: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/$exit
      -- CP-element group 77: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/ack
      -- 
    ack_779_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 77_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_322_index_offset_ack_0, ack => zeropad3D_CP_182_elements(77)); -- 
    -- CP-element group 78:  transition  input  output  bypass 
    -- CP-element group 78: predecessors 
    -- CP-element group 78: 	247 
    -- CP-element group 78: successors 
    -- CP-element group 78: 	79 
    -- CP-element group 78:  members (11) 
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_sample_start_
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_root_address_calculated
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_offset_calculated
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/$exit
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/ack
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/$entry
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/$exit
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/sum_rename_req
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/sum_rename_ack
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/$entry
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/req
      -- 
    ack_784_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 78_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_322_index_offset_ack_1, ack => zeropad3D_CP_182_elements(78)); -- 
    req_793_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_793_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(78), ack => addr_of_323_final_reg_req_0); -- 
    -- CP-element group 79:  transition  input  bypass 
    -- CP-element group 79: predecessors 
    -- CP-element group 79: 	78 
    -- CP-element group 79: successors 
    -- CP-element group 79:  members (3) 
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_sample_completed_
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/$exit
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/ack
      -- 
    ack_794_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 79_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_323_final_reg_ack_0, ack => zeropad3D_CP_182_elements(79)); -- 
    -- CP-element group 80:  fork  transition  input  bypass 
    -- CP-element group 80: predecessors 
    -- CP-element group 80: 	247 
    -- CP-element group 80: successors 
    -- CP-element group 80: 	113 
    -- CP-element group 80:  members (19) 
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/root_register_ack
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/root_register_req
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/$exit
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/$entry
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/sum_rename_ack
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/sum_rename_req
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/$exit
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/$entry
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/base_resize_ack
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/base_resize_req
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/$exit
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/$entry
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_address_resized
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_root_address_calculated
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_address_calculated
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_address_calculated
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_update_completed_
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/$exit
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/ack
      -- 
    ack_799_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 80_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_323_final_reg_ack_1, ack => zeropad3D_CP_182_elements(80)); -- 
    -- CP-element group 81:  transition  input  output  bypass 
    -- CP-element group 81: predecessors 
    -- CP-element group 81: 	247 
    -- CP-element group 81: successors 
    -- CP-element group 81: 	82 
    -- CP-element group 81:  members (6) 
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_sample_completed_
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_update_start_
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/$exit
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/ra
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/$entry
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/cr
      -- 
    ra_808_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 81_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_326_inst_ack_0, ack => zeropad3D_CP_182_elements(81)); -- 
    cr_812_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_812_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(81), ack => RPIPE_zeropad_input_pipe_326_inst_req_1); -- 
    -- CP-element group 82:  fork  transition  input  output  bypass 
    -- CP-element group 82: predecessors 
    -- CP-element group 82: 	81 
    -- CP-element group 82: successors 
    -- CP-element group 82: 	83 
    -- CP-element group 82: 	85 
    -- CP-element group 82:  members (9) 
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_update_completed_
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/$exit
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/ca
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_sample_start_
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/$entry
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/rr
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_sample_start_
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/$entry
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/rr
      -- 
    ca_813_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 82_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_326_inst_ack_1, ack => zeropad3D_CP_182_elements(82)); -- 
    rr_821_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_821_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(82), ack => type_cast_330_inst_req_0); -- 
    rr_835_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_835_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(82), ack => RPIPE_zeropad_input_pipe_339_inst_req_0); -- 
    -- CP-element group 83:  transition  input  bypass 
    -- CP-element group 83: predecessors 
    -- CP-element group 83: 	82 
    -- CP-element group 83: successors 
    -- CP-element group 83:  members (3) 
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_sample_completed_
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/$exit
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/ra
      -- 
    ra_822_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 83_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_330_inst_ack_0, ack => zeropad3D_CP_182_elements(83)); -- 
    -- CP-element group 84:  transition  input  bypass 
    -- CP-element group 84: predecessors 
    -- CP-element group 84: 	247 
    -- CP-element group 84: successors 
    -- CP-element group 84: 	113 
    -- CP-element group 84:  members (3) 
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_update_completed_
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/$exit
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/ca
      -- 
    ca_827_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 84_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_330_inst_ack_1, ack => zeropad3D_CP_182_elements(84)); -- 
    -- CP-element group 85:  transition  input  output  bypass 
    -- CP-element group 85: predecessors 
    -- CP-element group 85: 	82 
    -- CP-element group 85: successors 
    -- CP-element group 85: 	86 
    -- CP-element group 85:  members (6) 
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_sample_completed_
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_update_start_
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/$exit
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/ra
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/$entry
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/cr
      -- 
    ra_836_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 85_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_339_inst_ack_0, ack => zeropad3D_CP_182_elements(85)); -- 
    cr_840_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_840_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(85), ack => RPIPE_zeropad_input_pipe_339_inst_req_1); -- 
    -- CP-element group 86:  fork  transition  input  output  bypass 
    -- CP-element group 86: predecessors 
    -- CP-element group 86: 	85 
    -- CP-element group 86: successors 
    -- CP-element group 86: 	89 
    -- CP-element group 86: 	87 
    -- CP-element group 86:  members (9) 
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_update_completed_
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/$exit
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/ca
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_sample_start_
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/$entry
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/rr
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_sample_start_
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/$entry
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/rr
      -- 
    ca_841_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 86_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_339_inst_ack_1, ack => zeropad3D_CP_182_elements(86)); -- 
    rr_849_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_849_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(86), ack => type_cast_343_inst_req_0); -- 
    rr_863_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_863_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(86), ack => RPIPE_zeropad_input_pipe_357_inst_req_0); -- 
    -- CP-element group 87:  transition  input  bypass 
    -- CP-element group 87: predecessors 
    -- CP-element group 87: 	86 
    -- CP-element group 87: successors 
    -- CP-element group 87:  members (3) 
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_sample_completed_
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/$exit
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/ra
      -- 
    ra_850_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 87_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_343_inst_ack_0, ack => zeropad3D_CP_182_elements(87)); -- 
    -- CP-element group 88:  transition  input  bypass 
    -- CP-element group 88: predecessors 
    -- CP-element group 88: 	247 
    -- CP-element group 88: successors 
    -- CP-element group 88: 	113 
    -- CP-element group 88:  members (3) 
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_update_completed_
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/$exit
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/ca
      -- 
    ca_855_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 88_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_343_inst_ack_1, ack => zeropad3D_CP_182_elements(88)); -- 
    -- CP-element group 89:  transition  input  output  bypass 
    -- CP-element group 89: predecessors 
    -- CP-element group 89: 	86 
    -- CP-element group 89: successors 
    -- CP-element group 89: 	90 
    -- CP-element group 89:  members (6) 
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_sample_completed_
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_update_start_
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/$exit
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/ra
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/$entry
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/cr
      -- 
    ra_864_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 89_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_357_inst_ack_0, ack => zeropad3D_CP_182_elements(89)); -- 
    cr_868_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_868_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(89), ack => RPIPE_zeropad_input_pipe_357_inst_req_1); -- 
    -- CP-element group 90:  fork  transition  input  output  bypass 
    -- CP-element group 90: predecessors 
    -- CP-element group 90: 	89 
    -- CP-element group 90: successors 
    -- CP-element group 90: 	93 
    -- CP-element group 90: 	91 
    -- CP-element group 90:  members (9) 
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_update_completed_
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/$exit
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/ca
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_sample_start_
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/$entry
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/rr
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_sample_start_
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/$entry
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/rr
      -- 
    ca_869_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 90_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_357_inst_ack_1, ack => zeropad3D_CP_182_elements(90)); -- 
    rr_877_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_877_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(90), ack => type_cast_361_inst_req_0); -- 
    rr_891_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_891_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(90), ack => RPIPE_zeropad_input_pipe_375_inst_req_0); -- 
    -- CP-element group 91:  transition  input  bypass 
    -- CP-element group 91: predecessors 
    -- CP-element group 91: 	90 
    -- CP-element group 91: successors 
    -- CP-element group 91:  members (3) 
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_sample_completed_
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/$exit
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/ra
      -- 
    ra_878_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 91_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_361_inst_ack_0, ack => zeropad3D_CP_182_elements(91)); -- 
    -- CP-element group 92:  transition  input  bypass 
    -- CP-element group 92: predecessors 
    -- CP-element group 92: 	247 
    -- CP-element group 92: successors 
    -- CP-element group 92: 	113 
    -- CP-element group 92:  members (3) 
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_update_completed_
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/$exit
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/ca
      -- 
    ca_883_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 92_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_361_inst_ack_1, ack => zeropad3D_CP_182_elements(92)); -- 
    -- CP-element group 93:  transition  input  output  bypass 
    -- CP-element group 93: predecessors 
    -- CP-element group 93: 	90 
    -- CP-element group 93: successors 
    -- CP-element group 93: 	94 
    -- CP-element group 93:  members (6) 
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_sample_completed_
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_update_start_
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/$exit
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/ra
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/$entry
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/cr
      -- 
    ra_892_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 93_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_375_inst_ack_0, ack => zeropad3D_CP_182_elements(93)); -- 
    cr_896_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_896_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(93), ack => RPIPE_zeropad_input_pipe_375_inst_req_1); -- 
    -- CP-element group 94:  fork  transition  input  output  bypass 
    -- CP-element group 94: predecessors 
    -- CP-element group 94: 	93 
    -- CP-element group 94: successors 
    -- CP-element group 94: 	95 
    -- CP-element group 94: 	97 
    -- CP-element group 94:  members (9) 
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/$entry
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_sample_start_
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/rr
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_update_completed_
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/$exit
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/ca
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_sample_start_
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/$entry
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/rr
      -- 
    ca_897_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 94_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_375_inst_ack_1, ack => zeropad3D_CP_182_elements(94)); -- 
    rr_905_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_905_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(94), ack => type_cast_379_inst_req_0); -- 
    rr_919_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_919_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(94), ack => RPIPE_zeropad_input_pipe_393_inst_req_0); -- 
    -- CP-element group 95:  transition  input  bypass 
    -- CP-element group 95: predecessors 
    -- CP-element group 95: 	94 
    -- CP-element group 95: successors 
    -- CP-element group 95:  members (3) 
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_sample_completed_
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/$exit
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/ra
      -- 
    ra_906_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 95_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_379_inst_ack_0, ack => zeropad3D_CP_182_elements(95)); -- 
    -- CP-element group 96:  transition  input  bypass 
    -- CP-element group 96: predecessors 
    -- CP-element group 96: 	247 
    -- CP-element group 96: successors 
    -- CP-element group 96: 	113 
    -- CP-element group 96:  members (3) 
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/ca
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/$exit
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_update_completed_
      -- 
    ca_911_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 96_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_379_inst_ack_1, ack => zeropad3D_CP_182_elements(96)); -- 
    -- CP-element group 97:  transition  input  output  bypass 
    -- CP-element group 97: predecessors 
    -- CP-element group 97: 	94 
    -- CP-element group 97: successors 
    -- CP-element group 97: 	98 
    -- CP-element group 97:  members (6) 
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_update_start_
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_sample_completed_
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/cr
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/$entry
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/ra
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/$exit
      -- 
    ra_920_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 97_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_393_inst_ack_0, ack => zeropad3D_CP_182_elements(97)); -- 
    cr_924_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_924_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(97), ack => RPIPE_zeropad_input_pipe_393_inst_req_1); -- 
    -- CP-element group 98:  fork  transition  input  output  bypass 
    -- CP-element group 98: predecessors 
    -- CP-element group 98: 	97 
    -- CP-element group 98: successors 
    -- CP-element group 98: 	99 
    -- CP-element group 98: 	101 
    -- CP-element group 98:  members (9) 
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_update_completed_
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/rr
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/$entry
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_sample_start_
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/ca
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/$exit
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/rr
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/$entry
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_sample_start_
      -- 
    ca_925_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 98_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_393_inst_ack_1, ack => zeropad3D_CP_182_elements(98)); -- 
    rr_933_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_933_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(98), ack => type_cast_397_inst_req_0); -- 
    rr_947_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_947_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(98), ack => RPIPE_zeropad_input_pipe_411_inst_req_0); -- 
    -- CP-element group 99:  transition  input  bypass 
    -- CP-element group 99: predecessors 
    -- CP-element group 99: 	98 
    -- CP-element group 99: successors 
    -- CP-element group 99:  members (3) 
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/$exit
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_sample_completed_
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/ra
      -- 
    ra_934_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 99_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_397_inst_ack_0, ack => zeropad3D_CP_182_elements(99)); -- 
    -- CP-element group 100:  transition  input  bypass 
    -- CP-element group 100: predecessors 
    -- CP-element group 100: 	247 
    -- CP-element group 100: successors 
    -- CP-element group 100: 	113 
    -- CP-element group 100:  members (3) 
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_update_completed_
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/ca
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/$exit
      -- 
    ca_939_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 100_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_397_inst_ack_1, ack => zeropad3D_CP_182_elements(100)); -- 
    -- CP-element group 101:  transition  input  output  bypass 
    -- CP-element group 101: predecessors 
    -- CP-element group 101: 	98 
    -- CP-element group 101: successors 
    -- CP-element group 101: 	102 
    -- CP-element group 101:  members (6) 
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_update_start_
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/cr
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/$entry
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/ra
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/$exit
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_sample_completed_
      -- 
    ra_948_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 101_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_411_inst_ack_0, ack => zeropad3D_CP_182_elements(101)); -- 
    cr_952_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_952_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(101), ack => RPIPE_zeropad_input_pipe_411_inst_req_1); -- 
    -- CP-element group 102:  fork  transition  input  output  bypass 
    -- CP-element group 102: predecessors 
    -- CP-element group 102: 	101 
    -- CP-element group 102: successors 
    -- CP-element group 102: 	103 
    -- CP-element group 102: 	105 
    -- CP-element group 102:  members (9) 
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_sample_start_
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/rr
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/rr
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_update_completed_
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/$entry
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/$entry
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_sample_start_
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/ca
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/$exit
      -- 
    ca_953_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 102_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_411_inst_ack_1, ack => zeropad3D_CP_182_elements(102)); -- 
    rr_961_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_961_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(102), ack => type_cast_415_inst_req_0); -- 
    rr_975_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_975_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(102), ack => RPIPE_zeropad_input_pipe_429_inst_req_0); -- 
    -- CP-element group 103:  transition  input  bypass 
    -- CP-element group 103: predecessors 
    -- CP-element group 103: 	102 
    -- CP-element group 103: successors 
    -- CP-element group 103:  members (3) 
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/ra
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/$exit
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_sample_completed_
      -- 
    ra_962_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 103_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_415_inst_ack_0, ack => zeropad3D_CP_182_elements(103)); -- 
    -- CP-element group 104:  transition  input  bypass 
    -- CP-element group 104: predecessors 
    -- CP-element group 104: 	247 
    -- CP-element group 104: successors 
    -- CP-element group 104: 	113 
    -- CP-element group 104:  members (3) 
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/ca
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/$exit
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_update_completed_
      -- 
    ca_967_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 104_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_415_inst_ack_1, ack => zeropad3D_CP_182_elements(104)); -- 
    -- CP-element group 105:  transition  input  output  bypass 
    -- CP-element group 105: predecessors 
    -- CP-element group 105: 	102 
    -- CP-element group 105: successors 
    -- CP-element group 105: 	106 
    -- CP-element group 105:  members (6) 
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_sample_completed_
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_update_start_
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/cr
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/$entry
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/ra
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/$exit
      -- 
    ra_976_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 105_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_429_inst_ack_0, ack => zeropad3D_CP_182_elements(105)); -- 
    cr_980_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_980_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(105), ack => RPIPE_zeropad_input_pipe_429_inst_req_1); -- 
    -- CP-element group 106:  fork  transition  input  output  bypass 
    -- CP-element group 106: predecessors 
    -- CP-element group 106: 	105 
    -- CP-element group 106: successors 
    -- CP-element group 106: 	107 
    -- CP-element group 106: 	109 
    -- CP-element group 106:  members (9) 
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_update_completed_
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_sample_start_
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/ca
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/$exit
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_sample_start_
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/rr
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/$entry
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/rr
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/$entry
      -- 
    ca_981_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 106_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_429_inst_ack_1, ack => zeropad3D_CP_182_elements(106)); -- 
    rr_989_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_989_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(106), ack => type_cast_433_inst_req_0); -- 
    rr_1003_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1003_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(106), ack => RPIPE_zeropad_input_pipe_447_inst_req_0); -- 
    -- CP-element group 107:  transition  input  bypass 
    -- CP-element group 107: predecessors 
    -- CP-element group 107: 	106 
    -- CP-element group 107: successors 
    -- CP-element group 107:  members (3) 
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_sample_completed_
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/ra
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/$exit
      -- 
    ra_990_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 107_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_433_inst_ack_0, ack => zeropad3D_CP_182_elements(107)); -- 
    -- CP-element group 108:  transition  input  bypass 
    -- CP-element group 108: predecessors 
    -- CP-element group 108: 	247 
    -- CP-element group 108: successors 
    -- CP-element group 108: 	113 
    -- CP-element group 108:  members (3) 
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/ca
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/$exit
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_update_completed_
      -- 
    ca_995_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 108_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_433_inst_ack_1, ack => zeropad3D_CP_182_elements(108)); -- 
    -- CP-element group 109:  transition  input  output  bypass 
    -- CP-element group 109: predecessors 
    -- CP-element group 109: 	106 
    -- CP-element group 109: successors 
    -- CP-element group 109: 	110 
    -- CP-element group 109:  members (6) 
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_update_start_
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_sample_completed_
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/cr
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/$entry
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/ra
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/$exit
      -- 
    ra_1004_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 109_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_447_inst_ack_0, ack => zeropad3D_CP_182_elements(109)); -- 
    cr_1008_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1008_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(109), ack => RPIPE_zeropad_input_pipe_447_inst_req_1); -- 
    -- CP-element group 110:  transition  input  output  bypass 
    -- CP-element group 110: predecessors 
    -- CP-element group 110: 	109 
    -- CP-element group 110: successors 
    -- CP-element group 110: 	111 
    -- CP-element group 110:  members (6) 
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_sample_start_
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/rr
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/ca
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/$exit
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_update_completed_
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/$entry
      -- 
    ca_1009_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 110_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_447_inst_ack_1, ack => zeropad3D_CP_182_elements(110)); -- 
    rr_1017_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1017_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(110), ack => type_cast_451_inst_req_0); -- 
    -- CP-element group 111:  transition  input  bypass 
    -- CP-element group 111: predecessors 
    -- CP-element group 111: 	110 
    -- CP-element group 111: successors 
    -- CP-element group 111:  members (3) 
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/ra
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_sample_completed_
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/$exit
      -- 
    ra_1018_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 111_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_451_inst_ack_0, ack => zeropad3D_CP_182_elements(111)); -- 
    -- CP-element group 112:  transition  input  bypass 
    -- CP-element group 112: predecessors 
    -- CP-element group 112: 	247 
    -- CP-element group 112: successors 
    -- CP-element group 112: 	113 
    -- CP-element group 112:  members (3) 
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/$exit
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_update_completed_
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/ca
      -- 
    ca_1023_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 112_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_451_inst_ack_1, ack => zeropad3D_CP_182_elements(112)); -- 
    -- CP-element group 113:  join  transition  output  bypass 
    -- CP-element group 113: predecessors 
    -- CP-element group 113: 	96 
    -- CP-element group 113: 	100 
    -- CP-element group 113: 	104 
    -- CP-element group 113: 	92 
    -- CP-element group 113: 	108 
    -- CP-element group 113: 	112 
    -- CP-element group 113: 	88 
    -- CP-element group 113: 	80 
    -- CP-element group 113: 	84 
    -- CP-element group 113: successors 
    -- CP-element group 113: 	114 
    -- CP-element group 113:  members (9) 
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/rr
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/$entry
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/$entry
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/split_ack
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/split_req
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/$exit
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/$entry
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/$entry
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_sample_start_
      -- 
    rr_1061_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1061_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(113), ack => ptr_deref_459_store_0_req_0); -- 
    zeropad3D_cp_element_group_113: block -- 
      constant place_capacities: IntegerArray(0 to 8) := (0 => 1,1 => 1,2 => 1,3 => 1,4 => 1,5 => 1,6 => 1,7 => 1,8 => 1);
      constant place_markings: IntegerArray(0 to 8)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0);
      constant place_delays: IntegerArray(0 to 8) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_113"; 
      signal preds: BooleanArray(1 to 9); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(96) & zeropad3D_CP_182_elements(100) & zeropad3D_CP_182_elements(104) & zeropad3D_CP_182_elements(92) & zeropad3D_CP_182_elements(108) & zeropad3D_CP_182_elements(112) & zeropad3D_CP_182_elements(88) & zeropad3D_CP_182_elements(80) & zeropad3D_CP_182_elements(84);
      gj_zeropad3D_cp_element_group_113 : generic_join generic map(name => joinName, number_of_predecessors => 9, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(113), clk => clk, reset => reset); --
    end block;
    -- CP-element group 114:  transition  input  bypass 
    -- CP-element group 114: predecessors 
    -- CP-element group 114: 	113 
    -- CP-element group 114: successors 
    -- CP-element group 114:  members (5) 
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/ra
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/$exit
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/$exit
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/$exit
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_sample_completed_
      -- 
    ra_1062_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 114_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_459_store_0_ack_0, ack => zeropad3D_CP_182_elements(114)); -- 
    -- CP-element group 115:  transition  input  bypass 
    -- CP-element group 115: predecessors 
    -- CP-element group 115: 	247 
    -- CP-element group 115: successors 
    -- CP-element group 115: 	116 
    -- CP-element group 115:  members (5) 
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/$exit
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_update_completed_
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/ca
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/$exit
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/$exit
      -- 
    ca_1073_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 115_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_459_store_0_ack_1, ack => zeropad3D_CP_182_elements(115)); -- 
    -- CP-element group 116:  branch  join  transition  place  output  bypass 
    -- CP-element group 116: predecessors 
    -- CP-element group 116: 	115 
    -- CP-element group 116: 	77 
    -- CP-element group 116: successors 
    -- CP-element group 116: 	117 
    -- CP-element group 116: 	118 
    -- CP-element group 116:  members (10) 
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_dead_link/$entry
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472__exit__
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473__entry__
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_else_link/$entry
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_if_link/$entry
      -- CP-element group 116: 	 branch_block_stmt_49/R_exitcond_474_place
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_eval_test/branch_req
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_eval_test/$exit
      -- CP-element group 116: 	 branch_block_stmt_49/if_stmt_473_eval_test/$entry
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/$exit
      -- 
    branch_req_1081_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_1081_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(116), ack => if_stmt_473_branch_req_0); -- 
    zeropad3D_cp_element_group_116: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_116"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(115) & zeropad3D_CP_182_elements(77);
      gj_zeropad3D_cp_element_group_116 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(116), clk => clk, reset => reset); --
    end block;
    -- CP-element group 117:  merge  transition  place  input  bypass 
    -- CP-element group 117: predecessors 
    -- CP-element group 117: 	116 
    -- CP-element group 117: successors 
    -- CP-element group 117: 	248 
    -- CP-element group 117:  members (13) 
      -- CP-element group 117: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/dummy
      -- CP-element group 117: 	 branch_block_stmt_49/merge_stmt_479__exit__
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend_PhiReq/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_if_link/if_choice_transition
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_if_link/$exit
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend_PhiReq/$exit
      -- CP-element group 117: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/$exit
      -- CP-element group 117: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/merge_stmt_479_PhiReqMerge
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit_PhiReq/$exit
      -- CP-element group 117: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit_PhiReq/$entry
      -- 
    if_choice_transition_1086_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 117_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_473_branch_ack_1, ack => zeropad3D_CP_182_elements(117)); -- 
    -- CP-element group 118:  fork  transition  place  input  output  bypass 
    -- CP-element group 118: predecessors 
    -- CP-element group 118: 	116 
    -- CP-element group 118: successors 
    -- CP-element group 118: 	243 
    -- CP-element group 118: 	244 
    -- CP-element group 118:  members (12) 
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody
      -- CP-element group 118: 	 branch_block_stmt_49/if_stmt_473_else_link/else_choice_transition
      -- CP-element group 118: 	 branch_block_stmt_49/if_stmt_473_else_link/$exit
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/cr
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/rr
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/$entry
      -- 
    else_choice_transition_1090_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 118_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_473_branch_ack_0, ack => zeropad3D_CP_182_elements(118)); -- 
    cr_1966_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1966_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(118), ack => type_cast_316_inst_req_1); -- 
    rr_1961_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1961_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(118), ack => type_cast_316_inst_req_0); -- 
    -- CP-element group 119:  transition  input  bypass 
    -- CP-element group 119: predecessors 
    -- CP-element group 119: 	248 
    -- CP-element group 119: successors 
    -- CP-element group 119:  members (3) 
      -- CP-element group 119: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/cra
      -- CP-element group 119: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/$exit
      -- CP-element group 119: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_sample_completed_
      -- 
    cra_1104_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 119_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_484_call_ack_0, ack => zeropad3D_CP_182_elements(119)); -- 
    -- CP-element group 120:  transition  input  output  bypass 
    -- CP-element group 120: predecessors 
    -- CP-element group 120: 	248 
    -- CP-element group 120: successors 
    -- CP-element group 120: 	121 
    -- CP-element group 120:  members (6) 
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_sample_start_
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_update_completed_
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/rr
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/cca
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/$exit
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/$entry
      -- 
    cca_1109_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 120_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_484_call_ack_1, ack => zeropad3D_CP_182_elements(120)); -- 
    rr_1117_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1117_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(120), ack => type_cast_488_inst_req_0); -- 
    -- CP-element group 121:  transition  input  bypass 
    -- CP-element group 121: predecessors 
    -- CP-element group 121: 	120 
    -- CP-element group 121: successors 
    -- CP-element group 121:  members (3) 
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_sample_completed_
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/ra
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/$exit
      -- 
    ra_1118_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 121_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_488_inst_ack_0, ack => zeropad3D_CP_182_elements(121)); -- 
    -- CP-element group 122:  fork  transition  place  input  output  bypass 
    -- CP-element group 122: predecessors 
    -- CP-element group 122: 	248 
    -- CP-element group 122: successors 
    -- CP-element group 122: 	123 
    -- CP-element group 122: 	137 
    -- CP-element group 122:  members (13) 
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Sample/$entry
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Sample/req
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_sample_start_
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489__exit__
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514__entry__
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/$exit
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Sample/$entry
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/$exit
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_sample_start_
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/$entry
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/ca
      -- CP-element group 122: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Sample/rr
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_update_completed_
      -- 
    ca_1123_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 122_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_488_inst_ack_1, ack => zeropad3D_CP_182_elements(122)); -- 
    req_1134_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1134_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(122), ack => WPIPE_Block0_starting_491_inst_req_0); -- 
    rr_1232_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1232_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(122), ack => RPIPE_Block0_complete_513_inst_req_0); -- 
    -- CP-element group 123:  transition  input  output  bypass 
    -- CP-element group 123: predecessors 
    -- CP-element group 123: 	122 
    -- CP-element group 123: successors 
    -- CP-element group 123: 	124 
    -- CP-element group 123:  members (6) 
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Update/req
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Update/$entry
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Sample/ack
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Sample/$exit
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_update_start_
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_sample_completed_
      -- 
    ack_1135_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 123_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_491_inst_ack_0, ack => zeropad3D_CP_182_elements(123)); -- 
    req_1139_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1139_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(123), ack => WPIPE_Block0_starting_491_inst_req_1); -- 
    -- CP-element group 124:  transition  input  output  bypass 
    -- CP-element group 124: predecessors 
    -- CP-element group 124: 	123 
    -- CP-element group 124: successors 
    -- CP-element group 124: 	125 
    -- CP-element group 124:  members (6) 
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_sample_start_
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Update/ack
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_Update/$exit
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_491_update_completed_
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Sample/req
      -- CP-element group 124: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Sample/$entry
      -- 
    ack_1140_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 124_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_491_inst_ack_1, ack => zeropad3D_CP_182_elements(124)); -- 
    req_1148_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1148_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(124), ack => WPIPE_Block0_starting_494_inst_req_0); -- 
    -- CP-element group 125:  transition  input  output  bypass 
    -- CP-element group 125: predecessors 
    -- CP-element group 125: 	124 
    -- CP-element group 125: successors 
    -- CP-element group 125: 	126 
    -- CP-element group 125:  members (6) 
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_sample_completed_
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_update_start_
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Update/req
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Update/$entry
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Sample/ack
      -- CP-element group 125: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Sample/$exit
      -- 
    ack_1149_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 125_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_494_inst_ack_0, ack => zeropad3D_CP_182_elements(125)); -- 
    req_1153_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1153_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(125), ack => WPIPE_Block0_starting_494_inst_req_1); -- 
    -- CP-element group 126:  transition  input  output  bypass 
    -- CP-element group 126: predecessors 
    -- CP-element group 126: 	125 
    -- CP-element group 126: successors 
    -- CP-element group 126: 	127 
    -- CP-element group 126:  members (6) 
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Sample/req
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Sample/$entry
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_sample_start_
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Update/ack
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_Update/$exit
      -- CP-element group 126: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_494_update_completed_
      -- 
    ack_1154_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 126_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_494_inst_ack_1, ack => zeropad3D_CP_182_elements(126)); -- 
    req_1162_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1162_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(126), ack => WPIPE_Block0_starting_497_inst_req_0); -- 
    -- CP-element group 127:  transition  input  output  bypass 
    -- CP-element group 127: predecessors 
    -- CP-element group 127: 	126 
    -- CP-element group 127: successors 
    -- CP-element group 127: 	128 
    -- CP-element group 127:  members (6) 
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Update/req
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Update/$entry
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Sample/ack
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Sample/$exit
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_update_start_
      -- CP-element group 127: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_sample_completed_
      -- 
    ack_1163_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 127_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_497_inst_ack_0, ack => zeropad3D_CP_182_elements(127)); -- 
    req_1167_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1167_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(127), ack => WPIPE_Block0_starting_497_inst_req_1); -- 
    -- CP-element group 128:  transition  input  output  bypass 
    -- CP-element group 128: predecessors 
    -- CP-element group 128: 	127 
    -- CP-element group 128: successors 
    -- CP-element group 128: 	129 
    -- CP-element group 128:  members (6) 
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_sample_start_
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Update/ack
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_Update/$exit
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_497_update_completed_
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Sample/req
      -- CP-element group 128: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Sample/$entry
      -- 
    ack_1168_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 128_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_497_inst_ack_1, ack => zeropad3D_CP_182_elements(128)); -- 
    req_1176_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1176_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(128), ack => WPIPE_Block0_starting_500_inst_req_0); -- 
    -- CP-element group 129:  transition  input  output  bypass 
    -- CP-element group 129: predecessors 
    -- CP-element group 129: 	128 
    -- CP-element group 129: successors 
    -- CP-element group 129: 	130 
    -- CP-element group 129:  members (6) 
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_update_start_
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_sample_completed_
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Update/req
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Update/$entry
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Sample/ack
      -- CP-element group 129: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Sample/$exit
      -- 
    ack_1177_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 129_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_500_inst_ack_0, ack => zeropad3D_CP_182_elements(129)); -- 
    req_1181_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1181_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(129), ack => WPIPE_Block0_starting_500_inst_req_1); -- 
    -- CP-element group 130:  transition  input  output  bypass 
    -- CP-element group 130: predecessors 
    -- CP-element group 130: 	129 
    -- CP-element group 130: successors 
    -- CP-element group 130: 	131 
    -- CP-element group 130:  members (6) 
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Sample/req
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Sample/$entry
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_sample_start_
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Update/ack
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_Update/$exit
      -- CP-element group 130: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_500_update_completed_
      -- 
    ack_1182_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 130_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_500_inst_ack_1, ack => zeropad3D_CP_182_elements(130)); -- 
    req_1190_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1190_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(130), ack => WPIPE_Block0_starting_503_inst_req_0); -- 
    -- CP-element group 131:  transition  input  output  bypass 
    -- CP-element group 131: predecessors 
    -- CP-element group 131: 	130 
    -- CP-element group 131: successors 
    -- CP-element group 131: 	132 
    -- CP-element group 131:  members (6) 
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Update/$entry
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Sample/ack
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Sample/$exit
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Update/req
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_update_start_
      -- CP-element group 131: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_sample_completed_
      -- 
    ack_1191_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 131_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_503_inst_ack_0, ack => zeropad3D_CP_182_elements(131)); -- 
    req_1195_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1195_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(131), ack => WPIPE_Block0_starting_503_inst_req_1); -- 
    -- CP-element group 132:  transition  input  output  bypass 
    -- CP-element group 132: predecessors 
    -- CP-element group 132: 	131 
    -- CP-element group 132: successors 
    -- CP-element group 132: 	133 
    -- CP-element group 132:  members (6) 
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Update/ack
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Sample/req
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_update_completed_
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_503_Update/$exit
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Sample/$entry
      -- CP-element group 132: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_sample_start_
      -- 
    ack_1196_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 132_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_503_inst_ack_1, ack => zeropad3D_CP_182_elements(132)); -- 
    req_1204_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1204_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(132), ack => WPIPE_Block0_starting_506_inst_req_0); -- 
    -- CP-element group 133:  transition  input  output  bypass 
    -- CP-element group 133: predecessors 
    -- CP-element group 133: 	132 
    -- CP-element group 133: successors 
    -- CP-element group 133: 	134 
    -- CP-element group 133:  members (6) 
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Update/req
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Update/$entry
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Sample/ack
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Sample/$exit
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_update_start_
      -- CP-element group 133: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_sample_completed_
      -- 
    ack_1205_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 133_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_506_inst_ack_0, ack => zeropad3D_CP_182_elements(133)); -- 
    req_1209_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1209_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(133), ack => WPIPE_Block0_starting_506_inst_req_1); -- 
    -- CP-element group 134:  transition  input  output  bypass 
    -- CP-element group 134: predecessors 
    -- CP-element group 134: 	133 
    -- CP-element group 134: successors 
    -- CP-element group 134: 	135 
    -- CP-element group 134:  members (6) 
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Update/$exit
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_update_completed_
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Sample/req
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Sample/$entry
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_sample_start_
      -- CP-element group 134: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_506_Update/ack
      -- 
    ack_1210_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 134_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_506_inst_ack_1, ack => zeropad3D_CP_182_elements(134)); -- 
    req_1218_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1218_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(134), ack => WPIPE_Block0_starting_509_inst_req_0); -- 
    -- CP-element group 135:  transition  input  output  bypass 
    -- CP-element group 135: predecessors 
    -- CP-element group 135: 	134 
    -- CP-element group 135: successors 
    -- CP-element group 135: 	136 
    -- CP-element group 135:  members (6) 
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Update/req
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Update/$entry
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Sample/ack
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Sample/$exit
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_update_start_
      -- CP-element group 135: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_sample_completed_
      -- 
    ack_1219_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 135_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_509_inst_ack_0, ack => zeropad3D_CP_182_elements(135)); -- 
    req_1223_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1223_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(135), ack => WPIPE_Block0_starting_509_inst_req_1); -- 
    -- CP-element group 136:  transition  input  bypass 
    -- CP-element group 136: predecessors 
    -- CP-element group 136: 	135 
    -- CP-element group 136: successors 
    -- CP-element group 136: 	139 
    -- CP-element group 136:  members (3) 
      -- CP-element group 136: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Update/ack
      -- CP-element group 136: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_Update/$exit
      -- CP-element group 136: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/WPIPE_Block0_starting_509_update_completed_
      -- 
    ack_1224_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 136_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_starting_509_inst_ack_1, ack => zeropad3D_CP_182_elements(136)); -- 
    -- CP-element group 137:  transition  input  output  bypass 
    -- CP-element group 137: predecessors 
    -- CP-element group 137: 	122 
    -- CP-element group 137: successors 
    -- CP-element group 137: 	138 
    -- CP-element group 137:  members (6) 
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_update_start_
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Update/cr
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_sample_completed_
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Update/$entry
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Sample/ra
      -- CP-element group 137: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Sample/$exit
      -- 
    ra_1233_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 137_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_complete_513_inst_ack_0, ack => zeropad3D_CP_182_elements(137)); -- 
    cr_1237_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1237_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(137), ack => RPIPE_Block0_complete_513_inst_req_1); -- 
    -- CP-element group 138:  transition  input  bypass 
    -- CP-element group 138: predecessors 
    -- CP-element group 138: 	137 
    -- CP-element group 138: successors 
    -- CP-element group 138: 	139 
    -- CP-element group 138:  members (3) 
      -- CP-element group 138: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Update/ca
      -- CP-element group 138: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_update_completed_
      -- CP-element group 138: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/RPIPE_Block0_complete_513_Update/$exit
      -- 
    ca_1238_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 138_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_complete_513_inst_ack_1, ack => zeropad3D_CP_182_elements(138)); -- 
    -- CP-element group 139:  join  fork  transition  place  output  bypass 
    -- CP-element group 139: predecessors 
    -- CP-element group 139: 	136 
    -- CP-element group 139: 	138 
    -- CP-element group 139: successors 
    -- CP-element group 139: 	140 
    -- CP-element group 139: 	141 
    -- CP-element group 139: 	143 
    -- CP-element group 139:  members (13) 
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Update/ccr
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_update_start_
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/$entry
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Update/$entry
      -- CP-element group 139: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514__exit__
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527__entry__
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Update/cr
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Sample/crr
      -- CP-element group 139: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_514/$exit
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Update/$entry
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Sample/$entry
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_update_start_
      -- CP-element group 139: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_sample_start_
      -- 
    ccr_1254_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_1254_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(139), ack => call_stmt_517_call_req_1); -- 
    cr_1268_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1268_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(139), ack => type_cast_521_inst_req_1); -- 
    crr_1249_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_1249_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(139), ack => call_stmt_517_call_req_0); -- 
    zeropad3D_cp_element_group_139: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_139"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(136) & zeropad3D_CP_182_elements(138);
      gj_zeropad3D_cp_element_group_139 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(139), clk => clk, reset => reset); --
    end block;
    -- CP-element group 140:  transition  input  bypass 
    -- CP-element group 140: predecessors 
    -- CP-element group 140: 	139 
    -- CP-element group 140: successors 
    -- CP-element group 140:  members (3) 
      -- CP-element group 140: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Sample/cra
      -- CP-element group 140: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Sample/$exit
      -- CP-element group 140: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_sample_completed_
      -- 
    cra_1250_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 140_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_517_call_ack_0, ack => zeropad3D_CP_182_elements(140)); -- 
    -- CP-element group 141:  transition  input  output  bypass 
    -- CP-element group 141: predecessors 
    -- CP-element group 141: 	139 
    -- CP-element group 141: successors 
    -- CP-element group 141: 	142 
    -- CP-element group 141:  members (6) 
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_sample_start_
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Update/$exit
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_Update/cca
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Sample/rr
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/call_stmt_517_update_completed_
      -- CP-element group 141: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Sample/$entry
      -- 
    cca_1255_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 141_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_517_call_ack_1, ack => zeropad3D_CP_182_elements(141)); -- 
    rr_1263_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1263_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(141), ack => type_cast_521_inst_req_0); -- 
    -- CP-element group 142:  transition  input  bypass 
    -- CP-element group 142: predecessors 
    -- CP-element group 142: 	141 
    -- CP-element group 142: successors 
    -- CP-element group 142:  members (3) 
      -- CP-element group 142: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_sample_completed_
      -- CP-element group 142: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Sample/ra
      -- CP-element group 142: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Sample/$exit
      -- 
    ra_1264_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 142_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_521_inst_ack_0, ack => zeropad3D_CP_182_elements(142)); -- 
    -- CP-element group 143:  fork  transition  place  input  output  bypass 
    -- CP-element group 143: predecessors 
    -- CP-element group 143: 	139 
    -- CP-element group 143: successors 
    -- CP-element group 143: 	144 
    -- CP-element group 143: 	145 
    -- CP-element group 143: 	146 
    -- CP-element group 143: 	147 
    -- CP-element group 143: 	148 
    -- CP-element group 143: 	149 
    -- CP-element group 143: 	150 
    -- CP-element group 143: 	151 
    -- CP-element group 143: 	152 
    -- CP-element group 143: 	153 
    -- CP-element group 143: 	154 
    -- CP-element group 143: 	155 
    -- CP-element group 143: 	156 
    -- CP-element group 143: 	157 
    -- CP-element group 143: 	158 
    -- CP-element group 143: 	159 
    -- CP-element group 143:  members (55) 
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527__exit__
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626__entry__
      -- CP-element group 143: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Update/ca
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_Update/$exit
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/$exit
      -- CP-element group 143: 	 branch_block_stmt_49/call_stmt_517_to_assign_stmt_527/type_cast_521_update_completed_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Update/cr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_sample_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_update_start_
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Sample/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Sample/rr
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Update/cr
      -- 
    ca_1269_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 143_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_521_inst_ack_1, ack => zeropad3D_CP_182_elements(143)); -- 
    cr_1313_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1313_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_551_inst_req_1); -- 
    cr_1327_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1327_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_561_inst_req_1); -- 
    rr_1336_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1336_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_571_inst_req_0); -- 
    rr_1308_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1308_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_551_inst_req_0); -- 
    cr_1285_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1285_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_531_inst_req_1); -- 
    rr_1322_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1322_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_561_inst_req_0); -- 
    cr_1341_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1341_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_571_inst_req_1); -- 
    rr_1280_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1280_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_531_inst_req_0); -- 
    cr_1299_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1299_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_541_inst_req_1); -- 
    rr_1294_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1294_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_541_inst_req_0); -- 
    rr_1350_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1350_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_581_inst_req_0); -- 
    cr_1355_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1355_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_581_inst_req_1); -- 
    rr_1364_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1364_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_591_inst_req_0); -- 
    cr_1369_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1369_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_591_inst_req_1); -- 
    rr_1378_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1378_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_601_inst_req_0); -- 
    cr_1383_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1383_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(143), ack => type_cast_601_inst_req_1); -- 
    -- CP-element group 144:  transition  input  bypass 
    -- CP-element group 144: predecessors 
    -- CP-element group 144: 	143 
    -- CP-element group 144: successors 
    -- CP-element group 144:  members (3) 
      -- CP-element group 144: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Sample/$exit
      -- CP-element group 144: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Sample/ra
      -- CP-element group 144: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_sample_completed_
      -- 
    ra_1281_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 144_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_531_inst_ack_0, ack => zeropad3D_CP_182_elements(144)); -- 
    -- CP-element group 145:  transition  input  bypass 
    -- CP-element group 145: predecessors 
    -- CP-element group 145: 	143 
    -- CP-element group 145: successors 
    -- CP-element group 145: 	180 
    -- CP-element group 145:  members (3) 
      -- CP-element group 145: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Update/ca
      -- CP-element group 145: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_Update/$exit
      -- CP-element group 145: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_531_update_completed_
      -- 
    ca_1286_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 145_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_531_inst_ack_1, ack => zeropad3D_CP_182_elements(145)); -- 
    -- CP-element group 146:  transition  input  bypass 
    -- CP-element group 146: predecessors 
    -- CP-element group 146: 	143 
    -- CP-element group 146: successors 
    -- CP-element group 146:  members (3) 
      -- CP-element group 146: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_sample_completed_
      -- CP-element group 146: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Sample/ra
      -- CP-element group 146: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Sample/$exit
      -- 
    ra_1295_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 146_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_541_inst_ack_0, ack => zeropad3D_CP_182_elements(146)); -- 
    -- CP-element group 147:  transition  input  bypass 
    -- CP-element group 147: predecessors 
    -- CP-element group 147: 	143 
    -- CP-element group 147: successors 
    -- CP-element group 147: 	177 
    -- CP-element group 147:  members (3) 
      -- CP-element group 147: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Update/ca
      -- CP-element group 147: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_Update/$exit
      -- CP-element group 147: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_541_update_completed_
      -- 
    ca_1300_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 147_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_541_inst_ack_1, ack => zeropad3D_CP_182_elements(147)); -- 
    -- CP-element group 148:  transition  input  bypass 
    -- CP-element group 148: predecessors 
    -- CP-element group 148: 	143 
    -- CP-element group 148: successors 
    -- CP-element group 148:  members (3) 
      -- CP-element group 148: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_sample_completed_
      -- CP-element group 148: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Sample/ra
      -- CP-element group 148: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Sample/$exit
      -- 
    ra_1309_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 148_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_551_inst_ack_0, ack => zeropad3D_CP_182_elements(148)); -- 
    -- CP-element group 149:  transition  input  bypass 
    -- CP-element group 149: predecessors 
    -- CP-element group 149: 	143 
    -- CP-element group 149: successors 
    -- CP-element group 149: 	174 
    -- CP-element group 149:  members (3) 
      -- CP-element group 149: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Update/$exit
      -- CP-element group 149: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_Update/ca
      -- CP-element group 149: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_551_update_completed_
      -- 
    ca_1314_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 149_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_551_inst_ack_1, ack => zeropad3D_CP_182_elements(149)); -- 
    -- CP-element group 150:  transition  input  bypass 
    -- CP-element group 150: predecessors 
    -- CP-element group 150: 	143 
    -- CP-element group 150: successors 
    -- CP-element group 150:  members (3) 
      -- CP-element group 150: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Sample/$exit
      -- CP-element group 150: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Sample/ra
      -- CP-element group 150: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_sample_completed_
      -- 
    ra_1323_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 150_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_561_inst_ack_0, ack => zeropad3D_CP_182_elements(150)); -- 
    -- CP-element group 151:  transition  input  bypass 
    -- CP-element group 151: predecessors 
    -- CP-element group 151: 	143 
    -- CP-element group 151: successors 
    -- CP-element group 151: 	171 
    -- CP-element group 151:  members (3) 
      -- CP-element group 151: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_update_completed_
      -- CP-element group 151: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Update/$exit
      -- CP-element group 151: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_561_Update/ca
      -- 
    ca_1328_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 151_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_561_inst_ack_1, ack => zeropad3D_CP_182_elements(151)); -- 
    -- CP-element group 152:  transition  input  bypass 
    -- CP-element group 152: predecessors 
    -- CP-element group 152: 	143 
    -- CP-element group 152: successors 
    -- CP-element group 152:  members (3) 
      -- CP-element group 152: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_sample_completed_
      -- CP-element group 152: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Sample/$exit
      -- CP-element group 152: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Sample/ra
      -- 
    ra_1337_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 152_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_571_inst_ack_0, ack => zeropad3D_CP_182_elements(152)); -- 
    -- CP-element group 153:  transition  input  bypass 
    -- CP-element group 153: predecessors 
    -- CP-element group 153: 	143 
    -- CP-element group 153: successors 
    -- CP-element group 153: 	168 
    -- CP-element group 153:  members (3) 
      -- CP-element group 153: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_update_completed_
      -- CP-element group 153: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Update/$exit
      -- CP-element group 153: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_571_Update/ca
      -- 
    ca_1342_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 153_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_571_inst_ack_1, ack => zeropad3D_CP_182_elements(153)); -- 
    -- CP-element group 154:  transition  input  bypass 
    -- CP-element group 154: predecessors 
    -- CP-element group 154: 	143 
    -- CP-element group 154: successors 
    -- CP-element group 154:  members (3) 
      -- CP-element group 154: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_sample_completed_
      -- CP-element group 154: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Sample/$exit
      -- CP-element group 154: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Sample/ra
      -- 
    ra_1351_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 154_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_581_inst_ack_0, ack => zeropad3D_CP_182_elements(154)); -- 
    -- CP-element group 155:  transition  input  bypass 
    -- CP-element group 155: predecessors 
    -- CP-element group 155: 	143 
    -- CP-element group 155: successors 
    -- CP-element group 155: 	165 
    -- CP-element group 155:  members (3) 
      -- CP-element group 155: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_update_completed_
      -- CP-element group 155: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Update/$exit
      -- CP-element group 155: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_581_Update/ca
      -- 
    ca_1356_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 155_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_581_inst_ack_1, ack => zeropad3D_CP_182_elements(155)); -- 
    -- CP-element group 156:  transition  input  bypass 
    -- CP-element group 156: predecessors 
    -- CP-element group 156: 	143 
    -- CP-element group 156: successors 
    -- CP-element group 156:  members (3) 
      -- CP-element group 156: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_sample_completed_
      -- CP-element group 156: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Sample/$exit
      -- CP-element group 156: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Sample/ra
      -- 
    ra_1365_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 156_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_591_inst_ack_0, ack => zeropad3D_CP_182_elements(156)); -- 
    -- CP-element group 157:  transition  input  bypass 
    -- CP-element group 157: predecessors 
    -- CP-element group 157: 	143 
    -- CP-element group 157: successors 
    -- CP-element group 157: 	162 
    -- CP-element group 157:  members (3) 
      -- CP-element group 157: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_update_completed_
      -- CP-element group 157: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Update/$exit
      -- CP-element group 157: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_591_Update/ca
      -- 
    ca_1370_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 157_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_591_inst_ack_1, ack => zeropad3D_CP_182_elements(157)); -- 
    -- CP-element group 158:  transition  input  bypass 
    -- CP-element group 158: predecessors 
    -- CP-element group 158: 	143 
    -- CP-element group 158: successors 
    -- CP-element group 158:  members (3) 
      -- CP-element group 158: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_sample_completed_
      -- CP-element group 158: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Sample/$exit
      -- CP-element group 158: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Sample/ra
      -- 
    ra_1379_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 158_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_601_inst_ack_0, ack => zeropad3D_CP_182_elements(158)); -- 
    -- CP-element group 159:  transition  input  output  bypass 
    -- CP-element group 159: predecessors 
    -- CP-element group 159: 	143 
    -- CP-element group 159: successors 
    -- CP-element group 159: 	160 
    -- CP-element group 159:  members (6) 
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_update_completed_
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Update/$exit
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/type_cast_601_Update/ca
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_sample_start_
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Sample/$entry
      -- CP-element group 159: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Sample/req
      -- 
    ca_1384_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 159_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_601_inst_ack_1, ack => zeropad3D_CP_182_elements(159)); -- 
    req_1392_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1392_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(159), ack => WPIPE_zeropad_output_pipe_603_inst_req_0); -- 
    -- CP-element group 160:  transition  input  output  bypass 
    -- CP-element group 160: predecessors 
    -- CP-element group 160: 	159 
    -- CP-element group 160: successors 
    -- CP-element group 160: 	161 
    -- CP-element group 160:  members (6) 
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_sample_completed_
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_update_start_
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Sample/$exit
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Sample/ack
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Update/$entry
      -- CP-element group 160: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Update/req
      -- 
    ack_1393_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 160_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_603_inst_ack_0, ack => zeropad3D_CP_182_elements(160)); -- 
    req_1397_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1397_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(160), ack => WPIPE_zeropad_output_pipe_603_inst_req_1); -- 
    -- CP-element group 161:  transition  input  bypass 
    -- CP-element group 161: predecessors 
    -- CP-element group 161: 	160 
    -- CP-element group 161: successors 
    -- CP-element group 161: 	162 
    -- CP-element group 161:  members (3) 
      -- CP-element group 161: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_update_completed_
      -- CP-element group 161: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Update/$exit
      -- CP-element group 161: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_603_Update/ack
      -- 
    ack_1398_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 161_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_603_inst_ack_1, ack => zeropad3D_CP_182_elements(161)); -- 
    -- CP-element group 162:  join  transition  output  bypass 
    -- CP-element group 162: predecessors 
    -- CP-element group 162: 	157 
    -- CP-element group 162: 	161 
    -- CP-element group 162: successors 
    -- CP-element group 162: 	163 
    -- CP-element group 162:  members (3) 
      -- CP-element group 162: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_sample_start_
      -- CP-element group 162: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Sample/$entry
      -- CP-element group 162: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Sample/req
      -- 
    req_1406_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1406_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(162), ack => WPIPE_zeropad_output_pipe_606_inst_req_0); -- 
    zeropad3D_cp_element_group_162: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_162"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(157) & zeropad3D_CP_182_elements(161);
      gj_zeropad3D_cp_element_group_162 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(162), clk => clk, reset => reset); --
    end block;
    -- CP-element group 163:  transition  input  output  bypass 
    -- CP-element group 163: predecessors 
    -- CP-element group 163: 	162 
    -- CP-element group 163: successors 
    -- CP-element group 163: 	164 
    -- CP-element group 163:  members (6) 
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_sample_completed_
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_update_start_
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Sample/$exit
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Sample/ack
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Update/$entry
      -- CP-element group 163: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Update/req
      -- 
    ack_1407_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 163_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_606_inst_ack_0, ack => zeropad3D_CP_182_elements(163)); -- 
    req_1411_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1411_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(163), ack => WPIPE_zeropad_output_pipe_606_inst_req_1); -- 
    -- CP-element group 164:  transition  input  bypass 
    -- CP-element group 164: predecessors 
    -- CP-element group 164: 	163 
    -- CP-element group 164: successors 
    -- CP-element group 164: 	165 
    -- CP-element group 164:  members (3) 
      -- CP-element group 164: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_update_completed_
      -- CP-element group 164: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Update/$exit
      -- CP-element group 164: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_606_Update/ack
      -- 
    ack_1412_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 164_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_606_inst_ack_1, ack => zeropad3D_CP_182_elements(164)); -- 
    -- CP-element group 165:  join  transition  output  bypass 
    -- CP-element group 165: predecessors 
    -- CP-element group 165: 	155 
    -- CP-element group 165: 	164 
    -- CP-element group 165: successors 
    -- CP-element group 165: 	166 
    -- CP-element group 165:  members (3) 
      -- CP-element group 165: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_sample_start_
      -- CP-element group 165: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Sample/$entry
      -- CP-element group 165: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Sample/req
      -- 
    req_1420_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1420_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(165), ack => WPIPE_zeropad_output_pipe_609_inst_req_0); -- 
    zeropad3D_cp_element_group_165: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_165"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(155) & zeropad3D_CP_182_elements(164);
      gj_zeropad3D_cp_element_group_165 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(165), clk => clk, reset => reset); --
    end block;
    -- CP-element group 166:  transition  input  output  bypass 
    -- CP-element group 166: predecessors 
    -- CP-element group 166: 	165 
    -- CP-element group 166: successors 
    -- CP-element group 166: 	167 
    -- CP-element group 166:  members (6) 
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_sample_completed_
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_update_start_
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Sample/$exit
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Sample/ack
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Update/$entry
      -- CP-element group 166: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Update/req
      -- 
    ack_1421_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 166_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_609_inst_ack_0, ack => zeropad3D_CP_182_elements(166)); -- 
    req_1425_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1425_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(166), ack => WPIPE_zeropad_output_pipe_609_inst_req_1); -- 
    -- CP-element group 167:  transition  input  bypass 
    -- CP-element group 167: predecessors 
    -- CP-element group 167: 	166 
    -- CP-element group 167: successors 
    -- CP-element group 167: 	168 
    -- CP-element group 167:  members (3) 
      -- CP-element group 167: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_update_completed_
      -- CP-element group 167: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Update/$exit
      -- CP-element group 167: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_609_Update/ack
      -- 
    ack_1426_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 167_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_609_inst_ack_1, ack => zeropad3D_CP_182_elements(167)); -- 
    -- CP-element group 168:  join  transition  output  bypass 
    -- CP-element group 168: predecessors 
    -- CP-element group 168: 	153 
    -- CP-element group 168: 	167 
    -- CP-element group 168: successors 
    -- CP-element group 168: 	169 
    -- CP-element group 168:  members (3) 
      -- CP-element group 168: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_sample_start_
      -- CP-element group 168: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Sample/$entry
      -- CP-element group 168: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Sample/req
      -- 
    req_1434_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1434_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(168), ack => WPIPE_zeropad_output_pipe_612_inst_req_0); -- 
    zeropad3D_cp_element_group_168: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_168"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(153) & zeropad3D_CP_182_elements(167);
      gj_zeropad3D_cp_element_group_168 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(168), clk => clk, reset => reset); --
    end block;
    -- CP-element group 169:  transition  input  output  bypass 
    -- CP-element group 169: predecessors 
    -- CP-element group 169: 	168 
    -- CP-element group 169: successors 
    -- CP-element group 169: 	170 
    -- CP-element group 169:  members (6) 
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_sample_completed_
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_update_start_
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Sample/$exit
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Sample/ack
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Update/$entry
      -- CP-element group 169: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Update/req
      -- 
    ack_1435_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 169_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_612_inst_ack_0, ack => zeropad3D_CP_182_elements(169)); -- 
    req_1439_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1439_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(169), ack => WPIPE_zeropad_output_pipe_612_inst_req_1); -- 
    -- CP-element group 170:  transition  input  bypass 
    -- CP-element group 170: predecessors 
    -- CP-element group 170: 	169 
    -- CP-element group 170: successors 
    -- CP-element group 170: 	171 
    -- CP-element group 170:  members (3) 
      -- CP-element group 170: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_update_completed_
      -- CP-element group 170: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Update/$exit
      -- CP-element group 170: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_612_Update/ack
      -- 
    ack_1440_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 170_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_612_inst_ack_1, ack => zeropad3D_CP_182_elements(170)); -- 
    -- CP-element group 171:  join  transition  output  bypass 
    -- CP-element group 171: predecessors 
    -- CP-element group 171: 	151 
    -- CP-element group 171: 	170 
    -- CP-element group 171: successors 
    -- CP-element group 171: 	172 
    -- CP-element group 171:  members (3) 
      -- CP-element group 171: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_sample_start_
      -- CP-element group 171: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Sample/$entry
      -- CP-element group 171: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Sample/req
      -- 
    req_1448_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1448_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(171), ack => WPIPE_zeropad_output_pipe_615_inst_req_0); -- 
    zeropad3D_cp_element_group_171: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_171"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(151) & zeropad3D_CP_182_elements(170);
      gj_zeropad3D_cp_element_group_171 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(171), clk => clk, reset => reset); --
    end block;
    -- CP-element group 172:  transition  input  output  bypass 
    -- CP-element group 172: predecessors 
    -- CP-element group 172: 	171 
    -- CP-element group 172: successors 
    -- CP-element group 172: 	173 
    -- CP-element group 172:  members (6) 
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_sample_completed_
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_update_start_
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Sample/$exit
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Sample/ack
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Update/$entry
      -- CP-element group 172: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Update/req
      -- 
    ack_1449_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 172_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_615_inst_ack_0, ack => zeropad3D_CP_182_elements(172)); -- 
    req_1453_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1453_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(172), ack => WPIPE_zeropad_output_pipe_615_inst_req_1); -- 
    -- CP-element group 173:  transition  input  bypass 
    -- CP-element group 173: predecessors 
    -- CP-element group 173: 	172 
    -- CP-element group 173: successors 
    -- CP-element group 173: 	174 
    -- CP-element group 173:  members (3) 
      -- CP-element group 173: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_update_completed_
      -- CP-element group 173: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Update/$exit
      -- CP-element group 173: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_615_Update/ack
      -- 
    ack_1454_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 173_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_615_inst_ack_1, ack => zeropad3D_CP_182_elements(173)); -- 
    -- CP-element group 174:  join  transition  output  bypass 
    -- CP-element group 174: predecessors 
    -- CP-element group 174: 	149 
    -- CP-element group 174: 	173 
    -- CP-element group 174: successors 
    -- CP-element group 174: 	175 
    -- CP-element group 174:  members (3) 
      -- CP-element group 174: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_sample_start_
      -- CP-element group 174: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Sample/$entry
      -- CP-element group 174: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Sample/req
      -- 
    req_1462_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1462_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(174), ack => WPIPE_zeropad_output_pipe_618_inst_req_0); -- 
    zeropad3D_cp_element_group_174: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_174"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(149) & zeropad3D_CP_182_elements(173);
      gj_zeropad3D_cp_element_group_174 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(174), clk => clk, reset => reset); --
    end block;
    -- CP-element group 175:  transition  input  output  bypass 
    -- CP-element group 175: predecessors 
    -- CP-element group 175: 	174 
    -- CP-element group 175: successors 
    -- CP-element group 175: 	176 
    -- CP-element group 175:  members (6) 
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_sample_completed_
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_update_start_
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Sample/$exit
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Sample/ack
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Update/$entry
      -- CP-element group 175: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Update/req
      -- 
    ack_1463_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 175_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_618_inst_ack_0, ack => zeropad3D_CP_182_elements(175)); -- 
    req_1467_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1467_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(175), ack => WPIPE_zeropad_output_pipe_618_inst_req_1); -- 
    -- CP-element group 176:  transition  input  bypass 
    -- CP-element group 176: predecessors 
    -- CP-element group 176: 	175 
    -- CP-element group 176: successors 
    -- CP-element group 176: 	177 
    -- CP-element group 176:  members (3) 
      -- CP-element group 176: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_update_completed_
      -- CP-element group 176: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Update/$exit
      -- CP-element group 176: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_618_Update/ack
      -- 
    ack_1468_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 176_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_618_inst_ack_1, ack => zeropad3D_CP_182_elements(176)); -- 
    -- CP-element group 177:  join  transition  output  bypass 
    -- CP-element group 177: predecessors 
    -- CP-element group 177: 	147 
    -- CP-element group 177: 	176 
    -- CP-element group 177: successors 
    -- CP-element group 177: 	178 
    -- CP-element group 177:  members (3) 
      -- CP-element group 177: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_sample_start_
      -- CP-element group 177: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Sample/$entry
      -- CP-element group 177: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Sample/req
      -- 
    req_1476_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1476_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(177), ack => WPIPE_zeropad_output_pipe_621_inst_req_0); -- 
    zeropad3D_cp_element_group_177: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_177"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(147) & zeropad3D_CP_182_elements(176);
      gj_zeropad3D_cp_element_group_177 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(177), clk => clk, reset => reset); --
    end block;
    -- CP-element group 178:  transition  input  output  bypass 
    -- CP-element group 178: predecessors 
    -- CP-element group 178: 	177 
    -- CP-element group 178: successors 
    -- CP-element group 178: 	179 
    -- CP-element group 178:  members (6) 
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_sample_completed_
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_update_start_
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Sample/$exit
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Sample/ack
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Update/$entry
      -- CP-element group 178: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Update/req
      -- 
    ack_1477_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 178_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_621_inst_ack_0, ack => zeropad3D_CP_182_elements(178)); -- 
    req_1481_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1481_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(178), ack => WPIPE_zeropad_output_pipe_621_inst_req_1); -- 
    -- CP-element group 179:  transition  input  bypass 
    -- CP-element group 179: predecessors 
    -- CP-element group 179: 	178 
    -- CP-element group 179: successors 
    -- CP-element group 179: 	180 
    -- CP-element group 179:  members (3) 
      -- CP-element group 179: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_update_completed_
      -- CP-element group 179: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Update/$exit
      -- CP-element group 179: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_621_Update/ack
      -- 
    ack_1482_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 179_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_621_inst_ack_1, ack => zeropad3D_CP_182_elements(179)); -- 
    -- CP-element group 180:  join  transition  output  bypass 
    -- CP-element group 180: predecessors 
    -- CP-element group 180: 	145 
    -- CP-element group 180: 	179 
    -- CP-element group 180: successors 
    -- CP-element group 180: 	181 
    -- CP-element group 180:  members (3) 
      -- CP-element group 180: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_sample_start_
      -- CP-element group 180: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Sample/$entry
      -- CP-element group 180: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Sample/req
      -- 
    req_1490_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1490_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(180), ack => WPIPE_zeropad_output_pipe_624_inst_req_0); -- 
    zeropad3D_cp_element_group_180: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_180"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(145) & zeropad3D_CP_182_elements(179);
      gj_zeropad3D_cp_element_group_180 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(180), clk => clk, reset => reset); --
    end block;
    -- CP-element group 181:  transition  input  output  bypass 
    -- CP-element group 181: predecessors 
    -- CP-element group 181: 	180 
    -- CP-element group 181: successors 
    -- CP-element group 181: 	182 
    -- CP-element group 181:  members (6) 
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_sample_completed_
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_update_start_
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Sample/$exit
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Sample/ack
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Update/$entry
      -- CP-element group 181: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Update/req
      -- 
    ack_1491_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 181_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_624_inst_ack_0, ack => zeropad3D_CP_182_elements(181)); -- 
    req_1495_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1495_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(181), ack => WPIPE_zeropad_output_pipe_624_inst_req_1); -- 
    -- CP-element group 182:  fork  transition  place  input  output  bypass 
    -- CP-element group 182: predecessors 
    -- CP-element group 182: 	181 
    -- CP-element group 182: successors 
    -- CP-element group 182: 	183 
    -- CP-element group 182: 	184 
    -- CP-element group 182: 	185 
    -- CP-element group 182: 	186 
    -- CP-element group 182: 	187 
    -- CP-element group 182: 	188 
    -- CP-element group 182:  members (25) 
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/$exit
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626__exit__
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667__entry__
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_update_completed_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Update/$exit
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_532_to_assign_stmt_626/WPIPE_zeropad_output_pipe_624_Update/ack
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_sample_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_update_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Sample/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Sample/rr
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Update/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Update/cr
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_sample_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_update_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Sample/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Sample/rr
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Update/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Update/cr
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_sample_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_update_start_
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Sample/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Sample/rr
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Update/$entry
      -- CP-element group 182: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Update/cr
      -- 
    ack_1496_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 182_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_624_inst_ack_1, ack => zeropad3D_CP_182_elements(182)); -- 
    rr_1507_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1507_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_630_inst_req_0); -- 
    cr_1512_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1512_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_630_inst_req_1); -- 
    rr_1521_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1521_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_634_inst_req_0); -- 
    cr_1526_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1526_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_634_inst_req_1); -- 
    rr_1535_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1535_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_638_inst_req_0); -- 
    cr_1540_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1540_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => type_cast_638_inst_req_1); -- 
    -- CP-element group 183:  transition  input  bypass 
    -- CP-element group 183: predecessors 
    -- CP-element group 183: 	182 
    -- CP-element group 183: successors 
    -- CP-element group 183:  members (3) 
      -- CP-element group 183: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_sample_completed_
      -- CP-element group 183: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Sample/$exit
      -- CP-element group 183: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Sample/ra
      -- 
    ra_1508_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 183_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_630_inst_ack_0, ack => zeropad3D_CP_182_elements(183)); -- 
    -- CP-element group 184:  transition  input  bypass 
    -- CP-element group 184: predecessors 
    -- CP-element group 184: 	182 
    -- CP-element group 184: successors 
    -- CP-element group 184: 	189 
    -- CP-element group 184:  members (3) 
      -- CP-element group 184: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_update_completed_
      -- CP-element group 184: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Update/$exit
      -- CP-element group 184: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_630_Update/ca
      -- 
    ca_1513_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 184_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_630_inst_ack_1, ack => zeropad3D_CP_182_elements(184)); -- 
    -- CP-element group 185:  transition  input  bypass 
    -- CP-element group 185: predecessors 
    -- CP-element group 185: 	182 
    -- CP-element group 185: successors 
    -- CP-element group 185:  members (3) 
      -- CP-element group 185: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_sample_completed_
      -- CP-element group 185: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Sample/$exit
      -- CP-element group 185: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Sample/ra
      -- 
    ra_1522_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 185_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_634_inst_ack_0, ack => zeropad3D_CP_182_elements(185)); -- 
    -- CP-element group 186:  transition  input  bypass 
    -- CP-element group 186: predecessors 
    -- CP-element group 186: 	182 
    -- CP-element group 186: successors 
    -- CP-element group 186: 	189 
    -- CP-element group 186:  members (3) 
      -- CP-element group 186: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_update_completed_
      -- CP-element group 186: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Update/$exit
      -- CP-element group 186: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_634_Update/ca
      -- 
    ca_1527_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 186_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_634_inst_ack_1, ack => zeropad3D_CP_182_elements(186)); -- 
    -- CP-element group 187:  transition  input  bypass 
    -- CP-element group 187: predecessors 
    -- CP-element group 187: 	182 
    -- CP-element group 187: successors 
    -- CP-element group 187:  members (3) 
      -- CP-element group 187: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_sample_completed_
      -- CP-element group 187: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Sample/$exit
      -- CP-element group 187: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Sample/ra
      -- 
    ra_1536_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 187_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_638_inst_ack_0, ack => zeropad3D_CP_182_elements(187)); -- 
    -- CP-element group 188:  transition  input  bypass 
    -- CP-element group 188: predecessors 
    -- CP-element group 188: 	182 
    -- CP-element group 188: successors 
    -- CP-element group 188: 	189 
    -- CP-element group 188:  members (3) 
      -- CP-element group 188: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_update_completed_
      -- CP-element group 188: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Update/$exit
      -- CP-element group 188: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/type_cast_638_Update/ca
      -- 
    ca_1541_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 188_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_638_inst_ack_1, ack => zeropad3D_CP_182_elements(188)); -- 
    -- CP-element group 189:  branch  join  transition  place  output  bypass 
    -- CP-element group 189: predecessors 
    -- CP-element group 189: 	184 
    -- CP-element group 189: 	186 
    -- CP-element group 189: 	188 
    -- CP-element group 189: successors 
    -- CP-element group 189: 	190 
    -- CP-element group 189: 	191 
    -- CP-element group 189:  members (10) 
      -- CP-element group 189: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667__exit__
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668__entry__
      -- CP-element group 189: 	 branch_block_stmt_49/assign_stmt_631_to_assign_stmt_667/$exit
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_dead_link/$entry
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_eval_test/$entry
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_eval_test/$exit
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_eval_test/branch_req
      -- CP-element group 189: 	 branch_block_stmt_49/R_cmp233310_669_place
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_if_link/$entry
      -- CP-element group 189: 	 branch_block_stmt_49/if_stmt_668_else_link/$entry
      -- 
    branch_req_1549_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_1549_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(189), ack => if_stmt_668_branch_req_0); -- 
    zeropad3D_cp_element_group_189: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 0);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_189"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(184) & zeropad3D_CP_182_elements(186) & zeropad3D_CP_182_elements(188);
      gj_zeropad3D_cp_element_group_189 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(189), clk => clk, reset => reset); --
    end block;
    -- CP-element group 190:  merge  fork  transition  place  input  output  bypass 
    -- CP-element group 190: predecessors 
    -- CP-element group 190: 	189 
    -- CP-element group 190: successors 
    -- CP-element group 190: 	192 
    -- CP-element group 190: 	193 
    -- CP-element group 190:  members (18) 
      -- CP-element group 190: 	 branch_block_stmt_49/merge_stmt_674_PhiReqMerge
      -- CP-element group 190: 	 branch_block_stmt_49/merge_stmt_674_PhiAck/dummy
      -- CP-element group 190: 	 branch_block_stmt_49/forx_xend_bbx_xnph_PhiReq/$entry
      -- CP-element group 190: 	 branch_block_stmt_49/merge_stmt_674__exit__
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678__entry__
      -- CP-element group 190: 	 branch_block_stmt_49/merge_stmt_674_PhiAck/$exit
      -- CP-element group 190: 	 branch_block_stmt_49/merge_stmt_674_PhiAck/$entry
      -- CP-element group 190: 	 branch_block_stmt_49/forx_xend_bbx_xnph_PhiReq/$exit
      -- CP-element group 190: 	 branch_block_stmt_49/if_stmt_668_if_link/$exit
      -- CP-element group 190: 	 branch_block_stmt_49/if_stmt_668_if_link/if_choice_transition
      -- CP-element group 190: 	 branch_block_stmt_49/forx_xend_bbx_xnph
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/$entry
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_sample_start_
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_update_start_
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Sample/$entry
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Sample/rr
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Update/$entry
      -- CP-element group 190: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Update/cr
      -- 
    if_choice_transition_1554_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 190_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_668_branch_ack_1, ack => zeropad3D_CP_182_elements(190)); -- 
    rr_1571_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1571_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(190), ack => type_cast_677_inst_req_0); -- 
    cr_1576_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1576_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(190), ack => type_cast_677_inst_req_1); -- 
    -- CP-element group 191:  transition  place  input  bypass 
    -- CP-element group 191: predecessors 
    -- CP-element group 191: 	189 
    -- CP-element group 191: successors 
    -- CP-element group 191: 	255 
    -- CP-element group 191:  members (5) 
      -- CP-element group 191: 	 branch_block_stmt_49/if_stmt_668_else_link/$exit
      -- CP-element group 191: 	 branch_block_stmt_49/if_stmt_668_else_link/else_choice_transition
      -- CP-element group 191: 	 branch_block_stmt_49/forx_xend_forx_xend308
      -- CP-element group 191: 	 branch_block_stmt_49/forx_xend_forx_xend308_PhiReq/$exit
      -- CP-element group 191: 	 branch_block_stmt_49/forx_xend_forx_xend308_PhiReq/$entry
      -- 
    else_choice_transition_1558_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 191_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_668_branch_ack_0, ack => zeropad3D_CP_182_elements(191)); -- 
    -- CP-element group 192:  transition  input  bypass 
    -- CP-element group 192: predecessors 
    -- CP-element group 192: 	190 
    -- CP-element group 192: successors 
    -- CP-element group 192:  members (3) 
      -- CP-element group 192: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_sample_completed_
      -- CP-element group 192: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Sample/$exit
      -- CP-element group 192: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Sample/ra
      -- 
    ra_1572_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 192_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_677_inst_ack_0, ack => zeropad3D_CP_182_elements(192)); -- 
    -- CP-element group 193:  transition  place  input  bypass 
    -- CP-element group 193: predecessors 
    -- CP-element group 193: 	190 
    -- CP-element group 193: successors 
    -- CP-element group 193: 	249 
    -- CP-element group 193:  members (9) 
      -- CP-element group 193: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/$entry
      -- CP-element group 193: 	 branch_block_stmt_49/assign_stmt_678__exit__
      -- CP-element group 193: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235
      -- CP-element group 193: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/$entry
      -- CP-element group 193: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/$entry
      -- CP-element group 193: 	 branch_block_stmt_49/assign_stmt_678/$exit
      -- CP-element group 193: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_update_completed_
      -- CP-element group 193: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Update/$exit
      -- CP-element group 193: 	 branch_block_stmt_49/assign_stmt_678/type_cast_677_Update/ca
      -- 
    ca_1577_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 193_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_677_inst_ack_1, ack => zeropad3D_CP_182_elements(193)); -- 
    -- CP-element group 194:  transition  input  bypass 
    -- CP-element group 194: predecessors 
    -- CP-element group 194: 	254 
    -- CP-element group 194: successors 
    -- CP-element group 194: 	239 
    -- CP-element group 194:  members (3) 
      -- CP-element group 194: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_sample_complete
      -- CP-element group 194: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Sample/$exit
      -- CP-element group 194: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Sample/ack
      -- 
    ack_1606_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 194_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_693_index_offset_ack_0, ack => zeropad3D_CP_182_elements(194)); -- 
    -- CP-element group 195:  transition  input  output  bypass 
    -- CP-element group 195: predecessors 
    -- CP-element group 195: 	254 
    -- CP-element group 195: successors 
    -- CP-element group 195: 	196 
    -- CP-element group 195:  members (11) 
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_sample_start_
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_root_address_calculated
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_offset_calculated
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Update/$exit
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Update/ack
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_base_plus_offset/$entry
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_base_plus_offset/$exit
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_base_plus_offset/sum_rename_req
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_base_plus_offset/sum_rename_ack
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_request/$entry
      -- CP-element group 195: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_request/req
      -- 
    ack_1611_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 195_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_693_index_offset_ack_1, ack => zeropad3D_CP_182_elements(195)); -- 
    req_1620_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1620_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(195), ack => addr_of_694_final_reg_req_0); -- 
    -- CP-element group 196:  transition  input  bypass 
    -- CP-element group 196: predecessors 
    -- CP-element group 196: 	195 
    -- CP-element group 196: successors 
    -- CP-element group 196:  members (3) 
      -- CP-element group 196: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_sample_completed_
      -- CP-element group 196: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_request/$exit
      -- CP-element group 196: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_request/ack
      -- 
    ack_1621_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 196_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_694_final_reg_ack_0, ack => zeropad3D_CP_182_elements(196)); -- 
    -- CP-element group 197:  join  fork  transition  input  output  bypass 
    -- CP-element group 197: predecessors 
    -- CP-element group 197: 	254 
    -- CP-element group 197: successors 
    -- CP-element group 197: 	198 
    -- CP-element group 197:  members (24) 
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_update_completed_
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_complete/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_complete/ack
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_sample_start_
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_address_calculated
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_word_address_calculated
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_root_address_calculated
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_address_resized
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_addr_resize/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_addr_resize/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_addr_resize/base_resize_req
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_addr_resize/base_resize_ack
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_plus_offset/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_plus_offset/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_plus_offset/sum_rename_req
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_base_plus_offset/sum_rename_ack
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_word_addrgen/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_word_addrgen/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_word_addrgen/root_register_req
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_word_addrgen/root_register_ack
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/word_0/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/word_0/rr
      -- 
    ack_1626_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 197_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_694_final_reg_ack_1, ack => zeropad3D_CP_182_elements(197)); -- 
    rr_1659_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1659_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(197), ack => ptr_deref_698_load_0_req_0); -- 
    -- CP-element group 198:  transition  input  bypass 
    -- CP-element group 198: predecessors 
    -- CP-element group 198: 	197 
    -- CP-element group 198: successors 
    -- CP-element group 198:  members (5) 
      -- CP-element group 198: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_sample_completed_
      -- CP-element group 198: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/$exit
      -- CP-element group 198: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/$exit
      -- CP-element group 198: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/word_0/$exit
      -- CP-element group 198: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Sample/word_access_start/word_0/ra
      -- 
    ra_1660_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 198_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_698_load_0_ack_0, ack => zeropad3D_CP_182_elements(198)); -- 
    -- CP-element group 199:  fork  transition  input  output  bypass 
    -- CP-element group 199: predecessors 
    -- CP-element group 199: 	254 
    -- CP-element group 199: successors 
    -- CP-element group 199: 	200 
    -- CP-element group 199: 	202 
    -- CP-element group 199: 	204 
    -- CP-element group 199: 	206 
    -- CP-element group 199: 	208 
    -- CP-element group 199: 	210 
    -- CP-element group 199: 	212 
    -- CP-element group 199: 	214 
    -- CP-element group 199:  members (33) 
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_update_completed_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/$exit
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/$exit
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/word_0/$exit
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/word_0/ca
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/ptr_deref_698_Merge/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/ptr_deref_698_Merge/$exit
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/ptr_deref_698_Merge/merge_req
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/ptr_deref_698_Merge/merge_ack
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Sample/rr
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_sample_start_
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Sample/$entry
      -- CP-element group 199: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Sample/rr
      -- 
    ca_1671_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 199_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_698_load_0_ack_1, ack => zeropad3D_CP_182_elements(199)); -- 
    rr_1684_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1684_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_702_inst_req_0); -- 
    rr_1698_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1698_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_712_inst_req_0); -- 
    rr_1712_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1712_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_722_inst_req_0); -- 
    rr_1726_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1726_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_732_inst_req_0); -- 
    rr_1740_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1740_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_742_inst_req_0); -- 
    rr_1754_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1754_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_752_inst_req_0); -- 
    rr_1768_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1768_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_762_inst_req_0); -- 
    rr_1782_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1782_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => type_cast_772_inst_req_0); -- 
    -- CP-element group 200:  transition  input  bypass 
    -- CP-element group 200: predecessors 
    -- CP-element group 200: 	199 
    -- CP-element group 200: successors 
    -- CP-element group 200:  members (3) 
      -- CP-element group 200: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_sample_completed_
      -- CP-element group 200: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Sample/$exit
      -- CP-element group 200: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Sample/ra
      -- 
    ra_1685_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 200_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_702_inst_ack_0, ack => zeropad3D_CP_182_elements(200)); -- 
    -- CP-element group 201:  transition  input  bypass 
    -- CP-element group 201: predecessors 
    -- CP-element group 201: 	254 
    -- CP-element group 201: successors 
    -- CP-element group 201: 	236 
    -- CP-element group 201:  members (3) 
      -- CP-element group 201: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_update_completed_
      -- CP-element group 201: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Update/$exit
      -- CP-element group 201: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Update/ca
      -- 
    ca_1690_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 201_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_702_inst_ack_1, ack => zeropad3D_CP_182_elements(201)); -- 
    -- CP-element group 202:  transition  input  bypass 
    -- CP-element group 202: predecessors 
    -- CP-element group 202: 	199 
    -- CP-element group 202: successors 
    -- CP-element group 202:  members (3) 
      -- CP-element group 202: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_sample_completed_
      -- CP-element group 202: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Sample/$exit
      -- CP-element group 202: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Sample/ra
      -- 
    ra_1699_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 202_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_712_inst_ack_0, ack => zeropad3D_CP_182_elements(202)); -- 
    -- CP-element group 203:  transition  input  bypass 
    -- CP-element group 203: predecessors 
    -- CP-element group 203: 	254 
    -- CP-element group 203: successors 
    -- CP-element group 203: 	233 
    -- CP-element group 203:  members (3) 
      -- CP-element group 203: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_update_completed_
      -- CP-element group 203: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Update/$exit
      -- CP-element group 203: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Update/ca
      -- 
    ca_1704_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 203_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_712_inst_ack_1, ack => zeropad3D_CP_182_elements(203)); -- 
    -- CP-element group 204:  transition  input  bypass 
    -- CP-element group 204: predecessors 
    -- CP-element group 204: 	199 
    -- CP-element group 204: successors 
    -- CP-element group 204:  members (3) 
      -- CP-element group 204: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_sample_completed_
      -- CP-element group 204: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Sample/$exit
      -- CP-element group 204: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Sample/ra
      -- 
    ra_1713_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 204_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_722_inst_ack_0, ack => zeropad3D_CP_182_elements(204)); -- 
    -- CP-element group 205:  transition  input  bypass 
    -- CP-element group 205: predecessors 
    -- CP-element group 205: 	254 
    -- CP-element group 205: successors 
    -- CP-element group 205: 	230 
    -- CP-element group 205:  members (3) 
      -- CP-element group 205: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_update_completed_
      -- CP-element group 205: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Update/$exit
      -- CP-element group 205: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Update/ca
      -- 
    ca_1718_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 205_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_722_inst_ack_1, ack => zeropad3D_CP_182_elements(205)); -- 
    -- CP-element group 206:  transition  input  bypass 
    -- CP-element group 206: predecessors 
    -- CP-element group 206: 	199 
    -- CP-element group 206: successors 
    -- CP-element group 206:  members (3) 
      -- CP-element group 206: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_sample_completed_
      -- CP-element group 206: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Sample/$exit
      -- CP-element group 206: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Sample/ra
      -- 
    ra_1727_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 206_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_732_inst_ack_0, ack => zeropad3D_CP_182_elements(206)); -- 
    -- CP-element group 207:  transition  input  bypass 
    -- CP-element group 207: predecessors 
    -- CP-element group 207: 	254 
    -- CP-element group 207: successors 
    -- CP-element group 207: 	227 
    -- CP-element group 207:  members (3) 
      -- CP-element group 207: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_update_completed_
      -- CP-element group 207: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Update/$exit
      -- CP-element group 207: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Update/ca
      -- 
    ca_1732_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 207_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_732_inst_ack_1, ack => zeropad3D_CP_182_elements(207)); -- 
    -- CP-element group 208:  transition  input  bypass 
    -- CP-element group 208: predecessors 
    -- CP-element group 208: 	199 
    -- CP-element group 208: successors 
    -- CP-element group 208:  members (3) 
      -- CP-element group 208: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_sample_completed_
      -- CP-element group 208: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Sample/$exit
      -- CP-element group 208: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Sample/ra
      -- 
    ra_1741_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 208_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_742_inst_ack_0, ack => zeropad3D_CP_182_elements(208)); -- 
    -- CP-element group 209:  transition  input  bypass 
    -- CP-element group 209: predecessors 
    -- CP-element group 209: 	254 
    -- CP-element group 209: successors 
    -- CP-element group 209: 	224 
    -- CP-element group 209:  members (3) 
      -- CP-element group 209: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_update_completed_
      -- CP-element group 209: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Update/$exit
      -- CP-element group 209: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Update/ca
      -- 
    ca_1746_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 209_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_742_inst_ack_1, ack => zeropad3D_CP_182_elements(209)); -- 
    -- CP-element group 210:  transition  input  bypass 
    -- CP-element group 210: predecessors 
    -- CP-element group 210: 	199 
    -- CP-element group 210: successors 
    -- CP-element group 210:  members (3) 
      -- CP-element group 210: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_sample_completed_
      -- CP-element group 210: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Sample/$exit
      -- CP-element group 210: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Sample/ra
      -- 
    ra_1755_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 210_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_752_inst_ack_0, ack => zeropad3D_CP_182_elements(210)); -- 
    -- CP-element group 211:  transition  input  bypass 
    -- CP-element group 211: predecessors 
    -- CP-element group 211: 	254 
    -- CP-element group 211: successors 
    -- CP-element group 211: 	221 
    -- CP-element group 211:  members (3) 
      -- CP-element group 211: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_update_completed_
      -- CP-element group 211: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Update/$exit
      -- CP-element group 211: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Update/ca
      -- 
    ca_1760_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 211_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_752_inst_ack_1, ack => zeropad3D_CP_182_elements(211)); -- 
    -- CP-element group 212:  transition  input  bypass 
    -- CP-element group 212: predecessors 
    -- CP-element group 212: 	199 
    -- CP-element group 212: successors 
    -- CP-element group 212:  members (3) 
      -- CP-element group 212: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_sample_completed_
      -- CP-element group 212: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Sample/$exit
      -- CP-element group 212: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Sample/ra
      -- 
    ra_1769_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 212_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_762_inst_ack_0, ack => zeropad3D_CP_182_elements(212)); -- 
    -- CP-element group 213:  transition  input  bypass 
    -- CP-element group 213: predecessors 
    -- CP-element group 213: 	254 
    -- CP-element group 213: successors 
    -- CP-element group 213: 	218 
    -- CP-element group 213:  members (3) 
      -- CP-element group 213: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_update_completed_
      -- CP-element group 213: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Update/$exit
      -- CP-element group 213: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Update/ca
      -- 
    ca_1774_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 213_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_762_inst_ack_1, ack => zeropad3D_CP_182_elements(213)); -- 
    -- CP-element group 214:  transition  input  bypass 
    -- CP-element group 214: predecessors 
    -- CP-element group 214: 	199 
    -- CP-element group 214: successors 
    -- CP-element group 214:  members (3) 
      -- CP-element group 214: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_sample_completed_
      -- CP-element group 214: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Sample/$exit
      -- CP-element group 214: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Sample/ra
      -- 
    ra_1783_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 214_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_772_inst_ack_0, ack => zeropad3D_CP_182_elements(214)); -- 
    -- CP-element group 215:  transition  input  output  bypass 
    -- CP-element group 215: predecessors 
    -- CP-element group 215: 	254 
    -- CP-element group 215: successors 
    -- CP-element group 215: 	216 
    -- CP-element group 215:  members (6) 
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_update_completed_
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Update/$exit
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Update/ca
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_sample_start_
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Sample/$entry
      -- CP-element group 215: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Sample/req
      -- 
    ca_1788_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 215_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_772_inst_ack_1, ack => zeropad3D_CP_182_elements(215)); -- 
    req_1796_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1796_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(215), ack => WPIPE_zeropad_output_pipe_774_inst_req_0); -- 
    -- CP-element group 216:  transition  input  output  bypass 
    -- CP-element group 216: predecessors 
    -- CP-element group 216: 	215 
    -- CP-element group 216: successors 
    -- CP-element group 216: 	217 
    -- CP-element group 216:  members (6) 
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_sample_completed_
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_update_start_
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Sample/$exit
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Sample/ack
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Update/$entry
      -- CP-element group 216: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Update/req
      -- 
    ack_1797_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 216_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_774_inst_ack_0, ack => zeropad3D_CP_182_elements(216)); -- 
    req_1801_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1801_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(216), ack => WPIPE_zeropad_output_pipe_774_inst_req_1); -- 
    -- CP-element group 217:  transition  input  bypass 
    -- CP-element group 217: predecessors 
    -- CP-element group 217: 	216 
    -- CP-element group 217: successors 
    -- CP-element group 217: 	218 
    -- CP-element group 217:  members (3) 
      -- CP-element group 217: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_update_completed_
      -- CP-element group 217: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Update/$exit
      -- CP-element group 217: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_774_Update/ack
      -- 
    ack_1802_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 217_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_774_inst_ack_1, ack => zeropad3D_CP_182_elements(217)); -- 
    -- CP-element group 218:  join  transition  output  bypass 
    -- CP-element group 218: predecessors 
    -- CP-element group 218: 	213 
    -- CP-element group 218: 	217 
    -- CP-element group 218: successors 
    -- CP-element group 218: 	219 
    -- CP-element group 218:  members (3) 
      -- CP-element group 218: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_sample_start_
      -- CP-element group 218: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Sample/$entry
      -- CP-element group 218: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Sample/req
      -- 
    req_1810_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1810_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(218), ack => WPIPE_zeropad_output_pipe_777_inst_req_0); -- 
    zeropad3D_cp_element_group_218: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_218"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(213) & zeropad3D_CP_182_elements(217);
      gj_zeropad3D_cp_element_group_218 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(218), clk => clk, reset => reset); --
    end block;
    -- CP-element group 219:  transition  input  output  bypass 
    -- CP-element group 219: predecessors 
    -- CP-element group 219: 	218 
    -- CP-element group 219: successors 
    -- CP-element group 219: 	220 
    -- CP-element group 219:  members (6) 
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_sample_completed_
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_update_start_
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Sample/$exit
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Sample/ack
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Update/$entry
      -- CP-element group 219: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Update/req
      -- 
    ack_1811_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 219_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_777_inst_ack_0, ack => zeropad3D_CP_182_elements(219)); -- 
    req_1815_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1815_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(219), ack => WPIPE_zeropad_output_pipe_777_inst_req_1); -- 
    -- CP-element group 220:  transition  input  bypass 
    -- CP-element group 220: predecessors 
    -- CP-element group 220: 	219 
    -- CP-element group 220: successors 
    -- CP-element group 220: 	221 
    -- CP-element group 220:  members (3) 
      -- CP-element group 220: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_update_completed_
      -- CP-element group 220: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Update/$exit
      -- CP-element group 220: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_777_Update/ack
      -- 
    ack_1816_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 220_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_777_inst_ack_1, ack => zeropad3D_CP_182_elements(220)); -- 
    -- CP-element group 221:  join  transition  output  bypass 
    -- CP-element group 221: predecessors 
    -- CP-element group 221: 	211 
    -- CP-element group 221: 	220 
    -- CP-element group 221: successors 
    -- CP-element group 221: 	222 
    -- CP-element group 221:  members (3) 
      -- CP-element group 221: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Sample/req
      -- CP-element group 221: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Sample/$entry
      -- CP-element group 221: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_sample_start_
      -- 
    req_1824_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1824_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(221), ack => WPIPE_zeropad_output_pipe_780_inst_req_0); -- 
    zeropad3D_cp_element_group_221: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_221"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(211) & zeropad3D_CP_182_elements(220);
      gj_zeropad3D_cp_element_group_221 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(221), clk => clk, reset => reset); --
    end block;
    -- CP-element group 222:  transition  input  output  bypass 
    -- CP-element group 222: predecessors 
    -- CP-element group 222: 	221 
    -- CP-element group 222: successors 
    -- CP-element group 222: 	223 
    -- CP-element group 222:  members (6) 
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Update/req
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Update/$entry
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Sample/ack
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Sample/$exit
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_sample_completed_
      -- CP-element group 222: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_update_start_
      -- 
    ack_1825_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 222_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_780_inst_ack_0, ack => zeropad3D_CP_182_elements(222)); -- 
    req_1829_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1829_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(222), ack => WPIPE_zeropad_output_pipe_780_inst_req_1); -- 
    -- CP-element group 223:  transition  input  bypass 
    -- CP-element group 223: predecessors 
    -- CP-element group 223: 	222 
    -- CP-element group 223: successors 
    -- CP-element group 223: 	224 
    -- CP-element group 223:  members (3) 
      -- CP-element group 223: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Update/ack
      -- CP-element group 223: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_Update/$exit
      -- CP-element group 223: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_780_update_completed_
      -- 
    ack_1830_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 223_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_780_inst_ack_1, ack => zeropad3D_CP_182_elements(223)); -- 
    -- CP-element group 224:  join  transition  output  bypass 
    -- CP-element group 224: predecessors 
    -- CP-element group 224: 	209 
    -- CP-element group 224: 	223 
    -- CP-element group 224: successors 
    -- CP-element group 224: 	225 
    -- CP-element group 224:  members (3) 
      -- CP-element group 224: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Sample/$entry
      -- CP-element group 224: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Sample/req
      -- CP-element group 224: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_sample_start_
      -- 
    req_1838_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1838_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(224), ack => WPIPE_zeropad_output_pipe_783_inst_req_0); -- 
    zeropad3D_cp_element_group_224: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_224"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(209) & zeropad3D_CP_182_elements(223);
      gj_zeropad3D_cp_element_group_224 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(224), clk => clk, reset => reset); --
    end block;
    -- CP-element group 225:  transition  input  output  bypass 
    -- CP-element group 225: predecessors 
    -- CP-element group 225: 	224 
    -- CP-element group 225: successors 
    -- CP-element group 225: 	226 
    -- CP-element group 225:  members (6) 
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Sample/ack
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Update/req
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Update/$entry
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_update_start_
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_sample_completed_
      -- CP-element group 225: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Sample/$exit
      -- 
    ack_1839_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 225_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_783_inst_ack_0, ack => zeropad3D_CP_182_elements(225)); -- 
    req_1843_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1843_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(225), ack => WPIPE_zeropad_output_pipe_783_inst_req_1); -- 
    -- CP-element group 226:  transition  input  bypass 
    -- CP-element group 226: predecessors 
    -- CP-element group 226: 	225 
    -- CP-element group 226: successors 
    -- CP-element group 226: 	227 
    -- CP-element group 226:  members (3) 
      -- CP-element group 226: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_update_completed_
      -- CP-element group 226: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Update/ack
      -- CP-element group 226: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_783_Update/$exit
      -- 
    ack_1844_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 226_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_783_inst_ack_1, ack => zeropad3D_CP_182_elements(226)); -- 
    -- CP-element group 227:  join  transition  output  bypass 
    -- CP-element group 227: predecessors 
    -- CP-element group 227: 	207 
    -- CP-element group 227: 	226 
    -- CP-element group 227: successors 
    -- CP-element group 227: 	228 
    -- CP-element group 227:  members (3) 
      -- CP-element group 227: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_sample_start_
      -- CP-element group 227: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Sample/req
      -- CP-element group 227: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Sample/$entry
      -- 
    req_1852_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1852_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(227), ack => WPIPE_zeropad_output_pipe_786_inst_req_0); -- 
    zeropad3D_cp_element_group_227: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_227"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(207) & zeropad3D_CP_182_elements(226);
      gj_zeropad3D_cp_element_group_227 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(227), clk => clk, reset => reset); --
    end block;
    -- CP-element group 228:  transition  input  output  bypass 
    -- CP-element group 228: predecessors 
    -- CP-element group 228: 	227 
    -- CP-element group 228: successors 
    -- CP-element group 228: 	229 
    -- CP-element group 228:  members (6) 
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_sample_completed_
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Update/req
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_update_start_
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Update/$entry
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Sample/ack
      -- CP-element group 228: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Sample/$exit
      -- 
    ack_1853_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 228_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_786_inst_ack_0, ack => zeropad3D_CP_182_elements(228)); -- 
    req_1857_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1857_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(228), ack => WPIPE_zeropad_output_pipe_786_inst_req_1); -- 
    -- CP-element group 229:  transition  input  bypass 
    -- CP-element group 229: predecessors 
    -- CP-element group 229: 	228 
    -- CP-element group 229: successors 
    -- CP-element group 229: 	230 
    -- CP-element group 229:  members (3) 
      -- CP-element group 229: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Update/ack
      -- CP-element group 229: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_Update/$exit
      -- CP-element group 229: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_786_update_completed_
      -- 
    ack_1858_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 229_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_786_inst_ack_1, ack => zeropad3D_CP_182_elements(229)); -- 
    -- CP-element group 230:  join  transition  output  bypass 
    -- CP-element group 230: predecessors 
    -- CP-element group 230: 	205 
    -- CP-element group 230: 	229 
    -- CP-element group 230: successors 
    -- CP-element group 230: 	231 
    -- CP-element group 230:  members (3) 
      -- CP-element group 230: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_sample_start_
      -- CP-element group 230: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Sample/req
      -- CP-element group 230: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Sample/$entry
      -- 
    req_1866_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1866_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(230), ack => WPIPE_zeropad_output_pipe_789_inst_req_0); -- 
    zeropad3D_cp_element_group_230: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_230"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(205) & zeropad3D_CP_182_elements(229);
      gj_zeropad3D_cp_element_group_230 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(230), clk => clk, reset => reset); --
    end block;
    -- CP-element group 231:  transition  input  output  bypass 
    -- CP-element group 231: predecessors 
    -- CP-element group 231: 	230 
    -- CP-element group 231: successors 
    -- CP-element group 231: 	232 
    -- CP-element group 231:  members (6) 
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Sample/ack
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Sample/$exit
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_update_start_
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_sample_completed_
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Update/$entry
      -- CP-element group 231: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Update/req
      -- 
    ack_1867_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 231_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_789_inst_ack_0, ack => zeropad3D_CP_182_elements(231)); -- 
    req_1871_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1871_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(231), ack => WPIPE_zeropad_output_pipe_789_inst_req_1); -- 
    -- CP-element group 232:  transition  input  bypass 
    -- CP-element group 232: predecessors 
    -- CP-element group 232: 	231 
    -- CP-element group 232: successors 
    -- CP-element group 232: 	233 
    -- CP-element group 232:  members (3) 
      -- CP-element group 232: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_update_completed_
      -- CP-element group 232: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Update/$exit
      -- CP-element group 232: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_789_Update/ack
      -- 
    ack_1872_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 232_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_789_inst_ack_1, ack => zeropad3D_CP_182_elements(232)); -- 
    -- CP-element group 233:  join  transition  output  bypass 
    -- CP-element group 233: predecessors 
    -- CP-element group 233: 	203 
    -- CP-element group 233: 	232 
    -- CP-element group 233: successors 
    -- CP-element group 233: 	234 
    -- CP-element group 233:  members (3) 
      -- CP-element group 233: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Sample/$entry
      -- CP-element group 233: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_sample_start_
      -- CP-element group 233: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Sample/req
      -- 
    req_1880_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1880_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(233), ack => WPIPE_zeropad_output_pipe_792_inst_req_0); -- 
    zeropad3D_cp_element_group_233: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_233"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(203) & zeropad3D_CP_182_elements(232);
      gj_zeropad3D_cp_element_group_233 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(233), clk => clk, reset => reset); --
    end block;
    -- CP-element group 234:  transition  input  output  bypass 
    -- CP-element group 234: predecessors 
    -- CP-element group 234: 	233 
    -- CP-element group 234: successors 
    -- CP-element group 234: 	235 
    -- CP-element group 234:  members (6) 
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_sample_completed_
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_update_start_
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Update/req
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Update/$entry
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Sample/ack
      -- CP-element group 234: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Sample/$exit
      -- 
    ack_1881_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 234_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_792_inst_ack_0, ack => zeropad3D_CP_182_elements(234)); -- 
    req_1885_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1885_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(234), ack => WPIPE_zeropad_output_pipe_792_inst_req_1); -- 
    -- CP-element group 235:  transition  input  bypass 
    -- CP-element group 235: predecessors 
    -- CP-element group 235: 	234 
    -- CP-element group 235: successors 
    -- CP-element group 235: 	236 
    -- CP-element group 235:  members (3) 
      -- CP-element group 235: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_update_completed_
      -- CP-element group 235: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Update/ack
      -- CP-element group 235: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_792_Update/$exit
      -- 
    ack_1886_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 235_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_792_inst_ack_1, ack => zeropad3D_CP_182_elements(235)); -- 
    -- CP-element group 236:  join  transition  output  bypass 
    -- CP-element group 236: predecessors 
    -- CP-element group 236: 	201 
    -- CP-element group 236: 	235 
    -- CP-element group 236: successors 
    -- CP-element group 236: 	237 
    -- CP-element group 236:  members (3) 
      -- CP-element group 236: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Sample/req
      -- CP-element group 236: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Sample/$entry
      -- CP-element group 236: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_sample_start_
      -- 
    req_1894_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1894_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(236), ack => WPIPE_zeropad_output_pipe_795_inst_req_0); -- 
    zeropad3D_cp_element_group_236: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_236"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(201) & zeropad3D_CP_182_elements(235);
      gj_zeropad3D_cp_element_group_236 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(236), clk => clk, reset => reset); --
    end block;
    -- CP-element group 237:  transition  input  output  bypass 
    -- CP-element group 237: predecessors 
    -- CP-element group 237: 	236 
    -- CP-element group 237: successors 
    -- CP-element group 237: 	238 
    -- CP-element group 237:  members (6) 
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Update/$entry
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Sample/ack
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Update/req
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Sample/$exit
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_update_start_
      -- CP-element group 237: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_sample_completed_
      -- 
    ack_1895_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 237_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_795_inst_ack_0, ack => zeropad3D_CP_182_elements(237)); -- 
    req_1899_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1899_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(237), ack => WPIPE_zeropad_output_pipe_795_inst_req_1); -- 
    -- CP-element group 238:  transition  input  bypass 
    -- CP-element group 238: predecessors 
    -- CP-element group 238: 	237 
    -- CP-element group 238: successors 
    -- CP-element group 238: 	239 
    -- CP-element group 238:  members (3) 
      -- CP-element group 238: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Update/$exit
      -- CP-element group 238: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_Update/ack
      -- CP-element group 238: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/WPIPE_zeropad_output_pipe_795_update_completed_
      -- 
    ack_1900_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 238_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_795_inst_ack_1, ack => zeropad3D_CP_182_elements(238)); -- 
    -- CP-element group 239:  branch  join  transition  place  output  bypass 
    -- CP-element group 239: predecessors 
    -- CP-element group 239: 	194 
    -- CP-element group 239: 	238 
    -- CP-element group 239: successors 
    -- CP-element group 239: 	240 
    -- CP-element group 239: 	241 
    -- CP-element group 239:  members (10) 
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_eval_test/branch_req
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_else_link/$entry
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_if_link/$entry
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_eval_test/$entry
      -- CP-element group 239: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808__exit__
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809__entry__
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_dead_link/$entry
      -- CP-element group 239: 	 branch_block_stmt_49/if_stmt_809_eval_test/$exit
      -- CP-element group 239: 	 branch_block_stmt_49/R_exitcond2_810_place
      -- CP-element group 239: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/$exit
      -- 
    branch_req_1908_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_1908_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(239), ack => if_stmt_809_branch_req_0); -- 
    zeropad3D_cp_element_group_239: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_239"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(194) & zeropad3D_CP_182_elements(238);
      gj_zeropad3D_cp_element_group_239 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(239), clk => clk, reset => reset); --
    end block;
    -- CP-element group 240:  merge  transition  place  input  bypass 
    -- CP-element group 240: predecessors 
    -- CP-element group 240: 	239 
    -- CP-element group 240: successors 
    -- CP-element group 240: 	255 
    -- CP-element group 240:  members (13) 
      -- CP-element group 240: 	 branch_block_stmt_49/merge_stmt_815_PhiReqMerge
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit_PhiReq/$exit
      -- CP-element group 240: 	 branch_block_stmt_49/merge_stmt_815__exit__
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308
      -- CP-element group 240: 	 branch_block_stmt_49/if_stmt_809_if_link/$exit
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit_PhiReq/$entry
      -- CP-element group 240: 	 branch_block_stmt_49/if_stmt_809_if_link/if_choice_transition
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308_PhiReq/$exit
      -- CP-element group 240: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308_PhiReq/$entry
      -- CP-element group 240: 	 branch_block_stmt_49/merge_stmt_815_PhiAck/dummy
      -- CP-element group 240: 	 branch_block_stmt_49/merge_stmt_815_PhiAck/$exit
      -- CP-element group 240: 	 branch_block_stmt_49/merge_stmt_815_PhiAck/$entry
      -- 
    if_choice_transition_1913_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 240_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_809_branch_ack_1, ack => zeropad3D_CP_182_elements(240)); -- 
    -- CP-element group 241:  fork  transition  place  input  output  bypass 
    -- CP-element group 241: predecessors 
    -- CP-element group 241: 	239 
    -- CP-element group 241: successors 
    -- CP-element group 241: 	250 
    -- CP-element group 241: 	251 
    -- CP-element group 241:  members (12) 
      -- CP-element group 241: 	 branch_block_stmt_49/if_stmt_809_else_link/$exit
      -- CP-element group 241: 	 branch_block_stmt_49/if_stmt_809_else_link/else_choice_transition
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Update/cr
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Update/$entry
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Sample/rr
      -- CP-element group 241: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Sample/$entry
      -- 
    else_choice_transition_1917_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 241_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_809_branch_ack_0, ack => zeropad3D_CP_182_elements(241)); -- 
    cr_2043_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2043_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(241), ack => type_cast_687_inst_req_1); -- 
    rr_2038_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2038_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(241), ack => type_cast_687_inst_req_0); -- 
    -- CP-element group 242:  transition  output  delay-element  bypass 
    -- CP-element group 242: predecessors 
    -- CP-element group 242: 	75 
    -- CP-element group 242: successors 
    -- CP-element group 242: 	246 
    -- CP-element group 242:  members (5) 
      -- CP-element group 242: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_req
      -- CP-element group 242: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_314_konst_delay_trans
      -- CP-element group 242: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/$exit
      -- CP-element group 242: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$exit
      -- CP-element group 242: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/$exit
      -- 
    phi_stmt_310_req_1942_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_310_req_1942_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(242), ack => phi_stmt_310_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(242) is a control-delay.
    cp_element_242_delay: control_delay_element  generic map(name => " 242_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(75), ack => zeropad3D_CP_182_elements(242), clk => clk, reset =>reset);
    -- CP-element group 243:  transition  input  bypass 
    -- CP-element group 243: predecessors 
    -- CP-element group 243: 	118 
    -- CP-element group 243: successors 
    -- CP-element group 243: 	245 
    -- CP-element group 243:  members (2) 
      -- CP-element group 243: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/ra
      -- CP-element group 243: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/$exit
      -- 
    ra_1962_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 243_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_316_inst_ack_0, ack => zeropad3D_CP_182_elements(243)); -- 
    -- CP-element group 244:  transition  input  bypass 
    -- CP-element group 244: predecessors 
    -- CP-element group 244: 	118 
    -- CP-element group 244: successors 
    -- CP-element group 244: 	245 
    -- CP-element group 244:  members (2) 
      -- CP-element group 244: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/ca
      -- CP-element group 244: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/$exit
      -- 
    ca_1967_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 244_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_316_inst_ack_1, ack => zeropad3D_CP_182_elements(244)); -- 
    -- CP-element group 245:  join  transition  output  bypass 
    -- CP-element group 245: predecessors 
    -- CP-element group 245: 	243 
    -- CP-element group 245: 	244 
    -- CP-element group 245: successors 
    -- CP-element group 245: 	246 
    -- CP-element group 245:  members (6) 
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_req
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/$exit
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/$exit
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$exit
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/$exit
      -- CP-element group 245: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/$exit
      -- 
    phi_stmt_310_req_1968_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_310_req_1968_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(245), ack => phi_stmt_310_req_1); -- 
    zeropad3D_cp_element_group_245: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_245"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(243) & zeropad3D_CP_182_elements(244);
      gj_zeropad3D_cp_element_group_245 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(245), clk => clk, reset => reset); --
    end block;
    -- CP-element group 246:  merge  transition  place  bypass 
    -- CP-element group 246: predecessors 
    -- CP-element group 246: 	242 
    -- CP-element group 246: 	245 
    -- CP-element group 246: successors 
    -- CP-element group 246: 	247 
    -- CP-element group 246:  members (2) 
      -- CP-element group 246: 	 branch_block_stmt_49/merge_stmt_309_PhiReqMerge
      -- CP-element group 246: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/$entry
      -- 
    zeropad3D_CP_182_elements(246) <= OrReduce(zeropad3D_CP_182_elements(242) & zeropad3D_CP_182_elements(245));
    -- CP-element group 247:  fork  transition  place  input  output  bypass 
    -- CP-element group 247: predecessors 
    -- CP-element group 247: 	246 
    -- CP-element group 247: successors 
    -- CP-element group 247: 	96 
    -- CP-element group 247: 	100 
    -- CP-element group 247: 	104 
    -- CP-element group 247: 	92 
    -- CP-element group 247: 	108 
    -- CP-element group 247: 	112 
    -- CP-element group 247: 	115 
    -- CP-element group 247: 	88 
    -- CP-element group 247: 	77 
    -- CP-element group 247: 	78 
    -- CP-element group 247: 	80 
    -- CP-element group 247: 	81 
    -- CP-element group 247: 	84 
    -- CP-element group 247:  members (56) 
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/merge_stmt_309__exit__
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472__entry__
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resized_1
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scaled_1
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_computed_1
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/$exit
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/index_resize_req
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/index_resize_ack
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/$exit
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/scale_rename_req
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/scale_rename_ack
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_update_start
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/req
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/req
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/req
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_sample_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/rr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/$entry
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/cr
      -- CP-element group 247: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_update_start_
      -- CP-element group 247: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/phi_stmt_310_ack
      -- CP-element group 247: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/$exit
      -- 
    phi_stmt_310_ack_1973_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 247_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_310_ack_0, ack => zeropad3D_CP_182_elements(247)); -- 
    cr_1022_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1022_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_451_inst_req_1); -- 
    cr_966_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_966_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_415_inst_req_1); -- 
    cr_910_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_910_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_379_inst_req_1); -- 
    cr_1072_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1072_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => ptr_deref_459_store_0_req_1); -- 
    cr_994_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_994_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_433_inst_req_1); -- 
    cr_938_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_938_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_397_inst_req_1); -- 
    req_778_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_778_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => array_obj_ref_322_index_offset_req_0); -- 
    req_783_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_783_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => array_obj_ref_322_index_offset_req_1); -- 
    req_798_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_798_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => addr_of_323_final_reg_req_1); -- 
    rr_807_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_807_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => RPIPE_zeropad_input_pipe_326_inst_req_0); -- 
    cr_826_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_826_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_330_inst_req_1); -- 
    cr_854_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_854_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_343_inst_req_1); -- 
    cr_882_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_882_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(247), ack => type_cast_361_inst_req_1); -- 
    -- CP-element group 248:  merge  fork  transition  place  output  bypass 
    -- CP-element group 248: predecessors 
    -- CP-element group 248: 	117 
    -- CP-element group 248: 	76 
    -- CP-element group 248: successors 
    -- CP-element group 248: 	119 
    -- CP-element group 248: 	120 
    -- CP-element group 248: 	122 
    -- CP-element group 248:  members (16) 
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/merge_stmt_481__exit__
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489__entry__
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/crr
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_update_start_
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_sample_start_
      -- CP-element group 248: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/$exit
      -- CP-element group 248: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/dummy
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/cr
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/ccr
      -- CP-element group 248: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_update_start_
      -- CP-element group 248: 	 branch_block_stmt_49/merge_stmt_481_PhiReqMerge
      -- 
    crr_1103_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_1103_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(248), ack => call_stmt_484_call_req_0); -- 
    cr_1122_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1122_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(248), ack => type_cast_488_inst_req_1); -- 
    ccr_1108_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_1108_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(248), ack => call_stmt_484_call_req_1); -- 
    zeropad3D_CP_182_elements(248) <= OrReduce(zeropad3D_CP_182_elements(117) & zeropad3D_CP_182_elements(76));
    -- CP-element group 249:  transition  output  delay-element  bypass 
    -- CP-element group 249: predecessors 
    -- CP-element group 249: 	193 
    -- CP-element group 249: successors 
    -- CP-element group 249: 	253 
    -- CP-element group 249:  members (5) 
      -- CP-element group 249: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/$exit
      -- CP-element group 249: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/$exit
      -- CP-element group 249: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/$exit
      -- CP-element group 249: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_685_konst_delay_trans
      -- CP-element group 249: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_req
      -- 
    phi_stmt_681_req_2019_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_681_req_2019_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(249), ack => phi_stmt_681_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(249) is a control-delay.
    cp_element_249_delay: control_delay_element  generic map(name => " 249_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(193), ack => zeropad3D_CP_182_elements(249), clk => clk, reset =>reset);
    -- CP-element group 250:  transition  input  bypass 
    -- CP-element group 250: predecessors 
    -- CP-element group 250: 	241 
    -- CP-element group 250: successors 
    -- CP-element group 250: 	252 
    -- CP-element group 250:  members (2) 
      -- CP-element group 250: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Sample/ra
      -- CP-element group 250: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Sample/$exit
      -- 
    ra_2039_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 250_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_687_inst_ack_0, ack => zeropad3D_CP_182_elements(250)); -- 
    -- CP-element group 251:  transition  input  bypass 
    -- CP-element group 251: predecessors 
    -- CP-element group 251: 	241 
    -- CP-element group 251: successors 
    -- CP-element group 251: 	252 
    -- CP-element group 251:  members (2) 
      -- CP-element group 251: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Update/ca
      -- CP-element group 251: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/Update/$exit
      -- 
    ca_2044_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 251_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_687_inst_ack_1, ack => zeropad3D_CP_182_elements(251)); -- 
    -- CP-element group 252:  join  transition  output  bypass 
    -- CP-element group 252: predecessors 
    -- CP-element group 252: 	250 
    -- CP-element group 252: 	251 
    -- CP-element group 252: successors 
    -- CP-element group 252: 	253 
    -- CP-element group 252:  members (6) 
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/$exit
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/$exit
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/$exit
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/$exit
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_req
      -- CP-element group 252: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_681/phi_stmt_681_sources/type_cast_687/SplitProtocol/$exit
      -- 
    phi_stmt_681_req_2045_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_681_req_2045_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(252), ack => phi_stmt_681_req_1); -- 
    zeropad3D_cp_element_group_252: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_252"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(250) & zeropad3D_CP_182_elements(251);
      gj_zeropad3D_cp_element_group_252 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(252), clk => clk, reset => reset); --
    end block;
    -- CP-element group 253:  merge  transition  place  bypass 
    -- CP-element group 253: predecessors 
    -- CP-element group 253: 	249 
    -- CP-element group 253: 	252 
    -- CP-element group 253: successors 
    -- CP-element group 253: 	254 
    -- CP-element group 253:  members (2) 
      -- CP-element group 253: 	 branch_block_stmt_49/merge_stmt_680_PhiReqMerge
      -- CP-element group 253: 	 branch_block_stmt_49/merge_stmt_680_PhiAck/$entry
      -- 
    zeropad3D_CP_182_elements(253) <= OrReduce(zeropad3D_CP_182_elements(249) & zeropad3D_CP_182_elements(252));
    -- CP-element group 254:  fork  transition  place  input  output  bypass 
    -- CP-element group 254: predecessors 
    -- CP-element group 254: 	253 
    -- CP-element group 254: successors 
    -- CP-element group 254: 	194 
    -- CP-element group 254: 	195 
    -- CP-element group 254: 	197 
    -- CP-element group 254: 	199 
    -- CP-element group 254: 	201 
    -- CP-element group 254: 	203 
    -- CP-element group 254: 	205 
    -- CP-element group 254: 	207 
    -- CP-element group 254: 	209 
    -- CP-element group 254: 	211 
    -- CP-element group 254: 	213 
    -- CP-element group 254: 	215 
    -- CP-element group 254:  members (53) 
      -- CP-element group 254: 	 branch_block_stmt_49/merge_stmt_680__exit__
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808__entry__
      -- CP-element group 254: 	 branch_block_stmt_49/merge_stmt_680_PhiAck/phi_stmt_681_ack
      -- CP-element group 254: 	 branch_block_stmt_49/merge_stmt_680_PhiAck/$exit
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_resized_1
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_scaled_1
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_computed_1
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_resize_1/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_resize_1/$exit
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_resize_1/index_resize_req
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_resize_1/index_resize_ack
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_scale_1/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_scale_1/$exit
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_scale_1/scale_rename_req
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_index_scale_1/scale_rename_ack
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_update_start
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Sample/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Sample/req
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/array_obj_ref_693_final_index_sum_regn_Update/req
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_complete/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/addr_of_694_complete/req
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/word_0/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/ptr_deref_698_Update/word_access_complete/word_0/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_702_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_712_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_722_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_732_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_742_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_752_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_762_Update/cr
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_update_start_
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Update/$entry
      -- CP-element group 254: 	 branch_block_stmt_49/assign_stmt_695_to_assign_stmt_808/type_cast_772_Update/cr
      -- 
    phi_stmt_681_ack_2050_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 254_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_681_ack_0, ack => zeropad3D_CP_182_elements(254)); -- 
    req_1605_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1605_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => array_obj_ref_693_index_offset_req_0); -- 
    req_1610_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1610_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => array_obj_ref_693_index_offset_req_1); -- 
    req_1625_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1625_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => addr_of_694_final_reg_req_1); -- 
    cr_1670_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1670_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => ptr_deref_698_load_0_req_1); -- 
    cr_1689_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1689_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_702_inst_req_1); -- 
    cr_1703_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1703_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_712_inst_req_1); -- 
    cr_1717_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1717_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_722_inst_req_1); -- 
    cr_1731_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1731_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_732_inst_req_1); -- 
    cr_1745_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1745_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_742_inst_req_1); -- 
    cr_1759_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1759_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_752_inst_req_1); -- 
    cr_1773_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1773_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_762_inst_req_1); -- 
    cr_1787_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1787_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(254), ack => type_cast_772_inst_req_1); -- 
    -- CP-element group 255:  merge  transition  place  bypass 
    -- CP-element group 255: predecessors 
    -- CP-element group 255: 	191 
    -- CP-element group 255: 	240 
    -- CP-element group 255: successors 
    -- CP-element group 255:  members (16) 
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_817_PhiReqMerge
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_819_PhiReqMerge
      -- CP-element group 255: 	 $exit
      -- CP-element group 255: 	 branch_block_stmt_49/$exit
      -- CP-element group 255: 	 branch_block_stmt_49/branch_block_stmt_49__exit__
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_817__exit__
      -- CP-element group 255: 	 branch_block_stmt_49/return__
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_819__exit__
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_819_PhiAck/dummy
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_819_PhiAck/$exit
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_819_PhiAck/$entry
      -- CP-element group 255: 	 branch_block_stmt_49/return___PhiReq/$exit
      -- CP-element group 255: 	 branch_block_stmt_49/return___PhiReq/$entry
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_817_PhiAck/dummy
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_817_PhiAck/$exit
      -- CP-element group 255: 	 branch_block_stmt_49/merge_stmt_817_PhiAck/$entry
      -- 
    zeropad3D_CP_182_elements(255) <= OrReduce(zeropad3D_CP_182_elements(191) & zeropad3D_CP_182_elements(240));
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal ASHR_i32_i32_657_wire : std_logic_vector(31 downto 0);
    signal ASHR_i64_i64_272_wire : std_logic_vector(63 downto 0);
    signal R_indvar317_321_resized : std_logic_vector(13 downto 0);
    signal R_indvar317_321_scaled : std_logic_vector(13 downto 0);
    signal R_indvar_692_resized : std_logic_vector(13 downto 0);
    signal R_indvar_692_scaled : std_logic_vector(13 downto 0);
    signal add100_349 : std_logic_vector(63 downto 0);
    signal add106_367 : std_logic_vector(63 downto 0);
    signal add112_385 : std_logic_vector(63 downto 0);
    signal add118_403 : std_logic_vector(63 downto 0);
    signal add124_421 : std_logic_vector(63 downto 0);
    signal add130_439 : std_logic_vector(63 downto 0);
    signal add136_457 : std_logic_vector(63 downto 0);
    signal add23_86 : std_logic_vector(15 downto 0);
    signal add32_111 : std_logic_vector(15 downto 0);
    signal add41_136 : std_logic_vector(15 downto 0);
    signal add50_161 : std_logic_vector(15 downto 0);
    signal add59_186 : std_logic_vector(15 downto 0);
    signal add68_211 : std_logic_vector(15 downto 0);
    signal add77_236 : std_logic_vector(15 downto 0);
    signal array_obj_ref_322_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_root_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_693_root_address : std_logic_vector(13 downto 0);
    signal arrayidx240_695 : std_logic_vector(31 downto 0);
    signal arrayidx_324 : std_logic_vector(31 downto 0);
    signal call103_358 : std_logic_vector(7 downto 0);
    signal call109_376 : std_logic_vector(7 downto 0);
    signal call115_394 : std_logic_vector(7 downto 0);
    signal call11_61 : std_logic_vector(7 downto 0);
    signal call121_412 : std_logic_vector(7 downto 0);
    signal call127_430 : std_logic_vector(7 downto 0);
    signal call133_448 : std_logic_vector(7 downto 0);
    signal call141_484 : std_logic_vector(63 downto 0);
    signal call151_514 : std_logic_vector(15 downto 0);
    signal call153_517 : std_logic_vector(63 downto 0);
    signal call16_64 : std_logic_vector(7 downto 0);
    signal call21_77 : std_logic_vector(7 downto 0);
    signal call25_89 : std_logic_vector(7 downto 0);
    signal call2_55 : std_logic_vector(7 downto 0);
    signal call30_102 : std_logic_vector(7 downto 0);
    signal call34_114 : std_logic_vector(7 downto 0);
    signal call39_127 : std_logic_vector(7 downto 0);
    signal call43_139 : std_logic_vector(7 downto 0);
    signal call48_152 : std_logic_vector(7 downto 0);
    signal call52_164 : std_logic_vector(7 downto 0);
    signal call57_177 : std_logic_vector(7 downto 0);
    signal call61_189 : std_logic_vector(7 downto 0);
    signal call66_202 : std_logic_vector(7 downto 0);
    signal call6_58 : std_logic_vector(7 downto 0);
    signal call70_214 : std_logic_vector(7 downto 0);
    signal call75_227 : std_logic_vector(7 downto 0);
    signal call93_327 : std_logic_vector(7 downto 0);
    signal call97_340 : std_logic_vector(7 downto 0);
    signal call_52 : std_logic_vector(7 downto 0);
    signal cmp233310_667 : std_logic_vector(0 downto 0);
    signal cmp314_281 : std_logic_vector(0 downto 0);
    signal conv105_362 : std_logic_vector(63 downto 0);
    signal conv111_380 : std_logic_vector(63 downto 0);
    signal conv117_398 : std_logic_vector(63 downto 0);
    signal conv123_416 : std_logic_vector(63 downto 0);
    signal conv129_434 : std_logic_vector(63 downto 0);
    signal conv135_452 : std_logic_vector(63 downto 0);
    signal conv142_489 : std_logic_vector(63 downto 0);
    signal conv154_522 : std_logic_vector(63 downto 0);
    signal conv160_532 : std_logic_vector(7 downto 0);
    signal conv166_542 : std_logic_vector(7 downto 0);
    signal conv172_552 : std_logic_vector(7 downto 0);
    signal conv178_562 : std_logic_vector(7 downto 0);
    signal conv184_572 : std_logic_vector(7 downto 0);
    signal conv190_582 : std_logic_vector(7 downto 0);
    signal conv196_592 : std_logic_vector(7 downto 0);
    signal conv19_68 : std_logic_vector(15 downto 0);
    signal conv202_602 : std_logic_vector(7 downto 0);
    signal conv222_631 : std_logic_vector(31 downto 0);
    signal conv224_635 : std_logic_vector(31 downto 0);
    signal conv227_639 : std_logic_vector(31 downto 0);
    signal conv22_81 : std_logic_vector(15 downto 0);
    signal conv245_703 : std_logic_vector(7 downto 0);
    signal conv251_713 : std_logic_vector(7 downto 0);
    signal conv257_723 : std_logic_vector(7 downto 0);
    signal conv263_733 : std_logic_vector(7 downto 0);
    signal conv269_743 : std_logic_vector(7 downto 0);
    signal conv275_753 : std_logic_vector(7 downto 0);
    signal conv281_763 : std_logic_vector(7 downto 0);
    signal conv287_773 : std_logic_vector(7 downto 0);
    signal conv28_93 : std_logic_vector(15 downto 0);
    signal conv31_106 : std_logic_vector(15 downto 0);
    signal conv37_118 : std_logic_vector(15 downto 0);
    signal conv40_131 : std_logic_vector(15 downto 0);
    signal conv46_143 : std_logic_vector(15 downto 0);
    signal conv49_156 : std_logic_vector(15 downto 0);
    signal conv55_168 : std_logic_vector(15 downto 0);
    signal conv58_181 : std_logic_vector(15 downto 0);
    signal conv64_193 : std_logic_vector(15 downto 0);
    signal conv67_206 : std_logic_vector(15 downto 0);
    signal conv73_218 : std_logic_vector(15 downto 0);
    signal conv76_231 : std_logic_vector(15 downto 0);
    signal conv81_240 : std_logic_vector(63 downto 0);
    signal conv83_244 : std_logic_vector(63 downto 0);
    signal conv85_248 : std_logic_vector(63 downto 0);
    signal conv87_274 : std_logic_vector(63 downto 0);
    signal conv94_331 : std_logic_vector(63 downto 0);
    signal conv99_344 : std_logic_vector(63 downto 0);
    signal exitcond2_808 : std_logic_vector(0 downto 0);
    signal exitcond_472 : std_logic_vector(0 downto 0);
    signal indvar317_310 : std_logic_vector(63 downto 0);
    signal indvar_681 : std_logic_vector(63 downto 0);
    signal indvarx_xnext318_467 : std_logic_vector(63 downto 0);
    signal indvarx_xnext_803 : std_logic_vector(63 downto 0);
    signal mul225_644 : std_logic_vector(31 downto 0);
    signal mul228_649 : std_logic_vector(31 downto 0);
    signal mul86_259 : std_logic_vector(63 downto 0);
    signal mul_254 : std_logic_vector(63 downto 0);
    signal ptr_deref_459_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_459_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_459_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_459_wire : std_logic_vector(63 downto 0);
    signal ptr_deref_459_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_459_word_offset_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_698_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_698_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_698_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_698_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_698_word_offset_0 : std_logic_vector(13 downto 0);
    signal sext_264 : std_logic_vector(63 downto 0);
    signal shl102_355 : std_logic_vector(63 downto 0);
    signal shl108_373 : std_logic_vector(63 downto 0);
    signal shl114_391 : std_logic_vector(63 downto 0);
    signal shl120_409 : std_logic_vector(63 downto 0);
    signal shl126_427 : std_logic_vector(63 downto 0);
    signal shl132_445 : std_logic_vector(63 downto 0);
    signal shl20_74 : std_logic_vector(15 downto 0);
    signal shl29_99 : std_logic_vector(15 downto 0);
    signal shl38_124 : std_logic_vector(15 downto 0);
    signal shl47_149 : std_logic_vector(15 downto 0);
    signal shl56_174 : std_logic_vector(15 downto 0);
    signal shl65_199 : std_logic_vector(15 downto 0);
    signal shl74_224 : std_logic_vector(15 downto 0);
    signal shl96_337 : std_logic_vector(63 downto 0);
    signal shr163_538 : std_logic_vector(63 downto 0);
    signal shr169_548 : std_logic_vector(63 downto 0);
    signal shr175_558 : std_logic_vector(63 downto 0);
    signal shr181_568 : std_logic_vector(63 downto 0);
    signal shr187_578 : std_logic_vector(63 downto 0);
    signal shr193_588 : std_logic_vector(63 downto 0);
    signal shr199_598 : std_logic_vector(63 downto 0);
    signal shr232309_659 : std_logic_vector(31 downto 0);
    signal shr248_709 : std_logic_vector(63 downto 0);
    signal shr254_719 : std_logic_vector(63 downto 0);
    signal shr260_729 : std_logic_vector(63 downto 0);
    signal shr266_739 : std_logic_vector(63 downto 0);
    signal shr272_749 : std_logic_vector(63 downto 0);
    signal shr278_759 : std_logic_vector(63 downto 0);
    signal shr284_769 : std_logic_vector(63 downto 0);
    signal shr_294 : std_logic_vector(63 downto 0);
    signal sub_527 : std_logic_vector(63 downto 0);
    signal tmp1_678 : std_logic_vector(63 downto 0);
    signal tmp241_699 : std_logic_vector(63 downto 0);
    signal tmp_300 : std_logic_vector(0 downto 0);
    signal type_cast_122_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_147_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_172_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_197_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_222_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_252_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_268_wire : std_logic_vector(63 downto 0);
    signal type_cast_271_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_278_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_292_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_298_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_305_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_314_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_316_wire : std_logic_vector(63 downto 0);
    signal type_cast_335_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_353_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_371_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_389_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_407_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_425_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_443_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_465_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_487_wire : std_logic_vector(63 downto 0);
    signal type_cast_520_wire : std_logic_vector(63 downto 0);
    signal type_cast_536_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_546_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_556_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_566_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_576_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_586_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_596_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_653_wire : std_logic_vector(31 downto 0);
    signal type_cast_656_wire_constant : std_logic_vector(31 downto 0);
    signal type_cast_662_wire : std_logic_vector(31 downto 0);
    signal type_cast_665_wire_constant : std_logic_vector(31 downto 0);
    signal type_cast_685_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_687_wire : std_logic_vector(63 downto 0);
    signal type_cast_707_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_717_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_727_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_72_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_737_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_747_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_757_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_767_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_801_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_97_wire_constant : std_logic_vector(15 downto 0);
    signal umax3_307 : std_logic_vector(63 downto 0);
    -- 
  begin -- 
    array_obj_ref_322_constant_part_of_offset <= "00000000000000";
    array_obj_ref_322_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_322_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_322_resized_base_address <= "00000000000000";
    array_obj_ref_693_constant_part_of_offset <= "00000000000000";
    array_obj_ref_693_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_693_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_693_resized_base_address <= "00000000000000";
    ptr_deref_459_word_offset_0 <= "00000000000000";
    ptr_deref_698_word_offset_0 <= "00000000000000";
    type_cast_122_wire_constant <= "0000000000001000";
    type_cast_147_wire_constant <= "0000000000001000";
    type_cast_172_wire_constant <= "0000000000001000";
    type_cast_197_wire_constant <= "0000000000001000";
    type_cast_222_wire_constant <= "0000000000001000";
    type_cast_252_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_271_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_278_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000111";
    type_cast_292_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000011";
    type_cast_298_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
    type_cast_305_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
    type_cast_314_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
    type_cast_335_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_353_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_371_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_389_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_407_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_425_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_443_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_465_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
    type_cast_536_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_546_wire_constant <= "0000000000000000000000000000000000000000000000000000000000010000";
    type_cast_556_wire_constant <= "0000000000000000000000000000000000000000000000000000000000011000";
    type_cast_566_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_576_wire_constant <= "0000000000000000000000000000000000000000000000000000000000101000";
    type_cast_586_wire_constant <= "0000000000000000000000000000000000000000000000000000000000110000";
    type_cast_596_wire_constant <= "0000000000000000000000000000000000000000000000000000000000111000";
    type_cast_656_wire_constant <= "00000000000000000000000000000010";
    type_cast_665_wire_constant <= "00000000000000000000000000000000";
    type_cast_685_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
    type_cast_707_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_717_wire_constant <= "0000000000000000000000000000000000000000000000000000000000010000";
    type_cast_727_wire_constant <= "0000000000000000000000000000000000000000000000000000000000011000";
    type_cast_72_wire_constant <= "0000000000001000";
    type_cast_737_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_747_wire_constant <= "0000000000000000000000000000000000000000000000000000000000101000";
    type_cast_757_wire_constant <= "0000000000000000000000000000000000000000000000000000000000110000";
    type_cast_767_wire_constant <= "0000000000000000000000000000000000000000000000000000000000111000";
    type_cast_801_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
    type_cast_97_wire_constant <= "0000000000001000";
    phi_stmt_310: Block -- phi operator 
      signal idata: std_logic_vector(127 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= type_cast_314_wire_constant & type_cast_316_wire;
      req <= phi_stmt_310_req_0 & phi_stmt_310_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_310",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 64) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_310_ack_0,
          idata => idata,
          odata => indvar317_310,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_310
    phi_stmt_681: Block -- phi operator 
      signal idata: std_logic_vector(127 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= type_cast_685_wire_constant & type_cast_687_wire;
      req <= phi_stmt_681_req_0 & phi_stmt_681_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_681",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 64) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_681_ack_0,
          idata => idata,
          odata => indvar_681,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_681
    -- flow-through select operator MUX_306_inst
    umax3_307 <= shr_294 when (tmp_300(0) /=  '0') else type_cast_305_wire_constant;
    addr_of_323_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_323_final_reg_req_0;
      addr_of_323_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_323_final_reg_req_1;
      addr_of_323_final_reg_ack_1<= rack(0);
      addr_of_323_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_323_final_reg",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 14,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => array_obj_ref_322_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => arrayidx_324,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    addr_of_694_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_694_final_reg_req_0;
      addr_of_694_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_694_final_reg_req_1;
      addr_of_694_final_reg_ack_1<= rack(0);
      addr_of_694_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_694_final_reg",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 14,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => array_obj_ref_693_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => arrayidx240_695,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_105_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_105_inst_req_0;
      type_cast_105_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_105_inst_req_1;
      type_cast_105_inst_ack_1<= rack(0);
      type_cast_105_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_105_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call30_102,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv31_106,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_117_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_117_inst_req_0;
      type_cast_117_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_117_inst_req_1;
      type_cast_117_inst_ack_1<= rack(0);
      type_cast_117_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_117_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call34_114,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv37_118,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_130_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_130_inst_req_0;
      type_cast_130_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_130_inst_req_1;
      type_cast_130_inst_ack_1<= rack(0);
      type_cast_130_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_130_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call39_127,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv40_131,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_142_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_142_inst_req_0;
      type_cast_142_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_142_inst_req_1;
      type_cast_142_inst_ack_1<= rack(0);
      type_cast_142_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_142_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call43_139,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv46_143,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_155_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_155_inst_req_0;
      type_cast_155_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_155_inst_req_1;
      type_cast_155_inst_ack_1<= rack(0);
      type_cast_155_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_155_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call48_152,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv49_156,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_167_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_167_inst_req_0;
      type_cast_167_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_167_inst_req_1;
      type_cast_167_inst_ack_1<= rack(0);
      type_cast_167_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_167_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call52_164,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv55_168,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_180_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_180_inst_req_0;
      type_cast_180_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_180_inst_req_1;
      type_cast_180_inst_ack_1<= rack(0);
      type_cast_180_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_180_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call57_177,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv58_181,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_192_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_192_inst_req_0;
      type_cast_192_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_192_inst_req_1;
      type_cast_192_inst_ack_1<= rack(0);
      type_cast_192_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_192_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call61_189,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv64_193,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_205_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_205_inst_req_0;
      type_cast_205_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_205_inst_req_1;
      type_cast_205_inst_ack_1<= rack(0);
      type_cast_205_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_205_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call66_202,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv67_206,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_217_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_217_inst_req_0;
      type_cast_217_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_217_inst_req_1;
      type_cast_217_inst_ack_1<= rack(0);
      type_cast_217_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_217_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call70_214,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv73_218,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_230_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_230_inst_req_0;
      type_cast_230_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_230_inst_req_1;
      type_cast_230_inst_ack_1<= rack(0);
      type_cast_230_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_230_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call75_227,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv76_231,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_239_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_239_inst_req_0;
      type_cast_239_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_239_inst_req_1;
      type_cast_239_inst_ack_1<= rack(0);
      type_cast_239_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_239_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add23_86,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv81_240,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_243_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_243_inst_req_0;
      type_cast_243_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_243_inst_req_1;
      type_cast_243_inst_ack_1<= rack(0);
      type_cast_243_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_243_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add32_111,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv83_244,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_247_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_247_inst_req_0;
      type_cast_247_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_247_inst_req_1;
      type_cast_247_inst_ack_1<= rack(0);
      type_cast_247_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_247_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add41_136,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv85_248,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock type_cast_268_inst
    process(sext_264) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 63 downto 0) := sext_264(63 downto 0);
      type_cast_268_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_273_inst
    process(ASHR_i64_i64_272_wire) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 63 downto 0) := ASHR_i64_i64_272_wire(63 downto 0);
      conv87_274 <= tmp_var; -- 
    end process;
    type_cast_316_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_316_inst_req_0;
      type_cast_316_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_316_inst_req_1;
      type_cast_316_inst_ack_1<= rack(0);
      type_cast_316_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_316_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => indvarx_xnext318_467,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => type_cast_316_wire,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_330_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_330_inst_req_0;
      type_cast_330_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_330_inst_req_1;
      type_cast_330_inst_ack_1<= rack(0);
      type_cast_330_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_330_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call93_327,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv94_331,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_343_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_343_inst_req_0;
      type_cast_343_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_343_inst_req_1;
      type_cast_343_inst_ack_1<= rack(0);
      type_cast_343_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_343_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call97_340,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv99_344,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_361_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_361_inst_req_0;
      type_cast_361_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_361_inst_req_1;
      type_cast_361_inst_ack_1<= rack(0);
      type_cast_361_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_361_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call103_358,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv105_362,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_379_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_379_inst_req_0;
      type_cast_379_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_379_inst_req_1;
      type_cast_379_inst_ack_1<= rack(0);
      type_cast_379_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_379_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call109_376,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv111_380,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_397_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_397_inst_req_0;
      type_cast_397_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_397_inst_req_1;
      type_cast_397_inst_ack_1<= rack(0);
      type_cast_397_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_397_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call115_394,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv117_398,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_415_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_415_inst_req_0;
      type_cast_415_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_415_inst_req_1;
      type_cast_415_inst_ack_1<= rack(0);
      type_cast_415_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_415_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call121_412,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv123_416,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_433_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_433_inst_req_0;
      type_cast_433_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_433_inst_req_1;
      type_cast_433_inst_ack_1<= rack(0);
      type_cast_433_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_433_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call127_430,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv129_434,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_451_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_451_inst_req_0;
      type_cast_451_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_451_inst_req_1;
      type_cast_451_inst_ack_1<= rack(0);
      type_cast_451_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_451_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call133_448,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv135_452,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_488_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_488_inst_req_0;
      type_cast_488_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_488_inst_req_1;
      type_cast_488_inst_ack_1<= rack(0);
      type_cast_488_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_488_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => type_cast_487_wire,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv142_489,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_521_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_521_inst_req_0;
      type_cast_521_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_521_inst_req_1;
      type_cast_521_inst_ack_1<= rack(0);
      type_cast_521_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_521_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => type_cast_520_wire,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv154_522,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_531_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_531_inst_req_0;
      type_cast_531_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_531_inst_req_1;
      type_cast_531_inst_ack_1<= rack(0);
      type_cast_531_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_531_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => sub_527,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv160_532,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_541_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_541_inst_req_0;
      type_cast_541_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_541_inst_req_1;
      type_cast_541_inst_ack_1<= rack(0);
      type_cast_541_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_541_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr163_538,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv166_542,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_551_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_551_inst_req_0;
      type_cast_551_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_551_inst_req_1;
      type_cast_551_inst_ack_1<= rack(0);
      type_cast_551_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_551_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr169_548,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv172_552,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_561_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_561_inst_req_0;
      type_cast_561_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_561_inst_req_1;
      type_cast_561_inst_ack_1<= rack(0);
      type_cast_561_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_561_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr175_558,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv178_562,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_571_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_571_inst_req_0;
      type_cast_571_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_571_inst_req_1;
      type_cast_571_inst_ack_1<= rack(0);
      type_cast_571_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_571_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr181_568,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv184_572,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_581_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_581_inst_req_0;
      type_cast_581_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_581_inst_req_1;
      type_cast_581_inst_ack_1<= rack(0);
      type_cast_581_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_581_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr187_578,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv190_582,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_591_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_591_inst_req_0;
      type_cast_591_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_591_inst_req_1;
      type_cast_591_inst_ack_1<= rack(0);
      type_cast_591_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_591_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr193_588,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv196_592,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_601_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_601_inst_req_0;
      type_cast_601_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_601_inst_req_1;
      type_cast_601_inst_ack_1<= rack(0);
      type_cast_601_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_601_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr199_598,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv202_602,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_630_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_630_inst_req_0;
      type_cast_630_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_630_inst_req_1;
      type_cast_630_inst_ack_1<= rack(0);
      type_cast_630_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_630_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add59_186,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv222_631,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_634_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_634_inst_req_0;
      type_cast_634_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_634_inst_req_1;
      type_cast_634_inst_ack_1<= rack(0);
      type_cast_634_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_634_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add68_211,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv224_635,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_638_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_638_inst_req_0;
      type_cast_638_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_638_inst_req_1;
      type_cast_638_inst_ack_1<= rack(0);
      type_cast_638_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_638_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => add77_236,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv227_639,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock type_cast_653_inst
    process(mul228_649) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := mul228_649(31 downto 0);
      type_cast_653_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_658_inst
    process(ASHR_i32_i32_657_wire) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := ASHR_i32_i32_657_wire(31 downto 0);
      shr232309_659 <= tmp_var; -- 
    end process;
    -- interlock type_cast_662_inst
    process(shr232309_659) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := shr232309_659(31 downto 0);
      type_cast_662_wire <= tmp_var; -- 
    end process;
    type_cast_677_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_677_inst_req_0;
      type_cast_677_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_677_inst_req_1;
      type_cast_677_inst_ack_1<= rack(0);
      type_cast_677_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_677_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 32,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr232309_659,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => tmp1_678,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_67_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_67_inst_req_0;
      type_cast_67_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_67_inst_req_1;
      type_cast_67_inst_ack_1<= rack(0);
      type_cast_67_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_67_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call16_64,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv19_68,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_687_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_687_inst_req_0;
      type_cast_687_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_687_inst_req_1;
      type_cast_687_inst_ack_1<= rack(0);
      type_cast_687_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_687_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 64,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => indvarx_xnext_803,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => type_cast_687_wire,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_702_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_702_inst_req_0;
      type_cast_702_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_702_inst_req_1;
      type_cast_702_inst_ack_1<= rack(0);
      type_cast_702_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_702_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => tmp241_699,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv245_703,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_712_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_712_inst_req_0;
      type_cast_712_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_712_inst_req_1;
      type_cast_712_inst_ack_1<= rack(0);
      type_cast_712_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_712_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr248_709,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv251_713,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_722_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_722_inst_req_0;
      type_cast_722_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_722_inst_req_1;
      type_cast_722_inst_ack_1<= rack(0);
      type_cast_722_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_722_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr254_719,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv257_723,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_732_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_732_inst_req_0;
      type_cast_732_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_732_inst_req_1;
      type_cast_732_inst_ack_1<= rack(0);
      type_cast_732_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_732_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr260_729,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv263_733,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_742_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_742_inst_req_0;
      type_cast_742_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_742_inst_req_1;
      type_cast_742_inst_ack_1<= rack(0);
      type_cast_742_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_742_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr266_739,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv269_743,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_752_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_752_inst_req_0;
      type_cast_752_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_752_inst_req_1;
      type_cast_752_inst_ack_1<= rack(0);
      type_cast_752_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_752_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr272_749,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv275_753,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_762_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_762_inst_req_0;
      type_cast_762_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_762_inst_req_1;
      type_cast_762_inst_ack_1<= rack(0);
      type_cast_762_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_762_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr278_759,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv281_763,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_772_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_772_inst_req_0;
      type_cast_772_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_772_inst_req_1;
      type_cast_772_inst_ack_1<= rack(0);
      type_cast_772_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_772_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 64,
        out_data_width => 8,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => shr284_769,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv287_773,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_80_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_80_inst_req_0;
      type_cast_80_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_80_inst_req_1;
      type_cast_80_inst_ack_1<= rack(0);
      type_cast_80_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_80_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call21_77,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv22_81,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_92_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_92_inst_req_0;
      type_cast_92_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_92_inst_req_1;
      type_cast_92_inst_ack_1<= rack(0);
      type_cast_92_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_92_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 8,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => call25_89,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv28_93,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- equivalence array_obj_ref_322_index_1_rename
    process(R_indvar317_321_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := R_indvar317_321_resized;
      ov(13 downto 0) := iv;
      R_indvar317_321_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_322_index_1_resize
    process(indvar317_310) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := indvar317_310;
      ov := iv(13 downto 0);
      R_indvar317_321_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_322_root_address_inst
    process(array_obj_ref_322_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_322_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_322_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_693_index_1_rename
    process(R_indvar_692_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := R_indvar_692_resized;
      ov(13 downto 0) := iv;
      R_indvar_692_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_693_index_1_resize
    process(indvar_681) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := indvar_681;
      ov := iv(13 downto 0);
      R_indvar_692_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_693_root_address_inst
    process(array_obj_ref_693_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_693_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_693_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_459_addr_0
    process(ptr_deref_459_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_459_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_459_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_459_base_resize
    process(arrayidx_324) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := arrayidx_324;
      ov := iv(13 downto 0);
      ptr_deref_459_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_459_gather_scatter
    process(add136_457) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := add136_457;
      ov(63 downto 0) := iv;
      ptr_deref_459_data_0 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_459_root_address_inst
    process(ptr_deref_459_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_459_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_459_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_698_addr_0
    process(ptr_deref_698_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_698_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_698_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_698_base_resize
    process(arrayidx240_695) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := arrayidx240_695;
      ov := iv(13 downto 0);
      ptr_deref_698_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_698_gather_scatter
    process(ptr_deref_698_data_0) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_698_data_0;
      ov(63 downto 0) := iv;
      tmp241_699 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_698_root_address_inst
    process(ptr_deref_698_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_698_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_698_root_address <= ov(13 downto 0);
      --
    end process;
    if_stmt_282_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= cmp314_281;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_282_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_282_branch_req_0,
          ack0 => if_stmt_282_branch_ack_0,
          ack1 => if_stmt_282_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    if_stmt_473_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= exitcond_472;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_473_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_473_branch_req_0,
          ack0 => if_stmt_473_branch_ack_0,
          ack1 => if_stmt_473_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    if_stmt_668_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= cmp233310_667;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_668_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_668_branch_req_0,
          ack0 => if_stmt_668_branch_ack_0,
          ack1 => if_stmt_668_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    if_stmt_809_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= exitcond2_808;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_809_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_809_branch_req_0,
          ack0 => if_stmt_809_branch_ack_0,
          ack1 => if_stmt_809_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator ADD_u64_u64_466_inst
    process(indvar317_310) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntAdd_proc(indvar317_310, type_cast_465_wire_constant, tmp_var);
      indvarx_xnext318_467 <= tmp_var; --
    end process;
    -- binary operator ADD_u64_u64_802_inst
    process(indvar_681) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntAdd_proc(indvar_681, type_cast_801_wire_constant, tmp_var);
      indvarx_xnext_803 <= tmp_var; --
    end process;
    -- binary operator ASHR_i32_i32_657_inst
    process(type_cast_653_wire) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntASHR_proc(type_cast_653_wire, type_cast_656_wire_constant, tmp_var);
      ASHR_i32_i32_657_wire <= tmp_var; --
    end process;
    -- binary operator ASHR_i64_i64_272_inst
    process(type_cast_268_wire) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntASHR_proc(type_cast_268_wire, type_cast_271_wire_constant, tmp_var);
      ASHR_i64_i64_272_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u64_u1_471_inst
    process(indvarx_xnext318_467, umax3_307) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(indvarx_xnext318_467, umax3_307, tmp_var);
      exitcond_472 <= tmp_var; --
    end process;
    -- binary operator EQ_u64_u1_807_inst
    process(indvarx_xnext_803, tmp1_678) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(indvarx_xnext_803, tmp1_678, tmp_var);
      exitcond2_808 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_293_inst
    process(conv87_274) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(conv87_274, type_cast_292_wire_constant, tmp_var);
      shr_294 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_537_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_536_wire_constant, tmp_var);
      shr163_538 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_547_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_546_wire_constant, tmp_var);
      shr169_548 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_557_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_556_wire_constant, tmp_var);
      shr175_558 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_567_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_566_wire_constant, tmp_var);
      shr181_568 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_577_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_576_wire_constant, tmp_var);
      shr187_578 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_587_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_586_wire_constant, tmp_var);
      shr193_588 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_597_inst
    process(sub_527) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_527, type_cast_596_wire_constant, tmp_var);
      shr199_598 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_708_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_707_wire_constant, tmp_var);
      shr248_709 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_718_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_717_wire_constant, tmp_var);
      shr254_719 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_728_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_727_wire_constant, tmp_var);
      shr260_729 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_738_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_737_wire_constant, tmp_var);
      shr266_739 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_748_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_747_wire_constant, tmp_var);
      shr272_749 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_758_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_757_wire_constant, tmp_var);
      shr278_759 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_768_inst
    process(tmp241_699) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_699, type_cast_767_wire_constant, tmp_var);
      shr284_769 <= tmp_var; --
    end process;
    -- binary operator MUL_u32_u32_643_inst
    process(conv224_635, conv222_631) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntMul_proc(conv224_635, conv222_631, tmp_var);
      mul225_644 <= tmp_var; --
    end process;
    -- binary operator MUL_u32_u32_648_inst
    process(mul225_644, conv227_639) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntMul_proc(mul225_644, conv227_639, tmp_var);
      mul228_649 <= tmp_var; --
    end process;
    -- binary operator MUL_u64_u64_258_inst
    process(mul_254, conv83_244) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntMul_proc(mul_254, conv83_244, tmp_var);
      mul86_259 <= tmp_var; --
    end process;
    -- binary operator MUL_u64_u64_263_inst
    process(mul86_259, conv85_248) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntMul_proc(mul86_259, conv85_248, tmp_var);
      sext_264 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_110_inst
    process(shl29_99, conv31_106) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl29_99, conv31_106, tmp_var);
      add32_111 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_135_inst
    process(shl38_124, conv40_131) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl38_124, conv40_131, tmp_var);
      add41_136 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_160_inst
    process(shl47_149, conv49_156) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl47_149, conv49_156, tmp_var);
      add50_161 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_185_inst
    process(shl56_174, conv58_181) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl56_174, conv58_181, tmp_var);
      add59_186 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_210_inst
    process(shl65_199, conv67_206) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl65_199, conv67_206, tmp_var);
      add68_211 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_235_inst
    process(shl74_224, conv76_231) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl74_224, conv76_231, tmp_var);
      add77_236 <= tmp_var; --
    end process;
    -- binary operator OR_u16_u16_85_inst
    process(shl20_74, conv22_81) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl20_74, conv22_81, tmp_var);
      add23_86 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_348_inst
    process(shl96_337, conv99_344) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl96_337, conv99_344, tmp_var);
      add100_349 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_366_inst
    process(shl102_355, conv105_362) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl102_355, conv105_362, tmp_var);
      add106_367 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_384_inst
    process(shl108_373, conv111_380) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl108_373, conv111_380, tmp_var);
      add112_385 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_402_inst
    process(shl114_391, conv117_398) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl114_391, conv117_398, tmp_var);
      add118_403 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_420_inst
    process(shl120_409, conv123_416) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl120_409, conv123_416, tmp_var);
      add124_421 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_438_inst
    process(shl126_427, conv129_434) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl126_427, conv129_434, tmp_var);
      add130_439 <= tmp_var; --
    end process;
    -- binary operator OR_u64_u64_456_inst
    process(shl132_445, conv135_452) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntOr_proc(shl132_445, conv135_452, tmp_var);
      add136_457 <= tmp_var; --
    end process;
    -- binary operator SGT_i32_u1_666_inst
    process(type_cast_662_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntSgt_proc(type_cast_662_wire, type_cast_665_wire_constant, tmp_var);
      cmp233310_667 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_123_inst
    process(conv37_118) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv37_118, type_cast_122_wire_constant, tmp_var);
      shl38_124 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_148_inst
    process(conv46_143) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv46_143, type_cast_147_wire_constant, tmp_var);
      shl47_149 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_173_inst
    process(conv55_168) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv55_168, type_cast_172_wire_constant, tmp_var);
      shl56_174 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_198_inst
    process(conv64_193) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv64_193, type_cast_197_wire_constant, tmp_var);
      shl65_199 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_223_inst
    process(conv73_218) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv73_218, type_cast_222_wire_constant, tmp_var);
      shl74_224 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_73_inst
    process(conv19_68) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv19_68, type_cast_72_wire_constant, tmp_var);
      shl20_74 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_98_inst
    process(conv28_93) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv28_93, type_cast_97_wire_constant, tmp_var);
      shl29_99 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_253_inst
    process(conv81_240) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv81_240, type_cast_252_wire_constant, tmp_var);
      mul_254 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_336_inst
    process(conv94_331) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(conv94_331, type_cast_335_wire_constant, tmp_var);
      shl96_337 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_354_inst
    process(add100_349) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add100_349, type_cast_353_wire_constant, tmp_var);
      shl102_355 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_372_inst
    process(add106_367) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add106_367, type_cast_371_wire_constant, tmp_var);
      shl108_373 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_390_inst
    process(add112_385) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add112_385, type_cast_389_wire_constant, tmp_var);
      shl114_391 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_408_inst
    process(add118_403) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add118_403, type_cast_407_wire_constant, tmp_var);
      shl120_409 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_426_inst
    process(add124_421) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add124_421, type_cast_425_wire_constant, tmp_var);
      shl126_427 <= tmp_var; --
    end process;
    -- binary operator SHL_u64_u64_444_inst
    process(add130_439) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSHL_proc(add130_439, type_cast_443_wire_constant, tmp_var);
      shl132_445 <= tmp_var; --
    end process;
    -- binary operator SUB_u64_u64_526_inst
    process(conv154_522, conv142_489) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSub_proc(conv154_522, conv142_489, tmp_var);
      sub_527 <= tmp_var; --
    end process;
    -- binary operator UGT_u64_u1_279_inst
    process(conv87_274) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(conv87_274, type_cast_278_wire_constant, tmp_var);
      cmp314_281 <= tmp_var; --
    end process;
    -- binary operator UGT_u64_u1_299_inst
    process(shr_294) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUgt_proc(shr_294, type_cast_298_wire_constant, tmp_var);
      tmp_300 <= tmp_var; --
    end process;
    -- shared split operator group (58) : array_obj_ref_322_index_offset 
    ApIntAdd_group_58: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(13 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= R_indvar317_321_scaled;
      array_obj_ref_322_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_322_index_offset_req_0;
      array_obj_ref_322_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_322_index_offset_req_1;
      array_obj_ref_322_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_58_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_58_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_58",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 14,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 14,
          constant_operand => "00000000000000",
          constant_width => 14,
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
    end Block; -- split operator group 58
    -- shared split operator group (59) : array_obj_ref_693_index_offset 
    ApIntAdd_group_59: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(13 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= R_indvar_692_scaled;
      array_obj_ref_693_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_693_index_offset_req_0;
      array_obj_ref_693_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_693_index_offset_req_1;
      array_obj_ref_693_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_59_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_59_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_59",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 14,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 14,
          constant_operand => "00000000000000",
          constant_width => 14,
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
    end Block; -- split operator group 59
    -- unary operator type_cast_487_inst
    process(call141_484) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntToApIntSigned", call141_484, tmp_var);
      type_cast_487_wire <= tmp_var; -- 
    end process;
    -- unary operator type_cast_520_inst
    process(call153_517) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntToApIntSigned", call153_517, tmp_var);
      type_cast_520_wire <= tmp_var; -- 
    end process;
    -- shared load operator group (0) : ptr_deref_698_load_0 
    LoadGroup0: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated: BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      reqL_unguarded(0) <= ptr_deref_698_load_0_req_0;
      ptr_deref_698_load_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_698_load_0_req_1;
      ptr_deref_698_load_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      LoadGroup0_gI: SplitGuardInterface generic map(name => "LoadGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      data_in <= ptr_deref_698_word_address_0;
      ptr_deref_698_data_0 <= data_out(63 downto 0);
      LoadReq: LoadReqSharedWithInputBuffers -- 
        generic map ( name => "LoadGroup0", addr_width => 14,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          dataL => data_in, 
          mreq => memory_space_0_lr_req(0),
          mack => memory_space_0_lr_ack(0),
          maddr => memory_space_0_lr_addr(13 downto 0),
          mtag => memory_space_0_lr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      LoadComplete: LoadCompleteShared -- 
        generic map ( name => "LoadGroup0 load-complete ",
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        detailed_buffering_per_output => outBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          mreq => memory_space_0_lc_req(0),
          mack => memory_space_0_lc_ack(0),
          mdata => memory_space_0_lc_data(63 downto 0),
          mtag => memory_space_0_lc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- load group 0
    -- shared store operator group (0) : ptr_deref_459_store_0 
    StoreGroup0: Block -- 
      signal addr_in: std_logic_vector(13 downto 0);
      signal data_in: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      reqL_unguarded(0) <= ptr_deref_459_store_0_req_0;
      ptr_deref_459_store_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_459_store_0_req_1;
      ptr_deref_459_store_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      StoreGroup0_gI: SplitGuardInterface generic map(name => "StoreGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      addr_in <= ptr_deref_459_word_address_0;
      data_in <= ptr_deref_459_data_0;
      StoreReq: StoreReqSharedWithInputBuffers -- 
        generic map ( name => "StoreGroup0 Req ", addr_width => 14,
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map (--
          reqL => reqL , 
          ackL => ackL , 
          addr => addr_in, 
          data => data_in, 
          mreq => memory_space_1_sr_req(0),
          mack => memory_space_1_sr_ack(0),
          maddr => memory_space_1_sr_addr(13 downto 0),
          mdata => memory_space_1_sr_data(63 downto 0),
          mtag => memory_space_1_sr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        );--
      StoreComplete: StoreCompleteShared -- 
        generic map ( -- 
          name => "StoreGroup0 Complete ",
          num_reqs => 1,
          detailed_buffering_per_output => outBUFs,
          tag_length => 1 -- 
        )
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          mreq => memory_space_1_sc_req(0),
          mack => memory_space_1_sc_ack(0),
          mtag => memory_space_1_sc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- store group 0
    -- shared inport operator group (0) : RPIPE_Block0_complete_513_inst 
    InportGroup_0: Block -- 
      signal data_out: std_logic_vector(15 downto 0);
      signal reqL, ackL, reqR, ackR : BooleanArray( 0 downto 0);
      signal reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      reqL_unguarded(0) <= RPIPE_Block0_complete_513_inst_req_0;
      RPIPE_Block0_complete_513_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= RPIPE_Block0_complete_513_inst_req_1;
      RPIPE_Block0_complete_513_inst_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      call151_514 <= data_out(15 downto 0);
      Block0_complete_read_0_gI: SplitGuardInterface generic map(name => "Block0_complete_read_0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => true) -- 
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
      Block0_complete_read_0: InputPortRevised -- 
        generic map ( name => "Block0_complete_read_0", data_width => 16,  num_reqs => 1,  output_buffering => outBUFs,   nonblocking_read_flag => False,  no_arbitration => false)
        port map (-- 
          sample_req => reqL , 
          sample_ack => ackL, 
          update_req => reqR, 
          update_ack => ackR, 
          data => data_out, 
          oreq => Block0_complete_pipe_read_req(0),
          oack => Block0_complete_pipe_read_ack(0),
          odata => Block0_complete_pipe_read_data(15 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- inport group 0
    -- shared inport operator group (1) : RPIPE_zeropad_input_pipe_51_inst RPIPE_zeropad_input_pipe_54_inst RPIPE_zeropad_input_pipe_57_inst RPIPE_zeropad_input_pipe_60_inst RPIPE_zeropad_input_pipe_63_inst RPIPE_zeropad_input_pipe_76_inst RPIPE_zeropad_input_pipe_88_inst RPIPE_zeropad_input_pipe_101_inst RPIPE_zeropad_input_pipe_113_inst RPIPE_zeropad_input_pipe_126_inst RPIPE_zeropad_input_pipe_138_inst RPIPE_zeropad_input_pipe_151_inst RPIPE_zeropad_input_pipe_163_inst RPIPE_zeropad_input_pipe_176_inst RPIPE_zeropad_input_pipe_188_inst RPIPE_zeropad_input_pipe_201_inst RPIPE_zeropad_input_pipe_213_inst RPIPE_zeropad_input_pipe_226_inst RPIPE_zeropad_input_pipe_326_inst RPIPE_zeropad_input_pipe_339_inst RPIPE_zeropad_input_pipe_357_inst RPIPE_zeropad_input_pipe_375_inst RPIPE_zeropad_input_pipe_393_inst RPIPE_zeropad_input_pipe_411_inst RPIPE_zeropad_input_pipe_429_inst RPIPE_zeropad_input_pipe_447_inst 
    InportGroup_1: Block -- 
      signal data_out: std_logic_vector(207 downto 0);
      signal reqL, ackL, reqR, ackR : BooleanArray( 25 downto 0);
      signal reqL_unguarded, ackL_unguarded : BooleanArray( 25 downto 0);
      signal reqR_unguarded, ackR_unguarded : BooleanArray( 25 downto 0);
      signal guard_vector : std_logic_vector( 25 downto 0);
      constant outBUFs : IntegerArray(25 downto 0) := (25 => 1, 24 => 1, 23 => 1, 22 => 1, 21 => 1, 20 => 1, 19 => 1, 18 => 1, 17 => 1, 16 => 1, 15 => 1, 14 => 1, 13 => 1, 12 => 1, 11 => 1, 10 => 1, 9 => 1, 8 => 1, 7 => 1, 6 => 1, 5 => 1, 4 => 1, 3 => 1, 2 => 1, 1 => 1, 0 => 1);
      constant guardFlags : BooleanArray(25 downto 0) := (0 => false, 1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false, 7 => false, 8 => false, 9 => false, 10 => false, 11 => false, 12 => false, 13 => false, 14 => false, 15 => false, 16 => false, 17 => false, 18 => false, 19 => false, 20 => false, 21 => false, 22 => false, 23 => false, 24 => false, 25 => false);
      constant guardBuffering: IntegerArray(25 downto 0)  := (0 => 2, 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2, 7 => 2, 8 => 2, 9 => 2, 10 => 2, 11 => 2, 12 => 2, 13 => 2, 14 => 2, 15 => 2, 16 => 2, 17 => 2, 18 => 2, 19 => 2, 20 => 2, 21 => 2, 22 => 2, 23 => 2, 24 => 2, 25 => 2);
      -- 
    begin -- 
      reqL_unguarded(25) <= RPIPE_zeropad_input_pipe_51_inst_req_0;
      reqL_unguarded(24) <= RPIPE_zeropad_input_pipe_54_inst_req_0;
      reqL_unguarded(23) <= RPIPE_zeropad_input_pipe_57_inst_req_0;
      reqL_unguarded(22) <= RPIPE_zeropad_input_pipe_60_inst_req_0;
      reqL_unguarded(21) <= RPIPE_zeropad_input_pipe_63_inst_req_0;
      reqL_unguarded(20) <= RPIPE_zeropad_input_pipe_76_inst_req_0;
      reqL_unguarded(19) <= RPIPE_zeropad_input_pipe_88_inst_req_0;
      reqL_unguarded(18) <= RPIPE_zeropad_input_pipe_101_inst_req_0;
      reqL_unguarded(17) <= RPIPE_zeropad_input_pipe_113_inst_req_0;
      reqL_unguarded(16) <= RPIPE_zeropad_input_pipe_126_inst_req_0;
      reqL_unguarded(15) <= RPIPE_zeropad_input_pipe_138_inst_req_0;
      reqL_unguarded(14) <= RPIPE_zeropad_input_pipe_151_inst_req_0;
      reqL_unguarded(13) <= RPIPE_zeropad_input_pipe_163_inst_req_0;
      reqL_unguarded(12) <= RPIPE_zeropad_input_pipe_176_inst_req_0;
      reqL_unguarded(11) <= RPIPE_zeropad_input_pipe_188_inst_req_0;
      reqL_unguarded(10) <= RPIPE_zeropad_input_pipe_201_inst_req_0;
      reqL_unguarded(9) <= RPIPE_zeropad_input_pipe_213_inst_req_0;
      reqL_unguarded(8) <= RPIPE_zeropad_input_pipe_226_inst_req_0;
      reqL_unguarded(7) <= RPIPE_zeropad_input_pipe_326_inst_req_0;
      reqL_unguarded(6) <= RPIPE_zeropad_input_pipe_339_inst_req_0;
      reqL_unguarded(5) <= RPIPE_zeropad_input_pipe_357_inst_req_0;
      reqL_unguarded(4) <= RPIPE_zeropad_input_pipe_375_inst_req_0;
      reqL_unguarded(3) <= RPIPE_zeropad_input_pipe_393_inst_req_0;
      reqL_unguarded(2) <= RPIPE_zeropad_input_pipe_411_inst_req_0;
      reqL_unguarded(1) <= RPIPE_zeropad_input_pipe_429_inst_req_0;
      reqL_unguarded(0) <= RPIPE_zeropad_input_pipe_447_inst_req_0;
      RPIPE_zeropad_input_pipe_51_inst_ack_0 <= ackL_unguarded(25);
      RPIPE_zeropad_input_pipe_54_inst_ack_0 <= ackL_unguarded(24);
      RPIPE_zeropad_input_pipe_57_inst_ack_0 <= ackL_unguarded(23);
      RPIPE_zeropad_input_pipe_60_inst_ack_0 <= ackL_unguarded(22);
      RPIPE_zeropad_input_pipe_63_inst_ack_0 <= ackL_unguarded(21);
      RPIPE_zeropad_input_pipe_76_inst_ack_0 <= ackL_unguarded(20);
      RPIPE_zeropad_input_pipe_88_inst_ack_0 <= ackL_unguarded(19);
      RPIPE_zeropad_input_pipe_101_inst_ack_0 <= ackL_unguarded(18);
      RPIPE_zeropad_input_pipe_113_inst_ack_0 <= ackL_unguarded(17);
      RPIPE_zeropad_input_pipe_126_inst_ack_0 <= ackL_unguarded(16);
      RPIPE_zeropad_input_pipe_138_inst_ack_0 <= ackL_unguarded(15);
      RPIPE_zeropad_input_pipe_151_inst_ack_0 <= ackL_unguarded(14);
      RPIPE_zeropad_input_pipe_163_inst_ack_0 <= ackL_unguarded(13);
      RPIPE_zeropad_input_pipe_176_inst_ack_0 <= ackL_unguarded(12);
      RPIPE_zeropad_input_pipe_188_inst_ack_0 <= ackL_unguarded(11);
      RPIPE_zeropad_input_pipe_201_inst_ack_0 <= ackL_unguarded(10);
      RPIPE_zeropad_input_pipe_213_inst_ack_0 <= ackL_unguarded(9);
      RPIPE_zeropad_input_pipe_226_inst_ack_0 <= ackL_unguarded(8);
      RPIPE_zeropad_input_pipe_326_inst_ack_0 <= ackL_unguarded(7);
      RPIPE_zeropad_input_pipe_339_inst_ack_0 <= ackL_unguarded(6);
      RPIPE_zeropad_input_pipe_357_inst_ack_0 <= ackL_unguarded(5);
      RPIPE_zeropad_input_pipe_375_inst_ack_0 <= ackL_unguarded(4);
      RPIPE_zeropad_input_pipe_393_inst_ack_0 <= ackL_unguarded(3);
      RPIPE_zeropad_input_pipe_411_inst_ack_0 <= ackL_unguarded(2);
      RPIPE_zeropad_input_pipe_429_inst_ack_0 <= ackL_unguarded(1);
      RPIPE_zeropad_input_pipe_447_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(25) <= RPIPE_zeropad_input_pipe_51_inst_req_1;
      reqR_unguarded(24) <= RPIPE_zeropad_input_pipe_54_inst_req_1;
      reqR_unguarded(23) <= RPIPE_zeropad_input_pipe_57_inst_req_1;
      reqR_unguarded(22) <= RPIPE_zeropad_input_pipe_60_inst_req_1;
      reqR_unguarded(21) <= RPIPE_zeropad_input_pipe_63_inst_req_1;
      reqR_unguarded(20) <= RPIPE_zeropad_input_pipe_76_inst_req_1;
      reqR_unguarded(19) <= RPIPE_zeropad_input_pipe_88_inst_req_1;
      reqR_unguarded(18) <= RPIPE_zeropad_input_pipe_101_inst_req_1;
      reqR_unguarded(17) <= RPIPE_zeropad_input_pipe_113_inst_req_1;
      reqR_unguarded(16) <= RPIPE_zeropad_input_pipe_126_inst_req_1;
      reqR_unguarded(15) <= RPIPE_zeropad_input_pipe_138_inst_req_1;
      reqR_unguarded(14) <= RPIPE_zeropad_input_pipe_151_inst_req_1;
      reqR_unguarded(13) <= RPIPE_zeropad_input_pipe_163_inst_req_1;
      reqR_unguarded(12) <= RPIPE_zeropad_input_pipe_176_inst_req_1;
      reqR_unguarded(11) <= RPIPE_zeropad_input_pipe_188_inst_req_1;
      reqR_unguarded(10) <= RPIPE_zeropad_input_pipe_201_inst_req_1;
      reqR_unguarded(9) <= RPIPE_zeropad_input_pipe_213_inst_req_1;
      reqR_unguarded(8) <= RPIPE_zeropad_input_pipe_226_inst_req_1;
      reqR_unguarded(7) <= RPIPE_zeropad_input_pipe_326_inst_req_1;
      reqR_unguarded(6) <= RPIPE_zeropad_input_pipe_339_inst_req_1;
      reqR_unguarded(5) <= RPIPE_zeropad_input_pipe_357_inst_req_1;
      reqR_unguarded(4) <= RPIPE_zeropad_input_pipe_375_inst_req_1;
      reqR_unguarded(3) <= RPIPE_zeropad_input_pipe_393_inst_req_1;
      reqR_unguarded(2) <= RPIPE_zeropad_input_pipe_411_inst_req_1;
      reqR_unguarded(1) <= RPIPE_zeropad_input_pipe_429_inst_req_1;
      reqR_unguarded(0) <= RPIPE_zeropad_input_pipe_447_inst_req_1;
      RPIPE_zeropad_input_pipe_51_inst_ack_1 <= ackR_unguarded(25);
      RPIPE_zeropad_input_pipe_54_inst_ack_1 <= ackR_unguarded(24);
      RPIPE_zeropad_input_pipe_57_inst_ack_1 <= ackR_unguarded(23);
      RPIPE_zeropad_input_pipe_60_inst_ack_1 <= ackR_unguarded(22);
      RPIPE_zeropad_input_pipe_63_inst_ack_1 <= ackR_unguarded(21);
      RPIPE_zeropad_input_pipe_76_inst_ack_1 <= ackR_unguarded(20);
      RPIPE_zeropad_input_pipe_88_inst_ack_1 <= ackR_unguarded(19);
      RPIPE_zeropad_input_pipe_101_inst_ack_1 <= ackR_unguarded(18);
      RPIPE_zeropad_input_pipe_113_inst_ack_1 <= ackR_unguarded(17);
      RPIPE_zeropad_input_pipe_126_inst_ack_1 <= ackR_unguarded(16);
      RPIPE_zeropad_input_pipe_138_inst_ack_1 <= ackR_unguarded(15);
      RPIPE_zeropad_input_pipe_151_inst_ack_1 <= ackR_unguarded(14);
      RPIPE_zeropad_input_pipe_163_inst_ack_1 <= ackR_unguarded(13);
      RPIPE_zeropad_input_pipe_176_inst_ack_1 <= ackR_unguarded(12);
      RPIPE_zeropad_input_pipe_188_inst_ack_1 <= ackR_unguarded(11);
      RPIPE_zeropad_input_pipe_201_inst_ack_1 <= ackR_unguarded(10);
      RPIPE_zeropad_input_pipe_213_inst_ack_1 <= ackR_unguarded(9);
      RPIPE_zeropad_input_pipe_226_inst_ack_1 <= ackR_unguarded(8);
      RPIPE_zeropad_input_pipe_326_inst_ack_1 <= ackR_unguarded(7);
      RPIPE_zeropad_input_pipe_339_inst_ack_1 <= ackR_unguarded(6);
      RPIPE_zeropad_input_pipe_357_inst_ack_1 <= ackR_unguarded(5);
      RPIPE_zeropad_input_pipe_375_inst_ack_1 <= ackR_unguarded(4);
      RPIPE_zeropad_input_pipe_393_inst_ack_1 <= ackR_unguarded(3);
      RPIPE_zeropad_input_pipe_411_inst_ack_1 <= ackR_unguarded(2);
      RPIPE_zeropad_input_pipe_429_inst_ack_1 <= ackR_unguarded(1);
      RPIPE_zeropad_input_pipe_447_inst_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      guard_vector(2)  <=  '1';
      guard_vector(3)  <=  '1';
      guard_vector(4)  <=  '1';
      guard_vector(5)  <=  '1';
      guard_vector(6)  <=  '1';
      guard_vector(7)  <=  '1';
      guard_vector(8)  <=  '1';
      guard_vector(9)  <=  '1';
      guard_vector(10)  <=  '1';
      guard_vector(11)  <=  '1';
      guard_vector(12)  <=  '1';
      guard_vector(13)  <=  '1';
      guard_vector(14)  <=  '1';
      guard_vector(15)  <=  '1';
      guard_vector(16)  <=  '1';
      guard_vector(17)  <=  '1';
      guard_vector(18)  <=  '1';
      guard_vector(19)  <=  '1';
      guard_vector(20)  <=  '1';
      guard_vector(21)  <=  '1';
      guard_vector(22)  <=  '1';
      guard_vector(23)  <=  '1';
      guard_vector(24)  <=  '1';
      guard_vector(25)  <=  '1';
      call_52 <= data_out(207 downto 200);
      call2_55 <= data_out(199 downto 192);
      call6_58 <= data_out(191 downto 184);
      call11_61 <= data_out(183 downto 176);
      call16_64 <= data_out(175 downto 168);
      call21_77 <= data_out(167 downto 160);
      call25_89 <= data_out(159 downto 152);
      call30_102 <= data_out(151 downto 144);
      call34_114 <= data_out(143 downto 136);
      call39_127 <= data_out(135 downto 128);
      call43_139 <= data_out(127 downto 120);
      call48_152 <= data_out(119 downto 112);
      call52_164 <= data_out(111 downto 104);
      call57_177 <= data_out(103 downto 96);
      call61_189 <= data_out(95 downto 88);
      call66_202 <= data_out(87 downto 80);
      call70_214 <= data_out(79 downto 72);
      call75_227 <= data_out(71 downto 64);
      call93_327 <= data_out(63 downto 56);
      call97_340 <= data_out(55 downto 48);
      call103_358 <= data_out(47 downto 40);
      call109_376 <= data_out(39 downto 32);
      call115_394 <= data_out(31 downto 24);
      call121_412 <= data_out(23 downto 16);
      call127_430 <= data_out(15 downto 8);
      call133_448 <= data_out(7 downto 0);
      zeropad_input_pipe_read_1_gI: SplitGuardInterface generic map(name => "zeropad_input_pipe_read_1_gI", nreqs => 26, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => true) -- 
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
      zeropad_input_pipe_read_1: InputPortRevised -- 
        generic map ( name => "zeropad_input_pipe_read_1", data_width => 8,  num_reqs => 26,  output_buffering => outBUFs,   nonblocking_read_flag => False,  no_arbitration => false)
        port map (-- 
          sample_req => reqL , 
          sample_ack => ackL, 
          update_req => reqR, 
          update_ack => ackR, 
          data => data_out, 
          oreq => zeropad_input_pipe_pipe_read_req(0),
          oack => zeropad_input_pipe_pipe_read_ack(0),
          odata => zeropad_input_pipe_pipe_read_data(7 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- inport group 1
    -- shared outport operator group (0) : WPIPE_Block0_starting_509_inst WPIPE_Block0_starting_506_inst WPIPE_Block0_starting_503_inst WPIPE_Block0_starting_500_inst WPIPE_Block0_starting_497_inst WPIPE_Block0_starting_494_inst WPIPE_Block0_starting_491_inst 
    OutportGroup_0: Block -- 
      signal data_in: std_logic_vector(111 downto 0);
      signal sample_req, sample_ack : BooleanArray( 6 downto 0);
      signal update_req, update_ack : BooleanArray( 6 downto 0);
      signal sample_req_unguarded, sample_ack_unguarded : BooleanArray( 6 downto 0);
      signal update_req_unguarded, update_ack_unguarded : BooleanArray( 6 downto 0);
      signal guard_vector : std_logic_vector( 6 downto 0);
      constant inBUFs : IntegerArray(6 downto 0) := (6 => 0, 5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0, 0 => 0);
      constant guardFlags : BooleanArray(6 downto 0) := (0 => false, 1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false);
      constant guardBuffering: IntegerArray(6 downto 0)  := (0 => 2, 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2);
      -- 
    begin -- 
      sample_req_unguarded(6) <= WPIPE_Block0_starting_509_inst_req_0;
      sample_req_unguarded(5) <= WPIPE_Block0_starting_506_inst_req_0;
      sample_req_unguarded(4) <= WPIPE_Block0_starting_503_inst_req_0;
      sample_req_unguarded(3) <= WPIPE_Block0_starting_500_inst_req_0;
      sample_req_unguarded(2) <= WPIPE_Block0_starting_497_inst_req_0;
      sample_req_unguarded(1) <= WPIPE_Block0_starting_494_inst_req_0;
      sample_req_unguarded(0) <= WPIPE_Block0_starting_491_inst_req_0;
      WPIPE_Block0_starting_509_inst_ack_0 <= sample_ack_unguarded(6);
      WPIPE_Block0_starting_506_inst_ack_0 <= sample_ack_unguarded(5);
      WPIPE_Block0_starting_503_inst_ack_0 <= sample_ack_unguarded(4);
      WPIPE_Block0_starting_500_inst_ack_0 <= sample_ack_unguarded(3);
      WPIPE_Block0_starting_497_inst_ack_0 <= sample_ack_unguarded(2);
      WPIPE_Block0_starting_494_inst_ack_0 <= sample_ack_unguarded(1);
      WPIPE_Block0_starting_491_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(6) <= WPIPE_Block0_starting_509_inst_req_1;
      update_req_unguarded(5) <= WPIPE_Block0_starting_506_inst_req_1;
      update_req_unguarded(4) <= WPIPE_Block0_starting_503_inst_req_1;
      update_req_unguarded(3) <= WPIPE_Block0_starting_500_inst_req_1;
      update_req_unguarded(2) <= WPIPE_Block0_starting_497_inst_req_1;
      update_req_unguarded(1) <= WPIPE_Block0_starting_494_inst_req_1;
      update_req_unguarded(0) <= WPIPE_Block0_starting_491_inst_req_1;
      WPIPE_Block0_starting_509_inst_ack_1 <= update_ack_unguarded(6);
      WPIPE_Block0_starting_506_inst_ack_1 <= update_ack_unguarded(5);
      WPIPE_Block0_starting_503_inst_ack_1 <= update_ack_unguarded(4);
      WPIPE_Block0_starting_500_inst_ack_1 <= update_ack_unguarded(3);
      WPIPE_Block0_starting_497_inst_ack_1 <= update_ack_unguarded(2);
      WPIPE_Block0_starting_494_inst_ack_1 <= update_ack_unguarded(1);
      WPIPE_Block0_starting_491_inst_ack_1 <= update_ack_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      guard_vector(2)  <=  '1';
      guard_vector(3)  <=  '1';
      guard_vector(4)  <=  '1';
      guard_vector(5)  <=  '1';
      guard_vector(6)  <=  '1';
      data_in <= add50_161 & add77_236 & add68_211 & add59_186 & add41_136 & add32_111 & add23_86;
      Block0_starting_write_0_gI: SplitGuardInterface generic map(name => "Block0_starting_write_0_gI", nreqs => 7, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
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
      Block0_starting_write_0: OutputPortRevised -- 
        generic map ( name => "Block0_starting", data_width => 16, num_reqs => 7, input_buffering => inBUFs, full_rate => false,
        no_arbitration => false)
        port map (--
          sample_req => sample_req , 
          sample_ack => sample_ack , 
          update_req => update_req , 
          update_ack => update_ack , 
          data => data_in, 
          oreq => Block0_starting_pipe_write_req(0),
          oack => Block0_starting_pipe_write_ack(0),
          odata => Block0_starting_pipe_write_data(15 downto 0),
          clk => clk, reset => reset -- 
        );-- 
      -- 
    end Block; -- outport group 0
    -- shared outport operator group (1) : WPIPE_zeropad_output_pipe_792_inst WPIPE_zeropad_output_pipe_783_inst WPIPE_zeropad_output_pipe_777_inst WPIPE_zeropad_output_pipe_780_inst WPIPE_zeropad_output_pipe_786_inst WPIPE_zeropad_output_pipe_789_inst WPIPE_zeropad_output_pipe_795_inst WPIPE_zeropad_output_pipe_774_inst WPIPE_zeropad_output_pipe_624_inst WPIPE_zeropad_output_pipe_621_inst WPIPE_zeropad_output_pipe_618_inst WPIPE_zeropad_output_pipe_615_inst WPIPE_zeropad_output_pipe_612_inst WPIPE_zeropad_output_pipe_609_inst WPIPE_zeropad_output_pipe_606_inst WPIPE_zeropad_output_pipe_603_inst 
    OutportGroup_1: Block -- 
      signal data_in: std_logic_vector(127 downto 0);
      signal sample_req, sample_ack : BooleanArray( 15 downto 0);
      signal update_req, update_ack : BooleanArray( 15 downto 0);
      signal sample_req_unguarded, sample_ack_unguarded : BooleanArray( 15 downto 0);
      signal update_req_unguarded, update_ack_unguarded : BooleanArray( 15 downto 0);
      signal guard_vector : std_logic_vector( 15 downto 0);
      constant inBUFs : IntegerArray(15 downto 0) := (15 => 0, 14 => 0, 13 => 0, 12 => 0, 11 => 0, 10 => 0, 9 => 0, 8 => 0, 7 => 0, 6 => 0, 5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0, 0 => 0);
      constant guardFlags : BooleanArray(15 downto 0) := (0 => false, 1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false, 7 => false, 8 => false, 9 => false, 10 => false, 11 => false, 12 => false, 13 => false, 14 => false, 15 => false);
      constant guardBuffering: IntegerArray(15 downto 0)  := (0 => 2, 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2, 7 => 2, 8 => 2, 9 => 2, 10 => 2, 11 => 2, 12 => 2, 13 => 2, 14 => 2, 15 => 2);
      -- 
    begin -- 
      sample_req_unguarded(15) <= WPIPE_zeropad_output_pipe_792_inst_req_0;
      sample_req_unguarded(14) <= WPIPE_zeropad_output_pipe_783_inst_req_0;
      sample_req_unguarded(13) <= WPIPE_zeropad_output_pipe_777_inst_req_0;
      sample_req_unguarded(12) <= WPIPE_zeropad_output_pipe_780_inst_req_0;
      sample_req_unguarded(11) <= WPIPE_zeropad_output_pipe_786_inst_req_0;
      sample_req_unguarded(10) <= WPIPE_zeropad_output_pipe_789_inst_req_0;
      sample_req_unguarded(9) <= WPIPE_zeropad_output_pipe_795_inst_req_0;
      sample_req_unguarded(8) <= WPIPE_zeropad_output_pipe_774_inst_req_0;
      sample_req_unguarded(7) <= WPIPE_zeropad_output_pipe_624_inst_req_0;
      sample_req_unguarded(6) <= WPIPE_zeropad_output_pipe_621_inst_req_0;
      sample_req_unguarded(5) <= WPIPE_zeropad_output_pipe_618_inst_req_0;
      sample_req_unguarded(4) <= WPIPE_zeropad_output_pipe_615_inst_req_0;
      sample_req_unguarded(3) <= WPIPE_zeropad_output_pipe_612_inst_req_0;
      sample_req_unguarded(2) <= WPIPE_zeropad_output_pipe_609_inst_req_0;
      sample_req_unguarded(1) <= WPIPE_zeropad_output_pipe_606_inst_req_0;
      sample_req_unguarded(0) <= WPIPE_zeropad_output_pipe_603_inst_req_0;
      WPIPE_zeropad_output_pipe_792_inst_ack_0 <= sample_ack_unguarded(15);
      WPIPE_zeropad_output_pipe_783_inst_ack_0 <= sample_ack_unguarded(14);
      WPIPE_zeropad_output_pipe_777_inst_ack_0 <= sample_ack_unguarded(13);
      WPIPE_zeropad_output_pipe_780_inst_ack_0 <= sample_ack_unguarded(12);
      WPIPE_zeropad_output_pipe_786_inst_ack_0 <= sample_ack_unguarded(11);
      WPIPE_zeropad_output_pipe_789_inst_ack_0 <= sample_ack_unguarded(10);
      WPIPE_zeropad_output_pipe_795_inst_ack_0 <= sample_ack_unguarded(9);
      WPIPE_zeropad_output_pipe_774_inst_ack_0 <= sample_ack_unguarded(8);
      WPIPE_zeropad_output_pipe_624_inst_ack_0 <= sample_ack_unguarded(7);
      WPIPE_zeropad_output_pipe_621_inst_ack_0 <= sample_ack_unguarded(6);
      WPIPE_zeropad_output_pipe_618_inst_ack_0 <= sample_ack_unguarded(5);
      WPIPE_zeropad_output_pipe_615_inst_ack_0 <= sample_ack_unguarded(4);
      WPIPE_zeropad_output_pipe_612_inst_ack_0 <= sample_ack_unguarded(3);
      WPIPE_zeropad_output_pipe_609_inst_ack_0 <= sample_ack_unguarded(2);
      WPIPE_zeropad_output_pipe_606_inst_ack_0 <= sample_ack_unguarded(1);
      WPIPE_zeropad_output_pipe_603_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(15) <= WPIPE_zeropad_output_pipe_792_inst_req_1;
      update_req_unguarded(14) <= WPIPE_zeropad_output_pipe_783_inst_req_1;
      update_req_unguarded(13) <= WPIPE_zeropad_output_pipe_777_inst_req_1;
      update_req_unguarded(12) <= WPIPE_zeropad_output_pipe_780_inst_req_1;
      update_req_unguarded(11) <= WPIPE_zeropad_output_pipe_786_inst_req_1;
      update_req_unguarded(10) <= WPIPE_zeropad_output_pipe_789_inst_req_1;
      update_req_unguarded(9) <= WPIPE_zeropad_output_pipe_795_inst_req_1;
      update_req_unguarded(8) <= WPIPE_zeropad_output_pipe_774_inst_req_1;
      update_req_unguarded(7) <= WPIPE_zeropad_output_pipe_624_inst_req_1;
      update_req_unguarded(6) <= WPIPE_zeropad_output_pipe_621_inst_req_1;
      update_req_unguarded(5) <= WPIPE_zeropad_output_pipe_618_inst_req_1;
      update_req_unguarded(4) <= WPIPE_zeropad_output_pipe_615_inst_req_1;
      update_req_unguarded(3) <= WPIPE_zeropad_output_pipe_612_inst_req_1;
      update_req_unguarded(2) <= WPIPE_zeropad_output_pipe_609_inst_req_1;
      update_req_unguarded(1) <= WPIPE_zeropad_output_pipe_606_inst_req_1;
      update_req_unguarded(0) <= WPIPE_zeropad_output_pipe_603_inst_req_1;
      WPIPE_zeropad_output_pipe_792_inst_ack_1 <= update_ack_unguarded(15);
      WPIPE_zeropad_output_pipe_783_inst_ack_1 <= update_ack_unguarded(14);
      WPIPE_zeropad_output_pipe_777_inst_ack_1 <= update_ack_unguarded(13);
      WPIPE_zeropad_output_pipe_780_inst_ack_1 <= update_ack_unguarded(12);
      WPIPE_zeropad_output_pipe_786_inst_ack_1 <= update_ack_unguarded(11);
      WPIPE_zeropad_output_pipe_789_inst_ack_1 <= update_ack_unguarded(10);
      WPIPE_zeropad_output_pipe_795_inst_ack_1 <= update_ack_unguarded(9);
      WPIPE_zeropad_output_pipe_774_inst_ack_1 <= update_ack_unguarded(8);
      WPIPE_zeropad_output_pipe_624_inst_ack_1 <= update_ack_unguarded(7);
      WPIPE_zeropad_output_pipe_621_inst_ack_1 <= update_ack_unguarded(6);
      WPIPE_zeropad_output_pipe_618_inst_ack_1 <= update_ack_unguarded(5);
      WPIPE_zeropad_output_pipe_615_inst_ack_1 <= update_ack_unguarded(4);
      WPIPE_zeropad_output_pipe_612_inst_ack_1 <= update_ack_unguarded(3);
      WPIPE_zeropad_output_pipe_609_inst_ack_1 <= update_ack_unguarded(2);
      WPIPE_zeropad_output_pipe_606_inst_ack_1 <= update_ack_unguarded(1);
      WPIPE_zeropad_output_pipe_603_inst_ack_1 <= update_ack_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      guard_vector(2)  <=  '1';
      guard_vector(3)  <=  '1';
      guard_vector(4)  <=  '1';
      guard_vector(5)  <=  '1';
      guard_vector(6)  <=  '1';
      guard_vector(7)  <=  '1';
      guard_vector(8)  <=  '1';
      guard_vector(9)  <=  '1';
      guard_vector(10)  <=  '1';
      guard_vector(11)  <=  '1';
      guard_vector(12)  <=  '1';
      guard_vector(13)  <=  '1';
      guard_vector(14)  <=  '1';
      guard_vector(15)  <=  '1';
      data_in <= conv251_713 & conv269_743 & conv281_763 & conv275_753 & conv263_733 & conv257_723 & conv245_703 & conv287_773 & conv160_532 & conv166_542 & conv172_552 & conv178_562 & conv184_572 & conv190_582 & conv196_592 & conv202_602;
      zeropad_output_pipe_write_1_gI: SplitGuardInterface generic map(name => "zeropad_output_pipe_write_1_gI", nreqs => 16, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
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
      zeropad_output_pipe_write_1: OutputPortRevised -- 
        generic map ( name => "zeropad_output_pipe", data_width => 8, num_reqs => 16, input_buffering => inBUFs, full_rate => false,
        no_arbitration => false)
        port map (--
          sample_req => sample_req , 
          sample_ack => sample_ack , 
          update_req => update_req , 
          update_ack => update_ack , 
          data => data_in, 
          oreq => zeropad_output_pipe_pipe_write_req(0),
          oack => zeropad_output_pipe_pipe_write_ack(0),
          odata => zeropad_output_pipe_pipe_write_data(7 downto 0),
          clk => clk, reset => reset -- 
        );-- 
      -- 
    end Block; -- outport group 1
    -- shared call operator group (0) : call_stmt_484_call call_stmt_517_call 
    timer_call_group_0: Block -- 
      signal data_out: std_logic_vector(127 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 1 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 1 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 1 downto 0);
      signal guard_vector : std_logic_vector( 1 downto 0);
      constant inBUFs : IntegerArray(1 downto 0) := (1 => 0, 0 => 0);
      constant outBUFs : IntegerArray(1 downto 0) := (1 => 1, 0 => 1);
      constant guardFlags : BooleanArray(1 downto 0) := (0 => false, 1 => false);
      constant guardBuffering: IntegerArray(1 downto 0)  := (0 => 2, 1 => 2);
      -- 
    begin -- 
      reqL_unguarded(1) <= call_stmt_484_call_req_0;
      reqL_unguarded(0) <= call_stmt_517_call_req_0;
      call_stmt_484_call_ack_0 <= ackL_unguarded(1);
      call_stmt_517_call_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(1) <= call_stmt_484_call_req_1;
      reqR_unguarded(0) <= call_stmt_517_call_req_1;
      call_stmt_484_call_ack_1 <= ackR_unguarded(1);
      call_stmt_517_call_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      timer_call_group_0_accessRegulator_0: access_regulator_base generic map (name => "timer_call_group_0_accessRegulator_0", num_slots => 1) -- 
        port map (req => reqL_unregulated(0), -- 
          ack => ackL_unregulated(0),
          regulated_req => reqL(0),
          regulated_ack => ackL(0),
          release_req => reqR(0),
          release_ack => ackR(0),
          clk => clk, reset => reset); -- 
      timer_call_group_0_accessRegulator_1: access_regulator_base generic map (name => "timer_call_group_0_accessRegulator_1", num_slots => 1) -- 
        port map (req => reqL_unregulated(1), -- 
          ack => ackL_unregulated(1),
          regulated_req => reqL(1),
          regulated_ack => ackL(1),
          release_req => reqR(1),
          release_ack => ackR(1),
          clk => clk, reset => reset); -- 
      timer_call_group_0_gI: SplitGuardInterface generic map(name => "timer_call_group_0_gI", nreqs => 2, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      call141_484 <= data_out(127 downto 64);
      call153_517 <= data_out(63 downto 0);
      CallReq: InputMuxBaseNoData -- 
        generic map (name => "InputMuxBaseNoData",
        twidth => 2,
        nreqs => 2,
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          reqR => timer_call_reqs(0),
          ackR => timer_call_acks(0),
          tagR => timer_call_tag(1 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      CallComplete: OutputDemuxBaseWithBuffering -- 
        generic map ( -- 
          iwidth => 64,
          owidth => 128,
          detailed_buffering_per_output => outBUFs, 
          full_rate => false, 
          twidth => 2,
          name => "OutputDemuxBaseWithBuffering",
          nreqs => 2) -- 
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          reqL => timer_return_acks(0), -- cross-over
          ackL => timer_return_reqs(0), -- cross-over
          dataL => timer_return_data(63 downto 0),
          tagL => timer_return_tag(1 downto 0),
          clk => clk,
          reset => reset -- 
        ); -- 
      -- 
    end Block; -- call group 0
    -- 
  end Block; -- data_path
  -- 
end zeropad3D_arch;
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
library work;
use work.ahir_system_global_package.all;
entity zeropad3D_A is -- 
  generic (tag_length : integer); 
  port ( -- 
    memory_space_1_lr_req : out  std_logic_vector(0 downto 0);
    memory_space_1_lr_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_lr_addr : out  std_logic_vector(13 downto 0);
    memory_space_1_lr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_1_lc_req : out  std_logic_vector(0 downto 0);
    memory_space_1_lc_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_lc_data : in   std_logic_vector(63 downto 0);
    memory_space_1_lc_tag :  in  std_logic_vector(0 downto 0);
    memory_space_0_sr_req : out  std_logic_vector(0 downto 0);
    memory_space_0_sr_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_sr_addr : out  std_logic_vector(13 downto 0);
    memory_space_0_sr_data : out  std_logic_vector(63 downto 0);
    memory_space_0_sr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_0_sc_req : out  std_logic_vector(0 downto 0);
    memory_space_0_sc_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_sc_tag :  in  std_logic_vector(0 downto 0);
    Block0_starting_pipe_read_req : out  std_logic_vector(0 downto 0);
    Block0_starting_pipe_read_ack : in   std_logic_vector(0 downto 0);
    Block0_starting_pipe_read_data : in   std_logic_vector(15 downto 0);
    Block0_complete_pipe_write_req : out  std_logic_vector(0 downto 0);
    Block0_complete_pipe_write_ack : in   std_logic_vector(0 downto 0);
    Block0_complete_pipe_write_data : out  std_logic_vector(15 downto 0);
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
end entity zeropad3D_A;
architecture zeropad3D_A_arch of zeropad3D_A is -- 
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
  signal zeropad3D_A_CP_2082_start: Boolean;
  signal zeropad3D_A_CP_2082_symbol: Boolean;
  -- volatile/operator module components. 
  -- links between control-path and data-path
  signal RPIPE_Block0_starting_837_inst_ack_1 : boolean;
  signal phi_stmt_909_ack_0 : boolean;
  signal next_k_loop_1133_908_buf_ack_0 : boolean;
  signal next_k_loop_1133_908_buf_req_0 : boolean;
  signal RPIPE_Block0_starting_825_inst_ack_0 : boolean;
  signal next_k_loop_1133_908_buf_req_1 : boolean;
  signal phi_stmt_905_req_0 : boolean;
  signal RPIPE_Block0_starting_840_inst_req_0 : boolean;
  signal next_j_loop_1144_912_buf_ack_1 : boolean;
  signal RPIPE_Block0_starting_825_inst_req_0 : boolean;
  signal next_k_loop_1133_908_buf_ack_1 : boolean;
  signal RPIPE_Block0_starting_828_inst_req_1 : boolean;
  signal phi_stmt_905_req_1 : boolean;
  signal phi_stmt_909_req_0 : boolean;
  signal phi_stmt_905_ack_0 : boolean;
  signal next_j_loop_1144_912_buf_req_0 : boolean;
  signal RPIPE_Block0_starting_828_inst_ack_0 : boolean;
  signal RPIPE_Block0_starting_834_inst_req_1 : boolean;
  signal RPIPE_Block0_starting_837_inst_req_1 : boolean;
  signal phi_stmt_913_ack_0 : boolean;
  signal RPIPE_Block0_starting_825_inst_ack_1 : boolean;
  signal phi_stmt_909_req_1 : boolean;
  signal next_j_loop_1144_912_buf_req_1 : boolean;
  signal RPIPE_Block0_starting_840_inst_req_1 : boolean;
  signal RPIPE_Block0_starting_828_inst_ack_1 : boolean;
  signal RPIPE_Block0_starting_837_inst_ack_0 : boolean;
  signal next_j_loop_1144_912_buf_ack_0 : boolean;
  signal phi_stmt_913_req_0 : boolean;
  signal RPIPE_Block0_starting_834_inst_req_0 : boolean;
  signal RPIPE_Block0_starting_834_inst_ack_0 : boolean;
  signal RPIPE_Block0_starting_831_inst_ack_1 : boolean;
  signal next_i_loop_1152_916_buf_req_1 : boolean;
  signal next_i_loop_1152_916_buf_ack_1 : boolean;
  signal RPIPE_Block0_starting_834_inst_ack_1 : boolean;
  signal RPIPE_Block0_starting_831_inst_req_1 : boolean;
  signal do_while_stmt_903_branch_req_0 : boolean;
  signal phi_stmt_917_req_0 : boolean;
  signal RPIPE_Block0_starting_840_inst_ack_0 : boolean;
  signal phi_stmt_913_req_1 : boolean;
  signal phi_stmt_917_ack_0 : boolean;
  signal RPIPE_Block0_starting_828_inst_req_0 : boolean;
  signal next_i_loop_1152_916_buf_ack_0 : boolean;
  signal WPIPE_Block0_complete_1160_inst_req_1 : boolean;
  signal phi_stmt_917_req_1 : boolean;
  signal RPIPE_Block0_starting_837_inst_req_0 : boolean;
  signal RPIPE_Block0_starting_831_inst_req_0 : boolean;
  signal RPIPE_Block0_starting_831_inst_ack_0 : boolean;
  signal next_i_loop_1152_916_buf_req_0 : boolean;
  signal RPIPE_Block0_starting_843_inst_ack_1 : boolean;
  signal next_dest_add_1025_920_buf_ack_0 : boolean;
  signal RPIPE_Block0_starting_843_inst_req_1 : boolean;
  signal next_dest_add_1025_920_buf_req_0 : boolean;
  signal RPIPE_Block0_starting_843_inst_ack_0 : boolean;
  signal RPIPE_Block0_starting_843_inst_req_0 : boolean;
  signal next_dest_add_1025_920_buf_req_1 : boolean;
  signal next_dest_add_1025_920_buf_ack_1 : boolean;
  signal WPIPE_Block0_complete_1160_inst_ack_1 : boolean;
  signal WPIPE_Block0_complete_1160_inst_req_0 : boolean;
  signal phi_stmt_921_req_1 : boolean;
  signal phi_stmt_921_ack_0 : boolean;
  signal WPIPE_Block0_complete_1160_inst_ack_0 : boolean;
  signal RPIPE_Block0_starting_840_inst_ack_1 : boolean;
  signal phi_stmt_921_req_0 : boolean;
  signal RPIPE_Block0_starting_825_inst_req_1 : boolean;
  signal next_src_add_1030_924_buf_req_0 : boolean;
  signal next_src_add_1030_924_buf_ack_0 : boolean;
  signal next_src_add_1030_924_buf_req_1 : boolean;
  signal next_src_add_1030_924_buf_ack_1 : boolean;
  signal ADD_u16_u16_989_inst_req_0 : boolean;
  signal ADD_u16_u16_989_inst_ack_0 : boolean;
  signal ADD_u16_u16_989_inst_req_1 : boolean;
  signal ADD_u16_u16_989_inst_ack_1 : boolean;
  signal ADD_u16_u16_999_inst_req_0 : boolean;
  signal ADD_u16_u16_999_inst_ack_0 : boolean;
  signal ADD_u16_u16_999_inst_req_1 : boolean;
  signal ADD_u16_u16_999_inst_ack_1 : boolean;
  signal array_obj_ref_1036_index_offset_req_0 : boolean;
  signal array_obj_ref_1036_index_offset_ack_0 : boolean;
  signal array_obj_ref_1036_index_offset_req_1 : boolean;
  signal array_obj_ref_1036_index_offset_ack_1 : boolean;
  signal addr_of_1037_final_reg_req_0 : boolean;
  signal addr_of_1037_final_reg_ack_0 : boolean;
  signal addr_of_1037_final_reg_req_1 : boolean;
  signal addr_of_1037_final_reg_ack_1 : boolean;
  signal ptr_deref_1041_load_0_req_0 : boolean;
  signal ptr_deref_1041_load_0_ack_0 : boolean;
  signal ptr_deref_1041_load_0_req_1 : boolean;
  signal ptr_deref_1041_load_0_ack_1 : boolean;
  signal array_obj_ref_1048_index_offset_req_0 : boolean;
  signal array_obj_ref_1048_index_offset_ack_0 : boolean;
  signal array_obj_ref_1048_index_offset_req_1 : boolean;
  signal array_obj_ref_1048_index_offset_ack_1 : boolean;
  signal addr_of_1049_final_reg_req_0 : boolean;
  signal addr_of_1049_final_reg_ack_0 : boolean;
  signal addr_of_1049_final_reg_req_1 : boolean;
  signal addr_of_1049_final_reg_ack_1 : boolean;
  signal W_ov_1045_delayed_7_0_1051_inst_req_0 : boolean;
  signal W_ov_1045_delayed_7_0_1051_inst_ack_0 : boolean;
  signal W_ov_1045_delayed_7_0_1051_inst_req_1 : boolean;
  signal W_ov_1045_delayed_7_0_1051_inst_ack_1 : boolean;
  signal W_data_check_1047_delayed_13_0_1054_inst_req_0 : boolean;
  signal W_data_check_1047_delayed_13_0_1054_inst_ack_0 : boolean;
  signal W_data_check_1047_delayed_13_0_1054_inst_req_1 : boolean;
  signal W_data_check_1047_delayed_13_0_1054_inst_ack_1 : boolean;
  signal MUX_1063_inst_req_0 : boolean;
  signal MUX_1063_inst_ack_0 : boolean;
  signal MUX_1063_inst_req_1 : boolean;
  signal MUX_1063_inst_ack_1 : boolean;
  signal ptr_deref_1058_store_0_req_0 : boolean;
  signal ptr_deref_1058_store_0_ack_0 : boolean;
  signal ptr_deref_1058_store_0_req_1 : boolean;
  signal ptr_deref_1058_store_0_ack_1 : boolean;
  signal W_dim2T_dif_1060_delayed_1_0_1070_inst_req_0 : boolean;
  signal W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_0 : boolean;
  signal W_dim2T_dif_1060_delayed_1_0_1070_inst_req_1 : boolean;
  signal W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_1 : boolean;
  signal W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_0 : boolean;
  signal W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_0 : boolean;
  signal W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_1 : boolean;
  signal W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_1 : boolean;
  signal W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_0 : boolean;
  signal W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_0 : boolean;
  signal W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_1 : boolean;
  signal W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_1 : boolean;
  signal do_while_stmt_903_branch_ack_0 : boolean;
  signal do_while_stmt_903_branch_ack_1 : boolean;
  -- 
begin --  
  -- input handling ------------------------------------------------
  in_buffer: UnloadBuffer -- 
    generic map(name => "zeropad3D_A_input_buffer", -- 
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
  zeropad3D_A_CP_2082_start <= in_buffer_unload_ack_symbol;
  -- output handling  -------------------------------------------------------
  out_buffer: ReceiveBuffer -- 
    generic map(name => "zeropad3D_A_out_buffer", -- 
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
    preds <= zeropad3D_A_CP_2082_symbol & out_buffer_write_ack_symbol & tag_ilock_read_ack_symbol;
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
    preds <= zeropad3D_A_CP_2082_start & tag_ilock_write_ack_symbol;
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
    preds <= zeropad3D_A_CP_2082_start & tag_ilock_read_ack_symbol & out_buffer_write_ack_symbol;
    gj_tag_ilock_read_req_symbol_join : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
      port map(preds => preds, symbol_out => tag_ilock_read_req_symbol, clk => clk, reset => reset); --
  end block;
  -- the control path --------------------------------------------------
  always_true_symbol <= true; 
  default_zero_sig <= '0';
  zeropad3D_A_CP_2082: Block -- control-path 
    signal zeropad3D_A_CP_2082_elements: BooleanArray(182 downto 0);
    -- 
  begin -- 
    zeropad3D_A_CP_2082_elements(0) <= zeropad3D_A_CP_2082_start;
    zeropad3D_A_CP_2082_symbol <= zeropad3D_A_CP_2082_elements(182);
    -- CP-element group 0:  transition  place  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	2 
    -- CP-element group 0:  members (8) 
      -- CP-element group 0: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844__entry__
      -- CP-element group 0: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Sample/rr
      -- CP-element group 0: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Sample/$entry
      -- CP-element group 0: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_sample_start_
      -- CP-element group 0: 	 branch_block_stmt_823/$entry
      -- CP-element group 0: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/$entry
      -- CP-element group 0: 	 branch_block_stmt_823/branch_block_stmt_823__entry__
      -- CP-element group 0: 	 $entry
      -- 
    rr_2110_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2110_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(0), ack => RPIPE_Block0_starting_825_inst_req_0); -- 
    -- CP-element group 1:  transition  place  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	180 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	181 
    -- CP-element group 1:  members (6) 
      -- CP-element group 1: 	 branch_block_stmt_823/assign_stmt_1163__entry__
      -- CP-element group 1: 	 branch_block_stmt_823/do_while_stmt_903__exit__
      -- CP-element group 1: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Sample/req
      -- CP-element group 1: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Sample/$entry
      -- CP-element group 1: 	 branch_block_stmt_823/assign_stmt_1163/$entry
      -- CP-element group 1: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_sample_start_
      -- 
    req_2768_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2768_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(1), ack => WPIPE_Block0_complete_1160_inst_req_0); -- 
    zeropad3D_A_CP_2082_elements(1) <= zeropad3D_A_CP_2082_elements(180);
    -- CP-element group 2:  transition  input  output  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	0 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	3 
    -- CP-element group 2:  members (6) 
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Sample/ra
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Sample/$exit
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_update_start_
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_sample_completed_
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Update/$entry
      -- CP-element group 2: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Update/cr
      -- 
    ra_2111_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_825_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(2)); -- 
    cr_2115_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2115_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(2), ack => RPIPE_Block0_starting_825_inst_req_1); -- 
    -- CP-element group 3:  transition  input  output  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: 	2 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	4 
    -- CP-element group 3:  members (6) 
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_sample_start_
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Update/ca
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_Update/$exit
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Sample/$entry
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Sample/rr
      -- CP-element group 3: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_825_update_completed_
      -- 
    ca_2116_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 3_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_825_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(3)); -- 
    rr_2124_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2124_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(3), ack => RPIPE_Block0_starting_828_inst_req_0); -- 
    -- CP-element group 4:  transition  input  output  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	3 
    -- CP-element group 4: successors 
    -- CP-element group 4: 	5 
    -- CP-element group 4:  members (6) 
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Update/cr
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_update_start_
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Sample/$exit
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Sample/ra
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_sample_completed_
      -- CP-element group 4: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Update/$entry
      -- 
    ra_2125_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 4_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_828_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(4)); -- 
    cr_2129_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2129_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(4), ack => RPIPE_Block0_starting_828_inst_req_1); -- 
    -- CP-element group 5:  transition  input  output  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	4 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	6 
    -- CP-element group 5:  members (6) 
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_sample_start_
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Sample/$entry
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_update_completed_
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Update/ca
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_828_Update/$exit
      -- CP-element group 5: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Sample/rr
      -- 
    ca_2130_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_828_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(5)); -- 
    rr_2138_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2138_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(5), ack => RPIPE_Block0_starting_831_inst_req_0); -- 
    -- CP-element group 6:  transition  input  output  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	5 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	7 
    -- CP-element group 6:  members (6) 
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_update_start_
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Update/cr
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_sample_completed_
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Sample/$exit
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Sample/ra
      -- CP-element group 6: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Update/$entry
      -- 
    ra_2139_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 6_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_831_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(6)); -- 
    cr_2143_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2143_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(6), ack => RPIPE_Block0_starting_831_inst_req_1); -- 
    -- CP-element group 7:  transition  input  output  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	6 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	8 
    -- CP-element group 7:  members (6) 
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_update_completed_
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Sample/$entry
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Sample/rr
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Update/ca
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_sample_start_
      -- CP-element group 7: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_831_Update/$exit
      -- 
    ca_2144_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 7_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_831_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(7)); -- 
    rr_2152_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2152_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(7), ack => RPIPE_Block0_starting_834_inst_req_0); -- 
    -- CP-element group 8:  transition  input  output  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	7 
    -- CP-element group 8: successors 
    -- CP-element group 8: 	9 
    -- CP-element group 8:  members (6) 
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Update/cr
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Sample/$exit
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_sample_completed_
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Sample/ra
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Update/$entry
      -- CP-element group 8: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_update_start_
      -- 
    ra_2153_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 8_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_834_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(8)); -- 
    cr_2157_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2157_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(8), ack => RPIPE_Block0_starting_834_inst_req_1); -- 
    -- CP-element group 9:  transition  input  output  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	8 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	10 
    -- CP-element group 9:  members (6) 
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Sample/$entry
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_sample_start_
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_update_completed_
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Update/$exit
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_834_Update/ca
      -- CP-element group 9: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Sample/rr
      -- 
    ca_2158_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 9_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_834_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(9)); -- 
    rr_2166_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2166_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(9), ack => RPIPE_Block0_starting_837_inst_req_0); -- 
    -- CP-element group 10:  transition  input  output  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	9 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	11 
    -- CP-element group 10:  members (6) 
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_sample_completed_
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Update/cr
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Update/$entry
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Sample/ra
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Sample/$exit
      -- CP-element group 10: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_update_start_
      -- 
    ra_2167_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_837_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(10)); -- 
    cr_2171_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2171_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(10), ack => RPIPE_Block0_starting_837_inst_req_1); -- 
    -- CP-element group 11:  transition  input  output  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	10 
    -- CP-element group 11: successors 
    -- CP-element group 11: 	12 
    -- CP-element group 11:  members (6) 
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Update/ca
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Sample/$entry
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Sample/rr
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_Update/$exit
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_837_update_completed_
      -- CP-element group 11: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_sample_start_
      -- 
    ca_2172_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_837_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(11)); -- 
    rr_2180_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2180_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(11), ack => RPIPE_Block0_starting_840_inst_req_0); -- 
    -- CP-element group 12:  transition  input  output  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	11 
    -- CP-element group 12: successors 
    -- CP-element group 12: 	13 
    -- CP-element group 12:  members (6) 
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_sample_completed_
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_update_start_
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Sample/$exit
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Update/cr
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Sample/ra
      -- CP-element group 12: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Update/$entry
      -- 
    ra_2181_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 12_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_840_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(12)); -- 
    cr_2185_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2185_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(12), ack => RPIPE_Block0_starting_840_inst_req_1); -- 
    -- CP-element group 13:  transition  input  output  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	12 
    -- CP-element group 13: successors 
    -- CP-element group 13: 	14 
    -- CP-element group 13:  members (6) 
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_update_completed_
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Update/$exit
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Sample/rr
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Sample/$entry
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_sample_start_
      -- CP-element group 13: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_840_Update/ca
      -- 
    ca_2186_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_840_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(13)); -- 
    rr_2194_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2194_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(13), ack => RPIPE_Block0_starting_843_inst_req_0); -- 
    -- CP-element group 14:  transition  input  output  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	13 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14:  members (6) 
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Update/cr
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Update/$entry
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Sample/ra
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Sample/$exit
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_update_start_
      -- CP-element group 14: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_sample_completed_
      -- 
    ra_2195_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_843_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(14)); -- 
    cr_2199_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2199_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(14), ack => RPIPE_Block0_starting_843_inst_req_1); -- 
    -- CP-element group 15:  transition  place  input  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	16 
    -- CP-element group 15:  members (10) 
      -- CP-element group 15: 	 branch_block_stmt_823/do_while_stmt_903__entry__
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_849_to_assign_stmt_902__exit__
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_849_to_assign_stmt_902__entry__
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844__exit__
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/$exit
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_849_to_assign_stmt_902/$exit
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_849_to_assign_stmt_902/$entry
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Update/ca
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_Update/$exit
      -- CP-element group 15: 	 branch_block_stmt_823/assign_stmt_826_to_assign_stmt_844/RPIPE_Block0_starting_843_update_completed_
      -- 
    ca_2200_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 15_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_Block0_starting_843_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(15)); -- 
    -- CP-element group 16:  transition  place  bypass  pipeline-parent 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	15 
    -- CP-element group 16: successors 
    -- CP-element group 16: 	22 
    -- CP-element group 16:  members (2) 
      -- CP-element group 16: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903__entry__
      -- CP-element group 16: 	 branch_block_stmt_823/do_while_stmt_903/$entry
      -- 
    zeropad3D_A_CP_2082_elements(16) <= zeropad3D_A_CP_2082_elements(15);
    -- CP-element group 17:  merge  place  bypass  pipeline-parent 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	180 
    -- CP-element group 17:  members (1) 
      -- CP-element group 17: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903__exit__
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(17) is bound as output of CP function.
    -- CP-element group 18:  merge  place  bypass  pipeline-parent 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	21 
    -- CP-element group 18:  members (1) 
      -- CP-element group 18: 	 branch_block_stmt_823/do_while_stmt_903/loop_back
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(18) is bound as output of CP function.
    -- CP-element group 19:  branch  transition  place  bypass  pipeline-parent 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	24 
    -- CP-element group 19: successors 
    -- CP-element group 19: 	178 
    -- CP-element group 19: 	179 
    -- CP-element group 19:  members (3) 
      -- CP-element group 19: 	 branch_block_stmt_823/do_while_stmt_903/condition_done
      -- CP-element group 19: 	 branch_block_stmt_823/do_while_stmt_903/loop_exit/$entry
      -- CP-element group 19: 	 branch_block_stmt_823/do_while_stmt_903/loop_taken/$entry
      -- 
    zeropad3D_A_CP_2082_elements(19) <= zeropad3D_A_CP_2082_elements(24);
    -- CP-element group 20:  branch  place  bypass  pipeline-parent 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	177 
    -- CP-element group 20: successors 
    -- CP-element group 20:  members (1) 
      -- CP-element group 20: 	 branch_block_stmt_823/do_while_stmt_903/loop_body_done
      -- 
    zeropad3D_A_CP_2082_elements(20) <= zeropad3D_A_CP_2082_elements(177);
    -- CP-element group 21:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	18 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	33 
    -- CP-element group 21: 	52 
    -- CP-element group 21: 	71 
    -- CP-element group 21: 	90 
    -- CP-element group 21: 	109 
    -- CP-element group 21:  members (1) 
      -- CP-element group 21: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/back_edge_to_loop_body
      -- 
    zeropad3D_A_CP_2082_elements(21) <= zeropad3D_A_CP_2082_elements(18);
    -- CP-element group 22:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	16 
    -- CP-element group 22: successors 
    -- CP-element group 22: 	35 
    -- CP-element group 22: 	54 
    -- CP-element group 22: 	73 
    -- CP-element group 22: 	92 
    -- CP-element group 22: 	111 
    -- CP-element group 22:  members (1) 
      -- CP-element group 22: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/first_time_through_loop_body
      -- 
    zeropad3D_A_CP_2082_elements(22) <= zeropad3D_A_CP_2082_elements(16);
    -- CP-element group 23:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: successors 
    -- CP-element group 23: 	126 
    -- CP-element group 23: 	122 
    -- CP-element group 23: 	131 
    -- CP-element group 23: 	142 
    -- CP-element group 23: 	143 
    -- CP-element group 23: 	172 
    -- CP-element group 23: 	176 
    -- CP-element group 23: 	164 
    -- CP-element group 23: 	168 
    -- CP-element group 23: 	132 
    -- CP-element group 23: 	29 
    -- CP-element group 23: 	30 
    -- CP-element group 23: 	46 
    -- CP-element group 23: 	47 
    -- CP-element group 23: 	65 
    -- CP-element group 23: 	66 
    -- CP-element group 23: 	84 
    -- CP-element group 23: 	85 
    -- CP-element group 23: 	103 
    -- CP-element group 23: 	104 
    -- CP-element group 23:  members (2) 
      -- CP-element group 23: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/loop_body_start
      -- CP-element group 23: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/$entry
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(23) is bound as output of CP function.
    -- CP-element group 24:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	175 
    -- CP-element group 24: 	176 
    -- CP-element group 24: 	167 
    -- CP-element group 24: 	28 
    -- CP-element group 24: successors 
    -- CP-element group 24: 	19 
    -- CP-element group 24:  members (1) 
      -- CP-element group 24: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/condition_evaluated
      -- 
    condition_evaluated_2218_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " condition_evaluated_2218_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(24), ack => do_while_stmt_903_branch_req_0); -- 
    zeropad3D_A_cp_element_group_24: block -- 
      constant place_capacities: IntegerArray(0 to 3) := (0 => 15,1 => 15,2 => 15,3 => 15);
      constant place_markings: IntegerArray(0 to 3)  := (0 => 0,1 => 0,2 => 0,3 => 0);
      constant place_delays: IntegerArray(0 to 3) := (0 => 0,1 => 0,2 => 0,3 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_24"; 
      signal preds: BooleanArray(1 to 4); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(175) & zeropad3D_A_CP_2082_elements(176) & zeropad3D_A_CP_2082_elements(167) & zeropad3D_A_CP_2082_elements(28);
      gj_zeropad3D_A_cp_element_group_24 : generic_join generic map(name => joinName, number_of_predecessors => 4, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(24), clk => clk, reset => reset); --
    end block;
    -- CP-element group 25:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	29 
    -- CP-element group 25: 	46 
    -- CP-element group 25: 	65 
    -- CP-element group 25: 	84 
    -- CP-element group 25: 	103 
    -- CP-element group 25: marked-predecessors 
    -- CP-element group 25: 	28 
    -- CP-element group 25: successors 
    -- CP-element group 25: 	48 
    -- CP-element group 25: 	67 
    -- CP-element group 25: 	86 
    -- CP-element group 25: 	105 
    -- CP-element group 25:  members (2) 
      -- CP-element group 25: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_sample_start__ps
      -- CP-element group 25: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/aggregated_phi_sample_req
      -- 
    zeropad3D_A_cp_element_group_25: block -- 
      constant place_capacities: IntegerArray(0 to 5) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15,5 => 1);
      constant place_markings: IntegerArray(0 to 5)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 1);
      constant place_delays: IntegerArray(0 to 5) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_25"; 
      signal preds: BooleanArray(1 to 6); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(29) & zeropad3D_A_CP_2082_elements(46) & zeropad3D_A_CP_2082_elements(65) & zeropad3D_A_CP_2082_elements(84) & zeropad3D_A_CP_2082_elements(103) & zeropad3D_A_CP_2082_elements(28);
      gj_zeropad3D_A_cp_element_group_25 : generic_join generic map(name => joinName, number_of_predecessors => 6, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(25), clk => clk, reset => reset); --
    end block;
    -- CP-element group 26:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	31 
    -- CP-element group 26: 	49 
    -- CP-element group 26: 	68 
    -- CP-element group 26: 	87 
    -- CP-element group 26: 	106 
    -- CP-element group 26: successors 
    -- CP-element group 26: 	177 
    -- CP-element group 26: 	165 
    -- CP-element group 26: 	169 
    -- CP-element group 26: marked-successors 
    -- CP-element group 26: 	29 
    -- CP-element group 26: 	46 
    -- CP-element group 26: 	65 
    -- CP-element group 26: 	84 
    -- CP-element group 26: 	103 
    -- CP-element group 26:  members (6) 
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/aggregated_phi_sample_ack
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_sample_completed_
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_sample_completed_
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_sample_completed_
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_sample_completed_
      -- CP-element group 26: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_sample_completed_
      -- 
    zeropad3D_A_cp_element_group_26: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_26"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(31) & zeropad3D_A_CP_2082_elements(49) & zeropad3D_A_CP_2082_elements(68) & zeropad3D_A_CP_2082_elements(87) & zeropad3D_A_CP_2082_elements(106);
      gj_zeropad3D_A_cp_element_group_26 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(26), clk => clk, reset => reset); --
    end block;
    -- CP-element group 27:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: 	30 
    -- CP-element group 27: 	47 
    -- CP-element group 27: 	66 
    -- CP-element group 27: 	85 
    -- CP-element group 27: 	104 
    -- CP-element group 27: successors 
    -- CP-element group 27: 	50 
    -- CP-element group 27: 	69 
    -- CP-element group 27: 	88 
    -- CP-element group 27: 	107 
    -- CP-element group 27:  members (2) 
      -- CP-element group 27: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_update_start__ps
      -- CP-element group 27: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/aggregated_phi_update_req
      -- 
    zeropad3D_A_cp_element_group_27: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_27"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(30) & zeropad3D_A_CP_2082_elements(47) & zeropad3D_A_CP_2082_elements(66) & zeropad3D_A_CP_2082_elements(85) & zeropad3D_A_CP_2082_elements(104);
      gj_zeropad3D_A_cp_element_group_27 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(27), clk => clk, reset => reset); --
    end block;
    -- CP-element group 28:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 28: predecessors 
    -- CP-element group 28: 	32 
    -- CP-element group 28: 	51 
    -- CP-element group 28: 	70 
    -- CP-element group 28: 	89 
    -- CP-element group 28: 	108 
    -- CP-element group 28: successors 
    -- CP-element group 28: 	24 
    -- CP-element group 28: marked-successors 
    -- CP-element group 28: 	25 
    -- CP-element group 28:  members (1) 
      -- CP-element group 28: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/aggregated_phi_update_ack
      -- 
    zeropad3D_A_cp_element_group_28: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_28"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(32) & zeropad3D_A_CP_2082_elements(51) & zeropad3D_A_CP_2082_elements(70) & zeropad3D_A_CP_2082_elements(89) & zeropad3D_A_CP_2082_elements(108);
      gj_zeropad3D_A_cp_element_group_28 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(28), clk => clk, reset => reset); --
    end block;
    -- CP-element group 29:  join  transition  bypass  pipeline-parent 
    -- CP-element group 29: predecessors 
    -- CP-element group 29: 	23 
    -- CP-element group 29: marked-predecessors 
    -- CP-element group 29: 	167 
    -- CP-element group 29: 	26 
    -- CP-element group 29: successors 
    -- CP-element group 29: 	25 
    -- CP-element group 29:  members (1) 
      -- CP-element group 29: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_sample_start_
      -- 
    zeropad3D_A_cp_element_group_29: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_29"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(167) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_29 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(29), clk => clk, reset => reset); --
    end block;
    -- CP-element group 30:  join  transition  bypass  pipeline-parent 
    -- CP-element group 30: predecessors 
    -- CP-element group 30: 	23 
    -- CP-element group 30: marked-predecessors 
    -- CP-element group 30: 	32 
    -- CP-element group 30: successors 
    -- CP-element group 30: 	27 
    -- CP-element group 30:  members (1) 
      -- CP-element group 30: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_update_start_
      -- 
    zeropad3D_A_cp_element_group_30: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_30"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(32);
      gj_zeropad3D_A_cp_element_group_30 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(30), clk => clk, reset => reset); --
    end block;
    -- CP-element group 31:  join  transition  bypass  pipeline-parent 
    -- CP-element group 31: predecessors 
    -- CP-element group 31: successors 
    -- CP-element group 31: 	26 
    -- CP-element group 31:  members (1) 
      -- CP-element group 31: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(31) is bound as output of CP function.
    -- CP-element group 32:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 32: predecessors 
    -- CP-element group 32: successors 
    -- CP-element group 32: 	28 
    -- CP-element group 32: marked-successors 
    -- CP-element group 32: 	30 
    -- CP-element group 32:  members (2) 
      -- CP-element group 32: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_update_completed__ps
      -- CP-element group 32: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(32) is bound as output of CP function.
    -- CP-element group 33:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 33: predecessors 
    -- CP-element group 33: 	21 
    -- CP-element group 33: successors 
    -- CP-element group 33:  members (1) 
      -- CP-element group 33: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_loopback_trigger
      -- 
    zeropad3D_A_CP_2082_elements(33) <= zeropad3D_A_CP_2082_elements(21);
    -- CP-element group 34:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 34: predecessors 
    -- CP-element group 34: successors 
    -- CP-element group 34:  members (2) 
      -- CP-element group 34: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_loopback_sample_req_ps
      -- CP-element group 34: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_loopback_sample_req
      -- 
    phi_stmt_905_loopback_sample_req_2233_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_905_loopback_sample_req_2233_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(34), ack => phi_stmt_905_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(34) is bound as output of CP function.
    -- CP-element group 35:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 35: predecessors 
    -- CP-element group 35: 	22 
    -- CP-element group 35: successors 
    -- CP-element group 35:  members (1) 
      -- CP-element group 35: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_entry_trigger
      -- 
    zeropad3D_A_CP_2082_elements(35) <= zeropad3D_A_CP_2082_elements(22);
    -- CP-element group 36:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 36: predecessors 
    -- CP-element group 36: successors 
    -- CP-element group 36:  members (2) 
      -- CP-element group 36: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_entry_sample_req
      -- CP-element group 36: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_entry_sample_req_ps
      -- 
    phi_stmt_905_entry_sample_req_2236_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_905_entry_sample_req_2236_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(36), ack => phi_stmt_905_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(36) is bound as output of CP function.
    -- CP-element group 37:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 37: predecessors 
    -- CP-element group 37: successors 
    -- CP-element group 37:  members (2) 
      -- CP-element group 37: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_phi_mux_ack
      -- CP-element group 37: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_905_phi_mux_ack_ps
      -- 
    phi_stmt_905_phi_mux_ack_2239_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 37_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_905_ack_0, ack => zeropad3D_A_CP_2082_elements(37)); -- 
    -- CP-element group 38:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 38: predecessors 
    -- CP-element group 38: successors 
    -- CP-element group 38:  members (4) 
      -- CP-element group 38: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_sample_completed__ps
      -- CP-element group 38: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_sample_start__ps
      -- CP-element group 38: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_sample_start_
      -- CP-element group 38: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_sample_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(38) is bound as output of CP function.
    -- CP-element group 39:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 39: predecessors 
    -- CP-element group 39: successors 
    -- CP-element group 39: 	41 
    -- CP-element group 39:  members (2) 
      -- CP-element group 39: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_update_start_
      -- CP-element group 39: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_update_start__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(39) is bound as output of CP function.
    -- CP-element group 40:  join  transition  bypass  pipeline-parent 
    -- CP-element group 40: predecessors 
    -- CP-element group 40: 	41 
    -- CP-element group 40: successors 
    -- CP-element group 40:  members (1) 
      -- CP-element group 40: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_update_completed__ps
      -- 
    zeropad3D_A_CP_2082_elements(40) <= zeropad3D_A_CP_2082_elements(41);
    -- CP-element group 41:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 41: predecessors 
    -- CP-element group 41: 	39 
    -- CP-element group 41: successors 
    -- CP-element group 41: 	40 
    -- CP-element group 41:  members (1) 
      -- CP-element group 41: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_k_loop_init_907_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(41) is a control-delay.
    cp_element_41_delay: control_delay_element  generic map(name => " 41_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(39), ack => zeropad3D_A_CP_2082_elements(41), clk => clk, reset =>reset);
    -- CP-element group 42:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 42: predecessors 
    -- CP-element group 42: successors 
    -- CP-element group 42: 	44 
    -- CP-element group 42:  members (4) 
      -- CP-element group 42: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_sample_start__ps
      -- CP-element group 42: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Sample/req
      -- CP-element group 42: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Sample/$entry
      -- CP-element group 42: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_sample_start_
      -- 
    req_2260_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2260_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(42), ack => next_k_loop_1133_908_buf_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(42) is bound as output of CP function.
    -- CP-element group 43:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 43: predecessors 
    -- CP-element group 43: successors 
    -- CP-element group 43: 	45 
    -- CP-element group 43:  members (4) 
      -- CP-element group 43: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Update/$entry
      -- CP-element group 43: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Update/req
      -- CP-element group 43: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_update_start_
      -- CP-element group 43: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_update_start__ps
      -- 
    req_2265_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2265_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(43), ack => next_k_loop_1133_908_buf_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(43) is bound as output of CP function.
    -- CP-element group 44:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 44: predecessors 
    -- CP-element group 44: 	42 
    -- CP-element group 44: successors 
    -- CP-element group 44:  members (4) 
      -- CP-element group 44: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Sample/$exit
      -- CP-element group 44: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Sample/ack
      -- CP-element group 44: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_sample_completed__ps
      -- CP-element group 44: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_sample_completed_
      -- 
    ack_2261_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 44_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_k_loop_1133_908_buf_ack_0, ack => zeropad3D_A_CP_2082_elements(44)); -- 
    -- CP-element group 45:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 45: predecessors 
    -- CP-element group 45: 	43 
    -- CP-element group 45: successors 
    -- CP-element group 45:  members (4) 
      -- CP-element group 45: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Update/$exit
      -- CP-element group 45: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_Update/ack
      -- CP-element group 45: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_update_completed_
      -- CP-element group 45: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_k_loop_908_update_completed__ps
      -- 
    ack_2266_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 45_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_k_loop_1133_908_buf_ack_1, ack => zeropad3D_A_CP_2082_elements(45)); -- 
    -- CP-element group 46:  join  transition  bypass  pipeline-parent 
    -- CP-element group 46: predecessors 
    -- CP-element group 46: 	23 
    -- CP-element group 46: marked-predecessors 
    -- CP-element group 46: 	171 
    -- CP-element group 46: 	167 
    -- CP-element group 46: 	26 
    -- CP-element group 46: successors 
    -- CP-element group 46: 	25 
    -- CP-element group 46:  members (1) 
      -- CP-element group 46: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_sample_start_
      -- 
    zeropad3D_A_cp_element_group_46: block -- 
      constant place_capacities: IntegerArray(0 to 3) := (0 => 15,1 => 1,2 => 1,3 => 1);
      constant place_markings: IntegerArray(0 to 3)  := (0 => 0,1 => 1,2 => 1,3 => 1);
      constant place_delays: IntegerArray(0 to 3) := (0 => 0,1 => 0,2 => 0,3 => 1);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_46"; 
      signal preds: BooleanArray(1 to 4); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(171) & zeropad3D_A_CP_2082_elements(167) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_46 : generic_join generic map(name => joinName, number_of_predecessors => 4, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(46), clk => clk, reset => reset); --
    end block;
    -- CP-element group 47:  join  transition  bypass  pipeline-parent 
    -- CP-element group 47: predecessors 
    -- CP-element group 47: 	23 
    -- CP-element group 47: marked-predecessors 
    -- CP-element group 47: 	154 
    -- CP-element group 47: successors 
    -- CP-element group 47: 	27 
    -- CP-element group 47:  members (1) 
      -- CP-element group 47: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_update_start_
      -- 
    zeropad3D_A_cp_element_group_47: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_47"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(154);
      gj_zeropad3D_A_cp_element_group_47 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(47), clk => clk, reset => reset); --
    end block;
    -- CP-element group 48:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 48: predecessors 
    -- CP-element group 48: 	25 
    -- CP-element group 48: successors 
    -- CP-element group 48:  members (1) 
      -- CP-element group 48: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_sample_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(48) <= zeropad3D_A_CP_2082_elements(25);
    -- CP-element group 49:  join  transition  bypass  pipeline-parent 
    -- CP-element group 49: predecessors 
    -- CP-element group 49: successors 
    -- CP-element group 49: 	26 
    -- CP-element group 49:  members (1) 
      -- CP-element group 49: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(49) is bound as output of CP function.
    -- CP-element group 50:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 50: predecessors 
    -- CP-element group 50: 	27 
    -- CP-element group 50: successors 
    -- CP-element group 50:  members (1) 
      -- CP-element group 50: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_update_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(50) <= zeropad3D_A_CP_2082_elements(27);
    -- CP-element group 51:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 51: predecessors 
    -- CP-element group 51: successors 
    -- CP-element group 51: 	152 
    -- CP-element group 51: 	28 
    -- CP-element group 51:  members (2) 
      -- CP-element group 51: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_update_completed__ps
      -- CP-element group 51: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(51) is bound as output of CP function.
    -- CP-element group 52:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 52: predecessors 
    -- CP-element group 52: 	21 
    -- CP-element group 52: successors 
    -- CP-element group 52:  members (1) 
      -- CP-element group 52: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_loopback_trigger
      -- 
    zeropad3D_A_CP_2082_elements(52) <= zeropad3D_A_CP_2082_elements(21);
    -- CP-element group 53:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 53: predecessors 
    -- CP-element group 53: successors 
    -- CP-element group 53:  members (2) 
      -- CP-element group 53: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_loopback_sample_req_ps
      -- CP-element group 53: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_loopback_sample_req
      -- 
    phi_stmt_909_loopback_sample_req_2277_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_909_loopback_sample_req_2277_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(53), ack => phi_stmt_909_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(53) is bound as output of CP function.
    -- CP-element group 54:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 54: predecessors 
    -- CP-element group 54: 	22 
    -- CP-element group 54: successors 
    -- CP-element group 54:  members (1) 
      -- CP-element group 54: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_entry_trigger
      -- 
    zeropad3D_A_CP_2082_elements(54) <= zeropad3D_A_CP_2082_elements(22);
    -- CP-element group 55:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 55: predecessors 
    -- CP-element group 55: successors 
    -- CP-element group 55:  members (2) 
      -- CP-element group 55: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_entry_sample_req
      -- CP-element group 55: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_entry_sample_req_ps
      -- 
    phi_stmt_909_entry_sample_req_2280_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_909_entry_sample_req_2280_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(55), ack => phi_stmt_909_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(55) is bound as output of CP function.
    -- CP-element group 56:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 56: predecessors 
    -- CP-element group 56: successors 
    -- CP-element group 56:  members (2) 
      -- CP-element group 56: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_phi_mux_ack
      -- CP-element group 56: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_909_phi_mux_ack_ps
      -- 
    phi_stmt_909_phi_mux_ack_2283_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 56_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_909_ack_0, ack => zeropad3D_A_CP_2082_elements(56)); -- 
    -- CP-element group 57:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 57: predecessors 
    -- CP-element group 57: successors 
    -- CP-element group 57:  members (4) 
      -- CP-element group 57: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_sample_start__ps
      -- CP-element group 57: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_sample_start_
      -- CP-element group 57: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_sample_completed__ps
      -- CP-element group 57: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_sample_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(57) is bound as output of CP function.
    -- CP-element group 58:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 58: predecessors 
    -- CP-element group 58: successors 
    -- CP-element group 58: 	60 
    -- CP-element group 58:  members (2) 
      -- CP-element group 58: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_update_start__ps
      -- CP-element group 58: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_update_start_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(58) is bound as output of CP function.
    -- CP-element group 59:  join  transition  bypass  pipeline-parent 
    -- CP-element group 59: predecessors 
    -- CP-element group 59: 	60 
    -- CP-element group 59: successors 
    -- CP-element group 59:  members (1) 
      -- CP-element group 59: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_update_completed__ps
      -- 
    zeropad3D_A_CP_2082_elements(59) <= zeropad3D_A_CP_2082_elements(60);
    -- CP-element group 60:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 60: predecessors 
    -- CP-element group 60: 	58 
    -- CP-element group 60: successors 
    -- CP-element group 60: 	59 
    -- CP-element group 60:  members (1) 
      -- CP-element group 60: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_j_loop_init_911_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(60) is a control-delay.
    cp_element_60_delay: control_delay_element  generic map(name => " 60_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(58), ack => zeropad3D_A_CP_2082_elements(60), clk => clk, reset =>reset);
    -- CP-element group 61:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 61: predecessors 
    -- CP-element group 61: successors 
    -- CP-element group 61: 	63 
    -- CP-element group 61:  members (4) 
      -- CP-element group 61: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Sample/$entry
      -- CP-element group 61: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_sample_start_
      -- CP-element group 61: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Sample/req
      -- CP-element group 61: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_sample_start__ps
      -- 
    req_2304_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2304_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(61), ack => next_j_loop_1144_912_buf_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(61) is bound as output of CP function.
    -- CP-element group 62:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 62: predecessors 
    -- CP-element group 62: successors 
    -- CP-element group 62: 	64 
    -- CP-element group 62:  members (4) 
      -- CP-element group 62: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_update_start_
      -- CP-element group 62: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Update/req
      -- CP-element group 62: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Update/$entry
      -- CP-element group 62: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_update_start__ps
      -- 
    req_2309_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2309_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(62), ack => next_j_loop_1144_912_buf_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(62) is bound as output of CP function.
    -- CP-element group 63:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 63: predecessors 
    -- CP-element group 63: 	61 
    -- CP-element group 63: successors 
    -- CP-element group 63:  members (4) 
      -- CP-element group 63: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_sample_completed_
      -- CP-element group 63: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Sample/ack
      -- CP-element group 63: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_sample_completed__ps
      -- CP-element group 63: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Sample/$exit
      -- 
    ack_2305_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 63_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_j_loop_1144_912_buf_ack_0, ack => zeropad3D_A_CP_2082_elements(63)); -- 
    -- CP-element group 64:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 64: predecessors 
    -- CP-element group 64: 	62 
    -- CP-element group 64: successors 
    -- CP-element group 64:  members (4) 
      -- CP-element group 64: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Update/ack
      -- CP-element group 64: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_update_completed_
      -- CP-element group 64: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_Update/$exit
      -- CP-element group 64: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_j_loop_912_update_completed__ps
      -- 
    ack_2310_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 64_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_j_loop_1144_912_buf_ack_1, ack => zeropad3D_A_CP_2082_elements(64)); -- 
    -- CP-element group 65:  join  transition  bypass  pipeline-parent 
    -- CP-element group 65: predecessors 
    -- CP-element group 65: 	23 
    -- CP-element group 65: marked-predecessors 
    -- CP-element group 65: 	171 
    -- CP-element group 65: 	167 
    -- CP-element group 65: 	26 
    -- CP-element group 65: successors 
    -- CP-element group 65: 	25 
    -- CP-element group 65:  members (1) 
      -- CP-element group 65: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_sample_start_
      -- 
    zeropad3D_A_cp_element_group_65: block -- 
      constant place_capacities: IntegerArray(0 to 3) := (0 => 15,1 => 1,2 => 1,3 => 1);
      constant place_markings: IntegerArray(0 to 3)  := (0 => 0,1 => 1,2 => 1,3 => 1);
      constant place_delays: IntegerArray(0 to 3) := (0 => 0,1 => 0,2 => 0,3 => 1);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_65"; 
      signal preds: BooleanArray(1 to 4); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(171) & zeropad3D_A_CP_2082_elements(167) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_65 : generic_join generic map(name => joinName, number_of_predecessors => 4, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(65), clk => clk, reset => reset); --
    end block;
    -- CP-element group 66:  join  transition  bypass  pipeline-parent 
    -- CP-element group 66: predecessors 
    -- CP-element group 66: 	23 
    -- CP-element group 66: marked-predecessors 
    -- CP-element group 66: 	154 
    -- CP-element group 66: successors 
    -- CP-element group 66: 	27 
    -- CP-element group 66:  members (1) 
      -- CP-element group 66: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_update_start_
      -- 
    zeropad3D_A_cp_element_group_66: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_66"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(154);
      gj_zeropad3D_A_cp_element_group_66 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(66), clk => clk, reset => reset); --
    end block;
    -- CP-element group 67:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 67: predecessors 
    -- CP-element group 67: 	25 
    -- CP-element group 67: successors 
    -- CP-element group 67:  members (1) 
      -- CP-element group 67: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_sample_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(67) <= zeropad3D_A_CP_2082_elements(25);
    -- CP-element group 68:  join  transition  bypass  pipeline-parent 
    -- CP-element group 68: predecessors 
    -- CP-element group 68: successors 
    -- CP-element group 68: 	26 
    -- CP-element group 68:  members (1) 
      -- CP-element group 68: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(68) is bound as output of CP function.
    -- CP-element group 69:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 69: predecessors 
    -- CP-element group 69: 	27 
    -- CP-element group 69: successors 
    -- CP-element group 69:  members (1) 
      -- CP-element group 69: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_update_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(69) <= zeropad3D_A_CP_2082_elements(27);
    -- CP-element group 70:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 70: predecessors 
    -- CP-element group 70: successors 
    -- CP-element group 70: 	152 
    -- CP-element group 70: 	28 
    -- CP-element group 70:  members (2) 
      -- CP-element group 70: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_update_completed_
      -- CP-element group 70: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_update_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(70) is bound as output of CP function.
    -- CP-element group 71:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 71: predecessors 
    -- CP-element group 71: 	21 
    -- CP-element group 71: successors 
    -- CP-element group 71:  members (1) 
      -- CP-element group 71: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_loopback_trigger
      -- 
    zeropad3D_A_CP_2082_elements(71) <= zeropad3D_A_CP_2082_elements(21);
    -- CP-element group 72:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 72: predecessors 
    -- CP-element group 72: successors 
    -- CP-element group 72:  members (2) 
      -- CP-element group 72: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_loopback_sample_req_ps
      -- CP-element group 72: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_loopback_sample_req
      -- 
    phi_stmt_913_loopback_sample_req_2321_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_913_loopback_sample_req_2321_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(72), ack => phi_stmt_913_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(72) is bound as output of CP function.
    -- CP-element group 73:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 73: predecessors 
    -- CP-element group 73: 	22 
    -- CP-element group 73: successors 
    -- CP-element group 73:  members (1) 
      -- CP-element group 73: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_entry_trigger
      -- 
    zeropad3D_A_CP_2082_elements(73) <= zeropad3D_A_CP_2082_elements(22);
    -- CP-element group 74:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 74: predecessors 
    -- CP-element group 74: successors 
    -- CP-element group 74:  members (2) 
      -- CP-element group 74: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_entry_sample_req
      -- CP-element group 74: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_entry_sample_req_ps
      -- 
    phi_stmt_913_entry_sample_req_2324_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_913_entry_sample_req_2324_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(74), ack => phi_stmt_913_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(74) is bound as output of CP function.
    -- CP-element group 75:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 75: predecessors 
    -- CP-element group 75: successors 
    -- CP-element group 75:  members (2) 
      -- CP-element group 75: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_phi_mux_ack
      -- CP-element group 75: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_913_phi_mux_ack_ps
      -- 
    phi_stmt_913_phi_mux_ack_2327_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 75_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_913_ack_0, ack => zeropad3D_A_CP_2082_elements(75)); -- 
    -- CP-element group 76:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 76: predecessors 
    -- CP-element group 76: successors 
    -- CP-element group 76:  members (4) 
      -- CP-element group 76: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_sample_start_
      -- CP-element group 76: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_sample_start__ps
      -- CP-element group 76: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_sample_completed_
      -- CP-element group 76: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(76) is bound as output of CP function.
    -- CP-element group 77:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 77: predecessors 
    -- CP-element group 77: successors 
    -- CP-element group 77: 	79 
    -- CP-element group 77:  members (2) 
      -- CP-element group 77: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_update_start__ps
      -- CP-element group 77: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_update_start_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(77) is bound as output of CP function.
    -- CP-element group 78:  join  transition  bypass  pipeline-parent 
    -- CP-element group 78: predecessors 
    -- CP-element group 78: 	79 
    -- CP-element group 78: successors 
    -- CP-element group 78:  members (1) 
      -- CP-element group 78: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_update_completed__ps
      -- 
    zeropad3D_A_CP_2082_elements(78) <= zeropad3D_A_CP_2082_elements(79);
    -- CP-element group 79:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 79: predecessors 
    -- CP-element group 79: 	77 
    -- CP-element group 79: successors 
    -- CP-element group 79: 	78 
    -- CP-element group 79:  members (1) 
      -- CP-element group 79: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_i_loop_init_915_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(79) is a control-delay.
    cp_element_79_delay: control_delay_element  generic map(name => " 79_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(77), ack => zeropad3D_A_CP_2082_elements(79), clk => clk, reset =>reset);
    -- CP-element group 80:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 80: predecessors 
    -- CP-element group 80: successors 
    -- CP-element group 80: 	82 
    -- CP-element group 80:  members (4) 
      -- CP-element group 80: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Sample/req
      -- CP-element group 80: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Sample/$entry
      -- CP-element group 80: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_sample_start_
      -- CP-element group 80: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_sample_start__ps
      -- 
    req_2348_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2348_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(80), ack => next_i_loop_1152_916_buf_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(80) is bound as output of CP function.
    -- CP-element group 81:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 81: predecessors 
    -- CP-element group 81: successors 
    -- CP-element group 81: 	83 
    -- CP-element group 81:  members (4) 
      -- CP-element group 81: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Update/req
      -- CP-element group 81: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Update/$entry
      -- CP-element group 81: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_update_start_
      -- CP-element group 81: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_update_start__ps
      -- 
    req_2353_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2353_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(81), ack => next_i_loop_1152_916_buf_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(81) is bound as output of CP function.
    -- CP-element group 82:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 82: predecessors 
    -- CP-element group 82: 	80 
    -- CP-element group 82: successors 
    -- CP-element group 82:  members (4) 
      -- CP-element group 82: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Sample/ack
      -- CP-element group 82: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Sample/$exit
      -- CP-element group 82: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_sample_completed_
      -- CP-element group 82: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_sample_completed__ps
      -- 
    ack_2349_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 82_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_i_loop_1152_916_buf_ack_0, ack => zeropad3D_A_CP_2082_elements(82)); -- 
    -- CP-element group 83:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 83: predecessors 
    -- CP-element group 83: 	81 
    -- CP-element group 83: successors 
    -- CP-element group 83:  members (4) 
      -- CP-element group 83: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Update/$exit
      -- CP-element group 83: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_Update/ack
      -- CP-element group 83: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_update_completed_
      -- CP-element group 83: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_i_loop_916_update_completed__ps
      -- 
    ack_2354_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 83_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_i_loop_1152_916_buf_ack_1, ack => zeropad3D_A_CP_2082_elements(83)); -- 
    -- CP-element group 84:  join  transition  bypass  pipeline-parent 
    -- CP-element group 84: predecessors 
    -- CP-element group 84: 	23 
    -- CP-element group 84: marked-predecessors 
    -- CP-element group 84: 	26 
    -- CP-element group 84: successors 
    -- CP-element group 84: 	25 
    -- CP-element group 84:  members (1) 
      -- CP-element group 84: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_sample_start_
      -- 
    zeropad3D_A_cp_element_group_84: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_84"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_84 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(84), clk => clk, reset => reset); --
    end block;
    -- CP-element group 85:  join  transition  bypass  pipeline-parent 
    -- CP-element group 85: predecessors 
    -- CP-element group 85: 	23 
    -- CP-element group 85: marked-predecessors 
    -- CP-element group 85: 	144 
    -- CP-element group 85: successors 
    -- CP-element group 85: 	27 
    -- CP-element group 85:  members (1) 
      -- CP-element group 85: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_update_start_
      -- 
    zeropad3D_A_cp_element_group_85: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 31) := "zeropad3D_A_cp_element_group_85"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(144);
      gj_zeropad3D_A_cp_element_group_85 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(85), clk => clk, reset => reset); --
    end block;
    -- CP-element group 86:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 86: predecessors 
    -- CP-element group 86: 	25 
    -- CP-element group 86: successors 
    -- CP-element group 86:  members (1) 
      -- CP-element group 86: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_sample_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(86) <= zeropad3D_A_CP_2082_elements(25);
    -- CP-element group 87:  join  transition  bypass  pipeline-parent 
    -- CP-element group 87: predecessors 
    -- CP-element group 87: successors 
    -- CP-element group 87: 	26 
    -- CP-element group 87:  members (1) 
      -- CP-element group 87: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(87) is bound as output of CP function.
    -- CP-element group 88:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 88: predecessors 
    -- CP-element group 88: 	27 
    -- CP-element group 88: successors 
    -- CP-element group 88:  members (1) 
      -- CP-element group 88: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_update_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(88) <= zeropad3D_A_CP_2082_elements(27);
    -- CP-element group 89:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 89: predecessors 
    -- CP-element group 89: successors 
    -- CP-element group 89: 	144 
    -- CP-element group 89: 	28 
    -- CP-element group 89:  members (15) 
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_update_completed_
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_update_completed__ps
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_resized_1
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_scaled_1
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_computed_1
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_resize_1/$entry
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_resize_1/$exit
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_resize_1/index_resize_req
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_resize_1/index_resize_ack
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_scale_1/$entry
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_scale_1/$exit
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_scale_1/scale_rename_req
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_index_scale_1/scale_rename_ack
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Sample/$entry
      -- CP-element group 89: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Sample/req
      -- 
    req_2592_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2592_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(89), ack => array_obj_ref_1048_index_offset_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(89) is bound as output of CP function.
    -- CP-element group 90:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 90: predecessors 
    -- CP-element group 90: 	21 
    -- CP-element group 90: successors 
    -- CP-element group 90:  members (1) 
      -- CP-element group 90: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_loopback_trigger
      -- 
    zeropad3D_A_CP_2082_elements(90) <= zeropad3D_A_CP_2082_elements(21);
    -- CP-element group 91:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 91: predecessors 
    -- CP-element group 91: successors 
    -- CP-element group 91:  members (2) 
      -- CP-element group 91: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_loopback_sample_req_ps
      -- CP-element group 91: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_loopback_sample_req
      -- 
    phi_stmt_917_loopback_sample_req_2365_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_917_loopback_sample_req_2365_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(91), ack => phi_stmt_917_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(91) is bound as output of CP function.
    -- CP-element group 92:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 92: predecessors 
    -- CP-element group 92: 	22 
    -- CP-element group 92: successors 
    -- CP-element group 92:  members (1) 
      -- CP-element group 92: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_entry_trigger
      -- 
    zeropad3D_A_CP_2082_elements(92) <= zeropad3D_A_CP_2082_elements(22);
    -- CP-element group 93:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 93: predecessors 
    -- CP-element group 93: successors 
    -- CP-element group 93:  members (2) 
      -- CP-element group 93: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_entry_sample_req_ps
      -- CP-element group 93: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_entry_sample_req
      -- 
    phi_stmt_917_entry_sample_req_2368_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_917_entry_sample_req_2368_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(93), ack => phi_stmt_917_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(93) is bound as output of CP function.
    -- CP-element group 94:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 94: predecessors 
    -- CP-element group 94: successors 
    -- CP-element group 94:  members (2) 
      -- CP-element group 94: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_phi_mux_ack_ps
      -- CP-element group 94: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_917_phi_mux_ack
      -- 
    phi_stmt_917_phi_mux_ack_2371_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 94_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_917_ack_0, ack => zeropad3D_A_CP_2082_elements(94)); -- 
    -- CP-element group 95:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 95: predecessors 
    -- CP-element group 95: successors 
    -- CP-element group 95:  members (4) 
      -- CP-element group 95: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_sample_start_
      -- CP-element group 95: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_sample_completed_
      -- CP-element group 95: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_sample_start__ps
      -- CP-element group 95: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(95) is bound as output of CP function.
    -- CP-element group 96:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 96: predecessors 
    -- CP-element group 96: successors 
    -- CP-element group 96: 	98 
    -- CP-element group 96:  members (2) 
      -- CP-element group 96: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_update_start_
      -- CP-element group 96: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_update_start__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(96) is bound as output of CP function.
    -- CP-element group 97:  join  transition  bypass  pipeline-parent 
    -- CP-element group 97: predecessors 
    -- CP-element group 97: 	98 
    -- CP-element group 97: successors 
    -- CP-element group 97:  members (1) 
      -- CP-element group 97: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_update_completed__ps
      -- 
    zeropad3D_A_CP_2082_elements(97) <= zeropad3D_A_CP_2082_elements(98);
    -- CP-element group 98:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 98: predecessors 
    -- CP-element group 98: 	96 
    -- CP-element group 98: successors 
    -- CP-element group 98: 	97 
    -- CP-element group 98:  members (1) 
      -- CP-element group 98: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_dest_add_init_919_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(98) is a control-delay.
    cp_element_98_delay: control_delay_element  generic map(name => " 98_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(96), ack => zeropad3D_A_CP_2082_elements(98), clk => clk, reset =>reset);
    -- CP-element group 99:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 99: predecessors 
    -- CP-element group 99: successors 
    -- CP-element group 99: 	101 
    -- CP-element group 99:  members (4) 
      -- CP-element group 99: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Sample/$entry
      -- CP-element group 99: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Sample/req
      -- CP-element group 99: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_sample_start_
      -- CP-element group 99: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_sample_start__ps
      -- 
    req_2392_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2392_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(99), ack => next_dest_add_1025_920_buf_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(99) is bound as output of CP function.
    -- CP-element group 100:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 100: predecessors 
    -- CP-element group 100: successors 
    -- CP-element group 100: 	102 
    -- CP-element group 100:  members (4) 
      -- CP-element group 100: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Update/$entry
      -- CP-element group 100: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_update_start_
      -- CP-element group 100: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_update_start__ps
      -- CP-element group 100: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Update/req
      -- 
    req_2397_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2397_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(100), ack => next_dest_add_1025_920_buf_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(100) is bound as output of CP function.
    -- CP-element group 101:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 101: predecessors 
    -- CP-element group 101: 	99 
    -- CP-element group 101: successors 
    -- CP-element group 101:  members (4) 
      -- CP-element group 101: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Sample/ack
      -- CP-element group 101: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Sample/$exit
      -- CP-element group 101: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_sample_completed_
      -- CP-element group 101: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_sample_completed__ps
      -- 
    ack_2393_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 101_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_dest_add_1025_920_buf_ack_0, ack => zeropad3D_A_CP_2082_elements(101)); -- 
    -- CP-element group 102:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 102: predecessors 
    -- CP-element group 102: 	100 
    -- CP-element group 102: successors 
    -- CP-element group 102:  members (4) 
      -- CP-element group 102: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Update/$exit
      -- CP-element group 102: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_update_completed_
      -- CP-element group 102: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_update_completed__ps
      -- CP-element group 102: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_dest_add_920_Update/ack
      -- 
    ack_2398_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 102_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_dest_add_1025_920_buf_ack_1, ack => zeropad3D_A_CP_2082_elements(102)); -- 
    -- CP-element group 103:  join  transition  bypass  pipeline-parent 
    -- CP-element group 103: predecessors 
    -- CP-element group 103: 	23 
    -- CP-element group 103: marked-predecessors 
    -- CP-element group 103: 	26 
    -- CP-element group 103: successors 
    -- CP-element group 103: 	25 
    -- CP-element group 103:  members (1) 
      -- CP-element group 103: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_sample_start_
      -- 
    zeropad3D_A_cp_element_group_103: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_103"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_103 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(103), clk => clk, reset => reset); --
    end block;
    -- CP-element group 104:  join  transition  bypass  pipeline-parent 
    -- CP-element group 104: predecessors 
    -- CP-element group 104: 	23 
    -- CP-element group 104: marked-predecessors 
    -- CP-element group 104: 	133 
    -- CP-element group 104: successors 
    -- CP-element group 104: 	27 
    -- CP-element group 104:  members (1) 
      -- CP-element group 104: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_update_start_
      -- 
    zeropad3D_A_cp_element_group_104: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_104"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(133);
      gj_zeropad3D_A_cp_element_group_104 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(104), clk => clk, reset => reset); --
    end block;
    -- CP-element group 105:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 105: predecessors 
    -- CP-element group 105: 	25 
    -- CP-element group 105: successors 
    -- CP-element group 105:  members (1) 
      -- CP-element group 105: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_sample_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(105) <= zeropad3D_A_CP_2082_elements(25);
    -- CP-element group 106:  join  transition  bypass  pipeline-parent 
    -- CP-element group 106: predecessors 
    -- CP-element group 106: successors 
    -- CP-element group 106: 	26 
    -- CP-element group 106:  members (1) 
      -- CP-element group 106: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_sample_completed__ps
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(106) is bound as output of CP function.
    -- CP-element group 107:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 107: predecessors 
    -- CP-element group 107: 	27 
    -- CP-element group 107: successors 
    -- CP-element group 107:  members (1) 
      -- CP-element group 107: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_update_start__ps
      -- 
    zeropad3D_A_CP_2082_elements(107) <= zeropad3D_A_CP_2082_elements(27);
    -- CP-element group 108:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 108: predecessors 
    -- CP-element group 108: successors 
    -- CP-element group 108: 	133 
    -- CP-element group 108: 	28 
    -- CP-element group 108:  members (15) 
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_update_completed__ps
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_update_completed_
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_resized_1
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_scaled_1
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_computed_1
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_resize_1/$entry
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_resize_1/$exit
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_resize_1/index_resize_req
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_resize_1/index_resize_ack
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_scale_1/$entry
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_scale_1/$exit
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_scale_1/scale_rename_req
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_index_scale_1/scale_rename_ack
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Sample/$entry
      -- CP-element group 108: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Sample/req
      -- 
    req_2496_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2496_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(108), ack => array_obj_ref_1036_index_offset_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(108) is bound as output of CP function.
    -- CP-element group 109:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 109: predecessors 
    -- CP-element group 109: 	21 
    -- CP-element group 109: successors 
    -- CP-element group 109:  members (1) 
      -- CP-element group 109: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_loopback_trigger
      -- 
    zeropad3D_A_CP_2082_elements(109) <= zeropad3D_A_CP_2082_elements(21);
    -- CP-element group 110:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 110: predecessors 
    -- CP-element group 110: successors 
    -- CP-element group 110:  members (2) 
      -- CP-element group 110: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_loopback_sample_req
      -- CP-element group 110: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_loopback_sample_req_ps
      -- 
    phi_stmt_921_loopback_sample_req_2409_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_921_loopback_sample_req_2409_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(110), ack => phi_stmt_921_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(110) is bound as output of CP function.
    -- CP-element group 111:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 111: predecessors 
    -- CP-element group 111: 	22 
    -- CP-element group 111: successors 
    -- CP-element group 111:  members (1) 
      -- CP-element group 111: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_entry_trigger
      -- 
    zeropad3D_A_CP_2082_elements(111) <= zeropad3D_A_CP_2082_elements(22);
    -- CP-element group 112:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 112: predecessors 
    -- CP-element group 112: successors 
    -- CP-element group 112:  members (2) 
      -- CP-element group 112: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_entry_sample_req
      -- CP-element group 112: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_entry_sample_req_ps
      -- 
    phi_stmt_921_entry_sample_req_2412_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_921_entry_sample_req_2412_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(112), ack => phi_stmt_921_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(112) is bound as output of CP function.
    -- CP-element group 113:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 113: predecessors 
    -- CP-element group 113: successors 
    -- CP-element group 113:  members (2) 
      -- CP-element group 113: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_phi_mux_ack
      -- CP-element group 113: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/phi_stmt_921_phi_mux_ack_ps
      -- 
    phi_stmt_921_phi_mux_ack_2415_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 113_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_921_ack_0, ack => zeropad3D_A_CP_2082_elements(113)); -- 
    -- CP-element group 114:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 114: predecessors 
    -- CP-element group 114: successors 
    -- CP-element group 114:  members (4) 
      -- CP-element group 114: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_sample_start__ps
      -- CP-element group 114: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_sample_completed__ps
      -- CP-element group 114: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_sample_start_
      -- CP-element group 114: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_sample_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(114) is bound as output of CP function.
    -- CP-element group 115:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 115: predecessors 
    -- CP-element group 115: successors 
    -- CP-element group 115: 	117 
    -- CP-element group 115:  members (2) 
      -- CP-element group 115: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_update_start__ps
      -- CP-element group 115: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_update_start_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(115) is bound as output of CP function.
    -- CP-element group 116:  join  transition  bypass  pipeline-parent 
    -- CP-element group 116: predecessors 
    -- CP-element group 116: 	117 
    -- CP-element group 116: successors 
    -- CP-element group 116:  members (1) 
      -- CP-element group 116: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_update_completed__ps
      -- 
    zeropad3D_A_CP_2082_elements(116) <= zeropad3D_A_CP_2082_elements(117);
    -- CP-element group 117:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 117: predecessors 
    -- CP-element group 117: 	115 
    -- CP-element group 117: successors 
    -- CP-element group 117: 	116 
    -- CP-element group 117:  members (1) 
      -- CP-element group 117: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_src_add_init_923_update_completed_
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(117) is a control-delay.
    cp_element_117_delay: control_delay_element  generic map(name => " 117_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(115), ack => zeropad3D_A_CP_2082_elements(117), clk => clk, reset =>reset);
    -- CP-element group 118:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 118: predecessors 
    -- CP-element group 118: successors 
    -- CP-element group 118: 	120 
    -- CP-element group 118:  members (4) 
      -- CP-element group 118: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_sample_start__ps
      -- CP-element group 118: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_sample_start_
      -- CP-element group 118: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Sample/$entry
      -- CP-element group 118: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Sample/req
      -- 
    req_2436_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2436_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(118), ack => next_src_add_1030_924_buf_req_0); -- 
    -- Element group zeropad3D_A_CP_2082_elements(118) is bound as output of CP function.
    -- CP-element group 119:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 119: predecessors 
    -- CP-element group 119: successors 
    -- CP-element group 119: 	121 
    -- CP-element group 119:  members (4) 
      -- CP-element group 119: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_update_start__ps
      -- CP-element group 119: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_update_start_
      -- CP-element group 119: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Update/$entry
      -- CP-element group 119: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Update/req
      -- 
    req_2441_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2441_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(119), ack => next_src_add_1030_924_buf_req_1); -- 
    -- Element group zeropad3D_A_CP_2082_elements(119) is bound as output of CP function.
    -- CP-element group 120:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 120: predecessors 
    -- CP-element group 120: 	118 
    -- CP-element group 120: successors 
    -- CP-element group 120:  members (4) 
      -- CP-element group 120: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_sample_completed__ps
      -- CP-element group 120: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_sample_completed_
      -- CP-element group 120: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Sample/$exit
      -- CP-element group 120: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Sample/ack
      -- 
    ack_2437_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 120_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_src_add_1030_924_buf_ack_0, ack => zeropad3D_A_CP_2082_elements(120)); -- 
    -- CP-element group 121:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 121: predecessors 
    -- CP-element group 121: 	119 
    -- CP-element group 121: successors 
    -- CP-element group 121:  members (4) 
      -- CP-element group 121: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_update_completed__ps
      -- CP-element group 121: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_update_completed_
      -- CP-element group 121: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Update/$exit
      -- CP-element group 121: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/R_next_src_add_924_Update/ack
      -- 
    ack_2442_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 121_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_src_add_1030_924_buf_ack_1, ack => zeropad3D_A_CP_2082_elements(121)); -- 
    -- CP-element group 122:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 122: predecessors 
    -- CP-element group 122: 	23 
    -- CP-element group 122: marked-predecessors 
    -- CP-element group 122: 	124 
    -- CP-element group 122: successors 
    -- CP-element group 122: 	124 
    -- CP-element group 122:  members (3) 
      -- CP-element group 122: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_sample_start_
      -- CP-element group 122: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Sample/$entry
      -- CP-element group 122: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Sample/rr
      -- 
    rr_2451_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2451_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(122), ack => ADD_u16_u16_989_inst_req_0); -- 
    zeropad3D_A_cp_element_group_122: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_122"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(124);
      gj_zeropad3D_A_cp_element_group_122 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(122), clk => clk, reset => reset); --
    end block;
    -- CP-element group 123:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 123: predecessors 
    -- CP-element group 123: marked-predecessors 
    -- CP-element group 123: 	154 
    -- CP-element group 123: successors 
    -- CP-element group 123: 	125 
    -- CP-element group 123:  members (3) 
      -- CP-element group 123: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_update_start_
      -- CP-element group 123: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Update/$entry
      -- CP-element group 123: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Update/cr
      -- 
    cr_2456_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2456_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(123), ack => ADD_u16_u16_989_inst_req_1); -- 
    zeropad3D_A_cp_element_group_123: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_123"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(154);
      gj_zeropad3D_A_cp_element_group_123 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(123), clk => clk, reset => reset); --
    end block;
    -- CP-element group 124:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 124: predecessors 
    -- CP-element group 124: 	122 
    -- CP-element group 124: successors 
    -- CP-element group 124: marked-successors 
    -- CP-element group 124: 	122 
    -- CP-element group 124:  members (3) 
      -- CP-element group 124: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_sample_completed_
      -- CP-element group 124: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Sample/$exit
      -- CP-element group 124: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Sample/ra
      -- 
    ra_2452_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 124_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_989_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(124)); -- 
    -- CP-element group 125:  transition  input  bypass  pipeline-parent 
    -- CP-element group 125: predecessors 
    -- CP-element group 125: 	123 
    -- CP-element group 125: successors 
    -- CP-element group 125: 	152 
    -- CP-element group 125:  members (3) 
      -- CP-element group 125: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_update_completed_
      -- CP-element group 125: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Update/$exit
      -- CP-element group 125: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_989_Update/ca
      -- 
    ca_2457_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 125_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_989_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(125)); -- 
    -- CP-element group 126:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 126: predecessors 
    -- CP-element group 126: 	23 
    -- CP-element group 126: marked-predecessors 
    -- CP-element group 126: 	128 
    -- CP-element group 126: successors 
    -- CP-element group 126: 	128 
    -- CP-element group 126:  members (3) 
      -- CP-element group 126: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_sample_start_
      -- CP-element group 126: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Sample/$entry
      -- CP-element group 126: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Sample/rr
      -- 
    rr_2465_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2465_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(126), ack => ADD_u16_u16_999_inst_req_0); -- 
    zeropad3D_A_cp_element_group_126: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_126"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(128);
      gj_zeropad3D_A_cp_element_group_126 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(126), clk => clk, reset => reset); --
    end block;
    -- CP-element group 127:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 127: predecessors 
    -- CP-element group 127: marked-predecessors 
    -- CP-element group 127: 	154 
    -- CP-element group 127: successors 
    -- CP-element group 127: 	129 
    -- CP-element group 127:  members (3) 
      -- CP-element group 127: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_update_start_
      -- CP-element group 127: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Update/$entry
      -- CP-element group 127: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Update/cr
      -- 
    cr_2470_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2470_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(127), ack => ADD_u16_u16_999_inst_req_1); -- 
    zeropad3D_A_cp_element_group_127: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_127"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(154);
      gj_zeropad3D_A_cp_element_group_127 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(127), clk => clk, reset => reset); --
    end block;
    -- CP-element group 128:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 128: predecessors 
    -- CP-element group 128: 	126 
    -- CP-element group 128: successors 
    -- CP-element group 128: marked-successors 
    -- CP-element group 128: 	126 
    -- CP-element group 128:  members (3) 
      -- CP-element group 128: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_sample_completed_
      -- CP-element group 128: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Sample/$exit
      -- CP-element group 128: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Sample/ra
      -- 
    ra_2466_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 128_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_999_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(128)); -- 
    -- CP-element group 129:  transition  input  bypass  pipeline-parent 
    -- CP-element group 129: predecessors 
    -- CP-element group 129: 	127 
    -- CP-element group 129: successors 
    -- CP-element group 129: 	152 
    -- CP-element group 129:  members (3) 
      -- CP-element group 129: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_update_completed_
      -- CP-element group 129: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Update/$exit
      -- CP-element group 129: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ADD_u16_u16_999_Update/ca
      -- 
    ca_2471_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 129_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_999_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(129)); -- 
    -- CP-element group 130:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 130: predecessors 
    -- CP-element group 130: 	134 
    -- CP-element group 130: marked-predecessors 
    -- CP-element group 130: 	135 
    -- CP-element group 130: successors 
    -- CP-element group 130: 	135 
    -- CP-element group 130:  members (3) 
      -- CP-element group 130: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_sample_start_
      -- CP-element group 130: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_request/$entry
      -- CP-element group 130: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_request/req
      -- 
    req_2511_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2511_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(130), ack => addr_of_1037_final_reg_req_0); -- 
    zeropad3D_A_cp_element_group_130: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_130"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(134) & zeropad3D_A_CP_2082_elements(135);
      gj_zeropad3D_A_cp_element_group_130 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(130), clk => clk, reset => reset); --
    end block;
    -- CP-element group 131:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 131: predecessors 
    -- CP-element group 131: 	23 
    -- CP-element group 131: marked-predecessors 
    -- CP-element group 131: 	139 
    -- CP-element group 131: successors 
    -- CP-element group 131: 	136 
    -- CP-element group 131:  members (3) 
      -- CP-element group 131: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_update_start_
      -- CP-element group 131: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_complete/$entry
      -- CP-element group 131: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_complete/req
      -- 
    req_2516_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2516_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(131), ack => addr_of_1037_final_reg_req_1); -- 
    zeropad3D_A_cp_element_group_131: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_131"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(139);
      gj_zeropad3D_A_cp_element_group_131 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(131), clk => clk, reset => reset); --
    end block;
    -- CP-element group 132:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 132: predecessors 
    -- CP-element group 132: 	23 
    -- CP-element group 132: marked-predecessors 
    -- CP-element group 132: 	135 
    -- CP-element group 132: successors 
    -- CP-element group 132: 	134 
    -- CP-element group 132:  members (3) 
      -- CP-element group 132: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_update_start
      -- CP-element group 132: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Update/$entry
      -- CP-element group 132: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Update/req
      -- 
    req_2501_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2501_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(132), ack => array_obj_ref_1036_index_offset_req_1); -- 
    zeropad3D_A_cp_element_group_132: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_132"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(135);
      gj_zeropad3D_A_cp_element_group_132 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(132), clk => clk, reset => reset); --
    end block;
    -- CP-element group 133:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 133: predecessors 
    -- CP-element group 133: 	108 
    -- CP-element group 133: successors 
    -- CP-element group 133: 	177 
    -- CP-element group 133: marked-successors 
    -- CP-element group 133: 	104 
    -- CP-element group 133:  members (3) 
      -- CP-element group 133: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_sample_complete
      -- CP-element group 133: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Sample/$exit
      -- CP-element group 133: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Sample/ack
      -- 
    ack_2497_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 133_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1036_index_offset_ack_0, ack => zeropad3D_A_CP_2082_elements(133)); -- 
    -- CP-element group 134:  transition  input  bypass  pipeline-parent 
    -- CP-element group 134: predecessors 
    -- CP-element group 134: 	132 
    -- CP-element group 134: successors 
    -- CP-element group 134: 	130 
    -- CP-element group 134:  members (8) 
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_root_address_calculated
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_offset_calculated
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Update/$exit
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_final_index_sum_regn_Update/ack
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_base_plus_offset/$entry
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_base_plus_offset/$exit
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_base_plus_offset/sum_rename_req
      -- CP-element group 134: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1036_base_plus_offset/sum_rename_ack
      -- 
    ack_2502_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 134_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1036_index_offset_ack_1, ack => zeropad3D_A_CP_2082_elements(134)); -- 
    -- CP-element group 135:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 135: predecessors 
    -- CP-element group 135: 	130 
    -- CP-element group 135: successors 
    -- CP-element group 135: marked-successors 
    -- CP-element group 135: 	130 
    -- CP-element group 135: 	132 
    -- CP-element group 135:  members (3) 
      -- CP-element group 135: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_sample_completed_
      -- CP-element group 135: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_request/$exit
      -- CP-element group 135: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_request/ack
      -- 
    ack_2512_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 135_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1037_final_reg_ack_0, ack => zeropad3D_A_CP_2082_elements(135)); -- 
    -- CP-element group 136:  transition  input  bypass  pipeline-parent 
    -- CP-element group 136: predecessors 
    -- CP-element group 136: 	131 
    -- CP-element group 136: successors 
    -- CP-element group 136: 	137 
    -- CP-element group 136:  members (19) 
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_update_completed_
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_complete/$exit
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1037_complete/ack
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_address_calculated
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_word_address_calculated
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_root_address_calculated
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_address_resized
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_addr_resize/$entry
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_addr_resize/$exit
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_addr_resize/base_resize_req
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_addr_resize/base_resize_ack
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_plus_offset/$entry
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_plus_offset/$exit
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_plus_offset/sum_rename_req
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_base_plus_offset/sum_rename_ack
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_word_addrgen/$entry
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_word_addrgen/$exit
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_word_addrgen/root_register_req
      -- CP-element group 136: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_word_addrgen/root_register_ack
      -- 
    ack_2517_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 136_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1037_final_reg_ack_1, ack => zeropad3D_A_CP_2082_elements(136)); -- 
    -- CP-element group 137:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 137: predecessors 
    -- CP-element group 137: 	136 
    -- CP-element group 137: marked-predecessors 
    -- CP-element group 137: 	139 
    -- CP-element group 137: successors 
    -- CP-element group 137: 	139 
    -- CP-element group 137:  members (5) 
      -- CP-element group 137: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_sample_start_
      -- CP-element group 137: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/$entry
      -- CP-element group 137: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/$entry
      -- CP-element group 137: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/word_0/$entry
      -- CP-element group 137: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/word_0/rr
      -- 
    rr_2550_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2550_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(137), ack => ptr_deref_1041_load_0_req_0); -- 
    zeropad3D_A_cp_element_group_137: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_137"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(136) & zeropad3D_A_CP_2082_elements(139);
      gj_zeropad3D_A_cp_element_group_137 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(137), clk => clk, reset => reset); --
    end block;
    -- CP-element group 138:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 138: predecessors 
    -- CP-element group 138: marked-predecessors 
    -- CP-element group 138: 	158 
    -- CP-element group 138: successors 
    -- CP-element group 138: 	140 
    -- CP-element group 138:  members (5) 
      -- CP-element group 138: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_update_start_
      -- CP-element group 138: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/$entry
      -- CP-element group 138: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/$entry
      -- CP-element group 138: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/word_0/$entry
      -- CP-element group 138: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/word_0/cr
      -- 
    cr_2561_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2561_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(138), ack => ptr_deref_1041_load_0_req_1); -- 
    zeropad3D_A_cp_element_group_138: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_138"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(158);
      gj_zeropad3D_A_cp_element_group_138 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(138), clk => clk, reset => reset); --
    end block;
    -- CP-element group 139:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 139: predecessors 
    -- CP-element group 139: 	137 
    -- CP-element group 139: successors 
    -- CP-element group 139: marked-successors 
    -- CP-element group 139: 	137 
    -- CP-element group 139: 	131 
    -- CP-element group 139:  members (5) 
      -- CP-element group 139: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_sample_completed_
      -- CP-element group 139: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/$exit
      -- CP-element group 139: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/$exit
      -- CP-element group 139: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/word_0/$exit
      -- CP-element group 139: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Sample/word_access_start/word_0/ra
      -- 
    ra_2551_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 139_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1041_load_0_ack_0, ack => zeropad3D_A_CP_2082_elements(139)); -- 
    -- CP-element group 140:  transition  input  bypass  pipeline-parent 
    -- CP-element group 140: predecessors 
    -- CP-element group 140: 	138 
    -- CP-element group 140: successors 
    -- CP-element group 140: 	156 
    -- CP-element group 140:  members (9) 
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_update_completed_
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/$exit
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/$exit
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/word_0/$exit
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/word_access_complete/word_0/ca
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/ptr_deref_1041_Merge/$entry
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/ptr_deref_1041_Merge/$exit
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/ptr_deref_1041_Merge/merge_req
      -- CP-element group 140: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1041_Update/ptr_deref_1041_Merge/merge_ack
      -- 
    ca_2562_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 140_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1041_load_0_ack_1, ack => zeropad3D_A_CP_2082_elements(140)); -- 
    -- CP-element group 141:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 141: predecessors 
    -- CP-element group 141: 	145 
    -- CP-element group 141: marked-predecessors 
    -- CP-element group 141: 	146 
    -- CP-element group 141: successors 
    -- CP-element group 141: 	146 
    -- CP-element group 141:  members (3) 
      -- CP-element group 141: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_sample_start_
      -- CP-element group 141: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_request/$entry
      -- CP-element group 141: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_request/req
      -- 
    req_2607_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2607_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(141), ack => addr_of_1049_final_reg_req_0); -- 
    zeropad3D_A_cp_element_group_141: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_141"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(145) & zeropad3D_A_CP_2082_elements(146);
      gj_zeropad3D_A_cp_element_group_141 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(141), clk => clk, reset => reset); --
    end block;
    -- CP-element group 142:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 142: predecessors 
    -- CP-element group 142: 	23 
    -- CP-element group 142: marked-predecessors 
    -- CP-element group 142: 	150 
    -- CP-element group 142: successors 
    -- CP-element group 142: 	147 
    -- CP-element group 142:  members (3) 
      -- CP-element group 142: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_update_start_
      -- CP-element group 142: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_complete/$entry
      -- CP-element group 142: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_complete/req
      -- 
    req_2612_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2612_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(142), ack => addr_of_1049_final_reg_req_1); -- 
    zeropad3D_A_cp_element_group_142: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_142"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(150);
      gj_zeropad3D_A_cp_element_group_142 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(142), clk => clk, reset => reset); --
    end block;
    -- CP-element group 143:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 143: predecessors 
    -- CP-element group 143: 	23 
    -- CP-element group 143: marked-predecessors 
    -- CP-element group 143: 	146 
    -- CP-element group 143: successors 
    -- CP-element group 143: 	145 
    -- CP-element group 143:  members (3) 
      -- CP-element group 143: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_update_start
      -- CP-element group 143: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Update/$entry
      -- CP-element group 143: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Update/req
      -- 
    req_2597_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2597_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(143), ack => array_obj_ref_1048_index_offset_req_1); -- 
    zeropad3D_A_cp_element_group_143: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_143"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(146);
      gj_zeropad3D_A_cp_element_group_143 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(143), clk => clk, reset => reset); --
    end block;
    -- CP-element group 144:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 144: predecessors 
    -- CP-element group 144: 	89 
    -- CP-element group 144: successors 
    -- CP-element group 144: 	177 
    -- CP-element group 144: marked-successors 
    -- CP-element group 144: 	85 
    -- CP-element group 144:  members (3) 
      -- CP-element group 144: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_sample_complete
      -- CP-element group 144: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Sample/$exit
      -- CP-element group 144: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Sample/ack
      -- 
    ack_2593_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 144_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1048_index_offset_ack_0, ack => zeropad3D_A_CP_2082_elements(144)); -- 
    -- CP-element group 145:  transition  input  bypass  pipeline-parent 
    -- CP-element group 145: predecessors 
    -- CP-element group 145: 	143 
    -- CP-element group 145: successors 
    -- CP-element group 145: 	141 
    -- CP-element group 145:  members (8) 
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_root_address_calculated
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_offset_calculated
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Update/$exit
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_final_index_sum_regn_Update/ack
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_base_plus_offset/$entry
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_base_plus_offset/$exit
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_base_plus_offset/sum_rename_req
      -- CP-element group 145: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/array_obj_ref_1048_base_plus_offset/sum_rename_ack
      -- 
    ack_2598_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 145_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1048_index_offset_ack_1, ack => zeropad3D_A_CP_2082_elements(145)); -- 
    -- CP-element group 146:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 146: predecessors 
    -- CP-element group 146: 	141 
    -- CP-element group 146: successors 
    -- CP-element group 146: marked-successors 
    -- CP-element group 146: 	143 
    -- CP-element group 146: 	141 
    -- CP-element group 146:  members (3) 
      -- CP-element group 146: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_sample_completed_
      -- CP-element group 146: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_request/$exit
      -- CP-element group 146: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_request/ack
      -- 
    ack_2608_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 146_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1049_final_reg_ack_0, ack => zeropad3D_A_CP_2082_elements(146)); -- 
    -- CP-element group 147:  transition  input  bypass  pipeline-parent 
    -- CP-element group 147: predecessors 
    -- CP-element group 147: 	142 
    -- CP-element group 147: successors 
    -- CP-element group 147: 	148 
    -- CP-element group 147:  members (3) 
      -- CP-element group 147: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_update_completed_
      -- CP-element group 147: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_complete/$exit
      -- CP-element group 147: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/addr_of_1049_complete/ack
      -- 
    ack_2613_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 147_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1049_final_reg_ack_1, ack => zeropad3D_A_CP_2082_elements(147)); -- 
    -- CP-element group 148:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 148: predecessors 
    -- CP-element group 148: 	147 
    -- CP-element group 148: marked-predecessors 
    -- CP-element group 148: 	150 
    -- CP-element group 148: successors 
    -- CP-element group 148: 	150 
    -- CP-element group 148:  members (3) 
      -- CP-element group 148: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_sample_start_
      -- CP-element group 148: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Sample/$entry
      -- CP-element group 148: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Sample/req
      -- 
    req_2621_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2621_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(148), ack => W_ov_1045_delayed_7_0_1051_inst_req_0); -- 
    zeropad3D_A_cp_element_group_148: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_148"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(147) & zeropad3D_A_CP_2082_elements(150);
      gj_zeropad3D_A_cp_element_group_148 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(148), clk => clk, reset => reset); --
    end block;
    -- CP-element group 149:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 149: predecessors 
    -- CP-element group 149: marked-predecessors 
    -- CP-element group 149: 	162 
    -- CP-element group 149: successors 
    -- CP-element group 149: 	151 
    -- CP-element group 149:  members (3) 
      -- CP-element group 149: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_update_start_
      -- CP-element group 149: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Update/$entry
      -- CP-element group 149: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Update/req
      -- 
    req_2626_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2626_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(149), ack => W_ov_1045_delayed_7_0_1051_inst_req_1); -- 
    zeropad3D_A_cp_element_group_149: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_149"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(162);
      gj_zeropad3D_A_cp_element_group_149 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(149), clk => clk, reset => reset); --
    end block;
    -- CP-element group 150:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 150: predecessors 
    -- CP-element group 150: 	148 
    -- CP-element group 150: successors 
    -- CP-element group 150: marked-successors 
    -- CP-element group 150: 	148 
    -- CP-element group 150: 	142 
    -- CP-element group 150:  members (3) 
      -- CP-element group 150: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_sample_completed_
      -- CP-element group 150: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Sample/$exit
      -- CP-element group 150: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Sample/ack
      -- 
    ack_2622_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 150_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_ov_1045_delayed_7_0_1051_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(150)); -- 
    -- CP-element group 151:  transition  input  bypass  pipeline-parent 
    -- CP-element group 151: predecessors 
    -- CP-element group 151: 	149 
    -- CP-element group 151: successors 
    -- CP-element group 151: 	160 
    -- CP-element group 151:  members (19) 
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_update_completed_
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Update/$exit
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1053_Update/ack
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_address_calculated
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_word_address_calculated
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_root_address_calculated
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_address_resized
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_addr_resize/$entry
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_addr_resize/$exit
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_addr_resize/base_resize_req
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_addr_resize/base_resize_ack
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_plus_offset/$entry
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_plus_offset/$exit
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_plus_offset/sum_rename_req
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_base_plus_offset/sum_rename_ack
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_word_addrgen/$entry
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_word_addrgen/$exit
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_word_addrgen/root_register_req
      -- CP-element group 151: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_word_addrgen/root_register_ack
      -- 
    ack_2627_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 151_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_ov_1045_delayed_7_0_1051_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(151)); -- 
    -- CP-element group 152:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 152: predecessors 
    -- CP-element group 152: 	129 
    -- CP-element group 152: 	125 
    -- CP-element group 152: 	51 
    -- CP-element group 152: 	70 
    -- CP-element group 152: marked-predecessors 
    -- CP-element group 152: 	154 
    -- CP-element group 152: successors 
    -- CP-element group 152: 	154 
    -- CP-element group 152:  members (3) 
      -- CP-element group 152: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_sample_start_
      -- CP-element group 152: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Sample/$entry
      -- CP-element group 152: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Sample/req
      -- 
    req_2635_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2635_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(152), ack => W_data_check_1047_delayed_13_0_1054_inst_req_0); -- 
    zeropad3D_A_cp_element_group_152: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 1,1 => 1,2 => 15,3 => 15,4 => 1);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 1);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_152"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(129) & zeropad3D_A_CP_2082_elements(125) & zeropad3D_A_CP_2082_elements(51) & zeropad3D_A_CP_2082_elements(70) & zeropad3D_A_CP_2082_elements(154);
      gj_zeropad3D_A_cp_element_group_152 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(152), clk => clk, reset => reset); --
    end block;
    -- CP-element group 153:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 153: predecessors 
    -- CP-element group 153: marked-predecessors 
    -- CP-element group 153: 	158 
    -- CP-element group 153: successors 
    -- CP-element group 153: 	155 
    -- CP-element group 153:  members (3) 
      -- CP-element group 153: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_update_start_
      -- CP-element group 153: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Update/$entry
      -- CP-element group 153: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Update/req
      -- 
    req_2640_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2640_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(153), ack => W_data_check_1047_delayed_13_0_1054_inst_req_1); -- 
    zeropad3D_A_cp_element_group_153: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_153"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(158);
      gj_zeropad3D_A_cp_element_group_153 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(153), clk => clk, reset => reset); --
    end block;
    -- CP-element group 154:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 154: predecessors 
    -- CP-element group 154: 	152 
    -- CP-element group 154: successors 
    -- CP-element group 154: marked-successors 
    -- CP-element group 154: 	127 
    -- CP-element group 154: 	152 
    -- CP-element group 154: 	123 
    -- CP-element group 154: 	47 
    -- CP-element group 154: 	66 
    -- CP-element group 154:  members (3) 
      -- CP-element group 154: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_sample_completed_
      -- CP-element group 154: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Sample/$exit
      -- CP-element group 154: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Sample/ack
      -- 
    ack_2636_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 154_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_data_check_1047_delayed_13_0_1054_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(154)); -- 
    -- CP-element group 155:  transition  input  bypass  pipeline-parent 
    -- CP-element group 155: predecessors 
    -- CP-element group 155: 	153 
    -- CP-element group 155: successors 
    -- CP-element group 155: 	156 
    -- CP-element group 155:  members (3) 
      -- CP-element group 155: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_update_completed_
      -- CP-element group 155: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Update/$exit
      -- CP-element group 155: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1056_Update/ack
      -- 
    ack_2641_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 155_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_data_check_1047_delayed_13_0_1054_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(155)); -- 
    -- CP-element group 156:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 156: predecessors 
    -- CP-element group 156: 	140 
    -- CP-element group 156: 	155 
    -- CP-element group 156: marked-predecessors 
    -- CP-element group 156: 	158 
    -- CP-element group 156: successors 
    -- CP-element group 156: 	158 
    -- CP-element group 156:  members (3) 
      -- CP-element group 156: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_sample_start_
      -- CP-element group 156: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_start/$entry
      -- CP-element group 156: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_start/req
      -- 
    req_2649_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2649_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(156), ack => MUX_1063_inst_req_0); -- 
    zeropad3D_A_cp_element_group_156: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_156"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(140) & zeropad3D_A_CP_2082_elements(155) & zeropad3D_A_CP_2082_elements(158);
      gj_zeropad3D_A_cp_element_group_156 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(156), clk => clk, reset => reset); --
    end block;
    -- CP-element group 157:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 157: predecessors 
    -- CP-element group 157: marked-predecessors 
    -- CP-element group 157: 	162 
    -- CP-element group 157: successors 
    -- CP-element group 157: 	159 
    -- CP-element group 157:  members (3) 
      -- CP-element group 157: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_update_start_
      -- CP-element group 157: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_complete/$entry
      -- CP-element group 157: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_complete/req
      -- 
    req_2654_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2654_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(157), ack => MUX_1063_inst_req_1); -- 
    zeropad3D_A_cp_element_group_157: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_157"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(162);
      gj_zeropad3D_A_cp_element_group_157 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(157), clk => clk, reset => reset); --
    end block;
    -- CP-element group 158:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 158: predecessors 
    -- CP-element group 158: 	156 
    -- CP-element group 158: successors 
    -- CP-element group 158: marked-successors 
    -- CP-element group 158: 	138 
    -- CP-element group 158: 	153 
    -- CP-element group 158: 	156 
    -- CP-element group 158:  members (3) 
      -- CP-element group 158: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_sample_completed_
      -- CP-element group 158: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_start/$exit
      -- CP-element group 158: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_start/ack
      -- 
    ack_2650_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 158_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_1063_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(158)); -- 
    -- CP-element group 159:  transition  input  bypass  pipeline-parent 
    -- CP-element group 159: predecessors 
    -- CP-element group 159: 	157 
    -- CP-element group 159: successors 
    -- CP-element group 159: 	160 
    -- CP-element group 159:  members (3) 
      -- CP-element group 159: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_update_completed_
      -- CP-element group 159: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_complete/$exit
      -- CP-element group 159: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/MUX_1063_complete/ack
      -- 
    ack_2655_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 159_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_1063_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(159)); -- 
    -- CP-element group 160:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 160: predecessors 
    -- CP-element group 160: 	151 
    -- CP-element group 160: 	159 
    -- CP-element group 160: marked-predecessors 
    -- CP-element group 160: 	162 
    -- CP-element group 160: successors 
    -- CP-element group 160: 	162 
    -- CP-element group 160:  members (9) 
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_sample_start_
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/$entry
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/ptr_deref_1058_Split/$entry
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/ptr_deref_1058_Split/$exit
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/ptr_deref_1058_Split/split_req
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/ptr_deref_1058_Split/split_ack
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/$entry
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/word_0/$entry
      -- CP-element group 160: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/word_0/rr
      -- 
    rr_2693_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2693_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(160), ack => ptr_deref_1058_store_0_req_0); -- 
    zeropad3D_A_cp_element_group_160: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_160"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(151) & zeropad3D_A_CP_2082_elements(159) & zeropad3D_A_CP_2082_elements(162);
      gj_zeropad3D_A_cp_element_group_160 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(160), clk => clk, reset => reset); --
    end block;
    -- CP-element group 161:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 161: predecessors 
    -- CP-element group 161: marked-predecessors 
    -- CP-element group 161: 	163 
    -- CP-element group 161: successors 
    -- CP-element group 161: 	163 
    -- CP-element group 161:  members (5) 
      -- CP-element group 161: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_update_start_
      -- CP-element group 161: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/$entry
      -- CP-element group 161: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/$entry
      -- CP-element group 161: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/word_0/$entry
      -- CP-element group 161: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/word_0/cr
      -- 
    cr_2704_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2704_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(161), ack => ptr_deref_1058_store_0_req_1); -- 
    zeropad3D_A_cp_element_group_161: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_161"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(163);
      gj_zeropad3D_A_cp_element_group_161 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(161), clk => clk, reset => reset); --
    end block;
    -- CP-element group 162:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 162: predecessors 
    -- CP-element group 162: 	160 
    -- CP-element group 162: successors 
    -- CP-element group 162: marked-successors 
    -- CP-element group 162: 	149 
    -- CP-element group 162: 	157 
    -- CP-element group 162: 	160 
    -- CP-element group 162:  members (5) 
      -- CP-element group 162: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_sample_completed_
      -- CP-element group 162: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/$exit
      -- CP-element group 162: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/$exit
      -- CP-element group 162: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/word_0/$exit
      -- CP-element group 162: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Sample/word_access_start/word_0/ra
      -- 
    ra_2694_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 162_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1058_store_0_ack_0, ack => zeropad3D_A_CP_2082_elements(162)); -- 
    -- CP-element group 163:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 163: predecessors 
    -- CP-element group 163: 	161 
    -- CP-element group 163: successors 
    -- CP-element group 163: 	177 
    -- CP-element group 163: marked-successors 
    -- CP-element group 163: 	161 
    -- CP-element group 163:  members (5) 
      -- CP-element group 163: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_update_completed_
      -- CP-element group 163: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/$exit
      -- CP-element group 163: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/$exit
      -- CP-element group 163: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/word_0/$exit
      -- CP-element group 163: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/ptr_deref_1058_Update/word_access_complete/word_0/ca
      -- 
    ca_2705_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 163_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1058_store_0_ack_1, ack => zeropad3D_A_CP_2082_elements(163)); -- 
    -- CP-element group 164:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 164: predecessors 
    -- CP-element group 164: 	23 
    -- CP-element group 164: marked-predecessors 
    -- CP-element group 164: 	166 
    -- CP-element group 164: successors 
    -- CP-element group 164: 	166 
    -- CP-element group 164:  members (3) 
      -- CP-element group 164: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_sample_start_
      -- CP-element group 164: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Sample/$entry
      -- CP-element group 164: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Sample/req
      -- 
    req_2713_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2713_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(164), ack => W_dim2T_dif_1060_delayed_1_0_1070_inst_req_0); -- 
    zeropad3D_A_cp_element_group_164: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_164"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(166);
      gj_zeropad3D_A_cp_element_group_164 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(164), clk => clk, reset => reset); --
    end block;
    -- CP-element group 165:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 165: predecessors 
    -- CP-element group 165: 	26 
    -- CP-element group 165: marked-predecessors 
    -- CP-element group 165: 	167 
    -- CP-element group 165: successors 
    -- CP-element group 165: 	167 
    -- CP-element group 165:  members (3) 
      -- CP-element group 165: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_update_start_
      -- CP-element group 165: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Update/$entry
      -- CP-element group 165: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Update/req
      -- 
    req_2718_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2718_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(165), ack => W_dim2T_dif_1060_delayed_1_0_1070_inst_req_1); -- 
    zeropad3D_A_cp_element_group_165: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_165"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(26) & zeropad3D_A_CP_2082_elements(167);
      gj_zeropad3D_A_cp_element_group_165 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(165), clk => clk, reset => reset); --
    end block;
    -- CP-element group 166:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 166: predecessors 
    -- CP-element group 166: 	164 
    -- CP-element group 166: successors 
    -- CP-element group 166: marked-successors 
    -- CP-element group 166: 	164 
    -- CP-element group 166:  members (3) 
      -- CP-element group 166: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_sample_completed_
      -- CP-element group 166: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Sample/$exit
      -- CP-element group 166: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Sample/ack
      -- 
    ack_2714_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 166_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(166)); -- 
    -- CP-element group 167:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 167: predecessors 
    -- CP-element group 167: 	165 
    -- CP-element group 167: successors 
    -- CP-element group 167: 	24 
    -- CP-element group 167: marked-successors 
    -- CP-element group 167: 	165 
    -- CP-element group 167: 	29 
    -- CP-element group 167: 	46 
    -- CP-element group 167: 	65 
    -- CP-element group 167:  members (3) 
      -- CP-element group 167: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_update_completed_
      -- CP-element group 167: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Update/$exit
      -- CP-element group 167: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1072_Update/ack
      -- 
    ack_2719_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 167_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(167)); -- 
    -- CP-element group 168:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 168: predecessors 
    -- CP-element group 168: 	23 
    -- CP-element group 168: marked-predecessors 
    -- CP-element group 168: 	170 
    -- CP-element group 168: successors 
    -- CP-element group 168: 	170 
    -- CP-element group 168:  members (3) 
      -- CP-element group 168: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_sample_start_
      -- CP-element group 168: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Sample/$entry
      -- CP-element group 168: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Sample/req
      -- 
    req_2727_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2727_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(168), ack => W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_0); -- 
    zeropad3D_A_cp_element_group_168: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_168"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(170);
      gj_zeropad3D_A_cp_element_group_168 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(168), clk => clk, reset => reset); --
    end block;
    -- CP-element group 169:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 169: predecessors 
    -- CP-element group 169: 	26 
    -- CP-element group 169: marked-predecessors 
    -- CP-element group 169: 	171 
    -- CP-element group 169: successors 
    -- CP-element group 169: 	171 
    -- CP-element group 169:  members (3) 
      -- CP-element group 169: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_update_start_
      -- CP-element group 169: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Update/$entry
      -- CP-element group 169: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Update/req
      -- 
    req_2732_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2732_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(169), ack => W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_1); -- 
    zeropad3D_A_cp_element_group_169: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_169"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(26) & zeropad3D_A_CP_2082_elements(171);
      gj_zeropad3D_A_cp_element_group_169 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(169), clk => clk, reset => reset); --
    end block;
    -- CP-element group 170:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 170: predecessors 
    -- CP-element group 170: 	168 
    -- CP-element group 170: successors 
    -- CP-element group 170: marked-successors 
    -- CP-element group 170: 	168 
    -- CP-element group 170:  members (3) 
      -- CP-element group 170: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_sample_completed_
      -- CP-element group 170: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Sample/$exit
      -- CP-element group 170: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Sample/ack
      -- 
    ack_2728_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 170_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(170)); -- 
    -- CP-element group 171:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 171: predecessors 
    -- CP-element group 171: 	169 
    -- CP-element group 171: successors 
    -- CP-element group 171: 	177 
    -- CP-element group 171: marked-successors 
    -- CP-element group 171: 	169 
    -- CP-element group 171: 	46 
    -- CP-element group 171: 	65 
    -- CP-element group 171:  members (3) 
      -- CP-element group 171: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_update_completed_
      -- CP-element group 171: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Update/$exit
      -- CP-element group 171: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1090_Update/ack
      -- 
    ack_2733_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 171_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(171)); -- 
    -- CP-element group 172:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 172: predecessors 
    -- CP-element group 172: 	23 
    -- CP-element group 172: marked-predecessors 
    -- CP-element group 172: 	174 
    -- CP-element group 172: successors 
    -- CP-element group 172: 	174 
    -- CP-element group 172:  members (3) 
      -- CP-element group 172: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_sample_start_
      -- CP-element group 172: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Sample/$entry
      -- CP-element group 172: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Sample/req
      -- 
    req_2741_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2741_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(172), ack => W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_0); -- 
    zeropad3D_A_cp_element_group_172: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_172"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(23) & zeropad3D_A_CP_2082_elements(174);
      gj_zeropad3D_A_cp_element_group_172 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(172), clk => clk, reset => reset); --
    end block;
    -- CP-element group 173:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 173: predecessors 
    -- CP-element group 173: marked-predecessors 
    -- CP-element group 173: 	175 
    -- CP-element group 173: successors 
    -- CP-element group 173: 	175 
    -- CP-element group 173:  members (3) 
      -- CP-element group 173: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_update_start_
      -- CP-element group 173: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Update/$entry
      -- CP-element group 173: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Update/req
      -- 
    req_2746_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2746_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(173), ack => W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_1); -- 
    zeropad3D_A_cp_element_group_173: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_173"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_A_CP_2082_elements(175);
      gj_zeropad3D_A_cp_element_group_173 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(173), clk => clk, reset => reset); --
    end block;
    -- CP-element group 174:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 174: predecessors 
    -- CP-element group 174: 	172 
    -- CP-element group 174: successors 
    -- CP-element group 174: marked-successors 
    -- CP-element group 174: 	172 
    -- CP-element group 174:  members (3) 
      -- CP-element group 174: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_sample_completed_
      -- CP-element group 174: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Sample/$exit
      -- CP-element group 174: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Sample/ack
      -- 
    ack_2742_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 174_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(174)); -- 
    -- CP-element group 175:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 175: predecessors 
    -- CP-element group 175: 	173 
    -- CP-element group 175: successors 
    -- CP-element group 175: 	24 
    -- CP-element group 175: marked-successors 
    -- CP-element group 175: 	173 
    -- CP-element group 175:  members (3) 
      -- CP-element group 175: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_update_completed_
      -- CP-element group 175: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Update/$exit
      -- CP-element group 175: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/assign_stmt_1114_Update/ack
      -- 
    ack_2747_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 175_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(175)); -- 
    -- CP-element group 176:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 176: predecessors 
    -- CP-element group 176: 	23 
    -- CP-element group 176: successors 
    -- CP-element group 176: 	24 
    -- CP-element group 176:  members (1) 
      -- CP-element group 176: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/loop_body_delay_to_condition_start
      -- 
    -- Element group zeropad3D_A_CP_2082_elements(176) is a control-delay.
    cp_element_176_delay: control_delay_element  generic map(name => " 176_delay", delay_value => 1)  port map(req => zeropad3D_A_CP_2082_elements(23), ack => zeropad3D_A_CP_2082_elements(176), clk => clk, reset =>reset);
    -- CP-element group 177:  join  transition  bypass  pipeline-parent 
    -- CP-element group 177: predecessors 
    -- CP-element group 177: 	133 
    -- CP-element group 177: 	171 
    -- CP-element group 177: 	163 
    -- CP-element group 177: 	144 
    -- CP-element group 177: 	26 
    -- CP-element group 177: successors 
    -- CP-element group 177: 	20 
    -- CP-element group 177:  members (1) 
      -- CP-element group 177: 	 branch_block_stmt_823/do_while_stmt_903/do_while_stmt_903_loop_body/$exit
      -- 
    zeropad3D_A_cp_element_group_177: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 32) := "zeropad3D_A_cp_element_group_177"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_A_CP_2082_elements(133) & zeropad3D_A_CP_2082_elements(171) & zeropad3D_A_CP_2082_elements(163) & zeropad3D_A_CP_2082_elements(144) & zeropad3D_A_CP_2082_elements(26);
      gj_zeropad3D_A_cp_element_group_177 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(177), clk => clk, reset => reset); --
    end block;
    -- CP-element group 178:  transition  input  bypass  pipeline-parent 
    -- CP-element group 178: predecessors 
    -- CP-element group 178: 	19 
    -- CP-element group 178: successors 
    -- CP-element group 178:  members (2) 
      -- CP-element group 178: 	 branch_block_stmt_823/do_while_stmt_903/loop_exit/$exit
      -- CP-element group 178: 	 branch_block_stmt_823/do_while_stmt_903/loop_exit/ack
      -- 
    ack_2752_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 178_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_903_branch_ack_0, ack => zeropad3D_A_CP_2082_elements(178)); -- 
    -- CP-element group 179:  transition  input  bypass  pipeline-parent 
    -- CP-element group 179: predecessors 
    -- CP-element group 179: 	19 
    -- CP-element group 179: successors 
    -- CP-element group 179:  members (2) 
      -- CP-element group 179: 	 branch_block_stmt_823/do_while_stmt_903/loop_taken/$exit
      -- CP-element group 179: 	 branch_block_stmt_823/do_while_stmt_903/loop_taken/ack
      -- 
    ack_2756_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 179_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_903_branch_ack_1, ack => zeropad3D_A_CP_2082_elements(179)); -- 
    -- CP-element group 180:  transition  bypass  pipeline-parent 
    -- CP-element group 180: predecessors 
    -- CP-element group 180: 	17 
    -- CP-element group 180: successors 
    -- CP-element group 180: 	1 
    -- CP-element group 180:  members (1) 
      -- CP-element group 180: 	 branch_block_stmt_823/do_while_stmt_903/$exit
      -- 
    zeropad3D_A_CP_2082_elements(180) <= zeropad3D_A_CP_2082_elements(17);
    -- CP-element group 181:  transition  input  output  bypass 
    -- CP-element group 181: predecessors 
    -- CP-element group 181: 	1 
    -- CP-element group 181: successors 
    -- CP-element group 181: 	182 
    -- CP-element group 181:  members (6) 
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Update/$entry
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Update/req
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Sample/ack
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Sample/$exit
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_sample_completed_
      -- CP-element group 181: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_update_start_
      -- 
    ack_2769_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 181_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_complete_1160_inst_ack_0, ack => zeropad3D_A_CP_2082_elements(181)); -- 
    req_2773_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2773_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_A_CP_2082_elements(181), ack => WPIPE_Block0_complete_1160_inst_req_1); -- 
    -- CP-element group 182:  transition  place  input  bypass 
    -- CP-element group 182: predecessors 
    -- CP-element group 182: 	181 
    -- CP-element group 182: successors 
    -- CP-element group 182:  members (16) 
      -- CP-element group 182: 	 branch_block_stmt_823/return___PhiReq/$exit
      -- CP-element group 182: 	 branch_block_stmt_823/assign_stmt_1163__exit__
      -- CP-element group 182: 	 branch_block_stmt_823/return__
      -- CP-element group 182: 	 branch_block_stmt_823/merge_stmt_1165__exit__
      -- CP-element group 182: 	 branch_block_stmt_823/branch_block_stmt_823__exit__
      -- CP-element group 182: 	 branch_block_stmt_823/merge_stmt_1165_PhiAck/$exit
      -- CP-element group 182: 	 branch_block_stmt_823/merge_stmt_1165_PhiAck/dummy
      -- CP-element group 182: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Update/$exit
      -- CP-element group 182: 	 branch_block_stmt_823/return___PhiReq/$entry
      -- CP-element group 182: 	 branch_block_stmt_823/$exit
      -- CP-element group 182: 	 $exit
      -- CP-element group 182: 	 branch_block_stmt_823/merge_stmt_1165_PhiAck/$entry
      -- CP-element group 182: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_Update/ack
      -- CP-element group 182: 	 branch_block_stmt_823/merge_stmt_1165_PhiReqMerge
      -- CP-element group 182: 	 branch_block_stmt_823/assign_stmt_1163/$exit
      -- CP-element group 182: 	 branch_block_stmt_823/assign_stmt_1163/WPIPE_Block0_complete_1160_update_completed_
      -- 
    ack_2774_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 182_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_Block0_complete_1160_inst_ack_1, ack => zeropad3D_A_CP_2082_elements(182)); -- 
    zeropad3D_A_do_while_stmt_903_terminator_2757: loop_terminator -- 
      generic map (name => " zeropad3D_A_do_while_stmt_903_terminator_2757", max_iterations_in_flight =>15) 
      port map(loop_body_exit => zeropad3D_A_CP_2082_elements(20),loop_continue => zeropad3D_A_CP_2082_elements(179),loop_terminate => zeropad3D_A_CP_2082_elements(178),loop_back => zeropad3D_A_CP_2082_elements(18),loop_exit => zeropad3D_A_CP_2082_elements(17),clk => clk, reset => reset); -- 
    phi_stmt_905_phi_seq_2267_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_A_CP_2082_elements(35);
      zeropad3D_A_CP_2082_elements(38)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_A_CP_2082_elements(38);
      zeropad3D_A_CP_2082_elements(39)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_A_CP_2082_elements(40);
      zeropad3D_A_CP_2082_elements(36) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_A_CP_2082_elements(33);
      zeropad3D_A_CP_2082_elements(42)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_A_CP_2082_elements(44);
      zeropad3D_A_CP_2082_elements(43)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_A_CP_2082_elements(45);
      zeropad3D_A_CP_2082_elements(34) <= phi_mux_reqs(1);
      phi_stmt_905_phi_seq_2267 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_905_phi_seq_2267") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_A_CP_2082_elements(25), 
          phi_sample_ack => zeropad3D_A_CP_2082_elements(31), 
          phi_update_req => zeropad3D_A_CP_2082_elements(27), 
          phi_update_ack => zeropad3D_A_CP_2082_elements(32), 
          phi_mux_ack => zeropad3D_A_CP_2082_elements(37), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_909_phi_seq_2311_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_A_CP_2082_elements(54);
      zeropad3D_A_CP_2082_elements(57)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_A_CP_2082_elements(57);
      zeropad3D_A_CP_2082_elements(58)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_A_CP_2082_elements(59);
      zeropad3D_A_CP_2082_elements(55) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_A_CP_2082_elements(52);
      zeropad3D_A_CP_2082_elements(61)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_A_CP_2082_elements(63);
      zeropad3D_A_CP_2082_elements(62)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_A_CP_2082_elements(64);
      zeropad3D_A_CP_2082_elements(53) <= phi_mux_reqs(1);
      phi_stmt_909_phi_seq_2311 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_909_phi_seq_2311") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_A_CP_2082_elements(48), 
          phi_sample_ack => zeropad3D_A_CP_2082_elements(49), 
          phi_update_req => zeropad3D_A_CP_2082_elements(50), 
          phi_update_ack => zeropad3D_A_CP_2082_elements(51), 
          phi_mux_ack => zeropad3D_A_CP_2082_elements(56), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_913_phi_seq_2355_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_A_CP_2082_elements(73);
      zeropad3D_A_CP_2082_elements(76)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_A_CP_2082_elements(76);
      zeropad3D_A_CP_2082_elements(77)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_A_CP_2082_elements(78);
      zeropad3D_A_CP_2082_elements(74) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_A_CP_2082_elements(71);
      zeropad3D_A_CP_2082_elements(80)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_A_CP_2082_elements(82);
      zeropad3D_A_CP_2082_elements(81)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_A_CP_2082_elements(83);
      zeropad3D_A_CP_2082_elements(72) <= phi_mux_reqs(1);
      phi_stmt_913_phi_seq_2355 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_913_phi_seq_2355") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_A_CP_2082_elements(67), 
          phi_sample_ack => zeropad3D_A_CP_2082_elements(68), 
          phi_update_req => zeropad3D_A_CP_2082_elements(69), 
          phi_update_ack => zeropad3D_A_CP_2082_elements(70), 
          phi_mux_ack => zeropad3D_A_CP_2082_elements(75), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_917_phi_seq_2399_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_A_CP_2082_elements(92);
      zeropad3D_A_CP_2082_elements(95)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_A_CP_2082_elements(95);
      zeropad3D_A_CP_2082_elements(96)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_A_CP_2082_elements(97);
      zeropad3D_A_CP_2082_elements(93) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_A_CP_2082_elements(90);
      zeropad3D_A_CP_2082_elements(99)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_A_CP_2082_elements(101);
      zeropad3D_A_CP_2082_elements(100)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_A_CP_2082_elements(102);
      zeropad3D_A_CP_2082_elements(91) <= phi_mux_reqs(1);
      phi_stmt_917_phi_seq_2399 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_917_phi_seq_2399") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_A_CP_2082_elements(86), 
          phi_sample_ack => zeropad3D_A_CP_2082_elements(87), 
          phi_update_req => zeropad3D_A_CP_2082_elements(88), 
          phi_update_ack => zeropad3D_A_CP_2082_elements(89), 
          phi_mux_ack => zeropad3D_A_CP_2082_elements(94), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_921_phi_seq_2443_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_A_CP_2082_elements(111);
      zeropad3D_A_CP_2082_elements(114)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_A_CP_2082_elements(114);
      zeropad3D_A_CP_2082_elements(115)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_A_CP_2082_elements(116);
      zeropad3D_A_CP_2082_elements(112) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_A_CP_2082_elements(109);
      zeropad3D_A_CP_2082_elements(118)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_A_CP_2082_elements(120);
      zeropad3D_A_CP_2082_elements(119)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_A_CP_2082_elements(121);
      zeropad3D_A_CP_2082_elements(110) <= phi_mux_reqs(1);
      phi_stmt_921_phi_seq_2443 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_921_phi_seq_2443") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_A_CP_2082_elements(105), 
          phi_sample_ack => zeropad3D_A_CP_2082_elements(106), 
          phi_update_req => zeropad3D_A_CP_2082_elements(107), 
          phi_update_ack => zeropad3D_A_CP_2082_elements(108), 
          phi_mux_ack => zeropad3D_A_CP_2082_elements(113), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    entry_tmerge_2219_block : block -- 
      signal preds : BooleanArray(0 to 1);
      begin -- 
        preds(0)  <= zeropad3D_A_CP_2082_elements(21);
        preds(1)  <= zeropad3D_A_CP_2082_elements(22);
        entry_tmerge_2219 : transition_merge -- 
          generic map(name => " entry_tmerge_2219")
          port map (preds => preds, symbol_out => zeropad3D_A_CP_2082_elements(23));
          -- 
    end block;
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal ADD_u16_u16_1130_wire : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_1141_wire : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_1149_wire : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_990_990_delayed_1_0_990 : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_997_997_delayed_1_0_1000 : std_logic_vector(15 downto 0);
    signal MUX_1063_wire : std_logic_vector(63 downto 0);
    signal MUX_1142_wire : std_logic_vector(15 downto 0);
    signal NOT_u1_u1_1098_wire : std_logic_vector(0 downto 0);
    signal NOT_u1_u1_1122_wire : std_logic_vector(0 downto 0);
    signal array_obj_ref_1036_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1036_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1036_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1036_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1036_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_1036_root_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_1048_root_address : std_logic_vector(13 downto 0);
    signal cmp_dim0_1125 : std_logic_vector(0 downto 0);
    signal cmp_dim1_1101 : std_logic_vector(0 downto 0);
    signal cmp_dim2_1077 : std_logic_vector(0 downto 0);
    signal data_check1_1010 : std_logic_vector(0 downto 0);
    signal data_check2_1015 : std_logic_vector(0 downto 0);
    signal data_check_1020 : std_logic_vector(0 downto 0);
    signal data_check_1047_delayed_13_0_1056 : std_logic_vector(0 downto 0);
    signal dest_add_917 : std_logic_vector(15 downto 0);
    signal dest_add_init_865 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_1_930 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_2_935 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_3_940 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_4_945 : std_logic_vector(15 downto 0);
    signal dim0T_873 : std_logic_vector(15 downto 0);
    signal dim0T_check_1_1106 : std_logic_vector(15 downto 0);
    signal dim0T_check_2_1096_delayed_1_0_1114 : std_logic_vector(15 downto 0);
    signal dim0T_check_2_1111 : std_logic_vector(15 downto 0);
    signal dim0T_check_3_1119 : std_logic_vector(0 downto 0);
    signal dim1R_885 : std_logic_vector(15 downto 0);
    signal dim1T_877 : std_logic_vector(15 downto 0);
    signal dim1T_check_1_1082 : std_logic_vector(15 downto 0);
    signal dim1T_check_2_1075_delayed_1_0_1090 : std_logic_vector(15 downto 0);
    signal dim1T_check_2_1087 : std_logic_vector(15 downto 0);
    signal dim1T_check_3_1095 : std_logic_vector(0 downto 0);
    signal dim21R_899 : std_logic_vector(15 downto 0);
    signal dim21T_894 : std_logic_vector(15 downto 0);
    signal dim2R_889 : std_logic_vector(15 downto 0);
    signal dim2T_881 : std_logic_vector(15 downto 0);
    signal dim2T_dif_1060_delayed_1_0_1072 : std_logic_vector(15 downto 0);
    signal dim2T_dif_1069 : std_logic_vector(15 downto 0);
    signal flag_1156 : std_logic_vector(0 downto 0);
    signal i1_1042 : std_logic_vector(63 downto 0);
    signal i_large_check_995 : std_logic_vector(0 downto 0);
    signal i_loop_913 : std_logic_vector(15 downto 0);
    signal i_loop_init_849 : std_logic_vector(15 downto 0);
    signal i_small_check_980 : std_logic_vector(0 downto 0);
    signal img_data_array_idx_1_950 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_2_955 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_3_960 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_4_965 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_5_970 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_6_975 : std_logic_vector(15 downto 0);
    signal inp_d0_826 : std_logic_vector(15 downto 0);
    signal inp_d1_829 : std_logic_vector(15 downto 0);
    signal inp_d2_832 : std_logic_vector(15 downto 0);
    signal iv1_1038 : std_logic_vector(31 downto 0);
    signal j1_869 : std_logic_vector(15 downto 0);
    signal j_large_check_1005 : std_logic_vector(0 downto 0);
    signal j_loop_909 : std_logic_vector(15 downto 0);
    signal j_loop_init_853 : std_logic_vector(15 downto 0);
    signal j_small_check_985 : std_logic_vector(0 downto 0);
    signal k_loop_905 : std_logic_vector(15 downto 0);
    signal k_loop_init_857 : std_logic_vector(15 downto 0);
    signal konst_1023_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1028_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1067_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1080_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1104_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1129_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1131_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1140_wire_constant : std_logic_vector(15 downto 0);
    signal konst_1148_wire_constant : std_logic_vector(15 downto 0);
    signal next_dest_add_1025 : std_logic_vector(15 downto 0);
    signal next_dest_add_1025_920_buffered : std_logic_vector(15 downto 0);
    signal next_i_loop_1152 : std_logic_vector(15 downto 0);
    signal next_i_loop_1152_916_buffered : std_logic_vector(15 downto 0);
    signal next_j_loop_1144 : std_logic_vector(15 downto 0);
    signal next_j_loop_1144_912_buffered : std_logic_vector(15 downto 0);
    signal next_k_loop_1133 : std_logic_vector(15 downto 0);
    signal next_k_loop_1133_908_buffered : std_logic_vector(15 downto 0);
    signal next_src_add_1030 : std_logic_vector(15 downto 0);
    signal next_src_add_1030_924_buffered : std_logic_vector(15 downto 0);
    signal out_d0_835 : std_logic_vector(15 downto 0);
    signal out_d1_838 : std_logic_vector(15 downto 0);
    signal out_d2_841 : std_logic_vector(15 downto 0);
    signal ov_1045_delayed_7_0_1053 : std_logic_vector(31 downto 0);
    signal ov_1050 : std_logic_vector(31 downto 0);
    signal pad_902 : std_logic_vector(15 downto 0);
    signal padding_844 : std_logic_vector(15 downto 0);
    signal ptr_deref_1041_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_1041_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1041_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1041_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_1041_word_offset_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_1058_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_1058_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1058_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1058_wire : std_logic_vector(63 downto 0);
    signal ptr_deref_1058_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_1058_word_offset_0 : std_logic_vector(13 downto 0);
    signal src_add_921 : std_logic_vector(15 downto 0);
    signal src_add_init_861 : std_logic_vector(15 downto 0);
    signal type_cast_1035_resized : std_logic_vector(13 downto 0);
    signal type_cast_1035_scaled : std_logic_vector(13 downto 0);
    signal type_cast_1035_wire : std_logic_vector(63 downto 0);
    signal type_cast_1047_resized : std_logic_vector(13 downto 0);
    signal type_cast_1047_scaled : std_logic_vector(13 downto 0);
    signal type_cast_1047_wire : std_logic_vector(63 downto 0);
    signal type_cast_1061_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1162_wire_constant : std_logic_vector(15 downto 0);
    -- 
  begin -- 
    array_obj_ref_1036_constant_part_of_offset <= "00000000000000";
    array_obj_ref_1036_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_1036_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_1036_resized_base_address <= "00000000000000";
    array_obj_ref_1048_constant_part_of_offset <= "00000000000000";
    array_obj_ref_1048_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_1048_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_1048_resized_base_address <= "00000000000000";
    dest_add_init_865 <= "0000000000000000";
    i_loop_init_849 <= "0000000000000000";
    j1_869 <= "0000000000000000";
    j_loop_init_853 <= "0000000000000000";
    k_loop_init_857 <= "0000000000000000";
    konst_1023_wire_constant <= "0000000000000011";
    konst_1028_wire_constant <= "0000000000000011";
    konst_1067_wire_constant <= "0000000000001000";
    konst_1080_wire_constant <= "0000000000000001";
    konst_1104_wire_constant <= "0000000000000001";
    konst_1129_wire_constant <= "0000000000001000";
    konst_1131_wire_constant <= "0000000000000000";
    konst_1140_wire_constant <= "0000000000000001";
    konst_1148_wire_constant <= "0000000000000001";
    ptr_deref_1041_word_offset_0 <= "00000000000000";
    ptr_deref_1058_word_offset_0 <= "00000000000000";
    src_add_init_861 <= "0000000000000000";
    type_cast_1061_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
    type_cast_1162_wire_constant <= "0000000000000001";
    phi_stmt_905: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= k_loop_init_857 & next_k_loop_1133_908_buffered;
      req <= phi_stmt_905_req_0 & phi_stmt_905_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_905",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_905_ack_0,
          idata => idata,
          odata => k_loop_905,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_905
    phi_stmt_909: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= j_loop_init_853 & next_j_loop_1144_912_buffered;
      req <= phi_stmt_909_req_0 & phi_stmt_909_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_909",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_909_ack_0,
          idata => idata,
          odata => j_loop_909,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_909
    phi_stmt_913: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= i_loop_init_849 & next_i_loop_1152_916_buffered;
      req <= phi_stmt_913_req_0 & phi_stmt_913_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_913",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_913_ack_0,
          idata => idata,
          odata => i_loop_913,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_913
    phi_stmt_917: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= dest_add_init_865 & next_dest_add_1025_920_buffered;
      req <= phi_stmt_917_req_0 & phi_stmt_917_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_917",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_917_ack_0,
          idata => idata,
          odata => dest_add_917,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_917
    phi_stmt_921: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= src_add_init_861 & next_src_add_1030_924_buffered;
      req <= phi_stmt_921_req_0 & phi_stmt_921_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_921",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_921_ack_0,
          idata => idata,
          odata => src_add_921,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_921
    MUX_1063_inst_block : block -- 
      signal sample_req, sample_ack, update_req, update_ack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      sample_req(0) <= MUX_1063_inst_req_0;
      MUX_1063_inst_ack_0<= sample_ack(0);
      update_req(0) <= MUX_1063_inst_req_1;
      MUX_1063_inst_ack_1<= update_ack(0);
      MUX_1063_inst: SelectSplitProtocol generic map(name => "MUX_1063_inst", data_width => 64, buffering => 1, flow_through => false, full_rate => true) -- 
        port map( x => type_cast_1061_wire_constant, y => i1_1042, sel => data_check_1047_delayed_13_0_1056, z => MUX_1063_wire, sample_req => sample_req(0), sample_ack => sample_ack(0), update_req => update_req(0), update_ack => update_ack(0), clk => clk, reset => reset); -- 
      -- 
    end block;
    -- flow-through select operator MUX_1132_inst
    next_k_loop_1133 <= ADD_u16_u16_1130_wire when (cmp_dim2_1077(0) /=  '0') else konst_1131_wire_constant;
    -- flow-through select operator MUX_1142_inst
    MUX_1142_wire <= j1_869 when (cmp_dim1_1101(0) /=  '0') else ADD_u16_u16_1141_wire;
    -- flow-through select operator MUX_1143_inst
    next_j_loop_1144 <= j_loop_909 when (cmp_dim2_1077(0) /=  '0') else MUX_1142_wire;
    -- flow-through select operator MUX_1151_inst
    next_i_loop_1152 <= ADD_u16_u16_1149_wire when (cmp_dim1_1101(0) /=  '0') else i_loop_913;
    W_data_check_1047_delayed_13_0_1054_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_data_check_1047_delayed_13_0_1054_inst_req_0;
      W_data_check_1047_delayed_13_0_1054_inst_ack_0<= wack(0);
      rreq(0) <= W_data_check_1047_delayed_13_0_1054_inst_req_1;
      W_data_check_1047_delayed_13_0_1054_inst_ack_1<= rack(0);
      W_data_check_1047_delayed_13_0_1054_inst : InterlockBuffer generic map ( -- 
        name => "W_data_check_1047_delayed_13_0_1054_inst",
        buffer_size => 13,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 1,
        out_data_width => 1,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => data_check_1020,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => data_check_1047_delayed_13_0_1056,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim0T_check_2_1096_delayed_1_0_1112_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_0;
      W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_0<= wack(0);
      rreq(0) <= W_dim0T_check_2_1096_delayed_1_0_1112_inst_req_1;
      W_dim0T_check_2_1096_delayed_1_0_1112_inst_ack_1<= rack(0);
      W_dim0T_check_2_1096_delayed_1_0_1112_inst : InterlockBuffer generic map ( -- 
        name => "W_dim0T_check_2_1096_delayed_1_0_1112_inst",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => dim0T_check_2_1111,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim0T_check_2_1096_delayed_1_0_1114,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim1T_check_2_1075_delayed_1_0_1088_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_0;
      W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_0<= wack(0);
      rreq(0) <= W_dim1T_check_2_1075_delayed_1_0_1088_inst_req_1;
      W_dim1T_check_2_1075_delayed_1_0_1088_inst_ack_1<= rack(0);
      W_dim1T_check_2_1075_delayed_1_0_1088_inst : InterlockBuffer generic map ( -- 
        name => "W_dim1T_check_2_1075_delayed_1_0_1088_inst",
        buffer_size => 2,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => dim1T_check_2_1087,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim1T_check_2_1075_delayed_1_0_1090,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim2T_dif_1060_delayed_1_0_1070_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim2T_dif_1060_delayed_1_0_1070_inst_req_0;
      W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_0<= wack(0);
      rreq(0) <= W_dim2T_dif_1060_delayed_1_0_1070_inst_req_1;
      W_dim2T_dif_1060_delayed_1_0_1070_inst_ack_1<= rack(0);
      W_dim2T_dif_1060_delayed_1_0_1070_inst : InterlockBuffer generic map ( -- 
        name => "W_dim2T_dif_1060_delayed_1_0_1070_inst",
        buffer_size => 2,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => dim2T_dif_1069,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim2T_dif_1060_delayed_1_0_1072,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_ov_1045_delayed_7_0_1051_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_ov_1045_delayed_7_0_1051_inst_req_0;
      W_ov_1045_delayed_7_0_1051_inst_ack_0<= wack(0);
      rreq(0) <= W_ov_1045_delayed_7_0_1051_inst_req_1;
      W_ov_1045_delayed_7_0_1051_inst_ack_1<= rack(0);
      W_ov_1045_delayed_7_0_1051_inst : InterlockBuffer generic map ( -- 
        name => "W_ov_1045_delayed_7_0_1051_inst",
        buffer_size => 7,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 32,
        out_data_width => 32,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => ov_1050,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ov_1045_delayed_7_0_1053,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock W_pad_900_inst
    process(padding_844) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := padding_844(15 downto 0);
      pad_902 <= tmp_var; -- 
    end process;
    addr_of_1037_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_1037_final_reg_req_0;
      addr_of_1037_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_1037_final_reg_req_1;
      addr_of_1037_final_reg_ack_1<= rack(0);
      addr_of_1037_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_1037_final_reg",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 14,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => array_obj_ref_1036_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => iv1_1038,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    addr_of_1049_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_1049_final_reg_req_0;
      addr_of_1049_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_1049_final_reg_req_1;
      addr_of_1049_final_reg_ack_1<= rack(0);
      addr_of_1049_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_1049_final_reg",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 14,
        out_data_width => 32,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => array_obj_ref_1048_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ov_1050,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_dest_add_1025_920_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_dest_add_1025_920_buf_req_0;
      next_dest_add_1025_920_buf_ack_0<= wack(0);
      rreq(0) <= next_dest_add_1025_920_buf_req_1;
      next_dest_add_1025_920_buf_ack_1<= rack(0);
      next_dest_add_1025_920_buf : InterlockBuffer generic map ( -- 
        name => "next_dest_add_1025_920_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => next_dest_add_1025,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_dest_add_1025_920_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_i_loop_1152_916_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_i_loop_1152_916_buf_req_0;
      next_i_loop_1152_916_buf_ack_0<= wack(0);
      rreq(0) <= next_i_loop_1152_916_buf_req_1;
      next_i_loop_1152_916_buf_ack_1<= rack(0);
      next_i_loop_1152_916_buf : InterlockBuffer generic map ( -- 
        name => "next_i_loop_1152_916_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => next_i_loop_1152,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_i_loop_1152_916_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_j_loop_1144_912_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_j_loop_1144_912_buf_req_0;
      next_j_loop_1144_912_buf_ack_0<= wack(0);
      rreq(0) <= next_j_loop_1144_912_buf_req_1;
      next_j_loop_1144_912_buf_ack_1<= rack(0);
      next_j_loop_1144_912_buf : InterlockBuffer generic map ( -- 
        name => "next_j_loop_1144_912_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => next_j_loop_1144,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_j_loop_1144_912_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_k_loop_1133_908_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_k_loop_1133_908_buf_req_0;
      next_k_loop_1133_908_buf_ack_0<= wack(0);
      rreq(0) <= next_k_loop_1133_908_buf_req_1;
      next_k_loop_1133_908_buf_ack_1<= rack(0);
      next_k_loop_1133_908_buf : InterlockBuffer generic map ( -- 
        name => "next_k_loop_1133_908_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => next_k_loop_1133,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_k_loop_1133_908_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_src_add_1030_924_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_src_add_1030_924_buf_req_0;
      next_src_add_1030_924_buf_ack_0<= wack(0);
      rreq(0) <= next_src_add_1030_924_buf_req_1;
      next_src_add_1030_924_buf_ack_1<= rack(0);
      next_src_add_1030_924_buf : InterlockBuffer generic map ( -- 
        name => "next_src_add_1030_924_buf",
        buffer_size => 1,
        flow_through =>  false ,
        cut_through =>  false ,
        in_data_width => 16,
        out_data_width => 16,
        bypass_flag =>  false 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => next_src_add_1030,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_src_add_1030_924_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock type_cast_1035_inst
    process(src_add_921) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := src_add_921(15 downto 0);
      type_cast_1035_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_1047_inst
    process(dest_add_917) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := dest_add_917(15 downto 0);
      type_cast_1047_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_872_inst
    process(inp_d0_826) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d0_826(15 downto 0);
      dim0T_873 <= tmp_var; -- 
    end process;
    -- interlock type_cast_876_inst
    process(inp_d1_829) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d1_829(15 downto 0);
      dim1T_877 <= tmp_var; -- 
    end process;
    -- interlock type_cast_880_inst
    process(inp_d2_832) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d2_832(15 downto 0);
      dim2T_881 <= tmp_var; -- 
    end process;
    -- interlock type_cast_884_inst
    process(out_d1_838) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := out_d1_838(15 downto 0);
      dim1R_885 <= tmp_var; -- 
    end process;
    -- interlock type_cast_888_inst
    process(out_d2_841) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := out_d2_841(15 downto 0);
      dim2R_889 <= tmp_var; -- 
    end process;
    -- equivalence array_obj_ref_1036_index_1_rename
    process(type_cast_1035_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_1035_resized;
      ov(13 downto 0) := iv;
      type_cast_1035_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1036_index_1_resize
    process(type_cast_1035_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_1035_wire;
      ov := iv(13 downto 0);
      type_cast_1035_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1036_root_address_inst
    process(array_obj_ref_1036_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_1036_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_1036_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1048_index_1_rename
    process(type_cast_1047_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_1047_resized;
      ov(13 downto 0) := iv;
      type_cast_1047_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1048_index_1_resize
    process(type_cast_1047_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_1047_wire;
      ov := iv(13 downto 0);
      type_cast_1047_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1048_root_address_inst
    process(array_obj_ref_1048_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_1048_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_1048_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1041_addr_0
    process(ptr_deref_1041_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1041_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_1041_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1041_base_resize
    process(iv1_1038) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := iv1_1038;
      ov := iv(13 downto 0);
      ptr_deref_1041_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1041_gather_scatter
    process(ptr_deref_1041_data_0) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1041_data_0;
      ov(63 downto 0) := iv;
      i1_1042 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1041_root_address_inst
    process(ptr_deref_1041_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1041_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_1041_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1058_addr_0
    process(ptr_deref_1058_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1058_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_1058_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1058_base_resize
    process(ov_1045_delayed_7_0_1053) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ov_1045_delayed_7_0_1053;
      ov := iv(13 downto 0);
      ptr_deref_1058_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1058_gather_scatter
    process(MUX_1063_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := MUX_1063_wire;
      ov(63 downto 0) := iv;
      ptr_deref_1058_data_0 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1058_root_address_inst
    process(ptr_deref_1058_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1058_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_1058_root_address <= ov(13 downto 0);
      --
    end process;
    do_while_stmt_903_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= flag_1156;
      branch_instance: BranchBase -- 
        generic map( name => "do_while_stmt_903_branch", condition_width => 1,  bypass_flag => true)
        port map( -- 
          condition => condition_sig,
          req => do_while_stmt_903_branch_req_0,
          ack0 => do_while_stmt_903_branch_ack_0,
          ack1 => do_while_stmt_903_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator ADD_u16_u16_1086_inst
    process(dim1T_877, dim1T_check_1_1082) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dim1T_877, dim1T_check_1_1082, tmp_var);
      dim1T_check_2_1087 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_1110_inst
    process(dim0T_873, dim0T_check_1_1106) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dim0T_873, dim0T_check_1_1106, tmp_var);
      dim0T_check_2_1111 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_1130_inst
    process(k_loop_905) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(k_loop_905, konst_1129_wire_constant, tmp_var);
      ADD_u16_u16_1130_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_1141_inst
    process(j_loop_909) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(j_loop_909, konst_1140_wire_constant, tmp_var);
      ADD_u16_u16_1141_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_1149_inst
    process(i_loop_913) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(i_loop_913, konst_1148_wire_constant, tmp_var);
      ADD_u16_u16_1149_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_939_inst
    process(dest_data_array_idx_1_930, dest_data_array_idx_2_935) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dest_data_array_idx_1_930, dest_data_array_idx_2_935, tmp_var);
      dest_data_array_idx_3_940 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_944_inst
    process(dest_data_array_idx_3_940, k_loop_905) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dest_data_array_idx_3_940, k_loop_905, tmp_var);
      dest_data_array_idx_4_945 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_969_inst
    process(img_data_array_idx_3_960, img_data_array_idx_4_965) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(img_data_array_idx_3_960, img_data_array_idx_4_965, tmp_var);
      img_data_array_idx_5_970 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_974_inst
    process(img_data_array_idx_5_970, k_loop_905) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(img_data_array_idx_5_970, k_loop_905, tmp_var);
      img_data_array_idx_6_975 <= tmp_var; --
    end process;
    -- shared split operator group (9) : ADD_u16_u16_989_inst 
    ApIntAdd_group_9: Block -- 
      signal data_in: std_logic_vector(31 downto 0);
      signal data_out: std_logic_vector(15 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= inp_d0_826 & pad_902;
      ADD_u16_u16_990_990_delayed_1_0_990 <= data_out(15 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= ADD_u16_u16_989_inst_req_0;
      ADD_u16_u16_989_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ADD_u16_u16_989_inst_req_1;
      ADD_u16_u16_989_inst_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_9_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_9_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_9",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 16,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 16, 
          num_inputs    => 2,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 16,
          constant_operand => "0",
          constant_width => 1,
          buffering  => 1,
          flow_through => false,
          full_rate  => true,
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
    end Block; -- split operator group 9
    -- shared split operator group (10) : ADD_u16_u16_999_inst 
    ApIntAdd_group_10: Block -- 
      signal data_in: std_logic_vector(31 downto 0);
      signal data_out: std_logic_vector(15 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 0);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 1);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= inp_d1_829 & pad_902;
      ADD_u16_u16_997_997_delayed_1_0_1000 <= data_out(15 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= ADD_u16_u16_999_inst_req_0;
      ADD_u16_u16_999_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ADD_u16_u16_999_inst_req_1;
      ADD_u16_u16_999_inst_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_10_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_10_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_10",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 16,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 16, 
          num_inputs    => 2,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 16,
          constant_operand => "0",
          constant_width => 1,
          buffering  => 1,
          flow_through => false,
          full_rate  => true,
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
    end Block; -- split operator group 10
    -- binary operator AND_u1_u1_1100_inst
    process(NOT_u1_u1_1098_wire, dim1T_check_3_1095) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NOT_u1_u1_1098_wire, dim1T_check_3_1095, tmp_var);
      cmp_dim1_1101 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_1124_inst
    process(NOT_u1_u1_1122_wire, dim0T_check_3_1119) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NOT_u1_u1_1122_wire, dim0T_check_3_1119, tmp_var);
      cmp_dim0_1125 <= tmp_var; --
    end process;
    -- binary operator EQ_u16_u1_1094_inst
    process(j_loop_909, dim1T_check_2_1075_delayed_1_0_1090) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(j_loop_909, dim1T_check_2_1075_delayed_1_0_1090, tmp_var);
      dim1T_check_3_1095 <= tmp_var; --
    end process;
    -- binary operator EQ_u16_u1_1118_inst
    process(i_loop_913, dim0T_check_2_1096_delayed_1_0_1114) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(i_loop_913, dim0T_check_2_1096_delayed_1_0_1114, tmp_var);
      dim0T_check_3_1119 <= tmp_var; --
    end process;
    -- binary operator LSHR_u16_u16_1024_inst
    process(dest_data_array_idx_4_945) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(dest_data_array_idx_4_945, konst_1023_wire_constant, tmp_var);
      next_dest_add_1025 <= tmp_var; --
    end process;
    -- binary operator LSHR_u16_u16_1029_inst
    process(img_data_array_idx_6_975) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(img_data_array_idx_6_975, konst_1028_wire_constant, tmp_var);
      next_src_add_1030 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_893_inst
    process(dim2T_881, dim1T_877) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2T_881, dim1T_877, tmp_var);
      dim21T_894 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_898_inst
    process(dim2R_889, dim1R_885) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2R_889, dim1R_885, tmp_var);
      dim21R_899 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_929_inst
    process(dim2R_889, j_loop_909) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2R_889, j_loop_909, tmp_var);
      dest_data_array_idx_1_930 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_934_inst
    process(dim21R_899, i_loop_913) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim21R_899, i_loop_913, tmp_var);
      dest_data_array_idx_2_935 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_959_inst
    process(dim2T_881, img_data_array_idx_1_950) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2T_881, img_data_array_idx_1_950, tmp_var);
      img_data_array_idx_3_960 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_964_inst
    process(dim21T_894, img_data_array_idx_2_955) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim21T_894, img_data_array_idx_2_955, tmp_var);
      img_data_array_idx_4_965 <= tmp_var; --
    end process;
    -- unary operator NOT_u1_u1_1098_inst
    process(cmp_dim2_1077) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim2_1077, tmp_var);
      NOT_u1_u1_1098_wire <= tmp_var; -- 
    end process;
    -- unary operator NOT_u1_u1_1122_inst
    process(cmp_dim2_1077) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim2_1077, tmp_var);
      NOT_u1_u1_1122_wire <= tmp_var; -- 
    end process;
    -- unary operator NOT_u1_u1_1155_inst
    process(cmp_dim0_1125) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim0_1125, tmp_var);
      flag_1156 <= tmp_var; -- 
    end process;
    -- binary operator OR_u1_u1_1009_inst
    process(i_small_check_980, j_small_check_985) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(i_small_check_980, j_small_check_985, tmp_var);
      data_check1_1010 <= tmp_var; --
    end process;
    -- binary operator OR_u1_u1_1014_inst
    process(data_check1_1010, i_large_check_995) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(data_check1_1010, i_large_check_995, tmp_var);
      data_check2_1015 <= tmp_var; --
    end process;
    -- binary operator OR_u1_u1_1019_inst
    process(data_check2_1015, j_large_check_1005) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(data_check2_1015, j_large_check_1005, tmp_var);
      data_check_1020 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_1081_inst
    process(pad_902) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(pad_902, konst_1080_wire_constant, tmp_var);
      dim1T_check_1_1082 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_1105_inst
    process(pad_902) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(pad_902, konst_1104_wire_constant, tmp_var);
      dim0T_check_1_1106 <= tmp_var; --
    end process;
    -- binary operator SUB_u16_u16_1068_inst
    process(dim2T_881) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(dim2T_881, konst_1067_wire_constant, tmp_var);
      dim2T_dif_1069 <= tmp_var; --
    end process;
    -- binary operator SUB_u16_u16_949_inst
    process(j_loop_909, pad_902) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(j_loop_909, pad_902, tmp_var);
      img_data_array_idx_1_950 <= tmp_var; --
    end process;
    -- binary operator SUB_u16_u16_954_inst
    process(i_loop_913, pad_902) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(i_loop_913, pad_902, tmp_var);
      img_data_array_idx_2_955 <= tmp_var; --
    end process;
    -- binary operator UGE_u16_u1_1004_inst
    process(j_loop_909, ADD_u16_u16_997_997_delayed_1_0_1000) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUge_proc(j_loop_909, ADD_u16_u16_997_997_delayed_1_0_1000, tmp_var);
      j_large_check_1005 <= tmp_var; --
    end process;
    -- binary operator UGE_u16_u1_994_inst
    process(i_loop_913, ADD_u16_u16_990_990_delayed_1_0_990) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUge_proc(i_loop_913, ADD_u16_u16_990_990_delayed_1_0_990, tmp_var);
      i_large_check_995 <= tmp_var; --
    end process;
    -- binary operator ULE_u16_u1_1076_inst
    process(k_loop_905, dim2T_dif_1060_delayed_1_0_1072) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUle_proc(k_loop_905, dim2T_dif_1060_delayed_1_0_1072, tmp_var);
      cmp_dim2_1077 <= tmp_var; --
    end process;
    -- binary operator ULT_u16_u1_979_inst
    process(i_loop_913, pad_902) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUlt_proc(i_loop_913, pad_902, tmp_var);
      i_small_check_980 <= tmp_var; --
    end process;
    -- binary operator ULT_u16_u1_984_inst
    process(j_loop_909, pad_902) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUlt_proc(j_loop_909, pad_902, tmp_var);
      j_small_check_985 <= tmp_var; --
    end process;
    -- shared split operator group (39) : array_obj_ref_1036_index_offset 
    ApIntAdd_group_39: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(13 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= type_cast_1035_scaled;
      array_obj_ref_1036_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_1036_index_offset_req_0;
      array_obj_ref_1036_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_1036_index_offset_req_1;
      array_obj_ref_1036_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_39_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_39_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_39",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 14,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 14,
          constant_operand => "00000000000000",
          constant_width => 14,
          buffering  => 2,
          flow_through => false,
          full_rate  => true,
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
    end Block; -- split operator group 39
    -- shared split operator group (40) : array_obj_ref_1048_index_offset 
    ApIntAdd_group_40: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(13 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 2);
      -- 
    begin -- 
      data_in <= type_cast_1047_scaled;
      array_obj_ref_1048_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_1048_index_offset_req_0;
      array_obj_ref_1048_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_1048_index_offset_req_1;
      array_obj_ref_1048_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_40_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_40_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          operator_id => "ApIntAdd",
          name => "ApIntAdd_group_40",
          input1_is_int => true, 
          input1_characteristic_width => 0, 
          input1_mantissa_width    => 0, 
          iwidth_1  => 14,
          input2_is_int => true, 
          input2_characteristic_width => 0, 
          input2_mantissa_width => 0, 
          iwidth_2      => 0, 
          num_inputs    => 1,
          output_is_int => true,
          output_characteristic_width  => 0, 
          output_mantissa_width => 0, 
          owidth => 14,
          constant_operand => "00000000000000",
          constant_width => 14,
          buffering  => 2,
          flow_through => false,
          full_rate  => true,
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
    end Block; -- split operator group 40
    -- shared load operator group (0) : ptr_deref_1041_load_0 
    LoadGroup0: Block -- 
      signal data_in: std_logic_vector(13 downto 0);
      signal data_out: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated: BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 6);
      -- 
    begin -- 
      reqL_unguarded(0) <= ptr_deref_1041_load_0_req_0;
      ptr_deref_1041_load_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_1041_load_0_req_1;
      ptr_deref_1041_load_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      LoadGroup0_gI: SplitGuardInterface generic map(name => "LoadGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      data_in <= ptr_deref_1041_word_address_0;
      ptr_deref_1041_data_0 <= data_out(63 downto 0);
      LoadReq: LoadReqSharedWithInputBuffers -- 
        generic map ( name => "LoadGroup0", addr_width => 14,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqL => reqL , 
          ackL => ackL , 
          dataL => data_in, 
          mreq => memory_space_1_lr_req(0),
          mack => memory_space_1_lr_ack(0),
          maddr => memory_space_1_lr_addr(13 downto 0),
          mtag => memory_space_1_lr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      LoadComplete: LoadCompleteShared -- 
        generic map ( name => "LoadGroup0 load-complete ",
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        detailed_buffering_per_output => outBUFs, 
        no_arbitration => false)
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          dataR => data_out, 
          mreq => memory_space_1_lc_req(0),
          mack => memory_space_1_lc_ack(0),
          mdata => memory_space_1_lc_data(63 downto 0),
          mtag => memory_space_1_lc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- load group 0
    -- shared store operator group (0) : ptr_deref_1058_store_0 
    StoreGroup0: Block -- 
      signal addr_in: std_logic_vector(13 downto 0);
      signal data_in: std_logic_vector(63 downto 0);
      signal reqR, ackR, reqL, ackL : BooleanArray( 0 downto 0);
      signal reqR_unguarded, ackR_unguarded, reqL_unguarded, ackL_unguarded : BooleanArray( 0 downto 0);
      signal reqL_unregulated, ackL_unregulated : BooleanArray( 0 downto 0);
      signal guard_vector : std_logic_vector( 0 downto 0);
      constant inBUFs : IntegerArray(0 downto 0) := (0 => 2);
      constant outBUFs : IntegerArray(0 downto 0) := (0 => 15);
      constant guardFlags : BooleanArray(0 downto 0) := (0 => false);
      constant guardBuffering: IntegerArray(0 downto 0)  := (0 => 6);
      -- 
    begin -- 
      reqL_unguarded(0) <= ptr_deref_1058_store_0_req_0;
      ptr_deref_1058_store_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_1058_store_0_req_1;
      ptr_deref_1058_store_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      StoreGroup0_gI: SplitGuardInterface generic map(name => "StoreGroup0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      addr_in <= ptr_deref_1058_word_address_0;
      data_in <= ptr_deref_1058_data_0;
      StoreReq: StoreReqSharedWithInputBuffers -- 
        generic map ( name => "StoreGroup0 Req ", addr_width => 14,
        data_width => 64,
        num_reqs => 1,
        tag_length => 1,
        time_stamp_width => 17,
        min_clock_period => false,
        input_buffering => inBUFs, 
        no_arbitration => false)
        port map (--
          reqL => reqL , 
          ackL => ackL , 
          addr => addr_in, 
          data => data_in, 
          mreq => memory_space_0_sr_req(0),
          mack => memory_space_0_sr_ack(0),
          maddr => memory_space_0_sr_addr(13 downto 0),
          mdata => memory_space_0_sr_data(63 downto 0),
          mtag => memory_space_0_sr_tag(17 downto 0),
          clk => clk, reset => reset -- 
        );--
      StoreComplete: StoreCompleteShared -- 
        generic map ( -- 
          name => "StoreGroup0 Complete ",
          num_reqs => 1,
          detailed_buffering_per_output => outBUFs,
          tag_length => 1 -- 
        )
        port map ( -- 
          reqR => reqR , 
          ackR => ackR , 
          mreq => memory_space_0_sc_req(0),
          mack => memory_space_0_sc_ack(0),
          mtag => memory_space_0_sc_tag(0 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- store group 0
    -- shared inport operator group (0) : RPIPE_Block0_starting_843_inst RPIPE_Block0_starting_840_inst RPIPE_Block0_starting_837_inst RPIPE_Block0_starting_834_inst RPIPE_Block0_starting_831_inst RPIPE_Block0_starting_828_inst RPIPE_Block0_starting_825_inst 
    InportGroup_0: Block -- 
      signal data_out: std_logic_vector(111 downto 0);
      signal reqL, ackL, reqR, ackR : BooleanArray( 6 downto 0);
      signal reqL_unguarded, ackL_unguarded : BooleanArray( 6 downto 0);
      signal reqR_unguarded, ackR_unguarded : BooleanArray( 6 downto 0);
      signal guard_vector : std_logic_vector( 6 downto 0);
      constant outBUFs : IntegerArray(6 downto 0) := (6 => 1, 5 => 1, 4 => 1, 3 => 1, 2 => 1, 1 => 1, 0 => 1);
      constant guardFlags : BooleanArray(6 downto 0) := (0 => false, 1 => false, 2 => false, 3 => false, 4 => false, 5 => false, 6 => false);
      constant guardBuffering: IntegerArray(6 downto 0)  := (0 => 2, 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2);
      -- 
    begin -- 
      reqL_unguarded(6) <= RPIPE_Block0_starting_843_inst_req_0;
      reqL_unguarded(5) <= RPIPE_Block0_starting_840_inst_req_0;
      reqL_unguarded(4) <= RPIPE_Block0_starting_837_inst_req_0;
      reqL_unguarded(3) <= RPIPE_Block0_starting_834_inst_req_0;
      reqL_unguarded(2) <= RPIPE_Block0_starting_831_inst_req_0;
      reqL_unguarded(1) <= RPIPE_Block0_starting_828_inst_req_0;
      reqL_unguarded(0) <= RPIPE_Block0_starting_825_inst_req_0;
      RPIPE_Block0_starting_843_inst_ack_0 <= ackL_unguarded(6);
      RPIPE_Block0_starting_840_inst_ack_0 <= ackL_unguarded(5);
      RPIPE_Block0_starting_837_inst_ack_0 <= ackL_unguarded(4);
      RPIPE_Block0_starting_834_inst_ack_0 <= ackL_unguarded(3);
      RPIPE_Block0_starting_831_inst_ack_0 <= ackL_unguarded(2);
      RPIPE_Block0_starting_828_inst_ack_0 <= ackL_unguarded(1);
      RPIPE_Block0_starting_825_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(6) <= RPIPE_Block0_starting_843_inst_req_1;
      reqR_unguarded(5) <= RPIPE_Block0_starting_840_inst_req_1;
      reqR_unguarded(4) <= RPIPE_Block0_starting_837_inst_req_1;
      reqR_unguarded(3) <= RPIPE_Block0_starting_834_inst_req_1;
      reqR_unguarded(2) <= RPIPE_Block0_starting_831_inst_req_1;
      reqR_unguarded(1) <= RPIPE_Block0_starting_828_inst_req_1;
      reqR_unguarded(0) <= RPIPE_Block0_starting_825_inst_req_1;
      RPIPE_Block0_starting_843_inst_ack_1 <= ackR_unguarded(6);
      RPIPE_Block0_starting_840_inst_ack_1 <= ackR_unguarded(5);
      RPIPE_Block0_starting_837_inst_ack_1 <= ackR_unguarded(4);
      RPIPE_Block0_starting_834_inst_ack_1 <= ackR_unguarded(3);
      RPIPE_Block0_starting_831_inst_ack_1 <= ackR_unguarded(2);
      RPIPE_Block0_starting_828_inst_ack_1 <= ackR_unguarded(1);
      RPIPE_Block0_starting_825_inst_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      guard_vector(1)  <=  '1';
      guard_vector(2)  <=  '1';
      guard_vector(3)  <=  '1';
      guard_vector(4)  <=  '1';
      guard_vector(5)  <=  '1';
      guard_vector(6)  <=  '1';
      padding_844 <= data_out(111 downto 96);
      out_d2_841 <= data_out(95 downto 80);
      out_d1_838 <= data_out(79 downto 64);
      out_d0_835 <= data_out(63 downto 48);
      inp_d2_832 <= data_out(47 downto 32);
      inp_d1_829 <= data_out(31 downto 16);
      inp_d0_826 <= data_out(15 downto 0);
      Block0_starting_read_0_gI: SplitGuardInterface generic map(name => "Block0_starting_read_0_gI", nreqs => 7, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => true) -- 
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
      Block0_starting_read_0: InputPortRevised -- 
        generic map ( name => "Block0_starting_read_0", data_width => 16,  num_reqs => 7,  output_buffering => outBUFs,   nonblocking_read_flag => False,  no_arbitration => false)
        port map (-- 
          sample_req => reqL , 
          sample_ack => ackL, 
          update_req => reqR, 
          update_ack => ackR, 
          data => data_out, 
          oreq => Block0_starting_pipe_read_req(0),
          oack => Block0_starting_pipe_read_ack(0),
          odata => Block0_starting_pipe_read_data(15 downto 0),
          clk => clk, reset => reset -- 
        ); -- 
      -- 
    end Block; -- inport group 0
    -- shared outport operator group (0) : WPIPE_Block0_complete_1160_inst 
    OutportGroup_0: Block -- 
      signal data_in: std_logic_vector(15 downto 0);
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
      sample_req_unguarded(0) <= WPIPE_Block0_complete_1160_inst_req_0;
      WPIPE_Block0_complete_1160_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(0) <= WPIPE_Block0_complete_1160_inst_req_1;
      WPIPE_Block0_complete_1160_inst_ack_1 <= update_ack_unguarded(0);
      guard_vector(0)  <=  '1';
      data_in <= type_cast_1162_wire_constant;
      Block0_complete_write_0_gI: SplitGuardInterface generic map(name => "Block0_complete_write_0_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
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
      Block0_complete_write_0: OutputPortRevised -- 
        generic map ( name => "Block0_complete", data_width => 16, num_reqs => 1, input_buffering => inBUFs, full_rate => false,
        no_arbitration => false)
        port map (--
          sample_req => sample_req , 
          sample_ack => sample_ack , 
          update_req => update_req , 
          update_ack => update_ack , 
          data => data_in, 
          oreq => Block0_complete_pipe_write_req(0),
          oack => Block0_complete_pipe_write_ack(0),
          odata => Block0_complete_pipe_write_data(15 downto 0),
          clk => clk, reset => reset -- 
        );-- 
      -- 
    end Block; -- outport group 0
    -- 
  end Block; -- data_path
  -- 
end zeropad3D_A_arch;
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
library work;
use work.ahir_system_global_package.all;
entity ahir_system is  -- system 
  port (-- 
    clk : in std_logic;
    reset : in std_logic;
    zeropad_input_pipe_pipe_write_data: in std_logic_vector(7 downto 0);
    zeropad_input_pipe_pipe_write_req : in std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_write_ack : out std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_read_data: out std_logic_vector(7 downto 0);
    zeropad_output_pipe_pipe_read_req : in std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_read_ack : out std_logic_vector(0 downto 0)); -- 
  -- 
end entity; 
architecture ahir_system_arch  of ahir_system is -- system-architecture 
  -- interface signals to connect to memory space memory_space_0
  signal memory_space_0_lr_req :  std_logic_vector(0 downto 0);
  signal memory_space_0_lr_ack : std_logic_vector(0 downto 0);
  signal memory_space_0_lr_addr : std_logic_vector(13 downto 0);
  signal memory_space_0_lr_tag : std_logic_vector(17 downto 0);
  signal memory_space_0_lc_req : std_logic_vector(0 downto 0);
  signal memory_space_0_lc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_0_lc_data : std_logic_vector(63 downto 0);
  signal memory_space_0_lc_tag :  std_logic_vector(0 downto 0);
  signal memory_space_0_sr_req :  std_logic_vector(0 downto 0);
  signal memory_space_0_sr_ack : std_logic_vector(0 downto 0);
  signal memory_space_0_sr_addr : std_logic_vector(13 downto 0);
  signal memory_space_0_sr_data : std_logic_vector(63 downto 0);
  signal memory_space_0_sr_tag : std_logic_vector(17 downto 0);
  signal memory_space_0_sc_req : std_logic_vector(0 downto 0);
  signal memory_space_0_sc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_0_sc_tag :  std_logic_vector(0 downto 0);
  -- interface signals to connect to memory space memory_space_1
  signal memory_space_1_lr_req :  std_logic_vector(0 downto 0);
  signal memory_space_1_lr_ack : std_logic_vector(0 downto 0);
  signal memory_space_1_lr_addr : std_logic_vector(13 downto 0);
  signal memory_space_1_lr_tag : std_logic_vector(17 downto 0);
  signal memory_space_1_lc_req : std_logic_vector(0 downto 0);
  signal memory_space_1_lc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_1_lc_data : std_logic_vector(63 downto 0);
  signal memory_space_1_lc_tag :  std_logic_vector(0 downto 0);
  signal memory_space_1_sr_req :  std_logic_vector(0 downto 0);
  signal memory_space_1_sr_ack : std_logic_vector(0 downto 0);
  signal memory_space_1_sr_addr : std_logic_vector(13 downto 0);
  signal memory_space_1_sr_data : std_logic_vector(63 downto 0);
  signal memory_space_1_sr_tag : std_logic_vector(17 downto 0);
  signal memory_space_1_sc_req : std_logic_vector(0 downto 0);
  signal memory_space_1_sc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_1_sc_tag :  std_logic_vector(0 downto 0);
  -- interface signals to connect to memory space memory_space_2
  signal memory_space_2_lr_req :  std_logic_vector(0 downto 0);
  signal memory_space_2_lr_ack : std_logic_vector(0 downto 0);
  signal memory_space_2_lr_addr : std_logic_vector(0 downto 0);
  signal memory_space_2_lr_tag : std_logic_vector(17 downto 0);
  signal memory_space_2_lc_req : std_logic_vector(0 downto 0);
  signal memory_space_2_lc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_2_lc_data : std_logic_vector(63 downto 0);
  signal memory_space_2_lc_tag :  std_logic_vector(0 downto 0);
  signal memory_space_2_sr_req :  std_logic_vector(0 downto 0);
  signal memory_space_2_sr_ack : std_logic_vector(0 downto 0);
  signal memory_space_2_sr_addr : std_logic_vector(0 downto 0);
  signal memory_space_2_sr_data : std_logic_vector(63 downto 0);
  signal memory_space_2_sr_tag : std_logic_vector(17 downto 0);
  signal memory_space_2_sc_req : std_logic_vector(0 downto 0);
  signal memory_space_2_sc_ack :  std_logic_vector(0 downto 0);
  signal memory_space_2_sc_tag :  std_logic_vector(0 downto 0);
  -- declarations related to module timer
  component timer is -- 
    generic (tag_length : integer); 
    port ( -- 
      c : out  std_logic_vector(63 downto 0);
      memory_space_2_lr_req : out  std_logic_vector(0 downto 0);
      memory_space_2_lr_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_lr_addr : out  std_logic_vector(0 downto 0);
      memory_space_2_lr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_2_lc_req : out  std_logic_vector(0 downto 0);
      memory_space_2_lc_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_lc_data : in   std_logic_vector(63 downto 0);
      memory_space_2_lc_tag :  in  std_logic_vector(0 downto 0);
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
  -- argument signals for module timer
  signal timer_c :  std_logic_vector(63 downto 0);
  signal timer_out_args   : std_logic_vector(63 downto 0);
  signal timer_tag_in    : std_logic_vector(2 downto 0) := (others => '0');
  signal timer_tag_out   : std_logic_vector(2 downto 0);
  signal timer_start_req : std_logic;
  signal timer_start_ack : std_logic;
  signal timer_fin_req   : std_logic;
  signal timer_fin_ack : std_logic;
  -- caller side aggregated signals for module timer
  signal timer_call_reqs: std_logic_vector(0 downto 0);
  signal timer_call_acks: std_logic_vector(0 downto 0);
  signal timer_return_reqs: std_logic_vector(0 downto 0);
  signal timer_return_acks: std_logic_vector(0 downto 0);
  signal timer_call_tag: std_logic_vector(1 downto 0);
  signal timer_return_data: std_logic_vector(63 downto 0);
  signal timer_return_tag: std_logic_vector(1 downto 0);
  -- declarations related to module timerDaemon
  component timerDaemon is -- 
    generic (tag_length : integer); 
    port ( -- 
      memory_space_2_sr_req : out  std_logic_vector(0 downto 0);
      memory_space_2_sr_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_sr_addr : out  std_logic_vector(0 downto 0);
      memory_space_2_sr_data : out  std_logic_vector(63 downto 0);
      memory_space_2_sr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_2_sc_req : out  std_logic_vector(0 downto 0);
      memory_space_2_sc_ack : in   std_logic_vector(0 downto 0);
      memory_space_2_sc_tag :  in  std_logic_vector(0 downto 0);
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
  -- argument signals for module timerDaemon
  signal timerDaemon_tag_in    : std_logic_vector(1 downto 0) := (others => '0');
  signal timerDaemon_tag_out   : std_logic_vector(1 downto 0);
  signal timerDaemon_start_req : std_logic;
  signal timerDaemon_start_ack : std_logic;
  signal timerDaemon_fin_req   : std_logic;
  signal timerDaemon_fin_ack : std_logic;
  -- declarations related to module zeropad3D
  component zeropad3D is -- 
    generic (tag_length : integer); 
    port ( -- 
      memory_space_0_lr_req : out  std_logic_vector(0 downto 0);
      memory_space_0_lr_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_lr_addr : out  std_logic_vector(13 downto 0);
      memory_space_0_lr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_0_lc_req : out  std_logic_vector(0 downto 0);
      memory_space_0_lc_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_lc_data : in   std_logic_vector(63 downto 0);
      memory_space_0_lc_tag :  in  std_logic_vector(0 downto 0);
      memory_space_1_sr_req : out  std_logic_vector(0 downto 0);
      memory_space_1_sr_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_sr_addr : out  std_logic_vector(13 downto 0);
      memory_space_1_sr_data : out  std_logic_vector(63 downto 0);
      memory_space_1_sr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_1_sc_req : out  std_logic_vector(0 downto 0);
      memory_space_1_sc_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_sc_tag :  in  std_logic_vector(0 downto 0);
      Block0_complete_pipe_read_req : out  std_logic_vector(0 downto 0);
      Block0_complete_pipe_read_ack : in   std_logic_vector(0 downto 0);
      Block0_complete_pipe_read_data : in   std_logic_vector(15 downto 0);
      zeropad_input_pipe_pipe_read_req : out  std_logic_vector(0 downto 0);
      zeropad_input_pipe_pipe_read_ack : in   std_logic_vector(0 downto 0);
      zeropad_input_pipe_pipe_read_data : in   std_logic_vector(7 downto 0);
      zeropad_output_pipe_pipe_write_req : out  std_logic_vector(0 downto 0);
      zeropad_output_pipe_pipe_write_ack : in   std_logic_vector(0 downto 0);
      zeropad_output_pipe_pipe_write_data : out  std_logic_vector(7 downto 0);
      Block0_starting_pipe_write_req : out  std_logic_vector(0 downto 0);
      Block0_starting_pipe_write_ack : in   std_logic_vector(0 downto 0);
      Block0_starting_pipe_write_data : out  std_logic_vector(15 downto 0);
      timer_call_reqs : out  std_logic_vector(0 downto 0);
      timer_call_acks : in   std_logic_vector(0 downto 0);
      timer_call_tag  :  out  std_logic_vector(1 downto 0);
      timer_return_reqs : out  std_logic_vector(0 downto 0);
      timer_return_acks : in   std_logic_vector(0 downto 0);
      timer_return_data : in   std_logic_vector(63 downto 0);
      timer_return_tag :  in   std_logic_vector(1 downto 0);
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
  -- argument signals for module zeropad3D
  signal zeropad3D_tag_in    : std_logic_vector(1 downto 0) := (others => '0');
  signal zeropad3D_tag_out   : std_logic_vector(1 downto 0);
  signal zeropad3D_start_req : std_logic;
  signal zeropad3D_start_ack : std_logic;
  signal zeropad3D_fin_req   : std_logic;
  signal zeropad3D_fin_ack : std_logic;
  -- declarations related to module zeropad3D_A
  component zeropad3D_A is -- 
    generic (tag_length : integer); 
    port ( -- 
      memory_space_1_lr_req : out  std_logic_vector(0 downto 0);
      memory_space_1_lr_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_lr_addr : out  std_logic_vector(13 downto 0);
      memory_space_1_lr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_1_lc_req : out  std_logic_vector(0 downto 0);
      memory_space_1_lc_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_lc_data : in   std_logic_vector(63 downto 0);
      memory_space_1_lc_tag :  in  std_logic_vector(0 downto 0);
      memory_space_0_sr_req : out  std_logic_vector(0 downto 0);
      memory_space_0_sr_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_sr_addr : out  std_logic_vector(13 downto 0);
      memory_space_0_sr_data : out  std_logic_vector(63 downto 0);
      memory_space_0_sr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_0_sc_req : out  std_logic_vector(0 downto 0);
      memory_space_0_sc_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_sc_tag :  in  std_logic_vector(0 downto 0);
      Block0_starting_pipe_read_req : out  std_logic_vector(0 downto 0);
      Block0_starting_pipe_read_ack : in   std_logic_vector(0 downto 0);
      Block0_starting_pipe_read_data : in   std_logic_vector(15 downto 0);
      Block0_complete_pipe_write_req : out  std_logic_vector(0 downto 0);
      Block0_complete_pipe_write_ack : in   std_logic_vector(0 downto 0);
      Block0_complete_pipe_write_data : out  std_logic_vector(15 downto 0);
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
  -- argument signals for module zeropad3D_A
  signal zeropad3D_A_tag_in    : std_logic_vector(1 downto 0) := (others => '0');
  signal zeropad3D_A_tag_out   : std_logic_vector(1 downto 0);
  signal zeropad3D_A_start_req : std_logic;
  signal zeropad3D_A_start_ack : std_logic;
  signal zeropad3D_A_fin_req   : std_logic;
  signal zeropad3D_A_fin_ack : std_logic;
  -- aggregate signals for write to pipe Block0_complete
  signal Block0_complete_pipe_write_data: std_logic_vector(15 downto 0);
  signal Block0_complete_pipe_write_req: std_logic_vector(0 downto 0);
  signal Block0_complete_pipe_write_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for read from pipe Block0_complete
  signal Block0_complete_pipe_read_data: std_logic_vector(15 downto 0);
  signal Block0_complete_pipe_read_req: std_logic_vector(0 downto 0);
  signal Block0_complete_pipe_read_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for write to pipe Block0_starting
  signal Block0_starting_pipe_write_data: std_logic_vector(15 downto 0);
  signal Block0_starting_pipe_write_req: std_logic_vector(0 downto 0);
  signal Block0_starting_pipe_write_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for read from pipe Block0_starting
  signal Block0_starting_pipe_read_data: std_logic_vector(15 downto 0);
  signal Block0_starting_pipe_read_req: std_logic_vector(0 downto 0);
  signal Block0_starting_pipe_read_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for read from pipe zeropad_input_pipe
  signal zeropad_input_pipe_pipe_read_data: std_logic_vector(7 downto 0);
  signal zeropad_input_pipe_pipe_read_req: std_logic_vector(0 downto 0);
  signal zeropad_input_pipe_pipe_read_ack: std_logic_vector(0 downto 0);
  -- aggregate signals for write to pipe zeropad_output_pipe
  signal zeropad_output_pipe_pipe_write_data: std_logic_vector(7 downto 0);
  signal zeropad_output_pipe_pipe_write_req: std_logic_vector(0 downto 0);
  signal zeropad_output_pipe_pipe_write_ack: std_logic_vector(0 downto 0);
  -- gated clock signal declarations.
  -- 
begin -- 
  -- module timer
  timer_out_args <= timer_c ;
  -- call arbiter for module timer
  timer_arbiter: SplitCallArbiterNoInargs -- 
    generic map( --
      name => "SplitCallArbiterNoInargs", num_reqs => 1,
      return_data_width => 64,
      callee_tag_length => 1,
      caller_tag_length => 2--
    )
    port map(-- 
      call_reqs => timer_call_reqs,
      call_acks => timer_call_acks,
      return_reqs => timer_return_reqs,
      return_acks => timer_return_acks,
      call_tag  => timer_call_tag,
      return_tag  => timer_return_tag,
      call_mtag => timer_tag_in,
      return_mtag => timer_tag_out,
      return_data =>timer_return_data,
      call_mreq => timer_start_req,
      call_mack => timer_start_ack,
      return_mreq => timer_fin_req,
      return_mack => timer_fin_ack,
      return_mdata => timer_out_args,
      clk => clk, 
      reset => reset --
    ); --
  timer_instance:timer-- 
    generic map(tag_length => 3)
    port map(-- 
      c => timer_c,
      start_req => timer_start_req,
      start_ack => timer_start_ack,
      fin_req => timer_fin_req,
      fin_ack => timer_fin_ack,
      clk => clk,
      reset => reset,
      memory_space_2_lr_req => memory_space_2_lr_req(0 downto 0),
      memory_space_2_lr_ack => memory_space_2_lr_ack(0 downto 0),
      memory_space_2_lr_addr => memory_space_2_lr_addr(0 downto 0),
      memory_space_2_lr_tag => memory_space_2_lr_tag(17 downto 0),
      memory_space_2_lc_req => memory_space_2_lc_req(0 downto 0),
      memory_space_2_lc_ack => memory_space_2_lc_ack(0 downto 0),
      memory_space_2_lc_data => memory_space_2_lc_data(63 downto 0),
      memory_space_2_lc_tag => memory_space_2_lc_tag(0 downto 0),
      tag_in => timer_tag_in,
      tag_out => timer_tag_out-- 
    ); -- 
  -- module timerDaemon
  timerDaemon_instance:timerDaemon-- 
    generic map(tag_length => 2)
    port map(-- 
      start_req => timerDaemon_start_req,
      start_ack => timerDaemon_start_ack,
      fin_req => timerDaemon_fin_req,
      fin_ack => timerDaemon_fin_ack,
      clk => clk,
      reset => reset,
      memory_space_2_sr_req => memory_space_2_sr_req(0 downto 0),
      memory_space_2_sr_ack => memory_space_2_sr_ack(0 downto 0),
      memory_space_2_sr_addr => memory_space_2_sr_addr(0 downto 0),
      memory_space_2_sr_data => memory_space_2_sr_data(63 downto 0),
      memory_space_2_sr_tag => memory_space_2_sr_tag(17 downto 0),
      memory_space_2_sc_req => memory_space_2_sc_req(0 downto 0),
      memory_space_2_sc_ack => memory_space_2_sc_ack(0 downto 0),
      memory_space_2_sc_tag => memory_space_2_sc_tag(0 downto 0),
      tag_in => timerDaemon_tag_in,
      tag_out => timerDaemon_tag_out-- 
    ); -- 
  -- module will be run forever 
  timerDaemon_tag_in <= (others => '0');
  timerDaemon_auto_run: auto_run generic map(use_delay => true)  port map(clk => clk, reset => reset, start_req => timerDaemon_start_req, start_ack => timerDaemon_start_ack,  fin_req => timerDaemon_fin_req,  fin_ack => timerDaemon_fin_ack);
  -- module zeropad3D
  zeropad3D_instance:zeropad3D-- 
    generic map(tag_length => 2)
    port map(-- 
      start_req => zeropad3D_start_req,
      start_ack => zeropad3D_start_ack,
      fin_req => zeropad3D_fin_req,
      fin_ack => zeropad3D_fin_ack,
      clk => clk,
      reset => reset,
      memory_space_0_lr_req => memory_space_0_lr_req(0 downto 0),
      memory_space_0_lr_ack => memory_space_0_lr_ack(0 downto 0),
      memory_space_0_lr_addr => memory_space_0_lr_addr(13 downto 0),
      memory_space_0_lr_tag => memory_space_0_lr_tag(17 downto 0),
      memory_space_0_lc_req => memory_space_0_lc_req(0 downto 0),
      memory_space_0_lc_ack => memory_space_0_lc_ack(0 downto 0),
      memory_space_0_lc_data => memory_space_0_lc_data(63 downto 0),
      memory_space_0_lc_tag => memory_space_0_lc_tag(0 downto 0),
      memory_space_1_sr_req => memory_space_1_sr_req(0 downto 0),
      memory_space_1_sr_ack => memory_space_1_sr_ack(0 downto 0),
      memory_space_1_sr_addr => memory_space_1_sr_addr(13 downto 0),
      memory_space_1_sr_data => memory_space_1_sr_data(63 downto 0),
      memory_space_1_sr_tag => memory_space_1_sr_tag(17 downto 0),
      memory_space_1_sc_req => memory_space_1_sc_req(0 downto 0),
      memory_space_1_sc_ack => memory_space_1_sc_ack(0 downto 0),
      memory_space_1_sc_tag => memory_space_1_sc_tag(0 downto 0),
      Block0_complete_pipe_read_req => Block0_complete_pipe_read_req(0 downto 0),
      Block0_complete_pipe_read_ack => Block0_complete_pipe_read_ack(0 downto 0),
      Block0_complete_pipe_read_data => Block0_complete_pipe_read_data(15 downto 0),
      zeropad_input_pipe_pipe_read_req => zeropad_input_pipe_pipe_read_req(0 downto 0),
      zeropad_input_pipe_pipe_read_ack => zeropad_input_pipe_pipe_read_ack(0 downto 0),
      zeropad_input_pipe_pipe_read_data => zeropad_input_pipe_pipe_read_data(7 downto 0),
      zeropad_output_pipe_pipe_write_req => zeropad_output_pipe_pipe_write_req(0 downto 0),
      zeropad_output_pipe_pipe_write_ack => zeropad_output_pipe_pipe_write_ack(0 downto 0),
      zeropad_output_pipe_pipe_write_data => zeropad_output_pipe_pipe_write_data(7 downto 0),
      Block0_starting_pipe_write_req => Block0_starting_pipe_write_req(0 downto 0),
      Block0_starting_pipe_write_ack => Block0_starting_pipe_write_ack(0 downto 0),
      Block0_starting_pipe_write_data => Block0_starting_pipe_write_data(15 downto 0),
      timer_call_reqs => timer_call_reqs(0 downto 0),
      timer_call_acks => timer_call_acks(0 downto 0),
      timer_call_tag => timer_call_tag(1 downto 0),
      timer_return_reqs => timer_return_reqs(0 downto 0),
      timer_return_acks => timer_return_acks(0 downto 0),
      timer_return_data => timer_return_data(63 downto 0),
      timer_return_tag => timer_return_tag(1 downto 0),
      tag_in => zeropad3D_tag_in,
      tag_out => zeropad3D_tag_out-- 
    ); -- 
  -- module will be run forever 
  zeropad3D_tag_in <= (others => '0');
  zeropad3D_auto_run: auto_run generic map(use_delay => true)  port map(clk => clk, reset => reset, start_req => zeropad3D_start_req, start_ack => zeropad3D_start_ack,  fin_req => zeropad3D_fin_req,  fin_ack => zeropad3D_fin_ack);
  -- module zeropad3D_A
  zeropad3D_A_instance:zeropad3D_A-- 
    generic map(tag_length => 2)
    port map(-- 
      start_req => zeropad3D_A_start_req,
      start_ack => zeropad3D_A_start_ack,
      fin_req => zeropad3D_A_fin_req,
      fin_ack => zeropad3D_A_fin_ack,
      clk => clk,
      reset => reset,
      memory_space_1_lr_req => memory_space_1_lr_req(0 downto 0),
      memory_space_1_lr_ack => memory_space_1_lr_ack(0 downto 0),
      memory_space_1_lr_addr => memory_space_1_lr_addr(13 downto 0),
      memory_space_1_lr_tag => memory_space_1_lr_tag(17 downto 0),
      memory_space_1_lc_req => memory_space_1_lc_req(0 downto 0),
      memory_space_1_lc_ack => memory_space_1_lc_ack(0 downto 0),
      memory_space_1_lc_data => memory_space_1_lc_data(63 downto 0),
      memory_space_1_lc_tag => memory_space_1_lc_tag(0 downto 0),
      memory_space_0_sr_req => memory_space_0_sr_req(0 downto 0),
      memory_space_0_sr_ack => memory_space_0_sr_ack(0 downto 0),
      memory_space_0_sr_addr => memory_space_0_sr_addr(13 downto 0),
      memory_space_0_sr_data => memory_space_0_sr_data(63 downto 0),
      memory_space_0_sr_tag => memory_space_0_sr_tag(17 downto 0),
      memory_space_0_sc_req => memory_space_0_sc_req(0 downto 0),
      memory_space_0_sc_ack => memory_space_0_sc_ack(0 downto 0),
      memory_space_0_sc_tag => memory_space_0_sc_tag(0 downto 0),
      Block0_starting_pipe_read_req => Block0_starting_pipe_read_req(0 downto 0),
      Block0_starting_pipe_read_ack => Block0_starting_pipe_read_ack(0 downto 0),
      Block0_starting_pipe_read_data => Block0_starting_pipe_read_data(15 downto 0),
      Block0_complete_pipe_write_req => Block0_complete_pipe_write_req(0 downto 0),
      Block0_complete_pipe_write_ack => Block0_complete_pipe_write_ack(0 downto 0),
      Block0_complete_pipe_write_data => Block0_complete_pipe_write_data(15 downto 0),
      tag_in => zeropad3D_A_tag_in,
      tag_out => zeropad3D_A_tag_out-- 
    ); -- 
  -- module will be run forever 
  zeropad3D_A_tag_in <= (others => '0');
  zeropad3D_A_auto_run: auto_run generic map(use_delay => true)  port map(clk => clk, reset => reset, start_req => zeropad3D_A_start_req, start_ack => zeropad3D_A_start_ack,  fin_req => zeropad3D_A_fin_req,  fin_ack => zeropad3D_A_fin_ack);
  Block0_complete_Pipe: PipeBase -- 
    generic map( -- 
      name => "pipe Block0_complete",
      num_reads => 1,
      num_writes => 1,
      data_width => 16,
      lifo_mode => false,
      full_rate => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => Block0_complete_pipe_read_req,
      read_ack => Block0_complete_pipe_read_ack,
      read_data => Block0_complete_pipe_read_data,
      write_req => Block0_complete_pipe_write_req,
      write_ack => Block0_complete_pipe_write_ack,
      write_data => Block0_complete_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  Block0_starting_Pipe: PipeBase -- 
    generic map( -- 
      name => "pipe Block0_starting",
      num_reads => 1,
      num_writes => 1,
      data_width => 16,
      lifo_mode => false,
      full_rate => false,
      shift_register_mode => false,
      bypass => false,
      depth => 1 --
    )
    port map( -- 
      read_req => Block0_starting_pipe_read_req,
      read_ack => Block0_starting_pipe_read_ack,
      read_data => Block0_starting_pipe_read_data,
      write_req => Block0_starting_pipe_write_req,
      write_ack => Block0_starting_pipe_write_ack,
      write_data => Block0_starting_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  zeropad_input_pipe_Pipe: PipeBase -- 
    generic map( -- 
      name => "pipe zeropad_input_pipe",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      full_rate => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => zeropad_input_pipe_pipe_read_req,
      read_ack => zeropad_input_pipe_pipe_read_ack,
      read_data => zeropad_input_pipe_pipe_read_data,
      write_req => zeropad_input_pipe_pipe_write_req,
      write_ack => zeropad_input_pipe_pipe_write_ack,
      write_data => zeropad_input_pipe_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  zeropad_output_pipe_Pipe: PipeBase -- 
    generic map( -- 
      name => "pipe zeropad_output_pipe",
      num_reads => 1,
      num_writes => 1,
      data_width => 8,
      lifo_mode => false,
      full_rate => false,
      shift_register_mode => false,
      bypass => false,
      depth => 2 --
    )
    port map( -- 
      read_req => zeropad_output_pipe_pipe_read_req,
      read_ack => zeropad_output_pipe_pipe_read_ack,
      read_data => zeropad_output_pipe_pipe_read_data,
      write_req => zeropad_output_pipe_pipe_write_req,
      write_ack => zeropad_output_pipe_pipe_write_ack,
      write_data => zeropad_output_pipe_pipe_write_data,
      clk => clk,reset => reset -- 
    ); -- 
  -- gated clock generators 
  MemorySpace_memory_space_0: ordered_memory_subsystem -- 
    generic map(-- 
      name => "memory_space_0",
      num_loads => 1,
      num_stores => 1,
      addr_width => 14,
      data_width => 64,
      tag_width => 1,
      time_stamp_width => 17,
      number_of_banks => 1,
      mux_degree => 2,
      demux_degree => 2,
      base_bank_addr_width => 14,
      base_bank_data_width => 64
      ) -- 
    port map(-- 
      lr_addr_in => memory_space_0_lr_addr,
      lr_req_in => memory_space_0_lr_req,
      lr_ack_out => memory_space_0_lr_ack,
      lr_tag_in => memory_space_0_lr_tag,
      lc_req_in => memory_space_0_lc_req,
      lc_ack_out => memory_space_0_lc_ack,
      lc_data_out => memory_space_0_lc_data,
      lc_tag_out => memory_space_0_lc_tag,
      sr_addr_in => memory_space_0_sr_addr,
      sr_data_in => memory_space_0_sr_data,
      sr_req_in => memory_space_0_sr_req,
      sr_ack_out => memory_space_0_sr_ack,
      sr_tag_in => memory_space_0_sr_tag,
      sc_req_in=> memory_space_0_sc_req,
      sc_ack_out => memory_space_0_sc_ack,
      sc_tag_out => memory_space_0_sc_tag,
      clock => clk,
      reset => reset); -- 
  MemorySpace_memory_space_1: ordered_memory_subsystem -- 
    generic map(-- 
      name => "memory_space_1",
      num_loads => 1,
      num_stores => 1,
      addr_width => 14,
      data_width => 64,
      tag_width => 1,
      time_stamp_width => 17,
      number_of_banks => 1,
      mux_degree => 2,
      demux_degree => 2,
      base_bank_addr_width => 14,
      base_bank_data_width => 64
      ) -- 
    port map(-- 
      lr_addr_in => memory_space_1_lr_addr,
      lr_req_in => memory_space_1_lr_req,
      lr_ack_out => memory_space_1_lr_ack,
      lr_tag_in => memory_space_1_lr_tag,
      lc_req_in => memory_space_1_lc_req,
      lc_ack_out => memory_space_1_lc_ack,
      lc_data_out => memory_space_1_lc_data,
      lc_tag_out => memory_space_1_lc_tag,
      sr_addr_in => memory_space_1_sr_addr,
      sr_data_in => memory_space_1_sr_data,
      sr_req_in => memory_space_1_sr_req,
      sr_ack_out => memory_space_1_sr_ack,
      sr_tag_in => memory_space_1_sr_tag,
      sc_req_in=> memory_space_1_sc_req,
      sc_ack_out => memory_space_1_sc_ack,
      sc_tag_out => memory_space_1_sc_tag,
      clock => clk,
      reset => reset); -- 
  MemorySpace_memory_space_2: ordered_memory_subsystem -- 
    generic map(-- 
      name => "memory_space_2",
      num_loads => 1,
      num_stores => 1,
      addr_width => 1,
      data_width => 64,
      tag_width => 1,
      time_stamp_width => 17,
      number_of_banks => 1,
      mux_degree => 2,
      demux_degree => 2,
      base_bank_addr_width => 1,
      base_bank_data_width => 64
      ) -- 
    port map(-- 
      lr_addr_in => memory_space_2_lr_addr,
      lr_req_in => memory_space_2_lr_req,
      lr_ack_out => memory_space_2_lr_ack,
      lr_tag_in => memory_space_2_lr_tag,
      lc_req_in => memory_space_2_lc_req,
      lc_ack_out => memory_space_2_lc_ack,
      lc_data_out => memory_space_2_lc_data,
      lc_tag_out => memory_space_2_lc_tag,
      sr_addr_in => memory_space_2_sr_addr,
      sr_data_in => memory_space_2_sr_data,
      sr_req_in => memory_space_2_sr_req,
      sr_ack_out => memory_space_2_sr_ack,
      sr_tag_in => memory_space_2_sr_tag,
      sc_req_in=> memory_space_2_sc_req,
      sc_ack_out => memory_space_2_sc_ack,
      sc_tag_out => memory_space_2_sc_tag,
      clock => clk,
      reset => reset); -- 
  -- 
end ahir_system_arch;
