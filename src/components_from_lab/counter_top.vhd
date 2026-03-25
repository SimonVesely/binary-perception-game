library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (7 downto 0));
end counter_top;

architecture Behavioral of counter_top is
    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

    
    component counter is
       generic ( G_BITS : positive := 8 );
       port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
    );
    end component counter;

    -- Internal signal for counter
    signal sig_en_10ms : std_logic;

begin

    -- Component instantiation of clock enable for 10 ms
    clock_0 : clk_en
        generic map ( G_MAX => 1_000_000 )
        port map (
            clk => clk,
            rst => btnu,
            ce  => sig_en_10ms
        );

    -- Component instantiation of 8-bit binary counter
    counter_0 : counter
        generic map ( G_BITS =>  8 )
        port map (
            clk => clk,                             
            rst => btnu,                             
            en  => sig_en_10ms,                             
            cnt => led
        );


end Behavioral;
