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
    -- CP-element group 9: 	13 
    -- CP-element group 9: 	12 
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
    -- CP-element group 10: 	15 
    -- CP-element group 10: 	35 
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
      preds <= timerDaemon_CP_65_elements(15) & timerDaemon_CP_65_elements(35);
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
    -- CP-element group 31: 	15 
    -- CP-element group 31: 	9 
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
      preds <= timerDaemon_CP_65_elements(15) & timerDaemon_CP_65_elements(9) & timerDaemon_CP_65_elements(33);
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
    memory_space_1_lr_req : out  std_logic_vector(0 downto 0);
    memory_space_1_lr_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_lr_addr : out  std_logic_vector(13 downto 0);
    memory_space_1_lr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_1_lc_req : out  std_logic_vector(0 downto 0);
    memory_space_1_lc_ack : in   std_logic_vector(0 downto 0);
    memory_space_1_lc_data : in   std_logic_vector(63 downto 0);
    memory_space_1_lc_tag :  in  std_logic_vector(0 downto 0);
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
    memory_space_0_sr_req : out  std_logic_vector(0 downto 0);
    memory_space_0_sr_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_sr_addr : out  std_logic_vector(13 downto 0);
    memory_space_0_sr_data : out  std_logic_vector(63 downto 0);
    memory_space_0_sr_tag :  out  std_logic_vector(17 downto 0);
    memory_space_0_sc_req : out  std_logic_vector(0 downto 0);
    memory_space_0_sc_ack : in   std_logic_vector(0 downto 0);
    memory_space_0_sc_tag :  in  std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_read_req : out  std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_read_ack : in   std_logic_vector(0 downto 0);
    zeropad_input_pipe_pipe_read_data : in   std_logic_vector(7 downto 0);
    zeropad_output_pipe_pipe_write_req : out  std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_write_ack : in   std_logic_vector(0 downto 0);
    zeropad_output_pipe_pipe_write_data : out  std_logic_vector(7 downto 0);
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
  signal type_cast_1030_inst_req_1 : boolean;
  signal next_i_loop_816_580_buf_req_0 : boolean;
  signal next_i_loop_816_580_buf_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_ack_0 : boolean;
  signal addr_of_1002_final_reg_req_1 : boolean;
  signal next_i_loop_816_580_buf_req_1 : boolean;
  signal next_i_loop_816_580_buf_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_req_0 : boolean;
  signal type_cast_451_inst_req_0 : boolean;
  signal type_cast_397_inst_req_1 : boolean;
  signal type_cast_433_inst_ack_0 : boolean;
  signal phi_stmt_573_req_0 : boolean;
  signal type_cast_433_inst_req_0 : boolean;
  signal do_while_stmt_567_branch_req_0 : boolean;
  signal type_cast_946_inst_req_1 : boolean;
  signal type_cast_946_inst_ack_1 : boolean;
  signal phi_stmt_569_req_0 : boolean;
  signal type_cast_942_inst_ack_1 : boolean;
  signal type_cast_879_inst_ack_1 : boolean;
  signal phi_stmt_577_ack_0 : boolean;
  signal next_k_loop_797_572_buf_ack_1 : boolean;
  signal next_k_loop_797_572_buf_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_57_inst_ack_1 : boolean;
  signal type_cast_379_inst_ack_1 : boolean;
  signal type_cast_889_inst_ack_0 : boolean;
  signal phi_stmt_573_req_1 : boolean;
  signal type_cast_899_inst_req_1 : boolean;
  signal addr_of_1002_final_reg_ack_1 : boolean;
  signal type_cast_985_inst_req_1 : boolean;
  signal if_stmt_976_branch_req_0 : boolean;
  signal type_cast_415_inst_ack_1 : boolean;
  signal type_cast_397_inst_ack_0 : boolean;
  signal type_cast_397_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_429_inst_req_1 : boolean;
  signal type_cast_942_inst_ack_0 : boolean;
  signal call_stmt_484_call_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_51_inst_ack_1 : boolean;
  signal type_cast_942_inst_req_0 : boolean;
  signal call_stmt_484_call_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_ack_0 : boolean;
  signal type_cast_415_inst_req_1 : boolean;
  signal type_cast_1020_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_54_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_914_inst_req_0 : boolean;
  signal type_cast_985_inst_req_0 : boolean;
  signal type_cast_488_inst_req_1 : boolean;
  signal type_cast_230_inst_req_0 : boolean;
  signal type_cast_230_inst_ack_0 : boolean;
  signal type_cast_230_inst_req_1 : boolean;
  signal type_cast_230_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_req_0 : boolean;
  signal type_cast_909_inst_req_0 : boolean;
  signal type_cast_239_inst_req_0 : boolean;
  signal type_cast_451_inst_ack_1 : boolean;
  signal type_cast_239_inst_ack_0 : boolean;
  signal phi_stmt_569_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_60_inst_ack_1 : boolean;
  signal type_cast_1020_inst_req_1 : boolean;
  signal type_cast_889_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_63_inst_ack_1 : boolean;
  signal next_j_loop_808_576_buf_ack_1 : boolean;
  signal type_cast_67_inst_req_0 : boolean;
  signal type_cast_67_inst_ack_0 : boolean;
  signal type_cast_67_inst_req_1 : boolean;
  signal type_cast_67_inst_ack_1 : boolean;
  signal type_cast_985_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_ack_0 : boolean;
  signal type_cast_415_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_76_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_914_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_ack_1 : boolean;
  signal type_cast_946_inst_ack_0 : boolean;
  signal type_cast_80_inst_req_0 : boolean;
  signal type_cast_80_inst_ack_0 : boolean;
  signal type_cast_80_inst_req_1 : boolean;
  signal type_cast_80_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_ack_0 : boolean;
  signal type_cast_415_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_88_inst_ack_1 : boolean;
  signal next_k_loop_797_572_buf_ack_0 : boolean;
  signal next_j_loop_808_576_buf_req_1 : boolean;
  signal type_cast_92_inst_req_0 : boolean;
  signal type_cast_92_inst_ack_0 : boolean;
  signal type_cast_92_inst_req_1 : boolean;
  signal type_cast_92_inst_ack_1 : boolean;
  signal phi_stmt_577_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_101_inst_ack_1 : boolean;
  signal phi_stmt_573_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_req_1 : boolean;
  signal type_cast_105_inst_req_0 : boolean;
  signal type_cast_105_inst_ack_0 : boolean;
  signal type_cast_105_inst_req_1 : boolean;
  signal type_cast_105_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_920_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_113_inst_ack_1 : boolean;
  signal next_k_loop_797_572_buf_req_0 : boolean;
  signal type_cast_117_inst_req_0 : boolean;
  signal type_cast_117_inst_ack_0 : boolean;
  signal type_cast_117_inst_req_1 : boolean;
  signal type_cast_117_inst_ack_1 : boolean;
  signal type_cast_889_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_126_inst_ack_1 : boolean;
  signal if_stmt_976_branch_ack_1 : boolean;
  signal type_cast_130_inst_req_0 : boolean;
  signal type_cast_130_inst_ack_0 : boolean;
  signal type_cast_130_inst_req_1 : boolean;
  signal type_cast_130_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_914_inst_ack_1 : boolean;
  signal if_stmt_473_branch_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_req_0 : boolean;
  signal array_obj_ref_1001_index_offset_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_138_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_ack_0 : boolean;
  signal type_cast_142_inst_req_0 : boolean;
  signal type_cast_142_inst_ack_0 : boolean;
  signal type_cast_142_inst_req_1 : boolean;
  signal type_cast_142_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_151_inst_ack_1 : boolean;
  signal type_cast_1020_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_447_inst_req_0 : boolean;
  signal type_cast_155_inst_req_0 : boolean;
  signal type_cast_155_inst_ack_0 : boolean;
  signal type_cast_155_inst_req_1 : boolean;
  signal type_cast_155_inst_ack_1 : boolean;
  signal phi_stmt_577_req_1 : boolean;
  signal if_stmt_473_branch_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_req_1 : boolean;
  signal array_obj_ref_1001_index_offset_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_163_inst_ack_1 : boolean;
  signal type_cast_1030_inst_ack_1 : boolean;
  signal type_cast_167_inst_req_0 : boolean;
  signal type_cast_167_inst_ack_0 : boolean;
  signal type_cast_167_inst_req_1 : boolean;
  signal type_cast_167_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_176_inst_ack_1 : boolean;
  signal next_j_loop_808_576_buf_ack_0 : boolean;
  signal type_cast_180_inst_req_0 : boolean;
  signal type_cast_180_inst_ack_0 : boolean;
  signal type_cast_180_inst_req_1 : boolean;
  signal type_cast_180_inst_ack_1 : boolean;
  signal phi_stmt_569_ack_0 : boolean;
  signal type_cast_889_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_188_inst_ack_1 : boolean;
  signal type_cast_942_inst_req_1 : boolean;
  signal ptr_deref_459_store_0_ack_1 : boolean;
  signal type_cast_192_inst_req_0 : boolean;
  signal type_cast_192_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_393_inst_req_0 : boolean;
  signal type_cast_192_inst_req_1 : boolean;
  signal type_cast_192_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_req_1 : boolean;
  signal if_stmt_473_branch_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_201_inst_ack_1 : boolean;
  signal next_j_loop_808_576_buf_req_0 : boolean;
  signal ptr_deref_459_store_0_req_1 : boolean;
  signal type_cast_205_inst_req_0 : boolean;
  signal type_cast_205_inst_ack_0 : boolean;
  signal type_cast_205_inst_req_1 : boolean;
  signal type_cast_205_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_914_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_213_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_920_inst_req_0 : boolean;
  signal type_cast_217_inst_req_0 : boolean;
  signal type_cast_217_inst_ack_0 : boolean;
  signal type_cast_488_inst_ack_1 : boolean;
  signal type_cast_217_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_920_inst_ack_1 : boolean;
  signal type_cast_217_inst_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_411_inst_ack_0 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_226_inst_ack_1 : boolean;
  signal type_cast_379_inst_req_1 : boolean;
  signal type_cast_239_inst_req_1 : boolean;
  signal type_cast_239_inst_ack_1 : boolean;
  signal type_cast_985_inst_ack_0 : boolean;
  signal type_cast_451_inst_req_1 : boolean;
  signal type_cast_488_inst_ack_0 : boolean;
  signal type_cast_243_inst_req_0 : boolean;
  signal type_cast_243_inst_ack_0 : boolean;
  signal type_cast_243_inst_req_1 : boolean;
  signal type_cast_243_inst_ack_1 : boolean;
  signal type_cast_1020_inst_ack_0 : boolean;
  signal ptr_deref_459_store_0_ack_0 : boolean;
  signal type_cast_433_inst_ack_1 : boolean;
  signal type_cast_488_inst_req_0 : boolean;
  signal type_cast_247_inst_req_0 : boolean;
  signal type_cast_247_inst_ack_0 : boolean;
  signal type_cast_247_inst_req_1 : boolean;
  signal type_cast_451_inst_ack_0 : boolean;
  signal type_cast_247_inst_ack_1 : boolean;
  signal type_cast_397_inst_ack_1 : boolean;
  signal ptr_deref_459_store_0_req_0 : boolean;
  signal type_cast_899_inst_ack_1 : boolean;
  signal type_cast_946_inst_req_0 : boolean;
  signal call_stmt_484_call_ack_1 : boolean;
  signal call_stmt_484_call_req_1 : boolean;
  signal type_cast_433_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_920_inst_req_1 : boolean;
  signal if_stmt_282_branch_req_0 : boolean;
  signal if_stmt_976_branch_ack_0 : boolean;
  signal if_stmt_282_branch_ack_1 : boolean;
  signal type_cast_899_inst_req_0 : boolean;
  signal if_stmt_282_branch_ack_0 : boolean;
  signal type_cast_909_inst_ack_0 : boolean;
  signal type_cast_899_inst_ack_0 : boolean;
  signal array_obj_ref_1001_index_offset_req_1 : boolean;
  signal array_obj_ref_322_index_offset_req_0 : boolean;
  signal array_obj_ref_322_index_offset_ack_0 : boolean;
  signal array_obj_ref_322_index_offset_req_1 : boolean;
  signal array_obj_ref_322_index_offset_ack_1 : boolean;
  signal array_obj_ref_1001_index_offset_ack_1 : boolean;
  signal addr_of_323_final_reg_req_0 : boolean;
  signal addr_of_323_final_reg_ack_0 : boolean;
  signal addr_of_323_final_reg_req_1 : boolean;
  signal addr_of_323_final_reg_ack_1 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_917_inst_req_0 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_req_1 : boolean;
  signal RPIPE_zeropad_input_pipe_326_inst_ack_1 : boolean;
  signal type_cast_1010_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_917_inst_ack_0 : boolean;
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
  signal type_cast_938_inst_ack_1 : boolean;
  signal type_cast_938_inst_req_1 : boolean;
  signal addr_of_1002_final_reg_ack_0 : boolean;
  signal phi_stmt_581_req_1 : boolean;
  signal phi_stmt_581_req_0 : boolean;
  signal addr_of_1002_final_reg_req_0 : boolean;
  signal phi_stmt_581_ack_0 : boolean;
  signal type_cast_938_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_917_inst_ack_1 : boolean;
  signal next_dest_add_689_584_buf_req_0 : boolean;
  signal next_dest_add_689_584_buf_ack_0 : boolean;
  signal type_cast_938_inst_req_0 : boolean;
  signal next_dest_add_689_584_buf_req_1 : boolean;
  signal next_dest_add_689_584_buf_ack_1 : boolean;
  signal ptr_deref_1006_load_0_ack_1 : boolean;
  signal ptr_deref_1006_load_0_req_1 : boolean;
  signal type_cast_1010_inst_ack_1 : boolean;
  signal phi_stmt_585_req_1 : boolean;
  signal phi_stmt_585_req_0 : boolean;
  signal phi_stmt_585_ack_0 : boolean;
  signal ptr_deref_1006_load_0_ack_0 : boolean;
  signal type_cast_1010_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_932_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_932_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_932_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_932_inst_req_0 : boolean;
  signal next_src_add_694_588_buf_req_0 : boolean;
  signal next_src_add_694_588_buf_ack_0 : boolean;
  signal next_src_add_694_588_buf_req_1 : boolean;
  signal next_src_add_694_588_buf_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_929_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_929_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_929_inst_ack_0 : boolean;
  signal ADD_u16_u16_653_inst_req_0 : boolean;
  signal ADD_u16_u16_653_inst_ack_0 : boolean;
  signal ptr_deref_1006_load_0_req_0 : boolean;
  signal ADD_u16_u16_653_inst_req_1 : boolean;
  signal ADD_u16_u16_653_inst_ack_1 : boolean;
  signal type_cast_879_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_929_inst_req_0 : boolean;
  signal ADD_u16_u16_663_inst_req_0 : boolean;
  signal ADD_u16_u16_663_inst_ack_0 : boolean;
  signal ADD_u16_u16_663_inst_req_1 : boolean;
  signal ADD_u16_u16_663_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_911_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_911_inst_req_1 : boolean;
  signal type_cast_1030_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_926_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_926_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_926_inst_ack_0 : boolean;
  signal type_cast_1030_inst_req_0 : boolean;
  signal type_cast_879_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_926_inst_req_0 : boolean;
  signal array_obj_ref_700_index_offset_req_0 : boolean;
  signal array_obj_ref_700_index_offset_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_911_inst_ack_0 : boolean;
  signal array_obj_ref_700_index_offset_req_1 : boolean;
  signal array_obj_ref_700_index_offset_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_911_inst_req_0 : boolean;
  signal addr_of_701_final_reg_req_0 : boolean;
  signal addr_of_701_final_reg_ack_0 : boolean;
  signal type_cast_879_inst_req_0 : boolean;
  signal addr_of_701_final_reg_req_1 : boolean;
  signal addr_of_701_final_reg_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_923_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_923_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_923_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_923_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_917_inst_req_1 : boolean;
  signal ptr_deref_705_load_0_req_0 : boolean;
  signal ptr_deref_705_load_0_ack_0 : boolean;
  signal ptr_deref_705_load_0_req_1 : boolean;
  signal ptr_deref_705_load_0_ack_1 : boolean;
  signal type_cast_1010_inst_ack_0 : boolean;
  signal type_cast_909_inst_ack_1 : boolean;
  signal type_cast_909_inst_req_1 : boolean;
  signal array_obj_ref_712_index_offset_req_0 : boolean;
  signal array_obj_ref_712_index_offset_ack_0 : boolean;
  signal array_obj_ref_712_index_offset_req_1 : boolean;
  signal array_obj_ref_712_index_offset_ack_1 : boolean;
  signal addr_of_713_final_reg_req_0 : boolean;
  signal addr_of_713_final_reg_ack_0 : boolean;
  signal addr_of_713_final_reg_req_1 : boolean;
  signal addr_of_713_final_reg_ack_1 : boolean;
  signal W_ov_712_delayed_7_0_715_inst_req_0 : boolean;
  signal W_ov_712_delayed_7_0_715_inst_ack_0 : boolean;
  signal W_ov_712_delayed_7_0_715_inst_req_1 : boolean;
  signal W_ov_712_delayed_7_0_715_inst_ack_1 : boolean;
  signal W_data_check_714_delayed_12_0_718_inst_req_0 : boolean;
  signal W_data_check_714_delayed_12_0_718_inst_ack_0 : boolean;
  signal W_data_check_714_delayed_12_0_718_inst_req_1 : boolean;
  signal W_data_check_714_delayed_12_0_718_inst_ack_1 : boolean;
  signal MUX_727_inst_req_0 : boolean;
  signal MUX_727_inst_ack_0 : boolean;
  signal MUX_727_inst_req_1 : boolean;
  signal MUX_727_inst_ack_1 : boolean;
  signal ptr_deref_722_store_0_req_0 : boolean;
  signal ptr_deref_722_store_0_ack_0 : boolean;
  signal ptr_deref_722_store_0_req_1 : boolean;
  signal ptr_deref_722_store_0_ack_1 : boolean;
  signal W_dim2T_dif_727_delayed_1_0_734_inst_req_0 : boolean;
  signal W_dim2T_dif_727_delayed_1_0_734_inst_ack_0 : boolean;
  signal W_dim2T_dif_727_delayed_1_0_734_inst_req_1 : boolean;
  signal W_dim2T_dif_727_delayed_1_0_734_inst_ack_1 : boolean;
  signal W_dim1T_check_2_742_delayed_1_0_752_inst_req_0 : boolean;
  signal W_dim1T_check_2_742_delayed_1_0_752_inst_ack_0 : boolean;
  signal W_dim1T_check_2_742_delayed_1_0_752_inst_req_1 : boolean;
  signal W_dim1T_check_2_742_delayed_1_0_752_inst_ack_1 : boolean;
  signal W_dim0T_check_2_763_delayed_1_0_776_inst_req_0 : boolean;
  signal W_dim0T_check_2_763_delayed_1_0_776_inst_ack_0 : boolean;
  signal W_dim0T_check_2_763_delayed_1_0_776_inst_req_1 : boolean;
  signal W_dim0T_check_2_763_delayed_1_0_776_inst_ack_1 : boolean;
  signal do_while_stmt_567_branch_ack_0 : boolean;
  signal do_while_stmt_567_branch_ack_1 : boolean;
  signal call_stmt_825_call_req_0 : boolean;
  signal call_stmt_825_call_ack_0 : boolean;
  signal call_stmt_825_call_req_1 : boolean;
  signal call_stmt_825_call_ack_1 : boolean;
  signal type_cast_829_inst_req_0 : boolean;
  signal type_cast_829_inst_ack_0 : boolean;
  signal type_cast_829_inst_req_1 : boolean;
  signal type_cast_829_inst_ack_1 : boolean;
  signal type_cast_839_inst_req_0 : boolean;
  signal type_cast_839_inst_ack_0 : boolean;
  signal type_cast_839_inst_req_1 : boolean;
  signal type_cast_839_inst_ack_1 : boolean;
  signal type_cast_849_inst_req_0 : boolean;
  signal type_cast_849_inst_ack_0 : boolean;
  signal type_cast_849_inst_req_1 : boolean;
  signal type_cast_849_inst_ack_1 : boolean;
  signal type_cast_859_inst_req_0 : boolean;
  signal type_cast_859_inst_ack_0 : boolean;
  signal type_cast_859_inst_req_1 : boolean;
  signal type_cast_859_inst_ack_1 : boolean;
  signal type_cast_869_inst_req_0 : boolean;
  signal type_cast_869_inst_ack_0 : boolean;
  signal type_cast_869_inst_req_1 : boolean;
  signal type_cast_869_inst_ack_1 : boolean;
  signal type_cast_1040_inst_req_0 : boolean;
  signal type_cast_1040_inst_ack_0 : boolean;
  signal type_cast_1040_inst_req_1 : boolean;
  signal type_cast_1040_inst_ack_1 : boolean;
  signal type_cast_1050_inst_req_0 : boolean;
  signal type_cast_1050_inst_ack_0 : boolean;
  signal type_cast_1050_inst_req_1 : boolean;
  signal type_cast_1050_inst_ack_1 : boolean;
  signal type_cast_1060_inst_req_0 : boolean;
  signal type_cast_1060_inst_ack_0 : boolean;
  signal type_cast_1060_inst_req_1 : boolean;
  signal type_cast_1060_inst_ack_1 : boolean;
  signal type_cast_1070_inst_req_0 : boolean;
  signal type_cast_1070_inst_ack_0 : boolean;
  signal type_cast_1070_inst_req_1 : boolean;
  signal type_cast_1070_inst_ack_1 : boolean;
  signal type_cast_1080_inst_req_0 : boolean;
  signal type_cast_1080_inst_ack_0 : boolean;
  signal type_cast_1080_inst_req_1 : boolean;
  signal type_cast_1080_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1082_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1082_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1082_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1082_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1085_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1085_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1085_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1085_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1088_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1088_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1088_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1088_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1091_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1091_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1091_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1091_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1094_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1094_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1094_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1094_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1097_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1097_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1097_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1097_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1100_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1100_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1100_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1100_inst_ack_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1103_inst_req_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1103_inst_ack_0 : boolean;
  signal WPIPE_zeropad_output_pipe_1103_inst_req_1 : boolean;
  signal WPIPE_zeropad_output_pipe_1103_inst_ack_1 : boolean;
  signal if_stmt_1117_branch_req_0 : boolean;
  signal if_stmt_1117_branch_ack_1 : boolean;
  signal if_stmt_1117_branch_ack_0 : boolean;
  signal phi_stmt_310_req_0 : boolean;
  signal type_cast_316_inst_req_0 : boolean;
  signal type_cast_316_inst_ack_0 : boolean;
  signal type_cast_316_inst_req_1 : boolean;
  signal type_cast_316_inst_ack_1 : boolean;
  signal phi_stmt_310_req_1 : boolean;
  signal phi_stmt_310_ack_0 : boolean;
  signal phi_stmt_989_req_0 : boolean;
  signal type_cast_995_inst_req_0 : boolean;
  signal type_cast_995_inst_ack_0 : boolean;
  signal type_cast_995_inst_req_1 : boolean;
  signal type_cast_995_inst_ack_1 : boolean;
  signal phi_stmt_989_req_1 : boolean;
  signal phi_stmt_989_ack_0 : boolean;
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
    signal zeropad3D_CP_182_elements: BooleanArray(404 downto 0);
    -- 
  begin -- 
    zeropad3D_CP_182_elements(0) <= zeropad3D_CP_182_start;
    zeropad3D_CP_182_symbol <= zeropad3D_CP_182_elements(404);
    -- CP-element group 0:  fork  transition  place  output  bypass 
    -- CP-element group 0: predecessors 
    -- CP-element group 0: successors 
    -- CP-element group 0: 	45 
    -- CP-element group 0: 	49 
    -- CP-element group 0: 	53 
    -- CP-element group 0: 	57 
    -- CP-element group 0: 	61 
    -- CP-element group 0: 	41 
    -- CP-element group 0: 	37 
    -- CP-element group 0: 	65 
    -- CP-element group 0: 	68 
    -- CP-element group 0: 	71 
    -- CP-element group 0: 	74 
    -- CP-element group 0: 	2 
    -- CP-element group 0: 	13 
    -- CP-element group 0: 	17 
    -- CP-element group 0: 	21 
    -- CP-element group 0: 	25 
    -- CP-element group 0: 	29 
    -- CP-element group 0: 	33 
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
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/cr
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_update_start_
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/$entry
      -- CP-element group 0: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/cr
      -- 
    rr_250_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_250_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => RPIPE_zeropad_input_pipe_51_inst_req_0); -- 
    cr_689_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_689_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_230_inst_req_1); -- 
    cr_325_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_325_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_67_inst_req_1); -- 
    cr_353_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_353_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_80_inst_req_1); -- 
    cr_381_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_381_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_92_inst_req_1); -- 
    cr_409_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_409_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_105_inst_req_1); -- 
    cr_437_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_437_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_117_inst_req_1); -- 
    cr_465_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_465_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_130_inst_req_1); -- 
    cr_493_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_493_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_142_inst_req_1); -- 
    cr_521_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_521_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_155_inst_req_1); -- 
    cr_549_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_549_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_167_inst_req_1); -- 
    cr_577_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_577_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_180_inst_req_1); -- 
    cr_605_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_605_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_192_inst_req_1); -- 
    cr_633_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_633_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_205_inst_req_1); -- 
    cr_661_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_661_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_217_inst_req_1); -- 
    cr_703_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_703_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_239_inst_req_1); -- 
    cr_717_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_717_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_243_inst_req_1); -- 
    cr_731_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_731_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(0), ack => type_cast_247_inst_req_1); -- 
    -- CP-element group 1:  fork  transition  place  output  bypass 
    -- CP-element group 1: predecessors 
    -- CP-element group 1: 	288 
    -- CP-element group 1: successors 
    -- CP-element group 1: 	289 
    -- CP-element group 1: 	290 
    -- CP-element group 1: 	292 
    -- CP-element group 1:  members (12) 
      -- CP-element group 1: 	 branch_block_stmt_49/do_while_stmt_567__exit__
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835__entry__
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/$entry
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_sample_start_
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_update_start_
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Sample/$entry
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Sample/crr
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Update/$entry
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Update/ccr
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_update_start_
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Update/$entry
      -- CP-element group 1: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Update/cr
      -- 
    crr_1698_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_1698_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(1), ack => call_stmt_825_call_req_0); -- 
    ccr_1703_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_1703_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(1), ack => call_stmt_825_call_req_1); -- 
    cr_1717_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1717_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(1), ack => type_cast_829_inst_req_1); -- 
    zeropad3D_CP_182_elements(1) <= zeropad3D_CP_182_elements(288);
    -- CP-element group 2:  transition  input  output  bypass 
    -- CP-element group 2: predecessors 
    -- CP-element group 2: 	0 
    -- CP-element group 2: successors 
    -- CP-element group 2: 	3 
    -- CP-element group 2:  members (6) 
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_sample_completed_
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_update_start_
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/$exit
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Sample/ra
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/$entry
      -- CP-element group 2: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/cr
      -- 
    ra_251_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 2_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_51_inst_ack_0, ack => zeropad3D_CP_182_elements(2)); -- 
    cr_255_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_255_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(2), ack => RPIPE_zeropad_input_pipe_51_inst_req_1); -- 
    -- CP-element group 3:  transition  input  output  bypass 
    -- CP-element group 3: predecessors 
    -- CP-element group 3: 	2 
    -- CP-element group 3: successors 
    -- CP-element group 3: 	4 
    -- CP-element group 3:  members (6) 
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_update_completed_
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/$exit
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_51_Update/ca
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_sample_start_
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/$entry
      -- CP-element group 3: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/rr
      -- 
    ca_256_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 3_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_51_inst_ack_1, ack => zeropad3D_CP_182_elements(3)); -- 
    rr_264_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_264_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(3), ack => RPIPE_zeropad_input_pipe_54_inst_req_0); -- 
    -- CP-element group 4:  transition  input  output  bypass 
    -- CP-element group 4: predecessors 
    -- CP-element group 4: 	3 
    -- CP-element group 4: successors 
    -- CP-element group 4: 	5 
    -- CP-element group 4:  members (6) 
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_sample_completed_
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_update_start_
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/$exit
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Sample/ra
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/$entry
      -- CP-element group 4: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/cr
      -- 
    ra_265_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 4_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_54_inst_ack_0, ack => zeropad3D_CP_182_elements(4)); -- 
    cr_269_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_269_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(4), ack => RPIPE_zeropad_input_pipe_54_inst_req_1); -- 
    -- CP-element group 5:  transition  input  output  bypass 
    -- CP-element group 5: predecessors 
    -- CP-element group 5: 	4 
    -- CP-element group 5: successors 
    -- CP-element group 5: 	6 
    -- CP-element group 5:  members (6) 
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_sample_start_
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/$entry
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/rr
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_update_completed_
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/$exit
      -- CP-element group 5: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_54_Update/ca
      -- 
    ca_270_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 5_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_54_inst_ack_1, ack => zeropad3D_CP_182_elements(5)); -- 
    rr_278_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_278_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(5), ack => RPIPE_zeropad_input_pipe_57_inst_req_0); -- 
    -- CP-element group 6:  transition  input  output  bypass 
    -- CP-element group 6: predecessors 
    -- CP-element group 6: 	5 
    -- CP-element group 6: successors 
    -- CP-element group 6: 	7 
    -- CP-element group 6:  members (6) 
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_sample_completed_
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_update_start_
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/$exit
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Sample/ra
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/$entry
      -- CP-element group 6: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/cr
      -- 
    ra_279_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 6_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_57_inst_ack_0, ack => zeropad3D_CP_182_elements(6)); -- 
    cr_283_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_283_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(6), ack => RPIPE_zeropad_input_pipe_57_inst_req_1); -- 
    -- CP-element group 7:  transition  input  output  bypass 
    -- CP-element group 7: predecessors 
    -- CP-element group 7: 	6 
    -- CP-element group 7: successors 
    -- CP-element group 7: 	8 
    -- CP-element group 7:  members (6) 
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_update_completed_
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/$exit
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_57_Update/ca
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_sample_start_
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/$entry
      -- CP-element group 7: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/rr
      -- 
    ca_284_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 7_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_57_inst_ack_1, ack => zeropad3D_CP_182_elements(7)); -- 
    rr_292_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_292_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(7), ack => RPIPE_zeropad_input_pipe_60_inst_req_0); -- 
    -- CP-element group 8:  transition  input  output  bypass 
    -- CP-element group 8: predecessors 
    -- CP-element group 8: 	7 
    -- CP-element group 8: successors 
    -- CP-element group 8: 	9 
    -- CP-element group 8:  members (6) 
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_sample_completed_
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_update_start_
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/$exit
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Sample/ra
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/$entry
      -- CP-element group 8: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/cr
      -- 
    ra_293_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 8_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_60_inst_ack_0, ack => zeropad3D_CP_182_elements(8)); -- 
    cr_297_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_297_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(8), ack => RPIPE_zeropad_input_pipe_60_inst_req_1); -- 
    -- CP-element group 9:  transition  input  output  bypass 
    -- CP-element group 9: predecessors 
    -- CP-element group 9: 	8 
    -- CP-element group 9: successors 
    -- CP-element group 9: 	10 
    -- CP-element group 9:  members (6) 
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_update_completed_
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/$exit
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_60_Update/ca
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_sample_start_
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/$entry
      -- CP-element group 9: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/rr
      -- 
    ca_298_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 9_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_60_inst_ack_1, ack => zeropad3D_CP_182_elements(9)); -- 
    rr_306_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_306_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(9), ack => RPIPE_zeropad_input_pipe_63_inst_req_0); -- 
    -- CP-element group 10:  transition  input  output  bypass 
    -- CP-element group 10: predecessors 
    -- CP-element group 10: 	9 
    -- CP-element group 10: successors 
    -- CP-element group 10: 	11 
    -- CP-element group 10:  members (6) 
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_sample_completed_
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_update_start_
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/$exit
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Sample/ra
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/$entry
      -- CP-element group 10: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/cr
      -- 
    ra_307_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 10_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_63_inst_ack_0, ack => zeropad3D_CP_182_elements(10)); -- 
    cr_311_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_311_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(10), ack => RPIPE_zeropad_input_pipe_63_inst_req_1); -- 
    -- CP-element group 11:  fork  transition  input  output  bypass 
    -- CP-element group 11: predecessors 
    -- CP-element group 11: 	10 
    -- CP-element group 11: successors 
    -- CP-element group 11: 	12 
    -- CP-element group 11: 	14 
    -- CP-element group 11:  members (9) 
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_update_completed_
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/$exit
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_63_Update/ca
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_sample_start_
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/$entry
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/rr
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_sample_start_
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/$entry
      -- CP-element group 11: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/rr
      -- 
    ca_312_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 11_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_63_inst_ack_1, ack => zeropad3D_CP_182_elements(11)); -- 
    rr_320_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_320_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(11), ack => type_cast_67_inst_req_0); -- 
    rr_334_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_334_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(11), ack => RPIPE_zeropad_input_pipe_76_inst_req_0); -- 
    -- CP-element group 12:  transition  input  bypass 
    -- CP-element group 12: predecessors 
    -- CP-element group 12: 	11 
    -- CP-element group 12: successors 
    -- CP-element group 12:  members (3) 
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_sample_completed_
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/$exit
      -- CP-element group 12: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Sample/ra
      -- 
    ra_321_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 12_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_67_inst_ack_0, ack => zeropad3D_CP_182_elements(12)); -- 
    -- CP-element group 13:  transition  input  bypass 
    -- CP-element group 13: predecessors 
    -- CP-element group 13: 	0 
    -- CP-element group 13: successors 
    -- CP-element group 13: 	66 
    -- CP-element group 13:  members (3) 
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_update_completed_
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/$exit
      -- CP-element group 13: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_67_Update/ca
      -- 
    ca_326_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 13_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_67_inst_ack_1, ack => zeropad3D_CP_182_elements(13)); -- 
    -- CP-element group 14:  transition  input  output  bypass 
    -- CP-element group 14: predecessors 
    -- CP-element group 14: 	11 
    -- CP-element group 14: successors 
    -- CP-element group 14: 	15 
    -- CP-element group 14:  members (6) 
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_sample_completed_
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_update_start_
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/$exit
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Sample/ra
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/$entry
      -- CP-element group 14: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/cr
      -- 
    ra_335_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 14_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_76_inst_ack_0, ack => zeropad3D_CP_182_elements(14)); -- 
    cr_339_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_339_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(14), ack => RPIPE_zeropad_input_pipe_76_inst_req_1); -- 
    -- CP-element group 15:  fork  transition  input  output  bypass 
    -- CP-element group 15: predecessors 
    -- CP-element group 15: 	14 
    -- CP-element group 15: successors 
    -- CP-element group 15: 	16 
    -- CP-element group 15: 	18 
    -- CP-element group 15:  members (9) 
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_update_completed_
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/$exit
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_76_Update/ca
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_sample_start_
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/$entry
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/rr
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_sample_start_
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/$entry
      -- CP-element group 15: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/rr
      -- 
    ca_340_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 15_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_76_inst_ack_1, ack => zeropad3D_CP_182_elements(15)); -- 
    rr_348_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_348_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(15), ack => type_cast_80_inst_req_0); -- 
    rr_362_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_362_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(15), ack => RPIPE_zeropad_input_pipe_88_inst_req_0); -- 
    -- CP-element group 16:  transition  input  bypass 
    -- CP-element group 16: predecessors 
    -- CP-element group 16: 	15 
    -- CP-element group 16: successors 
    -- CP-element group 16:  members (3) 
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_sample_completed_
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/$exit
      -- CP-element group 16: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Sample/ra
      -- 
    ra_349_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 16_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_80_inst_ack_0, ack => zeropad3D_CP_182_elements(16)); -- 
    -- CP-element group 17:  transition  input  bypass 
    -- CP-element group 17: predecessors 
    -- CP-element group 17: 	0 
    -- CP-element group 17: successors 
    -- CP-element group 17: 	66 
    -- CP-element group 17:  members (3) 
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_update_completed_
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/$exit
      -- CP-element group 17: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_80_Update/ca
      -- 
    ca_354_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 17_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_80_inst_ack_1, ack => zeropad3D_CP_182_elements(17)); -- 
    -- CP-element group 18:  transition  input  output  bypass 
    -- CP-element group 18: predecessors 
    -- CP-element group 18: 	15 
    -- CP-element group 18: successors 
    -- CP-element group 18: 	19 
    -- CP-element group 18:  members (6) 
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_sample_completed_
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_update_start_
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/$exit
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Sample/ra
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/$entry
      -- CP-element group 18: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/cr
      -- 
    ra_363_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 18_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_88_inst_ack_0, ack => zeropad3D_CP_182_elements(18)); -- 
    cr_367_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_367_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(18), ack => RPIPE_zeropad_input_pipe_88_inst_req_1); -- 
    -- CP-element group 19:  fork  transition  input  output  bypass 
    -- CP-element group 19: predecessors 
    -- CP-element group 19: 	18 
    -- CP-element group 19: successors 
    -- CP-element group 19: 	20 
    -- CP-element group 19: 	22 
    -- CP-element group 19:  members (9) 
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_update_completed_
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/$exit
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_88_Update/ca
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_sample_start_
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/$entry
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/rr
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_sample_start_
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/$entry
      -- CP-element group 19: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/rr
      -- 
    ca_368_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 19_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_88_inst_ack_1, ack => zeropad3D_CP_182_elements(19)); -- 
    rr_376_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_376_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(19), ack => type_cast_92_inst_req_0); -- 
    rr_390_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_390_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(19), ack => RPIPE_zeropad_input_pipe_101_inst_req_0); -- 
    -- CP-element group 20:  transition  input  bypass 
    -- CP-element group 20: predecessors 
    -- CP-element group 20: 	19 
    -- CP-element group 20: successors 
    -- CP-element group 20:  members (3) 
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_sample_completed_
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/$exit
      -- CP-element group 20: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Sample/ra
      -- 
    ra_377_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 20_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_92_inst_ack_0, ack => zeropad3D_CP_182_elements(20)); -- 
    -- CP-element group 21:  transition  input  bypass 
    -- CP-element group 21: predecessors 
    -- CP-element group 21: 	0 
    -- CP-element group 21: successors 
    -- CP-element group 21: 	69 
    -- CP-element group 21:  members (3) 
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_update_completed_
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/$exit
      -- CP-element group 21: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_92_Update/ca
      -- 
    ca_382_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 21_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_92_inst_ack_1, ack => zeropad3D_CP_182_elements(21)); -- 
    -- CP-element group 22:  transition  input  output  bypass 
    -- CP-element group 22: predecessors 
    -- CP-element group 22: 	19 
    -- CP-element group 22: successors 
    -- CP-element group 22: 	23 
    -- CP-element group 22:  members (6) 
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_sample_completed_
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_update_start_
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/$exit
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Sample/ra
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/$entry
      -- CP-element group 22: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/cr
      -- 
    ra_391_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 22_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_101_inst_ack_0, ack => zeropad3D_CP_182_elements(22)); -- 
    cr_395_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_395_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(22), ack => RPIPE_zeropad_input_pipe_101_inst_req_1); -- 
    -- CP-element group 23:  fork  transition  input  output  bypass 
    -- CP-element group 23: predecessors 
    -- CP-element group 23: 	22 
    -- CP-element group 23: successors 
    -- CP-element group 23: 	24 
    -- CP-element group 23: 	26 
    -- CP-element group 23:  members (9) 
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_update_completed_
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/$exit
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_101_Update/ca
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_sample_start_
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/$entry
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/rr
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_sample_start_
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/$entry
      -- CP-element group 23: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/rr
      -- 
    ca_396_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 23_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_101_inst_ack_1, ack => zeropad3D_CP_182_elements(23)); -- 
    rr_404_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_404_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(23), ack => type_cast_105_inst_req_0); -- 
    rr_418_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_418_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(23), ack => RPIPE_zeropad_input_pipe_113_inst_req_0); -- 
    -- CP-element group 24:  transition  input  bypass 
    -- CP-element group 24: predecessors 
    -- CP-element group 24: 	23 
    -- CP-element group 24: successors 
    -- CP-element group 24:  members (3) 
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_sample_completed_
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/$exit
      -- CP-element group 24: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Sample/ra
      -- 
    ra_405_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 24_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_105_inst_ack_0, ack => zeropad3D_CP_182_elements(24)); -- 
    -- CP-element group 25:  transition  input  bypass 
    -- CP-element group 25: predecessors 
    -- CP-element group 25: 	0 
    -- CP-element group 25: successors 
    -- CP-element group 25: 	69 
    -- CP-element group 25:  members (3) 
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_update_completed_
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/$exit
      -- CP-element group 25: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_105_Update/ca
      -- 
    ca_410_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 25_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_105_inst_ack_1, ack => zeropad3D_CP_182_elements(25)); -- 
    -- CP-element group 26:  transition  input  output  bypass 
    -- CP-element group 26: predecessors 
    -- CP-element group 26: 	23 
    -- CP-element group 26: successors 
    -- CP-element group 26: 	27 
    -- CP-element group 26:  members (6) 
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_sample_completed_
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_update_start_
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/$exit
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Sample/ra
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/$entry
      -- CP-element group 26: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/cr
      -- 
    ra_419_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 26_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_113_inst_ack_0, ack => zeropad3D_CP_182_elements(26)); -- 
    cr_423_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_423_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(26), ack => RPIPE_zeropad_input_pipe_113_inst_req_1); -- 
    -- CP-element group 27:  fork  transition  input  output  bypass 
    -- CP-element group 27: predecessors 
    -- CP-element group 27: 	26 
    -- CP-element group 27: successors 
    -- CP-element group 27: 	28 
    -- CP-element group 27: 	30 
    -- CP-element group 27:  members (9) 
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_update_completed_
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/$exit
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_113_Update/ca
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_sample_start_
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/$entry
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/rr
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_sample_start_
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/$entry
      -- CP-element group 27: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/rr
      -- 
    ca_424_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 27_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_113_inst_ack_1, ack => zeropad3D_CP_182_elements(27)); -- 
    rr_432_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_432_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(27), ack => type_cast_117_inst_req_0); -- 
    rr_446_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_446_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(27), ack => RPIPE_zeropad_input_pipe_126_inst_req_0); -- 
    -- CP-element group 28:  transition  input  bypass 
    -- CP-element group 28: predecessors 
    -- CP-element group 28: 	27 
    -- CP-element group 28: successors 
    -- CP-element group 28:  members (3) 
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_sample_completed_
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/$exit
      -- CP-element group 28: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Sample/ra
      -- 
    ra_433_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 28_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_117_inst_ack_0, ack => zeropad3D_CP_182_elements(28)); -- 
    -- CP-element group 29:  transition  input  bypass 
    -- CP-element group 29: predecessors 
    -- CP-element group 29: 	0 
    -- CP-element group 29: successors 
    -- CP-element group 29: 	72 
    -- CP-element group 29:  members (3) 
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_update_completed_
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/$exit
      -- CP-element group 29: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_117_Update/ca
      -- 
    ca_438_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 29_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_117_inst_ack_1, ack => zeropad3D_CP_182_elements(29)); -- 
    -- CP-element group 30:  transition  input  output  bypass 
    -- CP-element group 30: predecessors 
    -- CP-element group 30: 	27 
    -- CP-element group 30: successors 
    -- CP-element group 30: 	31 
    -- CP-element group 30:  members (6) 
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_sample_completed_
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_update_start_
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/$exit
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Sample/ra
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/$entry
      -- CP-element group 30: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/cr
      -- 
    ra_447_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 30_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_126_inst_ack_0, ack => zeropad3D_CP_182_elements(30)); -- 
    cr_451_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_451_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(30), ack => RPIPE_zeropad_input_pipe_126_inst_req_1); -- 
    -- CP-element group 31:  fork  transition  input  output  bypass 
    -- CP-element group 31: predecessors 
    -- CP-element group 31: 	30 
    -- CP-element group 31: successors 
    -- CP-element group 31: 	34 
    -- CP-element group 31: 	32 
    -- CP-element group 31:  members (9) 
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_update_completed_
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/$exit
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_126_Update/ca
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_sample_start_
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/$entry
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/rr
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_sample_start_
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/$entry
      -- CP-element group 31: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/rr
      -- 
    ca_452_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 31_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_126_inst_ack_1, ack => zeropad3D_CP_182_elements(31)); -- 
    rr_460_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_460_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(31), ack => type_cast_130_inst_req_0); -- 
    rr_474_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_474_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(31), ack => RPIPE_zeropad_input_pipe_138_inst_req_0); -- 
    -- CP-element group 32:  transition  input  bypass 
    -- CP-element group 32: predecessors 
    -- CP-element group 32: 	31 
    -- CP-element group 32: successors 
    -- CP-element group 32:  members (3) 
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_sample_completed_
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/$exit
      -- CP-element group 32: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Sample/ra
      -- 
    ra_461_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 32_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_130_inst_ack_0, ack => zeropad3D_CP_182_elements(32)); -- 
    -- CP-element group 33:  transition  input  bypass 
    -- CP-element group 33: predecessors 
    -- CP-element group 33: 	0 
    -- CP-element group 33: successors 
    -- CP-element group 33: 	72 
    -- CP-element group 33:  members (3) 
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_update_completed_
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/$exit
      -- CP-element group 33: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_130_Update/ca
      -- 
    ca_466_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 33_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_130_inst_ack_1, ack => zeropad3D_CP_182_elements(33)); -- 
    -- CP-element group 34:  transition  input  output  bypass 
    -- CP-element group 34: predecessors 
    -- CP-element group 34: 	31 
    -- CP-element group 34: successors 
    -- CP-element group 34: 	35 
    -- CP-element group 34:  members (6) 
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_sample_completed_
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_update_start_
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/$exit
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Sample/ra
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/$entry
      -- CP-element group 34: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/cr
      -- 
    ra_475_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 34_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_138_inst_ack_0, ack => zeropad3D_CP_182_elements(34)); -- 
    cr_479_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_479_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(34), ack => RPIPE_zeropad_input_pipe_138_inst_req_1); -- 
    -- CP-element group 35:  fork  transition  input  output  bypass 
    -- CP-element group 35: predecessors 
    -- CP-element group 35: 	34 
    -- CP-element group 35: successors 
    -- CP-element group 35: 	36 
    -- CP-element group 35: 	38 
    -- CP-element group 35:  members (9) 
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_update_completed_
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/$exit
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_138_Update/ca
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_sample_start_
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/$entry
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/rr
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_sample_start_
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/$entry
      -- CP-element group 35: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/rr
      -- 
    ca_480_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 35_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_138_inst_ack_1, ack => zeropad3D_CP_182_elements(35)); -- 
    rr_502_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_502_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(35), ack => RPIPE_zeropad_input_pipe_151_inst_req_0); -- 
    rr_488_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_488_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(35), ack => type_cast_142_inst_req_0); -- 
    -- CP-element group 36:  transition  input  bypass 
    -- CP-element group 36: predecessors 
    -- CP-element group 36: 	35 
    -- CP-element group 36: successors 
    -- CP-element group 36:  members (3) 
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_sample_completed_
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/$exit
      -- CP-element group 36: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Sample/ra
      -- 
    ra_489_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 36_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_142_inst_ack_0, ack => zeropad3D_CP_182_elements(36)); -- 
    -- CP-element group 37:  transition  input  bypass 
    -- CP-element group 37: predecessors 
    -- CP-element group 37: 	0 
    -- CP-element group 37: successors 
    -- CP-element group 37: 	75 
    -- CP-element group 37:  members (3) 
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_update_completed_
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/$exit
      -- CP-element group 37: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_142_Update/ca
      -- 
    ca_494_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 37_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_142_inst_ack_1, ack => zeropad3D_CP_182_elements(37)); -- 
    -- CP-element group 38:  transition  input  output  bypass 
    -- CP-element group 38: predecessors 
    -- CP-element group 38: 	35 
    -- CP-element group 38: successors 
    -- CP-element group 38: 	39 
    -- CP-element group 38:  members (6) 
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_sample_completed_
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_update_start_
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/$exit
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Sample/ra
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/$entry
      -- CP-element group 38: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/cr
      -- 
    ra_503_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 38_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_151_inst_ack_0, ack => zeropad3D_CP_182_elements(38)); -- 
    cr_507_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_507_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(38), ack => RPIPE_zeropad_input_pipe_151_inst_req_1); -- 
    -- CP-element group 39:  fork  transition  input  output  bypass 
    -- CP-element group 39: predecessors 
    -- CP-element group 39: 	38 
    -- CP-element group 39: successors 
    -- CP-element group 39: 	40 
    -- CP-element group 39: 	42 
    -- CP-element group 39:  members (9) 
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_update_completed_
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/$exit
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_151_Update/ca
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_sample_start_
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/$entry
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/rr
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_sample_start_
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/$entry
      -- CP-element group 39: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/rr
      -- 
    ca_508_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 39_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_151_inst_ack_1, ack => zeropad3D_CP_182_elements(39)); -- 
    rr_516_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_516_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(39), ack => type_cast_155_inst_req_0); -- 
    rr_530_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_530_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(39), ack => RPIPE_zeropad_input_pipe_163_inst_req_0); -- 
    -- CP-element group 40:  transition  input  bypass 
    -- CP-element group 40: predecessors 
    -- CP-element group 40: 	39 
    -- CP-element group 40: successors 
    -- CP-element group 40:  members (3) 
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_sample_completed_
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/$exit
      -- CP-element group 40: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Sample/ra
      -- 
    ra_517_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 40_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_155_inst_ack_0, ack => zeropad3D_CP_182_elements(40)); -- 
    -- CP-element group 41:  transition  input  bypass 
    -- CP-element group 41: predecessors 
    -- CP-element group 41: 	0 
    -- CP-element group 41: successors 
    -- CP-element group 41: 	75 
    -- CP-element group 41:  members (3) 
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_update_completed_
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/$exit
      -- CP-element group 41: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_155_Update/ca
      -- 
    ca_522_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 41_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_155_inst_ack_1, ack => zeropad3D_CP_182_elements(41)); -- 
    -- CP-element group 42:  transition  input  output  bypass 
    -- CP-element group 42: predecessors 
    -- CP-element group 42: 	39 
    -- CP-element group 42: successors 
    -- CP-element group 42: 	43 
    -- CP-element group 42:  members (6) 
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_sample_completed_
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_update_start_
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/$exit
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Sample/ra
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/$entry
      -- CP-element group 42: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/cr
      -- 
    ra_531_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 42_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_163_inst_ack_0, ack => zeropad3D_CP_182_elements(42)); -- 
    cr_535_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_535_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(42), ack => RPIPE_zeropad_input_pipe_163_inst_req_1); -- 
    -- CP-element group 43:  fork  transition  input  output  bypass 
    -- CP-element group 43: predecessors 
    -- CP-element group 43: 	42 
    -- CP-element group 43: successors 
    -- CP-element group 43: 	44 
    -- CP-element group 43: 	46 
    -- CP-element group 43:  members (9) 
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_update_completed_
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/$exit
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_163_Update/ca
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_sample_start_
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/$entry
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/rr
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_sample_start_
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/$entry
      -- CP-element group 43: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/rr
      -- 
    ca_536_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 43_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_163_inst_ack_1, ack => zeropad3D_CP_182_elements(43)); -- 
    rr_544_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_544_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(43), ack => type_cast_167_inst_req_0); -- 
    rr_558_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_558_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(43), ack => RPIPE_zeropad_input_pipe_176_inst_req_0); -- 
    -- CP-element group 44:  transition  input  bypass 
    -- CP-element group 44: predecessors 
    -- CP-element group 44: 	43 
    -- CP-element group 44: successors 
    -- CP-element group 44:  members (3) 
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_sample_completed_
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/$exit
      -- CP-element group 44: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Sample/ra
      -- 
    ra_545_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 44_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_167_inst_ack_0, ack => zeropad3D_CP_182_elements(44)); -- 
    -- CP-element group 45:  transition  input  bypass 
    -- CP-element group 45: predecessors 
    -- CP-element group 45: 	0 
    -- CP-element group 45: successors 
    -- CP-element group 45: 	75 
    -- CP-element group 45:  members (3) 
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_update_completed_
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/$exit
      -- CP-element group 45: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_167_Update/ca
      -- 
    ca_550_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 45_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_167_inst_ack_1, ack => zeropad3D_CP_182_elements(45)); -- 
    -- CP-element group 46:  transition  input  output  bypass 
    -- CP-element group 46: predecessors 
    -- CP-element group 46: 	43 
    -- CP-element group 46: successors 
    -- CP-element group 46: 	47 
    -- CP-element group 46:  members (6) 
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_sample_completed_
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_update_start_
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/$exit
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Sample/ra
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/$entry
      -- CP-element group 46: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/cr
      -- 
    ra_559_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 46_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_176_inst_ack_0, ack => zeropad3D_CP_182_elements(46)); -- 
    cr_563_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_563_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(46), ack => RPIPE_zeropad_input_pipe_176_inst_req_1); -- 
    -- CP-element group 47:  fork  transition  input  output  bypass 
    -- CP-element group 47: predecessors 
    -- CP-element group 47: 	46 
    -- CP-element group 47: successors 
    -- CP-element group 47: 	48 
    -- CP-element group 47: 	50 
    -- CP-element group 47:  members (9) 
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_update_completed_
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/$exit
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_176_Update/ca
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_sample_start_
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/$entry
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/rr
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_sample_start_
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/$entry
      -- CP-element group 47: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/rr
      -- 
    ca_564_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 47_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_176_inst_ack_1, ack => zeropad3D_CP_182_elements(47)); -- 
    rr_572_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_572_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(47), ack => type_cast_180_inst_req_0); -- 
    rr_586_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_586_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(47), ack => RPIPE_zeropad_input_pipe_188_inst_req_0); -- 
    -- CP-element group 48:  transition  input  bypass 
    -- CP-element group 48: predecessors 
    -- CP-element group 48: 	47 
    -- CP-element group 48: successors 
    -- CP-element group 48:  members (3) 
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_sample_completed_
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/$exit
      -- CP-element group 48: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Sample/ra
      -- 
    ra_573_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 48_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_180_inst_ack_0, ack => zeropad3D_CP_182_elements(48)); -- 
    -- CP-element group 49:  transition  input  bypass 
    -- CP-element group 49: predecessors 
    -- CP-element group 49: 	0 
    -- CP-element group 49: successors 
    -- CP-element group 49: 	75 
    -- CP-element group 49:  members (3) 
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_update_completed_
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/$exit
      -- CP-element group 49: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_180_Update/ca
      -- 
    ca_578_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 49_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_180_inst_ack_1, ack => zeropad3D_CP_182_elements(49)); -- 
    -- CP-element group 50:  transition  input  output  bypass 
    -- CP-element group 50: predecessors 
    -- CP-element group 50: 	47 
    -- CP-element group 50: successors 
    -- CP-element group 50: 	51 
    -- CP-element group 50:  members (6) 
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_sample_completed_
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_update_start_
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/$exit
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Sample/ra
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/$entry
      -- CP-element group 50: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/cr
      -- 
    ra_587_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 50_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_188_inst_ack_0, ack => zeropad3D_CP_182_elements(50)); -- 
    cr_591_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_591_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(50), ack => RPIPE_zeropad_input_pipe_188_inst_req_1); -- 
    -- CP-element group 51:  fork  transition  input  output  bypass 
    -- CP-element group 51: predecessors 
    -- CP-element group 51: 	50 
    -- CP-element group 51: successors 
    -- CP-element group 51: 	52 
    -- CP-element group 51: 	54 
    -- CP-element group 51:  members (9) 
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_update_completed_
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/$exit
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_188_Update/ca
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_sample_start_
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/$entry
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/rr
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_sample_start_
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/$entry
      -- CP-element group 51: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/rr
      -- 
    ca_592_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 51_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_188_inst_ack_1, ack => zeropad3D_CP_182_elements(51)); -- 
    rr_600_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_600_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(51), ack => type_cast_192_inst_req_0); -- 
    rr_614_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_614_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(51), ack => RPIPE_zeropad_input_pipe_201_inst_req_0); -- 
    -- CP-element group 52:  transition  input  bypass 
    -- CP-element group 52: predecessors 
    -- CP-element group 52: 	51 
    -- CP-element group 52: successors 
    -- CP-element group 52:  members (3) 
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_sample_completed_
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/$exit
      -- CP-element group 52: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Sample/ra
      -- 
    ra_601_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 52_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_192_inst_ack_0, ack => zeropad3D_CP_182_elements(52)); -- 
    -- CP-element group 53:  transition  input  bypass 
    -- CP-element group 53: predecessors 
    -- CP-element group 53: 	0 
    -- CP-element group 53: successors 
    -- CP-element group 53: 	75 
    -- CP-element group 53:  members (3) 
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_update_completed_
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/$exit
      -- CP-element group 53: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_192_Update/ca
      -- 
    ca_606_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 53_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_192_inst_ack_1, ack => zeropad3D_CP_182_elements(53)); -- 
    -- CP-element group 54:  transition  input  output  bypass 
    -- CP-element group 54: predecessors 
    -- CP-element group 54: 	51 
    -- CP-element group 54: successors 
    -- CP-element group 54: 	55 
    -- CP-element group 54:  members (6) 
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_sample_completed_
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_update_start_
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/$exit
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Sample/ra
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/$entry
      -- CP-element group 54: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/cr
      -- 
    ra_615_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 54_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_201_inst_ack_0, ack => zeropad3D_CP_182_elements(54)); -- 
    cr_619_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_619_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(54), ack => RPIPE_zeropad_input_pipe_201_inst_req_1); -- 
    -- CP-element group 55:  fork  transition  input  output  bypass 
    -- CP-element group 55: predecessors 
    -- CP-element group 55: 	54 
    -- CP-element group 55: successors 
    -- CP-element group 55: 	56 
    -- CP-element group 55: 	58 
    -- CP-element group 55:  members (9) 
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_update_completed_
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/$exit
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_201_Update/ca
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_sample_start_
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/$entry
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/rr
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_sample_start_
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/$entry
      -- CP-element group 55: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/rr
      -- 
    ca_620_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 55_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_201_inst_ack_1, ack => zeropad3D_CP_182_elements(55)); -- 
    rr_628_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_628_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(55), ack => type_cast_205_inst_req_0); -- 
    rr_642_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_642_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(55), ack => RPIPE_zeropad_input_pipe_213_inst_req_0); -- 
    -- CP-element group 56:  transition  input  bypass 
    -- CP-element group 56: predecessors 
    -- CP-element group 56: 	55 
    -- CP-element group 56: successors 
    -- CP-element group 56:  members (3) 
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_sample_completed_
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/$exit
      -- CP-element group 56: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Sample/ra
      -- 
    ra_629_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 56_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_205_inst_ack_0, ack => zeropad3D_CP_182_elements(56)); -- 
    -- CP-element group 57:  transition  input  bypass 
    -- CP-element group 57: predecessors 
    -- CP-element group 57: 	0 
    -- CP-element group 57: successors 
    -- CP-element group 57: 	75 
    -- CP-element group 57:  members (3) 
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_update_completed_
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/$exit
      -- CP-element group 57: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_205_Update/ca
      -- 
    ca_634_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 57_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_205_inst_ack_1, ack => zeropad3D_CP_182_elements(57)); -- 
    -- CP-element group 58:  transition  input  output  bypass 
    -- CP-element group 58: predecessors 
    -- CP-element group 58: 	55 
    -- CP-element group 58: successors 
    -- CP-element group 58: 	59 
    -- CP-element group 58:  members (6) 
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_sample_completed_
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_update_start_
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/$exit
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Sample/ra
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/$entry
      -- CP-element group 58: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/cr
      -- 
    ra_643_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 58_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_213_inst_ack_0, ack => zeropad3D_CP_182_elements(58)); -- 
    cr_647_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_647_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(58), ack => RPIPE_zeropad_input_pipe_213_inst_req_1); -- 
    -- CP-element group 59:  fork  transition  input  output  bypass 
    -- CP-element group 59: predecessors 
    -- CP-element group 59: 	58 
    -- CP-element group 59: successors 
    -- CP-element group 59: 	60 
    -- CP-element group 59: 	62 
    -- CP-element group 59:  members (9) 
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_update_completed_
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/$exit
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_213_Update/ca
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_sample_start_
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/$entry
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/rr
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_sample_start_
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/$entry
      -- CP-element group 59: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/rr
      -- 
    ca_648_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 59_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_213_inst_ack_1, ack => zeropad3D_CP_182_elements(59)); -- 
    rr_656_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_656_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(59), ack => type_cast_217_inst_req_0); -- 
    rr_670_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_670_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(59), ack => RPIPE_zeropad_input_pipe_226_inst_req_0); -- 
    -- CP-element group 60:  transition  input  bypass 
    -- CP-element group 60: predecessors 
    -- CP-element group 60: 	59 
    -- CP-element group 60: successors 
    -- CP-element group 60:  members (3) 
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_sample_completed_
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/$exit
      -- CP-element group 60: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Sample/ra
      -- 
    ra_657_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 60_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_217_inst_ack_0, ack => zeropad3D_CP_182_elements(60)); -- 
    -- CP-element group 61:  transition  input  bypass 
    -- CP-element group 61: predecessors 
    -- CP-element group 61: 	0 
    -- CP-element group 61: successors 
    -- CP-element group 61: 	75 
    -- CP-element group 61:  members (3) 
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_update_completed_
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/$exit
      -- CP-element group 61: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_217_Update/ca
      -- 
    ca_662_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 61_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_217_inst_ack_1, ack => zeropad3D_CP_182_elements(61)); -- 
    -- CP-element group 62:  transition  input  output  bypass 
    -- CP-element group 62: predecessors 
    -- CP-element group 62: 	59 
    -- CP-element group 62: successors 
    -- CP-element group 62: 	63 
    -- CP-element group 62:  members (6) 
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_sample_completed_
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_update_start_
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/$exit
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Sample/ra
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/$entry
      -- CP-element group 62: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/cr
      -- 
    ra_671_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 62_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_226_inst_ack_0, ack => zeropad3D_CP_182_elements(62)); -- 
    cr_675_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_675_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(62), ack => RPIPE_zeropad_input_pipe_226_inst_req_1); -- 
    -- CP-element group 63:  transition  input  output  bypass 
    -- CP-element group 63: predecessors 
    -- CP-element group 63: 	62 
    -- CP-element group 63: successors 
    -- CP-element group 63: 	64 
    -- CP-element group 63:  members (6) 
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_sample_start_
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/$entry
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/rr
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_update_completed_
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/$exit
      -- CP-element group 63: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/RPIPE_zeropad_input_pipe_226_Update/ca
      -- 
    ca_676_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 63_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_226_inst_ack_1, ack => zeropad3D_CP_182_elements(63)); -- 
    rr_684_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_684_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(63), ack => type_cast_230_inst_req_0); -- 
    -- CP-element group 64:  transition  input  bypass 
    -- CP-element group 64: predecessors 
    -- CP-element group 64: 	63 
    -- CP-element group 64: successors 
    -- CP-element group 64:  members (3) 
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_sample_completed_
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/$exit
      -- CP-element group 64: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Sample/ra
      -- 
    ra_685_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 64_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_230_inst_ack_0, ack => zeropad3D_CP_182_elements(64)); -- 
    -- CP-element group 65:  transition  input  bypass 
    -- CP-element group 65: predecessors 
    -- CP-element group 65: 	0 
    -- CP-element group 65: successors 
    -- CP-element group 65: 	75 
    -- CP-element group 65:  members (3) 
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_update_completed_
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/$exit
      -- CP-element group 65: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_230_Update/ca
      -- 
    ca_690_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 65_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_230_inst_ack_1, ack => zeropad3D_CP_182_elements(65)); -- 
    -- CP-element group 66:  join  transition  output  bypass 
    -- CP-element group 66: predecessors 
    -- CP-element group 66: 	13 
    -- CP-element group 66: 	17 
    -- CP-element group 66: successors 
    -- CP-element group 66: 	67 
    -- CP-element group 66:  members (3) 
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_sample_start_
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/$entry
      -- CP-element group 66: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/rr
      -- 
    rr_698_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_698_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(66), ack => type_cast_239_inst_req_0); -- 
    zeropad3D_cp_element_group_66: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_66"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(13) & zeropad3D_CP_182_elements(17);
      gj_zeropad3D_cp_element_group_66 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(66), clk => clk, reset => reset); --
    end block;
    -- CP-element group 67:  transition  input  bypass 
    -- CP-element group 67: predecessors 
    -- CP-element group 67: 	66 
    -- CP-element group 67: successors 
    -- CP-element group 67:  members (3) 
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_sample_completed_
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/$exit
      -- CP-element group 67: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Sample/ra
      -- 
    ra_699_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 67_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_239_inst_ack_0, ack => zeropad3D_CP_182_elements(67)); -- 
    -- CP-element group 68:  transition  input  bypass 
    -- CP-element group 68: predecessors 
    -- CP-element group 68: 	0 
    -- CP-element group 68: successors 
    -- CP-element group 68: 	75 
    -- CP-element group 68:  members (3) 
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_update_completed_
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/$exit
      -- CP-element group 68: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_239_Update/ca
      -- 
    ca_704_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 68_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_239_inst_ack_1, ack => zeropad3D_CP_182_elements(68)); -- 
    -- CP-element group 69:  join  transition  output  bypass 
    -- CP-element group 69: predecessors 
    -- CP-element group 69: 	21 
    -- CP-element group 69: 	25 
    -- CP-element group 69: successors 
    -- CP-element group 69: 	70 
    -- CP-element group 69:  members (3) 
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_sample_start_
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/$entry
      -- CP-element group 69: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/rr
      -- 
    rr_712_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_712_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(69), ack => type_cast_243_inst_req_0); -- 
    zeropad3D_cp_element_group_69: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_69"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(21) & zeropad3D_CP_182_elements(25);
      gj_zeropad3D_cp_element_group_69 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(69), clk => clk, reset => reset); --
    end block;
    -- CP-element group 70:  transition  input  bypass 
    -- CP-element group 70: predecessors 
    -- CP-element group 70: 	69 
    -- CP-element group 70: successors 
    -- CP-element group 70:  members (3) 
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_sample_completed_
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/$exit
      -- CP-element group 70: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Sample/ra
      -- 
    ra_713_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 70_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_243_inst_ack_0, ack => zeropad3D_CP_182_elements(70)); -- 
    -- CP-element group 71:  transition  input  bypass 
    -- CP-element group 71: predecessors 
    -- CP-element group 71: 	0 
    -- CP-element group 71: successors 
    -- CP-element group 71: 	75 
    -- CP-element group 71:  members (3) 
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_update_completed_
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/$exit
      -- CP-element group 71: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_243_Update/ca
      -- 
    ca_718_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 71_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_243_inst_ack_1, ack => zeropad3D_CP_182_elements(71)); -- 
    -- CP-element group 72:  join  transition  output  bypass 
    -- CP-element group 72: predecessors 
    -- CP-element group 72: 	29 
    -- CP-element group 72: 	33 
    -- CP-element group 72: successors 
    -- CP-element group 72: 	73 
    -- CP-element group 72:  members (3) 
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_sample_start_
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/$entry
      -- CP-element group 72: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/rr
      -- 
    rr_726_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_726_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(72), ack => type_cast_247_inst_req_0); -- 
    zeropad3D_cp_element_group_72: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_72"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(29) & zeropad3D_CP_182_elements(33);
      gj_zeropad3D_cp_element_group_72 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(72), clk => clk, reset => reset); --
    end block;
    -- CP-element group 73:  transition  input  bypass 
    -- CP-element group 73: predecessors 
    -- CP-element group 73: 	72 
    -- CP-element group 73: successors 
    -- CP-element group 73:  members (3) 
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_sample_completed_
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/$exit
      -- CP-element group 73: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Sample/ra
      -- 
    ra_727_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 73_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_247_inst_ack_0, ack => zeropad3D_CP_182_elements(73)); -- 
    -- CP-element group 74:  transition  input  bypass 
    -- CP-element group 74: predecessors 
    -- CP-element group 74: 	0 
    -- CP-element group 74: successors 
    -- CP-element group 74: 	75 
    -- CP-element group 74:  members (3) 
      -- CP-element group 74: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_update_completed_
      -- CP-element group 74: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/$exit
      -- CP-element group 74: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/type_cast_247_Update/ca
      -- 
    ca_732_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 74_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_247_inst_ack_1, ack => zeropad3D_CP_182_elements(74)); -- 
    -- CP-element group 75:  branch  join  transition  place  output  bypass 
    -- CP-element group 75: predecessors 
    -- CP-element group 75: 	45 
    -- CP-element group 75: 	49 
    -- CP-element group 75: 	53 
    -- CP-element group 75: 	57 
    -- CP-element group 75: 	61 
    -- CP-element group 75: 	41 
    -- CP-element group 75: 	37 
    -- CP-element group 75: 	65 
    -- CP-element group 75: 	68 
    -- CP-element group 75: 	71 
    -- CP-element group 75: 	74 
    -- CP-element group 75: successors 
    -- CP-element group 75: 	76 
    -- CP-element group 75: 	77 
    -- CP-element group 75:  members (10) 
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281__exit__
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282__entry__
      -- CP-element group 75: 	 branch_block_stmt_49/assign_stmt_52_to_assign_stmt_281/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_dead_link/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_eval_test/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_eval_test/$exit
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_eval_test/branch_req
      -- CP-element group 75: 	 branch_block_stmt_49/R_cmp314_283_place
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_if_link/$entry
      -- CP-element group 75: 	 branch_block_stmt_49/if_stmt_282_else_link/$entry
      -- 
    branch_req_740_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_740_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(75), ack => if_stmt_282_branch_req_0); -- 
    zeropad3D_cp_element_group_75: block -- 
      constant place_capacities: IntegerArray(0 to 10) := (0 => 1,1 => 1,2 => 1,3 => 1,4 => 1,5 => 1,6 => 1,7 => 1,8 => 1,9 => 1,10 => 1);
      constant place_markings: IntegerArray(0 to 10)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0,9 => 0,10 => 0);
      constant place_delays: IntegerArray(0 to 10) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0,9 => 0,10 => 0);
      constant joinName: string(1 to 29) := "zeropad3D_cp_element_group_75"; 
      signal preds: BooleanArray(1 to 11); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(45) & zeropad3D_CP_182_elements(49) & zeropad3D_CP_182_elements(53) & zeropad3D_CP_182_elements(57) & zeropad3D_CP_182_elements(61) & zeropad3D_CP_182_elements(41) & zeropad3D_CP_182_elements(37) & zeropad3D_CP_182_elements(65) & zeropad3D_CP_182_elements(68) & zeropad3D_CP_182_elements(71) & zeropad3D_CP_182_elements(74);
      gj_zeropad3D_cp_element_group_75 : generic_join generic map(name => joinName, number_of_predecessors => 11, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(75), clk => clk, reset => reset); --
    end block;
    -- CP-element group 76:  merge  transition  place  input  bypass 
    -- CP-element group 76: predecessors 
    -- CP-element group 76: 	75 
    -- CP-element group 76: successors 
    -- CP-element group 76: 	391 
    -- CP-element group 76:  members (18) 
      -- CP-element group 76: 	 branch_block_stmt_49/merge_stmt_288__exit__
      -- CP-element group 76: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307__entry__
      -- CP-element group 76: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307__exit__
      -- CP-element group 76: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody
      -- CP-element group 76: 	 branch_block_stmt_49/if_stmt_282_if_link/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/if_stmt_282_if_link/if_choice_transition
      -- CP-element group 76: 	 branch_block_stmt_49/entry_bbx_xnph316
      -- CP-element group 76: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/assign_stmt_294_to_assign_stmt_307/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/entry_bbx_xnph316_PhiReq/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/entry_bbx_xnph316_PhiReq/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/merge_stmt_288_PhiReqMerge
      -- CP-element group 76: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/$exit
      -- CP-element group 76: 	 branch_block_stmt_49/merge_stmt_288_PhiAck/dummy
      -- CP-element group 76: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/$entry
      -- CP-element group 76: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$entry
      -- 
    if_choice_transition_745_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 76_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_282_branch_ack_1, ack => zeropad3D_CP_182_elements(76)); -- 
    -- CP-element group 77:  transition  place  input  bypass 
    -- CP-element group 77: predecessors 
    -- CP-element group 77: 	75 
    -- CP-element group 77: successors 
    -- CP-element group 77: 	397 
    -- CP-element group 77:  members (5) 
      -- CP-element group 77: 	 branch_block_stmt_49/if_stmt_282_else_link/$exit
      -- CP-element group 77: 	 branch_block_stmt_49/if_stmt_282_else_link/else_choice_transition
      -- CP-element group 77: 	 branch_block_stmt_49/entry_forx_xend
      -- CP-element group 77: 	 branch_block_stmt_49/entry_forx_xend_PhiReq/$entry
      -- CP-element group 77: 	 branch_block_stmt_49/entry_forx_xend_PhiReq/$exit
      -- 
    else_choice_transition_749_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 77_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_282_branch_ack_0, ack => zeropad3D_CP_182_elements(77)); -- 
    -- CP-element group 78:  transition  input  bypass 
    -- CP-element group 78: predecessors 
    -- CP-element group 78: 	396 
    -- CP-element group 78: successors 
    -- CP-element group 78: 	117 
    -- CP-element group 78:  members (3) 
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_sample_complete
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/$exit
      -- CP-element group 78: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/ack
      -- 
    ack_783_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 78_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_322_index_offset_ack_0, ack => zeropad3D_CP_182_elements(78)); -- 
    -- CP-element group 79:  transition  input  output  bypass 
    -- CP-element group 79: predecessors 
    -- CP-element group 79: 	396 
    -- CP-element group 79: successors 
    -- CP-element group 79: 	80 
    -- CP-element group 79:  members (11) 
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_sample_start_
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_root_address_calculated
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_offset_calculated
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/$exit
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/ack
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/$entry
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/$exit
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/sum_rename_req
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_base_plus_offset/sum_rename_ack
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/$entry
      -- CP-element group 79: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/req
      -- 
    ack_788_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 79_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_322_index_offset_ack_1, ack => zeropad3D_CP_182_elements(79)); -- 
    req_797_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_797_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(79), ack => addr_of_323_final_reg_req_0); -- 
    -- CP-element group 80:  transition  input  bypass 
    -- CP-element group 80: predecessors 
    -- CP-element group 80: 	79 
    -- CP-element group 80: successors 
    -- CP-element group 80:  members (3) 
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_sample_completed_
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/$exit
      -- CP-element group 80: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_request/ack
      -- 
    ack_798_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 80_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_323_final_reg_ack_0, ack => zeropad3D_CP_182_elements(80)); -- 
    -- CP-element group 81:  fork  transition  input  bypass 
    -- CP-element group 81: predecessors 
    -- CP-element group 81: 	396 
    -- CP-element group 81: successors 
    -- CP-element group 81: 	114 
    -- CP-element group 81:  members (19) 
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/root_register_ack
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/root_register_req
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/$exit
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_addrgen/$entry
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/sum_rename_ack
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/sum_rename_req
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/$exit
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_plus_offset/$entry
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/base_resize_ack
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/base_resize_req
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/$exit
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_addr_resize/$entry
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_address_resized
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_root_address_calculated
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_word_address_calculated
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_base_address_calculated
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_update_completed_
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/$exit
      -- CP-element group 81: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/ack
      -- 
    ack_803_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 81_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_323_final_reg_ack_1, ack => zeropad3D_CP_182_elements(81)); -- 
    -- CP-element group 82:  transition  input  output  bypass 
    -- CP-element group 82: predecessors 
    -- CP-element group 82: 	396 
    -- CP-element group 82: successors 
    -- CP-element group 82: 	83 
    -- CP-element group 82:  members (6) 
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_sample_completed_
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_update_start_
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/$exit
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/ra
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/$entry
      -- CP-element group 82: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/cr
      -- 
    ra_812_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 82_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_326_inst_ack_0, ack => zeropad3D_CP_182_elements(82)); -- 
    cr_816_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_816_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(82), ack => RPIPE_zeropad_input_pipe_326_inst_req_1); -- 
    -- CP-element group 83:  fork  transition  input  output  bypass 
    -- CP-element group 83: predecessors 
    -- CP-element group 83: 	82 
    -- CP-element group 83: successors 
    -- CP-element group 83: 	84 
    -- CP-element group 83: 	86 
    -- CP-element group 83:  members (9) 
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_update_completed_
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/$exit
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Update/ca
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_sample_start_
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/$entry
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/rr
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_sample_start_
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/$entry
      -- CP-element group 83: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/rr
      -- 
    ca_817_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 83_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_326_inst_ack_1, ack => zeropad3D_CP_182_elements(83)); -- 
    rr_825_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_825_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(83), ack => type_cast_330_inst_req_0); -- 
    rr_839_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_839_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(83), ack => RPIPE_zeropad_input_pipe_339_inst_req_0); -- 
    -- CP-element group 84:  transition  input  bypass 
    -- CP-element group 84: predecessors 
    -- CP-element group 84: 	83 
    -- CP-element group 84: successors 
    -- CP-element group 84:  members (3) 
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_sample_completed_
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/$exit
      -- CP-element group 84: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Sample/ra
      -- 
    ra_826_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 84_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_330_inst_ack_0, ack => zeropad3D_CP_182_elements(84)); -- 
    -- CP-element group 85:  transition  input  bypass 
    -- CP-element group 85: predecessors 
    -- CP-element group 85: 	396 
    -- CP-element group 85: successors 
    -- CP-element group 85: 	114 
    -- CP-element group 85:  members (3) 
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_update_completed_
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/$exit
      -- CP-element group 85: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/ca
      -- 
    ca_831_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 85_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_330_inst_ack_1, ack => zeropad3D_CP_182_elements(85)); -- 
    -- CP-element group 86:  transition  input  output  bypass 
    -- CP-element group 86: predecessors 
    -- CP-element group 86: 	83 
    -- CP-element group 86: successors 
    -- CP-element group 86: 	87 
    -- CP-element group 86:  members (6) 
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_sample_completed_
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_update_start_
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/$exit
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Sample/ra
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/$entry
      -- CP-element group 86: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/cr
      -- 
    ra_840_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 86_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_339_inst_ack_0, ack => zeropad3D_CP_182_elements(86)); -- 
    cr_844_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_844_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(86), ack => RPIPE_zeropad_input_pipe_339_inst_req_1); -- 
    -- CP-element group 87:  fork  transition  input  output  bypass 
    -- CP-element group 87: predecessors 
    -- CP-element group 87: 	86 
    -- CP-element group 87: successors 
    -- CP-element group 87: 	90 
    -- CP-element group 87: 	88 
    -- CP-element group 87:  members (9) 
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_update_completed_
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/$exit
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_339_Update/ca
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_sample_start_
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/$entry
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/rr
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_sample_start_
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/$entry
      -- CP-element group 87: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/rr
      -- 
    ca_845_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 87_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_339_inst_ack_1, ack => zeropad3D_CP_182_elements(87)); -- 
    rr_853_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_853_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(87), ack => type_cast_343_inst_req_0); -- 
    rr_867_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_867_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(87), ack => RPIPE_zeropad_input_pipe_357_inst_req_0); -- 
    -- CP-element group 88:  transition  input  bypass 
    -- CP-element group 88: predecessors 
    -- CP-element group 88: 	87 
    -- CP-element group 88: successors 
    -- CP-element group 88:  members (3) 
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_sample_completed_
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/$exit
      -- CP-element group 88: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Sample/ra
      -- 
    ra_854_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 88_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_343_inst_ack_0, ack => zeropad3D_CP_182_elements(88)); -- 
    -- CP-element group 89:  transition  input  bypass 
    -- CP-element group 89: predecessors 
    -- CP-element group 89: 	396 
    -- CP-element group 89: successors 
    -- CP-element group 89: 	114 
    -- CP-element group 89:  members (3) 
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_update_completed_
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/$exit
      -- CP-element group 89: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/ca
      -- 
    ca_859_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 89_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_343_inst_ack_1, ack => zeropad3D_CP_182_elements(89)); -- 
    -- CP-element group 90:  transition  input  output  bypass 
    -- CP-element group 90: predecessors 
    -- CP-element group 90: 	87 
    -- CP-element group 90: successors 
    -- CP-element group 90: 	91 
    -- CP-element group 90:  members (6) 
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_sample_completed_
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_update_start_
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/$exit
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Sample/ra
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/$entry
      -- CP-element group 90: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/cr
      -- 
    ra_868_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 90_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_357_inst_ack_0, ack => zeropad3D_CP_182_elements(90)); -- 
    cr_872_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_872_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(90), ack => RPIPE_zeropad_input_pipe_357_inst_req_1); -- 
    -- CP-element group 91:  fork  transition  input  output  bypass 
    -- CP-element group 91: predecessors 
    -- CP-element group 91: 	90 
    -- CP-element group 91: successors 
    -- CP-element group 91: 	92 
    -- CP-element group 91: 	94 
    -- CP-element group 91:  members (9) 
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_update_completed_
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/$exit
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_357_Update/ca
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_sample_start_
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/$entry
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/rr
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_sample_start_
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/$entry
      -- CP-element group 91: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/rr
      -- 
    ca_873_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 91_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_357_inst_ack_1, ack => zeropad3D_CP_182_elements(91)); -- 
    rr_881_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_881_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(91), ack => type_cast_361_inst_req_0); -- 
    rr_895_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_895_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(91), ack => RPIPE_zeropad_input_pipe_375_inst_req_0); -- 
    -- CP-element group 92:  transition  input  bypass 
    -- CP-element group 92: predecessors 
    -- CP-element group 92: 	91 
    -- CP-element group 92: successors 
    -- CP-element group 92:  members (3) 
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_sample_completed_
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/$exit
      -- CP-element group 92: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Sample/ra
      -- 
    ra_882_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 92_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_361_inst_ack_0, ack => zeropad3D_CP_182_elements(92)); -- 
    -- CP-element group 93:  transition  input  bypass 
    -- CP-element group 93: predecessors 
    -- CP-element group 93: 	396 
    -- CP-element group 93: successors 
    -- CP-element group 93: 	114 
    -- CP-element group 93:  members (3) 
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_update_completed_
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/$exit
      -- CP-element group 93: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/ca
      -- 
    ca_887_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 93_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_361_inst_ack_1, ack => zeropad3D_CP_182_elements(93)); -- 
    -- CP-element group 94:  transition  input  output  bypass 
    -- CP-element group 94: predecessors 
    -- CP-element group 94: 	91 
    -- CP-element group 94: successors 
    -- CP-element group 94: 	95 
    -- CP-element group 94:  members (6) 
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_sample_completed_
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_update_start_
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/$exit
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Sample/ra
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/$entry
      -- CP-element group 94: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/cr
      -- 
    ra_896_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 94_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_375_inst_ack_0, ack => zeropad3D_CP_182_elements(94)); -- 
    cr_900_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_900_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(94), ack => RPIPE_zeropad_input_pipe_375_inst_req_1); -- 
    -- CP-element group 95:  fork  transition  input  output  bypass 
    -- CP-element group 95: predecessors 
    -- CP-element group 95: 	94 
    -- CP-element group 95: successors 
    -- CP-element group 95: 	96 
    -- CP-element group 95: 	98 
    -- CP-element group 95:  members (9) 
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/$entry
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_sample_start_
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/rr
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_update_completed_
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/$exit
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_375_Update/ca
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_sample_start_
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/$entry
      -- CP-element group 95: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/rr
      -- 
    ca_901_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 95_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_375_inst_ack_1, ack => zeropad3D_CP_182_elements(95)); -- 
    rr_909_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_909_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(95), ack => type_cast_379_inst_req_0); -- 
    rr_923_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_923_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(95), ack => RPIPE_zeropad_input_pipe_393_inst_req_0); -- 
    -- CP-element group 96:  transition  input  bypass 
    -- CP-element group 96: predecessors 
    -- CP-element group 96: 	95 
    -- CP-element group 96: successors 
    -- CP-element group 96:  members (3) 
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_sample_completed_
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/$exit
      -- CP-element group 96: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Sample/ra
      -- 
    ra_910_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 96_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_379_inst_ack_0, ack => zeropad3D_CP_182_elements(96)); -- 
    -- CP-element group 97:  transition  input  bypass 
    -- CP-element group 97: predecessors 
    -- CP-element group 97: 	396 
    -- CP-element group 97: successors 
    -- CP-element group 97: 	114 
    -- CP-element group 97:  members (3) 
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/ca
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/$exit
      -- CP-element group 97: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_update_completed_
      -- 
    ca_915_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 97_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_379_inst_ack_1, ack => zeropad3D_CP_182_elements(97)); -- 
    -- CP-element group 98:  transition  input  output  bypass 
    -- CP-element group 98: predecessors 
    -- CP-element group 98: 	95 
    -- CP-element group 98: successors 
    -- CP-element group 98: 	99 
    -- CP-element group 98:  members (6) 
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/$exit
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_update_start_
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_sample_completed_
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/cr
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/$entry
      -- CP-element group 98: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Sample/ra
      -- 
    ra_924_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 98_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_393_inst_ack_0, ack => zeropad3D_CP_182_elements(98)); -- 
    cr_928_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_928_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(98), ack => RPIPE_zeropad_input_pipe_393_inst_req_1); -- 
    -- CP-element group 99:  fork  transition  input  output  bypass 
    -- CP-element group 99: predecessors 
    -- CP-element group 99: 	98 
    -- CP-element group 99: successors 
    -- CP-element group 99: 	100 
    -- CP-element group 99: 	102 
    -- CP-element group 99:  members (9) 
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_update_completed_
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/rr
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/$entry
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_sample_start_
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/ca
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_393_Update/$exit
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/rr
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/$entry
      -- CP-element group 99: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_sample_start_
      -- 
    ca_929_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 99_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_393_inst_ack_1, ack => zeropad3D_CP_182_elements(99)); -- 
    rr_937_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_937_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(99), ack => type_cast_397_inst_req_0); -- 
    rr_951_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_951_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(99), ack => RPIPE_zeropad_input_pipe_411_inst_req_0); -- 
    -- CP-element group 100:  transition  input  bypass 
    -- CP-element group 100: predecessors 
    -- CP-element group 100: 	99 
    -- CP-element group 100: successors 
    -- CP-element group 100:  members (3) 
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/ra
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Sample/$exit
      -- CP-element group 100: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_sample_completed_
      -- 
    ra_938_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 100_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_397_inst_ack_0, ack => zeropad3D_CP_182_elements(100)); -- 
    -- CP-element group 101:  transition  input  bypass 
    -- CP-element group 101: predecessors 
    -- CP-element group 101: 	396 
    -- CP-element group 101: successors 
    -- CP-element group 101: 	114 
    -- CP-element group 101:  members (3) 
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/$exit
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_update_completed_
      -- CP-element group 101: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/ca
      -- 
    ca_943_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 101_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_397_inst_ack_1, ack => zeropad3D_CP_182_elements(101)); -- 
    -- CP-element group 102:  transition  input  output  bypass 
    -- CP-element group 102: predecessors 
    -- CP-element group 102: 	99 
    -- CP-element group 102: successors 
    -- CP-element group 102: 	103 
    -- CP-element group 102:  members (6) 
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/$exit
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/cr
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/$entry
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Sample/ra
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_update_start_
      -- CP-element group 102: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_sample_completed_
      -- 
    ra_952_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 102_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_411_inst_ack_0, ack => zeropad3D_CP_182_elements(102)); -- 
    cr_956_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_956_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(102), ack => RPIPE_zeropad_input_pipe_411_inst_req_1); -- 
    -- CP-element group 103:  fork  transition  input  output  bypass 
    -- CP-element group 103: predecessors 
    -- CP-element group 103: 	102 
    -- CP-element group 103: successors 
    -- CP-element group 103: 	104 
    -- CP-element group 103: 	106 
    -- CP-element group 103:  members (9) 
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/rr
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/$entry
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_sample_start_
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/rr
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/$entry
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_sample_start_
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/ca
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_Update/$exit
      -- CP-element group 103: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_411_update_completed_
      -- 
    ca_957_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 103_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_411_inst_ack_1, ack => zeropad3D_CP_182_elements(103)); -- 
    rr_965_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_965_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(103), ack => type_cast_415_inst_req_0); -- 
    rr_979_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_979_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(103), ack => RPIPE_zeropad_input_pipe_429_inst_req_0); -- 
    -- CP-element group 104:  transition  input  bypass 
    -- CP-element group 104: predecessors 
    -- CP-element group 104: 	103 
    -- CP-element group 104: successors 
    -- CP-element group 104:  members (3) 
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/ra
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Sample/$exit
      -- CP-element group 104: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_sample_completed_
      -- 
    ra_966_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 104_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_415_inst_ack_0, ack => zeropad3D_CP_182_elements(104)); -- 
    -- CP-element group 105:  transition  input  bypass 
    -- CP-element group 105: predecessors 
    -- CP-element group 105: 	396 
    -- CP-element group 105: successors 
    -- CP-element group 105: 	114 
    -- CP-element group 105:  members (3) 
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/ca
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/$exit
      -- CP-element group 105: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_update_completed_
      -- 
    ca_971_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 105_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_415_inst_ack_1, ack => zeropad3D_CP_182_elements(105)); -- 
    -- CP-element group 106:  transition  input  output  bypass 
    -- CP-element group 106: predecessors 
    -- CP-element group 106: 	103 
    -- CP-element group 106: successors 
    -- CP-element group 106: 	107 
    -- CP-element group 106:  members (6) 
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/ra
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Sample/$exit
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_update_start_
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_sample_completed_
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/cr
      -- CP-element group 106: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/$entry
      -- 
    ra_980_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 106_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_429_inst_ack_0, ack => zeropad3D_CP_182_elements(106)); -- 
    cr_984_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_984_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(106), ack => RPIPE_zeropad_input_pipe_429_inst_req_1); -- 
    -- CP-element group 107:  fork  transition  input  output  bypass 
    -- CP-element group 107: predecessors 
    -- CP-element group 107: 	106 
    -- CP-element group 107: successors 
    -- CP-element group 107: 	108 
    -- CP-element group 107: 	110 
    -- CP-element group 107:  members (9) 
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/rr
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_update_completed_
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/$entry
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_sample_start_
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/ca
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_429_Update/$exit
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_sample_start_
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/rr
      -- CP-element group 107: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/$entry
      -- 
    ca_985_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 107_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_429_inst_ack_1, ack => zeropad3D_CP_182_elements(107)); -- 
    rr_993_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_993_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(107), ack => type_cast_433_inst_req_0); -- 
    rr_1007_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1007_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(107), ack => RPIPE_zeropad_input_pipe_447_inst_req_0); -- 
    -- CP-element group 108:  transition  input  bypass 
    -- CP-element group 108: predecessors 
    -- CP-element group 108: 	107 
    -- CP-element group 108: successors 
    -- CP-element group 108:  members (3) 
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/ra
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Sample/$exit
      -- CP-element group 108: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_sample_completed_
      -- 
    ra_994_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 108_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_433_inst_ack_0, ack => zeropad3D_CP_182_elements(108)); -- 
    -- CP-element group 109:  transition  input  bypass 
    -- CP-element group 109: predecessors 
    -- CP-element group 109: 	396 
    -- CP-element group 109: successors 
    -- CP-element group 109: 	114 
    -- CP-element group 109:  members (3) 
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_update_completed_
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/ca
      -- CP-element group 109: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/$exit
      -- 
    ca_999_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 109_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_433_inst_ack_1, ack => zeropad3D_CP_182_elements(109)); -- 
    -- CP-element group 110:  transition  input  output  bypass 
    -- CP-element group 110: predecessors 
    -- CP-element group 110: 	107 
    -- CP-element group 110: successors 
    -- CP-element group 110: 	111 
    -- CP-element group 110:  members (6) 
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_sample_completed_
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/cr
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/$entry
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/ra
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Sample/$exit
      -- CP-element group 110: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_update_start_
      -- 
    ra_1008_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 110_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_447_inst_ack_0, ack => zeropad3D_CP_182_elements(110)); -- 
    cr_1012_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1012_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(110), ack => RPIPE_zeropad_input_pipe_447_inst_req_1); -- 
    -- CP-element group 111:  transition  input  output  bypass 
    -- CP-element group 111: predecessors 
    -- CP-element group 111: 	110 
    -- CP-element group 111: successors 
    -- CP-element group 111: 	112 
    -- CP-element group 111:  members (6) 
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/rr
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_sample_start_
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/$entry
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/ca
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_Update/$exit
      -- CP-element group 111: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_447_update_completed_
      -- 
    ca_1013_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 111_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => RPIPE_zeropad_input_pipe_447_inst_ack_1, ack => zeropad3D_CP_182_elements(111)); -- 
    rr_1021_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1021_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(111), ack => type_cast_451_inst_req_0); -- 
    -- CP-element group 112:  transition  input  bypass 
    -- CP-element group 112: predecessors 
    -- CP-element group 112: 	111 
    -- CP-element group 112: successors 
    -- CP-element group 112:  members (3) 
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/$exit
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_sample_completed_
      -- CP-element group 112: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Sample/ra
      -- 
    ra_1022_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 112_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_451_inst_ack_0, ack => zeropad3D_CP_182_elements(112)); -- 
    -- CP-element group 113:  transition  input  bypass 
    -- CP-element group 113: predecessors 
    -- CP-element group 113: 	396 
    -- CP-element group 113: successors 
    -- CP-element group 113: 	114 
    -- CP-element group 113:  members (3) 
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/ca
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_update_completed_
      -- CP-element group 113: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/$exit
      -- 
    ca_1027_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 113_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_451_inst_ack_1, ack => zeropad3D_CP_182_elements(113)); -- 
    -- CP-element group 114:  join  transition  output  bypass 
    -- CP-element group 114: predecessors 
    -- CP-element group 114: 	93 
    -- CP-element group 114: 	97 
    -- CP-element group 114: 	101 
    -- CP-element group 114: 	105 
    -- CP-element group 114: 	109 
    -- CP-element group 114: 	113 
    -- CP-element group 114: 	81 
    -- CP-element group 114: 	85 
    -- CP-element group 114: 	89 
    -- CP-element group 114: successors 
    -- CP-element group 114: 	115 
    -- CP-element group 114:  members (9) 
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/$entry
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/split_ack
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/$entry
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/split_req
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/$exit
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/ptr_deref_459_Split/$entry
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/$entry
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_sample_start_
      -- CP-element group 114: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/rr
      -- 
    rr_1065_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1065_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(114), ack => ptr_deref_459_store_0_req_0); -- 
    zeropad3D_cp_element_group_114: block -- 
      constant place_capacities: IntegerArray(0 to 8) := (0 => 1,1 => 1,2 => 1,3 => 1,4 => 1,5 => 1,6 => 1,7 => 1,8 => 1);
      constant place_markings: IntegerArray(0 to 8)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0);
      constant place_delays: IntegerArray(0 to 8) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_114"; 
      signal preds: BooleanArray(1 to 9); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(93) & zeropad3D_CP_182_elements(97) & zeropad3D_CP_182_elements(101) & zeropad3D_CP_182_elements(105) & zeropad3D_CP_182_elements(109) & zeropad3D_CP_182_elements(113) & zeropad3D_CP_182_elements(81) & zeropad3D_CP_182_elements(85) & zeropad3D_CP_182_elements(89);
      gj_zeropad3D_cp_element_group_114 : generic_join generic map(name => joinName, number_of_predecessors => 9, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(114), clk => clk, reset => reset); --
    end block;
    -- CP-element group 115:  transition  input  bypass 
    -- CP-element group 115: predecessors 
    -- CP-element group 115: 	114 
    -- CP-element group 115: successors 
    -- CP-element group 115:  members (5) 
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/$exit
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/$exit
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/$exit
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_sample_completed_
      -- CP-element group 115: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Sample/word_access_start/word_0/ra
      -- 
    ra_1066_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 115_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_459_store_0_ack_0, ack => zeropad3D_CP_182_elements(115)); -- 
    -- CP-element group 116:  transition  input  bypass 
    -- CP-element group 116: predecessors 
    -- CP-element group 116: 	396 
    -- CP-element group 116: successors 
    -- CP-element group 116: 	117 
    -- CP-element group 116:  members (5) 
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/$exit
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_update_completed_
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/ca
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/$exit
      -- CP-element group 116: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/$exit
      -- 
    ca_1077_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 116_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_459_store_0_ack_1, ack => zeropad3D_CP_182_elements(116)); -- 
    -- CP-element group 117:  branch  join  transition  place  output  bypass 
    -- CP-element group 117: predecessors 
    -- CP-element group 117: 	116 
    -- CP-element group 117: 	78 
    -- CP-element group 117: successors 
    -- CP-element group 117: 	118 
    -- CP-element group 117: 	119 
    -- CP-element group 117:  members (10) 
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_dead_link/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472__exit__
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473__entry__
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_else_link/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_if_link/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/R_exitcond_474_place
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_eval_test/branch_req
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_eval_test/$exit
      -- CP-element group 117: 	 branch_block_stmt_49/if_stmt_473_eval_test/$entry
      -- CP-element group 117: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/$exit
      -- 
    branch_req_1085_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_1085_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(117), ack => if_stmt_473_branch_req_0); -- 
    zeropad3D_cp_element_group_117: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_117"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(116) & zeropad3D_CP_182_elements(78);
      gj_zeropad3D_cp_element_group_117 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(117), clk => clk, reset => reset); --
    end block;
    -- CP-element group 118:  merge  transition  place  input  bypass 
    -- CP-element group 118: predecessors 
    -- CP-element group 118: 	117 
    -- CP-element group 118: successors 
    -- CP-element group 118: 	397 
    -- CP-element group 118:  members (13) 
      -- CP-element group 118: 	 branch_block_stmt_49/merge_stmt_479__exit__
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit
      -- CP-element group 118: 	 branch_block_stmt_49/if_stmt_473_if_link/if_choice_transition
      -- CP-element group 118: 	 branch_block_stmt_49/if_stmt_473_if_link/$exit
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit_PhiReq/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xbody_forx_xendx_xloopexit_PhiReq/$exit
      -- CP-element group 118: 	 branch_block_stmt_49/merge_stmt_479_PhiReqMerge
      -- CP-element group 118: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/$exit
      -- CP-element group 118: 	 branch_block_stmt_49/merge_stmt_479_PhiAck/dummy
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend_PhiReq/$entry
      -- CP-element group 118: 	 branch_block_stmt_49/forx_xendx_xloopexit_forx_xend_PhiReq/$exit
      -- 
    if_choice_transition_1090_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 118_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_473_branch_ack_1, ack => zeropad3D_CP_182_elements(118)); -- 
    -- CP-element group 119:  fork  transition  place  input  output  bypass 
    -- CP-element group 119: predecessors 
    -- CP-element group 119: 	117 
    -- CP-element group 119: successors 
    -- CP-element group 119: 	392 
    -- CP-element group 119: 	393 
    -- CP-element group 119:  members (12) 
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody
      -- CP-element group 119: 	 branch_block_stmt_49/if_stmt_473_else_link/else_choice_transition
      -- CP-element group 119: 	 branch_block_stmt_49/if_stmt_473_else_link/$exit
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/rr
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/$entry
      -- CP-element group 119: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/cr
      -- 
    else_choice_transition_1094_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 119_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_473_branch_ack_0, ack => zeropad3D_CP_182_elements(119)); -- 
    rr_2410_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2410_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(119), ack => type_cast_316_inst_req_0); -- 
    cr_2415_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2415_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(119), ack => type_cast_316_inst_req_1); -- 
    -- CP-element group 120:  transition  input  bypass 
    -- CP-element group 120: predecessors 
    -- CP-element group 120: 	397 
    -- CP-element group 120: successors 
    -- CP-element group 120:  members (3) 
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/$exit
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/cra
      -- CP-element group 120: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_sample_completed_
      -- 
    cra_1108_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 120_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_484_call_ack_0, ack => zeropad3D_CP_182_elements(120)); -- 
    -- CP-element group 121:  transition  input  output  bypass 
    -- CP-element group 121: predecessors 
    -- CP-element group 121: 	397 
    -- CP-element group 121: successors 
    -- CP-element group 121: 	122 
    -- CP-element group 121:  members (6) 
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_sample_start_
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/$exit
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_update_completed_
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/rr
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/cca
      -- CP-element group 121: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/$entry
      -- 
    cca_1113_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 121_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_484_call_ack_1, ack => zeropad3D_CP_182_elements(121)); -- 
    rr_1121_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1121_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(121), ack => type_cast_488_inst_req_0); -- 
    -- CP-element group 122:  transition  input  bypass 
    -- CP-element group 122: predecessors 
    -- CP-element group 122: 	121 
    -- CP-element group 122: successors 
    -- CP-element group 122:  members (3) 
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_sample_completed_
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/$exit
      -- CP-element group 122: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Sample/ra
      -- 
    ra_1122_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 122_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_488_inst_ack_0, ack => zeropad3D_CP_182_elements(122)); -- 
    -- CP-element group 123:  transition  place  input  bypass 
    -- CP-element group 123: predecessors 
    -- CP-element group 123: 	397 
    -- CP-element group 123: successors 
    -- CP-element group 123: 	124 
    -- CP-element group 123:  members (14) 
      -- CP-element group 123: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489__exit__
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_508__entry__
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_508__exit__
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_513_to_assign_stmt_566__entry__
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_513_to_assign_stmt_566__exit__
      -- CP-element group 123: 	 branch_block_stmt_49/do_while_stmt_567__entry__
      -- CP-element group 123: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/$exit
      -- CP-element group 123: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/$exit
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_513_to_assign_stmt_566/$exit
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_513_to_assign_stmt_566/$entry
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_508/$exit
      -- CP-element group 123: 	 branch_block_stmt_49/assign_stmt_493_to_assign_stmt_508/$entry
      -- CP-element group 123: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/ca
      -- CP-element group 123: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_update_completed_
      -- 
    ca_1127_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 123_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_488_inst_ack_1, ack => zeropad3D_CP_182_elements(123)); -- 
    -- CP-element group 124:  transition  place  bypass  pipeline-parent 
    -- CP-element group 124: predecessors 
    -- CP-element group 124: 	123 
    -- CP-element group 124: successors 
    -- CP-element group 124: 	130 
    -- CP-element group 124:  members (2) 
      -- CP-element group 124: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567__entry__
      -- CP-element group 124: 	 branch_block_stmt_49/do_while_stmt_567/$entry
      -- 
    zeropad3D_CP_182_elements(124) <= zeropad3D_CP_182_elements(123);
    -- CP-element group 125:  merge  place  bypass  pipeline-parent 
    -- CP-element group 125: predecessors 
    -- CP-element group 125: successors 
    -- CP-element group 125: 	288 
    -- CP-element group 125:  members (1) 
      -- CP-element group 125: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567__exit__
      -- 
    -- Element group zeropad3D_CP_182_elements(125) is bound as output of CP function.
    -- CP-element group 126:  merge  place  bypass  pipeline-parent 
    -- CP-element group 126: predecessors 
    -- CP-element group 126: successors 
    -- CP-element group 126: 	129 
    -- CP-element group 126:  members (1) 
      -- CP-element group 126: 	 branch_block_stmt_49/do_while_stmt_567/loop_back
      -- 
    -- Element group zeropad3D_CP_182_elements(126) is bound as output of CP function.
    -- CP-element group 127:  branch  transition  place  bypass  pipeline-parent 
    -- CP-element group 127: predecessors 
    -- CP-element group 127: 	132 
    -- CP-element group 127: successors 
    -- CP-element group 127: 	286 
    -- CP-element group 127: 	287 
    -- CP-element group 127:  members (3) 
      -- CP-element group 127: 	 branch_block_stmt_49/do_while_stmt_567/condition_done
      -- CP-element group 127: 	 branch_block_stmt_49/do_while_stmt_567/loop_exit/$entry
      -- CP-element group 127: 	 branch_block_stmt_49/do_while_stmt_567/loop_taken/$entry
      -- 
    zeropad3D_CP_182_elements(127) <= zeropad3D_CP_182_elements(132);
    -- CP-element group 128:  branch  place  bypass  pipeline-parent 
    -- CP-element group 128: predecessors 
    -- CP-element group 128: 	285 
    -- CP-element group 128: successors 
    -- CP-element group 128:  members (1) 
      -- CP-element group 128: 	 branch_block_stmt_49/do_while_stmt_567/loop_body_done
      -- 
    zeropad3D_CP_182_elements(128) <= zeropad3D_CP_182_elements(285);
    -- CP-element group 129:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 129: predecessors 
    -- CP-element group 129: 	126 
    -- CP-element group 129: successors 
    -- CP-element group 129: 	141 
    -- CP-element group 129: 	160 
    -- CP-element group 129: 	179 
    -- CP-element group 129: 	198 
    -- CP-element group 129: 	217 
    -- CP-element group 129:  members (1) 
      -- CP-element group 129: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/back_edge_to_loop_body
      -- 
    zeropad3D_CP_182_elements(129) <= zeropad3D_CP_182_elements(126);
    -- CP-element group 130:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 130: predecessors 
    -- CP-element group 130: 	124 
    -- CP-element group 130: successors 
    -- CP-element group 130: 	143 
    -- CP-element group 130: 	162 
    -- CP-element group 130: 	181 
    -- CP-element group 130: 	200 
    -- CP-element group 130: 	219 
    -- CP-element group 130:  members (1) 
      -- CP-element group 130: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/first_time_through_loop_body
      -- 
    zeropad3D_CP_182_elements(130) <= zeropad3D_CP_182_elements(124);
    -- CP-element group 131:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 131: predecessors 
    -- CP-element group 131: successors 
    -- CP-element group 131: 	137 
    -- CP-element group 131: 	138 
    -- CP-element group 131: 	154 
    -- CP-element group 131: 	155 
    -- CP-element group 131: 	173 
    -- CP-element group 131: 	174 
    -- CP-element group 131: 	192 
    -- CP-element group 131: 	193 
    -- CP-element group 131: 	211 
    -- CP-element group 131: 	212 
    -- CP-element group 131: 	230 
    -- CP-element group 131: 	234 
    -- CP-element group 131: 	239 
    -- CP-element group 131: 	240 
    -- CP-element group 131: 	250 
    -- CP-element group 131: 	251 
    -- CP-element group 131: 	272 
    -- CP-element group 131: 	276 
    -- CP-element group 131: 	280 
    -- CP-element group 131: 	284 
    -- CP-element group 131:  members (2) 
      -- CP-element group 131: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/loop_body_start
      -- CP-element group 131: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/$entry
      -- 
    -- Element group zeropad3D_CP_182_elements(131) is bound as output of CP function.
    -- CP-element group 132:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 132: predecessors 
    -- CP-element group 132: 	136 
    -- CP-element group 132: 	140 
    -- CP-element group 132: 	178 
    -- CP-element group 132: 	275 
    -- CP-element group 132: 	283 
    -- CP-element group 132: 	284 
    -- CP-element group 132: successors 
    -- CP-element group 132: 	127 
    -- CP-element group 132:  members (1) 
      -- CP-element group 132: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/condition_evaluated
      -- 
    condition_evaluated_1148_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " condition_evaluated_1148_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(132), ack => do_while_stmt_567_branch_req_0); -- 
    zeropad3D_cp_element_group_132: block -- 
      constant place_capacities: IntegerArray(0 to 5) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15,5 => 15);
      constant place_markings: IntegerArray(0 to 5)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0);
      constant place_delays: IntegerArray(0 to 5) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_132"; 
      signal preds: BooleanArray(1 to 6); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(136) & zeropad3D_CP_182_elements(140) & zeropad3D_CP_182_elements(178) & zeropad3D_CP_182_elements(275) & zeropad3D_CP_182_elements(283) & zeropad3D_CP_182_elements(284);
      gj_zeropad3D_cp_element_group_132 : generic_join generic map(name => joinName, number_of_predecessors => 6, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(132), clk => clk, reset => reset); --
    end block;
    -- CP-element group 133:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 133: predecessors 
    -- CP-element group 133: 	137 
    -- CP-element group 133: 	154 
    -- CP-element group 133: 	173 
    -- CP-element group 133: 	192 
    -- CP-element group 133: 	211 
    -- CP-element group 133: marked-predecessors 
    -- CP-element group 133: 	136 
    -- CP-element group 133: successors 
    -- CP-element group 133: 	156 
    -- CP-element group 133: 	175 
    -- CP-element group 133: 	194 
    -- CP-element group 133: 	213 
    -- CP-element group 133:  members (2) 
      -- CP-element group 133: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_sample_start__ps
      -- CP-element group 133: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/aggregated_phi_sample_req
      -- 
    zeropad3D_cp_element_group_133: block -- 
      constant place_capacities: IntegerArray(0 to 5) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15,5 => 1);
      constant place_markings: IntegerArray(0 to 5)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 1);
      constant place_delays: IntegerArray(0 to 5) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_133"; 
      signal preds: BooleanArray(1 to 6); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(137) & zeropad3D_CP_182_elements(154) & zeropad3D_CP_182_elements(173) & zeropad3D_CP_182_elements(192) & zeropad3D_CP_182_elements(211) & zeropad3D_CP_182_elements(136);
      gj_zeropad3D_cp_element_group_133 : generic_join generic map(name => joinName, number_of_predecessors => 6, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(133), clk => clk, reset => reset); --
    end block;
    -- CP-element group 134:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 134: predecessors 
    -- CP-element group 134: 	139 
    -- CP-element group 134: 	157 
    -- CP-element group 134: 	176 
    -- CP-element group 134: 	195 
    -- CP-element group 134: 	214 
    -- CP-element group 134: successors 
    -- CP-element group 134: 	273 
    -- CP-element group 134: 	277 
    -- CP-element group 134: 	285 
    -- CP-element group 134: marked-successors 
    -- CP-element group 134: 	137 
    -- CP-element group 134: 	154 
    -- CP-element group 134: 	173 
    -- CP-element group 134: 	192 
    -- CP-element group 134: 	211 
    -- CP-element group 134:  members (6) 
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_sample_completed_
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/aggregated_phi_sample_ack
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_sample_completed_
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_sample_completed_
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_sample_completed_
      -- CP-element group 134: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_sample_completed_
      -- 
    zeropad3D_cp_element_group_134: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_134"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(139) & zeropad3D_CP_182_elements(157) & zeropad3D_CP_182_elements(176) & zeropad3D_CP_182_elements(195) & zeropad3D_CP_182_elements(214);
      gj_zeropad3D_cp_element_group_134 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(134), clk => clk, reset => reset); --
    end block;
    -- CP-element group 135:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 135: predecessors 
    -- CP-element group 135: 	138 
    -- CP-element group 135: 	155 
    -- CP-element group 135: 	174 
    -- CP-element group 135: 	193 
    -- CP-element group 135: 	212 
    -- CP-element group 135: successors 
    -- CP-element group 135: 	158 
    -- CP-element group 135: 	177 
    -- CP-element group 135: 	196 
    -- CP-element group 135: 	215 
    -- CP-element group 135:  members (2) 
      -- CP-element group 135: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_update_start__ps
      -- CP-element group 135: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/aggregated_phi_update_req
      -- 
    zeropad3D_cp_element_group_135: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_135"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(138) & zeropad3D_CP_182_elements(155) & zeropad3D_CP_182_elements(174) & zeropad3D_CP_182_elements(193) & zeropad3D_CP_182_elements(212);
      gj_zeropad3D_cp_element_group_135 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(135), clk => clk, reset => reset); --
    end block;
    -- CP-element group 136:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 136: predecessors 
    -- CP-element group 136: 	140 
    -- CP-element group 136: 	159 
    -- CP-element group 136: 	178 
    -- CP-element group 136: 	197 
    -- CP-element group 136: 	216 
    -- CP-element group 136: successors 
    -- CP-element group 136: 	132 
    -- CP-element group 136: marked-successors 
    -- CP-element group 136: 	133 
    -- CP-element group 136:  members (1) 
      -- CP-element group 136: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/aggregated_phi_update_ack
      -- 
    zeropad3D_cp_element_group_136: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_136"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(140) & zeropad3D_CP_182_elements(159) & zeropad3D_CP_182_elements(178) & zeropad3D_CP_182_elements(197) & zeropad3D_CP_182_elements(216);
      gj_zeropad3D_cp_element_group_136 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(136), clk => clk, reset => reset); --
    end block;
    -- CP-element group 137:  join  transition  bypass  pipeline-parent 
    -- CP-element group 137: predecessors 
    -- CP-element group 137: 	131 
    -- CP-element group 137: marked-predecessors 
    -- CP-element group 137: 	134 
    -- CP-element group 137: 	275 
    -- CP-element group 137: successors 
    -- CP-element group 137: 	133 
    -- CP-element group 137:  members (1) 
      -- CP-element group 137: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_sample_start_
      -- 
    zeropad3D_cp_element_group_137: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 1,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_137"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(275);
      gj_zeropad3D_cp_element_group_137 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(137), clk => clk, reset => reset); --
    end block;
    -- CP-element group 138:  join  transition  bypass  pipeline-parent 
    -- CP-element group 138: predecessors 
    -- CP-element group 138: 	131 
    -- CP-element group 138: marked-predecessors 
    -- CP-element group 138: 	140 
    -- CP-element group 138: successors 
    -- CP-element group 138: 	135 
    -- CP-element group 138:  members (1) 
      -- CP-element group 138: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_update_start_
      -- 
    zeropad3D_cp_element_group_138: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_138"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(140);
      gj_zeropad3D_cp_element_group_138 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(138), clk => clk, reset => reset); --
    end block;
    -- CP-element group 139:  join  transition  bypass  pipeline-parent 
    -- CP-element group 139: predecessors 
    -- CP-element group 139: successors 
    -- CP-element group 139: 	134 
    -- CP-element group 139:  members (1) 
      -- CP-element group 139: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(139) is bound as output of CP function.
    -- CP-element group 140:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 140: predecessors 
    -- CP-element group 140: successors 
    -- CP-element group 140: 	132 
    -- CP-element group 140: 	136 
    -- CP-element group 140: marked-successors 
    -- CP-element group 140: 	138 
    -- CP-element group 140:  members (2) 
      -- CP-element group 140: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_update_completed__ps
      -- CP-element group 140: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(140) is bound as output of CP function.
    -- CP-element group 141:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 141: predecessors 
    -- CP-element group 141: 	129 
    -- CP-element group 141: successors 
    -- CP-element group 141:  members (1) 
      -- CP-element group 141: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_loopback_trigger
      -- 
    zeropad3D_CP_182_elements(141) <= zeropad3D_CP_182_elements(129);
    -- CP-element group 142:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 142: predecessors 
    -- CP-element group 142: successors 
    -- CP-element group 142:  members (2) 
      -- CP-element group 142: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_loopback_sample_req_ps
      -- CP-element group 142: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_loopback_sample_req
      -- 
    phi_stmt_569_loopback_sample_req_1163_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_569_loopback_sample_req_1163_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(142), ack => phi_stmt_569_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(142) is bound as output of CP function.
    -- CP-element group 143:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 143: predecessors 
    -- CP-element group 143: 	130 
    -- CP-element group 143: successors 
    -- CP-element group 143:  members (1) 
      -- CP-element group 143: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_entry_trigger
      -- 
    zeropad3D_CP_182_elements(143) <= zeropad3D_CP_182_elements(130);
    -- CP-element group 144:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 144: predecessors 
    -- CP-element group 144: successors 
    -- CP-element group 144:  members (2) 
      -- CP-element group 144: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_entry_sample_req_ps
      -- CP-element group 144: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_entry_sample_req
      -- 
    phi_stmt_569_entry_sample_req_1166_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_569_entry_sample_req_1166_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(144), ack => phi_stmt_569_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(144) is bound as output of CP function.
    -- CP-element group 145:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 145: predecessors 
    -- CP-element group 145: successors 
    -- CP-element group 145:  members (2) 
      -- CP-element group 145: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_phi_mux_ack_ps
      -- CP-element group 145: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_569_phi_mux_ack
      -- 
    phi_stmt_569_phi_mux_ack_1169_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 145_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_569_ack_0, ack => zeropad3D_CP_182_elements(145)); -- 
    -- CP-element group 146:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 146: predecessors 
    -- CP-element group 146: successors 
    -- CP-element group 146:  members (4) 
      -- CP-element group 146: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_sample_completed_
      -- CP-element group 146: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_sample_start_
      -- CP-element group 146: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_sample_completed__ps
      -- CP-element group 146: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_sample_start__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(146) is bound as output of CP function.
    -- CP-element group 147:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 147: predecessors 
    -- CP-element group 147: successors 
    -- CP-element group 147: 	149 
    -- CP-element group 147:  members (2) 
      -- CP-element group 147: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_update_start_
      -- CP-element group 147: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_update_start__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(147) is bound as output of CP function.
    -- CP-element group 148:  join  transition  bypass  pipeline-parent 
    -- CP-element group 148: predecessors 
    -- CP-element group 148: 	149 
    -- CP-element group 148: successors 
    -- CP-element group 148:  members (1) 
      -- CP-element group 148: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_update_completed__ps
      -- 
    zeropad3D_CP_182_elements(148) <= zeropad3D_CP_182_elements(149);
    -- CP-element group 149:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 149: predecessors 
    -- CP-element group 149: 	147 
    -- CP-element group 149: successors 
    -- CP-element group 149: 	148 
    -- CP-element group 149:  members (1) 
      -- CP-element group 149: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_k_loop_init_571_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(149) is a control-delay.
    cp_element_149_delay: control_delay_element  generic map(name => " 149_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(147), ack => zeropad3D_CP_182_elements(149), clk => clk, reset =>reset);
    -- CP-element group 150:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 150: predecessors 
    -- CP-element group 150: successors 
    -- CP-element group 150: 	152 
    -- CP-element group 150:  members (4) 
      -- CP-element group 150: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_sample_start_
      -- CP-element group 150: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_sample_start__ps
      -- CP-element group 150: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Sample/req
      -- CP-element group 150: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Sample/$entry
      -- 
    req_1190_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1190_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(150), ack => next_k_loop_797_572_buf_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(150) is bound as output of CP function.
    -- CP-element group 151:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 151: predecessors 
    -- CP-element group 151: successors 
    -- CP-element group 151: 	153 
    -- CP-element group 151:  members (4) 
      -- CP-element group 151: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Update/req
      -- CP-element group 151: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_update_start__ps
      -- CP-element group 151: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Update/$entry
      -- CP-element group 151: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_update_start_
      -- 
    req_1195_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1195_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(151), ack => next_k_loop_797_572_buf_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(151) is bound as output of CP function.
    -- CP-element group 152:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 152: predecessors 
    -- CP-element group 152: 	150 
    -- CP-element group 152: successors 
    -- CP-element group 152:  members (4) 
      -- CP-element group 152: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_sample_completed__ps
      -- CP-element group 152: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Sample/ack
      -- CP-element group 152: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Sample/$exit
      -- CP-element group 152: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_sample_completed_
      -- 
    ack_1191_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 152_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_k_loop_797_572_buf_ack_0, ack => zeropad3D_CP_182_elements(152)); -- 
    -- CP-element group 153:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 153: predecessors 
    -- CP-element group 153: 	151 
    -- CP-element group 153: successors 
    -- CP-element group 153:  members (4) 
      -- CP-element group 153: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Update/$exit
      -- CP-element group 153: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_Update/ack
      -- CP-element group 153: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_update_completed__ps
      -- CP-element group 153: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_k_loop_572_update_completed_
      -- 
    ack_1196_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 153_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_k_loop_797_572_buf_ack_1, ack => zeropad3D_CP_182_elements(153)); -- 
    -- CP-element group 154:  join  transition  bypass  pipeline-parent 
    -- CP-element group 154: predecessors 
    -- CP-element group 154: 	131 
    -- CP-element group 154: marked-predecessors 
    -- CP-element group 154: 	134 
    -- CP-element group 154: 	275 
    -- CP-element group 154: 	279 
    -- CP-element group 154: successors 
    -- CP-element group 154: 	133 
    -- CP-element group 154:  members (1) 
      -- CP-element group 154: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_sample_start_
      -- 
    zeropad3D_cp_element_group_154: block -- 
      constant place_capacities: IntegerArray(0 to 3) := (0 => 15,1 => 1,2 => 1,3 => 1);
      constant place_markings: IntegerArray(0 to 3)  := (0 => 0,1 => 1,2 => 1,3 => 1);
      constant place_delays: IntegerArray(0 to 3) := (0 => 0,1 => 1,2 => 0,3 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_154"; 
      signal preds: BooleanArray(1 to 4); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(275) & zeropad3D_CP_182_elements(279);
      gj_zeropad3D_cp_element_group_154 : generic_join generic map(name => joinName, number_of_predecessors => 4, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(154), clk => clk, reset => reset); --
    end block;
    -- CP-element group 155:  join  transition  bypass  pipeline-parent 
    -- CP-element group 155: predecessors 
    -- CP-element group 155: 	131 
    -- CP-element group 155: marked-predecessors 
    -- CP-element group 155: 	159 
    -- CP-element group 155: 	262 
    -- CP-element group 155: successors 
    -- CP-element group 155: 	135 
    -- CP-element group 155:  members (1) 
      -- CP-element group 155: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_update_start_
      -- 
    zeropad3D_cp_element_group_155: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_155"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(159) & zeropad3D_CP_182_elements(262);
      gj_zeropad3D_cp_element_group_155 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(155), clk => clk, reset => reset); --
    end block;
    -- CP-element group 156:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 156: predecessors 
    -- CP-element group 156: 	133 
    -- CP-element group 156: successors 
    -- CP-element group 156:  members (1) 
      -- CP-element group 156: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_sample_start__ps
      -- 
    zeropad3D_CP_182_elements(156) <= zeropad3D_CP_182_elements(133);
    -- CP-element group 157:  join  transition  bypass  pipeline-parent 
    -- CP-element group 157: predecessors 
    -- CP-element group 157: successors 
    -- CP-element group 157: 	134 
    -- CP-element group 157:  members (1) 
      -- CP-element group 157: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(157) is bound as output of CP function.
    -- CP-element group 158:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 158: predecessors 
    -- CP-element group 158: 	135 
    -- CP-element group 158: successors 
    -- CP-element group 158:  members (1) 
      -- CP-element group 158: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_update_start__ps
      -- 
    zeropad3D_CP_182_elements(158) <= zeropad3D_CP_182_elements(135);
    -- CP-element group 159:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 159: predecessors 
    -- CP-element group 159: successors 
    -- CP-element group 159: 	136 
    -- CP-element group 159: 	260 
    -- CP-element group 159: marked-successors 
    -- CP-element group 159: 	155 
    -- CP-element group 159:  members (2) 
      -- CP-element group 159: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_update_completed__ps
      -- CP-element group 159: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(159) is bound as output of CP function.
    -- CP-element group 160:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 160: predecessors 
    -- CP-element group 160: 	129 
    -- CP-element group 160: successors 
    -- CP-element group 160:  members (1) 
      -- CP-element group 160: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_loopback_trigger
      -- 
    zeropad3D_CP_182_elements(160) <= zeropad3D_CP_182_elements(129);
    -- CP-element group 161:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 161: predecessors 
    -- CP-element group 161: successors 
    -- CP-element group 161:  members (2) 
      -- CP-element group 161: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_loopback_sample_req_ps
      -- CP-element group 161: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_loopback_sample_req
      -- 
    phi_stmt_573_loopback_sample_req_1207_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_573_loopback_sample_req_1207_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(161), ack => phi_stmt_573_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(161) is bound as output of CP function.
    -- CP-element group 162:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 162: predecessors 
    -- CP-element group 162: 	130 
    -- CP-element group 162: successors 
    -- CP-element group 162:  members (1) 
      -- CP-element group 162: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_entry_trigger
      -- 
    zeropad3D_CP_182_elements(162) <= zeropad3D_CP_182_elements(130);
    -- CP-element group 163:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 163: predecessors 
    -- CP-element group 163: successors 
    -- CP-element group 163:  members (2) 
      -- CP-element group 163: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_entry_sample_req
      -- CP-element group 163: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_entry_sample_req_ps
      -- 
    phi_stmt_573_entry_sample_req_1210_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_573_entry_sample_req_1210_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(163), ack => phi_stmt_573_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(163) is bound as output of CP function.
    -- CP-element group 164:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 164: predecessors 
    -- CP-element group 164: successors 
    -- CP-element group 164:  members (2) 
      -- CP-element group 164: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_phi_mux_ack_ps
      -- CP-element group 164: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_573_phi_mux_ack
      -- 
    phi_stmt_573_phi_mux_ack_1213_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 164_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_573_ack_0, ack => zeropad3D_CP_182_elements(164)); -- 
    -- CP-element group 165:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 165: predecessors 
    -- CP-element group 165: successors 
    -- CP-element group 165:  members (4) 
      -- CP-element group 165: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_sample_completed__ps
      -- CP-element group 165: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_sample_start__ps
      -- CP-element group 165: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_sample_completed_
      -- CP-element group 165: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_sample_start_
      -- 
    -- Element group zeropad3D_CP_182_elements(165) is bound as output of CP function.
    -- CP-element group 166:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 166: predecessors 
    -- CP-element group 166: successors 
    -- CP-element group 166: 	168 
    -- CP-element group 166:  members (2) 
      -- CP-element group 166: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_update_start__ps
      -- CP-element group 166: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_update_start_
      -- 
    -- Element group zeropad3D_CP_182_elements(166) is bound as output of CP function.
    -- CP-element group 167:  join  transition  bypass  pipeline-parent 
    -- CP-element group 167: predecessors 
    -- CP-element group 167: 	168 
    -- CP-element group 167: successors 
    -- CP-element group 167:  members (1) 
      -- CP-element group 167: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_update_completed__ps
      -- 
    zeropad3D_CP_182_elements(167) <= zeropad3D_CP_182_elements(168);
    -- CP-element group 168:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 168: predecessors 
    -- CP-element group 168: 	166 
    -- CP-element group 168: successors 
    -- CP-element group 168: 	167 
    -- CP-element group 168:  members (1) 
      -- CP-element group 168: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_j_loop_init_575_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(168) is a control-delay.
    cp_element_168_delay: control_delay_element  generic map(name => " 168_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(166), ack => zeropad3D_CP_182_elements(168), clk => clk, reset =>reset);
    -- CP-element group 169:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 169: predecessors 
    -- CP-element group 169: successors 
    -- CP-element group 169: 	171 
    -- CP-element group 169:  members (4) 
      -- CP-element group 169: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Sample/$entry
      -- CP-element group 169: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_sample_start__ps
      -- CP-element group 169: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_sample_start_
      -- CP-element group 169: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Sample/req
      -- 
    req_1234_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1234_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(169), ack => next_j_loop_808_576_buf_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(169) is bound as output of CP function.
    -- CP-element group 170:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 170: predecessors 
    -- CP-element group 170: successors 
    -- CP-element group 170: 	172 
    -- CP-element group 170:  members (4) 
      -- CP-element group 170: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_update_start_
      -- CP-element group 170: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_update_start__ps
      -- CP-element group 170: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Update/req
      -- CP-element group 170: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Update/$entry
      -- 
    req_1239_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1239_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(170), ack => next_j_loop_808_576_buf_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(170) is bound as output of CP function.
    -- CP-element group 171:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 171: predecessors 
    -- CP-element group 171: 	169 
    -- CP-element group 171: successors 
    -- CP-element group 171:  members (4) 
      -- CP-element group 171: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_sample_completed_
      -- CP-element group 171: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_sample_completed__ps
      -- CP-element group 171: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Sample/ack
      -- CP-element group 171: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Sample/$exit
      -- 
    ack_1235_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 171_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_j_loop_808_576_buf_ack_0, ack => zeropad3D_CP_182_elements(171)); -- 
    -- CP-element group 172:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 172: predecessors 
    -- CP-element group 172: 	170 
    -- CP-element group 172: successors 
    -- CP-element group 172:  members (4) 
      -- CP-element group 172: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_update_completed__ps
      -- CP-element group 172: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_update_completed_
      -- CP-element group 172: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Update/ack
      -- CP-element group 172: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_j_loop_576_Update/$exit
      -- 
    ack_1240_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 172_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_j_loop_808_576_buf_ack_1, ack => zeropad3D_CP_182_elements(172)); -- 
    -- CP-element group 173:  join  transition  bypass  pipeline-parent 
    -- CP-element group 173: predecessors 
    -- CP-element group 173: 	131 
    -- CP-element group 173: marked-predecessors 
    -- CP-element group 173: 	134 
    -- CP-element group 173: 	275 
    -- CP-element group 173: 	279 
    -- CP-element group 173: successors 
    -- CP-element group 173: 	133 
    -- CP-element group 173:  members (1) 
      -- CP-element group 173: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_sample_start_
      -- 
    zeropad3D_cp_element_group_173: block -- 
      constant place_capacities: IntegerArray(0 to 3) := (0 => 15,1 => 1,2 => 1,3 => 1);
      constant place_markings: IntegerArray(0 to 3)  := (0 => 0,1 => 1,2 => 1,3 => 1);
      constant place_delays: IntegerArray(0 to 3) := (0 => 0,1 => 1,2 => 0,3 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_173"; 
      signal preds: BooleanArray(1 to 4); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(275) & zeropad3D_CP_182_elements(279);
      gj_zeropad3D_cp_element_group_173 : generic_join generic map(name => joinName, number_of_predecessors => 4, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(173), clk => clk, reset => reset); --
    end block;
    -- CP-element group 174:  join  transition  bypass  pipeline-parent 
    -- CP-element group 174: predecessors 
    -- CP-element group 174: 	131 
    -- CP-element group 174: marked-predecessors 
    -- CP-element group 174: 	178 
    -- CP-element group 174: 	262 
    -- CP-element group 174: successors 
    -- CP-element group 174: 	135 
    -- CP-element group 174:  members (1) 
      -- CP-element group 174: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_update_start_
      -- 
    zeropad3D_cp_element_group_174: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_174"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(178) & zeropad3D_CP_182_elements(262);
      gj_zeropad3D_cp_element_group_174 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(174), clk => clk, reset => reset); --
    end block;
    -- CP-element group 175:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 175: predecessors 
    -- CP-element group 175: 	133 
    -- CP-element group 175: successors 
    -- CP-element group 175:  members (1) 
      -- CP-element group 175: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_sample_start__ps
      -- 
    zeropad3D_CP_182_elements(175) <= zeropad3D_CP_182_elements(133);
    -- CP-element group 176:  join  transition  bypass  pipeline-parent 
    -- CP-element group 176: predecessors 
    -- CP-element group 176: successors 
    -- CP-element group 176: 	134 
    -- CP-element group 176:  members (1) 
      -- CP-element group 176: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(176) is bound as output of CP function.
    -- CP-element group 177:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 177: predecessors 
    -- CP-element group 177: 	135 
    -- CP-element group 177: successors 
    -- CP-element group 177:  members (1) 
      -- CP-element group 177: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_update_start__ps
      -- 
    zeropad3D_CP_182_elements(177) <= zeropad3D_CP_182_elements(135);
    -- CP-element group 178:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 178: predecessors 
    -- CP-element group 178: successors 
    -- CP-element group 178: 	132 
    -- CP-element group 178: 	136 
    -- CP-element group 178: 	260 
    -- CP-element group 178: marked-successors 
    -- CP-element group 178: 	174 
    -- CP-element group 178:  members (2) 
      -- CP-element group 178: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_update_completed__ps
      -- CP-element group 178: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(178) is bound as output of CP function.
    -- CP-element group 179:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 179: predecessors 
    -- CP-element group 179: 	129 
    -- CP-element group 179: successors 
    -- CP-element group 179:  members (1) 
      -- CP-element group 179: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_loopback_trigger
      -- 
    zeropad3D_CP_182_elements(179) <= zeropad3D_CP_182_elements(129);
    -- CP-element group 180:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 180: predecessors 
    -- CP-element group 180: successors 
    -- CP-element group 180:  members (2) 
      -- CP-element group 180: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_loopback_sample_req_ps
      -- CP-element group 180: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_loopback_sample_req
      -- 
    phi_stmt_577_loopback_sample_req_1251_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_577_loopback_sample_req_1251_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(180), ack => phi_stmt_577_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(180) is bound as output of CP function.
    -- CP-element group 181:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 181: predecessors 
    -- CP-element group 181: 	130 
    -- CP-element group 181: successors 
    -- CP-element group 181:  members (1) 
      -- CP-element group 181: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_entry_trigger
      -- 
    zeropad3D_CP_182_elements(181) <= zeropad3D_CP_182_elements(130);
    -- CP-element group 182:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 182: predecessors 
    -- CP-element group 182: successors 
    -- CP-element group 182:  members (2) 
      -- CP-element group 182: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_entry_sample_req_ps
      -- CP-element group 182: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_entry_sample_req
      -- 
    phi_stmt_577_entry_sample_req_1254_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_577_entry_sample_req_1254_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(182), ack => phi_stmt_577_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(182) is bound as output of CP function.
    -- CP-element group 183:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 183: predecessors 
    -- CP-element group 183: successors 
    -- CP-element group 183:  members (2) 
      -- CP-element group 183: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_phi_mux_ack_ps
      -- CP-element group 183: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_577_phi_mux_ack
      -- 
    phi_stmt_577_phi_mux_ack_1257_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 183_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_577_ack_0, ack => zeropad3D_CP_182_elements(183)); -- 
    -- CP-element group 184:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 184: predecessors 
    -- CP-element group 184: successors 
    -- CP-element group 184:  members (4) 
      -- CP-element group 184: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_sample_start__ps
      -- CP-element group 184: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_sample_start_
      -- CP-element group 184: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_sample_completed_
      -- CP-element group 184: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(184) is bound as output of CP function.
    -- CP-element group 185:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 185: predecessors 
    -- CP-element group 185: successors 
    -- CP-element group 185: 	187 
    -- CP-element group 185:  members (2) 
      -- CP-element group 185: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_update_start__ps
      -- CP-element group 185: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_update_start_
      -- 
    -- Element group zeropad3D_CP_182_elements(185) is bound as output of CP function.
    -- CP-element group 186:  join  transition  bypass  pipeline-parent 
    -- CP-element group 186: predecessors 
    -- CP-element group 186: 	187 
    -- CP-element group 186: successors 
    -- CP-element group 186:  members (1) 
      -- CP-element group 186: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_update_completed__ps
      -- 
    zeropad3D_CP_182_elements(186) <= zeropad3D_CP_182_elements(187);
    -- CP-element group 187:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 187: predecessors 
    -- CP-element group 187: 	185 
    -- CP-element group 187: successors 
    -- CP-element group 187: 	186 
    -- CP-element group 187:  members (1) 
      -- CP-element group 187: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_i_loop_init_579_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(187) is a control-delay.
    cp_element_187_delay: control_delay_element  generic map(name => " 187_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(185), ack => zeropad3D_CP_182_elements(187), clk => clk, reset =>reset);
    -- CP-element group 188:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 188: predecessors 
    -- CP-element group 188: successors 
    -- CP-element group 188: 	190 
    -- CP-element group 188:  members (4) 
      -- CP-element group 188: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Sample/req
      -- CP-element group 188: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_sample_start__ps
      -- CP-element group 188: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Sample/$entry
      -- CP-element group 188: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_sample_start_
      -- 
    req_1278_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1278_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(188), ack => next_i_loop_816_580_buf_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(188) is bound as output of CP function.
    -- CP-element group 189:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 189: predecessors 
    -- CP-element group 189: successors 
    -- CP-element group 189: 	191 
    -- CP-element group 189:  members (4) 
      -- CP-element group 189: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Update/$entry
      -- CP-element group 189: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Update/req
      -- CP-element group 189: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_update_start_
      -- CP-element group 189: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_update_start__ps
      -- 
    req_1283_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1283_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(189), ack => next_i_loop_816_580_buf_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(189) is bound as output of CP function.
    -- CP-element group 190:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 190: predecessors 
    -- CP-element group 190: 	188 
    -- CP-element group 190: successors 
    -- CP-element group 190:  members (4) 
      -- CP-element group 190: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Sample/ack
      -- CP-element group 190: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Sample/$exit
      -- CP-element group 190: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_sample_completed__ps
      -- CP-element group 190: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_sample_completed_
      -- 
    ack_1279_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 190_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_i_loop_816_580_buf_ack_0, ack => zeropad3D_CP_182_elements(190)); -- 
    -- CP-element group 191:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 191: predecessors 
    -- CP-element group 191: 	189 
    -- CP-element group 191: successors 
    -- CP-element group 191:  members (4) 
      -- CP-element group 191: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Update/$exit
      -- CP-element group 191: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_update_completed_
      -- CP-element group 191: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_Update/ack
      -- CP-element group 191: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_i_loop_580_update_completed__ps
      -- 
    ack_1284_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 191_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_i_loop_816_580_buf_ack_1, ack => zeropad3D_CP_182_elements(191)); -- 
    -- CP-element group 192:  join  transition  bypass  pipeline-parent 
    -- CP-element group 192: predecessors 
    -- CP-element group 192: 	131 
    -- CP-element group 192: marked-predecessors 
    -- CP-element group 192: 	134 
    -- CP-element group 192: successors 
    -- CP-element group 192: 	133 
    -- CP-element group 192:  members (1) 
      -- CP-element group 192: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_sample_start_
      -- 
    zeropad3D_cp_element_group_192: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_192"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(134);
      gj_zeropad3D_cp_element_group_192 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(192), clk => clk, reset => reset); --
    end block;
    -- CP-element group 193:  join  transition  bypass  pipeline-parent 
    -- CP-element group 193: predecessors 
    -- CP-element group 193: 	131 
    -- CP-element group 193: marked-predecessors 
    -- CP-element group 193: 	197 
    -- CP-element group 193: 	252 
    -- CP-element group 193: successors 
    -- CP-element group 193: 	135 
    -- CP-element group 193:  members (1) 
      -- CP-element group 193: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_update_start_
      -- 
    zeropad3D_cp_element_group_193: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_193"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(197) & zeropad3D_CP_182_elements(252);
      gj_zeropad3D_cp_element_group_193 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(193), clk => clk, reset => reset); --
    end block;
    -- CP-element group 194:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 194: predecessors 
    -- CP-element group 194: 	133 
    -- CP-element group 194: successors 
    -- CP-element group 194:  members (1) 
      -- CP-element group 194: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_sample_start__ps
      -- 
    zeropad3D_CP_182_elements(194) <= zeropad3D_CP_182_elements(133);
    -- CP-element group 195:  join  transition  bypass  pipeline-parent 
    -- CP-element group 195: predecessors 
    -- CP-element group 195: successors 
    -- CP-element group 195: 	134 
    -- CP-element group 195:  members (1) 
      -- CP-element group 195: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(195) is bound as output of CP function.
    -- CP-element group 196:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 196: predecessors 
    -- CP-element group 196: 	135 
    -- CP-element group 196: successors 
    -- CP-element group 196:  members (1) 
      -- CP-element group 196: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_update_start__ps
      -- 
    zeropad3D_CP_182_elements(196) <= zeropad3D_CP_182_elements(135);
    -- CP-element group 197:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 197: predecessors 
    -- CP-element group 197: successors 
    -- CP-element group 197: 	136 
    -- CP-element group 197: 	252 
    -- CP-element group 197: marked-successors 
    -- CP-element group 197: 	193 
    -- CP-element group 197:  members (15) 
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_update_completed_
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_update_completed__ps
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_resized_1
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_scaled_1
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_computed_1
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_resize_1/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_resize_1/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_resize_1/index_resize_req
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_resize_1/index_resize_ack
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_scale_1/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_scale_1/$exit
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_scale_1/scale_rename_req
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_index_scale_1/scale_rename_ack
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Sample/$entry
      -- CP-element group 197: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Sample/req
      -- 
    req_1522_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1522_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(197), ack => array_obj_ref_712_index_offset_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(197) is bound as output of CP function.
    -- CP-element group 198:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 198: predecessors 
    -- CP-element group 198: 	129 
    -- CP-element group 198: successors 
    -- CP-element group 198:  members (1) 
      -- CP-element group 198: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_loopback_trigger
      -- 
    zeropad3D_CP_182_elements(198) <= zeropad3D_CP_182_elements(129);
    -- CP-element group 199:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 199: predecessors 
    -- CP-element group 199: successors 
    -- CP-element group 199:  members (2) 
      -- CP-element group 199: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_loopback_sample_req
      -- CP-element group 199: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_loopback_sample_req_ps
      -- 
    phi_stmt_581_loopback_sample_req_1295_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_581_loopback_sample_req_1295_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(199), ack => phi_stmt_581_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(199) is bound as output of CP function.
    -- CP-element group 200:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 200: predecessors 
    -- CP-element group 200: 	130 
    -- CP-element group 200: successors 
    -- CP-element group 200:  members (1) 
      -- CP-element group 200: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_entry_trigger
      -- 
    zeropad3D_CP_182_elements(200) <= zeropad3D_CP_182_elements(130);
    -- CP-element group 201:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 201: predecessors 
    -- CP-element group 201: successors 
    -- CP-element group 201:  members (2) 
      -- CP-element group 201: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_entry_sample_req
      -- CP-element group 201: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_entry_sample_req_ps
      -- 
    phi_stmt_581_entry_sample_req_1298_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_581_entry_sample_req_1298_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(201), ack => phi_stmt_581_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(201) is bound as output of CP function.
    -- CP-element group 202:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 202: predecessors 
    -- CP-element group 202: successors 
    -- CP-element group 202:  members (2) 
      -- CP-element group 202: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_phi_mux_ack_ps
      -- CP-element group 202: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_581_phi_mux_ack
      -- 
    phi_stmt_581_phi_mux_ack_1301_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 202_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_581_ack_0, ack => zeropad3D_CP_182_elements(202)); -- 
    -- CP-element group 203:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 203: predecessors 
    -- CP-element group 203: successors 
    -- CP-element group 203:  members (4) 
      -- CP-element group 203: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_sample_start__ps
      -- CP-element group 203: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_sample_completed__ps
      -- CP-element group 203: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_sample_start_
      -- CP-element group 203: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_sample_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(203) is bound as output of CP function.
    -- CP-element group 204:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 204: predecessors 
    -- CP-element group 204: successors 
    -- CP-element group 204: 	206 
    -- CP-element group 204:  members (2) 
      -- CP-element group 204: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_update_start__ps
      -- CP-element group 204: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_update_start_
      -- 
    -- Element group zeropad3D_CP_182_elements(204) is bound as output of CP function.
    -- CP-element group 205:  join  transition  bypass  pipeline-parent 
    -- CP-element group 205: predecessors 
    -- CP-element group 205: 	206 
    -- CP-element group 205: successors 
    -- CP-element group 205:  members (1) 
      -- CP-element group 205: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_update_completed__ps
      -- 
    zeropad3D_CP_182_elements(205) <= zeropad3D_CP_182_elements(206);
    -- CP-element group 206:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 206: predecessors 
    -- CP-element group 206: 	204 
    -- CP-element group 206: successors 
    -- CP-element group 206: 	205 
    -- CP-element group 206:  members (1) 
      -- CP-element group 206: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_dest_add_init_583_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(206) is a control-delay.
    cp_element_206_delay: control_delay_element  generic map(name => " 206_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(204), ack => zeropad3D_CP_182_elements(206), clk => clk, reset =>reset);
    -- CP-element group 207:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 207: predecessors 
    -- CP-element group 207: successors 
    -- CP-element group 207: 	209 
    -- CP-element group 207:  members (4) 
      -- CP-element group 207: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_sample_start__ps
      -- CP-element group 207: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_sample_start_
      -- CP-element group 207: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Sample/$entry
      -- CP-element group 207: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Sample/req
      -- 
    req_1322_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1322_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(207), ack => next_dest_add_689_584_buf_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(207) is bound as output of CP function.
    -- CP-element group 208:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 208: predecessors 
    -- CP-element group 208: successors 
    -- CP-element group 208: 	210 
    -- CP-element group 208:  members (4) 
      -- CP-element group 208: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_update_start__ps
      -- CP-element group 208: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_update_start_
      -- CP-element group 208: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Update/$entry
      -- CP-element group 208: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Update/req
      -- 
    req_1327_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1327_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(208), ack => next_dest_add_689_584_buf_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(208) is bound as output of CP function.
    -- CP-element group 209:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 209: predecessors 
    -- CP-element group 209: 	207 
    -- CP-element group 209: successors 
    -- CP-element group 209:  members (4) 
      -- CP-element group 209: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_sample_completed__ps
      -- CP-element group 209: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_sample_completed_
      -- CP-element group 209: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Sample/$exit
      -- CP-element group 209: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Sample/ack
      -- 
    ack_1323_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 209_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_dest_add_689_584_buf_ack_0, ack => zeropad3D_CP_182_elements(209)); -- 
    -- CP-element group 210:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 210: predecessors 
    -- CP-element group 210: 	208 
    -- CP-element group 210: successors 
    -- CP-element group 210:  members (4) 
      -- CP-element group 210: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_update_completed__ps
      -- CP-element group 210: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_update_completed_
      -- CP-element group 210: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Update/$exit
      -- CP-element group 210: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_dest_add_584_Update/ack
      -- 
    ack_1328_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 210_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_dest_add_689_584_buf_ack_1, ack => zeropad3D_CP_182_elements(210)); -- 
    -- CP-element group 211:  join  transition  bypass  pipeline-parent 
    -- CP-element group 211: predecessors 
    -- CP-element group 211: 	131 
    -- CP-element group 211: marked-predecessors 
    -- CP-element group 211: 	134 
    -- CP-element group 211: successors 
    -- CP-element group 211: 	133 
    -- CP-element group 211:  members (1) 
      -- CP-element group 211: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_sample_start_
      -- 
    zeropad3D_cp_element_group_211: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_211"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(134);
      gj_zeropad3D_cp_element_group_211 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(211), clk => clk, reset => reset); --
    end block;
    -- CP-element group 212:  join  transition  bypass  pipeline-parent 
    -- CP-element group 212: predecessors 
    -- CP-element group 212: 	131 
    -- CP-element group 212: marked-predecessors 
    -- CP-element group 212: 	216 
    -- CP-element group 212: 	241 
    -- CP-element group 212: successors 
    -- CP-element group 212: 	135 
    -- CP-element group 212:  members (1) 
      -- CP-element group 212: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_update_start_
      -- 
    zeropad3D_cp_element_group_212: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_212"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(216) & zeropad3D_CP_182_elements(241);
      gj_zeropad3D_cp_element_group_212 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(212), clk => clk, reset => reset); --
    end block;
    -- CP-element group 213:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 213: predecessors 
    -- CP-element group 213: 	133 
    -- CP-element group 213: successors 
    -- CP-element group 213:  members (1) 
      -- CP-element group 213: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_sample_start__ps
      -- 
    zeropad3D_CP_182_elements(213) <= zeropad3D_CP_182_elements(133);
    -- CP-element group 214:  join  transition  bypass  pipeline-parent 
    -- CP-element group 214: predecessors 
    -- CP-element group 214: successors 
    -- CP-element group 214: 	134 
    -- CP-element group 214:  members (1) 
      -- CP-element group 214: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_sample_completed__ps
      -- 
    -- Element group zeropad3D_CP_182_elements(214) is bound as output of CP function.
    -- CP-element group 215:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 215: predecessors 
    -- CP-element group 215: 	135 
    -- CP-element group 215: successors 
    -- CP-element group 215:  members (1) 
      -- CP-element group 215: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_update_start__ps
      -- 
    zeropad3D_CP_182_elements(215) <= zeropad3D_CP_182_elements(135);
    -- CP-element group 216:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 216: predecessors 
    -- CP-element group 216: successors 
    -- CP-element group 216: 	136 
    -- CP-element group 216: 	241 
    -- CP-element group 216: marked-successors 
    -- CP-element group 216: 	212 
    -- CP-element group 216:  members (15) 
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_update_completed_
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_update_completed__ps
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_resized_1
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_scaled_1
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_computed_1
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_resize_1/$entry
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_resize_1/$exit
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_resize_1/index_resize_req
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_resize_1/index_resize_ack
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_scale_1/$entry
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_scale_1/$exit
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_scale_1/scale_rename_req
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_index_scale_1/scale_rename_ack
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Sample/$entry
      -- CP-element group 216: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Sample/req
      -- 
    req_1426_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1426_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(216), ack => array_obj_ref_700_index_offset_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(216) is bound as output of CP function.
    -- CP-element group 217:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 217: predecessors 
    -- CP-element group 217: 	129 
    -- CP-element group 217: successors 
    -- CP-element group 217:  members (1) 
      -- CP-element group 217: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_loopback_trigger
      -- 
    zeropad3D_CP_182_elements(217) <= zeropad3D_CP_182_elements(129);
    -- CP-element group 218:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 218: predecessors 
    -- CP-element group 218: successors 
    -- CP-element group 218:  members (2) 
      -- CP-element group 218: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_loopback_sample_req
      -- CP-element group 218: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_loopback_sample_req_ps
      -- 
    phi_stmt_585_loopback_sample_req_1339_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_585_loopback_sample_req_1339_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(218), ack => phi_stmt_585_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(218) is bound as output of CP function.
    -- CP-element group 219:  fork  transition  bypass  pipeline-parent 
    -- CP-element group 219: predecessors 
    -- CP-element group 219: 	130 
    -- CP-element group 219: successors 
    -- CP-element group 219:  members (1) 
      -- CP-element group 219: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_entry_trigger
      -- 
    zeropad3D_CP_182_elements(219) <= zeropad3D_CP_182_elements(130);
    -- CP-element group 220:  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 220: predecessors 
    -- CP-element group 220: successors 
    -- CP-element group 220:  members (2) 
      -- CP-element group 220: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_entry_sample_req
      -- CP-element group 220: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_entry_sample_req_ps
      -- 
    phi_stmt_585_entry_sample_req_1342_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_585_entry_sample_req_1342_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(220), ack => phi_stmt_585_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(220) is bound as output of CP function.
    -- CP-element group 221:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 221: predecessors 
    -- CP-element group 221: successors 
    -- CP-element group 221:  members (2) 
      -- CP-element group 221: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_phi_mux_ack
      -- CP-element group 221: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/phi_stmt_585_phi_mux_ack_ps
      -- 
    phi_stmt_585_phi_mux_ack_1345_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 221_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_585_ack_0, ack => zeropad3D_CP_182_elements(221)); -- 
    -- CP-element group 222:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 222: predecessors 
    -- CP-element group 222: successors 
    -- CP-element group 222:  members (4) 
      -- CP-element group 222: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_sample_start__ps
      -- CP-element group 222: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_sample_completed__ps
      -- CP-element group 222: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_sample_start_
      -- CP-element group 222: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_sample_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(222) is bound as output of CP function.
    -- CP-element group 223:  join  fork  transition  bypass  pipeline-parent 
    -- CP-element group 223: predecessors 
    -- CP-element group 223: successors 
    -- CP-element group 223: 	225 
    -- CP-element group 223:  members (2) 
      -- CP-element group 223: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_update_start__ps
      -- CP-element group 223: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_update_start_
      -- 
    -- Element group zeropad3D_CP_182_elements(223) is bound as output of CP function.
    -- CP-element group 224:  join  transition  bypass  pipeline-parent 
    -- CP-element group 224: predecessors 
    -- CP-element group 224: 	225 
    -- CP-element group 224: successors 
    -- CP-element group 224:  members (1) 
      -- CP-element group 224: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_update_completed__ps
      -- 
    zeropad3D_CP_182_elements(224) <= zeropad3D_CP_182_elements(225);
    -- CP-element group 225:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 225: predecessors 
    -- CP-element group 225: 	223 
    -- CP-element group 225: successors 
    -- CP-element group 225: 	224 
    -- CP-element group 225:  members (1) 
      -- CP-element group 225: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_src_add_init_587_update_completed_
      -- 
    -- Element group zeropad3D_CP_182_elements(225) is a control-delay.
    cp_element_225_delay: control_delay_element  generic map(name => " 225_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(223), ack => zeropad3D_CP_182_elements(225), clk => clk, reset =>reset);
    -- CP-element group 226:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 226: predecessors 
    -- CP-element group 226: successors 
    -- CP-element group 226: 	228 
    -- CP-element group 226:  members (4) 
      -- CP-element group 226: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_sample_start__ps
      -- CP-element group 226: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_sample_start_
      -- CP-element group 226: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Sample/$entry
      -- CP-element group 226: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Sample/req
      -- 
    req_1366_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1366_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(226), ack => next_src_add_694_588_buf_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(226) is bound as output of CP function.
    -- CP-element group 227:  join  fork  transition  output  bypass  pipeline-parent 
    -- CP-element group 227: predecessors 
    -- CP-element group 227: successors 
    -- CP-element group 227: 	229 
    -- CP-element group 227:  members (4) 
      -- CP-element group 227: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_update_start__ps
      -- CP-element group 227: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_update_start_
      -- CP-element group 227: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Update/$entry
      -- CP-element group 227: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Update/req
      -- 
    req_1371_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1371_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(227), ack => next_src_add_694_588_buf_req_1); -- 
    -- Element group zeropad3D_CP_182_elements(227) is bound as output of CP function.
    -- CP-element group 228:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 228: predecessors 
    -- CP-element group 228: 	226 
    -- CP-element group 228: successors 
    -- CP-element group 228:  members (4) 
      -- CP-element group 228: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_sample_completed__ps
      -- CP-element group 228: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_sample_completed_
      -- CP-element group 228: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Sample/$exit
      -- CP-element group 228: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Sample/ack
      -- 
    ack_1367_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 228_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_src_add_694_588_buf_ack_0, ack => zeropad3D_CP_182_elements(228)); -- 
    -- CP-element group 229:  join  transition  input  bypass  pipeline-parent 
    -- CP-element group 229: predecessors 
    -- CP-element group 229: 	227 
    -- CP-element group 229: successors 
    -- CP-element group 229:  members (4) 
      -- CP-element group 229: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_update_completed__ps
      -- CP-element group 229: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_update_completed_
      -- CP-element group 229: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Update/$exit
      -- CP-element group 229: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/R_next_src_add_588_Update/ack
      -- 
    ack_1372_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 229_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => next_src_add_694_588_buf_ack_1, ack => zeropad3D_CP_182_elements(229)); -- 
    -- CP-element group 230:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 230: predecessors 
    -- CP-element group 230: 	131 
    -- CP-element group 230: marked-predecessors 
    -- CP-element group 230: 	232 
    -- CP-element group 230: successors 
    -- CP-element group 230: 	232 
    -- CP-element group 230:  members (3) 
      -- CP-element group 230: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_sample_start_
      -- CP-element group 230: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Sample/$entry
      -- CP-element group 230: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Sample/rr
      -- 
    rr_1381_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1381_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(230), ack => ADD_u16_u16_653_inst_req_0); -- 
    zeropad3D_cp_element_group_230: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_230"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(232);
      gj_zeropad3D_cp_element_group_230 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(230), clk => clk, reset => reset); --
    end block;
    -- CP-element group 231:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 231: predecessors 
    -- CP-element group 231: marked-predecessors 
    -- CP-element group 231: 	233 
    -- CP-element group 231: 	262 
    -- CP-element group 231: successors 
    -- CP-element group 231: 	233 
    -- CP-element group 231:  members (3) 
      -- CP-element group 231: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_update_start_
      -- CP-element group 231: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Update/$entry
      -- CP-element group 231: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Update/cr
      -- 
    cr_1386_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1386_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(231), ack => ADD_u16_u16_653_inst_req_1); -- 
    zeropad3D_cp_element_group_231: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_231"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(233) & zeropad3D_CP_182_elements(262);
      gj_zeropad3D_cp_element_group_231 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(231), clk => clk, reset => reset); --
    end block;
    -- CP-element group 232:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 232: predecessors 
    -- CP-element group 232: 	230 
    -- CP-element group 232: successors 
    -- CP-element group 232: marked-successors 
    -- CP-element group 232: 	230 
    -- CP-element group 232:  members (3) 
      -- CP-element group 232: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_sample_completed_
      -- CP-element group 232: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Sample/$exit
      -- CP-element group 232: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Sample/ra
      -- 
    ra_1382_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 232_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_653_inst_ack_0, ack => zeropad3D_CP_182_elements(232)); -- 
    -- CP-element group 233:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 233: predecessors 
    -- CP-element group 233: 	231 
    -- CP-element group 233: successors 
    -- CP-element group 233: 	260 
    -- CP-element group 233: marked-successors 
    -- CP-element group 233: 	231 
    -- CP-element group 233:  members (3) 
      -- CP-element group 233: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_update_completed_
      -- CP-element group 233: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Update/$exit
      -- CP-element group 233: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_653_Update/ca
      -- 
    ca_1387_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 233_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_653_inst_ack_1, ack => zeropad3D_CP_182_elements(233)); -- 
    -- CP-element group 234:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 234: predecessors 
    -- CP-element group 234: 	131 
    -- CP-element group 234: marked-predecessors 
    -- CP-element group 234: 	236 
    -- CP-element group 234: successors 
    -- CP-element group 234: 	236 
    -- CP-element group 234:  members (3) 
      -- CP-element group 234: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_sample_start_
      -- CP-element group 234: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Sample/$entry
      -- CP-element group 234: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Sample/rr
      -- 
    rr_1395_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1395_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(234), ack => ADD_u16_u16_663_inst_req_0); -- 
    zeropad3D_cp_element_group_234: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_234"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(236);
      gj_zeropad3D_cp_element_group_234 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(234), clk => clk, reset => reset); --
    end block;
    -- CP-element group 235:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 235: predecessors 
    -- CP-element group 235: marked-predecessors 
    -- CP-element group 235: 	237 
    -- CP-element group 235: 	262 
    -- CP-element group 235: successors 
    -- CP-element group 235: 	237 
    -- CP-element group 235:  members (3) 
      -- CP-element group 235: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_update_start_
      -- CP-element group 235: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Update/$entry
      -- CP-element group 235: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Update/cr
      -- 
    cr_1400_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1400_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(235), ack => ADD_u16_u16_663_inst_req_1); -- 
    zeropad3D_cp_element_group_235: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_235"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(237) & zeropad3D_CP_182_elements(262);
      gj_zeropad3D_cp_element_group_235 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(235), clk => clk, reset => reset); --
    end block;
    -- CP-element group 236:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 236: predecessors 
    -- CP-element group 236: 	234 
    -- CP-element group 236: successors 
    -- CP-element group 236: marked-successors 
    -- CP-element group 236: 	234 
    -- CP-element group 236:  members (3) 
      -- CP-element group 236: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_sample_completed_
      -- CP-element group 236: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Sample/$exit
      -- CP-element group 236: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Sample/ra
      -- 
    ra_1396_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 236_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_663_inst_ack_0, ack => zeropad3D_CP_182_elements(236)); -- 
    -- CP-element group 237:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 237: predecessors 
    -- CP-element group 237: 	235 
    -- CP-element group 237: successors 
    -- CP-element group 237: 	260 
    -- CP-element group 237: marked-successors 
    -- CP-element group 237: 	235 
    -- CP-element group 237:  members (3) 
      -- CP-element group 237: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_update_completed_
      -- CP-element group 237: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Update/$exit
      -- CP-element group 237: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ADD_u16_u16_663_Update/ca
      -- 
    ca_1401_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 237_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ADD_u16_u16_663_inst_ack_1, ack => zeropad3D_CP_182_elements(237)); -- 
    -- CP-element group 238:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 238: predecessors 
    -- CP-element group 238: 	242 
    -- CP-element group 238: marked-predecessors 
    -- CP-element group 238: 	243 
    -- CP-element group 238: successors 
    -- CP-element group 238: 	243 
    -- CP-element group 238:  members (3) 
      -- CP-element group 238: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_sample_start_
      -- CP-element group 238: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_request/$entry
      -- CP-element group 238: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_request/req
      -- 
    req_1441_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1441_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(238), ack => addr_of_701_final_reg_req_0); -- 
    zeropad3D_cp_element_group_238: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_238"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(242) & zeropad3D_CP_182_elements(243);
      gj_zeropad3D_cp_element_group_238 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(238), clk => clk, reset => reset); --
    end block;
    -- CP-element group 239:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 239: predecessors 
    -- CP-element group 239: 	131 
    -- CP-element group 239: marked-predecessors 
    -- CP-element group 239: 	244 
    -- CP-element group 239: 	247 
    -- CP-element group 239: successors 
    -- CP-element group 239: 	244 
    -- CP-element group 239:  members (3) 
      -- CP-element group 239: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_update_start_
      -- CP-element group 239: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_complete/$entry
      -- CP-element group 239: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_complete/req
      -- 
    req_1446_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1446_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(239), ack => addr_of_701_final_reg_req_1); -- 
    zeropad3D_cp_element_group_239: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_239"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(244) & zeropad3D_CP_182_elements(247);
      gj_zeropad3D_cp_element_group_239 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(239), clk => clk, reset => reset); --
    end block;
    -- CP-element group 240:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 240: predecessors 
    -- CP-element group 240: 	131 
    -- CP-element group 240: marked-predecessors 
    -- CP-element group 240: 	242 
    -- CP-element group 240: 	243 
    -- CP-element group 240: successors 
    -- CP-element group 240: 	242 
    -- CP-element group 240:  members (3) 
      -- CP-element group 240: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_update_start
      -- CP-element group 240: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Update/$entry
      -- CP-element group 240: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Update/req
      -- 
    req_1431_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1431_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(240), ack => array_obj_ref_700_index_offset_req_1); -- 
    zeropad3D_cp_element_group_240: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_240"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(242) & zeropad3D_CP_182_elements(243);
      gj_zeropad3D_cp_element_group_240 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(240), clk => clk, reset => reset); --
    end block;
    -- CP-element group 241:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 241: predecessors 
    -- CP-element group 241: 	216 
    -- CP-element group 241: successors 
    -- CP-element group 241: 	285 
    -- CP-element group 241: marked-successors 
    -- CP-element group 241: 	212 
    -- CP-element group 241:  members (3) 
      -- CP-element group 241: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_sample_complete
      -- CP-element group 241: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Sample/$exit
      -- CP-element group 241: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Sample/ack
      -- 
    ack_1427_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 241_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_700_index_offset_ack_0, ack => zeropad3D_CP_182_elements(241)); -- 
    -- CP-element group 242:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 242: predecessors 
    -- CP-element group 242: 	240 
    -- CP-element group 242: successors 
    -- CP-element group 242: 	238 
    -- CP-element group 242: marked-successors 
    -- CP-element group 242: 	240 
    -- CP-element group 242:  members (8) 
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_root_address_calculated
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_offset_calculated
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Update/$exit
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_final_index_sum_regn_Update/ack
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_base_plus_offset/$entry
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_base_plus_offset/$exit
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_base_plus_offset/sum_rename_req
      -- CP-element group 242: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_700_base_plus_offset/sum_rename_ack
      -- 
    ack_1432_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 242_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_700_index_offset_ack_1, ack => zeropad3D_CP_182_elements(242)); -- 
    -- CP-element group 243:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 243: predecessors 
    -- CP-element group 243: 	238 
    -- CP-element group 243: successors 
    -- CP-element group 243: marked-successors 
    -- CP-element group 243: 	238 
    -- CP-element group 243: 	240 
    -- CP-element group 243:  members (3) 
      -- CP-element group 243: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_sample_completed_
      -- CP-element group 243: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_request/$exit
      -- CP-element group 243: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_request/ack
      -- 
    ack_1442_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 243_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_701_final_reg_ack_0, ack => zeropad3D_CP_182_elements(243)); -- 
    -- CP-element group 244:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 244: predecessors 
    -- CP-element group 244: 	239 
    -- CP-element group 244: successors 
    -- CP-element group 244: 	245 
    -- CP-element group 244: marked-successors 
    -- CP-element group 244: 	239 
    -- CP-element group 244:  members (19) 
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_update_completed_
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_complete/$exit
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_701_complete/ack
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_address_calculated
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_word_address_calculated
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_root_address_calculated
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_address_resized
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_addr_resize/$entry
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_addr_resize/$exit
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_addr_resize/base_resize_req
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_addr_resize/base_resize_ack
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_plus_offset/$entry
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_plus_offset/$exit
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_plus_offset/sum_rename_req
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_base_plus_offset/sum_rename_ack
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_word_addrgen/$entry
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_word_addrgen/$exit
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_word_addrgen/root_register_req
      -- CP-element group 244: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_word_addrgen/root_register_ack
      -- 
    ack_1447_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 244_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_701_final_reg_ack_1, ack => zeropad3D_CP_182_elements(244)); -- 
    -- CP-element group 245:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 245: predecessors 
    -- CP-element group 245: 	244 
    -- CP-element group 245: marked-predecessors 
    -- CP-element group 245: 	247 
    -- CP-element group 245: successors 
    -- CP-element group 245: 	247 
    -- CP-element group 245:  members (5) 
      -- CP-element group 245: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_sample_start_
      -- CP-element group 245: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/$entry
      -- CP-element group 245: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/$entry
      -- CP-element group 245: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/word_0/$entry
      -- CP-element group 245: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/word_0/rr
      -- 
    rr_1480_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1480_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(245), ack => ptr_deref_705_load_0_req_0); -- 
    zeropad3D_cp_element_group_245: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_245"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(244) & zeropad3D_CP_182_elements(247);
      gj_zeropad3D_cp_element_group_245 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(245), clk => clk, reset => reset); --
    end block;
    -- CP-element group 246:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 246: predecessors 
    -- CP-element group 246: marked-predecessors 
    -- CP-element group 246: 	248 
    -- CP-element group 246: 	266 
    -- CP-element group 246: successors 
    -- CP-element group 246: 	248 
    -- CP-element group 246:  members (5) 
      -- CP-element group 246: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_update_start_
      -- CP-element group 246: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/$entry
      -- CP-element group 246: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/$entry
      -- CP-element group 246: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/word_0/$entry
      -- CP-element group 246: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/word_0/cr
      -- 
    cr_1491_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1491_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(246), ack => ptr_deref_705_load_0_req_1); -- 
    zeropad3D_cp_element_group_246: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_246"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(248) & zeropad3D_CP_182_elements(266);
      gj_zeropad3D_cp_element_group_246 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(246), clk => clk, reset => reset); --
    end block;
    -- CP-element group 247:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 247: predecessors 
    -- CP-element group 247: 	245 
    -- CP-element group 247: successors 
    -- CP-element group 247: marked-successors 
    -- CP-element group 247: 	239 
    -- CP-element group 247: 	245 
    -- CP-element group 247:  members (5) 
      -- CP-element group 247: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_sample_completed_
      -- CP-element group 247: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/$exit
      -- CP-element group 247: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/$exit
      -- CP-element group 247: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/word_0/$exit
      -- CP-element group 247: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Sample/word_access_start/word_0/ra
      -- 
    ra_1481_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 247_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_705_load_0_ack_0, ack => zeropad3D_CP_182_elements(247)); -- 
    -- CP-element group 248:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 248: predecessors 
    -- CP-element group 248: 	246 
    -- CP-element group 248: successors 
    -- CP-element group 248: 	264 
    -- CP-element group 248: marked-successors 
    -- CP-element group 248: 	246 
    -- CP-element group 248:  members (9) 
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_update_completed_
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/$exit
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/$exit
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/word_0/$exit
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/word_access_complete/word_0/ca
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/ptr_deref_705_Merge/$entry
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/ptr_deref_705_Merge/$exit
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/ptr_deref_705_Merge/merge_req
      -- CP-element group 248: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_705_Update/ptr_deref_705_Merge/merge_ack
      -- 
    ca_1492_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 248_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_705_load_0_ack_1, ack => zeropad3D_CP_182_elements(248)); -- 
    -- CP-element group 249:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 249: predecessors 
    -- CP-element group 249: 	253 
    -- CP-element group 249: marked-predecessors 
    -- CP-element group 249: 	254 
    -- CP-element group 249: successors 
    -- CP-element group 249: 	254 
    -- CP-element group 249:  members (3) 
      -- CP-element group 249: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_sample_start_
      -- CP-element group 249: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_request/$entry
      -- CP-element group 249: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_request/req
      -- 
    req_1537_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1537_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(249), ack => addr_of_713_final_reg_req_0); -- 
    zeropad3D_cp_element_group_249: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_249"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(253) & zeropad3D_CP_182_elements(254);
      gj_zeropad3D_cp_element_group_249 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(249), clk => clk, reset => reset); --
    end block;
    -- CP-element group 250:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 250: predecessors 
    -- CP-element group 250: 	131 
    -- CP-element group 250: marked-predecessors 
    -- CP-element group 250: 	255 
    -- CP-element group 250: 	258 
    -- CP-element group 250: successors 
    -- CP-element group 250: 	255 
    -- CP-element group 250:  members (3) 
      -- CP-element group 250: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_update_start_
      -- CP-element group 250: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_complete/$entry
      -- CP-element group 250: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_complete/req
      -- 
    req_1542_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1542_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(250), ack => addr_of_713_final_reg_req_1); -- 
    zeropad3D_cp_element_group_250: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_250"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(255) & zeropad3D_CP_182_elements(258);
      gj_zeropad3D_cp_element_group_250 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(250), clk => clk, reset => reset); --
    end block;
    -- CP-element group 251:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 251: predecessors 
    -- CP-element group 251: 	131 
    -- CP-element group 251: marked-predecessors 
    -- CP-element group 251: 	253 
    -- CP-element group 251: 	254 
    -- CP-element group 251: successors 
    -- CP-element group 251: 	253 
    -- CP-element group 251:  members (3) 
      -- CP-element group 251: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_update_start
      -- CP-element group 251: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Update/$entry
      -- CP-element group 251: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Update/req
      -- 
    req_1527_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1527_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(251), ack => array_obj_ref_712_index_offset_req_1); -- 
    zeropad3D_cp_element_group_251: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 15,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 1,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_251"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(253) & zeropad3D_CP_182_elements(254);
      gj_zeropad3D_cp_element_group_251 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(251), clk => clk, reset => reset); --
    end block;
    -- CP-element group 252:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 252: predecessors 
    -- CP-element group 252: 	197 
    -- CP-element group 252: successors 
    -- CP-element group 252: 	285 
    -- CP-element group 252: marked-successors 
    -- CP-element group 252: 	193 
    -- CP-element group 252:  members (3) 
      -- CP-element group 252: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_sample_complete
      -- CP-element group 252: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Sample/$exit
      -- CP-element group 252: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Sample/ack
      -- 
    ack_1523_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 252_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_712_index_offset_ack_0, ack => zeropad3D_CP_182_elements(252)); -- 
    -- CP-element group 253:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 253: predecessors 
    -- CP-element group 253: 	251 
    -- CP-element group 253: successors 
    -- CP-element group 253: 	249 
    -- CP-element group 253: marked-successors 
    -- CP-element group 253: 	251 
    -- CP-element group 253:  members (8) 
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_root_address_calculated
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_offset_calculated
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Update/$exit
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_final_index_sum_regn_Update/ack
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_base_plus_offset/$entry
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_base_plus_offset/$exit
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_base_plus_offset/sum_rename_req
      -- CP-element group 253: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/array_obj_ref_712_base_plus_offset/sum_rename_ack
      -- 
    ack_1528_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 253_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_712_index_offset_ack_1, ack => zeropad3D_CP_182_elements(253)); -- 
    -- CP-element group 254:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 254: predecessors 
    -- CP-element group 254: 	249 
    -- CP-element group 254: successors 
    -- CP-element group 254: marked-successors 
    -- CP-element group 254: 	249 
    -- CP-element group 254: 	251 
    -- CP-element group 254:  members (3) 
      -- CP-element group 254: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_sample_completed_
      -- CP-element group 254: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_request/$exit
      -- CP-element group 254: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_request/ack
      -- 
    ack_1538_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 254_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_713_final_reg_ack_0, ack => zeropad3D_CP_182_elements(254)); -- 
    -- CP-element group 255:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 255: predecessors 
    -- CP-element group 255: 	250 
    -- CP-element group 255: successors 
    -- CP-element group 255: 	256 
    -- CP-element group 255: marked-successors 
    -- CP-element group 255: 	250 
    -- CP-element group 255:  members (3) 
      -- CP-element group 255: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_update_completed_
      -- CP-element group 255: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_complete/$exit
      -- CP-element group 255: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/addr_of_713_complete/ack
      -- 
    ack_1543_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 255_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_713_final_reg_ack_1, ack => zeropad3D_CP_182_elements(255)); -- 
    -- CP-element group 256:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 256: predecessors 
    -- CP-element group 256: 	255 
    -- CP-element group 256: marked-predecessors 
    -- CP-element group 256: 	258 
    -- CP-element group 256: successors 
    -- CP-element group 256: 	258 
    -- CP-element group 256:  members (3) 
      -- CP-element group 256: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_sample_start_
      -- CP-element group 256: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Sample/$entry
      -- CP-element group 256: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Sample/req
      -- 
    req_1551_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1551_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(256), ack => W_ov_712_delayed_7_0_715_inst_req_0); -- 
    zeropad3D_cp_element_group_256: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_256"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(255) & zeropad3D_CP_182_elements(258);
      gj_zeropad3D_cp_element_group_256 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(256), clk => clk, reset => reset); --
    end block;
    -- CP-element group 257:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 257: predecessors 
    -- CP-element group 257: marked-predecessors 
    -- CP-element group 257: 	259 
    -- CP-element group 257: 	270 
    -- CP-element group 257: successors 
    -- CP-element group 257: 	259 
    -- CP-element group 257:  members (3) 
      -- CP-element group 257: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_update_start_
      -- CP-element group 257: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Update/$entry
      -- CP-element group 257: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Update/req
      -- 
    req_1556_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1556_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(257), ack => W_ov_712_delayed_7_0_715_inst_req_1); -- 
    zeropad3D_cp_element_group_257: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_257"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(259) & zeropad3D_CP_182_elements(270);
      gj_zeropad3D_cp_element_group_257 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(257), clk => clk, reset => reset); --
    end block;
    -- CP-element group 258:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 258: predecessors 
    -- CP-element group 258: 	256 
    -- CP-element group 258: successors 
    -- CP-element group 258: marked-successors 
    -- CP-element group 258: 	250 
    -- CP-element group 258: 	256 
    -- CP-element group 258:  members (3) 
      -- CP-element group 258: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_sample_completed_
      -- CP-element group 258: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Sample/$exit
      -- CP-element group 258: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Sample/ack
      -- 
    ack_1552_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 258_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_ov_712_delayed_7_0_715_inst_ack_0, ack => zeropad3D_CP_182_elements(258)); -- 
    -- CP-element group 259:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 259: predecessors 
    -- CP-element group 259: 	257 
    -- CP-element group 259: successors 
    -- CP-element group 259: 	268 
    -- CP-element group 259: marked-successors 
    -- CP-element group 259: 	257 
    -- CP-element group 259:  members (19) 
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_update_completed_
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Update/$exit
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_717_Update/ack
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_address_calculated
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_word_address_calculated
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_root_address_calculated
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_address_resized
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_addr_resize/$entry
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_addr_resize/$exit
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_addr_resize/base_resize_req
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_addr_resize/base_resize_ack
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_plus_offset/$entry
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_plus_offset/$exit
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_plus_offset/sum_rename_req
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_base_plus_offset/sum_rename_ack
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_word_addrgen/$entry
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_word_addrgen/$exit
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_word_addrgen/root_register_req
      -- CP-element group 259: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_word_addrgen/root_register_ack
      -- 
    ack_1557_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 259_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_ov_712_delayed_7_0_715_inst_ack_1, ack => zeropad3D_CP_182_elements(259)); -- 
    -- CP-element group 260:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 260: predecessors 
    -- CP-element group 260: 	159 
    -- CP-element group 260: 	178 
    -- CP-element group 260: 	233 
    -- CP-element group 260: 	237 
    -- CP-element group 260: marked-predecessors 
    -- CP-element group 260: 	262 
    -- CP-element group 260: successors 
    -- CP-element group 260: 	262 
    -- CP-element group 260:  members (3) 
      -- CP-element group 260: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_sample_start_
      -- CP-element group 260: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Sample/$entry
      -- CP-element group 260: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Sample/req
      -- 
    req_1565_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1565_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(260), ack => W_data_check_714_delayed_12_0_718_inst_req_0); -- 
    zeropad3D_cp_element_group_260: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 1,3 => 1,4 => 1);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 1);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_260"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(159) & zeropad3D_CP_182_elements(178) & zeropad3D_CP_182_elements(233) & zeropad3D_CP_182_elements(237) & zeropad3D_CP_182_elements(262);
      gj_zeropad3D_cp_element_group_260 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(260), clk => clk, reset => reset); --
    end block;
    -- CP-element group 261:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 261: predecessors 
    -- CP-element group 261: marked-predecessors 
    -- CP-element group 261: 	263 
    -- CP-element group 261: 	266 
    -- CP-element group 261: successors 
    -- CP-element group 261: 	263 
    -- CP-element group 261:  members (3) 
      -- CP-element group 261: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_update_start_
      -- CP-element group 261: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Update/$entry
      -- CP-element group 261: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Update/req
      -- 
    req_1570_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1570_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(261), ack => W_data_check_714_delayed_12_0_718_inst_req_1); -- 
    zeropad3D_cp_element_group_261: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_261"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(263) & zeropad3D_CP_182_elements(266);
      gj_zeropad3D_cp_element_group_261 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(261), clk => clk, reset => reset); --
    end block;
    -- CP-element group 262:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 262: predecessors 
    -- CP-element group 262: 	260 
    -- CP-element group 262: successors 
    -- CP-element group 262: marked-successors 
    -- CP-element group 262: 	155 
    -- CP-element group 262: 	174 
    -- CP-element group 262: 	231 
    -- CP-element group 262: 	235 
    -- CP-element group 262: 	260 
    -- CP-element group 262:  members (3) 
      -- CP-element group 262: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_sample_completed_
      -- CP-element group 262: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Sample/$exit
      -- CP-element group 262: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Sample/ack
      -- 
    ack_1566_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 262_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_data_check_714_delayed_12_0_718_inst_ack_0, ack => zeropad3D_CP_182_elements(262)); -- 
    -- CP-element group 263:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 263: predecessors 
    -- CP-element group 263: 	261 
    -- CP-element group 263: successors 
    -- CP-element group 263: 	264 
    -- CP-element group 263: marked-successors 
    -- CP-element group 263: 	261 
    -- CP-element group 263:  members (3) 
      -- CP-element group 263: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_update_completed_
      -- CP-element group 263: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Update/$exit
      -- CP-element group 263: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_720_Update/ack
      -- 
    ack_1571_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 263_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_data_check_714_delayed_12_0_718_inst_ack_1, ack => zeropad3D_CP_182_elements(263)); -- 
    -- CP-element group 264:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 264: predecessors 
    -- CP-element group 264: 	248 
    -- CP-element group 264: 	263 
    -- CP-element group 264: marked-predecessors 
    -- CP-element group 264: 	266 
    -- CP-element group 264: successors 
    -- CP-element group 264: 	266 
    -- CP-element group 264:  members (3) 
      -- CP-element group 264: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_sample_start_
      -- CP-element group 264: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_start/$entry
      -- CP-element group 264: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_start/req
      -- 
    req_1579_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1579_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(264), ack => MUX_727_inst_req_0); -- 
    zeropad3D_cp_element_group_264: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_264"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(248) & zeropad3D_CP_182_elements(263) & zeropad3D_CP_182_elements(266);
      gj_zeropad3D_cp_element_group_264 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(264), clk => clk, reset => reset); --
    end block;
    -- CP-element group 265:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 265: predecessors 
    -- CP-element group 265: marked-predecessors 
    -- CP-element group 265: 	267 
    -- CP-element group 265: 	270 
    -- CP-element group 265: successors 
    -- CP-element group 265: 	267 
    -- CP-element group 265:  members (3) 
      -- CP-element group 265: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_update_start_
      -- CP-element group 265: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_complete/$entry
      -- CP-element group 265: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_complete/req
      -- 
    req_1584_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1584_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(265), ack => MUX_727_inst_req_1); -- 
    zeropad3D_cp_element_group_265: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 1,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_265"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(267) & zeropad3D_CP_182_elements(270);
      gj_zeropad3D_cp_element_group_265 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(265), clk => clk, reset => reset); --
    end block;
    -- CP-element group 266:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 266: predecessors 
    -- CP-element group 266: 	264 
    -- CP-element group 266: successors 
    -- CP-element group 266: marked-successors 
    -- CP-element group 266: 	246 
    -- CP-element group 266: 	261 
    -- CP-element group 266: 	264 
    -- CP-element group 266:  members (3) 
      -- CP-element group 266: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_sample_completed_
      -- CP-element group 266: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_start/$exit
      -- CP-element group 266: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_start/ack
      -- 
    ack_1580_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 266_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_727_inst_ack_0, ack => zeropad3D_CP_182_elements(266)); -- 
    -- CP-element group 267:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 267: predecessors 
    -- CP-element group 267: 	265 
    -- CP-element group 267: successors 
    -- CP-element group 267: 	268 
    -- CP-element group 267: marked-successors 
    -- CP-element group 267: 	265 
    -- CP-element group 267:  members (3) 
      -- CP-element group 267: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_update_completed_
      -- CP-element group 267: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_complete/$exit
      -- CP-element group 267: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/MUX_727_complete/ack
      -- 
    ack_1585_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 267_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => MUX_727_inst_ack_1, ack => zeropad3D_CP_182_elements(267)); -- 
    -- CP-element group 268:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 268: predecessors 
    -- CP-element group 268: 	259 
    -- CP-element group 268: 	267 
    -- CP-element group 268: marked-predecessors 
    -- CP-element group 268: 	270 
    -- CP-element group 268: successors 
    -- CP-element group 268: 	270 
    -- CP-element group 268:  members (9) 
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_sample_start_
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/$entry
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/ptr_deref_722_Split/$entry
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/ptr_deref_722_Split/$exit
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/ptr_deref_722_Split/split_req
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/ptr_deref_722_Split/split_ack
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/$entry
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/word_0/$entry
      -- CP-element group 268: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/word_0/rr
      -- 
    rr_1623_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1623_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(268), ack => ptr_deref_722_store_0_req_0); -- 
    zeropad3D_cp_element_group_268: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 1);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_268"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(259) & zeropad3D_CP_182_elements(267) & zeropad3D_CP_182_elements(270);
      gj_zeropad3D_cp_element_group_268 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(268), clk => clk, reset => reset); --
    end block;
    -- CP-element group 269:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 269: predecessors 
    -- CP-element group 269: marked-predecessors 
    -- CP-element group 269: 	271 
    -- CP-element group 269: successors 
    -- CP-element group 269: 	271 
    -- CP-element group 269:  members (5) 
      -- CP-element group 269: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_update_start_
      -- CP-element group 269: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/$entry
      -- CP-element group 269: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/$entry
      -- CP-element group 269: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/word_0/$entry
      -- CP-element group 269: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/word_0/cr
      -- 
    cr_1634_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1634_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(269), ack => ptr_deref_722_store_0_req_1); -- 
    zeropad3D_cp_element_group_269: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_269"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_CP_182_elements(271);
      gj_zeropad3D_cp_element_group_269 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(269), clk => clk, reset => reset); --
    end block;
    -- CP-element group 270:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 270: predecessors 
    -- CP-element group 270: 	268 
    -- CP-element group 270: successors 
    -- CP-element group 270: marked-successors 
    -- CP-element group 270: 	257 
    -- CP-element group 270: 	265 
    -- CP-element group 270: 	268 
    -- CP-element group 270:  members (5) 
      -- CP-element group 270: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_sample_completed_
      -- CP-element group 270: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/$exit
      -- CP-element group 270: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/$exit
      -- CP-element group 270: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/word_0/$exit
      -- CP-element group 270: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Sample/word_access_start/word_0/ra
      -- 
    ra_1624_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 270_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_722_store_0_ack_0, ack => zeropad3D_CP_182_elements(270)); -- 
    -- CP-element group 271:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 271: predecessors 
    -- CP-element group 271: 	269 
    -- CP-element group 271: successors 
    -- CP-element group 271: 	285 
    -- CP-element group 271: marked-successors 
    -- CP-element group 271: 	269 
    -- CP-element group 271:  members (5) 
      -- CP-element group 271: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_update_completed_
      -- CP-element group 271: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/$exit
      -- CP-element group 271: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/$exit
      -- CP-element group 271: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/word_0/$exit
      -- CP-element group 271: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/ptr_deref_722_Update/word_access_complete/word_0/ca
      -- 
    ca_1635_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 271_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_722_store_0_ack_1, ack => zeropad3D_CP_182_elements(271)); -- 
    -- CP-element group 272:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 272: predecessors 
    -- CP-element group 272: 	131 
    -- CP-element group 272: marked-predecessors 
    -- CP-element group 272: 	274 
    -- CP-element group 272: successors 
    -- CP-element group 272: 	274 
    -- CP-element group 272:  members (3) 
      -- CP-element group 272: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_sample_start_
      -- CP-element group 272: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Sample/$entry
      -- CP-element group 272: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Sample/req
      -- 
    req_1643_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1643_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(272), ack => W_dim2T_dif_727_delayed_1_0_734_inst_req_0); -- 
    zeropad3D_cp_element_group_272: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_272"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(274);
      gj_zeropad3D_cp_element_group_272 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(272), clk => clk, reset => reset); --
    end block;
    -- CP-element group 273:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 273: predecessors 
    -- CP-element group 273: 	134 
    -- CP-element group 273: marked-predecessors 
    -- CP-element group 273: 	275 
    -- CP-element group 273: successors 
    -- CP-element group 273: 	275 
    -- CP-element group 273:  members (3) 
      -- CP-element group 273: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_update_start_
      -- CP-element group 273: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Update/$entry
      -- CP-element group 273: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Update/req
      -- 
    req_1648_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1648_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(273), ack => W_dim2T_dif_727_delayed_1_0_734_inst_req_1); -- 
    zeropad3D_cp_element_group_273: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_273"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(275);
      gj_zeropad3D_cp_element_group_273 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(273), clk => clk, reset => reset); --
    end block;
    -- CP-element group 274:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 274: predecessors 
    -- CP-element group 274: 	272 
    -- CP-element group 274: successors 
    -- CP-element group 274: marked-successors 
    -- CP-element group 274: 	272 
    -- CP-element group 274:  members (3) 
      -- CP-element group 274: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_sample_completed_
      -- CP-element group 274: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Sample/$exit
      -- CP-element group 274: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Sample/ack
      -- 
    ack_1644_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 274_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim2T_dif_727_delayed_1_0_734_inst_ack_0, ack => zeropad3D_CP_182_elements(274)); -- 
    -- CP-element group 275:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 275: predecessors 
    -- CP-element group 275: 	273 
    -- CP-element group 275: successors 
    -- CP-element group 275: 	132 
    -- CP-element group 275: marked-successors 
    -- CP-element group 275: 	137 
    -- CP-element group 275: 	154 
    -- CP-element group 275: 	173 
    -- CP-element group 275: 	273 
    -- CP-element group 275:  members (3) 
      -- CP-element group 275: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_update_completed_
      -- CP-element group 275: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Update/$exit
      -- CP-element group 275: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_736_Update/ack
      -- 
    ack_1649_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 275_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim2T_dif_727_delayed_1_0_734_inst_ack_1, ack => zeropad3D_CP_182_elements(275)); -- 
    -- CP-element group 276:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 276: predecessors 
    -- CP-element group 276: 	131 
    -- CP-element group 276: marked-predecessors 
    -- CP-element group 276: 	278 
    -- CP-element group 276: successors 
    -- CP-element group 276: 	278 
    -- CP-element group 276:  members (3) 
      -- CP-element group 276: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_sample_start_
      -- CP-element group 276: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Sample/$entry
      -- CP-element group 276: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Sample/req
      -- 
    req_1657_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1657_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(276), ack => W_dim1T_check_2_742_delayed_1_0_752_inst_req_0); -- 
    zeropad3D_cp_element_group_276: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_276"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(278);
      gj_zeropad3D_cp_element_group_276 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(276), clk => clk, reset => reset); --
    end block;
    -- CP-element group 277:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 277: predecessors 
    -- CP-element group 277: 	134 
    -- CP-element group 277: marked-predecessors 
    -- CP-element group 277: 	279 
    -- CP-element group 277: successors 
    -- CP-element group 277: 	279 
    -- CP-element group 277:  members (3) 
      -- CP-element group 277: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_update_start_
      -- CP-element group 277: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Update/$entry
      -- CP-element group 277: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Update/req
      -- 
    req_1662_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1662_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(277), ack => W_dim1T_check_2_742_delayed_1_0_752_inst_req_1); -- 
    zeropad3D_cp_element_group_277: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_277"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(279);
      gj_zeropad3D_cp_element_group_277 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(277), clk => clk, reset => reset); --
    end block;
    -- CP-element group 278:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 278: predecessors 
    -- CP-element group 278: 	276 
    -- CP-element group 278: successors 
    -- CP-element group 278: marked-successors 
    -- CP-element group 278: 	276 
    -- CP-element group 278:  members (3) 
      -- CP-element group 278: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_sample_completed_
      -- CP-element group 278: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Sample/$exit
      -- CP-element group 278: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Sample/ack
      -- 
    ack_1658_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 278_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim1T_check_2_742_delayed_1_0_752_inst_ack_0, ack => zeropad3D_CP_182_elements(278)); -- 
    -- CP-element group 279:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 279: predecessors 
    -- CP-element group 279: 	277 
    -- CP-element group 279: successors 
    -- CP-element group 279: 	285 
    -- CP-element group 279: marked-successors 
    -- CP-element group 279: 	154 
    -- CP-element group 279: 	173 
    -- CP-element group 279: 	277 
    -- CP-element group 279:  members (3) 
      -- CP-element group 279: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_update_completed_
      -- CP-element group 279: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Update/$exit
      -- CP-element group 279: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_754_Update/ack
      -- 
    ack_1663_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 279_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim1T_check_2_742_delayed_1_0_752_inst_ack_1, ack => zeropad3D_CP_182_elements(279)); -- 
    -- CP-element group 280:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 280: predecessors 
    -- CP-element group 280: 	131 
    -- CP-element group 280: marked-predecessors 
    -- CP-element group 280: 	282 
    -- CP-element group 280: successors 
    -- CP-element group 280: 	282 
    -- CP-element group 280:  members (3) 
      -- CP-element group 280: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_sample_start_
      -- CP-element group 280: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Sample/$entry
      -- CP-element group 280: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Sample/req
      -- 
    req_1671_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1671_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(280), ack => W_dim0T_check_2_763_delayed_1_0_776_inst_req_0); -- 
    zeropad3D_cp_element_group_280: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 15,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 1);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 1);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_280"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(131) & zeropad3D_CP_182_elements(282);
      gj_zeropad3D_cp_element_group_280 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(280), clk => clk, reset => reset); --
    end block;
    -- CP-element group 281:  join  transition  output  bypass  pipeline-parent 
    -- CP-element group 281: predecessors 
    -- CP-element group 281: marked-predecessors 
    -- CP-element group 281: 	283 
    -- CP-element group 281: successors 
    -- CP-element group 281: 	283 
    -- CP-element group 281:  members (3) 
      -- CP-element group 281: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_update_start_
      -- CP-element group 281: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Update/$entry
      -- CP-element group 281: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Update/req
      -- 
    req_1676_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1676_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(281), ack => W_dim0T_check_2_763_delayed_1_0_776_inst_req_1); -- 
    zeropad3D_cp_element_group_281: block -- 
      constant place_capacities: IntegerArray(0 to 0) := (0 => 1);
      constant place_markings: IntegerArray(0 to 0)  := (0 => 1);
      constant place_delays: IntegerArray(0 to 0) := (0 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_281"; 
      signal preds: BooleanArray(1 to 1); -- 
    begin -- 
      preds(1) <= zeropad3D_CP_182_elements(283);
      gj_zeropad3D_cp_element_group_281 : generic_join generic map(name => joinName, number_of_predecessors => 1, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(281), clk => clk, reset => reset); --
    end block;
    -- CP-element group 282:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 282: predecessors 
    -- CP-element group 282: 	280 
    -- CP-element group 282: successors 
    -- CP-element group 282: marked-successors 
    -- CP-element group 282: 	280 
    -- CP-element group 282:  members (3) 
      -- CP-element group 282: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_sample_completed_
      -- CP-element group 282: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Sample/$exit
      -- CP-element group 282: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Sample/ack
      -- 
    ack_1672_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 282_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim0T_check_2_763_delayed_1_0_776_inst_ack_0, ack => zeropad3D_CP_182_elements(282)); -- 
    -- CP-element group 283:  fork  transition  input  bypass  pipeline-parent 
    -- CP-element group 283: predecessors 
    -- CP-element group 283: 	281 
    -- CP-element group 283: successors 
    -- CP-element group 283: 	132 
    -- CP-element group 283: marked-successors 
    -- CP-element group 283: 	281 
    -- CP-element group 283:  members (3) 
      -- CP-element group 283: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_update_completed_
      -- CP-element group 283: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Update/$exit
      -- CP-element group 283: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/assign_stmt_778_Update/ack
      -- 
    ack_1677_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 283_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => W_dim0T_check_2_763_delayed_1_0_776_inst_ack_1, ack => zeropad3D_CP_182_elements(283)); -- 
    -- CP-element group 284:  transition  delay-element  bypass  pipeline-parent 
    -- CP-element group 284: predecessors 
    -- CP-element group 284: 	131 
    -- CP-element group 284: successors 
    -- CP-element group 284: 	132 
    -- CP-element group 284:  members (1) 
      -- CP-element group 284: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/loop_body_delay_to_condition_start
      -- 
    -- Element group zeropad3D_CP_182_elements(284) is a control-delay.
    cp_element_284_delay: control_delay_element  generic map(name => " 284_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(131), ack => zeropad3D_CP_182_elements(284), clk => clk, reset =>reset);
    -- CP-element group 285:  join  transition  bypass  pipeline-parent 
    -- CP-element group 285: predecessors 
    -- CP-element group 285: 	134 
    -- CP-element group 285: 	241 
    -- CP-element group 285: 	252 
    -- CP-element group 285: 	271 
    -- CP-element group 285: 	279 
    -- CP-element group 285: successors 
    -- CP-element group 285: 	128 
    -- CP-element group 285:  members (1) 
      -- CP-element group 285: 	 branch_block_stmt_49/do_while_stmt_567/do_while_stmt_567_loop_body/$exit
      -- 
    zeropad3D_cp_element_group_285: block -- 
      constant place_capacities: IntegerArray(0 to 4) := (0 => 15,1 => 15,2 => 15,3 => 15,4 => 15);
      constant place_markings: IntegerArray(0 to 4)  := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant place_delays: IntegerArray(0 to 4) := (0 => 0,1 => 0,2 => 0,3 => 0,4 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_285"; 
      signal preds: BooleanArray(1 to 5); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(134) & zeropad3D_CP_182_elements(241) & zeropad3D_CP_182_elements(252) & zeropad3D_CP_182_elements(271) & zeropad3D_CP_182_elements(279);
      gj_zeropad3D_cp_element_group_285 : generic_join generic map(name => joinName, number_of_predecessors => 5, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(285), clk => clk, reset => reset); --
    end block;
    -- CP-element group 286:  transition  input  bypass  pipeline-parent 
    -- CP-element group 286: predecessors 
    -- CP-element group 286: 	127 
    -- CP-element group 286: successors 
    -- CP-element group 286:  members (2) 
      -- CP-element group 286: 	 branch_block_stmt_49/do_while_stmt_567/loop_exit/$exit
      -- CP-element group 286: 	 branch_block_stmt_49/do_while_stmt_567/loop_exit/ack
      -- 
    ack_1682_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 286_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_567_branch_ack_0, ack => zeropad3D_CP_182_elements(286)); -- 
    -- CP-element group 287:  transition  input  bypass  pipeline-parent 
    -- CP-element group 287: predecessors 
    -- CP-element group 287: 	127 
    -- CP-element group 287: successors 
    -- CP-element group 287:  members (2) 
      -- CP-element group 287: 	 branch_block_stmt_49/do_while_stmt_567/loop_taken/$exit
      -- CP-element group 287: 	 branch_block_stmt_49/do_while_stmt_567/loop_taken/ack
      -- 
    ack_1686_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 287_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => do_while_stmt_567_branch_ack_1, ack => zeropad3D_CP_182_elements(287)); -- 
    -- CP-element group 288:  transition  bypass  pipeline-parent 
    -- CP-element group 288: predecessors 
    -- CP-element group 288: 	125 
    -- CP-element group 288: successors 
    -- CP-element group 288: 	1 
    -- CP-element group 288:  members (1) 
      -- CP-element group 288: 	 branch_block_stmt_49/do_while_stmt_567/$exit
      -- 
    zeropad3D_CP_182_elements(288) <= zeropad3D_CP_182_elements(125);
    -- CP-element group 289:  transition  input  bypass 
    -- CP-element group 289: predecessors 
    -- CP-element group 289: 	1 
    -- CP-element group 289: successors 
    -- CP-element group 289:  members (3) 
      -- CP-element group 289: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_sample_completed_
      -- CP-element group 289: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Sample/$exit
      -- CP-element group 289: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Sample/cra
      -- 
    cra_1699_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 289_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_825_call_ack_0, ack => zeropad3D_CP_182_elements(289)); -- 
    -- CP-element group 290:  transition  input  output  bypass 
    -- CP-element group 290: predecessors 
    -- CP-element group 290: 	1 
    -- CP-element group 290: successors 
    -- CP-element group 290: 	291 
    -- CP-element group 290:  members (6) 
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_update_completed_
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Update/$exit
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/call_stmt_825_Update/cca
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_sample_start_
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Sample/$entry
      -- CP-element group 290: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Sample/rr
      -- 
    cca_1704_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 290_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => call_stmt_825_call_ack_1, ack => zeropad3D_CP_182_elements(290)); -- 
    rr_1712_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1712_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(290), ack => type_cast_829_inst_req_0); -- 
    -- CP-element group 291:  transition  input  bypass 
    -- CP-element group 291: predecessors 
    -- CP-element group 291: 	290 
    -- CP-element group 291: successors 
    -- CP-element group 291:  members (3) 
      -- CP-element group 291: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_sample_completed_
      -- CP-element group 291: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Sample/$exit
      -- CP-element group 291: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Sample/ra
      -- 
    ra_1713_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 291_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_829_inst_ack_0, ack => zeropad3D_CP_182_elements(291)); -- 
    -- CP-element group 292:  fork  transition  place  input  output  bypass 
    -- CP-element group 292: predecessors 
    -- CP-element group 292: 	1 
    -- CP-element group 292: successors 
    -- CP-element group 292: 	293 
    -- CP-element group 292: 	294 
    -- CP-element group 292: 	295 
    -- CP-element group 292: 	296 
    -- CP-element group 292: 	297 
    -- CP-element group 292: 	298 
    -- CP-element group 292: 	299 
    -- CP-element group 292: 	300 
    -- CP-element group 292: 	301 
    -- CP-element group 292: 	302 
    -- CP-element group 292: 	303 
    -- CP-element group 292: 	304 
    -- CP-element group 292: 	305 
    -- CP-element group 292: 	306 
    -- CP-element group 292: 	307 
    -- CP-element group 292: 	308 
    -- CP-element group 292:  members (55) 
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835__exit__
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934__entry__
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/$exit
      -- CP-element group 292: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_update_completed_
      -- CP-element group 292: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Update/$exit
      -- CP-element group 292: 	 branch_block_stmt_49/call_stmt_825_to_assign_stmt_835/type_cast_829_Update/ca
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_update_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Sample/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Sample/rr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Update/$entry
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Update/cr
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_sample_start_
      -- CP-element group 292: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_update_start_
      -- 
    ca_1718_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 292_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_829_inst_ack_1, ack => zeropad3D_CP_182_elements(292)); -- 
    cr_1818_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1818_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_899_inst_req_1); -- 
    rr_1827_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1827_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_909_inst_req_0); -- 
    cr_1804_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1804_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_889_inst_req_1); -- 
    rr_1799_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1799_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_889_inst_req_0); -- 
    rr_1813_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1813_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_899_inst_req_0); -- 
    cr_1790_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1790_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_879_inst_req_1); -- 
    rr_1785_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1785_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_879_inst_req_0); -- 
    cr_1832_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1832_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_909_inst_req_1); -- 
    rr_1729_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1729_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_839_inst_req_0); -- 
    cr_1734_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1734_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_839_inst_req_1); -- 
    rr_1743_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1743_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_849_inst_req_0); -- 
    cr_1748_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1748_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_849_inst_req_1); -- 
    rr_1757_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1757_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_859_inst_req_0); -- 
    cr_1762_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1762_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_859_inst_req_1); -- 
    rr_1771_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1771_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_869_inst_req_0); -- 
    cr_1776_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1776_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(292), ack => type_cast_869_inst_req_1); -- 
    -- CP-element group 293:  transition  input  bypass 
    -- CP-element group 293: predecessors 
    -- CP-element group 293: 	292 
    -- CP-element group 293: successors 
    -- CP-element group 293:  members (3) 
      -- CP-element group 293: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_sample_completed_
      -- CP-element group 293: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Sample/$exit
      -- CP-element group 293: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Sample/ra
      -- 
    ra_1730_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 293_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_839_inst_ack_0, ack => zeropad3D_CP_182_elements(293)); -- 
    -- CP-element group 294:  transition  input  bypass 
    -- CP-element group 294: predecessors 
    -- CP-element group 294: 	292 
    -- CP-element group 294: successors 
    -- CP-element group 294: 	329 
    -- CP-element group 294:  members (3) 
      -- CP-element group 294: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_update_completed_
      -- CP-element group 294: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Update/$exit
      -- CP-element group 294: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_839_Update/ca
      -- 
    ca_1735_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 294_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_839_inst_ack_1, ack => zeropad3D_CP_182_elements(294)); -- 
    -- CP-element group 295:  transition  input  bypass 
    -- CP-element group 295: predecessors 
    -- CP-element group 295: 	292 
    -- CP-element group 295: successors 
    -- CP-element group 295:  members (3) 
      -- CP-element group 295: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_sample_completed_
      -- CP-element group 295: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Sample/$exit
      -- CP-element group 295: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Sample/ra
      -- 
    ra_1744_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 295_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_849_inst_ack_0, ack => zeropad3D_CP_182_elements(295)); -- 
    -- CP-element group 296:  transition  input  bypass 
    -- CP-element group 296: predecessors 
    -- CP-element group 296: 	292 
    -- CP-element group 296: successors 
    -- CP-element group 296: 	326 
    -- CP-element group 296:  members (3) 
      -- CP-element group 296: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_update_completed_
      -- CP-element group 296: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Update/$exit
      -- CP-element group 296: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_849_Update/ca
      -- 
    ca_1749_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 296_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_849_inst_ack_1, ack => zeropad3D_CP_182_elements(296)); -- 
    -- CP-element group 297:  transition  input  bypass 
    -- CP-element group 297: predecessors 
    -- CP-element group 297: 	292 
    -- CP-element group 297: successors 
    -- CP-element group 297:  members (3) 
      -- CP-element group 297: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_sample_completed_
      -- CP-element group 297: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Sample/$exit
      -- CP-element group 297: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Sample/ra
      -- 
    ra_1758_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 297_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_859_inst_ack_0, ack => zeropad3D_CP_182_elements(297)); -- 
    -- CP-element group 298:  transition  input  bypass 
    -- CP-element group 298: predecessors 
    -- CP-element group 298: 	292 
    -- CP-element group 298: successors 
    -- CP-element group 298: 	323 
    -- CP-element group 298:  members (3) 
      -- CP-element group 298: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_update_completed_
      -- CP-element group 298: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Update/$exit
      -- CP-element group 298: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_859_Update/ca
      -- 
    ca_1763_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 298_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_859_inst_ack_1, ack => zeropad3D_CP_182_elements(298)); -- 
    -- CP-element group 299:  transition  input  bypass 
    -- CP-element group 299: predecessors 
    -- CP-element group 299: 	292 
    -- CP-element group 299: successors 
    -- CP-element group 299:  members (3) 
      -- CP-element group 299: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_sample_completed_
      -- CP-element group 299: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Sample/$exit
      -- CP-element group 299: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Sample/ra
      -- 
    ra_1772_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 299_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_869_inst_ack_0, ack => zeropad3D_CP_182_elements(299)); -- 
    -- CP-element group 300:  transition  input  bypass 
    -- CP-element group 300: predecessors 
    -- CP-element group 300: 	292 
    -- CP-element group 300: successors 
    -- CP-element group 300: 	320 
    -- CP-element group 300:  members (3) 
      -- CP-element group 300: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_update_completed_
      -- CP-element group 300: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Update/$exit
      -- CP-element group 300: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_869_Update/ca
      -- 
    ca_1777_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 300_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_869_inst_ack_1, ack => zeropad3D_CP_182_elements(300)); -- 
    -- CP-element group 301:  transition  input  bypass 
    -- CP-element group 301: predecessors 
    -- CP-element group 301: 	292 
    -- CP-element group 301: successors 
    -- CP-element group 301:  members (3) 
      -- CP-element group 301: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Sample/ra
      -- CP-element group 301: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Sample/$exit
      -- CP-element group 301: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_sample_completed_
      -- 
    ra_1786_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 301_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_879_inst_ack_0, ack => zeropad3D_CP_182_elements(301)); -- 
    -- CP-element group 302:  transition  input  bypass 
    -- CP-element group 302: predecessors 
    -- CP-element group 302: 	292 
    -- CP-element group 302: successors 
    -- CP-element group 302: 	317 
    -- CP-element group 302:  members (3) 
      -- CP-element group 302: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Update/ca
      -- CP-element group 302: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_Update/$exit
      -- CP-element group 302: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_879_update_completed_
      -- 
    ca_1791_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 302_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_879_inst_ack_1, ack => zeropad3D_CP_182_elements(302)); -- 
    -- CP-element group 303:  transition  input  bypass 
    -- CP-element group 303: predecessors 
    -- CP-element group 303: 	292 
    -- CP-element group 303: successors 
    -- CP-element group 303:  members (3) 
      -- CP-element group 303: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Sample/ra
      -- CP-element group 303: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_sample_completed_
      -- CP-element group 303: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Sample/$exit
      -- 
    ra_1800_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 303_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_889_inst_ack_0, ack => zeropad3D_CP_182_elements(303)); -- 
    -- CP-element group 304:  transition  input  bypass 
    -- CP-element group 304: predecessors 
    -- CP-element group 304: 	292 
    -- CP-element group 304: successors 
    -- CP-element group 304: 	314 
    -- CP-element group 304:  members (3) 
      -- CP-element group 304: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Update/$exit
      -- CP-element group 304: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_update_completed_
      -- CP-element group 304: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_889_Update/ca
      -- 
    ca_1805_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 304_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_889_inst_ack_1, ack => zeropad3D_CP_182_elements(304)); -- 
    -- CP-element group 305:  transition  input  bypass 
    -- CP-element group 305: predecessors 
    -- CP-element group 305: 	292 
    -- CP-element group 305: successors 
    -- CP-element group 305:  members (3) 
      -- CP-element group 305: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_sample_completed_
      -- CP-element group 305: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Sample/$exit
      -- CP-element group 305: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Sample/ra
      -- 
    ra_1814_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 305_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_899_inst_ack_0, ack => zeropad3D_CP_182_elements(305)); -- 
    -- CP-element group 306:  transition  input  bypass 
    -- CP-element group 306: predecessors 
    -- CP-element group 306: 	292 
    -- CP-element group 306: successors 
    -- CP-element group 306: 	311 
    -- CP-element group 306:  members (3) 
      -- CP-element group 306: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_update_completed_
      -- CP-element group 306: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Update/ca
      -- CP-element group 306: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_899_Update/$exit
      -- 
    ca_1819_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 306_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_899_inst_ack_1, ack => zeropad3D_CP_182_elements(306)); -- 
    -- CP-element group 307:  transition  input  bypass 
    -- CP-element group 307: predecessors 
    -- CP-element group 307: 	292 
    -- CP-element group 307: successors 
    -- CP-element group 307:  members (3) 
      -- CP-element group 307: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_sample_completed_
      -- CP-element group 307: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Sample/$exit
      -- CP-element group 307: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Sample/ra
      -- 
    ra_1828_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 307_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_909_inst_ack_0, ack => zeropad3D_CP_182_elements(307)); -- 
    -- CP-element group 308:  transition  input  output  bypass 
    -- CP-element group 308: predecessors 
    -- CP-element group 308: 	292 
    -- CP-element group 308: successors 
    -- CP-element group 308: 	309 
    -- CP-element group 308:  members (6) 
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_update_completed_
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Update/$exit
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Sample/req
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Sample/$entry
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_sample_start_
      -- CP-element group 308: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/type_cast_909_Update/ca
      -- 
    ca_1833_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 308_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_909_inst_ack_1, ack => zeropad3D_CP_182_elements(308)); -- 
    req_1841_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1841_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(308), ack => WPIPE_zeropad_output_pipe_911_inst_req_0); -- 
    -- CP-element group 309:  transition  input  output  bypass 
    -- CP-element group 309: predecessors 
    -- CP-element group 309: 	308 
    -- CP-element group 309: successors 
    -- CP-element group 309: 	310 
    -- CP-element group 309:  members (6) 
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Update/req
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Update/$entry
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Sample/ack
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Sample/$exit
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_update_start_
      -- CP-element group 309: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_sample_completed_
      -- 
    ack_1842_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 309_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_911_inst_ack_0, ack => zeropad3D_CP_182_elements(309)); -- 
    req_1846_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1846_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(309), ack => WPIPE_zeropad_output_pipe_911_inst_req_1); -- 
    -- CP-element group 310:  transition  input  bypass 
    -- CP-element group 310: predecessors 
    -- CP-element group 310: 	309 
    -- CP-element group 310: successors 
    -- CP-element group 310: 	311 
    -- CP-element group 310:  members (3) 
      -- CP-element group 310: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Update/ack
      -- CP-element group 310: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_Update/$exit
      -- CP-element group 310: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_911_update_completed_
      -- 
    ack_1847_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 310_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_911_inst_ack_1, ack => zeropad3D_CP_182_elements(310)); -- 
    -- CP-element group 311:  join  transition  output  bypass 
    -- CP-element group 311: predecessors 
    -- CP-element group 311: 	306 
    -- CP-element group 311: 	310 
    -- CP-element group 311: successors 
    -- CP-element group 311: 	312 
    -- CP-element group 311:  members (3) 
      -- CP-element group 311: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Sample/req
      -- CP-element group 311: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Sample/$entry
      -- CP-element group 311: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_sample_start_
      -- 
    req_1855_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1855_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(311), ack => WPIPE_zeropad_output_pipe_914_inst_req_0); -- 
    zeropad3D_cp_element_group_311: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_311"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(306) & zeropad3D_CP_182_elements(310);
      gj_zeropad3D_cp_element_group_311 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(311), clk => clk, reset => reset); --
    end block;
    -- CP-element group 312:  transition  input  output  bypass 
    -- CP-element group 312: predecessors 
    -- CP-element group 312: 	311 
    -- CP-element group 312: successors 
    -- CP-element group 312: 	313 
    -- CP-element group 312:  members (6) 
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Update/$entry
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Sample/$exit
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Sample/ack
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Update/req
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_update_start_
      -- CP-element group 312: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_sample_completed_
      -- 
    ack_1856_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 312_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_914_inst_ack_0, ack => zeropad3D_CP_182_elements(312)); -- 
    req_1860_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1860_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(312), ack => WPIPE_zeropad_output_pipe_914_inst_req_1); -- 
    -- CP-element group 313:  transition  input  bypass 
    -- CP-element group 313: predecessors 
    -- CP-element group 313: 	312 
    -- CP-element group 313: successors 
    -- CP-element group 313: 	314 
    -- CP-element group 313:  members (3) 
      -- CP-element group 313: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Update/$exit
      -- CP-element group 313: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_Update/ack
      -- CP-element group 313: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_914_update_completed_
      -- 
    ack_1861_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 313_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_914_inst_ack_1, ack => zeropad3D_CP_182_elements(313)); -- 
    -- CP-element group 314:  join  transition  output  bypass 
    -- CP-element group 314: predecessors 
    -- CP-element group 314: 	304 
    -- CP-element group 314: 	313 
    -- CP-element group 314: successors 
    -- CP-element group 314: 	315 
    -- CP-element group 314:  members (3) 
      -- CP-element group 314: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_sample_start_
      -- CP-element group 314: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Sample/$entry
      -- CP-element group 314: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Sample/req
      -- 
    req_1869_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1869_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(314), ack => WPIPE_zeropad_output_pipe_917_inst_req_0); -- 
    zeropad3D_cp_element_group_314: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_314"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(304) & zeropad3D_CP_182_elements(313);
      gj_zeropad3D_cp_element_group_314 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(314), clk => clk, reset => reset); --
    end block;
    -- CP-element group 315:  transition  input  output  bypass 
    -- CP-element group 315: predecessors 
    -- CP-element group 315: 	314 
    -- CP-element group 315: successors 
    -- CP-element group 315: 	316 
    -- CP-element group 315:  members (6) 
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_sample_completed_
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_update_start_
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Sample/$exit
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Sample/ack
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Update/req
      -- CP-element group 315: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Update/$entry
      -- 
    ack_1870_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 315_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_917_inst_ack_0, ack => zeropad3D_CP_182_elements(315)); -- 
    req_1874_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1874_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(315), ack => WPIPE_zeropad_output_pipe_917_inst_req_1); -- 
    -- CP-element group 316:  transition  input  bypass 
    -- CP-element group 316: predecessors 
    -- CP-element group 316: 	315 
    -- CP-element group 316: successors 
    -- CP-element group 316: 	317 
    -- CP-element group 316:  members (3) 
      -- CP-element group 316: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_update_completed_
      -- CP-element group 316: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Update/ack
      -- CP-element group 316: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_917_Update/$exit
      -- 
    ack_1875_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 316_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_917_inst_ack_1, ack => zeropad3D_CP_182_elements(316)); -- 
    -- CP-element group 317:  join  transition  output  bypass 
    -- CP-element group 317: predecessors 
    -- CP-element group 317: 	302 
    -- CP-element group 317: 	316 
    -- CP-element group 317: successors 
    -- CP-element group 317: 	318 
    -- CP-element group 317:  members (3) 
      -- CP-element group 317: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Sample/$entry
      -- CP-element group 317: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_sample_start_
      -- CP-element group 317: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Sample/req
      -- 
    req_1883_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1883_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(317), ack => WPIPE_zeropad_output_pipe_920_inst_req_0); -- 
    zeropad3D_cp_element_group_317: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_317"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(302) & zeropad3D_CP_182_elements(316);
      gj_zeropad3D_cp_element_group_317 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(317), clk => clk, reset => reset); --
    end block;
    -- CP-element group 318:  transition  input  output  bypass 
    -- CP-element group 318: predecessors 
    -- CP-element group 318: 	317 
    -- CP-element group 318: successors 
    -- CP-element group 318: 	319 
    -- CP-element group 318:  members (6) 
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_sample_completed_
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_update_start_
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Sample/ack
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Update/$entry
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Sample/$exit
      -- CP-element group 318: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Update/req
      -- 
    ack_1884_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 318_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_920_inst_ack_0, ack => zeropad3D_CP_182_elements(318)); -- 
    req_1888_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1888_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(318), ack => WPIPE_zeropad_output_pipe_920_inst_req_1); -- 
    -- CP-element group 319:  transition  input  bypass 
    -- CP-element group 319: predecessors 
    -- CP-element group 319: 	318 
    -- CP-element group 319: successors 
    -- CP-element group 319: 	320 
    -- CP-element group 319:  members (3) 
      -- CP-element group 319: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_update_completed_
      -- CP-element group 319: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Update/$exit
      -- CP-element group 319: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_920_Update/ack
      -- 
    ack_1889_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 319_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_920_inst_ack_1, ack => zeropad3D_CP_182_elements(319)); -- 
    -- CP-element group 320:  join  transition  output  bypass 
    -- CP-element group 320: predecessors 
    -- CP-element group 320: 	300 
    -- CP-element group 320: 	319 
    -- CP-element group 320: successors 
    -- CP-element group 320: 	321 
    -- CP-element group 320:  members (3) 
      -- CP-element group 320: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_sample_start_
      -- CP-element group 320: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Sample/req
      -- CP-element group 320: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Sample/$entry
      -- 
    req_1897_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1897_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(320), ack => WPIPE_zeropad_output_pipe_923_inst_req_0); -- 
    zeropad3D_cp_element_group_320: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_320"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(300) & zeropad3D_CP_182_elements(319);
      gj_zeropad3D_cp_element_group_320 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(320), clk => clk, reset => reset); --
    end block;
    -- CP-element group 321:  transition  input  output  bypass 
    -- CP-element group 321: predecessors 
    -- CP-element group 321: 	320 
    -- CP-element group 321: successors 
    -- CP-element group 321: 	322 
    -- CP-element group 321:  members (6) 
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Update/req
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Update/$entry
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Sample/ack
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Sample/$exit
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_update_start_
      -- CP-element group 321: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_sample_completed_
      -- 
    ack_1898_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 321_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_923_inst_ack_0, ack => zeropad3D_CP_182_elements(321)); -- 
    req_1902_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1902_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(321), ack => WPIPE_zeropad_output_pipe_923_inst_req_1); -- 
    -- CP-element group 322:  transition  input  bypass 
    -- CP-element group 322: predecessors 
    -- CP-element group 322: 	321 
    -- CP-element group 322: successors 
    -- CP-element group 322: 	323 
    -- CP-element group 322:  members (3) 
      -- CP-element group 322: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Update/ack
      -- CP-element group 322: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_Update/$exit
      -- CP-element group 322: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_923_update_completed_
      -- 
    ack_1903_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 322_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_923_inst_ack_1, ack => zeropad3D_CP_182_elements(322)); -- 
    -- CP-element group 323:  join  transition  output  bypass 
    -- CP-element group 323: predecessors 
    -- CP-element group 323: 	298 
    -- CP-element group 323: 	322 
    -- CP-element group 323: successors 
    -- CP-element group 323: 	324 
    -- CP-element group 323:  members (3) 
      -- CP-element group 323: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Sample/req
      -- CP-element group 323: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Sample/$entry
      -- CP-element group 323: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_sample_start_
      -- 
    req_1911_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1911_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(323), ack => WPIPE_zeropad_output_pipe_926_inst_req_0); -- 
    zeropad3D_cp_element_group_323: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_323"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(298) & zeropad3D_CP_182_elements(322);
      gj_zeropad3D_cp_element_group_323 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(323), clk => clk, reset => reset); --
    end block;
    -- CP-element group 324:  transition  input  output  bypass 
    -- CP-element group 324: predecessors 
    -- CP-element group 324: 	323 
    -- CP-element group 324: successors 
    -- CP-element group 324: 	325 
    -- CP-element group 324:  members (6) 
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Update/req
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Update/$entry
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Sample/ack
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Sample/$exit
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_update_start_
      -- CP-element group 324: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_sample_completed_
      -- 
    ack_1912_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 324_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_926_inst_ack_0, ack => zeropad3D_CP_182_elements(324)); -- 
    req_1916_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1916_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(324), ack => WPIPE_zeropad_output_pipe_926_inst_req_1); -- 
    -- CP-element group 325:  transition  input  bypass 
    -- CP-element group 325: predecessors 
    -- CP-element group 325: 	324 
    -- CP-element group 325: successors 
    -- CP-element group 325: 	326 
    -- CP-element group 325:  members (3) 
      -- CP-element group 325: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Update/ack
      -- CP-element group 325: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_Update/$exit
      -- CP-element group 325: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_926_update_completed_
      -- 
    ack_1917_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 325_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_926_inst_ack_1, ack => zeropad3D_CP_182_elements(325)); -- 
    -- CP-element group 326:  join  transition  output  bypass 
    -- CP-element group 326: predecessors 
    -- CP-element group 326: 	296 
    -- CP-element group 326: 	325 
    -- CP-element group 326: successors 
    -- CP-element group 326: 	327 
    -- CP-element group 326:  members (3) 
      -- CP-element group 326: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Sample/req
      -- CP-element group 326: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Sample/$entry
      -- CP-element group 326: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_sample_start_
      -- 
    req_1925_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1925_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(326), ack => WPIPE_zeropad_output_pipe_929_inst_req_0); -- 
    zeropad3D_cp_element_group_326: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_326"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(296) & zeropad3D_CP_182_elements(325);
      gj_zeropad3D_cp_element_group_326 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(326), clk => clk, reset => reset); --
    end block;
    -- CP-element group 327:  transition  input  output  bypass 
    -- CP-element group 327: predecessors 
    -- CP-element group 327: 	326 
    -- CP-element group 327: successors 
    -- CP-element group 327: 	328 
    -- CP-element group 327:  members (6) 
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Update/req
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Update/$entry
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Sample/ack
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Sample/$exit
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_update_start_
      -- CP-element group 327: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_sample_completed_
      -- 
    ack_1926_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 327_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_929_inst_ack_0, ack => zeropad3D_CP_182_elements(327)); -- 
    req_1930_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1930_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(327), ack => WPIPE_zeropad_output_pipe_929_inst_req_1); -- 
    -- CP-element group 328:  transition  input  bypass 
    -- CP-element group 328: predecessors 
    -- CP-element group 328: 	327 
    -- CP-element group 328: successors 
    -- CP-element group 328: 	329 
    -- CP-element group 328:  members (3) 
      -- CP-element group 328: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Update/ack
      -- CP-element group 328: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_Update/$exit
      -- CP-element group 328: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_929_update_completed_
      -- 
    ack_1931_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 328_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_929_inst_ack_1, ack => zeropad3D_CP_182_elements(328)); -- 
    -- CP-element group 329:  join  transition  output  bypass 
    -- CP-element group 329: predecessors 
    -- CP-element group 329: 	294 
    -- CP-element group 329: 	328 
    -- CP-element group 329: successors 
    -- CP-element group 329: 	330 
    -- CP-element group 329:  members (3) 
      -- CP-element group 329: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Sample/req
      -- CP-element group 329: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Sample/$entry
      -- CP-element group 329: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_sample_start_
      -- 
    req_1939_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1939_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(329), ack => WPIPE_zeropad_output_pipe_932_inst_req_0); -- 
    zeropad3D_cp_element_group_329: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_329"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(294) & zeropad3D_CP_182_elements(328);
      gj_zeropad3D_cp_element_group_329 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(329), clk => clk, reset => reset); --
    end block;
    -- CP-element group 330:  transition  input  output  bypass 
    -- CP-element group 330: predecessors 
    -- CP-element group 330: 	329 
    -- CP-element group 330: successors 
    -- CP-element group 330: 	331 
    -- CP-element group 330:  members (6) 
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Update/req
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Update/$entry
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Sample/ack
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Sample/$exit
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_update_start_
      -- CP-element group 330: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_sample_completed_
      -- 
    ack_1940_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 330_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_932_inst_ack_0, ack => zeropad3D_CP_182_elements(330)); -- 
    req_1944_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_1944_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(330), ack => WPIPE_zeropad_output_pipe_932_inst_req_1); -- 
    -- CP-element group 331:  fork  transition  place  input  output  bypass 
    -- CP-element group 331: predecessors 
    -- CP-element group 331: 	330 
    -- CP-element group 331: successors 
    -- CP-element group 331: 	332 
    -- CP-element group 331: 	333 
    -- CP-element group 331: 	334 
    -- CP-element group 331: 	335 
    -- CP-element group 331: 	336 
    -- CP-element group 331: 	337 
    -- CP-element group 331:  members (25) 
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_update_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Update/cr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934__exit__
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975__entry__
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Sample/rr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_sample_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_update_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Update/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Sample/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Update/cr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Sample/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Update/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Sample/rr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_sample_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Update/cr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Update/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Sample/rr
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Sample/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_update_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_sample_start_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/$entry
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Update/ack
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_Update/$exit
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/WPIPE_zeropad_output_pipe_932_update_completed_
      -- CP-element group 331: 	 branch_block_stmt_49/assign_stmt_840_to_assign_stmt_934/$exit
      -- 
    ack_1945_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 331_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_932_inst_ack_1, ack => zeropad3D_CP_182_elements(331)); -- 
    cr_1989_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1989_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_946_inst_req_1); -- 
    rr_1970_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1970_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_942_inst_req_0); -- 
    cr_1975_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1975_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_942_inst_req_1); -- 
    rr_1984_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1984_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_946_inst_req_0); -- 
    cr_1961_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1961_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_938_inst_req_1); -- 
    rr_1956_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_1956_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(331), ack => type_cast_938_inst_req_0); -- 
    -- CP-element group 332:  transition  input  bypass 
    -- CP-element group 332: predecessors 
    -- CP-element group 332: 	331 
    -- CP-element group 332: successors 
    -- CP-element group 332:  members (3) 
      -- CP-element group 332: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Sample/ra
      -- CP-element group 332: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Sample/$exit
      -- CP-element group 332: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_sample_completed_
      -- 
    ra_1957_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 332_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_938_inst_ack_0, ack => zeropad3D_CP_182_elements(332)); -- 
    -- CP-element group 333:  transition  input  bypass 
    -- CP-element group 333: predecessors 
    -- CP-element group 333: 	331 
    -- CP-element group 333: successors 
    -- CP-element group 333: 	338 
    -- CP-element group 333:  members (3) 
      -- CP-element group 333: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Update/ca
      -- CP-element group 333: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_Update/$exit
      -- CP-element group 333: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_938_update_completed_
      -- 
    ca_1962_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 333_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_938_inst_ack_1, ack => zeropad3D_CP_182_elements(333)); -- 
    -- CP-element group 334:  transition  input  bypass 
    -- CP-element group 334: predecessors 
    -- CP-element group 334: 	331 
    -- CP-element group 334: successors 
    -- CP-element group 334:  members (3) 
      -- CP-element group 334: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Sample/$exit
      -- CP-element group 334: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_sample_completed_
      -- CP-element group 334: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Sample/ra
      -- 
    ra_1971_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 334_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_942_inst_ack_0, ack => zeropad3D_CP_182_elements(334)); -- 
    -- CP-element group 335:  transition  input  bypass 
    -- CP-element group 335: predecessors 
    -- CP-element group 335: 	331 
    -- CP-element group 335: successors 
    -- CP-element group 335: 	338 
    -- CP-element group 335:  members (3) 
      -- CP-element group 335: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_update_completed_
      -- CP-element group 335: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Update/$exit
      -- CP-element group 335: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_942_Update/ca
      -- 
    ca_1976_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 335_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_942_inst_ack_1, ack => zeropad3D_CP_182_elements(335)); -- 
    -- CP-element group 336:  transition  input  bypass 
    -- CP-element group 336: predecessors 
    -- CP-element group 336: 	331 
    -- CP-element group 336: successors 
    -- CP-element group 336:  members (3) 
      -- CP-element group 336: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_sample_completed_
      -- CP-element group 336: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Sample/ra
      -- CP-element group 336: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Sample/$exit
      -- 
    ra_1985_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 336_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_946_inst_ack_0, ack => zeropad3D_CP_182_elements(336)); -- 
    -- CP-element group 337:  transition  input  bypass 
    -- CP-element group 337: predecessors 
    -- CP-element group 337: 	331 
    -- CP-element group 337: successors 
    -- CP-element group 337: 	338 
    -- CP-element group 337:  members (3) 
      -- CP-element group 337: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Update/ca
      -- CP-element group 337: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_update_completed_
      -- CP-element group 337: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/type_cast_946_Update/$exit
      -- 
    ca_1990_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 337_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_946_inst_ack_1, ack => zeropad3D_CP_182_elements(337)); -- 
    -- CP-element group 338:  branch  join  transition  place  output  bypass 
    -- CP-element group 338: predecessors 
    -- CP-element group 338: 	333 
    -- CP-element group 338: 	335 
    -- CP-element group 338: 	337 
    -- CP-element group 338: successors 
    -- CP-element group 338: 	339 
    -- CP-element group 338: 	340 
    -- CP-element group 338:  members (10) 
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_eval_test/$entry
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_eval_test/$exit
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_eval_test/branch_req
      -- CP-element group 338: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975__exit__
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976__entry__
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_if_link/$entry
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_dead_link/$entry
      -- CP-element group 338: 	 branch_block_stmt_49/if_stmt_976_else_link/$entry
      -- CP-element group 338: 	 branch_block_stmt_49/assign_stmt_939_to_assign_stmt_975/$exit
      -- CP-element group 338: 	 branch_block_stmt_49/R_cmp233310_977_place
      -- 
    branch_req_1998_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_1998_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(338), ack => if_stmt_976_branch_req_0); -- 
    zeropad3D_cp_element_group_338: block -- 
      constant place_capacities: IntegerArray(0 to 2) := (0 => 1,1 => 1,2 => 1);
      constant place_markings: IntegerArray(0 to 2)  := (0 => 0,1 => 0,2 => 0);
      constant place_delays: IntegerArray(0 to 2) := (0 => 0,1 => 0,2 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_338"; 
      signal preds: BooleanArray(1 to 3); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(333) & zeropad3D_CP_182_elements(335) & zeropad3D_CP_182_elements(337);
      gj_zeropad3D_cp_element_group_338 : generic_join generic map(name => joinName, number_of_predecessors => 3, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(338), clk => clk, reset => reset); --
    end block;
    -- CP-element group 339:  merge  fork  transition  place  input  output  bypass 
    -- CP-element group 339: predecessors 
    -- CP-element group 339: 	338 
    -- CP-element group 339: successors 
    -- CP-element group 339: 	341 
    -- CP-element group 339: 	342 
    -- CP-element group 339:  members (18) 
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Update/cr
      -- CP-element group 339: 	 branch_block_stmt_49/merge_stmt_982__exit__
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986__entry__
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Sample/rr
      -- CP-element group 339: 	 branch_block_stmt_49/if_stmt_976_if_link/$exit
      -- CP-element group 339: 	 branch_block_stmt_49/if_stmt_976_if_link/if_choice_transition
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/$entry
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_sample_start_
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_update_start_
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Sample/$entry
      -- CP-element group 339: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Update/$entry
      -- CP-element group 339: 	 branch_block_stmt_49/forx_xend_bbx_xnph
      -- CP-element group 339: 	 branch_block_stmt_49/forx_xend_bbx_xnph_PhiReq/$entry
      -- CP-element group 339: 	 branch_block_stmt_49/forx_xend_bbx_xnph_PhiReq/$exit
      -- CP-element group 339: 	 branch_block_stmt_49/merge_stmt_982_PhiReqMerge
      -- CP-element group 339: 	 branch_block_stmt_49/merge_stmt_982_PhiAck/$entry
      -- CP-element group 339: 	 branch_block_stmt_49/merge_stmt_982_PhiAck/$exit
      -- CP-element group 339: 	 branch_block_stmt_49/merge_stmt_982_PhiAck/dummy
      -- 
    if_choice_transition_2003_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 339_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_976_branch_ack_1, ack => zeropad3D_CP_182_elements(339)); -- 
    cr_2025_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2025_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(339), ack => type_cast_985_inst_req_1); -- 
    rr_2020_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2020_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(339), ack => type_cast_985_inst_req_0); -- 
    -- CP-element group 340:  transition  place  input  bypass 
    -- CP-element group 340: predecessors 
    -- CP-element group 340: 	338 
    -- CP-element group 340: successors 
    -- CP-element group 340: 	404 
    -- CP-element group 340:  members (5) 
      -- CP-element group 340: 	 branch_block_stmt_49/if_stmt_976_else_link/$exit
      -- CP-element group 340: 	 branch_block_stmt_49/if_stmt_976_else_link/else_choice_transition
      -- CP-element group 340: 	 branch_block_stmt_49/forx_xend_forx_xend308
      -- CP-element group 340: 	 branch_block_stmt_49/forx_xend_forx_xend308_PhiReq/$entry
      -- CP-element group 340: 	 branch_block_stmt_49/forx_xend_forx_xend308_PhiReq/$exit
      -- 
    else_choice_transition_2007_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 340_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_976_branch_ack_0, ack => zeropad3D_CP_182_elements(340)); -- 
    -- CP-element group 341:  transition  input  bypass 
    -- CP-element group 341: predecessors 
    -- CP-element group 341: 	339 
    -- CP-element group 341: successors 
    -- CP-element group 341:  members (3) 
      -- CP-element group 341: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Sample/ra
      -- CP-element group 341: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_sample_completed_
      -- CP-element group 341: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Sample/$exit
      -- 
    ra_2021_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 341_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_985_inst_ack_0, ack => zeropad3D_CP_182_elements(341)); -- 
    -- CP-element group 342:  transition  place  input  bypass 
    -- CP-element group 342: predecessors 
    -- CP-element group 342: 	339 
    -- CP-element group 342: successors 
    -- CP-element group 342: 	398 
    -- CP-element group 342:  members (9) 
      -- CP-element group 342: 	 branch_block_stmt_49/assign_stmt_986__exit__
      -- CP-element group 342: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235
      -- CP-element group 342: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Update/ca
      -- CP-element group 342: 	 branch_block_stmt_49/assign_stmt_986/$exit
      -- CP-element group 342: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_update_completed_
      -- CP-element group 342: 	 branch_block_stmt_49/assign_stmt_986/type_cast_985_Update/$exit
      -- CP-element group 342: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/$entry
      -- CP-element group 342: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/$entry
      -- CP-element group 342: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/$entry
      -- 
    ca_2026_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 342_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_985_inst_ack_1, ack => zeropad3D_CP_182_elements(342)); -- 
    -- CP-element group 343:  transition  input  bypass 
    -- CP-element group 343: predecessors 
    -- CP-element group 343: 	403 
    -- CP-element group 343: successors 
    -- CP-element group 343: 	388 
    -- CP-element group 343:  members (3) 
      -- CP-element group 343: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_sample_complete
      -- CP-element group 343: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Sample/$exit
      -- CP-element group 343: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Sample/ack
      -- 
    ack_2055_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 343_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1001_index_offset_ack_0, ack => zeropad3D_CP_182_elements(343)); -- 
    -- CP-element group 344:  transition  input  output  bypass 
    -- CP-element group 344: predecessors 
    -- CP-element group 344: 	403 
    -- CP-element group 344: successors 
    -- CP-element group 344: 	345 
    -- CP-element group 344:  members (11) 
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_sample_start_
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_offset_calculated
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_root_address_calculated
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Update/$exit
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Update/ack
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_request/req
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_request/$entry
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_base_plus_offset/sum_rename_ack
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_base_plus_offset/sum_rename_req
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_base_plus_offset/$exit
      -- CP-element group 344: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_base_plus_offset/$entry
      -- 
    ack_2060_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 344_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => array_obj_ref_1001_index_offset_ack_1, ack => zeropad3D_CP_182_elements(344)); -- 
    req_2069_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2069_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(344), ack => addr_of_1002_final_reg_req_0); -- 
    -- CP-element group 345:  transition  input  bypass 
    -- CP-element group 345: predecessors 
    -- CP-element group 345: 	344 
    -- CP-element group 345: successors 
    -- CP-element group 345:  members (3) 
      -- CP-element group 345: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_sample_completed_
      -- CP-element group 345: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_request/ack
      -- CP-element group 345: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_request/$exit
      -- 
    ack_2070_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 345_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1002_final_reg_ack_0, ack => zeropad3D_CP_182_elements(345)); -- 
    -- CP-element group 346:  join  fork  transition  input  output  bypass 
    -- CP-element group 346: predecessors 
    -- CP-element group 346: 	403 
    -- CP-element group 346: successors 
    -- CP-element group 346: 	347 
    -- CP-element group 346:  members (24) 
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_addr_resize/$exit
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_complete/$exit
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_complete/ack
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_addr_resize/$entry
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_word_address_calculated
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_addr_resize/base_resize_ack
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_addr_resize/base_resize_req
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_word_addrgen/root_register_ack
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_address_calculated
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_sample_start_
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_root_address_calculated
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_update_completed_
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_plus_offset/$entry
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_plus_offset/$exit
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/$entry
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_plus_offset/sum_rename_req
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_word_addrgen/root_register_req
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_address_resized
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_word_addrgen/$exit
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_word_addrgen/$entry
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/word_0/rr
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/word_0/$entry
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_base_plus_offset/sum_rename_ack
      -- CP-element group 346: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/$entry
      -- 
    ack_2075_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 346_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => addr_of_1002_final_reg_ack_1, ack => zeropad3D_CP_182_elements(346)); -- 
    rr_2108_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2108_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(346), ack => ptr_deref_1006_load_0_req_0); -- 
    -- CP-element group 347:  transition  input  bypass 
    -- CP-element group 347: predecessors 
    -- CP-element group 347: 	346 
    -- CP-element group 347: successors 
    -- CP-element group 347:  members (5) 
      -- CP-element group 347: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_sample_completed_
      -- CP-element group 347: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/word_0/ra
      -- CP-element group 347: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/word_0/$exit
      -- CP-element group 347: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/word_access_start/$exit
      -- CP-element group 347: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Sample/$exit
      -- 
    ra_2109_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 347_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1006_load_0_ack_0, ack => zeropad3D_CP_182_elements(347)); -- 
    -- CP-element group 348:  fork  transition  input  output  bypass 
    -- CP-element group 348: predecessors 
    -- CP-element group 348: 	403 
    -- CP-element group 348: successors 
    -- CP-element group 348: 	349 
    -- CP-element group 348: 	351 
    -- CP-element group 348: 	353 
    -- CP-element group 348: 	355 
    -- CP-element group 348: 	357 
    -- CP-element group 348: 	359 
    -- CP-element group 348: 	361 
    -- CP-element group 348: 	363 
    -- CP-element group 348:  members (33) 
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/ptr_deref_1006_Merge/$exit
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_update_completed_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/ptr_deref_1006_Merge/merge_ack
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/ptr_deref_1006_Merge/merge_req
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/ptr_deref_1006_Merge/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/word_0/ca
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/word_0/$exit
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/$exit
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/$exit
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Sample/rr
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_sample_start_
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Sample/$entry
      -- CP-element group 348: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Sample/rr
      -- 
    ca_2120_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 348_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => ptr_deref_1006_load_0_ack_1, ack => zeropad3D_CP_182_elements(348)); -- 
    rr_2133_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2133_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1010_inst_req_0); -- 
    rr_2147_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2147_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1020_inst_req_0); -- 
    rr_2161_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2161_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1030_inst_req_0); -- 
    rr_2175_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2175_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1040_inst_req_0); -- 
    rr_2189_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2189_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1050_inst_req_0); -- 
    rr_2203_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2203_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1060_inst_req_0); -- 
    rr_2217_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2217_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1070_inst_req_0); -- 
    rr_2231_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2231_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(348), ack => type_cast_1080_inst_req_0); -- 
    -- CP-element group 349:  transition  input  bypass 
    -- CP-element group 349: predecessors 
    -- CP-element group 349: 	348 
    -- CP-element group 349: successors 
    -- CP-element group 349:  members (3) 
      -- CP-element group 349: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_sample_completed_
      -- CP-element group 349: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Sample/$exit
      -- CP-element group 349: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Sample/ra
      -- 
    ra_2134_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 349_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1010_inst_ack_0, ack => zeropad3D_CP_182_elements(349)); -- 
    -- CP-element group 350:  transition  input  bypass 
    -- CP-element group 350: predecessors 
    -- CP-element group 350: 	403 
    -- CP-element group 350: successors 
    -- CP-element group 350: 	385 
    -- CP-element group 350:  members (3) 
      -- CP-element group 350: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_update_completed_
      -- CP-element group 350: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Update/ca
      -- CP-element group 350: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Update/$exit
      -- 
    ca_2139_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 350_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1010_inst_ack_1, ack => zeropad3D_CP_182_elements(350)); -- 
    -- CP-element group 351:  transition  input  bypass 
    -- CP-element group 351: predecessors 
    -- CP-element group 351: 	348 
    -- CP-element group 351: successors 
    -- CP-element group 351:  members (3) 
      -- CP-element group 351: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_sample_completed_
      -- CP-element group 351: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Sample/$exit
      -- CP-element group 351: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Sample/ra
      -- 
    ra_2148_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 351_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1020_inst_ack_0, ack => zeropad3D_CP_182_elements(351)); -- 
    -- CP-element group 352:  transition  input  bypass 
    -- CP-element group 352: predecessors 
    -- CP-element group 352: 	403 
    -- CP-element group 352: successors 
    -- CP-element group 352: 	382 
    -- CP-element group 352:  members (3) 
      -- CP-element group 352: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Update/$exit
      -- CP-element group 352: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Update/ca
      -- CP-element group 352: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_update_completed_
      -- 
    ca_2153_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 352_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1020_inst_ack_1, ack => zeropad3D_CP_182_elements(352)); -- 
    -- CP-element group 353:  transition  input  bypass 
    -- CP-element group 353: predecessors 
    -- CP-element group 353: 	348 
    -- CP-element group 353: successors 
    -- CP-element group 353:  members (3) 
      -- CP-element group 353: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_sample_completed_
      -- CP-element group 353: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Sample/ra
      -- CP-element group 353: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Sample/$exit
      -- 
    ra_2162_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 353_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1030_inst_ack_0, ack => zeropad3D_CP_182_elements(353)); -- 
    -- CP-element group 354:  transition  input  bypass 
    -- CP-element group 354: predecessors 
    -- CP-element group 354: 	403 
    -- CP-element group 354: successors 
    -- CP-element group 354: 	379 
    -- CP-element group 354:  members (3) 
      -- CP-element group 354: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Update/ca
      -- CP-element group 354: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_update_completed_
      -- CP-element group 354: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Update/$exit
      -- 
    ca_2167_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 354_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1030_inst_ack_1, ack => zeropad3D_CP_182_elements(354)); -- 
    -- CP-element group 355:  transition  input  bypass 
    -- CP-element group 355: predecessors 
    -- CP-element group 355: 	348 
    -- CP-element group 355: successors 
    -- CP-element group 355:  members (3) 
      -- CP-element group 355: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_sample_completed_
      -- CP-element group 355: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Sample/$exit
      -- CP-element group 355: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Sample/ra
      -- 
    ra_2176_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 355_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1040_inst_ack_0, ack => zeropad3D_CP_182_elements(355)); -- 
    -- CP-element group 356:  transition  input  bypass 
    -- CP-element group 356: predecessors 
    -- CP-element group 356: 	403 
    -- CP-element group 356: successors 
    -- CP-element group 356: 	376 
    -- CP-element group 356:  members (3) 
      -- CP-element group 356: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_update_completed_
      -- CP-element group 356: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Update/$exit
      -- CP-element group 356: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Update/ca
      -- 
    ca_2181_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 356_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1040_inst_ack_1, ack => zeropad3D_CP_182_elements(356)); -- 
    -- CP-element group 357:  transition  input  bypass 
    -- CP-element group 357: predecessors 
    -- CP-element group 357: 	348 
    -- CP-element group 357: successors 
    -- CP-element group 357:  members (3) 
      -- CP-element group 357: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_sample_completed_
      -- CP-element group 357: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Sample/$exit
      -- CP-element group 357: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Sample/ra
      -- 
    ra_2190_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 357_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1050_inst_ack_0, ack => zeropad3D_CP_182_elements(357)); -- 
    -- CP-element group 358:  transition  input  bypass 
    -- CP-element group 358: predecessors 
    -- CP-element group 358: 	403 
    -- CP-element group 358: successors 
    -- CP-element group 358: 	373 
    -- CP-element group 358:  members (3) 
      -- CP-element group 358: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_update_completed_
      -- CP-element group 358: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Update/$exit
      -- CP-element group 358: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Update/ca
      -- 
    ca_2195_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 358_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1050_inst_ack_1, ack => zeropad3D_CP_182_elements(358)); -- 
    -- CP-element group 359:  transition  input  bypass 
    -- CP-element group 359: predecessors 
    -- CP-element group 359: 	348 
    -- CP-element group 359: successors 
    -- CP-element group 359:  members (3) 
      -- CP-element group 359: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_sample_completed_
      -- CP-element group 359: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Sample/$exit
      -- CP-element group 359: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Sample/ra
      -- 
    ra_2204_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 359_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1060_inst_ack_0, ack => zeropad3D_CP_182_elements(359)); -- 
    -- CP-element group 360:  transition  input  bypass 
    -- CP-element group 360: predecessors 
    -- CP-element group 360: 	403 
    -- CP-element group 360: successors 
    -- CP-element group 360: 	370 
    -- CP-element group 360:  members (3) 
      -- CP-element group 360: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_update_completed_
      -- CP-element group 360: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Update/$exit
      -- CP-element group 360: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Update/ca
      -- 
    ca_2209_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 360_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1060_inst_ack_1, ack => zeropad3D_CP_182_elements(360)); -- 
    -- CP-element group 361:  transition  input  bypass 
    -- CP-element group 361: predecessors 
    -- CP-element group 361: 	348 
    -- CP-element group 361: successors 
    -- CP-element group 361:  members (3) 
      -- CP-element group 361: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_sample_completed_
      -- CP-element group 361: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Sample/$exit
      -- CP-element group 361: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Sample/ra
      -- 
    ra_2218_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 361_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1070_inst_ack_0, ack => zeropad3D_CP_182_elements(361)); -- 
    -- CP-element group 362:  transition  input  bypass 
    -- CP-element group 362: predecessors 
    -- CP-element group 362: 	403 
    -- CP-element group 362: successors 
    -- CP-element group 362: 	367 
    -- CP-element group 362:  members (3) 
      -- CP-element group 362: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_update_completed_
      -- CP-element group 362: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Update/$exit
      -- CP-element group 362: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Update/ca
      -- 
    ca_2223_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 362_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1070_inst_ack_1, ack => zeropad3D_CP_182_elements(362)); -- 
    -- CP-element group 363:  transition  input  bypass 
    -- CP-element group 363: predecessors 
    -- CP-element group 363: 	348 
    -- CP-element group 363: successors 
    -- CP-element group 363:  members (3) 
      -- CP-element group 363: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_sample_completed_
      -- CP-element group 363: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Sample/$exit
      -- CP-element group 363: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Sample/ra
      -- 
    ra_2232_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 363_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1080_inst_ack_0, ack => zeropad3D_CP_182_elements(363)); -- 
    -- CP-element group 364:  transition  input  output  bypass 
    -- CP-element group 364: predecessors 
    -- CP-element group 364: 	403 
    -- CP-element group 364: successors 
    -- CP-element group 364: 	365 
    -- CP-element group 364:  members (6) 
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_update_completed_
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Update/$exit
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Update/ca
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_sample_start_
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Sample/$entry
      -- CP-element group 364: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Sample/req
      -- 
    ca_2237_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 364_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_1080_inst_ack_1, ack => zeropad3D_CP_182_elements(364)); -- 
    req_2245_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2245_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(364), ack => WPIPE_zeropad_output_pipe_1082_inst_req_0); -- 
    -- CP-element group 365:  transition  input  output  bypass 
    -- CP-element group 365: predecessors 
    -- CP-element group 365: 	364 
    -- CP-element group 365: successors 
    -- CP-element group 365: 	366 
    -- CP-element group 365:  members (6) 
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_sample_completed_
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_update_start_
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Sample/$exit
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Sample/ack
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Update/$entry
      -- CP-element group 365: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Update/req
      -- 
    ack_2246_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 365_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1082_inst_ack_0, ack => zeropad3D_CP_182_elements(365)); -- 
    req_2250_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2250_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(365), ack => WPIPE_zeropad_output_pipe_1082_inst_req_1); -- 
    -- CP-element group 366:  transition  input  bypass 
    -- CP-element group 366: predecessors 
    -- CP-element group 366: 	365 
    -- CP-element group 366: successors 
    -- CP-element group 366: 	367 
    -- CP-element group 366:  members (3) 
      -- CP-element group 366: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_update_completed_
      -- CP-element group 366: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Update/$exit
      -- CP-element group 366: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1082_Update/ack
      -- 
    ack_2251_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 366_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1082_inst_ack_1, ack => zeropad3D_CP_182_elements(366)); -- 
    -- CP-element group 367:  join  transition  output  bypass 
    -- CP-element group 367: predecessors 
    -- CP-element group 367: 	362 
    -- CP-element group 367: 	366 
    -- CP-element group 367: successors 
    -- CP-element group 367: 	368 
    -- CP-element group 367:  members (3) 
      -- CP-element group 367: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_sample_start_
      -- CP-element group 367: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Sample/$entry
      -- CP-element group 367: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Sample/req
      -- 
    req_2259_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2259_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(367), ack => WPIPE_zeropad_output_pipe_1085_inst_req_0); -- 
    zeropad3D_cp_element_group_367: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_367"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(362) & zeropad3D_CP_182_elements(366);
      gj_zeropad3D_cp_element_group_367 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(367), clk => clk, reset => reset); --
    end block;
    -- CP-element group 368:  transition  input  output  bypass 
    -- CP-element group 368: predecessors 
    -- CP-element group 368: 	367 
    -- CP-element group 368: successors 
    -- CP-element group 368: 	369 
    -- CP-element group 368:  members (6) 
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_sample_completed_
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_update_start_
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Sample/$exit
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Sample/ack
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Update/$entry
      -- CP-element group 368: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Update/req
      -- 
    ack_2260_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 368_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1085_inst_ack_0, ack => zeropad3D_CP_182_elements(368)); -- 
    req_2264_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2264_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(368), ack => WPIPE_zeropad_output_pipe_1085_inst_req_1); -- 
    -- CP-element group 369:  transition  input  bypass 
    -- CP-element group 369: predecessors 
    -- CP-element group 369: 	368 
    -- CP-element group 369: successors 
    -- CP-element group 369: 	370 
    -- CP-element group 369:  members (3) 
      -- CP-element group 369: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_update_completed_
      -- CP-element group 369: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Update/$exit
      -- CP-element group 369: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1085_Update/ack
      -- 
    ack_2265_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 369_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1085_inst_ack_1, ack => zeropad3D_CP_182_elements(369)); -- 
    -- CP-element group 370:  join  transition  output  bypass 
    -- CP-element group 370: predecessors 
    -- CP-element group 370: 	360 
    -- CP-element group 370: 	369 
    -- CP-element group 370: successors 
    -- CP-element group 370: 	371 
    -- CP-element group 370:  members (3) 
      -- CP-element group 370: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_sample_start_
      -- CP-element group 370: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Sample/$entry
      -- CP-element group 370: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Sample/req
      -- 
    req_2273_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2273_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(370), ack => WPIPE_zeropad_output_pipe_1088_inst_req_0); -- 
    zeropad3D_cp_element_group_370: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_370"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(360) & zeropad3D_CP_182_elements(369);
      gj_zeropad3D_cp_element_group_370 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(370), clk => clk, reset => reset); --
    end block;
    -- CP-element group 371:  transition  input  output  bypass 
    -- CP-element group 371: predecessors 
    -- CP-element group 371: 	370 
    -- CP-element group 371: successors 
    -- CP-element group 371: 	372 
    -- CP-element group 371:  members (6) 
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_sample_completed_
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_update_start_
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Sample/$exit
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Sample/ack
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Update/$entry
      -- CP-element group 371: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Update/req
      -- 
    ack_2274_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 371_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1088_inst_ack_0, ack => zeropad3D_CP_182_elements(371)); -- 
    req_2278_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2278_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(371), ack => WPIPE_zeropad_output_pipe_1088_inst_req_1); -- 
    -- CP-element group 372:  transition  input  bypass 
    -- CP-element group 372: predecessors 
    -- CP-element group 372: 	371 
    -- CP-element group 372: successors 
    -- CP-element group 372: 	373 
    -- CP-element group 372:  members (3) 
      -- CP-element group 372: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_update_completed_
      -- CP-element group 372: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Update/$exit
      -- CP-element group 372: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1088_Update/ack
      -- 
    ack_2279_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 372_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1088_inst_ack_1, ack => zeropad3D_CP_182_elements(372)); -- 
    -- CP-element group 373:  join  transition  output  bypass 
    -- CP-element group 373: predecessors 
    -- CP-element group 373: 	358 
    -- CP-element group 373: 	372 
    -- CP-element group 373: successors 
    -- CP-element group 373: 	374 
    -- CP-element group 373:  members (3) 
      -- CP-element group 373: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_sample_start_
      -- CP-element group 373: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Sample/$entry
      -- CP-element group 373: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Sample/req
      -- 
    req_2287_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2287_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(373), ack => WPIPE_zeropad_output_pipe_1091_inst_req_0); -- 
    zeropad3D_cp_element_group_373: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_373"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(358) & zeropad3D_CP_182_elements(372);
      gj_zeropad3D_cp_element_group_373 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(373), clk => clk, reset => reset); --
    end block;
    -- CP-element group 374:  transition  input  output  bypass 
    -- CP-element group 374: predecessors 
    -- CP-element group 374: 	373 
    -- CP-element group 374: successors 
    -- CP-element group 374: 	375 
    -- CP-element group 374:  members (6) 
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_sample_completed_
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_update_start_
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Sample/$exit
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Sample/ack
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Update/$entry
      -- CP-element group 374: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Update/req
      -- 
    ack_2288_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 374_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1091_inst_ack_0, ack => zeropad3D_CP_182_elements(374)); -- 
    req_2292_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2292_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(374), ack => WPIPE_zeropad_output_pipe_1091_inst_req_1); -- 
    -- CP-element group 375:  transition  input  bypass 
    -- CP-element group 375: predecessors 
    -- CP-element group 375: 	374 
    -- CP-element group 375: successors 
    -- CP-element group 375: 	376 
    -- CP-element group 375:  members (3) 
      -- CP-element group 375: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_update_completed_
      -- CP-element group 375: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Update/$exit
      -- CP-element group 375: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1091_Update/ack
      -- 
    ack_2293_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 375_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1091_inst_ack_1, ack => zeropad3D_CP_182_elements(375)); -- 
    -- CP-element group 376:  join  transition  output  bypass 
    -- CP-element group 376: predecessors 
    -- CP-element group 376: 	356 
    -- CP-element group 376: 	375 
    -- CP-element group 376: successors 
    -- CP-element group 376: 	377 
    -- CP-element group 376:  members (3) 
      -- CP-element group 376: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_sample_start_
      -- CP-element group 376: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Sample/$entry
      -- CP-element group 376: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Sample/req
      -- 
    req_2301_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2301_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(376), ack => WPIPE_zeropad_output_pipe_1094_inst_req_0); -- 
    zeropad3D_cp_element_group_376: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_376"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(356) & zeropad3D_CP_182_elements(375);
      gj_zeropad3D_cp_element_group_376 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(376), clk => clk, reset => reset); --
    end block;
    -- CP-element group 377:  transition  input  output  bypass 
    -- CP-element group 377: predecessors 
    -- CP-element group 377: 	376 
    -- CP-element group 377: successors 
    -- CP-element group 377: 	378 
    -- CP-element group 377:  members (6) 
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_sample_completed_
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_update_start_
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Sample/$exit
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Sample/ack
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Update/$entry
      -- CP-element group 377: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Update/req
      -- 
    ack_2302_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 377_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1094_inst_ack_0, ack => zeropad3D_CP_182_elements(377)); -- 
    req_2306_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2306_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(377), ack => WPIPE_zeropad_output_pipe_1094_inst_req_1); -- 
    -- CP-element group 378:  transition  input  bypass 
    -- CP-element group 378: predecessors 
    -- CP-element group 378: 	377 
    -- CP-element group 378: successors 
    -- CP-element group 378: 	379 
    -- CP-element group 378:  members (3) 
      -- CP-element group 378: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_update_completed_
      -- CP-element group 378: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Update/$exit
      -- CP-element group 378: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1094_Update/ack
      -- 
    ack_2307_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 378_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1094_inst_ack_1, ack => zeropad3D_CP_182_elements(378)); -- 
    -- CP-element group 379:  join  transition  output  bypass 
    -- CP-element group 379: predecessors 
    -- CP-element group 379: 	354 
    -- CP-element group 379: 	378 
    -- CP-element group 379: successors 
    -- CP-element group 379: 	380 
    -- CP-element group 379:  members (3) 
      -- CP-element group 379: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_sample_start_
      -- CP-element group 379: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Sample/$entry
      -- CP-element group 379: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Sample/req
      -- 
    req_2315_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2315_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(379), ack => WPIPE_zeropad_output_pipe_1097_inst_req_0); -- 
    zeropad3D_cp_element_group_379: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_379"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(354) & zeropad3D_CP_182_elements(378);
      gj_zeropad3D_cp_element_group_379 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(379), clk => clk, reset => reset); --
    end block;
    -- CP-element group 380:  transition  input  output  bypass 
    -- CP-element group 380: predecessors 
    -- CP-element group 380: 	379 
    -- CP-element group 380: successors 
    -- CP-element group 380: 	381 
    -- CP-element group 380:  members (6) 
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_sample_completed_
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_update_start_
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Sample/$exit
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Sample/ack
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Update/$entry
      -- CP-element group 380: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Update/req
      -- 
    ack_2316_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 380_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1097_inst_ack_0, ack => zeropad3D_CP_182_elements(380)); -- 
    req_2320_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2320_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(380), ack => WPIPE_zeropad_output_pipe_1097_inst_req_1); -- 
    -- CP-element group 381:  transition  input  bypass 
    -- CP-element group 381: predecessors 
    -- CP-element group 381: 	380 
    -- CP-element group 381: successors 
    -- CP-element group 381: 	382 
    -- CP-element group 381:  members (3) 
      -- CP-element group 381: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_update_completed_
      -- CP-element group 381: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Update/$exit
      -- CP-element group 381: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1097_Update/ack
      -- 
    ack_2321_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 381_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1097_inst_ack_1, ack => zeropad3D_CP_182_elements(381)); -- 
    -- CP-element group 382:  join  transition  output  bypass 
    -- CP-element group 382: predecessors 
    -- CP-element group 382: 	352 
    -- CP-element group 382: 	381 
    -- CP-element group 382: successors 
    -- CP-element group 382: 	383 
    -- CP-element group 382:  members (3) 
      -- CP-element group 382: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_sample_start_
      -- CP-element group 382: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Sample/$entry
      -- CP-element group 382: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Sample/req
      -- 
    req_2329_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2329_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(382), ack => WPIPE_zeropad_output_pipe_1100_inst_req_0); -- 
    zeropad3D_cp_element_group_382: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_382"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(352) & zeropad3D_CP_182_elements(381);
      gj_zeropad3D_cp_element_group_382 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(382), clk => clk, reset => reset); --
    end block;
    -- CP-element group 383:  transition  input  output  bypass 
    -- CP-element group 383: predecessors 
    -- CP-element group 383: 	382 
    -- CP-element group 383: successors 
    -- CP-element group 383: 	384 
    -- CP-element group 383:  members (6) 
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_sample_completed_
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_update_start_
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Sample/$exit
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Sample/ack
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Update/$entry
      -- CP-element group 383: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Update/req
      -- 
    ack_2330_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 383_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1100_inst_ack_0, ack => zeropad3D_CP_182_elements(383)); -- 
    req_2334_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2334_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(383), ack => WPIPE_zeropad_output_pipe_1100_inst_req_1); -- 
    -- CP-element group 384:  transition  input  bypass 
    -- CP-element group 384: predecessors 
    -- CP-element group 384: 	383 
    -- CP-element group 384: successors 
    -- CP-element group 384: 	385 
    -- CP-element group 384:  members (3) 
      -- CP-element group 384: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_update_completed_
      -- CP-element group 384: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Update/$exit
      -- CP-element group 384: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1100_Update/ack
      -- 
    ack_2335_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 384_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1100_inst_ack_1, ack => zeropad3D_CP_182_elements(384)); -- 
    -- CP-element group 385:  join  transition  output  bypass 
    -- CP-element group 385: predecessors 
    -- CP-element group 385: 	350 
    -- CP-element group 385: 	384 
    -- CP-element group 385: successors 
    -- CP-element group 385: 	386 
    -- CP-element group 385:  members (3) 
      -- CP-element group 385: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_sample_start_
      -- CP-element group 385: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Sample/$entry
      -- CP-element group 385: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Sample/req
      -- 
    req_2343_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2343_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(385), ack => WPIPE_zeropad_output_pipe_1103_inst_req_0); -- 
    zeropad3D_cp_element_group_385: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_385"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(350) & zeropad3D_CP_182_elements(384);
      gj_zeropad3D_cp_element_group_385 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(385), clk => clk, reset => reset); --
    end block;
    -- CP-element group 386:  transition  input  output  bypass 
    -- CP-element group 386: predecessors 
    -- CP-element group 386: 	385 
    -- CP-element group 386: successors 
    -- CP-element group 386: 	387 
    -- CP-element group 386:  members (6) 
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_sample_completed_
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_update_start_
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Sample/$exit
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Sample/ack
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Update/$entry
      -- CP-element group 386: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Update/req
      -- 
    ack_2344_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 386_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1103_inst_ack_0, ack => zeropad3D_CP_182_elements(386)); -- 
    req_2348_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2348_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(386), ack => WPIPE_zeropad_output_pipe_1103_inst_req_1); -- 
    -- CP-element group 387:  transition  input  bypass 
    -- CP-element group 387: predecessors 
    -- CP-element group 387: 	386 
    -- CP-element group 387: successors 
    -- CP-element group 387: 	388 
    -- CP-element group 387:  members (3) 
      -- CP-element group 387: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_update_completed_
      -- CP-element group 387: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Update/$exit
      -- CP-element group 387: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/WPIPE_zeropad_output_pipe_1103_Update/ack
      -- 
    ack_2349_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 387_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => WPIPE_zeropad_output_pipe_1103_inst_ack_1, ack => zeropad3D_CP_182_elements(387)); -- 
    -- CP-element group 388:  branch  join  transition  place  output  bypass 
    -- CP-element group 388: predecessors 
    -- CP-element group 388: 	343 
    -- CP-element group 388: 	387 
    -- CP-element group 388: successors 
    -- CP-element group 388: 	389 
    -- CP-element group 388: 	390 
    -- CP-element group 388:  members (10) 
      -- CP-element group 388: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/$exit
      -- CP-element group 388: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116__exit__
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117__entry__
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_dead_link/$entry
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_eval_test/$entry
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_eval_test/$exit
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_eval_test/branch_req
      -- CP-element group 388: 	 branch_block_stmt_49/R_exitcond2_1118_place
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_if_link/$entry
      -- CP-element group 388: 	 branch_block_stmt_49/if_stmt_1117_else_link/$entry
      -- 
    branch_req_2357_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " branch_req_2357_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(388), ack => if_stmt_1117_branch_req_0); -- 
    zeropad3D_cp_element_group_388: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_388"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(343) & zeropad3D_CP_182_elements(387);
      gj_zeropad3D_cp_element_group_388 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(388), clk => clk, reset => reset); --
    end block;
    -- CP-element group 389:  merge  transition  place  input  bypass 
    -- CP-element group 389: predecessors 
    -- CP-element group 389: 	388 
    -- CP-element group 389: successors 
    -- CP-element group 389: 	404 
    -- CP-element group 389:  members (13) 
      -- CP-element group 389: 	 branch_block_stmt_49/merge_stmt_1123__exit__
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308
      -- CP-element group 389: 	 branch_block_stmt_49/if_stmt_1117_if_link/$exit
      -- CP-element group 389: 	 branch_block_stmt_49/if_stmt_1117_if_link/if_choice_transition
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit_PhiReq/$entry
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xbody235_forx_xend308x_xloopexit_PhiReq/$exit
      -- CP-element group 389: 	 branch_block_stmt_49/merge_stmt_1123_PhiReqMerge
      -- CP-element group 389: 	 branch_block_stmt_49/merge_stmt_1123_PhiAck/$entry
      -- CP-element group 389: 	 branch_block_stmt_49/merge_stmt_1123_PhiAck/$exit
      -- CP-element group 389: 	 branch_block_stmt_49/merge_stmt_1123_PhiAck/dummy
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308_PhiReq/$entry
      -- CP-element group 389: 	 branch_block_stmt_49/forx_xend308x_xloopexit_forx_xend308_PhiReq/$exit
      -- 
    if_choice_transition_2362_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 389_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_1117_branch_ack_1, ack => zeropad3D_CP_182_elements(389)); -- 
    -- CP-element group 390:  fork  transition  place  input  output  bypass 
    -- CP-element group 390: predecessors 
    -- CP-element group 390: 	388 
    -- CP-element group 390: successors 
    -- CP-element group 390: 	399 
    -- CP-element group 390: 	400 
    -- CP-element group 390:  members (12) 
      -- CP-element group 390: 	 branch_block_stmt_49/if_stmt_1117_else_link/$exit
      -- CP-element group 390: 	 branch_block_stmt_49/if_stmt_1117_else_link/else_choice_transition
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Sample/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Sample/rr
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Update/$entry
      -- CP-element group 390: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Update/cr
      -- 
    else_choice_transition_2366_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 390_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => if_stmt_1117_branch_ack_0, ack => zeropad3D_CP_182_elements(390)); -- 
    rr_2487_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_2487_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(390), ack => type_cast_995_inst_req_0); -- 
    cr_2492_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2492_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(390), ack => type_cast_995_inst_req_1); -- 
    -- CP-element group 391:  transition  output  delay-element  bypass 
    -- CP-element group 391: predecessors 
    -- CP-element group 391: 	76 
    -- CP-element group 391: successors 
    -- CP-element group 391: 	395 
    -- CP-element group 391:  members (5) 
      -- CP-element group 391: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/$exit
      -- CP-element group 391: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/$exit
      -- CP-element group 391: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$exit
      -- CP-element group 391: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_314_konst_delay_trans
      -- CP-element group 391: 	 branch_block_stmt_49/bbx_xnph316_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_req
      -- 
    phi_stmt_310_req_2391_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_310_req_2391_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(391), ack => phi_stmt_310_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(391) is a control-delay.
    cp_element_391_delay: control_delay_element  generic map(name => " 391_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(76), ack => zeropad3D_CP_182_elements(391), clk => clk, reset =>reset);
    -- CP-element group 392:  transition  input  bypass 
    -- CP-element group 392: predecessors 
    -- CP-element group 392: 	119 
    -- CP-element group 392: successors 
    -- CP-element group 392: 	394 
    -- CP-element group 392:  members (2) 
      -- CP-element group 392: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/$exit
      -- CP-element group 392: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Sample/ra
      -- 
    ra_2411_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 392_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_316_inst_ack_0, ack => zeropad3D_CP_182_elements(392)); -- 
    -- CP-element group 393:  transition  input  bypass 
    -- CP-element group 393: predecessors 
    -- CP-element group 393: 	119 
    -- CP-element group 393: successors 
    -- CP-element group 393: 	394 
    -- CP-element group 393:  members (2) 
      -- CP-element group 393: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/$exit
      -- CP-element group 393: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/Update/ca
      -- 
    ca_2416_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 393_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_316_inst_ack_1, ack => zeropad3D_CP_182_elements(393)); -- 
    -- CP-element group 394:  join  transition  output  bypass 
    -- CP-element group 394: predecessors 
    -- CP-element group 394: 	392 
    -- CP-element group 394: 	393 
    -- CP-element group 394: successors 
    -- CP-element group 394: 	395 
    -- CP-element group 394:  members (6) 
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/$exit
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/$exit
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/$exit
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/$exit
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_sources/type_cast_316/SplitProtocol/$exit
      -- CP-element group 394: 	 branch_block_stmt_49/forx_xbody_forx_xbody_PhiReq/phi_stmt_310/phi_stmt_310_req
      -- 
    phi_stmt_310_req_2417_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_310_req_2417_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(394), ack => phi_stmt_310_req_1); -- 
    zeropad3D_cp_element_group_394: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_394"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(392) & zeropad3D_CP_182_elements(393);
      gj_zeropad3D_cp_element_group_394 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(394), clk => clk, reset => reset); --
    end block;
    -- CP-element group 395:  merge  transition  place  bypass 
    -- CP-element group 395: predecessors 
    -- CP-element group 395: 	391 
    -- CP-element group 395: 	394 
    -- CP-element group 395: successors 
    -- CP-element group 395: 	396 
    -- CP-element group 395:  members (2) 
      -- CP-element group 395: 	 branch_block_stmt_49/merge_stmt_309_PhiReqMerge
      -- CP-element group 395: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/$entry
      -- 
    zeropad3D_CP_182_elements(395) <= OrReduce(zeropad3D_CP_182_elements(391) & zeropad3D_CP_182_elements(394));
    -- CP-element group 396:  fork  transition  place  input  output  bypass 
    -- CP-element group 396: predecessors 
    -- CP-element group 396: 	395 
    -- CP-element group 396: successors 
    -- CP-element group 396: 	93 
    -- CP-element group 396: 	97 
    -- CP-element group 396: 	101 
    -- CP-element group 396: 	105 
    -- CP-element group 396: 	109 
    -- CP-element group 396: 	113 
    -- CP-element group 396: 	116 
    -- CP-element group 396: 	78 
    -- CP-element group 396: 	79 
    -- CP-element group 396: 	81 
    -- CP-element group 396: 	82 
    -- CP-element group 396: 	85 
    -- CP-element group 396: 	89 
    -- CP-element group 396:  members (56) 
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/merge_stmt_309__exit__
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472__entry__
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_397_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_415_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/word_0/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/word_access_complete/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/ptr_deref_459_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_451_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_433_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resized_1
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scaled_1
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_computed_1
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/$exit
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/index_resize_req
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_resize_1/index_resize_ack
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/$exit
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/scale_rename_req
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_index_scale_1/scale_rename_ack
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_update_start
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Sample/req
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/array_obj_ref_322_final_index_sum_regn_Update/req
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/addr_of_323_complete/req
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_sample_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/RPIPE_zeropad_input_pipe_326_Sample/rr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_330_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_343_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/$entry
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_361_Update/cr
      -- CP-element group 396: 	 branch_block_stmt_49/assign_stmt_324_to_assign_stmt_472/type_cast_379_update_start_
      -- CP-element group 396: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/$exit
      -- CP-element group 396: 	 branch_block_stmt_49/merge_stmt_309_PhiAck/phi_stmt_310_ack
      -- 
    phi_stmt_310_ack_2422_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 396_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_310_ack_0, ack => zeropad3D_CP_182_elements(396)); -- 
    cr_942_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_942_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_397_inst_req_1); -- 
    cr_970_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_970_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_415_inst_req_1); -- 
    cr_1076_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1076_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => ptr_deref_459_store_0_req_1); -- 
    cr_914_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_914_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_379_inst_req_1); -- 
    cr_1026_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1026_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_451_inst_req_1); -- 
    cr_998_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_998_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_433_inst_req_1); -- 
    req_782_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_782_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => array_obj_ref_322_index_offset_req_0); -- 
    req_787_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_787_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => array_obj_ref_322_index_offset_req_1); -- 
    req_802_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_802_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => addr_of_323_final_reg_req_1); -- 
    rr_811_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " rr_811_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => RPIPE_zeropad_input_pipe_326_inst_req_0); -- 
    cr_830_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_830_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_330_inst_req_1); -- 
    cr_858_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_858_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_343_inst_req_1); -- 
    cr_886_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_886_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(396), ack => type_cast_361_inst_req_1); -- 
    -- CP-element group 397:  merge  fork  transition  place  output  bypass 
    -- CP-element group 397: predecessors 
    -- CP-element group 397: 	118 
    -- CP-element group 397: 	77 
    -- CP-element group 397: successors 
    -- CP-element group 397: 	120 
    -- CP-element group 397: 	121 
    -- CP-element group 397: 	123 
    -- CP-element group 397:  members (16) 
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_update_start_
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/$entry
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/$entry
      -- CP-element group 397: 	 branch_block_stmt_49/merge_stmt_481__exit__
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489__entry__
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Sample/crr
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/cr
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/type_cast_488_Update/$entry
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_update_start_
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_sample_start_
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/$entry
      -- CP-element group 397: 	 branch_block_stmt_49/call_stmt_484_to_assign_stmt_489/call_stmt_484_Update/ccr
      -- CP-element group 397: 	 branch_block_stmt_49/merge_stmt_481_PhiReqMerge
      -- CP-element group 397: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/$entry
      -- CP-element group 397: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/$exit
      -- CP-element group 397: 	 branch_block_stmt_49/merge_stmt_481_PhiAck/dummy
      -- 
    crr_1107_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " crr_1107_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(397), ack => call_stmt_484_call_req_0); -- 
    cr_1126_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_1126_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(397), ack => type_cast_488_inst_req_1); -- 
    ccr_1112_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " ccr_1112_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(397), ack => call_stmt_484_call_req_1); -- 
    zeropad3D_CP_182_elements(397) <= OrReduce(zeropad3D_CP_182_elements(118) & zeropad3D_CP_182_elements(77));
    -- CP-element group 398:  transition  output  delay-element  bypass 
    -- CP-element group 398: predecessors 
    -- CP-element group 398: 	342 
    -- CP-element group 398: successors 
    -- CP-element group 398: 	402 
    -- CP-element group 398:  members (5) 
      -- CP-element group 398: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/$exit
      -- CP-element group 398: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/$exit
      -- CP-element group 398: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/$exit
      -- CP-element group 398: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_993_konst_delay_trans
      -- CP-element group 398: 	 branch_block_stmt_49/bbx_xnph_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_req
      -- 
    phi_stmt_989_req_2468_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_989_req_2468_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(398), ack => phi_stmt_989_req_0); -- 
    -- Element group zeropad3D_CP_182_elements(398) is a control-delay.
    cp_element_398_delay: control_delay_element  generic map(name => " 398_delay", delay_value => 1)  port map(req => zeropad3D_CP_182_elements(342), ack => zeropad3D_CP_182_elements(398), clk => clk, reset =>reset);
    -- CP-element group 399:  transition  input  bypass 
    -- CP-element group 399: predecessors 
    -- CP-element group 399: 	390 
    -- CP-element group 399: successors 
    -- CP-element group 399: 	401 
    -- CP-element group 399:  members (2) 
      -- CP-element group 399: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Sample/$exit
      -- CP-element group 399: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Sample/ra
      -- 
    ra_2488_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 399_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_995_inst_ack_0, ack => zeropad3D_CP_182_elements(399)); -- 
    -- CP-element group 400:  transition  input  bypass 
    -- CP-element group 400: predecessors 
    -- CP-element group 400: 	390 
    -- CP-element group 400: successors 
    -- CP-element group 400: 	401 
    -- CP-element group 400:  members (2) 
      -- CP-element group 400: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Update/$exit
      -- CP-element group 400: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/Update/ca
      -- 
    ca_2493_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 400_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => type_cast_995_inst_ack_1, ack => zeropad3D_CP_182_elements(400)); -- 
    -- CP-element group 401:  join  transition  output  bypass 
    -- CP-element group 401: predecessors 
    -- CP-element group 401: 	399 
    -- CP-element group 401: 	400 
    -- CP-element group 401: successors 
    -- CP-element group 401: 	402 
    -- CP-element group 401:  members (6) 
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/$exit
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/$exit
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/$exit
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/$exit
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_sources/type_cast_995/SplitProtocol/$exit
      -- CP-element group 401: 	 branch_block_stmt_49/forx_xbody235_forx_xbody235_PhiReq/phi_stmt_989/phi_stmt_989_req
      -- 
    phi_stmt_989_req_2494_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " phi_stmt_989_req_2494_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(401), ack => phi_stmt_989_req_1); -- 
    zeropad3D_cp_element_group_401: block -- 
      constant place_capacities: IntegerArray(0 to 1) := (0 => 1,1 => 1);
      constant place_markings: IntegerArray(0 to 1)  := (0 => 0,1 => 0);
      constant place_delays: IntegerArray(0 to 1) := (0 => 0,1 => 0);
      constant joinName: string(1 to 30) := "zeropad3D_cp_element_group_401"; 
      signal preds: BooleanArray(1 to 2); -- 
    begin -- 
      preds <= zeropad3D_CP_182_elements(399) & zeropad3D_CP_182_elements(400);
      gj_zeropad3D_cp_element_group_401 : generic_join generic map(name => joinName, number_of_predecessors => 2, place_capacities => place_capacities, place_markings => place_markings, place_delays => place_delays) -- 
        port map(preds => preds, symbol_out => zeropad3D_CP_182_elements(401), clk => clk, reset => reset); --
    end block;
    -- CP-element group 402:  merge  transition  place  bypass 
    -- CP-element group 402: predecessors 
    -- CP-element group 402: 	398 
    -- CP-element group 402: 	401 
    -- CP-element group 402: successors 
    -- CP-element group 402: 	403 
    -- CP-element group 402:  members (2) 
      -- CP-element group 402: 	 branch_block_stmt_49/merge_stmt_988_PhiReqMerge
      -- CP-element group 402: 	 branch_block_stmt_49/merge_stmt_988_PhiAck/$entry
      -- 
    zeropad3D_CP_182_elements(402) <= OrReduce(zeropad3D_CP_182_elements(398) & zeropad3D_CP_182_elements(401));
    -- CP-element group 403:  fork  transition  place  input  output  bypass 
    -- CP-element group 403: predecessors 
    -- CP-element group 403: 	402 
    -- CP-element group 403: successors 
    -- CP-element group 403: 	343 
    -- CP-element group 403: 	344 
    -- CP-element group 403: 	346 
    -- CP-element group 403: 	348 
    -- CP-element group 403: 	350 
    -- CP-element group 403: 	352 
    -- CP-element group 403: 	354 
    -- CP-element group 403: 	356 
    -- CP-element group 403: 	358 
    -- CP-element group 403: 	360 
    -- CP-element group 403: 	362 
    -- CP-element group 403: 	364 
    -- CP-element group 403:  members (53) 
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_scale_1/scale_rename_req
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_complete/req
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/addr_of_1002_complete/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/merge_stmt_988__exit__
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116__entry__
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_update_start
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1020_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Sample/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Sample/req
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_scale_1/scale_rename_ack
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_resized_1
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_final_index_sum_regn_Update/req
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_scaled_1
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_scale_1/$exit
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/word_0/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/word_0/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/word_access_complete/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/ptr_deref_1006_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1030_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_scale_1/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_resize_1/index_resize_ack
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1010_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_resize_1/index_resize_req
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_resize_1/$exit
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_resize_1/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/array_obj_ref_1001_index_computed_1
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1040_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1050_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1060_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1070_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_update_start_
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Update/$entry
      -- CP-element group 403: 	 branch_block_stmt_49/assign_stmt_1003_to_assign_stmt_1116/type_cast_1080_Update/cr
      -- CP-element group 403: 	 branch_block_stmt_49/merge_stmt_988_PhiAck/$exit
      -- CP-element group 403: 	 branch_block_stmt_49/merge_stmt_988_PhiAck/phi_stmt_989_ack
      -- 
    phi_stmt_989_ack_2499_symbol_link_from_dp: control_delay_element -- 
      generic map(name => " 403_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => phi_stmt_989_ack_0, ack => zeropad3D_CP_182_elements(403)); -- 
    cr_2166_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2166_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1030_inst_req_1); -- 
    req_2074_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2074_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => addr_of_1002_final_reg_req_1); -- 
    cr_2152_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2152_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1020_inst_req_1); -- 
    req_2054_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2054_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => array_obj_ref_1001_index_offset_req_0); -- 
    req_2059_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " req_2059_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => array_obj_ref_1001_index_offset_req_1); -- 
    cr_2119_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2119_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => ptr_deref_1006_load_0_req_1); -- 
    cr_2138_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2138_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1010_inst_req_1); -- 
    cr_2180_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2180_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1040_inst_req_1); -- 
    cr_2194_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2194_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1050_inst_req_1); -- 
    cr_2208_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2208_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1060_inst_req_1); -- 
    cr_2222_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2222_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1070_inst_req_1); -- 
    cr_2236_symbol_link_to_dp: control_delay_element -- 
      generic map(name => " cr_2236_symbol_delay",delay_value => 0)
      port map(clk => clk, reset => reset, req => zeropad3D_CP_182_elements(403), ack => type_cast_1080_inst_req_1); -- 
    -- CP-element group 404:  merge  transition  place  bypass 
    -- CP-element group 404: predecessors 
    -- CP-element group 404: 	340 
    -- CP-element group 404: 	389 
    -- CP-element group 404: successors 
    -- CP-element group 404:  members (16) 
      -- CP-element group 404: 	 $exit
      -- CP-element group 404: 	 branch_block_stmt_49/$exit
      -- CP-element group 404: 	 branch_block_stmt_49/branch_block_stmt_49__exit__
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1125__exit__
      -- CP-element group 404: 	 branch_block_stmt_49/return__
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1127__exit__
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1125_PhiReqMerge
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1125_PhiAck/$entry
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1125_PhiAck/$exit
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1125_PhiAck/dummy
      -- CP-element group 404: 	 branch_block_stmt_49/return___PhiReq/$entry
      -- CP-element group 404: 	 branch_block_stmt_49/return___PhiReq/$exit
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1127_PhiReqMerge
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1127_PhiAck/$entry
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1127_PhiAck/$exit
      -- CP-element group 404: 	 branch_block_stmt_49/merge_stmt_1127_PhiAck/dummy
      -- 
    zeropad3D_CP_182_elements(404) <= OrReduce(zeropad3D_CP_182_elements(340) & zeropad3D_CP_182_elements(389));
    zeropad3D_do_while_stmt_567_terminator_1687: loop_terminator -- 
      generic map (name => " zeropad3D_do_while_stmt_567_terminator_1687", max_iterations_in_flight =>15) 
      port map(loop_body_exit => zeropad3D_CP_182_elements(128),loop_continue => zeropad3D_CP_182_elements(287),loop_terminate => zeropad3D_CP_182_elements(286),loop_back => zeropad3D_CP_182_elements(126),loop_exit => zeropad3D_CP_182_elements(125),clk => clk, reset => reset); -- 
    phi_stmt_569_phi_seq_1197_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_CP_182_elements(143);
      zeropad3D_CP_182_elements(146)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_CP_182_elements(146);
      zeropad3D_CP_182_elements(147)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_CP_182_elements(148);
      zeropad3D_CP_182_elements(144) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_CP_182_elements(141);
      zeropad3D_CP_182_elements(150)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_CP_182_elements(152);
      zeropad3D_CP_182_elements(151)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_CP_182_elements(153);
      zeropad3D_CP_182_elements(142) <= phi_mux_reqs(1);
      phi_stmt_569_phi_seq_1197 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_569_phi_seq_1197") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_CP_182_elements(133), 
          phi_sample_ack => zeropad3D_CP_182_elements(139), 
          phi_update_req => zeropad3D_CP_182_elements(135), 
          phi_update_ack => zeropad3D_CP_182_elements(140), 
          phi_mux_ack => zeropad3D_CP_182_elements(145), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_573_phi_seq_1241_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_CP_182_elements(162);
      zeropad3D_CP_182_elements(165)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_CP_182_elements(165);
      zeropad3D_CP_182_elements(166)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_CP_182_elements(167);
      zeropad3D_CP_182_elements(163) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_CP_182_elements(160);
      zeropad3D_CP_182_elements(169)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_CP_182_elements(171);
      zeropad3D_CP_182_elements(170)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_CP_182_elements(172);
      zeropad3D_CP_182_elements(161) <= phi_mux_reqs(1);
      phi_stmt_573_phi_seq_1241 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_573_phi_seq_1241") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_CP_182_elements(156), 
          phi_sample_ack => zeropad3D_CP_182_elements(157), 
          phi_update_req => zeropad3D_CP_182_elements(158), 
          phi_update_ack => zeropad3D_CP_182_elements(159), 
          phi_mux_ack => zeropad3D_CP_182_elements(164), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_577_phi_seq_1285_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_CP_182_elements(181);
      zeropad3D_CP_182_elements(184)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_CP_182_elements(184);
      zeropad3D_CP_182_elements(185)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_CP_182_elements(186);
      zeropad3D_CP_182_elements(182) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_CP_182_elements(179);
      zeropad3D_CP_182_elements(188)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_CP_182_elements(190);
      zeropad3D_CP_182_elements(189)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_CP_182_elements(191);
      zeropad3D_CP_182_elements(180) <= phi_mux_reqs(1);
      phi_stmt_577_phi_seq_1285 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_577_phi_seq_1285") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_CP_182_elements(175), 
          phi_sample_ack => zeropad3D_CP_182_elements(176), 
          phi_update_req => zeropad3D_CP_182_elements(177), 
          phi_update_ack => zeropad3D_CP_182_elements(178), 
          phi_mux_ack => zeropad3D_CP_182_elements(183), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_581_phi_seq_1329_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_CP_182_elements(200);
      zeropad3D_CP_182_elements(203)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_CP_182_elements(203);
      zeropad3D_CP_182_elements(204)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_CP_182_elements(205);
      zeropad3D_CP_182_elements(201) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_CP_182_elements(198);
      zeropad3D_CP_182_elements(207)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_CP_182_elements(209);
      zeropad3D_CP_182_elements(208)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_CP_182_elements(210);
      zeropad3D_CP_182_elements(199) <= phi_mux_reqs(1);
      phi_stmt_581_phi_seq_1329 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_581_phi_seq_1329") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_CP_182_elements(194), 
          phi_sample_ack => zeropad3D_CP_182_elements(195), 
          phi_update_req => zeropad3D_CP_182_elements(196), 
          phi_update_ack => zeropad3D_CP_182_elements(197), 
          phi_mux_ack => zeropad3D_CP_182_elements(202), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    phi_stmt_585_phi_seq_1373_block : block -- 
      signal triggers, src_sample_reqs, src_sample_acks, src_update_reqs, src_update_acks : BooleanArray(0 to 1);
      signal phi_mux_reqs : BooleanArray(0 to 1); -- 
    begin -- 
      triggers(0)  <= zeropad3D_CP_182_elements(219);
      zeropad3D_CP_182_elements(222)<= src_sample_reqs(0);
      src_sample_acks(0)  <= zeropad3D_CP_182_elements(222);
      zeropad3D_CP_182_elements(223)<= src_update_reqs(0);
      src_update_acks(0)  <= zeropad3D_CP_182_elements(224);
      zeropad3D_CP_182_elements(220) <= phi_mux_reqs(0);
      triggers(1)  <= zeropad3D_CP_182_elements(217);
      zeropad3D_CP_182_elements(226)<= src_sample_reqs(1);
      src_sample_acks(1)  <= zeropad3D_CP_182_elements(228);
      zeropad3D_CP_182_elements(227)<= src_update_reqs(1);
      src_update_acks(1)  <= zeropad3D_CP_182_elements(229);
      zeropad3D_CP_182_elements(218) <= phi_mux_reqs(1);
      phi_stmt_585_phi_seq_1373 : phi_sequencer_v2-- 
        generic map (place_capacity => 15, ntriggers => 2, name => "phi_stmt_585_phi_seq_1373") 
        port map ( -- 
          triggers => triggers, src_sample_starts => src_sample_reqs, 
          src_sample_completes => src_sample_acks, src_update_starts => src_update_reqs, 
          src_update_completes => src_update_acks,
          phi_mux_select_reqs => phi_mux_reqs, 
          phi_sample_req => zeropad3D_CP_182_elements(213), 
          phi_sample_ack => zeropad3D_CP_182_elements(214), 
          phi_update_req => zeropad3D_CP_182_elements(215), 
          phi_update_ack => zeropad3D_CP_182_elements(216), 
          phi_mux_ack => zeropad3D_CP_182_elements(221), 
          clk => clk, reset => reset -- 
        );
        -- 
    end block;
    entry_tmerge_1149_block : block -- 
      signal preds : BooleanArray(0 to 1);
      begin -- 
        preds(0)  <= zeropad3D_CP_182_elements(129);
        preds(1)  <= zeropad3D_CP_182_elements(130);
        entry_tmerge_1149 : transition_merge -- 
          generic map(name => " entry_tmerge_1149")
          port map (preds => preds, symbol_out => zeropad3D_CP_182_elements(131));
          -- 
    end block;
    --  hookup: inputs to control-path 
    -- hookup: output from control-path 
    -- 
  end Block; -- control-path
  -- the data path
  data_path: Block -- 
    signal ADD_u16_u16_657_657_delayed_1_0_654 : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_664_664_delayed_1_0_664 : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_794_wire : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_805_wire : std_logic_vector(15 downto 0);
    signal ADD_u16_u16_813_wire : std_logic_vector(15 downto 0);
    signal ASHR_i32_i32_965_wire : std_logic_vector(31 downto 0);
    signal ASHR_i64_i64_272_wire : std_logic_vector(63 downto 0);
    signal MUX_727_wire : std_logic_vector(63 downto 0);
    signal MUX_806_wire : std_logic_vector(15 downto 0);
    signal NOT_u1_u1_762_wire : std_logic_vector(0 downto 0);
    signal NOT_u1_u1_786_wire : std_logic_vector(0 downto 0);
    signal R_indvar317_321_resized : std_logic_vector(13 downto 0);
    signal R_indvar317_321_scaled : std_logic_vector(13 downto 0);
    signal R_indvar_1000_resized : std_logic_vector(13 downto 0);
    signal R_indvar_1000_scaled : std_logic_vector(13 downto 0);
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
    signal array_obj_ref_1001_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1001_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_1001_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1001_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_1001_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_1001_root_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_322_root_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_700_root_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_constant_part_of_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_final_offset : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_offset_scale_factor_0 : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_offset_scale_factor_1 : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_resized_base_address : std_logic_vector(13 downto 0);
    signal array_obj_ref_712_root_address : std_logic_vector(13 downto 0);
    signal arrayidx240_1003 : std_logic_vector(31 downto 0);
    signal arrayidx_324 : std_logic_vector(31 downto 0);
    signal call103_358 : std_logic_vector(7 downto 0);
    signal call109_376 : std_logic_vector(7 downto 0);
    signal call115_394 : std_logic_vector(7 downto 0);
    signal call11_61 : std_logic_vector(7 downto 0);
    signal call121_412 : std_logic_vector(7 downto 0);
    signal call127_430 : std_logic_vector(7 downto 0);
    signal call133_448 : std_logic_vector(7 downto 0);
    signal call141_484 : std_logic_vector(63 downto 0);
    signal call153_825 : std_logic_vector(63 downto 0);
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
    signal cmp233310_975 : std_logic_vector(0 downto 0);
    signal cmp314_281 : std_logic_vector(0 downto 0);
    signal cmp_dim0_789 : std_logic_vector(0 downto 0);
    signal cmp_dim1_765 : std_logic_vector(0 downto 0);
    signal cmp_dim2_741 : std_logic_vector(0 downto 0);
    signal conv105_362 : std_logic_vector(63 downto 0);
    signal conv111_380 : std_logic_vector(63 downto 0);
    signal conv117_398 : std_logic_vector(63 downto 0);
    signal conv123_416 : std_logic_vector(63 downto 0);
    signal conv129_434 : std_logic_vector(63 downto 0);
    signal conv135_452 : std_logic_vector(63 downto 0);
    signal conv142_489 : std_logic_vector(63 downto 0);
    signal conv154_830 : std_logic_vector(63 downto 0);
    signal conv160_840 : std_logic_vector(7 downto 0);
    signal conv166_850 : std_logic_vector(7 downto 0);
    signal conv172_860 : std_logic_vector(7 downto 0);
    signal conv178_870 : std_logic_vector(7 downto 0);
    signal conv184_880 : std_logic_vector(7 downto 0);
    signal conv190_890 : std_logic_vector(7 downto 0);
    signal conv196_900 : std_logic_vector(7 downto 0);
    signal conv19_68 : std_logic_vector(15 downto 0);
    signal conv202_910 : std_logic_vector(7 downto 0);
    signal conv222_939 : std_logic_vector(31 downto 0);
    signal conv224_943 : std_logic_vector(31 downto 0);
    signal conv227_947 : std_logic_vector(31 downto 0);
    signal conv22_81 : std_logic_vector(15 downto 0);
    signal conv245_1011 : std_logic_vector(7 downto 0);
    signal conv251_1021 : std_logic_vector(7 downto 0);
    signal conv257_1031 : std_logic_vector(7 downto 0);
    signal conv263_1041 : std_logic_vector(7 downto 0);
    signal conv269_1051 : std_logic_vector(7 downto 0);
    signal conv275_1061 : std_logic_vector(7 downto 0);
    signal conv281_1071 : std_logic_vector(7 downto 0);
    signal conv287_1081 : std_logic_vector(7 downto 0);
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
    signal data_check1_674 : std_logic_vector(0 downto 0);
    signal data_check2_679 : std_logic_vector(0 downto 0);
    signal data_check_684 : std_logic_vector(0 downto 0);
    signal data_check_714_delayed_12_0_720 : std_logic_vector(0 downto 0);
    signal dest_add_581 : std_logic_vector(15 downto 0);
    signal dest_add_init_529 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_1_594 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_2_599 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_3_604 : std_logic_vector(15 downto 0);
    signal dest_data_array_idx_4_609 : std_logic_vector(15 downto 0);
    signal dim0T_537 : std_logic_vector(15 downto 0);
    signal dim0T_check_1_770 : std_logic_vector(15 downto 0);
    signal dim0T_check_2_763_delayed_1_0_778 : std_logic_vector(15 downto 0);
    signal dim0T_check_2_775 : std_logic_vector(15 downto 0);
    signal dim0T_check_3_783 : std_logic_vector(0 downto 0);
    signal dim1R_549 : std_logic_vector(15 downto 0);
    signal dim1T_541 : std_logic_vector(15 downto 0);
    signal dim1T_check_1_746 : std_logic_vector(15 downto 0);
    signal dim1T_check_2_742_delayed_1_0_754 : std_logic_vector(15 downto 0);
    signal dim1T_check_2_751 : std_logic_vector(15 downto 0);
    signal dim1T_check_3_759 : std_logic_vector(0 downto 0);
    signal dim21R_563 : std_logic_vector(15 downto 0);
    signal dim21T_558 : std_logic_vector(15 downto 0);
    signal dim2R_553 : std_logic_vector(15 downto 0);
    signal dim2T_545 : std_logic_vector(15 downto 0);
    signal dim2T_dif_727_delayed_1_0_736 : std_logic_vector(15 downto 0);
    signal dim2T_dif_733 : std_logic_vector(15 downto 0);
    signal exitcond2_1116 : std_logic_vector(0 downto 0);
    signal exitcond_472 : std_logic_vector(0 downto 0);
    signal flag_820 : std_logic_vector(0 downto 0);
    signal i1_706 : std_logic_vector(63 downto 0);
    signal i_large_check_659 : std_logic_vector(0 downto 0);
    signal i_loop_577 : std_logic_vector(15 downto 0);
    signal i_loop_init_513 : std_logic_vector(15 downto 0);
    signal i_small_check_644 : std_logic_vector(0 downto 0);
    signal img_data_array_idx_1_614 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_2_619 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_3_624 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_4_629 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_5_634 : std_logic_vector(15 downto 0);
    signal img_data_array_idx_6_639 : std_logic_vector(15 downto 0);
    signal indvar317_310 : std_logic_vector(63 downto 0);
    signal indvar_989 : std_logic_vector(63 downto 0);
    signal indvarx_xnext318_467 : std_logic_vector(63 downto 0);
    signal indvarx_xnext_1111 : std_logic_vector(63 downto 0);
    signal inp_d0_493 : std_logic_vector(15 downto 0);
    signal inp_d1_496 : std_logic_vector(15 downto 0);
    signal inp_d2_499 : std_logic_vector(15 downto 0);
    signal iv1_702 : std_logic_vector(31 downto 0);
    signal j1_533 : std_logic_vector(15 downto 0);
    signal j_large_check_669 : std_logic_vector(0 downto 0);
    signal j_loop_573 : std_logic_vector(15 downto 0);
    signal j_loop_init_517 : std_logic_vector(15 downto 0);
    signal j_small_check_649 : std_logic_vector(0 downto 0);
    signal k_loop_569 : std_logic_vector(15 downto 0);
    signal k_loop_init_521 : std_logic_vector(15 downto 0);
    signal konst_687_wire_constant : std_logic_vector(15 downto 0);
    signal konst_692_wire_constant : std_logic_vector(15 downto 0);
    signal konst_731_wire_constant : std_logic_vector(15 downto 0);
    signal konst_744_wire_constant : std_logic_vector(15 downto 0);
    signal konst_768_wire_constant : std_logic_vector(15 downto 0);
    signal konst_793_wire_constant : std_logic_vector(15 downto 0);
    signal konst_795_wire_constant : std_logic_vector(15 downto 0);
    signal konst_804_wire_constant : std_logic_vector(15 downto 0);
    signal konst_812_wire_constant : std_logic_vector(15 downto 0);
    signal mul225_952 : std_logic_vector(31 downto 0);
    signal mul228_957 : std_logic_vector(31 downto 0);
    signal mul86_259 : std_logic_vector(63 downto 0);
    signal mul_254 : std_logic_vector(63 downto 0);
    signal next_dest_add_689 : std_logic_vector(15 downto 0);
    signal next_dest_add_689_584_buffered : std_logic_vector(15 downto 0);
    signal next_i_loop_816 : std_logic_vector(15 downto 0);
    signal next_i_loop_816_580_buffered : std_logic_vector(15 downto 0);
    signal next_j_loop_808 : std_logic_vector(15 downto 0);
    signal next_j_loop_808_576_buffered : std_logic_vector(15 downto 0);
    signal next_k_loop_797 : std_logic_vector(15 downto 0);
    signal next_k_loop_797_572_buffered : std_logic_vector(15 downto 0);
    signal next_src_add_694 : std_logic_vector(15 downto 0);
    signal next_src_add_694_588_buffered : std_logic_vector(15 downto 0);
    signal out_d1_502 : std_logic_vector(15 downto 0);
    signal out_d2_505 : std_logic_vector(15 downto 0);
    signal ov_712_delayed_7_0_717 : std_logic_vector(31 downto 0);
    signal ov_714 : std_logic_vector(31 downto 0);
    signal pad_566 : std_logic_vector(15 downto 0);
    signal padding_508 : std_logic_vector(15 downto 0);
    signal ptr_deref_1006_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_1006_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1006_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_1006_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_1006_word_offset_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_459_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_459_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_459_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_459_wire : std_logic_vector(63 downto 0);
    signal ptr_deref_459_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_459_word_offset_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_705_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_705_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_705_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_705_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_705_word_offset_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_722_data_0 : std_logic_vector(63 downto 0);
    signal ptr_deref_722_resized_base_address : std_logic_vector(13 downto 0);
    signal ptr_deref_722_root_address : std_logic_vector(13 downto 0);
    signal ptr_deref_722_wire : std_logic_vector(63 downto 0);
    signal ptr_deref_722_word_address_0 : std_logic_vector(13 downto 0);
    signal ptr_deref_722_word_offset_0 : std_logic_vector(13 downto 0);
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
    signal shr163_846 : std_logic_vector(63 downto 0);
    signal shr169_856 : std_logic_vector(63 downto 0);
    signal shr175_866 : std_logic_vector(63 downto 0);
    signal shr181_876 : std_logic_vector(63 downto 0);
    signal shr187_886 : std_logic_vector(63 downto 0);
    signal shr193_896 : std_logic_vector(63 downto 0);
    signal shr199_906 : std_logic_vector(63 downto 0);
    signal shr232309_967 : std_logic_vector(31 downto 0);
    signal shr248_1017 : std_logic_vector(63 downto 0);
    signal shr254_1027 : std_logic_vector(63 downto 0);
    signal shr260_1037 : std_logic_vector(63 downto 0);
    signal shr266_1047 : std_logic_vector(63 downto 0);
    signal shr272_1057 : std_logic_vector(63 downto 0);
    signal shr278_1067 : std_logic_vector(63 downto 0);
    signal shr284_1077 : std_logic_vector(63 downto 0);
    signal shr_294 : std_logic_vector(63 downto 0);
    signal src_add_585 : std_logic_vector(15 downto 0);
    signal src_add_init_525 : std_logic_vector(15 downto 0);
    signal sub_835 : std_logic_vector(63 downto 0);
    signal tmp1_986 : std_logic_vector(63 downto 0);
    signal tmp241_1007 : std_logic_vector(63 downto 0);
    signal tmp_300 : std_logic_vector(0 downto 0);
    signal type_cast_1015_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1025_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1035_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1045_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1055_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1065_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1075_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_1109_wire_constant : std_logic_vector(63 downto 0);
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
    signal type_cast_699_resized : std_logic_vector(13 downto 0);
    signal type_cast_699_scaled : std_logic_vector(13 downto 0);
    signal type_cast_699_wire : std_logic_vector(63 downto 0);
    signal type_cast_711_resized : std_logic_vector(13 downto 0);
    signal type_cast_711_scaled : std_logic_vector(13 downto 0);
    signal type_cast_711_wire : std_logic_vector(63 downto 0);
    signal type_cast_725_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_72_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_828_wire : std_logic_vector(63 downto 0);
    signal type_cast_844_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_854_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_864_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_874_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_884_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_894_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_904_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_961_wire : std_logic_vector(31 downto 0);
    signal type_cast_964_wire_constant : std_logic_vector(31 downto 0);
    signal type_cast_970_wire : std_logic_vector(31 downto 0);
    signal type_cast_973_wire_constant : std_logic_vector(31 downto 0);
    signal type_cast_97_wire_constant : std_logic_vector(15 downto 0);
    signal type_cast_993_wire_constant : std_logic_vector(63 downto 0);
    signal type_cast_995_wire : std_logic_vector(63 downto 0);
    signal umax3_307 : std_logic_vector(63 downto 0);
    -- 
  begin -- 
    array_obj_ref_1001_constant_part_of_offset <= "00000000000000";
    array_obj_ref_1001_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_1001_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_1001_resized_base_address <= "00000000000000";
    array_obj_ref_322_constant_part_of_offset <= "00000000000000";
    array_obj_ref_322_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_322_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_322_resized_base_address <= "00000000000000";
    array_obj_ref_700_constant_part_of_offset <= "00000000000000";
    array_obj_ref_700_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_700_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_700_resized_base_address <= "00000000000000";
    array_obj_ref_712_constant_part_of_offset <= "00000000000000";
    array_obj_ref_712_offset_scale_factor_0 <= "00000000000000";
    array_obj_ref_712_offset_scale_factor_1 <= "00000000000001";
    array_obj_ref_712_resized_base_address <= "00000000000000";
    dest_add_init_529 <= "0000000000000000";
    i_loop_init_513 <= "0000000000000000";
    j1_533 <= "0000000000000000";
    j_loop_init_517 <= "0000000000000000";
    k_loop_init_521 <= "0000000000000000";
    konst_687_wire_constant <= "0000000000000011";
    konst_692_wire_constant <= "0000000000000011";
    konst_731_wire_constant <= "0000000000001000";
    konst_744_wire_constant <= "0000000000000001";
    konst_768_wire_constant <= "0000000000000001";
    konst_793_wire_constant <= "0000000000001000";
    konst_795_wire_constant <= "0000000000000000";
    konst_804_wire_constant <= "0000000000000001";
    konst_812_wire_constant <= "0000000000000001";
    ptr_deref_1006_word_offset_0 <= "00000000000000";
    ptr_deref_459_word_offset_0 <= "00000000000000";
    ptr_deref_705_word_offset_0 <= "00000000000000";
    ptr_deref_722_word_offset_0 <= "00000000000000";
    src_add_init_525 <= "0000000000000000";
    type_cast_1015_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_1025_wire_constant <= "0000000000000000000000000000000000000000000000000000000000010000";
    type_cast_1035_wire_constant <= "0000000000000000000000000000000000000000000000000000000000011000";
    type_cast_1045_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_1055_wire_constant <= "0000000000000000000000000000000000000000000000000000000000101000";
    type_cast_1065_wire_constant <= "0000000000000000000000000000000000000000000000000000000000110000";
    type_cast_1075_wire_constant <= "0000000000000000000000000000000000000000000000000000000000111000";
    type_cast_1109_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000001";
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
    type_cast_725_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
    type_cast_72_wire_constant <= "0000000000001000";
    type_cast_844_wire_constant <= "0000000000000000000000000000000000000000000000000000000000001000";
    type_cast_854_wire_constant <= "0000000000000000000000000000000000000000000000000000000000010000";
    type_cast_864_wire_constant <= "0000000000000000000000000000000000000000000000000000000000011000";
    type_cast_874_wire_constant <= "0000000000000000000000000000000000000000000000000000000000100000";
    type_cast_884_wire_constant <= "0000000000000000000000000000000000000000000000000000000000101000";
    type_cast_894_wire_constant <= "0000000000000000000000000000000000000000000000000000000000110000";
    type_cast_904_wire_constant <= "0000000000000000000000000000000000000000000000000000000000111000";
    type_cast_964_wire_constant <= "00000000000000000000000000000010";
    type_cast_973_wire_constant <= "00000000000000000000000000000000";
    type_cast_97_wire_constant <= "0000000000001000";
    type_cast_993_wire_constant <= "0000000000000000000000000000000000000000000000000000000000000000";
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
    phi_stmt_569: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= k_loop_init_521 & next_k_loop_797_572_buffered;
      req <= phi_stmt_569_req_0 & phi_stmt_569_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_569",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_569_ack_0,
          idata => idata,
          odata => k_loop_569,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_569
    phi_stmt_573: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= j_loop_init_517 & next_j_loop_808_576_buffered;
      req <= phi_stmt_573_req_0 & phi_stmt_573_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_573",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_573_ack_0,
          idata => idata,
          odata => j_loop_573,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_573
    phi_stmt_577: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= i_loop_init_513 & next_i_loop_816_580_buffered;
      req <= phi_stmt_577_req_0 & phi_stmt_577_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_577",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_577_ack_0,
          idata => idata,
          odata => i_loop_577,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_577
    phi_stmt_581: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= dest_add_init_529 & next_dest_add_689_584_buffered;
      req <= phi_stmt_581_req_0 & phi_stmt_581_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_581",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_581_ack_0,
          idata => idata,
          odata => dest_add_581,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_581
    phi_stmt_585: Block -- phi operator 
      signal idata: std_logic_vector(31 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= src_add_init_525 & next_src_add_694_588_buffered;
      req <= phi_stmt_585_req_0 & phi_stmt_585_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_585",
          num_reqs => 2,
          bypass_flag => true,
          data_width => 16) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_585_ack_0,
          idata => idata,
          odata => src_add_585,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_585
    phi_stmt_989: Block -- phi operator 
      signal idata: std_logic_vector(127 downto 0);
      signal req: BooleanArray(1 downto 0);
      --
    begin -- 
      idata <= type_cast_993_wire_constant & type_cast_995_wire;
      req <= phi_stmt_989_req_0 & phi_stmt_989_req_1;
      phi: PhiBase -- 
        generic map( -- 
          name => "phi_stmt_989",
          num_reqs => 2,
          bypass_flag => false,
          data_width => 64) -- 
        port map( -- 
          req => req, 
          ack => phi_stmt_989_ack_0,
          idata => idata,
          odata => indvar_989,
          clk => clk,
          reset => reset ); -- 
      -- 
    end Block; -- phi operator phi_stmt_989
    -- flow-through select operator MUX_306_inst
    umax3_307 <= shr_294 when (tmp_300(0) /=  '0') else type_cast_305_wire_constant;
    MUX_727_inst_block : block -- 
      signal sample_req, sample_ack, update_req, update_ack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      sample_req(0) <= MUX_727_inst_req_0;
      MUX_727_inst_ack_0<= sample_ack(0);
      update_req(0) <= MUX_727_inst_req_1;
      MUX_727_inst_ack_1<= update_ack(0);
      MUX_727_inst: SelectSplitProtocol generic map(name => "MUX_727_inst", data_width => 64, buffering => 1, flow_through => false, full_rate => true) -- 
        port map( x => type_cast_725_wire_constant, y => i1_706, sel => data_check_714_delayed_12_0_720, z => MUX_727_wire, sample_req => sample_req(0), sample_ack => sample_ack(0), update_req => update_req(0), update_ack => update_ack(0), clk => clk, reset => reset); -- 
      -- 
    end block;
    -- flow-through select operator MUX_796_inst
    next_k_loop_797 <= ADD_u16_u16_794_wire when (cmp_dim2_741(0) /=  '0') else konst_795_wire_constant;
    -- flow-through select operator MUX_806_inst
    MUX_806_wire <= j1_533 when (cmp_dim1_765(0) /=  '0') else ADD_u16_u16_805_wire;
    -- flow-through select operator MUX_807_inst
    next_j_loop_808 <= j_loop_573 when (cmp_dim2_741(0) /=  '0') else MUX_806_wire;
    -- flow-through select operator MUX_815_inst
    next_i_loop_816 <= ADD_u16_u16_813_wire when (cmp_dim1_765(0) /=  '0') else i_loop_577;
    W_data_check_714_delayed_12_0_718_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_data_check_714_delayed_12_0_718_inst_req_0;
      W_data_check_714_delayed_12_0_718_inst_ack_0<= wack(0);
      rreq(0) <= W_data_check_714_delayed_12_0_718_inst_req_1;
      W_data_check_714_delayed_12_0_718_inst_ack_1<= rack(0);
      W_data_check_714_delayed_12_0_718_inst : InterlockBuffer generic map ( -- 
        name => "W_data_check_714_delayed_12_0_718_inst",
        buffer_size => 12,
        flow_through =>  false ,
        cut_through =>  true ,
        in_data_width => 1,
        out_data_width => 1,
        bypass_flag =>  true 
        -- 
      )port map ( -- 
        write_req => wreq(0), 
        write_ack => wack(0), 
        write_data => data_check_684,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => data_check_714_delayed_12_0_720,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim0T_check_2_763_delayed_1_0_776_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim0T_check_2_763_delayed_1_0_776_inst_req_0;
      W_dim0T_check_2_763_delayed_1_0_776_inst_ack_0<= wack(0);
      rreq(0) <= W_dim0T_check_2_763_delayed_1_0_776_inst_req_1;
      W_dim0T_check_2_763_delayed_1_0_776_inst_ack_1<= rack(0);
      W_dim0T_check_2_763_delayed_1_0_776_inst : InterlockBuffer generic map ( -- 
        name => "W_dim0T_check_2_763_delayed_1_0_776_inst",
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
        write_data => dim0T_check_2_775,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim0T_check_2_763_delayed_1_0_778,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim1T_check_2_742_delayed_1_0_752_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim1T_check_2_742_delayed_1_0_752_inst_req_0;
      W_dim1T_check_2_742_delayed_1_0_752_inst_ack_0<= wack(0);
      rreq(0) <= W_dim1T_check_2_742_delayed_1_0_752_inst_req_1;
      W_dim1T_check_2_742_delayed_1_0_752_inst_ack_1<= rack(0);
      W_dim1T_check_2_742_delayed_1_0_752_inst : InterlockBuffer generic map ( -- 
        name => "W_dim1T_check_2_742_delayed_1_0_752_inst",
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
        write_data => dim1T_check_2_751,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim1T_check_2_742_delayed_1_0_754,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    W_dim2T_dif_727_delayed_1_0_734_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_dim2T_dif_727_delayed_1_0_734_inst_req_0;
      W_dim2T_dif_727_delayed_1_0_734_inst_ack_0<= wack(0);
      rreq(0) <= W_dim2T_dif_727_delayed_1_0_734_inst_req_1;
      W_dim2T_dif_727_delayed_1_0_734_inst_ack_1<= rack(0);
      W_dim2T_dif_727_delayed_1_0_734_inst : InterlockBuffer generic map ( -- 
        name => "W_dim2T_dif_727_delayed_1_0_734_inst",
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
        write_data => dim2T_dif_733,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => dim2T_dif_727_delayed_1_0_736,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock W_inp_d0_491_inst
    process(add23_86) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add23_86(15 downto 0);
      inp_d0_493 <= tmp_var; -- 
    end process;
    -- interlock W_inp_d1_494_inst
    process(add32_111) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add32_111(15 downto 0);
      inp_d1_496 <= tmp_var; -- 
    end process;
    -- interlock W_inp_d2_497_inst
    process(add41_136) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add41_136(15 downto 0);
      inp_d2_499 <= tmp_var; -- 
    end process;
    -- interlock W_out_d1_500_inst
    process(add68_211) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add68_211(15 downto 0);
      out_d1_502 <= tmp_var; -- 
    end process;
    -- interlock W_out_d2_503_inst
    process(add77_236) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add77_236(15 downto 0);
      out_d2_505 <= tmp_var; -- 
    end process;
    W_ov_712_delayed_7_0_715_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= W_ov_712_delayed_7_0_715_inst_req_0;
      W_ov_712_delayed_7_0_715_inst_ack_0<= wack(0);
      rreq(0) <= W_ov_712_delayed_7_0_715_inst_req_1;
      W_ov_712_delayed_7_0_715_inst_ack_1<= rack(0);
      W_ov_712_delayed_7_0_715_inst : InterlockBuffer generic map ( -- 
        name => "W_ov_712_delayed_7_0_715_inst",
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
        write_data => ov_714,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ov_712_delayed_7_0_717,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock W_pad_564_inst
    process(padding_508) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := padding_508(15 downto 0);
      pad_566 <= tmp_var; -- 
    end process;
    -- interlock W_padding_506_inst
    process(add50_161) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := add50_161(15 downto 0);
      padding_508 <= tmp_var; -- 
    end process;
    addr_of_1002_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_1002_final_reg_req_0;
      addr_of_1002_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_1002_final_reg_req_1;
      addr_of_1002_final_reg_ack_1<= rack(0);
      addr_of_1002_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_1002_final_reg",
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
        write_data => array_obj_ref_1001_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => arrayidx240_1003,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
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
    addr_of_701_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_701_final_reg_req_0;
      addr_of_701_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_701_final_reg_req_1;
      addr_of_701_final_reg_ack_1<= rack(0);
      addr_of_701_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_701_final_reg",
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
        write_data => array_obj_ref_700_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => iv1_702,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    addr_of_713_final_reg_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= addr_of_713_final_reg_req_0;
      addr_of_713_final_reg_ack_0<= wack(0);
      rreq(0) <= addr_of_713_final_reg_req_1;
      addr_of_713_final_reg_ack_1<= rack(0);
      addr_of_713_final_reg : InterlockBuffer generic map ( -- 
        name => "addr_of_713_final_reg",
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
        write_data => array_obj_ref_712_root_address,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => ov_714,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_dest_add_689_584_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_dest_add_689_584_buf_req_0;
      next_dest_add_689_584_buf_ack_0<= wack(0);
      rreq(0) <= next_dest_add_689_584_buf_req_1;
      next_dest_add_689_584_buf_ack_1<= rack(0);
      next_dest_add_689_584_buf : InterlockBuffer generic map ( -- 
        name => "next_dest_add_689_584_buf",
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
        write_data => next_dest_add_689,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_dest_add_689_584_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_i_loop_816_580_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_i_loop_816_580_buf_req_0;
      next_i_loop_816_580_buf_ack_0<= wack(0);
      rreq(0) <= next_i_loop_816_580_buf_req_1;
      next_i_loop_816_580_buf_ack_1<= rack(0);
      next_i_loop_816_580_buf : InterlockBuffer generic map ( -- 
        name => "next_i_loop_816_580_buf",
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
        write_data => next_i_loop_816,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_i_loop_816_580_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_j_loop_808_576_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_j_loop_808_576_buf_req_0;
      next_j_loop_808_576_buf_ack_0<= wack(0);
      rreq(0) <= next_j_loop_808_576_buf_req_1;
      next_j_loop_808_576_buf_ack_1<= rack(0);
      next_j_loop_808_576_buf : InterlockBuffer generic map ( -- 
        name => "next_j_loop_808_576_buf",
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
        write_data => next_j_loop_808,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_j_loop_808_576_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_k_loop_797_572_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_k_loop_797_572_buf_req_0;
      next_k_loop_797_572_buf_ack_0<= wack(0);
      rreq(0) <= next_k_loop_797_572_buf_req_1;
      next_k_loop_797_572_buf_ack_1<= rack(0);
      next_k_loop_797_572_buf : InterlockBuffer generic map ( -- 
        name => "next_k_loop_797_572_buf",
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
        write_data => next_k_loop_797,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_k_loop_797_572_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    next_src_add_694_588_buf_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= next_src_add_694_588_buf_req_0;
      next_src_add_694_588_buf_ack_0<= wack(0);
      rreq(0) <= next_src_add_694_588_buf_req_1;
      next_src_add_694_588_buf_ack_1<= rack(0);
      next_src_add_694_588_buf : InterlockBuffer generic map ( -- 
        name => "next_src_add_694_588_buf",
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
        write_data => next_src_add_694,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => next_src_add_694_588_buffered,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1010_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1010_inst_req_0;
      type_cast_1010_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1010_inst_req_1;
      type_cast_1010_inst_ack_1<= rack(0);
      type_cast_1010_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1010_inst",
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
        write_data => tmp241_1007,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv245_1011,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1020_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1020_inst_req_0;
      type_cast_1020_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1020_inst_req_1;
      type_cast_1020_inst_ack_1<= rack(0);
      type_cast_1020_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1020_inst",
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
        write_data => shr248_1017,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv251_1021,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1030_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1030_inst_req_0;
      type_cast_1030_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1030_inst_req_1;
      type_cast_1030_inst_ack_1<= rack(0);
      type_cast_1030_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1030_inst",
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
        write_data => shr254_1027,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv257_1031,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1040_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1040_inst_req_0;
      type_cast_1040_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1040_inst_req_1;
      type_cast_1040_inst_ack_1<= rack(0);
      type_cast_1040_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1040_inst",
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
        write_data => shr260_1037,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv263_1041,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1050_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1050_inst_req_0;
      type_cast_1050_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1050_inst_req_1;
      type_cast_1050_inst_ack_1<= rack(0);
      type_cast_1050_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1050_inst",
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
        write_data => shr266_1047,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv269_1051,
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
    type_cast_1060_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1060_inst_req_0;
      type_cast_1060_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1060_inst_req_1;
      type_cast_1060_inst_ack_1<= rack(0);
      type_cast_1060_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1060_inst",
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
        write_data => shr272_1057,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv275_1061,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1070_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1070_inst_req_0;
      type_cast_1070_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1070_inst_req_1;
      type_cast_1070_inst_ack_1<= rack(0);
      type_cast_1070_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1070_inst",
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
        write_data => shr278_1067,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv281_1071,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_1080_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_1080_inst_req_0;
      type_cast_1080_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_1080_inst_req_1;
      type_cast_1080_inst_ack_1<= rack(0);
      type_cast_1080_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_1080_inst",
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
        write_data => shr284_1077,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv287_1081,
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
    -- interlock type_cast_536_inst
    process(inp_d0_493) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d0_493(15 downto 0);
      dim0T_537 <= tmp_var; -- 
    end process;
    -- interlock type_cast_540_inst
    process(inp_d1_496) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d1_496(15 downto 0);
      dim1T_541 <= tmp_var; -- 
    end process;
    -- interlock type_cast_544_inst
    process(inp_d2_499) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := inp_d2_499(15 downto 0);
      dim2T_545 <= tmp_var; -- 
    end process;
    -- interlock type_cast_548_inst
    process(out_d1_502) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := out_d1_502(15 downto 0);
      dim1R_549 <= tmp_var; -- 
    end process;
    -- interlock type_cast_552_inst
    process(out_d2_505) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := out_d2_505(15 downto 0);
      dim2R_553 <= tmp_var; -- 
    end process;
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
    -- interlock type_cast_699_inst
    process(src_add_585) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := src_add_585(15 downto 0);
      type_cast_699_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_711_inst
    process(dest_add_581) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 15 downto 0) := dest_add_581(15 downto 0);
      type_cast_711_wire <= tmp_var; -- 
    end process;
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
    type_cast_829_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_829_inst_req_0;
      type_cast_829_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_829_inst_req_1;
      type_cast_829_inst_ack_1<= rack(0);
      type_cast_829_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_829_inst",
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
        write_data => type_cast_828_wire,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv154_830,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_839_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_839_inst_req_0;
      type_cast_839_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_839_inst_req_1;
      type_cast_839_inst_ack_1<= rack(0);
      type_cast_839_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_839_inst",
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
        write_data => sub_835,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv160_840,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_849_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_849_inst_req_0;
      type_cast_849_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_849_inst_req_1;
      type_cast_849_inst_ack_1<= rack(0);
      type_cast_849_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_849_inst",
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
        write_data => shr163_846,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv166_850,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_859_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_859_inst_req_0;
      type_cast_859_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_859_inst_req_1;
      type_cast_859_inst_ack_1<= rack(0);
      type_cast_859_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_859_inst",
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
        write_data => shr169_856,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv172_860,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_869_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_869_inst_req_0;
      type_cast_869_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_869_inst_req_1;
      type_cast_869_inst_ack_1<= rack(0);
      type_cast_869_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_869_inst",
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
        write_data => shr175_866,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv178_870,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_879_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_879_inst_req_0;
      type_cast_879_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_879_inst_req_1;
      type_cast_879_inst_ack_1<= rack(0);
      type_cast_879_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_879_inst",
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
        write_data => shr181_876,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv184_880,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_889_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_889_inst_req_0;
      type_cast_889_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_889_inst_req_1;
      type_cast_889_inst_ack_1<= rack(0);
      type_cast_889_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_889_inst",
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
        write_data => shr187_886,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv190_890,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_899_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_899_inst_req_0;
      type_cast_899_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_899_inst_req_1;
      type_cast_899_inst_ack_1<= rack(0);
      type_cast_899_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_899_inst",
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
        write_data => shr193_896,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv196_900,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_909_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_909_inst_req_0;
      type_cast_909_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_909_inst_req_1;
      type_cast_909_inst_ack_1<= rack(0);
      type_cast_909_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_909_inst",
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
        write_data => shr199_906,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => conv202_910,
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
    type_cast_938_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_938_inst_req_0;
      type_cast_938_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_938_inst_req_1;
      type_cast_938_inst_ack_1<= rack(0);
      type_cast_938_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_938_inst",
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
        read_data => conv222_939,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_942_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_942_inst_req_0;
      type_cast_942_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_942_inst_req_1;
      type_cast_942_inst_ack_1<= rack(0);
      type_cast_942_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_942_inst",
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
        read_data => conv224_943,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_946_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_946_inst_req_0;
      type_cast_946_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_946_inst_req_1;
      type_cast_946_inst_ack_1<= rack(0);
      type_cast_946_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_946_inst",
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
        read_data => conv227_947,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- interlock type_cast_961_inst
    process(mul228_957) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := mul228_957(31 downto 0);
      type_cast_961_wire <= tmp_var; -- 
    end process;
    -- interlock type_cast_966_inst
    process(ASHR_i32_i32_965_wire) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := ASHR_i32_i32_965_wire(31 downto 0);
      shr232309_967 <= tmp_var; -- 
    end process;
    -- interlock type_cast_970_inst
    process(shr232309_967) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      tmp_var := (others => '0'); 
      tmp_var( 31 downto 0) := shr232309_967(31 downto 0);
      type_cast_970_wire <= tmp_var; -- 
    end process;
    type_cast_985_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_985_inst_req_0;
      type_cast_985_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_985_inst_req_1;
      type_cast_985_inst_ack_1<= rack(0);
      type_cast_985_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_985_inst",
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
        write_data => shr232309_967,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => tmp1_986,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    type_cast_995_inst_block: block -- 
      signal wreq, wack, rreq, rack: BooleanArray(0 downto 0); 
      -- 
    begin -- 
      wreq(0) <= type_cast_995_inst_req_0;
      type_cast_995_inst_ack_0<= wack(0);
      rreq(0) <= type_cast_995_inst_req_1;
      type_cast_995_inst_ack_1<= rack(0);
      type_cast_995_inst : InterlockBuffer generic map ( -- 
        name => "type_cast_995_inst",
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
        write_data => indvarx_xnext_1111,
        read_req => rreq(0),  
        read_ack => rack(0), 
        read_data => type_cast_995_wire,
        clk => clk, reset => reset
        -- 
      );
      end block; -- 
    -- equivalence array_obj_ref_1001_index_1_rename
    process(R_indvar_1000_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := R_indvar_1000_resized;
      ov(13 downto 0) := iv;
      R_indvar_1000_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1001_index_1_resize
    process(indvar_989) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := indvar_989;
      ov := iv(13 downto 0);
      R_indvar_1000_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_1001_root_address_inst
    process(array_obj_ref_1001_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_1001_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_1001_root_address <= ov(13 downto 0);
      --
    end process;
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
    -- equivalence array_obj_ref_700_index_1_rename
    process(type_cast_699_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_699_resized;
      ov(13 downto 0) := iv;
      type_cast_699_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_700_index_1_resize
    process(type_cast_699_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_699_wire;
      ov := iv(13 downto 0);
      type_cast_699_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_700_root_address_inst
    process(array_obj_ref_700_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_700_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_700_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_712_index_1_rename
    process(type_cast_711_resized) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_711_resized;
      ov(13 downto 0) := iv;
      type_cast_711_scaled <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_712_index_1_resize
    process(type_cast_711_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := type_cast_711_wire;
      ov := iv(13 downto 0);
      type_cast_711_resized <= ov(13 downto 0);
      --
    end process;
    -- equivalence array_obj_ref_712_root_address_inst
    process(array_obj_ref_712_final_offset) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := array_obj_ref_712_final_offset;
      ov(13 downto 0) := iv;
      array_obj_ref_712_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1006_addr_0
    process(ptr_deref_1006_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1006_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_1006_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1006_base_resize
    process(arrayidx240_1003) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := arrayidx240_1003;
      ov := iv(13 downto 0);
      ptr_deref_1006_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1006_gather_scatter
    process(ptr_deref_1006_data_0) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1006_data_0;
      ov(63 downto 0) := iv;
      tmp241_1007 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_1006_root_address_inst
    process(ptr_deref_1006_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_1006_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_1006_root_address <= ov(13 downto 0);
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
    -- equivalence ptr_deref_705_addr_0
    process(ptr_deref_705_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_705_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_705_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_705_base_resize
    process(iv1_702) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := iv1_702;
      ov := iv(13 downto 0);
      ptr_deref_705_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_705_gather_scatter
    process(ptr_deref_705_data_0) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_705_data_0;
      ov(63 downto 0) := iv;
      i1_706 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_705_root_address_inst
    process(ptr_deref_705_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_705_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_705_root_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_722_addr_0
    process(ptr_deref_722_root_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_722_root_address;
      ov(13 downto 0) := iv;
      ptr_deref_722_word_address_0 <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_722_base_resize
    process(ov_712_delayed_7_0_717) --
      variable iv : std_logic_vector(31 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ov_712_delayed_7_0_717;
      ov := iv(13 downto 0);
      ptr_deref_722_resized_base_address <= ov(13 downto 0);
      --
    end process;
    -- equivalence ptr_deref_722_gather_scatter
    process(MUX_727_wire) --
      variable iv : std_logic_vector(63 downto 0);
      variable ov : std_logic_vector(63 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := MUX_727_wire;
      ov(63 downto 0) := iv;
      ptr_deref_722_data_0 <= ov(63 downto 0);
      --
    end process;
    -- equivalence ptr_deref_722_root_address_inst
    process(ptr_deref_722_resized_base_address) --
      variable iv : std_logic_vector(13 downto 0);
      variable ov : std_logic_vector(13 downto 0);
      -- 
    begin -- 
      ov := (others => '0');
      iv := ptr_deref_722_resized_base_address;
      ov(13 downto 0) := iv;
      ptr_deref_722_root_address <= ov(13 downto 0);
      --
    end process;
    do_while_stmt_567_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= flag_820;
      branch_instance: BranchBase -- 
        generic map( name => "do_while_stmt_567_branch", condition_width => 1,  bypass_flag => true)
        port map( -- 
          condition => condition_sig,
          req => do_while_stmt_567_branch_req_0,
          ack0 => do_while_stmt_567_branch_ack_0,
          ack1 => do_while_stmt_567_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    if_stmt_1117_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= exitcond2_1116;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_1117_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_1117_branch_req_0,
          ack0 => if_stmt_1117_branch_ack_0,
          ack1 => if_stmt_1117_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
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
    if_stmt_976_branch: Block -- 
      -- branch-block
      signal condition_sig : std_logic_vector(0 downto 0);
      begin 
      condition_sig <= cmp233310_975;
      branch_instance: BranchBase -- 
        generic map( name => "if_stmt_976_branch", condition_width => 1,  bypass_flag => false)
        port map( -- 
          condition => condition_sig,
          req => if_stmt_976_branch_req_0,
          ack0 => if_stmt_976_branch_ack_0,
          ack1 => if_stmt_976_branch_ack_1,
          clk => clk,
          reset => reset); -- 
      --
    end Block; -- branch-block
    -- binary operator ADD_u16_u16_603_inst
    process(dest_data_array_idx_1_594, dest_data_array_idx_2_599) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dest_data_array_idx_1_594, dest_data_array_idx_2_599, tmp_var);
      dest_data_array_idx_3_604 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_608_inst
    process(dest_data_array_idx_3_604, k_loop_569) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dest_data_array_idx_3_604, k_loop_569, tmp_var);
      dest_data_array_idx_4_609 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_633_inst
    process(img_data_array_idx_3_624, img_data_array_idx_4_629) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(img_data_array_idx_3_624, img_data_array_idx_4_629, tmp_var);
      img_data_array_idx_5_634 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_638_inst
    process(img_data_array_idx_5_634, k_loop_569) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(img_data_array_idx_5_634, k_loop_569, tmp_var);
      img_data_array_idx_6_639 <= tmp_var; --
    end process;
    -- shared split operator group (4) : ADD_u16_u16_653_inst 
    ApIntAdd_group_4: Block -- 
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
      data_in <= inp_d0_493 & pad_566;
      ADD_u16_u16_657_657_delayed_1_0_654 <= data_out(15 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= ADD_u16_u16_653_inst_req_0;
      ADD_u16_u16_653_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ADD_u16_u16_653_inst_req_1;
      ADD_u16_u16_653_inst_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_4_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_4_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_4",
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
    end Block; -- split operator group 4
    -- shared split operator group (5) : ADD_u16_u16_663_inst 
    ApIntAdd_group_5: Block -- 
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
      data_in <= inp_d1_496 & pad_566;
      ADD_u16_u16_664_664_delayed_1_0_664 <= data_out(15 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= ADD_u16_u16_663_inst_req_0;
      ADD_u16_u16_663_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ADD_u16_u16_663_inst_req_1;
      ADD_u16_u16_663_inst_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_5_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_5_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_5",
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
    end Block; -- split operator group 5
    -- binary operator ADD_u16_u16_750_inst
    process(dim1T_541, dim1T_check_1_746) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dim1T_541, dim1T_check_1_746, tmp_var);
      dim1T_check_2_751 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_774_inst
    process(dim0T_537, dim0T_check_1_770) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(dim0T_537, dim0T_check_1_770, tmp_var);
      dim0T_check_2_775 <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_794_inst
    process(k_loop_569) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(k_loop_569, konst_793_wire_constant, tmp_var);
      ADD_u16_u16_794_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_805_inst
    process(j_loop_573) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(j_loop_573, konst_804_wire_constant, tmp_var);
      ADD_u16_u16_805_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u16_u16_813_inst
    process(i_loop_577) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntAdd_proc(i_loop_577, konst_812_wire_constant, tmp_var);
      ADD_u16_u16_813_wire <= tmp_var; --
    end process;
    -- binary operator ADD_u64_u64_1110_inst
    process(indvar_989) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntAdd_proc(indvar_989, type_cast_1109_wire_constant, tmp_var);
      indvarx_xnext_1111 <= tmp_var; --
    end process;
    -- binary operator ADD_u64_u64_466_inst
    process(indvar317_310) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntAdd_proc(indvar317_310, type_cast_465_wire_constant, tmp_var);
      indvarx_xnext318_467 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_764_inst
    process(NOT_u1_u1_762_wire, dim1T_check_3_759) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NOT_u1_u1_762_wire, dim1T_check_3_759, tmp_var);
      cmp_dim1_765 <= tmp_var; --
    end process;
    -- binary operator AND_u1_u1_788_inst
    process(NOT_u1_u1_786_wire, dim0T_check_3_783) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntAnd_proc(NOT_u1_u1_786_wire, dim0T_check_3_783, tmp_var);
      cmp_dim0_789 <= tmp_var; --
    end process;
    -- binary operator ASHR_i32_i32_965_inst
    process(type_cast_961_wire) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntASHR_proc(type_cast_961_wire, type_cast_964_wire_constant, tmp_var);
      ASHR_i32_i32_965_wire <= tmp_var; --
    end process;
    -- binary operator ASHR_i64_i64_272_inst
    process(type_cast_268_wire) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntASHR_proc(type_cast_268_wire, type_cast_271_wire_constant, tmp_var);
      ASHR_i64_i64_272_wire <= tmp_var; --
    end process;
    -- binary operator EQ_u16_u1_758_inst
    process(j_loop_573, dim1T_check_2_742_delayed_1_0_754) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(j_loop_573, dim1T_check_2_742_delayed_1_0_754, tmp_var);
      dim1T_check_3_759 <= tmp_var; --
    end process;
    -- binary operator EQ_u16_u1_782_inst
    process(i_loop_577, dim0T_check_2_763_delayed_1_0_778) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(i_loop_577, dim0T_check_2_763_delayed_1_0_778, tmp_var);
      dim0T_check_3_783 <= tmp_var; --
    end process;
    -- binary operator EQ_u64_u1_1115_inst
    process(indvarx_xnext_1111, tmp1_986) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(indvarx_xnext_1111, tmp1_986, tmp_var);
      exitcond2_1116 <= tmp_var; --
    end process;
    -- binary operator EQ_u64_u1_471_inst
    process(indvarx_xnext318_467, umax3_307) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntEq_proc(indvarx_xnext318_467, umax3_307, tmp_var);
      exitcond_472 <= tmp_var; --
    end process;
    -- binary operator LSHR_u16_u16_688_inst
    process(dest_data_array_idx_4_609) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(dest_data_array_idx_4_609, konst_687_wire_constant, tmp_var);
      next_dest_add_689 <= tmp_var; --
    end process;
    -- binary operator LSHR_u16_u16_693_inst
    process(img_data_array_idx_6_639) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(img_data_array_idx_6_639, konst_692_wire_constant, tmp_var);
      next_src_add_694 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1016_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1015_wire_constant, tmp_var);
      shr248_1017 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1026_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1025_wire_constant, tmp_var);
      shr254_1027 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1036_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1035_wire_constant, tmp_var);
      shr260_1037 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1046_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1045_wire_constant, tmp_var);
      shr266_1047 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1056_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1055_wire_constant, tmp_var);
      shr272_1057 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1066_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1065_wire_constant, tmp_var);
      shr278_1067 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_1076_inst
    process(tmp241_1007) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(tmp241_1007, type_cast_1075_wire_constant, tmp_var);
      shr284_1077 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_293_inst
    process(conv87_274) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(conv87_274, type_cast_292_wire_constant, tmp_var);
      shr_294 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_845_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_844_wire_constant, tmp_var);
      shr163_846 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_855_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_854_wire_constant, tmp_var);
      shr169_856 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_865_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_864_wire_constant, tmp_var);
      shr175_866 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_875_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_874_wire_constant, tmp_var);
      shr181_876 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_885_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_884_wire_constant, tmp_var);
      shr187_886 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_895_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_894_wire_constant, tmp_var);
      shr193_896 <= tmp_var; --
    end process;
    -- binary operator LSHR_u64_u64_905_inst
    process(sub_835) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntLSHR_proc(sub_835, type_cast_904_wire_constant, tmp_var);
      shr199_906 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_557_inst
    process(dim2T_545, dim1T_541) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2T_545, dim1T_541, tmp_var);
      dim21T_558 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_562_inst
    process(dim2R_553, dim1R_549) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2R_553, dim1R_549, tmp_var);
      dim21R_563 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_593_inst
    process(dim2R_553, j_loop_573) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2R_553, j_loop_573, tmp_var);
      dest_data_array_idx_1_594 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_598_inst
    process(dim21R_563, i_loop_577) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim21R_563, i_loop_577, tmp_var);
      dest_data_array_idx_2_599 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_623_inst
    process(dim2T_545, img_data_array_idx_1_614) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim2T_545, img_data_array_idx_1_614, tmp_var);
      img_data_array_idx_3_624 <= tmp_var; --
    end process;
    -- binary operator MUL_u16_u16_628_inst
    process(dim21T_558, img_data_array_idx_2_619) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntMul_proc(dim21T_558, img_data_array_idx_2_619, tmp_var);
      img_data_array_idx_4_629 <= tmp_var; --
    end process;
    -- binary operator MUL_u32_u32_951_inst
    process(conv224_943, conv222_939) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntMul_proc(conv224_943, conv222_939, tmp_var);
      mul225_952 <= tmp_var; --
    end process;
    -- binary operator MUL_u32_u32_956_inst
    process(mul225_952, conv227_947) -- 
      variable tmp_var : std_logic_vector(31 downto 0); -- 
    begin -- 
      ApIntMul_proc(mul225_952, conv227_947, tmp_var);
      mul228_957 <= tmp_var; --
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
    -- unary operator NOT_u1_u1_762_inst
    process(cmp_dim2_741) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim2_741, tmp_var);
      NOT_u1_u1_762_wire <= tmp_var; -- 
    end process;
    -- unary operator NOT_u1_u1_786_inst
    process(cmp_dim2_741) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim2_741, tmp_var);
      NOT_u1_u1_786_wire <= tmp_var; -- 
    end process;
    -- unary operator NOT_u1_u1_819_inst
    process(cmp_dim0_789) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntNot", cmp_dim0_789, tmp_var);
      flag_820 <= tmp_var; -- 
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
    -- binary operator OR_u1_u1_673_inst
    process(i_small_check_644, j_small_check_649) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(i_small_check_644, j_small_check_649, tmp_var);
      data_check1_674 <= tmp_var; --
    end process;
    -- binary operator OR_u1_u1_678_inst
    process(data_check1_674, i_large_check_659) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(data_check1_674, i_large_check_659, tmp_var);
      data_check2_679 <= tmp_var; --
    end process;
    -- binary operator OR_u1_u1_683_inst
    process(data_check2_679, j_large_check_669) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntOr_proc(data_check2_679, j_large_check_669, tmp_var);
      data_check_684 <= tmp_var; --
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
    -- binary operator SGT_i32_u1_974_inst
    process(type_cast_970_wire) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntSgt_proc(type_cast_970_wire, type_cast_973_wire_constant, tmp_var);
      cmp233310_975 <= tmp_var; --
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
    -- binary operator SHL_u16_u16_745_inst
    process(pad_566) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(pad_566, konst_744_wire_constant, tmp_var);
      dim1T_check_1_746 <= tmp_var; --
    end process;
    -- binary operator SHL_u16_u16_769_inst
    process(pad_566) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSHL_proc(pad_566, konst_768_wire_constant, tmp_var);
      dim0T_check_1_770 <= tmp_var; --
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
    -- binary operator SUB_u16_u16_613_inst
    process(j_loop_573, pad_566) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(j_loop_573, pad_566, tmp_var);
      img_data_array_idx_1_614 <= tmp_var; --
    end process;
    -- binary operator SUB_u16_u16_618_inst
    process(i_loop_577, pad_566) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(i_loop_577, pad_566, tmp_var);
      img_data_array_idx_2_619 <= tmp_var; --
    end process;
    -- binary operator SUB_u16_u16_732_inst
    process(dim2T_545) -- 
      variable tmp_var : std_logic_vector(15 downto 0); -- 
    begin -- 
      ApIntSub_proc(dim2T_545, konst_731_wire_constant, tmp_var);
      dim2T_dif_733 <= tmp_var; --
    end process;
    -- binary operator SUB_u64_u64_834_inst
    process(conv154_830, conv142_489) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      ApIntSub_proc(conv154_830, conv142_489, tmp_var);
      sub_835 <= tmp_var; --
    end process;
    -- binary operator UGE_u16_u1_658_inst
    process(i_loop_577, ADD_u16_u16_657_657_delayed_1_0_654) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUge_proc(i_loop_577, ADD_u16_u16_657_657_delayed_1_0_654, tmp_var);
      i_large_check_659 <= tmp_var; --
    end process;
    -- binary operator UGE_u16_u1_668_inst
    process(j_loop_573, ADD_u16_u16_664_664_delayed_1_0_664) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUge_proc(j_loop_573, ADD_u16_u16_664_664_delayed_1_0_664, tmp_var);
      j_large_check_669 <= tmp_var; --
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
    -- binary operator ULE_u16_u1_740_inst
    process(k_loop_569, dim2T_dif_727_delayed_1_0_736) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUle_proc(k_loop_569, dim2T_dif_727_delayed_1_0_736, tmp_var);
      cmp_dim2_741 <= tmp_var; --
    end process;
    -- binary operator ULT_u16_u1_643_inst
    process(i_loop_577, pad_566) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUlt_proc(i_loop_577, pad_566, tmp_var);
      i_small_check_644 <= tmp_var; --
    end process;
    -- binary operator ULT_u16_u1_648_inst
    process(j_loop_573, pad_566) -- 
      variable tmp_var : std_logic_vector(0 downto 0); -- 
    begin -- 
      ApIntUlt_proc(j_loop_573, pad_566, tmp_var);
      j_small_check_649 <= tmp_var; --
    end process;
    -- shared split operator group (97) : array_obj_ref_1001_index_offset 
    ApIntAdd_group_97: Block -- 
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
      data_in <= R_indvar_1000_scaled;
      array_obj_ref_1001_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_1001_index_offset_req_0;
      array_obj_ref_1001_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_1001_index_offset_req_1;
      array_obj_ref_1001_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_97_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_97_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_97",
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
    end Block; -- split operator group 97
    -- shared split operator group (98) : array_obj_ref_322_index_offset 
    ApIntAdd_group_98: Block -- 
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
      ApIntAdd_group_98_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_98_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_98",
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
    end Block; -- split operator group 98
    -- shared split operator group (99) : array_obj_ref_700_index_offset 
    ApIntAdd_group_99: Block -- 
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
      data_in <= type_cast_699_scaled;
      array_obj_ref_700_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_700_index_offset_req_0;
      array_obj_ref_700_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_700_index_offset_req_1;
      array_obj_ref_700_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_99_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_99_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_99",
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
    end Block; -- split operator group 99
    -- shared split operator group (100) : array_obj_ref_712_index_offset 
    ApIntAdd_group_100: Block -- 
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
      data_in <= type_cast_711_scaled;
      array_obj_ref_712_final_offset <= data_out(13 downto 0);
      guard_vector(0)  <=  '1';
      reqL_unguarded(0) <= array_obj_ref_712_index_offset_req_0;
      array_obj_ref_712_index_offset_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= array_obj_ref_712_index_offset_req_1;
      array_obj_ref_712_index_offset_ack_1 <= ackR_unguarded(0);
      ApIntAdd_group_100_gI: SplitGuardInterface generic map(name => "ApIntAdd_group_100_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
          name => "ApIntAdd_group_100",
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
    end Block; -- split operator group 100
    -- unary operator type_cast_487_inst
    process(call141_484) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntToApIntSigned", call141_484, tmp_var);
      type_cast_487_wire <= tmp_var; -- 
    end process;
    -- unary operator type_cast_828_inst
    process(call153_825) -- 
      variable tmp_var : std_logic_vector(63 downto 0); -- 
    begin -- 
      SingleInputOperation("ApIntToApIntSigned", call153_825, tmp_var);
      type_cast_828_wire <= tmp_var; -- 
    end process;
    -- shared load operator group (0) : ptr_deref_1006_load_0 
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
      reqL_unguarded(0) <= ptr_deref_1006_load_0_req_0;
      ptr_deref_1006_load_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_1006_load_0_req_1;
      ptr_deref_1006_load_0_ack_1 <= ackR_unguarded(0);
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
      data_in <= ptr_deref_1006_word_address_0;
      ptr_deref_1006_data_0 <= data_out(63 downto 0);
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
    -- shared load operator group (1) : ptr_deref_705_load_0 
    LoadGroup1: Block -- 
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
      reqL_unguarded(0) <= ptr_deref_705_load_0_req_0;
      ptr_deref_705_load_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_705_load_0_req_1;
      ptr_deref_705_load_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      LoadGroup1_gI: SplitGuardInterface generic map(name => "LoadGroup1_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      data_in <= ptr_deref_705_word_address_0;
      ptr_deref_705_data_0 <= data_out(63 downto 0);
      LoadReq: LoadReqSharedWithInputBuffers -- 
        generic map ( name => "LoadGroup1", addr_width => 14,
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
        generic map ( name => "LoadGroup1 load-complete ",
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
    end Block; -- load group 1
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
    -- shared store operator group (1) : ptr_deref_722_store_0 
    StoreGroup1: Block -- 
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
      reqL_unguarded(0) <= ptr_deref_722_store_0_req_0;
      ptr_deref_722_store_0_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(0) <= ptr_deref_722_store_0_req_1;
      ptr_deref_722_store_0_ack_1 <= ackR_unguarded(0);
      guard_vector(0)  <=  '1';
      reqL <= reqL_unregulated;
      ackL_unregulated <= ackL;
      StoreGroup1_gI: SplitGuardInterface generic map(name => "StoreGroup1_gI", nreqs => 1, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => false) -- 
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
      addr_in <= ptr_deref_722_word_address_0;
      data_in <= ptr_deref_722_data_0;
      StoreReq: StoreReqSharedWithInputBuffers -- 
        generic map ( name => "StoreGroup1 Req ", addr_width => 14,
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
          name => "StoreGroup1 Complete ",
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
    end Block; -- store group 1
    -- shared inport operator group (0) : RPIPE_zeropad_input_pipe_60_inst RPIPE_zeropad_input_pipe_88_inst RPIPE_zeropad_input_pipe_76_inst RPIPE_zeropad_input_pipe_63_inst RPIPE_zeropad_input_pipe_54_inst RPIPE_zeropad_input_pipe_57_inst RPIPE_zeropad_input_pipe_201_inst RPIPE_zeropad_input_pipe_101_inst RPIPE_zeropad_input_pipe_113_inst RPIPE_zeropad_input_pipe_126_inst RPIPE_zeropad_input_pipe_138_inst RPIPE_zeropad_input_pipe_326_inst RPIPE_zeropad_input_pipe_213_inst RPIPE_zeropad_input_pipe_151_inst RPIPE_zeropad_input_pipe_163_inst RPIPE_zeropad_input_pipe_176_inst RPIPE_zeropad_input_pipe_188_inst RPIPE_zeropad_input_pipe_51_inst RPIPE_zeropad_input_pipe_226_inst RPIPE_zeropad_input_pipe_339_inst RPIPE_zeropad_input_pipe_357_inst RPIPE_zeropad_input_pipe_375_inst RPIPE_zeropad_input_pipe_393_inst RPIPE_zeropad_input_pipe_411_inst RPIPE_zeropad_input_pipe_429_inst RPIPE_zeropad_input_pipe_447_inst 
    InportGroup_0: Block -- 
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
      reqL_unguarded(25) <= RPIPE_zeropad_input_pipe_60_inst_req_0;
      reqL_unguarded(24) <= RPIPE_zeropad_input_pipe_88_inst_req_0;
      reqL_unguarded(23) <= RPIPE_zeropad_input_pipe_76_inst_req_0;
      reqL_unguarded(22) <= RPIPE_zeropad_input_pipe_63_inst_req_0;
      reqL_unguarded(21) <= RPIPE_zeropad_input_pipe_54_inst_req_0;
      reqL_unguarded(20) <= RPIPE_zeropad_input_pipe_57_inst_req_0;
      reqL_unguarded(19) <= RPIPE_zeropad_input_pipe_201_inst_req_0;
      reqL_unguarded(18) <= RPIPE_zeropad_input_pipe_101_inst_req_0;
      reqL_unguarded(17) <= RPIPE_zeropad_input_pipe_113_inst_req_0;
      reqL_unguarded(16) <= RPIPE_zeropad_input_pipe_126_inst_req_0;
      reqL_unguarded(15) <= RPIPE_zeropad_input_pipe_138_inst_req_0;
      reqL_unguarded(14) <= RPIPE_zeropad_input_pipe_326_inst_req_0;
      reqL_unguarded(13) <= RPIPE_zeropad_input_pipe_213_inst_req_0;
      reqL_unguarded(12) <= RPIPE_zeropad_input_pipe_151_inst_req_0;
      reqL_unguarded(11) <= RPIPE_zeropad_input_pipe_163_inst_req_0;
      reqL_unguarded(10) <= RPIPE_zeropad_input_pipe_176_inst_req_0;
      reqL_unguarded(9) <= RPIPE_zeropad_input_pipe_188_inst_req_0;
      reqL_unguarded(8) <= RPIPE_zeropad_input_pipe_51_inst_req_0;
      reqL_unguarded(7) <= RPIPE_zeropad_input_pipe_226_inst_req_0;
      reqL_unguarded(6) <= RPIPE_zeropad_input_pipe_339_inst_req_0;
      reqL_unguarded(5) <= RPIPE_zeropad_input_pipe_357_inst_req_0;
      reqL_unguarded(4) <= RPIPE_zeropad_input_pipe_375_inst_req_0;
      reqL_unguarded(3) <= RPIPE_zeropad_input_pipe_393_inst_req_0;
      reqL_unguarded(2) <= RPIPE_zeropad_input_pipe_411_inst_req_0;
      reqL_unguarded(1) <= RPIPE_zeropad_input_pipe_429_inst_req_0;
      reqL_unguarded(0) <= RPIPE_zeropad_input_pipe_447_inst_req_0;
      RPIPE_zeropad_input_pipe_60_inst_ack_0 <= ackL_unguarded(25);
      RPIPE_zeropad_input_pipe_88_inst_ack_0 <= ackL_unguarded(24);
      RPIPE_zeropad_input_pipe_76_inst_ack_0 <= ackL_unguarded(23);
      RPIPE_zeropad_input_pipe_63_inst_ack_0 <= ackL_unguarded(22);
      RPIPE_zeropad_input_pipe_54_inst_ack_0 <= ackL_unguarded(21);
      RPIPE_zeropad_input_pipe_57_inst_ack_0 <= ackL_unguarded(20);
      RPIPE_zeropad_input_pipe_201_inst_ack_0 <= ackL_unguarded(19);
      RPIPE_zeropad_input_pipe_101_inst_ack_0 <= ackL_unguarded(18);
      RPIPE_zeropad_input_pipe_113_inst_ack_0 <= ackL_unguarded(17);
      RPIPE_zeropad_input_pipe_126_inst_ack_0 <= ackL_unguarded(16);
      RPIPE_zeropad_input_pipe_138_inst_ack_0 <= ackL_unguarded(15);
      RPIPE_zeropad_input_pipe_326_inst_ack_0 <= ackL_unguarded(14);
      RPIPE_zeropad_input_pipe_213_inst_ack_0 <= ackL_unguarded(13);
      RPIPE_zeropad_input_pipe_151_inst_ack_0 <= ackL_unguarded(12);
      RPIPE_zeropad_input_pipe_163_inst_ack_0 <= ackL_unguarded(11);
      RPIPE_zeropad_input_pipe_176_inst_ack_0 <= ackL_unguarded(10);
      RPIPE_zeropad_input_pipe_188_inst_ack_0 <= ackL_unguarded(9);
      RPIPE_zeropad_input_pipe_51_inst_ack_0 <= ackL_unguarded(8);
      RPIPE_zeropad_input_pipe_226_inst_ack_0 <= ackL_unguarded(7);
      RPIPE_zeropad_input_pipe_339_inst_ack_0 <= ackL_unguarded(6);
      RPIPE_zeropad_input_pipe_357_inst_ack_0 <= ackL_unguarded(5);
      RPIPE_zeropad_input_pipe_375_inst_ack_0 <= ackL_unguarded(4);
      RPIPE_zeropad_input_pipe_393_inst_ack_0 <= ackL_unguarded(3);
      RPIPE_zeropad_input_pipe_411_inst_ack_0 <= ackL_unguarded(2);
      RPIPE_zeropad_input_pipe_429_inst_ack_0 <= ackL_unguarded(1);
      RPIPE_zeropad_input_pipe_447_inst_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(25) <= RPIPE_zeropad_input_pipe_60_inst_req_1;
      reqR_unguarded(24) <= RPIPE_zeropad_input_pipe_88_inst_req_1;
      reqR_unguarded(23) <= RPIPE_zeropad_input_pipe_76_inst_req_1;
      reqR_unguarded(22) <= RPIPE_zeropad_input_pipe_63_inst_req_1;
      reqR_unguarded(21) <= RPIPE_zeropad_input_pipe_54_inst_req_1;
      reqR_unguarded(20) <= RPIPE_zeropad_input_pipe_57_inst_req_1;
      reqR_unguarded(19) <= RPIPE_zeropad_input_pipe_201_inst_req_1;
      reqR_unguarded(18) <= RPIPE_zeropad_input_pipe_101_inst_req_1;
      reqR_unguarded(17) <= RPIPE_zeropad_input_pipe_113_inst_req_1;
      reqR_unguarded(16) <= RPIPE_zeropad_input_pipe_126_inst_req_1;
      reqR_unguarded(15) <= RPIPE_zeropad_input_pipe_138_inst_req_1;
      reqR_unguarded(14) <= RPIPE_zeropad_input_pipe_326_inst_req_1;
      reqR_unguarded(13) <= RPIPE_zeropad_input_pipe_213_inst_req_1;
      reqR_unguarded(12) <= RPIPE_zeropad_input_pipe_151_inst_req_1;
      reqR_unguarded(11) <= RPIPE_zeropad_input_pipe_163_inst_req_1;
      reqR_unguarded(10) <= RPIPE_zeropad_input_pipe_176_inst_req_1;
      reqR_unguarded(9) <= RPIPE_zeropad_input_pipe_188_inst_req_1;
      reqR_unguarded(8) <= RPIPE_zeropad_input_pipe_51_inst_req_1;
      reqR_unguarded(7) <= RPIPE_zeropad_input_pipe_226_inst_req_1;
      reqR_unguarded(6) <= RPIPE_zeropad_input_pipe_339_inst_req_1;
      reqR_unguarded(5) <= RPIPE_zeropad_input_pipe_357_inst_req_1;
      reqR_unguarded(4) <= RPIPE_zeropad_input_pipe_375_inst_req_1;
      reqR_unguarded(3) <= RPIPE_zeropad_input_pipe_393_inst_req_1;
      reqR_unguarded(2) <= RPIPE_zeropad_input_pipe_411_inst_req_1;
      reqR_unguarded(1) <= RPIPE_zeropad_input_pipe_429_inst_req_1;
      reqR_unguarded(0) <= RPIPE_zeropad_input_pipe_447_inst_req_1;
      RPIPE_zeropad_input_pipe_60_inst_ack_1 <= ackR_unguarded(25);
      RPIPE_zeropad_input_pipe_88_inst_ack_1 <= ackR_unguarded(24);
      RPIPE_zeropad_input_pipe_76_inst_ack_1 <= ackR_unguarded(23);
      RPIPE_zeropad_input_pipe_63_inst_ack_1 <= ackR_unguarded(22);
      RPIPE_zeropad_input_pipe_54_inst_ack_1 <= ackR_unguarded(21);
      RPIPE_zeropad_input_pipe_57_inst_ack_1 <= ackR_unguarded(20);
      RPIPE_zeropad_input_pipe_201_inst_ack_1 <= ackR_unguarded(19);
      RPIPE_zeropad_input_pipe_101_inst_ack_1 <= ackR_unguarded(18);
      RPIPE_zeropad_input_pipe_113_inst_ack_1 <= ackR_unguarded(17);
      RPIPE_zeropad_input_pipe_126_inst_ack_1 <= ackR_unguarded(16);
      RPIPE_zeropad_input_pipe_138_inst_ack_1 <= ackR_unguarded(15);
      RPIPE_zeropad_input_pipe_326_inst_ack_1 <= ackR_unguarded(14);
      RPIPE_zeropad_input_pipe_213_inst_ack_1 <= ackR_unguarded(13);
      RPIPE_zeropad_input_pipe_151_inst_ack_1 <= ackR_unguarded(12);
      RPIPE_zeropad_input_pipe_163_inst_ack_1 <= ackR_unguarded(11);
      RPIPE_zeropad_input_pipe_176_inst_ack_1 <= ackR_unguarded(10);
      RPIPE_zeropad_input_pipe_188_inst_ack_1 <= ackR_unguarded(9);
      RPIPE_zeropad_input_pipe_51_inst_ack_1 <= ackR_unguarded(8);
      RPIPE_zeropad_input_pipe_226_inst_ack_1 <= ackR_unguarded(7);
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
      call11_61 <= data_out(207 downto 200);
      call25_89 <= data_out(199 downto 192);
      call21_77 <= data_out(191 downto 184);
      call16_64 <= data_out(183 downto 176);
      call2_55 <= data_out(175 downto 168);
      call6_58 <= data_out(167 downto 160);
      call66_202 <= data_out(159 downto 152);
      call30_102 <= data_out(151 downto 144);
      call34_114 <= data_out(143 downto 136);
      call39_127 <= data_out(135 downto 128);
      call43_139 <= data_out(127 downto 120);
      call93_327 <= data_out(119 downto 112);
      call70_214 <= data_out(111 downto 104);
      call48_152 <= data_out(103 downto 96);
      call52_164 <= data_out(95 downto 88);
      call57_177 <= data_out(87 downto 80);
      call61_189 <= data_out(79 downto 72);
      call_52 <= data_out(71 downto 64);
      call75_227 <= data_out(63 downto 56);
      call97_340 <= data_out(55 downto 48);
      call103_358 <= data_out(47 downto 40);
      call109_376 <= data_out(39 downto 32);
      call115_394 <= data_out(31 downto 24);
      call121_412 <= data_out(23 downto 16);
      call127_430 <= data_out(15 downto 8);
      call133_448 <= data_out(7 downto 0);
      zeropad_input_pipe_read_0_gI: SplitGuardInterface generic map(name => "zeropad_input_pipe_read_0_gI", nreqs => 26, buffering => guardBuffering, use_guards => guardFlags,  sample_only => false,  update_only => true) -- 
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
      zeropad_input_pipe_read_0: InputPortRevised -- 
        generic map ( name => "zeropad_input_pipe_read_0", data_width => 8,  num_reqs => 26,  output_buffering => outBUFs,   nonblocking_read_flag => False,  no_arbitration => false)
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
    end Block; -- inport group 0
    -- shared outport operator group (0) : WPIPE_zeropad_output_pipe_932_inst WPIPE_zeropad_output_pipe_929_inst WPIPE_zeropad_output_pipe_1082_inst WPIPE_zeropad_output_pipe_1085_inst WPIPE_zeropad_output_pipe_1088_inst WPIPE_zeropad_output_pipe_1091_inst WPIPE_zeropad_output_pipe_1094_inst WPIPE_zeropad_output_pipe_911_inst WPIPE_zeropad_output_pipe_914_inst WPIPE_zeropad_output_pipe_1097_inst WPIPE_zeropad_output_pipe_917_inst WPIPE_zeropad_output_pipe_920_inst WPIPE_zeropad_output_pipe_1100_inst WPIPE_zeropad_output_pipe_923_inst WPIPE_zeropad_output_pipe_1103_inst WPIPE_zeropad_output_pipe_926_inst 
    OutportGroup_0: Block -- 
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
      sample_req_unguarded(15) <= WPIPE_zeropad_output_pipe_932_inst_req_0;
      sample_req_unguarded(14) <= WPIPE_zeropad_output_pipe_929_inst_req_0;
      sample_req_unguarded(13) <= WPIPE_zeropad_output_pipe_1082_inst_req_0;
      sample_req_unguarded(12) <= WPIPE_zeropad_output_pipe_1085_inst_req_0;
      sample_req_unguarded(11) <= WPIPE_zeropad_output_pipe_1088_inst_req_0;
      sample_req_unguarded(10) <= WPIPE_zeropad_output_pipe_1091_inst_req_0;
      sample_req_unguarded(9) <= WPIPE_zeropad_output_pipe_1094_inst_req_0;
      sample_req_unguarded(8) <= WPIPE_zeropad_output_pipe_911_inst_req_0;
      sample_req_unguarded(7) <= WPIPE_zeropad_output_pipe_914_inst_req_0;
      sample_req_unguarded(6) <= WPIPE_zeropad_output_pipe_1097_inst_req_0;
      sample_req_unguarded(5) <= WPIPE_zeropad_output_pipe_917_inst_req_0;
      sample_req_unguarded(4) <= WPIPE_zeropad_output_pipe_920_inst_req_0;
      sample_req_unguarded(3) <= WPIPE_zeropad_output_pipe_1100_inst_req_0;
      sample_req_unguarded(2) <= WPIPE_zeropad_output_pipe_923_inst_req_0;
      sample_req_unguarded(1) <= WPIPE_zeropad_output_pipe_1103_inst_req_0;
      sample_req_unguarded(0) <= WPIPE_zeropad_output_pipe_926_inst_req_0;
      WPIPE_zeropad_output_pipe_932_inst_ack_0 <= sample_ack_unguarded(15);
      WPIPE_zeropad_output_pipe_929_inst_ack_0 <= sample_ack_unguarded(14);
      WPIPE_zeropad_output_pipe_1082_inst_ack_0 <= sample_ack_unguarded(13);
      WPIPE_zeropad_output_pipe_1085_inst_ack_0 <= sample_ack_unguarded(12);
      WPIPE_zeropad_output_pipe_1088_inst_ack_0 <= sample_ack_unguarded(11);
      WPIPE_zeropad_output_pipe_1091_inst_ack_0 <= sample_ack_unguarded(10);
      WPIPE_zeropad_output_pipe_1094_inst_ack_0 <= sample_ack_unguarded(9);
      WPIPE_zeropad_output_pipe_911_inst_ack_0 <= sample_ack_unguarded(8);
      WPIPE_zeropad_output_pipe_914_inst_ack_0 <= sample_ack_unguarded(7);
      WPIPE_zeropad_output_pipe_1097_inst_ack_0 <= sample_ack_unguarded(6);
      WPIPE_zeropad_output_pipe_917_inst_ack_0 <= sample_ack_unguarded(5);
      WPIPE_zeropad_output_pipe_920_inst_ack_0 <= sample_ack_unguarded(4);
      WPIPE_zeropad_output_pipe_1100_inst_ack_0 <= sample_ack_unguarded(3);
      WPIPE_zeropad_output_pipe_923_inst_ack_0 <= sample_ack_unguarded(2);
      WPIPE_zeropad_output_pipe_1103_inst_ack_0 <= sample_ack_unguarded(1);
      WPIPE_zeropad_output_pipe_926_inst_ack_0 <= sample_ack_unguarded(0);
      update_req_unguarded(15) <= WPIPE_zeropad_output_pipe_932_inst_req_1;
      update_req_unguarded(14) <= WPIPE_zeropad_output_pipe_929_inst_req_1;
      update_req_unguarded(13) <= WPIPE_zeropad_output_pipe_1082_inst_req_1;
      update_req_unguarded(12) <= WPIPE_zeropad_output_pipe_1085_inst_req_1;
      update_req_unguarded(11) <= WPIPE_zeropad_output_pipe_1088_inst_req_1;
      update_req_unguarded(10) <= WPIPE_zeropad_output_pipe_1091_inst_req_1;
      update_req_unguarded(9) <= WPIPE_zeropad_output_pipe_1094_inst_req_1;
      update_req_unguarded(8) <= WPIPE_zeropad_output_pipe_911_inst_req_1;
      update_req_unguarded(7) <= WPIPE_zeropad_output_pipe_914_inst_req_1;
      update_req_unguarded(6) <= WPIPE_zeropad_output_pipe_1097_inst_req_1;
      update_req_unguarded(5) <= WPIPE_zeropad_output_pipe_917_inst_req_1;
      update_req_unguarded(4) <= WPIPE_zeropad_output_pipe_920_inst_req_1;
      update_req_unguarded(3) <= WPIPE_zeropad_output_pipe_1100_inst_req_1;
      update_req_unguarded(2) <= WPIPE_zeropad_output_pipe_923_inst_req_1;
      update_req_unguarded(1) <= WPIPE_zeropad_output_pipe_1103_inst_req_1;
      update_req_unguarded(0) <= WPIPE_zeropad_output_pipe_926_inst_req_1;
      WPIPE_zeropad_output_pipe_932_inst_ack_1 <= update_ack_unguarded(15);
      WPIPE_zeropad_output_pipe_929_inst_ack_1 <= update_ack_unguarded(14);
      WPIPE_zeropad_output_pipe_1082_inst_ack_1 <= update_ack_unguarded(13);
      WPIPE_zeropad_output_pipe_1085_inst_ack_1 <= update_ack_unguarded(12);
      WPIPE_zeropad_output_pipe_1088_inst_ack_1 <= update_ack_unguarded(11);
      WPIPE_zeropad_output_pipe_1091_inst_ack_1 <= update_ack_unguarded(10);
      WPIPE_zeropad_output_pipe_1094_inst_ack_1 <= update_ack_unguarded(9);
      WPIPE_zeropad_output_pipe_911_inst_ack_1 <= update_ack_unguarded(8);
      WPIPE_zeropad_output_pipe_914_inst_ack_1 <= update_ack_unguarded(7);
      WPIPE_zeropad_output_pipe_1097_inst_ack_1 <= update_ack_unguarded(6);
      WPIPE_zeropad_output_pipe_917_inst_ack_1 <= update_ack_unguarded(5);
      WPIPE_zeropad_output_pipe_920_inst_ack_1 <= update_ack_unguarded(4);
      WPIPE_zeropad_output_pipe_1100_inst_ack_1 <= update_ack_unguarded(3);
      WPIPE_zeropad_output_pipe_923_inst_ack_1 <= update_ack_unguarded(2);
      WPIPE_zeropad_output_pipe_1103_inst_ack_1 <= update_ack_unguarded(1);
      WPIPE_zeropad_output_pipe_926_inst_ack_1 <= update_ack_unguarded(0);
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
      data_in <= conv160_840 & conv166_850 & conv287_1081 & conv281_1071 & conv275_1061 & conv269_1051 & conv263_1041 & conv202_910 & conv196_900 & conv257_1031 & conv190_890 & conv184_880 & conv251_1021 & conv178_870 & conv245_1011 & conv172_860;
      zeropad_output_pipe_write_0_gI: SplitGuardInterface generic map(name => "zeropad_output_pipe_write_0_gI", nreqs => 16, buffering => guardBuffering, use_guards => guardFlags,  sample_only => true,  update_only => false) -- 
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
      zeropad_output_pipe_write_0: OutputPortRevised -- 
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
    end Block; -- outport group 0
    -- shared call operator group (0) : call_stmt_825_call call_stmt_484_call 
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
      reqL_unguarded(1) <= call_stmt_825_call_req_0;
      reqL_unguarded(0) <= call_stmt_484_call_req_0;
      call_stmt_825_call_ack_0 <= ackL_unguarded(1);
      call_stmt_484_call_ack_0 <= ackL_unguarded(0);
      reqR_unguarded(1) <= call_stmt_825_call_req_1;
      reqR_unguarded(0) <= call_stmt_484_call_req_1;
      call_stmt_825_call_ack_1 <= ackR_unguarded(1);
      call_stmt_484_call_ack_1 <= ackR_unguarded(0);
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
      call153_825 <= data_out(127 downto 64);
      call141_484 <= data_out(63 downto 0);
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
      memory_space_1_lr_req : out  std_logic_vector(0 downto 0);
      memory_space_1_lr_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_lr_addr : out  std_logic_vector(13 downto 0);
      memory_space_1_lr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_1_lc_req : out  std_logic_vector(0 downto 0);
      memory_space_1_lc_ack : in   std_logic_vector(0 downto 0);
      memory_space_1_lc_data : in   std_logic_vector(63 downto 0);
      memory_space_1_lc_tag :  in  std_logic_vector(0 downto 0);
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
      memory_space_0_sr_req : out  std_logic_vector(0 downto 0);
      memory_space_0_sr_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_sr_addr : out  std_logic_vector(13 downto 0);
      memory_space_0_sr_data : out  std_logic_vector(63 downto 0);
      memory_space_0_sr_tag :  out  std_logic_vector(17 downto 0);
      memory_space_0_sc_req : out  std_logic_vector(0 downto 0);
      memory_space_0_sc_ack : in   std_logic_vector(0 downto 0);
      memory_space_0_sc_tag :  in  std_logic_vector(0 downto 0);
      zeropad_input_pipe_pipe_read_req : out  std_logic_vector(0 downto 0);
      zeropad_input_pipe_pipe_read_ack : in   std_logic_vector(0 downto 0);
      zeropad_input_pipe_pipe_read_data : in   std_logic_vector(7 downto 0);
      zeropad_output_pipe_pipe_write_req : out  std_logic_vector(0 downto 0);
      zeropad_output_pipe_pipe_write_ack : in   std_logic_vector(0 downto 0);
      zeropad_output_pipe_pipe_write_data : out  std_logic_vector(7 downto 0);
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
      memory_space_1_sr_req => memory_space_1_sr_req(0 downto 0),
      memory_space_1_sr_ack => memory_space_1_sr_ack(0 downto 0),
      memory_space_1_sr_addr => memory_space_1_sr_addr(13 downto 0),
      memory_space_1_sr_data => memory_space_1_sr_data(63 downto 0),
      memory_space_1_sr_tag => memory_space_1_sr_tag(17 downto 0),
      memory_space_1_sc_req => memory_space_1_sc_req(0 downto 0),
      memory_space_1_sc_ack => memory_space_1_sc_ack(0 downto 0),
      memory_space_1_sc_tag => memory_space_1_sc_tag(0 downto 0),
      zeropad_input_pipe_pipe_read_req => zeropad_input_pipe_pipe_read_req(0 downto 0),
      zeropad_input_pipe_pipe_read_ack => zeropad_input_pipe_pipe_read_ack(0 downto 0),
      zeropad_input_pipe_pipe_read_data => zeropad_input_pipe_pipe_read_data(7 downto 0),
      zeropad_output_pipe_pipe_write_req => zeropad_output_pipe_pipe_write_req(0 downto 0),
      zeropad_output_pipe_pipe_write_ack => zeropad_output_pipe_pipe_write_ack(0 downto 0),
      zeropad_output_pipe_pipe_write_data => zeropad_output_pipe_pipe_write_data(7 downto 0),
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
