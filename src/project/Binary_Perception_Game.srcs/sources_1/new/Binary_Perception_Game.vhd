library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Binary_Perception_Game_Top is
    Port ( clk : in STD_LOGIC;
           btnc : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end Binary_Perception_Game_Top;

architecture Behavioral of Binary_Perception_Game_Top is

begin


end Behavioral;
