-- This testbench was created using the online tool: https://vhdl.lapinoo.net/
-- We created a stimulus process to test all possible outcomes.

library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (
              clk       : in std_logic;
              rst       : in std_logic;
              btn_in    : in std_logic;
              btn_press : out std_logic
        );
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal btn_in    : std_logic;
    signal btn_press : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce
    port map (clk       => clk,
              rst       => rst,
              btn_in    => btn_in,
              btn_press => btn_press);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

   p_stimuli : process
begin
    -- --- 1. INICIALIZATION ---
    rst <= '1';
    btn_in <= '0';
    wait for 50 ns;
    rst <= '0';
    wait for 50 ns;

    -- --- 2. SIM OF BOUNCY PRESS ---
    btn_in <= '1'; wait for 20 us; 
    btn_in <= '0'; wait for 15 us; 
    btn_in <= '1'; wait for 25 us;
    btn_in <= '0'; wait for 10 us; 
    
    -- --- 3. STABLE PRESS ---
    btn_in <= '1'; 
    wait for 2 ms; 
    
    -- --- 4. SIM ---
    btn_in <= '0'; wait for 15 us;
    btn_in <= '1'; wait for 10 us;
    btn_in <= '0'; wait for 20 us;
    btn_in <= '1'; wait for 5 us;
    btn_in <= '0'; 
    
    wait for 2 ms;

end process;

end tb;

configuration cfg_tb_debounce of tb_debounce is
    for tb
    end for;
end cfg_tb_debounce;
