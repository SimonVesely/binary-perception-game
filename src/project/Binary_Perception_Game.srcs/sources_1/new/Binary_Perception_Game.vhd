library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Binary_Perception_Game_Top is
    Port (
        CLK100MHZ : in  STD_LOGIC;                         
        CPU_RESETN : in  STD_LOGIC;                       
        BTNC       : in  STD_LOGIC;                        
        BTNR       : in  STD_LOGIC;                      
        SW         : in  STD_LOGIC_VECTOR (7 downto 0); 
        LED        : out STD_LOGIC_VECTOR (7 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;   
        DP         : out STD_LOGIC;                        
        AN         : out STD_LOGIC_VECTOR (7 downto 0)     
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

    component bin_2_seg
        Port ( 
               bin_in : in STD_LOGIC_VECTOR (3 downto 0); 
               seg_out : out STD_LOGIC_VECTOR (6 downto 0) 
             );
    end component;

    signal s_rst : std_logic;
    signal s_ce_1ms : std_logic;
    signal s_btn_start : std_logic;
    signal s_target_num : std_logic_vector(7 downto 0);
    signal s_current_target : std_logic_vector(7 downto 0);
    signal s_target_en : std_logic;
    signal s_match : std_logic;
    signal s_show_time : std_logic;
    
    signal s_time_h, s_time_t, s_time_u : std_logic_vector(3 downto 0);
    signal s_target_h, s_target_t, s_target_u : std_logic_vector(3 downto 0);
    signal s_mux_data : std_logic_vector(3 downto 0);
    signal s_seg_line : std_logic_vector(6 downto 0);

begin
    s_rst <= not CPU_RESETN or BTNR;
    LED <= SW; 

    s_match <= '1' when (SW = s_current_target) else '0';

    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if s_rst = '1' then
                s_current_target <= (others => '0');
            elsif s_target_en = '1' then
                s_current_target <= s_target_num;
            end if;
        end if;
    end process;

    Inst_Clock: clk_en port map ( 
                                  clk => CLK100MHZ, 
                                  rst => s_rst, ce_1ms => s_ce_1ms 
                                );

    Inst_Debounce: debounce port map ( 
                                       clk => CLK100MHZ, 
                                       rst => s_rst, 
                                       btn_in => BTNC, 
                                       btn_press => s_btn_start 
                                     );

    Inst_Random: counter port map ( 
                                    clk => CLK100MHZ, 
                                    rst => s_rst, 
                                    cnt_out => s_target_num 
                                  );

    Inst_Game: Main_Game_logic port map (
        clk => CLK100MHZ, 
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
        bin_in => s_current_target, hun => s_target_h, ten => s_target_t, uni => s_target_u
    );

    Inst_Mux: Multiplexor port map (
        clk => CLK100MHZ, 
        ce_1ms => s_ce_1ms, 
        show_time => s_show_time,
        user_u => s_time_u, 
        user_t => s_time_t, 
        user_h => s_time_h,
        left_u => s_target_u, 
        left_t => s_target_t, 
        left_h => s_target_h,
        an => AN, 
        mux_out => s_mux_data, 
        dp => DP
    );

    Inst_Seg: bin_2_seg port map ( 
                                   bin_in => s_mux_data, 
                                   seg_out => s_seg_line 
                                 );

    (CA, CB, CC, CD, CE, CF, CG) <= s_seg_line;

end Behavioral;
