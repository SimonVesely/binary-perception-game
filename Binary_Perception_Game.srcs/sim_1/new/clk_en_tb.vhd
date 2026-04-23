-- This testbench was created using the online tool: https://vhdl.lapinoo.net/
-- We created a stimulus process to test all possible outcomes.

library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        port (
              clk    : in std_logic;
              rst    : in std_logic;
              ce_1ms : out std_logic
        );
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal ce_1ms : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clk_en
    port map (clk    => clk,
              rst    => rst,
              ce_1ms => ce_1ms);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    p_stimuli : process
begin
    rst <= '1';
    wait for 50 ns;
    rst <= '0';
    wait for TbPeriod;

    wait for 1 ms; 
    
end process;
end tb;

configuration cfg_tb_clk_en of tb_clk_en is
    for tb
    end for;
end cfg_tb_clk_en;
