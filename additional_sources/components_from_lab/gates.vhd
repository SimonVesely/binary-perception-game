library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gates is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y_and : out STD_LOGIC;
           y_or : out STD_LOGIC;
           y_xor : out STD_LOGIC);
end gates;

architecture Behavioral of gates is

begin
    
    y_and <= a and b;
    y_or <= a or b;
    y_xor <= a xor b;


end Behavioral;
