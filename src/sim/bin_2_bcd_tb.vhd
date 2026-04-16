library ieee;
use ieee.std_logic_1164.all;

entity tb_bin_2_bcd is
end tb_bin_2_bcd;

architecture tb of tb_bin_2_bcd is

    component bin_2_bcd
        port (bin_in : in std_logic_vector (7 downto 0);
              hun    : out std_logic_vector (3 downto 0);
              ten    : out std_logic_vector (3 downto 0);
              uni    : out std_logic_vector (3 downto 0));
    end component;

    signal bin_in : std_logic_vector (7 downto 0);
    signal hun    : std_logic_vector (3 downto 0);
    signal ten    : std_logic_vector (3 downto 0);
    signal uni    : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : bin_2_bcd
    port map (bin_in => bin_in,
              hun    => hun,
              ten    => ten,
              uni    => uni);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin

        bin_in <= "00000000";  -- 0
        wait for TbPeriod;

        bin_in <= "00000001";  -- 1
        wait for TbPeriod;

        bin_in <= "00001001";  -- 9
        wait for TbPeriod;

        bin_in <= "00001010";  -- 10
        wait for TbPeriod;

        bin_in <= "00010000";  -- 16
        wait for TbPeriod;

        bin_in <= "00011001";  -- 25
        wait for TbPeriod;

        bin_in <= "00110010";  -- 50
        wait for TbPeriod;

        bin_in <= "01100100";  -- 100
        wait for TbPeriod;

        bin_in <= "01100101";  -- 101
        wait for TbPeriod;

        bin_in <= "10011000";  -- 152
        wait for TbPeriod;

        bin_in <= "11111111";  -- 255 (maximum)
        wait for TbPeriod;

        -- Additional edge cases
        bin_in <= "00000000";  -- 0 again
        wait for TbPeriod;

        bin_in <= "01100100";  -- 100 (boundary)
        wait for TbPeriod;

        bin_in <= "11000111";  -- 199
        wait for TbPeriod;

        bin_in <= "11111110";  -- 254
        wait for TbPeriod;

        -- Test invalid / unknown inputs
        bin_in <= "UUUUUUUU";
        wait for TbPeriod;

        bin_in <= "XXXXXXXX";
        wait for TbPeriod;

    end process;

end tb;

configuration cfg_tb_bin_2_bcd of tb_bin_2_bcd is
    for tb
    end for;
end cfg_tb_bin_2_bcd;
