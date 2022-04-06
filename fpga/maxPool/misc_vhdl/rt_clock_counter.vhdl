library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rt_clock_counter is

	port (
			clk, reset: in std_logic;
			one_hz_rt_clock: in std_logic_vector(0 downto 0);
			count_value : out std_logic_vector(31 downto 0)
		);

end entity rt_clock_counter;


architecture Behave of rt_clock_counter is

	signal counter : integer;
	signal last_one_hz_rt_clock, one_hz_rt_clock_synch: std_logic_vector(0 downto 0);
	signal rt_rising, rt_falling: boolean;
	type FsmState is (IDLE, RT_HIGH, RT_LOW);
	signal fsm_state: FsmState;

begin
	process(clk, reset)
	begin
		if(clk'event and clk = '1') then
			one_hz_rt_clock_synch <= one_hz_rt_clock;
			last_one_hz_rt_clock  <= one_hz_rt_clock_synch;
		end if;
	end process;

	rt_rising  <= (one_hz_rt_clock_synch(0) = '1') and (last_one_hz_rt_clock(0) = '0');
	rt_falling <= (one_hz_rt_clock_synch(0) = '0') and (last_one_hz_rt_clock(0) = '1');

	-- counter
	process(clk, reset, fsm_state, counter, rt_rising, rt_falling)
		variable latch_counter_var: boolean;
		variable next_counter_var : integer;
		variable next_fsm_state_var : FsmState;
	begin
		latch_counter_var := false;
		next_counter_var  := counter;
		next_fsm_state_var := fsm_state;

		case fsm_state is 
			when IDLE => 
				if rt_rising then
					next_counter_var := 0;
					next_fsm_state_var := RT_HIGH;
				end if;
			when RT_HIGH =>
				next_counter_var := (counter + 1);
				if(rt_falling) then
					next_fsm_state_var := RT_LOW;
				end if;
			when RT_LOW =>
				if(rt_rising) then
					latch_counter_var := true;
					next_counter_var := 0;
					next_fsm_state_var := RT_HIGH;
				else
					next_counter_var := (counter + 1);
				end if;
		end case;

		if(clk'event and clk = '1') then
			if(reset = '1') then
				counter <= 0;
				count_value <= (others => '0');				
				fsm_state <= IDLE;
			else
				counter <= next_counter_var;
				fsm_state <= next_fsm_state_var;

				if(latch_counter_var) then
					count_value <= std_logic_vector(to_unsigned(counter, 32));
				end if;

			end if;
		end if;
	end process;

end Behave; 
