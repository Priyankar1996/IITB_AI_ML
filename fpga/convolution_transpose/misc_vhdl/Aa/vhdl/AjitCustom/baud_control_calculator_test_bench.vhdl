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
library GhdlLink;
use GhdlLink.Utility_Package.all;
use GhdlLink.Vhpi_Foreign.all;
entity baud_control_calculator_Test_Bench is -- 
  -- 
end entity;
architecture VhpiLink of baud_control_calculator_Test_Bench is -- 
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  signal baudControlCalculatorDaemon_tag_in: std_logic_vector(1 downto 0);
  signal baudControlCalculatorDaemon_tag_out: std_logic_vector(1 downto 0);
  signal baudControlCalculatorDaemon_start_req : std_logic := '0';
  signal baudControlCalculatorDaemon_start_ack : std_logic := '0';
  signal baudControlCalculatorDaemon_fin_req   : std_logic := '0';
  signal baudControlCalculatorDaemon_fin_ack   : std_logic := '0';
  -- read from pipe BAUD_CONTROL_WORD_SIG
  signal BAUD_CONTROL_WORD_SIG_pipe_read_data: std_logic_vector(31 downto 0);
  signal BAUD_CONTROL_WORD_SIG_pipe_read_req : std_logic_vector(0 downto 0) := (others => '0');
  signal BAUD_CONTROL_WORD_SIG_pipe_read_ack : std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_SIG: std_logic_vector(31 downto 0);
  -- read from pipe BAUD_CONTROL_WORD_VALID
  signal BAUD_CONTROL_WORD_VALID_pipe_read_data: std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_VALID_pipe_read_req : std_logic_vector(0 downto 0) := (others => '0');
  signal BAUD_CONTROL_WORD_VALID_pipe_read_ack : std_logic_vector(0 downto 0);
  signal BAUD_CONTROL_WORD_VALID: std_logic_vector(0 downto 0);
  -- write to pipe BAUD_RATE_SIG
  signal BAUD_RATE_SIG_pipe_write_data: std_logic_vector(31 downto 0);
  signal BAUD_RATE_SIG_pipe_write_req : std_logic_vector(0 downto 0) := (others => '0');
  signal BAUD_RATE_SIG_pipe_write_ack : std_logic_vector(0 downto 0);
  signal BAUD_RATE_SIG: std_logic_vector(31 downto 0);
  -- write to pipe CLK_FREQUENCY_SIG
  signal CLK_FREQUENCY_SIG_pipe_write_data: std_logic_vector(31 downto 0);
  signal CLK_FREQUENCY_SIG_pipe_write_req : std_logic_vector(0 downto 0) := (others => '0');
  signal CLK_FREQUENCY_SIG_pipe_write_ack : std_logic_vector(0 downto 0);
  signal CLK_FREQUENCY_SIG: std_logic_vector(31 downto 0);
  -- write to pipe CLOCK_FREQUENCY_VALID
  signal CLOCK_FREQUENCY_VALID_pipe_write_data: std_logic_vector(0 downto 0);
  signal CLOCK_FREQUENCY_VALID_pipe_write_req : std_logic_vector(0 downto 0) := (others => '0');
  signal CLOCK_FREQUENCY_VALID_pipe_write_ack : std_logic_vector(0 downto 0);
  signal CLOCK_FREQUENCY_VALID: std_logic_vector(0 downto 0);
  -- 
