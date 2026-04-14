----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2026 06:08:27 PM
-- Design Name: 
-- Module Name: clk_divider - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tick_1ms : out STD_LOGIC;
           tick_10ms : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
signal cnt_1ms :  integer range 0 to 99999 := 0; 
signal cnt_10ms :  integer range 0 to 9 := 0;
begin
process(clk)
begin 
    if rising_edge(clk) then 
        if reset = '1' then 
            cnt_1ms <= 0; cnt_10ms <= 0; 
            tick_1ms <= '0'; tick_10ms <= '0';
        else
            if cnt_1ms = 99999 then 
               cnt_1ms <= 0; tick_1ms <= '1';
            if cnt_10ms = 9 then 
               cnt_10ms <= 0; tick_10ms <= '1';
            else 
               cnt_10ms <= cnt_10ms + 1; tick_10ms <= '0';
            end if;
          else 
              cnt_1ms <= cnt_1ms + 1; tick_1ms <= '0'; tick_10ms <= '0';
          end if;
        end if;
      end if;

end process; 
end Behavioral;
