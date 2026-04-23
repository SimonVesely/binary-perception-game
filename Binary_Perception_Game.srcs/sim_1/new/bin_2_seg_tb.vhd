-- This testbench was created using the online tool: https://vhdl.lapinoo.net/
-- We created a stimulus process to test all possible outcomes.

library ieee;
use ieee.std_logic_1164.all;

entity tb_bin_2_seg is
end tb_bin_2_seg;

architecture tb of tb_bin_2_seg is

    component bin_2_seg
        port (
              bin_in  : in std_logic_vector (3 downto 0);
              seg_out : out std_logic_vector (6 downto 0)
        );
    end component;

    signal bin_in  : std_logic_vector (3 downto 0);
    signal seg_out : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : bin_2_seg
    port map (bin_in  => bin_in,
              seg_out => seg_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin

        bin_in <= "0000";  -- 0
        wait for TbPeriod;

        bin_in <= "0001";  -- 1
        wait for TbPeriod;

        bin_in <= "0010";  -- 2
        wait for TbPeriod;

        bin_in <= "0011";  -- 3
        wait for TbPeriod;

        bin_in <= "0100";  -- 4
        wait for TbPeriod;

        bin_in <= "0101";  -- 5
        wait for TbPeriod;

        bin_in <= "0110";  -- 6
        wait for TbPeriod;

        bin_in <= "0111";  -- 7
        wait for TbPeriod;

        bin_in <= "1000";  -- 8
        wait for TbPeriod;

        bin_in <= "1001";  -- 9
        wait for TbPeriod;

        bin_in <= "1010";  -- A
        wait for TbPeriod;

        bin_in <= "1011";  -- B
        wait for TbPeriod;

        bin_in <= "1100";  -- C
        wait for TbPeriod;

        bin_in <= "1101";  -- D
        wait for TbPeriod;

        bin_in <= "1110";  -- E
        wait for TbPeriod;

        bin_in <= "1111";  -- F
        wait for TbPeriod;

    end process;

end tb;


configuration cfg_tb_bin_2_seg of tb_bin_2_seg is
    for tb
    end for;
end cfg_tb_bin_2_seg;
