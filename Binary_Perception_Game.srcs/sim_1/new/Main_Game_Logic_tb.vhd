-- This testbench was created using the online tool: https://vhdl.lapinoo.net/
-- We created a stimulus process to test all possible outcomes.

library ieee;
use ieee.std_logic_1164.all;

entity tb_Main_Game_logic is
end tb_Main_Game_logic;

architecture tb of tb_Main_Game_logic is

    component Main_Game_logic
        port (
              clk        : in std_logic;
              rst        : in std_logic;
              ce_1ms     : in std_logic;
              btn_start  : in std_logic;
              match      : in std_logic;
              target_en  : out std_logic;
              show_time  : out std_logic;
              time_bcd_h : out std_logic_vector (3 downto 0);
              time_bcd_t : out std_logic_vector (3 downto 0);
              time_bcd_u : out std_logic_vector (3 downto 0)
        );
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal ce_1ms     : std_logic;
    signal btn_start  : std_logic;
    signal match      : std_logic;
    signal target_en  : std_logic;
    signal show_time  : std_logic;
    signal time_bcd_h : std_logic_vector (3 downto 0);
    signal time_bcd_t : std_logic_vector (3 downto 0);
    signal time_bcd_u : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Main_Game_logic
    port map (
        clk        => clk,
        rst        => rst,
        ce_1ms     => ce_1ms,
        btn_start  => btn_start,
        match      => match,
        target_en  => target_en,
        show_time  => show_time,
        time_bcd_h => time_bcd_h,
        time_bcd_t => time_bcd_t,
        time_bcd_u => time_bcd_u
    );

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

   p_stimuli : process
begin
    -- --- 1. Initialization and reset ---
    rst <= '1';
    btn_start <= '0';
    match <= '0';
    wait for 50 ns;
    rst <= '0';
    wait for 20 ns;
    -- --- NOW SHOULD BE IDLE ---

    -- --- 2. START ---
    btn_start <= '1';
    wait for 10 ns; 
    btn_start <= '0';
    wait for 10 ns;
    
    -- --- 3. TIMER ---
    for i in 1 to 3 loop
        for j in 1 to 100 loop
            ce_1ms <= '1';
            wait for 10 ns;
            ce_1ms <= '0';
            wait for 40 ns; 
        end loop;
    end loop;

    -- --- 4. WIN ---
    match <= '1';
    wait for 20 ns;
    match <= '0'; 
    
    -- --- 5. RETURN TO IDLE ---
    wait for 100 ns;
    btn_start <= '1'; 
    wait for 10 ns;
    btn_start <= '0';
    
    wait for 100 ns;
end process;

end tb;

configuration cfg_tb_Main_Game_logic of tb_Main_Game_logic is
    for tb
    end for;
end cfg_tb_Main_Game_logic;
