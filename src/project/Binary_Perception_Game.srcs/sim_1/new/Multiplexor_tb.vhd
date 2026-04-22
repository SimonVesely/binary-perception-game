library ieee;
use ieee.std_logic_1164.all;

entity tb_Multiplexor is
end tb_Multiplexor;

architecture tb of tb_Multiplexor is

    component Multiplexor
        port (clk       : in std_logic;
              ce_1ms    : in std_logic;
              show_time : in std_logic;
              user_u    : in std_logic_vector (3 downto 0);
              user_t    : in std_logic_vector (3 downto 0);
              user_h    : in std_logic_vector (3 downto 0);
              left_u    : in std_logic_vector (3 downto 0);
              left_t    : in std_logic_vector (3 downto 0);
              left_h    : in std_logic_vector (3 downto 0);
              an        : out std_logic_vector (7 downto 0);
              mux_out   : out std_logic_vector (3 downto 0);
              dp        : out std_logic);
    end component;

    signal clk       : std_logic;
    signal ce_1ms    : std_logic;
    signal show_time : std_logic;
    signal user_u    : std_logic_vector (3 downto 0);
    signal user_t    : std_logic_vector (3 downto 0);
    signal user_h    : std_logic_vector (3 downto 0);
    signal left_u    : std_logic_vector (3 downto 0);
    signal left_t    : std_logic_vector (3 downto 0);
    signal left_h    : std_logic_vector (3 downto 0);
    signal an        : std_logic_vector (7 downto 0);
    signal mux_out   : std_logic_vector (3 downto 0);
    signal dp        : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Multiplexor
    port map (clk       => clk,
              ce_1ms    => ce_1ms,
              show_time => show_time,
              user_u    => user_u,
              user_t    => user_t,
              user_h    => user_h,
              left_u    => left_u,
              left_t    => left_t,
              left_h    => left_h,
              an        => an,
              mux_out   => mux_out,
              dp        => dp);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        -- Initialize input values (example: User = 163, Left = 245)
        user_u  <= "0011";   -- user units   = 3
        user_t  <= "0110";   -- user tens    = 6
        user_h  <= "0001";   -- user hundreds= 1
        left_u  <= "0101";   -- left units   = 5
        left_t  <= "0100";   -- left tens    = 4
        left_h  <= "0010";   -- left hundreds= 2
        show_time <= '0';    -- decimal point off

        ce_1ms <= '0';       -- disable counter at start

        wait for 20 ns;

        -------------------------------------------------
        -- Test 1: Normal operation - enable 1ms clock enable
        -------------------------------------------------
        ce_1ms <= '1';
        show_time <= '0';
        wait for 30 * TbPeriod;     

        -------------------------------------------------
        -- Test 2: Enable decimal point (show_time = '1')
        -------------------------------------------------
        show_time <= '1';
        wait for 30 * TbPeriod;

        -------------------------------------------------
        -- Test 3: Disable counter (ce_1ms = '0') - should freeze position
        -------------------------------------------------
        ce_1ms <= '0';
        wait for 20 * TbPeriod;

        -------------------------------------------------
        -- Test 4: Change input data while running
        -------------------------------------------------
        ce_1ms <= '1';
        user_u  <= "1001";   -- change user units to 9
        user_h  <= "1001";   -- change user hundreds to 9
        left_t  <= "0000";   -- change left tens to 0
        wait for 30 * TbPeriod;

        -------------------------------------------------
        -- Test 5: Disable decimal point again
        -------------------------------------------------
        show_time <= '0';
        wait for 25 * TbPeriod;

        -------------------------------------------------
        -- Test 6: Invalid / unknown input values
        -------------------------------------------------
        user_u  <= "XXXX";
        left_h  <= "UUUU";
        wait for 15 * TbPeriod;

    end process;

end tb;

configuration cfg_tb_Multiplexor of tb_Multiplexor is
    for tb
    end for;
end cfg_tb_Multiplexor;
