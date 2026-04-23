-- This testbench was created using the online tool: https://vhdl.lapinoo.net/
-- We created a stimulus process to test all possible outcomes.

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    component counter
        port (
              clk     : in std_logic;
              rst     : in std_logic;
              cnt_out : out std_logic_vector (7 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal cnt_out : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter
    port map (clk     => clk,
              rst     => rst,
              cnt_out => cnt_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_counter of tb_counter is
    for tb
    end for;
end cfg_tb_counter;
