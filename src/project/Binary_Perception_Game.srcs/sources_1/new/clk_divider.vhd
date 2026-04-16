library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity clk_divider is
    generic (
        G_MAX_1MS   : positive := 100_000;
        G_MAX_100MS : positive := 10_000_000
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        tick_1ms     : out std_logic;
        tick_100ms   : out std_logic
    );
end entity clk_divider;

architecture Behavioral of clk_divider is
    signal s_cnt_1ms   : unsigned(16 downto 0) := (others => '0');
    signal s_cnt_100ms : unsigned(23 downto 0) := (others => '0');
begin
    p_clk_divider : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt_1ms   <= (others => '0');
                s_cnt_100ms <= (others => '0');
                tick_1ms     <= '0';
                tick_100ms   <= '0';
            else
                -- Generování 1ms pulzu
                tick_1ms <= '0';
                if s_cnt_1ms = G_MAX_1MS - 1 then
                    s_cnt_1ms <= (others => '0');
                    tick_1ms <= '1';
                else
                    s_cnt_1ms <= s_cnt_1ms + 1;
                end if;

                -- Generování 100ms pulzu
                tick_100ms <= '0';
                if s_cnt_100ms = G_MAX_100MS - 1 then
                    s_cnt_100ms <= (others => '0');
                    tick_100ms <= '1';
                else
                    s_cnt_100ms <= s_cnt_100ms + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
