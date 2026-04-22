library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Multiplexor is
    Port ( clk : in STD_LOGIC;
           ce_1ms : in STD_LOGIC;
           show_time : in STD_LOGIC;
           user_u : in STD_LOGIC_VECTOR (3 downto 0);
           user_t : in STD_LOGIC_VECTOR (3 downto 0);
           user_h : in STD_LOGIC_VECTOR (3 downto 0);
           left_u : in STD_LOGIC_VECTOR (3 downto 0);
           left_t : in STD_LOGIC_VECTOR (3 downto 0);
           left_h : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           mux_out : out STD_LOGIC_VECTOR (3 downto 0);
           dp: out std_logic);
end Multiplexor;

architecture Behavioral of Multiplexor is
     signal cnt : unsigned(2 downto 0) := "000";
begin
    process(clk) begin
        if rising_edge(clk) then
            if ce_1ms = '1' then cnt <= cnt + 1; end if;
        end if;
    end process;

    process(cnt, user_u, user_t, user_h, left_u, left_t, left_h, show_time)
     begin
        an <= (others => '1'); mux_out <= "1111"; dp <= '1';
        case cnt is
            when "000" => an <= "11111110"; mux_out <= user_u;
            when "001" => an <= "11111101"; mux_out <= user_t;
            when "010" => an <= "11111011"; mux_out <= user_h;
            when "101" => an <= "11011111"; mux_out <= left_u;
            when "110" => an <= "10111111"; mux_out <= left_t; if show_time = '1' then dp <= '0'; end if;
            when "111" => an <= "01111111"; mux_out <= left_h;
            when others => null;
        end case;
    end process;
end Behavioral;
