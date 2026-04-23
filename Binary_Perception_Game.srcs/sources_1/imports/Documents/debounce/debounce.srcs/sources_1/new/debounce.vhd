----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2026 06:02:24 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_press : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal s_cnt : unsigned(16 downto 0) := (others => '0');
    signal s_sync : std_logic_vector(1 downto 0);
    signal s_debounced : std_logic;
    signal s_prev : std_logic;
begin
    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                s_sync <= "00"; s_cnt <= (others => '0'); s_debounced <= '0'; s_prev <= '0';
            else
                s_sync <= s_sync(0) & btn_in;
                if s_cnt = 100000 - 1 then -- cca 1ms vzorkování
                    s_debounced <= s_sync(1);
                    s_cnt <= (others => '0');
                else s_cnt <= s_cnt + 1; end if;
                s_prev <= s_debounced;
            end if;
        end if;
    end process;
    btn_press <= s_debounced and not s_prev;
end Behavioral;