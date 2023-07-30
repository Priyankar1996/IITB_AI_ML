library ieee;
use ieee.std_logic_1164.all;


package i2cBaseComponents is
  component i2c_master IS
  --
  -- MPD: pass the divider as a signal to the design.
  --
  -- GENERIC(
    -- input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    -- bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz

  PORT(
    clock_divide_count   : IN integer;
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda_in    : in  STD_LOGIC;                  
    sda_pull_down : out STD_LOGIC;
    scl_in    : in std_logic;
    scl_pull_down : out std_logic);
  END component;

  component afb_i2c_master is
	port (
		AFB_BUS_REQUEST_pipe_write_data : in std_logic_vector(73 downto 0);
      		AFB_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      		AFB_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      		AFB_BUS_RESPONSE_pipe_read_data : out std_logic_vector(32 downto 0);
      		AFB_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      		AFB_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
    		sda_pull_down       : out  std_logic_vector(0 downto 0);
    		sda_in       	    : in  std_logic_vector(0 downto 0);
    		scl_pull_down       : out std_logic_vector(0 downto 0);
    		scl_in       	    : in  std_logic_vector(0 downto 0);
		clk, reset: in std_logic
		);
   end component;
end package i2cBaseComponents;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
--   FileName:         i2c_master.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 13.1 Build 162 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 11/01/2012 Scott Larson
--     Initial Public Release
--   Version 2.0 06/20/2014 Scott Larson
--     Added ability to interface with different slaves in the same transaction
--     Corrected ack_error bug where ack_error went 'Z' instead of '1' on error
--     Corrected timing of when ack_error signal clears
--   Version 2.1 10/21/2014 Scott Larson
--     Replaced gated clock with clock enable
--     Adjusted timing of SCL during start and stop conditions
--   Version 2.2 02/05/2015 Scott Larson
--     Corrected small SDA glitch introduced in version 2.1
-- 
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY i2c_master IS
  --
  -- MPD: pass the divider as a signal to the design.
  --
  -- GENERIC(
    -- input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    -- bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz

  -- MPD removed the tristates and made all I/O's unidirectional...

  PORT(
    clock_divide_count   : IN integer;
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    -- unidirectionals here.. make them bidirectionals at a higher layer.
    sda_in    : in  STD_LOGIC;                  
    sda_pull_down : out STD_LOGIC;
    scl_in    : in std_logic;
    scl_pull_down : out std_logic
   );                   --serial clock output of i2c bus
END i2c_master;

ARCHITECTURE logic OF i2c_master IS

  -- CONSTANT divider  :  INTEGER := (input_clk/bus_clk)/4; --number of clocks in 1/4 cycle of scl
  signal   cdivX4, cdivX2, cdivX3: integer;

  TYPE machine IS(ready, start, command, slv_ack1, wr, rd, slv_ack2, mstr_ack, stop); --needed states

  SIGNAL state         : machine;                        --state machine
  SIGNAL data_clk      : STD_LOGIC;                      --data clock for sda
  SIGNAL data_clk_prev : STD_LOGIC;                      --data clock during previous system clock
  SIGNAL scl_clk       : STD_LOGIC;                      --constantly running internal scl
  SIGNAL scl_ena       : STD_LOGIC := '0';               --enables internal scl to output
  SIGNAL sda_int       : STD_LOGIC := '1';               --internal sda
  SIGNAL sda_ena_n     : STD_LOGIC;                      --enables internal sda to output
  SIGNAL addr_rw       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --latched in address and read/write
  SIGNAL data_tx       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --latched in data to write to slave
  SIGNAL data_rx       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --data received from slave
  SIGNAL bit_cnt       : INTEGER RANGE 0 TO 7 := 7;      --tracks bit number in transaction
  SIGNAL stretch       : STD_LOGIC := '0';               --identifies if slave is stretching scl

  signal sda, scl, sda_pull_down_sig, scl_pull_down_sig: std_logic;

BEGIN

  cdivX4 <= clock_divide_count*4;
  cdivX2 <= clock_divide_count*2;
  cdivX3 <= (cdivX2 + clock_divide_count);

  --generate the timing for the bus clock (scl_clk) and the data clock (data_clk)
  PROCESS(clk, reset_n)
    VARIABLE count  :  INTEGER RANGE 0 TO 1023;  --timing for clock generation
  BEGIN
    IF(reset_n = '0') THEN                --reset asserted
      stretch <= '0';
      count := 0;
    ELSIF(clk'EVENT AND clk = '1') THEN
      data_clk_prev <= data_clk;          --store previous value of data clock
      IF(count = cdivX4-1) THEN           --end of timing cycle
        count := 0;                       --reset timer
      ELSIF(stretch = '0') THEN           --clock stretching from slave not detected
        count := count + 1;               --continue clock generation timing
      END IF;
      if (COUNT < clock_divide_count) then --first 1/4 cycle of clocking
          scl_clk <= '0';
          data_clk <= '0';
      elsif (COUNT < cdivX2) then      	   --second 1/4 cycle of clocking
          scl_clk <= '0';
          data_clk <= '1';
      elsif (COUNT < cdivX3)  then  	   --third 1/4 cycle of clocking
          scl_clk <= '1';                 --release scl
          IF(scl = '0') THEN              --detect if slave is stretching clock
            stretch <= '1';
          ELSE
            stretch <= '0';
          END IF;
          data_clk <= '1';
      else
          scl_clk <= '1';
          data_clk <= '0';
      end if;
    END IF;
  END PROCESS;

  --state machine and writing to sda during scl low (data_clk rising edge)
  PROCESS(clk, reset_n)
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      IF(reset_n = '0') THEN                 --reset asserted
        state <= ready;                      --return to initial state
        busy <= '1';                         --indicate not available
        scl_ena <= '0';                      --sets scl high impedance
        sda_int <= '1';                      --sets sda high impedance
        ack_error <= '0';                    --clear acknowledge error flag
        bit_cnt <= 7;                        --restarts data bit counter
        data_rd <= "00000000";               --clear data read port
      ELSE
        IF(data_clk = '1' AND data_clk_prev = '0') THEN  --data clock rising edge
          CASE state IS
            WHEN ready =>                      --idle state
              IF(ena = '1') THEN               --transaction requested
                busy <= '1';                   --flag busy
                addr_rw <= addr & rw;          --collect requested slave address and command
                data_tx <= data_wr;            --collect requested data to write
                state <= start;                --go to start bit
              ELSE                             --remain idle
                busy <= '0';                   --unflag busy
                state <= ready;                --remain idle
              END IF;
            WHEN start =>                      --start bit of transaction
              busy <= '1';                     --resume busy if continuous mode
              sda_int <= addr_rw(bit_cnt);     --set first address bit to bus
              state <= command;                --go to command
            WHEN command =>                    --address and command byte of transaction
              IF(bit_cnt = 0) THEN             --command transmit finished
                sda_int <= '1';                --release sda for slave acknowledge
                bit_cnt <= 7;                  --reset bit counter for "byte" states
                state <= slv_ack1;             --go to slave acknowledge (command)
              ELSE                             --next clock cycle of command state
                bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
                sda_int <= addr_rw(bit_cnt-1); --write address/command bit to bus
                state <= command;              --continue with command
              END IF;
            WHEN slv_ack1 =>                   --slave acknowledge bit (command)
              IF(addr_rw(0) = '0') THEN        --write command
                sda_int <= data_tx(bit_cnt);   --write first bit of data
                state <= wr;                   --go to write byte
              ELSE                             --read command
                sda_int <= '1';                --release sda from incoming data
                state <= rd;                   --go to read byte
              END IF;
            WHEN wr =>                         --write byte of transaction
              busy <= '1';                     --resume busy if continuous mode
              IF(bit_cnt = 0) THEN             --write byte transmit finished
                sda_int <= '1';                --release sda for slave acknowledge
                bit_cnt <= 7;                  --reset bit counter for "byte" states
                state <= slv_ack2;             --go to slave acknowledge (write)
              ELSE                             --next clock cycle of write state
                bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
                sda_int <= data_tx(bit_cnt-1); --write next bit to bus
                state <= wr;                   --continue writing
              END IF;
            WHEN rd =>                         --read byte of transaction
              busy <= '1';                     --resume busy if continuous mode
              IF(bit_cnt = 0) THEN             --read byte receive finished
                IF(ena = '1' AND addr_rw = addr & rw) THEN  --continuing with another read at same address
                  sda_int <= '0';              --acknowledge the byte has been received
                ELSE                           --stopping or continuing with a write
                  sda_int <= '1';              --send a no-acknowledge (before stop or repeated start)
                END IF;
                bit_cnt <= 7;                  --reset bit counter for "byte" states
                data_rd <= data_rx;            --output received data
                state <= mstr_ack;             --go to master acknowledge
              ELSE                             --next clock cycle of read state
                bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
                state <= rd;                   --continue reading
              END IF;
            WHEN slv_ack2 =>                   --slave acknowledge bit (write)
              IF(ena = '1') THEN               --continue transaction
                busy <= '0';                   --continue is accepted
                addr_rw <= addr & rw;          --collect requested slave address and command
                data_tx <= data_wr;            --collect requested data to write
                IF(addr_rw = addr & rw) THEN   --continue transaction with another write
                  sda_int <= data_wr(bit_cnt); --write first bit of data
                  state <= wr;                 --go to write byte
                ELSE                           --continue transaction with a read or new slave
                  state <= start;              --go to repeated start
                END IF;
              ELSE                             --complete transaction
                state <= stop;                 --go to stop bit
              END IF;
            WHEN mstr_ack =>                   --master acknowledge bit after a read
              IF(ena = '1') THEN               --continue transaction
                busy <= '0';                   --continue is accepted and data received is available on bus
                addr_rw <= addr & rw;          --collect requested slave address and command
                data_tx <= data_wr;            --collect requested data to write
                IF(addr_rw = addr & rw) THEN   --continue transaction with another read
                  sda_int <= '1';              --release sda from incoming data
                  state <= rd;                 --go to read byte
                ELSE                           --continue transaction with a write or new slave
                  state <= start;              --repeated start
                END IF;    
              ELSE                             --complete transaction
                state <= stop;                 --go to stop bit
              END IF;
            WHEN stop =>                       --stop bit of transaction
              busy <= '0';                     --unflag busy
              state <= ready;                  --go to idle state
          END CASE;    
        ELSIF(data_clk = '0' AND data_clk_prev = '1') THEN  --data clock falling edge
          CASE state IS
            WHEN start =>                  
              IF(scl_ena = '0') THEN                  --starting new transaction
                scl_ena <= '1';                       --enable scl output
                ack_error <= '0';                     --reset acknowledge error output
              END IF;
            WHEN slv_ack1 =>                          --receiving slave acknowledge (command)
              IF(sda /= '0' OR ack_error = '1') THEN  --no-acknowledge or previous no-acknowledge
                ack_error <= '1';                     --set error output if no-acknowledge
              END IF;
            WHEN rd =>                                --receiving slave data
              data_rx(bit_cnt) <= sda;                --receive current slave data bit
            WHEN slv_ack2 =>                          --receiving slave acknowledge (write)
              IF(sda /= '0' OR ack_error = '1') THEN  --no-acknowledge or previous no-acknowledge
                ack_error <= '1';                     --set error output if no-acknowledge
              END IF;
            WHEN stop =>
              scl_ena <= '0';                         --disable scl
            WHEN OTHERS =>
              NULL;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS;  

  --set sda output
  WITH state SELECT
    sda_ena_n <= data_clk_prev WHEN start,     --generate start condition
                 NOT data_clk_prev WHEN stop,  --generate stop condition
                 sda_int WHEN OTHERS;          --set to internal sda signal    
      
  -- pull downs.
  scl_pull_down_sig <= scl_ena and (not scl_clk);
  sda_pull_down_sig <= (not sda_ena_n);

  -- ports.
  scl_pull_down <= scl_pull_down_sig;
  sda_pull_down <= sda_pull_down_sig;

  -- resolved signals used inside the design..
  scl <= '0' WHEN (scl_pull_down_sig = '1') else scl_in;
  sda <= '0' WHEN (sda_pull_down_sig = '1') else sda_in;

  
END logic;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library simpleI2CLib;
use simpleI2CLib.i2cBaseComponents.all;

-- An interface from the AFB bus (AJIT peripheral bus) to
-- the i2c_master..  

-- The incoming comand from the AFB (32-bits wdata) is
-- parsed as 
--
-- if [31] is '1' then 
--
-- [31]    = set clock divider.
-- [30:0] = clock divide count (31 bit value)
--
-- else if [31] is '0', then the command is parsed as follows:
--
-- [15]    = rwbar
-- [14:8]  = address
-- [7:0]   = write-data-byte.
-- 
-- The outgoint response to the AFB is
-- generated as 
-- [9]   = ack-error.
-- [8]   = busy
-- [7:0] = data read.
-- 
entity afb_i2c_master is
	port (
		AFB_BUS_REQUEST_pipe_write_data : in std_logic_vector(73 downto 0);
      		AFB_BUS_REQUEST_pipe_write_req  : in std_logic_vector(0  downto 0);
      		AFB_BUS_REQUEST_pipe_write_ack  : out std_logic_vector(0  downto 0);
      		AFB_BUS_RESPONSE_pipe_read_data : out std_logic_vector(32 downto 0);
      		AFB_BUS_RESPONSE_pipe_read_req  : in std_logic_vector(0  downto 0);
      		AFB_BUS_RESPONSE_pipe_read_ack  : out std_logic_vector(0  downto 0);
    		sda_pull_down       : out  std_logic_vector(0 downto 0);
    		sda_in       	    : in  std_logic_vector(0 downto 0);
    		scl_pull_down       : out std_logic_vector(0 downto 0);
    		scl_in       	    : in  std_logic_vector(0 downto 0);
		clk, reset: in std_logic
		);
end entity afb_i2c_master;

architecture MixedBeh of afb_i2c_master is
	signal reset_n: std_logic;

	signal i2cm_addr: std_logic_vector(6 downto 0);
	signal i2cm_rdata, i2cm_rdata_reg,  i2cm_wdata: std_logic_vector(7 downto 0);
	signal i2cm_ena, i2cm_rwbar, i2cm_busy, i2cm_ack_error: std_logic;
	signal i2cm_clock_divide_count: integer;
	
	signal latch_i2cm_clock_divide_count: boolean;
	signal latch_i2cm_rdata: boolean;

	type FsmState is (IDLE, I2CM_WAIT_FOR_BUSY, I2CM_IS_BUSY, I2CM_DONE);
	signal fsm_state: FsmState;

	signal afb_command_available: boolean;
	signal afb_ready_for_response  : boolean;
	signal afb_set_clock_divider: boolean;
	signal afb_do_read_write: boolean;
	signal afb_clock_divide_count: unsigned(30 downto 0);
begin

	afb_command_available <= (AFB_BUS_REQUEST_PIPE_write_req(0) = '1');
	afb_ready_for_response <= (AFB_BUS_RESPONSE_pipe_read_req(0) = '1');
	afb_set_clock_divider <= afb_command_available and
					(AFB_BUS_REQUEST_PIPE_write_data(31) = '1');
	afb_do_read_write <= afb_command_available and (not afb_set_clock_divider);
	afb_clock_divide_count <= unsigned(AFB_BUS_REQUEST_PIPE_write_data(30 downto 0));

	i2cm_wdata <= AFB_BUS_REQUEST_pipe_write_data(7 downto 0);
	i2cm_addr  <= AFB_BUS_REQUEST_pipe_write_data(14 downto 8);
	i2cm_rwbar <= AFB_BUS_REQUEST_pipe_write_data(15);
	
	-- state machine.
	process(fsm_state, afb_command_available, afb_ready_for_response, i2cm_busy)
		variable next_fsm_state_var : FsmState;
		variable afb_request_ack_var: std_logic;
		variable afb_response_ack_var: std_logic;
		variable enable_i2cm_var: std_logic;
		variable latch_i2cm_rdata_var: boolean;
		variable latch_i2cm_clock_divide_count_var : boolean;

	begin
		next_fsm_state_var   := fsm_state;
		afb_request_ack_var  := '0';
		afb_response_ack_var := '0';
		enable_i2cm_var      := '0';
		latch_i2cm_rdata_var := false;
		latch_i2cm_clock_divide_count_var := false;

		case fsm_state is
			when IDLE =>
				if(afb_set_clock_divider) then
					afb_request_ack_var := '1';
					latch_i2cm_clock_divide_count_var := true;
					next_fsm_state_var := I2CM_DONE;
				elsif (afb_do_read_write) then
					afb_request_ack_var := '1';
					enable_i2cm_var := '1';
					next_fsm_state_var := I2CM_WAIT_FOR_BUSY;
				end if;
			when I2CM_WAIT_FOR_BUSY =>
				if(i2cm_busy = '1') then
					next_fsm_state_var := I2CM_IS_BUSY;
				end if;
			when I2CM_IS_BUSY =>
				if(i2cm_busy = '0') then
					next_fsm_state_var := I2CM_DONE;
					latch_i2cm_rdata_var := true;
				end if;
			when I2CM_DONE =>
				afb_response_ack_var := '1';
				if(afb_ready_for_response) then
					next_fsm_state_var := IDLE;
				end if;
		end case;

		AFB_BUS_REQUEST_pipe_write_ack(0) <= afb_request_ack_var;
		AFB_BUS_RESPONSE_pipe_read_ack(0)  <= afb_response_ack_var;
		i2cm_ena <= enable_i2cm_var;

		latch_i2cm_clock_divide_count <= latch_i2cm_clock_divide_count_var;
		latch_i2cm_rdata <= latch_i2cm_rdata_var;

		if(clk'event and clk = '1') then
			if(reset = '1') then
				fsm_state <= IDLE;
			else
				fsm_state <= next_fsm_state_var;
			end if;
		end if;
		
	end process;
	reset_n <= not reset;

	-- latch i2cm information....
	process(clk, reset)
	begin
		if(clk'event and clk = '1') then
			if(reset = '1') then
				i2cm_clock_divide_count <= 0;
				i2cm_rdata_reg <= (others => '0');
			else 
				if (latch_i2cm_clock_divide_count) then
					i2cm_clock_divide_count <= to_integer (afb_clock_divide_count);
				end if;
				if (latch_i2cm_rdata) then
					i2cm_rdata_reg <= i2cm_rdata;
				end if;
			end if;
		end if;
	end process;

	process(i2cm_busy, i2cm_rdata_reg) 
	begin
      		AFB_BUS_RESPONSE_pipe_read_data(32 downto 10) <= (others => '0');
      		AFB_BUS_RESPONSE_pipe_read_data(9) <= i2cm_ack_error;
      		AFB_BUS_RESPONSE_pipe_read_data(8) <= i2cm_busy;
      		AFB_BUS_RESPONSE_pipe_read_data(7 downto 0) <= i2cm_rdata_reg;
	end process;

	i2cm_inst:
		i2c_master port map
			(
    				clock_divide_count => i2cm_clock_divide_count,
    				clk       => clk, 
    				reset_n   => reset_n,
    				ena       => i2cm_ena, 
    				addr      => i2cm_addr,
    				rw        => i2cm_rwbar,
    				data_wr   => i2cm_wdata,
    				busy      => i2cm_busy,
    				data_rd   => i2cm_rdata,
    				ack_error => i2cm_ack_error,
    				sda_in    => sda_in(0), 
    				sda_pull_down       => sda_pull_down(0), 
    				scl_in    => scl_in(0),
    				scl_pull_down    => scl_pull_down(0)
			);

end MixedBeh;
