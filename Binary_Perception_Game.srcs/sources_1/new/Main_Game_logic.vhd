library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Main_Game_logic is
 port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        ce_1ms     : in  std_logic;
        btn_start  : in  std_logic;
        match      : in  std_logic;
        target_en  : out std_logic;
        show_time  : out std_logic;
        time_bcd_h : out std_logic_vector(3 downto 0);
        time_bcd_t : out std_logic_vector(3 downto 0);
        time_bcd_u : out std_logic_vector(3 downto 0)
    );
end Main_Game_logic;

architecture Behavioral of Main_Game_logic is
 type t_state is (S_IDLE, S_GEN, S_RUN, S_WIN);
    signal state : t_state := S_IDLE;
    signal s_timer : unsigned(9 downto 0) := (others => '0');
    signal s_ms_divider : integer range 0 to 99 := 0;
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S_IDLE; s_timer <= (others => '0'); s_ms_divider <= 0;
            else
                case state is
                    when S_IDLE =>
                        s_timer <= (others => '0'); s_ms_divider <= 0;
                        if btn_start = '1' then state <= S_GEN; end if;
                    when S_GEN => state <= S_RUN;
                    when S_RUN =>
                        if ce_1ms = '1' then
                            if s_ms_divider = 99 then
                                s_ms_divider <= 0;
                                if s_timer < 999 then s_timer <= s_timer + 1; end if;
                            else s_ms_divider <= s_ms_divider + 1;
                            end if;
                        end if;
                        if match = '1' then state <= S_WIN; end if;
                    when S_WIN =>
                        if btn_start = '1' then state <= S_IDLE; end if;
                end case;
            end if;
        end if;
    end process;

    target_en <= '1' when state = S_GEN else '0';
    show_time <= '1' when state = S_WIN else '0';

    process(s_timer)
        variable t : integer;
    begin
        t := to_integer(s_timer);
        time_bcd_h <= std_logic_vector(to_unsigned(t / 100, 4));
        time_bcd_t <= std_logic_vector(to_unsigned((t rem 100) / 10, 4));
        time_bcd_u <= std_logic_vector(to_unsigned(t rem 10, 4));
    end process;
end Behavioral;