begin --
  -- clock/reset generation 
  clk <= not clk after 5 ns;
  -- assert reset for four clocks.
  process
  begin --
    Vhpi_Initialize;
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    reset <= '0';
    while true loop --
      wait until clk = '0';
      Vhpi_Listen;
      Vhpi_Send;
      --
    end loop;
    wait;
    --
  end process;
  -- connect all the top-level modules to Vhpi
  BAUD_CONTROL_WORD_SIG_pipe_read_ack(0) <= '1';
  TruncateOrPad(BAUD_CONTROL_WORD_SIG, BAUD_CONTROL_WORD_SIG_pipe_read_data);
  process
  variable port_val_string, req_val_string, ack_val_string,  obj_ref: VhpiString;
  begin --
    wait until reset = '0';
    -- let the DUT come out of reset.... give it 4 cycles.
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    while true loop -- 
      wait until clk = '0';
      wait for 1 ns; 
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_SIG req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      BAUD_CONTROL_WORD_SIG_pipe_read_req <= Unpack_String(req_val_string,1);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_SIG ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(BAUD_CONTROL_WORD_SIG_pipe_read_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_SIG 0");
      port_val_string := Pack_SLV_To_Vhpi_String(BAUD_CONTROL_WORD_SIG_pipe_read_data);
      Vhpi_Set_Port_Value(obj_ref,port_val_string,32);
      -- 
    end loop;
    --
  end process;
  BAUD_CONTROL_WORD_VALID_pipe_read_ack(0) <= '1';
  TruncateOrPad(BAUD_CONTROL_WORD_VALID, BAUD_CONTROL_WORD_VALID_pipe_read_data);
  process
  variable port_val_string, req_val_string, ack_val_string,  obj_ref: VhpiString;
  begin --
    wait until reset = '0';
    -- let the DUT come out of reset.... give it 4 cycles.
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    while true loop -- 
      wait until clk = '0';
      wait for 1 ns; 
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_VALID req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      BAUD_CONTROL_WORD_VALID_pipe_read_req <= Unpack_String(req_val_string,1);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_VALID ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(BAUD_CONTROL_WORD_VALID_pipe_read_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("BAUD_CONTROL_WORD_VALID 0");
      port_val_string := Pack_SLV_To_Vhpi_String(BAUD_CONTROL_WORD_VALID_pipe_read_data);
      Vhpi_Set_Port_Value(obj_ref,port_val_string,1);
      -- 
    end loop;
    --
  end process;
  BAUD_RATE_SIG_pipe_write_ack(0) <= '1';
  TruncateOrPad(BAUD_RATE_SIG_pipe_write_data,BAUD_RATE_SIG);
  process
  variable port_val_string, req_val_string, ack_val_string,  obj_ref: VhpiString;
  begin --
    wait until reset = '0';
    -- let the DUT come out of reset.... give it 4 cycles.
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    while true loop -- 
      wait until clk = '0';
      wait for 1 ns; 
      obj_ref := Pack_String_To_Vhpi_String("BAUD_RATE_SIG req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      BAUD_RATE_SIG_pipe_write_req <= Unpack_String(req_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("BAUD_RATE_SIG 0");
      Vhpi_Get_Port_Value(obj_ref,port_val_string,32);
      wait for 1 ns;
      if (BAUD_RATE_SIG_pipe_write_req(0) = '1') then 
      -- 
        BAUD_RATE_SIG_pipe_write_data <= Unpack_String(port_val_string,32);
        -- 
      end if;
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("BAUD_RATE_SIG ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(BAUD_RATE_SIG_pipe_write_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      -- 
    end loop;
    --
  end process;
  CLK_FREQUENCY_SIG_pipe_write_ack(0) <= '1';
  TruncateOrPad(CLK_FREQUENCY_SIG_pipe_write_data,CLK_FREQUENCY_SIG);
  process
  variable port_val_string, req_val_string, ack_val_string,  obj_ref: VhpiString;
  begin --
    wait until reset = '0';
    -- let the DUT come out of reset.... give it 4 cycles.
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    while true loop -- 
      wait until clk = '0';
      wait for 1 ns; 
      obj_ref := Pack_String_To_Vhpi_String("CLK_FREQUENCY_SIG req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      CLK_FREQUENCY_SIG_pipe_write_req <= Unpack_String(req_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("CLK_FREQUENCY_SIG 0");
      Vhpi_Get_Port_Value(obj_ref,port_val_string,32);
      wait for 1 ns;
      if (CLK_FREQUENCY_SIG_pipe_write_req(0) = '1') then 
      -- 
        CLK_FREQUENCY_SIG_pipe_write_data <= Unpack_String(port_val_string,32);
        -- 
      end if;
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("CLK_FREQUENCY_SIG ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(CLK_FREQUENCY_SIG_pipe_write_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      -- 
    end loop;
    --
  end process;
  CLOCK_FREQUENCY_VALID_pipe_write_ack(0) <= '1';
  TruncateOrPad(CLOCK_FREQUENCY_VALID_pipe_write_data,CLOCK_FREQUENCY_VALID);
  process
  variable port_val_string, req_val_string, ack_val_string,  obj_ref: VhpiString;
  begin --
    wait until reset = '0';
    -- let the DUT come out of reset.... give it 4 cycles.
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    wait until clk = '1';
    while true loop -- 
      wait until clk = '0';
      wait for 1 ns; 
      obj_ref := Pack_String_To_Vhpi_String("CLOCK_FREQUENCY_VALID req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      CLOCK_FREQUENCY_VALID_pipe_write_req <= Unpack_String(req_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("CLOCK_FREQUENCY_VALID 0");
      Vhpi_Get_Port_Value(obj_ref,port_val_string,1);
      wait for 1 ns;
      if (CLOCK_FREQUENCY_VALID_pipe_write_req(0) = '1') then 
      -- 
        CLOCK_FREQUENCY_VALID_pipe_write_data <= Unpack_String(port_val_string,1);
        -- 
      end if;
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("CLOCK_FREQUENCY_VALID ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(CLOCK_FREQUENCY_VALID_pipe_write_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      -- 
    end loop;
    --
  end process;
  baud_control_calculator_instance: baud_control_calculator -- 
    port map ( -- 
      clk => clk,
      reset => reset,
      BAUD_CONTROL_WORD_SIG => BAUD_CONTROL_WORD_SIG,
      BAUD_CONTROL_WORD_VALID => BAUD_CONTROL_WORD_VALID,
      BAUD_RATE_SIG => BAUD_RATE_SIG,
      CLK_FREQUENCY_SIG => CLK_FREQUENCY_SIG,
      CLOCK_FREQUENCY_VALID => CLOCK_FREQUENCY_VALID); -- 
  -- 
end VhpiLink;
