library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.numeric_std.ALL;

entity clk_en is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce_1ms : out STD_LOGIC);
end clk_en;

architecture Behavioral of clk_en is
signal s_cnt : unsigned(16 downto 0) := (others => '0');
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt <= (others => '0'); ce_1ms <= '0';
            else
                ce_1ms <= '0';
                if s_cnt = 100000 - 1 then
                    s_cnt <= (others => '0'); ce_1ms <= '1';
                else
                    s_cnt <= s_cnt + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
