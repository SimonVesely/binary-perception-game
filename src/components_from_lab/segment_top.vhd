library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity segment_top is
    Port ( sw : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0));
end segment_top;

architecture Behavioral of segment_top is

    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    display : bin2seg
        port map (
            bin => sw,
            seg => seg
        );

    -- Turn off decimal point (inactive = '1')
    dp <= '1';

    -- Enable only the rightmost digit (AN0 active-low)
    an <= b"1111_1110";

end Behavioral;
