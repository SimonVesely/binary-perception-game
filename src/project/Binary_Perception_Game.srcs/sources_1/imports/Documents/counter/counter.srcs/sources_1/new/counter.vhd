-------------------------------------------------
--! @brief N-bit synchronous up counter with enable
--! @version 1.4
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This design implements a parameterizable N-bit
--! binary up counter with synchronous, high-active
--! reset and clock enable input. The counter wraps
--! around to zero after reaching its maximum value
--! (2^G_BITS - 1).
--
-- Notes:
-- - Synchronous design (rising edge of clk)
-- - High-active synchronous reset
-- - Enable input controls counting
-- - Modulo 2^N operation (automatic wrap-around)
-- - Integer-based internal counter
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Package for data types conversion

-------------------------------------------------

entity counter is
    port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(7 downto 0)  --! Counter value
    );
end entity counter;

-------------------------------------------------

architecture Behavioral of counter is

    signal sig_cnt : unsigned(7 downto 0) := (others =>'0');

begin
    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then 
                sig_cnt <= (others => '0');

            elsif en = '1' then 
                    sig_cnt <= sig_cnt + 1;
            end if;
        end if;
    end process p_counter;

    -- Convert integer to std_logic_vector
    cnt <= std_logic_vector(sig_cnt);

end Behavioral;