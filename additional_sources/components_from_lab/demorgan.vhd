library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demorgan is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           f_org : out STD_LOGIC;
           f_nand : out STD_LOGIC;
           f_nor : out STD_LOGIC);
end demorgan;

architecture Behavioral of demorgan is

begin

    -- f-org = A+(nB * C)
    f_org <= a or ((not b) and c);
    f_nand <= not( (not a) and (not((not b) and c)));
    f_nor <= a or (not ( b or (not c)));

end Behavioral;
