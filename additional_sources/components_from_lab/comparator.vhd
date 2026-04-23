library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
           b : in STD_LOGIC_VECTOR (1 downto 0);
           b_gt : out STD_LOGIC;
           b_gt_k_map : out std_logic;
           b_a_eq : out STD_LOGIC;
           b_a_eq_k_map : out std_logic;
           a_gt : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is
begin

    b_gt   <= '1' when (b > a) else
            '0';
            
    
    b_gt_k_map <= (not(a(1)) and not(a(0)) and b(0)) or (not(a(1)) and  b(1)) or (not(a(0)) and b(1) and b(0));
    
    
    b_a_eq <= '1' when (b = a) else
            '0';
            
    b_a_eq_k_map <= (not(a(1)) and not(a(0)) and not(b(1)) and not(b(0))) or (not(a(1)) and (a(0)) and not(b(1)) and (b(0))) or ((a(1)) and not(a(0)) and (b(1)) and not(b(0))) or ((a(1)) and (a(0)) and (b(1)) and (b(0)));
    
    a_gt   <= '1' when (b < a) else
            '0';

end Behavioral;
