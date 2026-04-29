-- TOP OF OUR PROJECT
-- This module is connecting all of our components


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Binary_Perception_Game_Top is
    Port (
        clk : in  STD_LOGIC;                        
        rst: in  STD_LOGIC;                        
        btnc       : in  STD_LOGIC;                       
        btnr       : in  STD_LOGIC;                        
        sw         : in  STD_LOGIC_VECTOR (7 downto 0);    
        led        : out STD_LOGIC_VECTOR (7 downto 0);   
        seg : out STD_LOGIC_VECTOR (6 downto 0);      
        dp         : out STD_LOGIC;                        
        an         : out STD_LOGIC_VECTOR (7 downto 0);    
        led16_r : out STD_LOGIC;
        led16_g : out STD_LOGIC;
        led16_b : out STD_LOGIC;
        led17_r : out STD_LOGIC;
        led17_g : out STD_LOGIC;
        led17_b : out STD_LOGIC
    );
end Binary_Perception_Game_Top;

architecture Behavioral of Binary_Perception_Game_Top is

    component clk_en
        Port ( 
            clk : in STD_LOGIC; 
            rst : in STD_LOGIC; 
            ce_1ms : out STD_LOGIC 
        );
    end component;

    component debounce
        Port ( 
            clk : in STD_LOGIC; 
            rst : in STD_LOGIC; 
            btn_in : in STD_LOGIC; 
            btn_press : out STD_LOGIC 
        );
    end component;

    component counter
        Port ( 
            clk : in STD_LOGIC; 
            rst : in STD_LOGIC; 
            cnt_out : out STD_LOGIC_VECTOR (7 downto 0) 
        );
    end component;






    component Main_Game_logic
        Port ( 
            clk, rst, ce_1ms, btn_start, match : in STD_LOGIC;
            target_en : out STD_LOGIC;
            show_time : out STD_LOGIC;
            time_bcd_h, time_bcd_t, time_bcd_u : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component bin_2_bcd
        Port ( 
            bin_in : in STD_LOGIC_VECTOR (7 downto 0); 
            hun, ten, uni : out STD_LOGIC_VECTOR (3 downto 0) 
        );
    end component;

    component bin_2_seg
        Port ( 
             bin_in : in STD_LOGIC_VECTOR (3 downto 0); 
             seg_out : out STD_LOGIC_VECTOR (6 downto 0) 
        );
    end component;

    component Multiplexor
        Port (
            clk, ce_1ms, show_time : in STD_LOGIC;
            user_u, user_t, user_h : in STD_LOGIC_VECTOR(3 downto 0); 
            left_u, left_t, left_h : in STD_LOGIC_VECTOR(3 downto 0); 
            an : out STD_LOGIC_VECTOR(7 downto 0);
            mux_out : out STD_LOGIC_VECTOR(3 downto 0);
            dp : out STD_LOGIC
        );
    end component;


  -- System signals 
  signal s_rst : std_logic;
  signal s_ce_1ms : std_logic;
  signal s_btn_start : std_logic;
  signal s_target_num : std_logic_vector(7 downto 0);
  signal s_current_target : std_logic_vector(7 downto 0);
  signal s_target_en : std_logic;
  signal s_match : std_logic;
  signal s_show_time : std_logic;
  
  -- BCD timer
  signal s_time_h, s_time_t, s_time_u : std_logic_vector(3 downto 0);
  signal s_target_h, s_target_t, s_target_u : std_logic_vector(3 downto 0);
  signal s_mux_data : std_logic_vector(3 downto 0);
  signal s_seg_line : std_logic_vector(6 downto 0);
  
  -- BCD switch input
  signal s_sw_h, s_sw_t, s_sw_u : std_logic_vector(3 downto 0);
  signal s_mux_h, s_mux_t, s_mux_u : std_logic_vector(3 downto 0);

  -- RGB led signal
  signal s_in_run : std_logic := '0';


begin
    -- Inverting Nexys default reset
    s_rst <= not rst or btnr;
    led <= sw; -- Led for active switches

    -- Comparing generated value with current input from user
    s_match <= '1' when (sw = s_current_target) else '0';
    
    -- Timer value on background
    s_mux_h <= s_time_h when (s_show_time = '1') else s_sw_h;
    s_mux_t <= s_time_t when (s_show_time = '1') else s_sw_t;
    s_mux_u <= s_time_u when (s_show_time = '1') else s_sw_u;

    -- Register for random generated value from pseudo-counter
    process(clk)
    begin
        if rising_edge(clk) then
            if s_rst = '1' then
                s_current_target <= (others => '0');
            elsif s_target_en = '1' then
                s_current_target <= not s_target_num(3 downto 0) & s_target_num(7 downto 4);
            end if;
        end if;
    end process;

    -- RGB led process
    process(clk)
    begin
        if rising_edge(clk) then
            if s_rst = '1' then
                s_in_run <= '0';
            elsif s_target_en = '1' then   
                s_in_run <= '1';
            elsif s_show_time = '1' then  
                s_in_run <= '0';
            end if;
        end if;
    end process;

    led16_r <= '0' when s_in_run    = '1' else '1';
    led16_g <= '0' when s_show_time = '1' else '1';
    led16_b <= '1' when (s_in_run = '1' or s_show_time = '1') else '0';

    led17_r <= led16_r;
    led17_g <= led16_g;
    led17_b <= led16_b;






    Inst_Clock: clk_en port map ( 
        clk => clk, 
        rst => s_rst, 
        ce_1ms => s_ce_1ms 
    );

    Inst_Debounce: debounce port map ( 
        clk => clk, rst => s_rst, 
        btn_in => btnc, 
        btn_press => s_btn_start 
    );

    Inst_Random: counter port map ( 
        clk => clk, 
        rst => s_rst, 
        cnt_out => s_target_num 
    );










    Inst_Game: Main_Game_logic port map (
        clk => clk, 
        rst => s_rst, 
        ce_1ms => s_ce_1ms, 
        btn_start => s_btn_start,
        match => s_match, 
        target_en => s_target_en, 
        show_time => s_show_time,
        time_bcd_h => s_time_h, 
        time_bcd_t => s_time_t, 
        time_bcd_u => s_time_u
    );

    Inst_Bin2BCD_Target: bin_2_bcd port map (
        bin_in => s_current_target, 
        hun => s_target_h, 
        ten => s_target_t, 
        uni => s_target_u
    );

    Inst_Seg: bin_2_seg port map ( 
        bin_in => s_mux_data, 
        seg_out => s_seg_line 
    );
    
    Inst_BIN2BCD_SW: bin_2_bcd port map (
        bin_in => sw,
        hun => s_sw_h,
        ten => s_sw_t,
        uni => s_sw_u
    );
    Inst_Mux: Multiplexor port map (
        clk => clk, 
        ce_1ms => s_ce_1ms, 
        show_time => s_show_time,
        user_u => s_mux_u, 
        user_t => s_mux_t, 
        user_h => s_mux_h,
        left_u => s_target_u, 
        left_t => s_target_t, 
        left_h => s_target_h,
        an => an, 
        mux_out => s_mux_data, 
        dp => dp
    );

    -- Segment mapping
    seg <= s_seg_line;

end Behavioral;
