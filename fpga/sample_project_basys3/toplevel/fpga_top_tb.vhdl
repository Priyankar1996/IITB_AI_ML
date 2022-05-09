library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RtUart;
use RtUart.RtUartComponents.all;

entity fpga_top_tb is
end entity fpga_top_tb;

architecture tb of fpga_top_tb is

    signal Rx : std_logic := 'Z';
    signal Tx : std_logic;
    signal LED: std_logic_vector(7 downto 0);
    signal CLK100MHZ : std_logic := '0';
    signal btnC: std_logic := '0';
        
    component fpga_top is
    port(
        Rx : in std_logic;
        Tx : out std_logic;
        LED: out    std_logic_vector(7 downto 0);
        CLK100MHZ: in std_logic;
        btnC: in std_logic);
    end component;

begin 

    fpga_top_inst: fpga_top 
    port map(Rx => Rx,
            Tx => Tx,
            LED => LED,
            CLK100MHZ => CLK100MHZ,
            btnC => btnC);

    process(CLK100MHZ)
    variable i : integer := 0;
    begin
        if (i < 50000) then
        CLK100MHZ <= not CLK100MHZ after 5 ns;
        report "Clock switched";
        report std_logic'image(Rx) & " " & std_logic'image(Tx);
        report integer'image(to_integer(unsigned(LED)));
        i := i +1;
        end if;
        -- wait for 1 ns;  --for 0.5 ns signal is '0'.
        -- CLK100MHZ <= '1';
        -- wait for 1 ns;  --for next 0.5 ns signal is '1'.
   end process;

   process
   begin
        btnC <= '1';
        wait for 100 ns;
        btnc <= '0';
        wait for 100 ns;

        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '0'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '0'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '0'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= '1'; wait for 9 us;
        Rx <= 'Z'; wait;
   end process;
end tb;
