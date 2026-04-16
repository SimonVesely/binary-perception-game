library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity bin_2_bcd is
    Port ( bin_in : in STD_LOGIC_VECTOR (7 downto 0);
           hun : out STD_LOGIC_VECTOR (3 downto 0);
           ten : out STD_LOGIC_VECTOR (3 downto 0);
           uni : out STD_LOGIC_VECTOR (3 downto 0));
end bin_2_bcd;

architecture Behavioral of bin_2_bcd is

begin
process(bin_in)
variable temp : integer;
begin

temp := to_integer(unsigned(bin_in));
    hun <= std_logic_vector(to_unsigned(temp / 100, 4));
    ten <= std_logic_vector(to_unsigned((temp rem 100) / 10, 4));
    uni <= std_logic_vector(to_unsigned(temp rem 10, 4));
    
end process;
end Behavioral;
