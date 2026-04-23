library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity counter is
    port (
        clk : in  std_logic;                           
        rst : in  std_logic;                             
        cnt_out : out std_logic_vector(7 downto 0) 
    );
end entity counter;

-------------------------------------------------

architecture Behavioral of counter is

 signal s_cnt : unsigned(7 downto 0) := (others => '0');
 signal s_reg : std_logic_vector(7 downto 0) := "10101011";
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                s_reg <= "10101011";
            else
                s_reg <= s_reg(6 downto 0) & (s_reg(7) xor s_reg(5) xor s_reg(4) xor s_reg(3));
            end if;
        end if;
    end process;
    cnt_out <= s_reg;
end Behavioral;