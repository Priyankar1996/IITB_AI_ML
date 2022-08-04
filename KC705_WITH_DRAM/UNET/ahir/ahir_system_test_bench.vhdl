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
library GhdlLink;
use GhdlLink.Utility_Package.all;
use GhdlLink.Vhpi_Foreign.all;
entity ahir_system_Test_Bench is -- 
  -- 
end entity;
architecture VhpiLink of ahir_system_Test_Bench is -- 
  component ahir_system is -- 
    port (-- 
      clk : in std_logic;
      reset : in std_logic;
      MAIN_MEM_REQUEST_pipe_read_data: out std_logic_vector(109 downto 0);
      MAIN_MEM_REQUEST_pipe_read_req : in std_logic_vector(0 downto 0);
      MAIN_MEM_REQUEST_pipe_read_ack : out std_logic_vector(0 downto 0);
      MAIN_MEM_RESPONSE_pipe_write_data: in std_logic_vector(64 downto 0);
      MAIN_MEM_RESPONSE_pipe_write_req : in std_logic_vector(0 downto 0);
      MAIN_MEM_RESPONSE_pipe_write_ack : out std_logic_vector(0 downto 0);
      system_input_pipe_pipe_write_data: in std_logic_vector(7 downto 0);
      system_input_pipe_pipe_write_req : in std_logic_vector(0 downto 0);
      system_input_pipe_pipe_write_ack : out std_logic_vector(0 downto 0);
      system_output_pipe_pipe_read_data: out std_logic_vector(7 downto 0);
      system_output_pipe_pipe_read_req : in std_logic_vector(0 downto 0);
      system_output_pipe_pipe_read_ack : out std_logic_vector(0 downto 0)); -- 
    -- 
  end component;
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  signal systemTOP_tag_in: std_logic_vector(1 downto 0);
  signal systemTOP_tag_out: std_logic_vector(1 downto 0);
  signal systemTOP_start_req : std_logic := '0';
  signal systemTOP_start_ack : std_logic := '0';
  signal systemTOP_fin_req   : std_logic := '0';
  signal systemTOP_fin_ack   : std_logic := '0';
  signal timerDaemon_tag_in: std_logic_vector(1 downto 0);
  signal timerDaemon_tag_out: std_logic_vector(1 downto 0);
  signal timerDaemon_start_req : std_logic := '0';
  signal timerDaemon_start_ack : std_logic := '0';
  signal timerDaemon_fin_req   : std_logic := '0';
  signal timerDaemon_fin_ack   : std_logic := '0';
  -- read from pipe MAIN_MEM_REQUEST
  signal MAIN_MEM_REQUEST_pipe_read_data: std_logic_vector(109 downto 0);
  signal MAIN_MEM_REQUEST_pipe_read_req : std_logic_vector(0 downto 0) := (others => '0');
  signal MAIN_MEM_REQUEST_pipe_read_ack : std_logic_vector(0 downto 0);
  -- write to pipe MAIN_MEM_RESPONSE
  signal MAIN_MEM_RESPONSE_pipe_write_data: std_logic_vector(64 downto 0);
  signal MAIN_MEM_RESPONSE_pipe_write_req : std_logic_vector(0 downto 0) := (others => '0');
  signal MAIN_MEM_RESPONSE_pipe_write_ack : std_logic_vector(0 downto 0);
  -- write to pipe system_input_pipe
  signal system_input_pipe_pipe_write_data: std_logic_vector(7 downto 0);
  signal system_input_pipe_pipe_write_req : std_logic_vector(0 downto 0) := (others => '0');
  signal system_input_pipe_pipe_write_ack : std_logic_vector(0 downto 0);
  -- read from pipe system_output_pipe
  signal system_output_pipe_pipe_read_data: std_logic_vector(7 downto 0);
  signal system_output_pipe_pipe_read_req : std_logic_vector(0 downto 0) := (others => '0');
  signal system_output_pipe_pipe_read_ack : std_logic_vector(0 downto 0);
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
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_REQUEST req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      MAIN_MEM_REQUEST_pipe_read_req <= Unpack_String(req_val_string,1);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_REQUEST ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(MAIN_MEM_REQUEST_pipe_read_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_REQUEST 0");
      port_val_string := Pack_SLV_To_Vhpi_String(MAIN_MEM_REQUEST_pipe_read_data);
      Vhpi_Set_Port_Value(obj_ref,port_val_string,110);
      -- 
    end loop;
    --
  end process;
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
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_RESPONSE req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      MAIN_MEM_RESPONSE_pipe_write_req <= Unpack_String(req_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_RESPONSE 0");
      Vhpi_Get_Port_Value(obj_ref,port_val_string,65);
      MAIN_MEM_RESPONSE_pipe_write_data <= Unpack_String(port_val_string,65);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("MAIN_MEM_RESPONSE ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(MAIN_MEM_RESPONSE_pipe_write_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      -- 
    end loop;
    --
  end process;
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
      obj_ref := Pack_String_To_Vhpi_String("system_input_pipe req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      system_input_pipe_pipe_write_req <= Unpack_String(req_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("system_input_pipe 0");
      Vhpi_Get_Port_Value(obj_ref,port_val_string,8);
      system_input_pipe_pipe_write_data <= Unpack_String(port_val_string,8);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("system_input_pipe ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(system_input_pipe_pipe_write_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      -- 
    end loop;
    --
  end process;
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
      obj_ref := Pack_String_To_Vhpi_String("system_output_pipe req");
      Vhpi_Get_Port_Value(obj_ref,req_val_string,1);
      system_output_pipe_pipe_read_req <= Unpack_String(req_val_string,1);
      wait until clk = '1';
      obj_ref := Pack_String_To_Vhpi_String("system_output_pipe ack");
      ack_val_string := Pack_SLV_To_Vhpi_String(system_output_pipe_pipe_read_ack);
      Vhpi_Set_Port_Value(obj_ref,ack_val_string,1);
      obj_ref := Pack_String_To_Vhpi_String("system_output_pipe 0");
      port_val_string := Pack_SLV_To_Vhpi_String(system_output_pipe_pipe_read_data);
      Vhpi_Set_Port_Value(obj_ref,port_val_string,8);
      -- 
    end loop;
    --
  end process;
  ahir_system_instance: ahir_system -- 
    port map ( -- 
      clk => clk,
      reset => reset,
      MAIN_MEM_REQUEST_pipe_read_data  => MAIN_MEM_REQUEST_pipe_read_data, 
      MAIN_MEM_REQUEST_pipe_read_req  => MAIN_MEM_REQUEST_pipe_read_req, 
      MAIN_MEM_REQUEST_pipe_read_ack  => MAIN_MEM_REQUEST_pipe_read_ack ,
      MAIN_MEM_RESPONSE_pipe_write_data  => MAIN_MEM_RESPONSE_pipe_write_data, 
      MAIN_MEM_RESPONSE_pipe_write_req  => MAIN_MEM_RESPONSE_pipe_write_req, 
      MAIN_MEM_RESPONSE_pipe_write_ack  => MAIN_MEM_RESPONSE_pipe_write_ack,
      system_input_pipe_pipe_write_data  => system_input_pipe_pipe_write_data, 
      system_input_pipe_pipe_write_req  => system_input_pipe_pipe_write_req, 
      system_input_pipe_pipe_write_ack  => system_input_pipe_pipe_write_ack,
      system_output_pipe_pipe_read_data  => system_output_pipe_pipe_read_data, 
      system_output_pipe_pipe_read_req  => system_output_pipe_pipe_read_req, 
      system_output_pipe_pipe_read_ack  => system_output_pipe_pipe_read_ack ); -- 
  -- 
end VhpiLink;
