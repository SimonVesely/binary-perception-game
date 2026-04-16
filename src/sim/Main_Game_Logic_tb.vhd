library ieee;
use ieee.std_logic_1164.all;

entity tb_Main_Game_logic is
end tb_Main_Game_logic;

architecture tb of tb_Main_Game_logic is

    component Main_Game_logic
        port (clk        : in std_logic;
              rst        : in std_logic;
              ce_1ms     : in std_logic;
              btn_start  : in std_logic;
              match      : in std_logic;
              target_en  : out std_logic;
              show_time  : out std_logic;
              time_bcd_h : out std_logic_vector (3 downto 0);
              time_bcd_t : out std_logic_vector (3 downto 0);
              time_bcd_u : out std_logic_vector (3 downto 0));
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

    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Main_Game_logic
    port map (clk        => clk,
              rst        => rst,
              ce_1ms     => ce_1ms,
              btn_start  => btn_start,
              match      => match,
              target_en  => target_en,
              show_time  => show_time,
              time_bcd_h => time_bcd_h,
              time_bcd_t => time_bcd_t,
              time_bcd_u => time_bcd_u);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        -- Initial state
        rst       <= '1';
        ce_1ms    <= '0';
        btn_start <= '0';
        match     <= '0';
    
        -- Reset
        wait for 5 * TbPeriod;
        rst <= '0';
        wait for 2 * TbPeriod;
    
        -- Start game
        btn_start <= '1';
        wait for TbPeriod;
        btn_start <= '0';
    
        -- Wait for S_GEN -> S_RUN
        wait for 3 * TbPeriod;
    
        ----------------------------------------------------------------
        -- 1st pulse
        ----------------------------------------------------------------
        ce_1ms <= '1';
        wait for TbPeriod;
        ce_1ms <= '0';
        wait for TbPeriod;
    
        -- 2nd pulse
        ce_1ms <= '1';
        wait for TbPeriod;
        ce_1ms <= '0';
        wait for TbPeriod;
    
        -- 3rd pulse
        ce_1ms <= '1';
        wait for TbPeriod;
        ce_1ms <= '0';
        wait for TbPeriod;
    
        -- 4th pulse
        ce_1ms <= '1';
        wait for TbPeriod;
        ce_1ms <= '0';
        wait for TbPeriod;
    
        -- 5th pulse
        ce_1ms <= '1';
        wait for TbPeriod;
        ce_1ms <= '0';
        wait for TbPeriod;
    
        ----------------------------------------------------------------
        -- Match detected
        ----------------------------------------------------------------
        match <= '1';
        wait for TbPeriod;
        match <= '0';
    
        wait for 5 * TbPeriod;
    
        ----------------------------------------------------------------
        -- Restart from WIN state
        ----------------------------------------------------------------
        btn_start <= '1';
        wait for TbPeriod;
        btn_start <= '0';
    
        wait for 5 * TbPeriod;
    end process;

end tb;

configuration cfg_tb_Main_Game_logic of tb_Main_Game_logic is
    for tb
    end for;
end cfg_tb_Main_Game_logic;
