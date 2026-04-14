----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2026 07:19:10 PM
-- Design Name: 
-- Module Name: State_Machine_Logic - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity State_Machine_Logic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_start : in STD_LOGIC;
           match : in STD_LOGIC;
           timer_en : out STD_LOGIC;
           timer_rst : out STD_LOGIC;
           target_en : out STD_LOGIC;
           show_time : out STD_LOGIC);
end State_Machine_Logic;

architecture Behavioral of State_Machine_Logic is
type t_state is (IDLE, GENERAT, RUNNING, FINISHED);
signal current_state : t_state := IDLE;
begin

p_fsm : process(clk)
begin 
     if rising_edge(clk) then 
       if rst = '1' then 
          current_state <= IDLE; 
       else
        case current_state is 
       
        when IDLE =>
           if btn_start = '1' then 
            current_state <= GENERAT;
           end if;
            
        when GENERAT => 
            current_state <= RUNNING;
        
        when RUNNING =>
            if match = '1' then
                current_state <= FINISHED;
            end if; 
            
        when FINISHED => 
            if btn_start = '1' then 
                current_state <= IDLE; 
                end if; 
                
        when others =>
        current_state <= IDLE;
        end case;
      end if;
    end if;
end process;
timer_en <= '1' when (current_state = RUNNING) else '0';
timer_rst <= '1' when (current_state = GENERAT) else '0';
target_en <= '1' when (current_state = GENERAT) else '0';
show_time <= '1' when (current_state = FINISHED) else '0';

end Behavioral;
